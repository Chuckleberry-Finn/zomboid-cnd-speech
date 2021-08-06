require "ConditionalSpeech___Util"

---@class ConditionalSpeech
ConditionalSpeech = {}

---@class ConditionalSpeech_Filter
ConditionalSpeech_Filter = {}

---@type table|table
ConditionalSpeech.Phrases = {}

---@type table|number
ConditionalSpeech.Speakers = {}

VolumeMAX = 30
DAWN_TIME = 6
DUSK_TIME = 22
NullColor = Color.new(1,1,1,1)

--- filters that shouldn't run if volume is 0
ConditionalSpeech.volumeSensitiveFilters = {"Stutter","Stammer"}

--- global paired list of mood types and corresponding filters
ConditionalSpeech.filterTable = {
	["Endurance"] = {"BlurtOut"},
	["Tired"] = {"BlurtOut"},
	["Panic"] = {"panicSwear","Stutter","BlurtOut","SCREAM"},
	["Bored"] = {"BlurtOut"},
	["Bleeding"] = {"BlurtOut"},
	["Angry"] = {"interlacedFucks","SCREAM"},
	["Pain"] = {"BlurtOut","SCREAM","interlacedFucks"},
	["Drunk"] = {"BlurtOut"},
	["Hypothermia"] = {"Stammer","BlurtOut"}
	--["Hungry"] = nil,
	--["Sick"] = nil,
	--["Unhappy"] = nil,
	--["Wet"] = nil,
	--["HasACold"] = nil,
	--["Stress"] = nil,
	--["Thirst"] = nil,
	--["Injured"] = nil,
	--["HeavyLoad"] = nil,
	--[Dead] = nil,
	--[Zombie] = nil,
	--"Hyperthermia"] = nil,
	--["Windchill"] = nil,
	--["FoodEaten"] = nil
}


--- Cleans up the dialogue and applies filters.
---@param player IsoGameCharacter
function ConditionalSpeech.bIsNPC(player)
	for playerIndex=0, getNumActivePlayers()-1 do
		---@type IsoLivingCharacter | IsoGameCharacter
		local playerObj = getSpecificPlayer(playerIndex)
		if playerObj and (playerObj == player) then
			return false
		end
	end
	return true
end


--- Retrieve MoodLevel Values and Set up MoodArray per player.
---@param player IsoLivingCharacter | IsoGameCharacter
function ConditionalSpeech.load_n_set_Moodles(player)
	if not player or player:isDead() then
		return
	end

	ConditionalSpeech.Speakers[player] = true

	local bIsNPC = ConditionalSpeech.bIsNPC(player)
	print("CND-SPEECH: load_n_set_Moodles: "..tostring(player:getFullName()).." (NPC:"..tostring(bIsNPC)..")")

	local moodles = player:getMoodles()

	player:getModData().cs_lastspoke = {[1]=getTimestamp(), [2]=""}
	player:getModData().moodleTable = {}

	--fetches moodles index num
	local moodNum = moodles:getNumMoodles()

	for i=0, moodNum-1 do
		--fetches mood type string based on index
		local moodType = moodles:getMoodleType(i)
		--fetches moodle level based on fetched type
		local foundlevel = moodles:getMoodleLevel(moodType)
		--creates a key value pair of type and found level
		player:getModData().moodleTable[tostring(moodType)] = foundlevel
	end
end



--- Handler for filters. Text passed through will have mood defined filters applied. Called from within ConditionalSpeech.Speech.
---@param player IsoGameCharacter
function ConditionalSpeech.passMoodleFilters(player,text)
	if not text or not player then
		return
	end

	--filtersToPass will be populated by pairs of filter type and mood levels
	local filtersToPass = {}
	--sortFilters will be populated by only the filter types as to sort based on volumeSensitiveFilters
	local sortFilters = {}

	--for each mood grab stored mood and lvl in player's moodle array
	for MoodID,lvl in pairs(player:getModData().moodleTable) do

		local moodleLevel = lvl
		local MoodID_filters = ConditionalSpeech.filterTable[MoodID]

		--check if mood should be processed
		if moodleLevel > 0 and MoodID_filters then

			--trackPos to maintain order through sorting
			local trackPos = 0
			--for each filter in MoodID_filters

			for _,Filter in pairs(MoodID_filters) do
				--if Filter is not already in filtersToPass or if the stored level is lower, then
				-- --set filtersToPass[Filter] = moodleLevel
				if not is_keyIn(filtersToPass,Filter) or (is_keyIn(filtersToPass,Filter) and moodleLevel > filtersToPass[Filter]) then
					filtersToPass[Filter] = moodleLevel
					--set up the processing order based on if found in volumeSensitiveFilters
					if not is_valueIn(sortFilters,Filter) then
						--adds to the end of the order if found in volumeSensitiveFilters, or in "trackPos" pos
						if is_valueIn(ConditionalSpeech.volumeSensitiveFilters,Filter) then
							table.insert(sortFilters,Filter)
						else
							trackPos = trackPos+1
							table.insert(sortFilters,trackPos,Filter)
						end
					end
				end
			end
		end
	end

	--volume to be called and modified depending on filters
	local filtered_vol = 0

	for _,FilterType in ipairs(sortFilters) do
		if not is_valueIn(ConditionalSpeech.volumeSensitiveFilters,FilterType) or (filtered_vol > 0 and is_valueIn(ConditionalSpeech.volumeSensitiveFilters,FilterType)) then
			--compare sortFilters's value to filtersToPass's keys to find stored intensity
			--[debug]] print("CND-SPEECH: RUN FILTER: ",FilterType,"-")
			local intensity = filtersToPass[FilterType]
			local filter = ConditionalSpeech_Filter[FilterType]
			local filter_results = filter(text, intensity)

			if filter_results.return_text then
				text = filter_results.return_text
			end

			if filter_results.return_vol and filter_results.return_vol > filtered_vol then
				filtered_vol = filter_results.return_vol
			end
		end
	end

	if filtered_vol == VolumeMAX then
		text = text:upper()
	end
	local total_results = filterResults:new(text,filtered_vol)

	return total_results
end



--- Generates speech from a given table/list of phrases.
---@param player IsoGameCharacter
---@param PhraseSetID string String needs to match a table with in ConditionalSpeech.Phrases.
function ConditionalSpeech.generateSpeechFrom(player, PhraseSetID, intensity, MAXintensity, volumeBlock, danger)
	if not player or not PhraseSetID then
		return
	end

	if not intensity or intensity <=0 then
		intensity = 1
	end

	if not MAXintensity or MAXintensity <=0 then
		MAXintensity = 1
	end

	-- prevent the player from speaking too soon -- getTimestamp is in seconds
	local lastspoke = player:getModData().cs_lastspoke or {[1]=getTimestamp(), [2]=""}
	--delay between lines is 1 unless they're the same phraset, then it is 3
	if (lastspoke[1]+1 > getTimestamp()) or (lastspoke[1]+3 > getTimestamp() and lastspoke[2]==PhraseSetID) then
		return
	end

	local PhraseTable = ConditionalSpeech.Phrases[PhraseSetID]
	if not PhraseTable then
		return
	end

	local dialogue = RangedRandPick(PhraseTable,intensity,MAXintensity)
	if not dialogue then
		return
	end

	--If "<" is found within the phrase - assume there's a keyword
	while string.find(dialogue, "<") do
		--replace text matching PhraseSetID (KEYWORD) with words from phraseset
		for KEYWORD, PHRASE in pairs(ConditionalSpeech.Phrases) do
			local phrases = PHRASE
			if danger and (KEYWORD=="SARCASM") then
				phrases = ConditionalSpeech.Phrases["SWEAR"]
			end
			dialogue = dialogue:gsub("<"..KEYWORD..">", pickFrom(phrases))
		end
	end
	ConditionalSpeech.Speech(player,dialogue,PhraseSetID, volumeBlock)
end




--- Cleans up the dialogue and applies filters.
---@param player IsoGameCharacter
---@param dialogue string
function ConditionalSpeech.Speech(player, dialogue, PhraseSetID, volumeBlock)

	--prevent MPCs from speaking if config is set to such
	if ConditionalSpeech.bIsNPC(player)==true and cndSpeechConfig.config.NPCsDontTalk==true then
		--[DEBUG]] print("CND-SPEECH: NO NPC TALK ("..player:getFullName()..")")
		return
	end

	-- prevent the player from speaking too soon -- getTimestamp is in seconds
	local lastspoke = player:getModData().cs_lastspoke or {[1]=getTimestamp(), [2]=""}

	if (lastspoke[1]+1 > getTimestamp()) or (lastspoke[1]+3 > getTimestamp() and lastspoke[2]==PhraseSetID) then
		return
	end

	player:getModData().cs_lastspoke = {[1]=getTimestamp(),[2]=PhraseSetID}

	local fc = string.sub(dialogue, 1,1) --fc=first character
	local lc = string.sub(dialogue, -1) --lc=last character
	local vocal_volume = 0

	--avoid filtering/messing with *emotive* text
	if fc~="*" and lc~="*" then

		--just in case of no punctuation add some
		if lc~="." and lc~="!" and lc~="?" then
			dialogue = dialogue .. "."
		end

		--pass moodle filters if player has a moodle array
		if player:getModData().moodleTable then
			local passMF_results = ConditionalSpeech.passMoodleFilters(player,dialogue)--have other moods impact dialogue
			dialogue = passMF_results.return_text
			vocal_volume = passMF_results.return_vol
		end

		--Proper sentence capitalization. Like so.
		dialogue = dialogue:gsub("[!?.]%s", "%0\0"):gsub("%f[%Z]%s*%l", dialogue.upper):gsub("%z", "")
	end

	if volumeBlock then
		vocal_volume = 0
	end

	--[[debug]] print("CND-SPEECH: "..player:getFullName()," (vol:",vocal_volume,") : ",dialogue)
	ConditionalSpeech.applyVolumetricColor_Say(player,tostring(dialogue),vocal_volume)

	if cndSpeechConfig.config.SpeechCanAttractsZombies==true then
		addSound(nil, player:getX(), player:getY(), player:getZ(), vocal_volume, vocal_volume)
	end

end


--- Blends speech color with gray on a scale with volume. This is called with in ConditionalSpeech.Speech.
---@param player IsoGameCharacter | IsoPlayer
function ConditionalSpeech.applyVolumetricColor_Say(player,text,vol)
	if not player or not text then
		return
	end

	local vc_shift = 0.3+(0.7*(vol/VolumeMAX))--have a 0.3 base --difference of 0.7 is then multipled against volume/maxvolume
	local Text_Color = player:getSpeakColour()

	if not Text_Color then
		player:setSpeakColour(Color(ZombRand(0.45,0.9),ZombRand(0.45,0.9),ZombRand(0.45,0.9)))
	end

	Text_Color = player:getSpeakColour() or NullColor

	local text_color = { r = Text_Color:getRedFloat()*vc_shift, g = Text_Color:getGreenFloat()*vc_shift, b = Text_Color:getBlueFloat()*vc_shift, a = vc_shift}--alpha shift based on vc_shift
	local graybase = {r=0.45, g=0.45, b=0.45, a=1}--gray base text_color will be overlayed onto
	local return_color = {r=0, g=0, b=0, a=0}--set up return color

	return_color.a = 1 - (1 - text_color.a) * (1 - graybase.a)--alpha
	return_color.r = text_color.r * text_color.r / return_color.a + graybase.r * graybase.a * (1 - text_color.a) / return_color.a--red
	return_color.g = text_color.g * text_color.g / return_color.a + graybase.g * graybase.a * (1 - text_color.a) / return_color.a--green
	return_color.b = text_color.b * text_color.b / return_color.a + graybase.b * graybase.a * (1 - text_color.a) / return_color.a--blue

	player:Say(text, return_color.r, return_color.g, return_color.b, UIFont.NewSmall, vol, "radio") --radio makes it colored, I don't know why exactly
end


--- Tracks moodle levels overtime, runs generate speech.
---@param player IsoGameCharacter
function ConditionalSpeech.check_PlayerStatus(player)
	if (not player) or (not player:getModData().moodleTable) then
		return
	end

	local playerStats = player:getStats()
	--panic is a troublesome moodle and can't be treated like the rest
	local panicLevel = player:getMoodles():getMoodleLevel(MoodleType.Panic)

	-- on fire condition
	if player:isOnFire() then
		playerStats:setPanic(playerStats:getPanic()+100)
		ConditionalSpeech.generateSpeechFrom(player,"Panic",panicLevel,4, false, true)
		return
	end

	local zombiesNearBy = (playerStats:getNumVisibleZombies() + playerStats:getNumChasingZombies()) > 0
	--prevent vocalization if any zombies are visible or chasing
	local volumeBlock = ((panicLevel >= 0) and zombiesNearBy)
	--check if agoraphobic is actively enducing panic
	local agora = (player:isOutside() and player:HasTrait("Agoraphobic"))
	local claustro = ((not player:isOutside()) and player:HasTrait("Claustophobic"))

	local spoke = false

	for MoodleID,lvl in pairs(player:getModData().moodleTable) do
		local storedmoodleLevel = lvl
		local currentMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType[MoodleID])
		--currentMoodleLevel(current mood level) is not equal to stored mood level then
		if currentMoodleLevel ~= storedmoodleLevel then
			--if moodlevel has increased
			if currentMoodleLevel > storedmoodleLevel then
				local phraseSet = MoodleID
				--space-phobic conditions met, set MoodleID\Phraset
				if MoodleID=="Panic" then
					if agora then
						phraseSet = "Agoraphobic"
					end
					if claustro then
						phraseSet = "Claustrophobic"
					end
				end
				--pain overrides volumeBlock
				if MoodleID == "Pain" then
					volumeBlock = false
				end
				--generate speech
				ConditionalSpeech.generateSpeechFrom(player, phraseSet, currentMoodleLevel,4, volumeBlock, zombiesNearBy)
				spoke = true
			end
			--match stored mood level to current regardless of above outcome
			player:getModData().moodleTable[MoodleID] = currentMoodleLevel
		end
	end

	if not spoke then
		local tellTime = player:getModData().CndSpeech_tellTime
		local validTime = ((getGameTime():getHour() == DUSK_TIME) or (getGameTime():getHour() == DAWN_TIME))

		if tellTime and validTime then
			ConditionalSpeech.generateSpeechFrom(player,tellTime)
			player:getModData().CndSpeech_tellTime = false
		end
	end
end


--- Weapon Status Check
---@param player IsoGameCharacter
---@param weapon InventoryItem
function ConditionalSpeech.check_WeaponStatus(player,weapon)
	if player and weapon and weapon:getCategory() == "Weapon" and weapon:isRanged() and not player:isShoving() then
		if weapon:isJammed() then
			ConditionalSpeech.generateSpeechFrom(player,"GunJammed")
		elseif (weapon:haveChamber() and not weapon:isRoundChambered()) or (not weapon:haveChamber() and weapon:getCurrentAmmoCount() <= 0) then
			ConditionalSpeech.generateSpeechFrom(player,"OutOfAmmo")
		elseif weapon:getMaxAmmo()>0 then
			if player:getPerkLevel(Perks.Reloading)>=5 then
				ConditionalSpeech.Speech(player,weapon:getCurrentAmmoCount().." shots left")
			elseif player:getPerkLevel(Perks.Reloading)>=2 then
				if weapon:getCurrentAmmoCount()<(weapon:getMaxAmmo()/4) then
					ConditionalSpeech.generateSpeechFrom(player,"LowAmmo")
				end
			end
		end
	end
end


--- Have players react to specific times throughout the day.
function ConditionalSpeech.check_Time()
	local TIME = getGameTime():getHour()

	for playerObject,_ in pairs(ConditionalSpeech.Speakers) do
		---@type IsoGameCharacter | IsoPlayer
		local player = playerObject

		if player and not player:isDead() then
			if player:isOutside() and is_prob(75) then
				if TIME==DAWN_TIME then
					player:getModData().CndSpeech_tellTime = "OnDawn"
				elseif TIME==DUSK_TIME then
					player:getModData().CndSpeech_tellTime = "OnDusk"
				end
			end
		end
	end
end



--- Event Hooks ---
Events.OnCreateLivingCharacter.Add(ConditionalSpeech.load_n_set_Moodles)--OnCreateLivingCharacter(playerObj) --Starts up ConditionalSpeech
Events.EveryHours.Add(ConditionalSpeech.check_Time)--EveryHours(?) --check every in-game hour for events
Events.OnWeaponSwing.Add(ConditionalSpeech.check_WeaponStatus) --OnWeaponSwing(playerObj,weapon)
Events.OnPlayerUpdate.Add(ConditionalSpeech.check_PlayerStatus) --OnPlayerUpdate(playerObj) --checks moodlestatus


---@param playerID number
---@param playerObject IsoPlayer | IsoGameCharacter
function ConditionalSpeech.setSpeakColor(playerObject)
	local MpTextColor = getCore():getMpTextColor()
	playerObject:setSpeakColourInfo(MpTextColor)
	print("CND-SPEECH: Setting Speak Color on: "..playerObject:getFullName())
end
Events.OnCreateLivingCharacter.Add(ConditionalSpeech.setSpeakColor)

MainOptions_pickedMPTextColor = MainOptions.pickedMPTextColor
function MainOptions:pickedMPTextColor(color, mouseUp)
	MainOptions_pickedMPTextColor(self, color, mouseUp)
	ConditionalSpeech.setSpeakColor(getPlayer())
end
