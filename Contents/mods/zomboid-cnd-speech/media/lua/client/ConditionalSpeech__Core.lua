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

--- filters that shouldn't run if volume is 0
ConditionalSpeech.volumeSensitiveFilters = {"Stutter","Stammer"}

--- global paired list of mood types and corresponding filters
ConditionalSpeech.filterTable = { -- This has to be under where the filters themselves are defined
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



--- Retrieve MoodLevel Values and Set up MoodArray per player.
---@param ID number IDs are assigned upon player creation via OnCreatePlayer().
function ConditionalSpeech.load_n_set_Moodles(ID)
	if not ID then
		return
	end

	local player = getSpecificPlayer(ID)

	if not player then
		return
	end

	table.insert(ConditionalSpeech.Speakers, player)
	player:getMoodles():Update()
	player:getModData().cs_lastspoke = {[1] = getTimestamp(),[2]=""}
	player:getModData().moodleTable = {}

	local moodles = player:getMoodles()
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

			print("RUN FILTER: ",FilterType,"-")

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

	local total_results = filterResults:new(text,filtered_vol)

	return total_results
end



--- Generates speech from a given table/list of phrases.
---@param player IsoGameCharacter
---@param PhraseSetID string String needs to match a table with in ConditionalSpeech.Phrases.
function ConditionalSpeech.generateSpeechFrom(player,PhraseSetID,intensity,MAXintensity)
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

	local lastspoke = player:getModData().cs_lastspoke

	if not lastspoke or lastspoke[1]+1 > getTimestamp() or (lastspoke[1]+2 > getTimestamp() and lastspoke[2]==PhraseSetID) then
		return
	end

	local PhraseTable = ConditionalSpeech.Phrases[PhraseSetID]
	local dialogue = RangedRandPick(PhraseTable,intensity,MAXintensity)

	if not PhraseTable or not dialogue then
		return
	end

	--replace KEYWORDS found with randomly picked words
	for KEYWORD,REPLACEWORDS in pairs(ConditionalSpeech.Phrases) do dialogue = dialogue:gsub("<"..KEYWORD..">", pickFrom(REPLACEWORDS)) end
	ConditionalSpeech.Speech(player,dialogue,PhraseSetID)

end


--- Cleans up the dialogue and applies filters.
---@param player IsoGameCharacter
---@param dialogue string
function ConditionalSpeech.Speech(player,dialogue,PhraseSetID)
	-- prevent the player from speaking too soon -- getTimestamp is in seconds
	local lastspoke = player:getModData().cs_lastspoke

	if not lastspoke or lastspoke[1]+1 > getTimestamp() then
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

	--[[debug]] print(player:getDescriptor():getForename(),player:getDescriptor():getSurname(),"  vol:",vocal_volume,"  ",dialogue)
	ConditionalSpeech.applyVolumetricColor_Say(player,tostring(dialogue),vocal_volume)
	addSound(nil, player:getX(), player:getY(), player:getZ(), vocal_volume, vocal_volume)

end


--- Blends speech color with gray on a scale with volume. This is called with in ConditionalSpeech.Speech.
---@param player IsoGameCharacter
function ConditionalSpeech.applyVolumetricColor_Say(player,text,vol)
	if not player or not text then
		return
	end

	local vc_shift = 0.3+(0.7*(vol/VolumeMAX))--have a 0.3 base --difference of 0.7 is then multipled against volume/maxvolume
	local MpText_Color = getCore():getMpTextColor()--grab player's MP text from main menu
	local text_color = {r = MpText_Color:getR()*vc_shift, g = MpText_Color:getG()*vc_shift, b = MpText_Color:getB()*vc_shift, a = vc_shift}--alpha shift based on vc_shift
	local graybase = {r=0.45, g=0.45, b=0.45, a=1}--gray base text_color will be overlayed onto
	local return_color = {r=0, g=0, b=0, a=0}--set up return color

	return_color.a = 1 - (1 - text_color.a) * (1 - graybase.a)--alpha
	return_color.r = text_color.r * text_color.r / return_color.a + graybase.r * graybase.a * (1 - text_color.a) / return_color.a--red
	return_color.g = text_color.g * text_color.g / return_color.a + graybase.g * graybase.a * (1 - text_color.a) / return_color.a--green
	return_color.b = text_color.b * text_color.b / return_color.a + graybase.b * graybase.a * (1 - text_color.a) / return_color.a--blue

	player:Say(text, return_color.r, return_color.g, return_color.b, UIFont.Small, vol, "radio") --radio makes it colored, I don't know why exactly
end


--- Tracks moodle levels overtime, runs generate speech.
---@param player IsoGameCharacter
function ConditionalSpeech.check_PlayerStatus(player)
	if not player then
		return
	end

	-- on fire condition
	if player:isOnFire() then
		player:getStats():setPanic(player:getStats():getPanic()+100)
		ConditionalSpeech.generateSpeechFrom(player,"Panic",player:getMoodles():getMoodleLevel(MoodleType.Panic),4)
		return
	end

	if not player:getModData().moodleTable then
		return
	end

	for MoodleID,lvl in pairs(player:getModData().moodleTable) do
		local storedmoodleLevel = lvl
		local currentMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType[MoodleID])

		--currentMoodleLevel(current mood level) is not equal to stored mood level then
		if currentMoodleLevel ~= storedmoodleLevel then
			--if moodlevel has increased
			if currentMoodleLevel > storedmoodleLevel then

				--panic is a troublesome moodle and can't be treated like the rest
				local panicLevel = player:getMoodles():getMoodleLevel(MoodleType.Panic)

				if MoodleID=="Panic" then
					--agoraphobic conditions
					if player:isOutside() and player:HasTrait("Agoraphobic") then

						local stats = player:getStats()

						if stats:getNumVisibleZombies() + stats:getNumChasingZombies() <=0 then
							ConditionalSpeech.generateSpeechFrom(player,"Agoraphobic")
						end
					end
				-- prevent speech if in high panic (or allow if high panic and agoraphobic)
				elseif ((panicLevel < 1) or MoodleID=="Pain") or (panicLevel > 0 and player:HasTrait("Agoraphobic")) then
					ConditionalSpeech.generateSpeechFrom(player,MoodleID,storedmoodleLevel,4)

				end
			end

			--match stored mood level to current regardless of above outcome
			player:getModData().moodleTable[MoodleID] = currentMoodleLevel
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
	local TIME = math.floor(getGameTime():getTimeOfDay())

	if #ConditionalSpeech.Speakers > 0 then
		for playerIndex,_ in pairs(ConditionalSpeech.Speakers) do
			local player = ConditionalSpeech.Speakers[playerIndex]

			if player and not player:isDead() then
				if player:isOutside() and is_prob(75) then
					if TIME==6 then ConditionalSpeech.generateSpeechFrom(player,"OnDawn")
					else if TIME==22 then ConditionalSpeech.generateSpeechFrom(player,"OnDusk") end
					end
				end
			end
		end
	end
end


--- Event Hooks ---
Events.OnCreatePlayer.Add(ConditionalSpeech.load_n_set_Moodles)--OnCreatePlayer(playerID) --Starts up ConditionalSpeech
Events.EveryHours.Add(ConditionalSpeech.check_Time)--EveryHours(?) --check every in-game hour for events
Events.OnWeaponSwing.Add(ConditionalSpeech.check_WeaponStatus) --OnWeaponSwing(playerObj,weapon)
Events.OnPlayerUpdate.Add(ConditionalSpeech.check_PlayerStatus) --OnPlayerUpdate(playerObj) --checks moodlestatus

-- Events.EveryDays
-- Events.OnWeaponHitCharacter
-- Events.OnWeaponHitTree
-- Events.OnWeaponSwingHitPoint
-- Events.onWeaponHitXp
-- Events.EveryTenMinutes
-- Events.EveryDays
-- Events.EveryHours
-- Events.OnEnterVehicle
-- Events.OnExitVehicle
-- Events.OnVehicleDamageTexture
-- Events.LevelPerk
-- Events.OnZombieDead
-- Events.OnCharacterDeath
