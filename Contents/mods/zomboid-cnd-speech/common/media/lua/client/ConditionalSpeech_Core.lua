local cndSpeechUtil = require "ConditionalSpeech_Util"
local conditionalSpeechFilter = require "ConditionalSpeech_Filters"
local phraseSets = require "ConditionalSpeech_PhraseSet"
local metaValues = require "ConditionalSpeech_metaValues"
local config = require "ConditionalSpeech_Config"
local cndSpeechMemory = require "ConditionalSpeech_Memory"

local ConditionalSpeech = {}

function ConditionalSpeech.checkModOption(ID)
	if not PZAPI or not PZAPI.ModOptions then return nil end

	local options = PZAPI.ModOptions:getOptions("Conditional-Speech")
	local option = options and options:getOption(ID)
	local value = option and option:getValue()

	return value
end

function ConditionalSpeech.enabledPhraseSet(moodID)
	config.applyDisabledPhraseSets()
	local disabled = config.disabledPhraseSets and config.disabledPhraseSets[moodID]
	if disabled then return false end

	if config.clientModOptionsEditable == false then return true end

	local modOptionValue = ConditionalSpeech.checkModOption("cndSpeech_Phrase_"..moodID)
	if modOptionValue == false then return false end

	return true
end

ConditionalSpeech.Speakers = {}

--- Tracks in-progress zombie strikes per player, keyed by zombie.
ConditionalSpeech.zombieStrikes = {}

--- filters that shouldn't run if volume is 0 or thoughts
ConditionalSpeech.volumeSensitiveFilters = {["Stutter"]=true,["Stammer"]=true}

--- global paired list of mood types and corresponding filters
ConditionalSpeech.filterTable = {
	["Endurance"] = {"BlurtOut"},
	["Tired"] = {"BlurtOut"},
	["Panic"] = {"panicSwear","Stutter","BlurtOut","SCREAM"},
	["Bored"] = {"BlurtOut"},
	["Bleeding"] = {"BlurtOut"},
	["Angry"] = {"SCREAM"},
	["Pain"] = {"BlurtOut","SCREAM"},
	["Drunk"] = {"BlurtOut","Slurring"},
	["Hyperthermia"] = {"Stammer","BlurtOut"},
	["HasACold"] = {"Congested"},

	--["Hungry"] = nil,
	--["Sick"] = nil,
	--["Unhappy"] = nil,
	--["Wet"] = nil,
	--["Stress"] = nil,
	--["Thirst"] = nil,
	--["Injured"] = nil,
	--["HeavyLoad"] = nil,
	--["Dead"] = nil,
	--["Zombie"] = nil,
	--["Hypothermia"] = nil,
	--["Windchill"] = nil,
	--["FoodEaten"] = nil,
	--["CantSprint"] = nil,
	--["Uncomfortable"] = nil,
	--["NoxiousSmell"] = nil,
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
function ConditionalSpeech.load_n_set_Moodles(id,player)
	if not player or player:isDead() then
		return
	end

	ConditionalSpeech.Speakers[player] = true

	local pModData = player:getModData()
	if pModData then
		pModData.cs_lastspoke = {[1]=getTimestamp(), [2]=""}
		pModData.cs_lastPanicTime = getTimestamp()
		pModData.cs_moodleTable = {}

		local moodles = player:getMoodles()
		if moodles then
			--fetches moodles index num
			for moodleID,moodle in pairs(MoodleType) do
				if instanceof(moodle, "MoodleType") then

					--fetches mood type string based on index
					local moodType = tostring(moodleID)
					--fetches moodle level based on fetched type
					local foundlevel = moodles:getMoodleLevel(moodle)
					--creates a key value pair of type and found level
					pModData.cs_moodleTable[tostring(moodType)] = foundlevel
				end
			end
		end
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
	for moodleType,lvl in pairs(player:getModData().cs_moodleTable) do

		local moodle = MoodleType[moodleType]
		local moodID = moodle:getTranslationName()

		local moodleLevel = lvl
		local MoodID_filters = ConditionalSpeech.filterTable[moodID]

		--check if mood should be processed
		if moodleLevel > 0 and MoodID_filters then

			--trackPos to maintain order through sorting
			local trackPos = 0
			for _,Filter in pairs(MoodID_filters) do
				if moodleLevel > (filtersToPass[Filter] or 0) then
					filtersToPass[Filter] = moodleLevel

					if ConditionalSpeech.volumeSensitiveFilters[Filter] then
						table.insert(sortFilters,Filter)
					else
						trackPos = trackPos+1
						table.insert(sortFilters,trackPos,Filter)
					end
				end
			end
		end
	end

	--volume to be called and modified depending on filters
	local filtered_vol = 0

	for _,FilterType in ipairs(sortFilters) do
		if not ConditionalSpeech.volumeSensitiveFilters[FilterType] or (filtered_vol > 0 and ConditionalSpeech.volumeSensitiveFilters[FilterType]) then
			--compare sortFilters's value to filtersToPass's keys to find stored intensity

			local intensity = filtersToPass[FilterType]
			local filter = conditionalSpeechFilter[FilterType]
			local resultText, resultVolume = filter(text, intensity)
			--[debug]] print("CND-SPEECH: RUN FILTER: ",FilterType," -intensity:",intensity)

			text = resultText or text
			if resultVolume and resultVolume > filtered_vol then filtered_vol = resultVolume end
		end
	end

	if filtered_vol >= metaValues.volumeMax then
		text = text:upper()
	end

	return text,filtered_vol
end



--- Resolves <KEYWORD> tags within a phrase, substituting in a random line from the matching phraseset.
---@param dialogue string
--- Checks whether a player is currently panicking.
---@param player IsoGameCharacter
function ConditionalSpeech.isPanicking(player)
	local playerMoodles = player and player:getMoodles()
	local panicLevel = playerMoodles and playerMoodles:getMoodleLevel(MoodleType.PANIC) or 0
	return panicLevel > 0
end


function ConditionalSpeech.resolveKeywords(dialogue, danger, player)
	if not dialogue then return dialogue end

	if player and dialogue:find("<RecentFood>", 1, true) then
		local recentFood = cndSpeechMemory.recent(player, "AteFood", 3600) or "something"
		dialogue = dialogue:gsub("<RecentFood>", recentFood:gsub("%%","%%%%"), 1)
	end

	local MAX_PASSES = 15
	local passes = 0

	while string.find(dialogue, "<") and passes < MAX_PASSES do
		passes = passes + 1

		for KEYWORD, PHRASE in pairs(phraseSets.Phrases) do
			local tag = "<"..KEYWORD..">"

			if dialogue:find(tag, 1, true) then
				local phrases = PHRASE
				if danger and (KEYWORD=="SARCASM") then phrases = phraseSets.Phrases["SWEAR"] end

				local replacement = phrases and #phrases > 0 and cndSpeechUtil.pickFrom(phrases)

				if replacement then
					replacement = replacement:gsub("%%","%%%%")
					dialogue = dialogue:gsub(tag, replacement, 1)
				else
					dialogue = dialogue:gsub(tag, "", 1)
				end
			end
		end
	end

	dialogue = dialogue:gsub("<%a+>", ""):gsub("[<>]", "")

	return dialogue
end


--- Generates speech from a given table/list of phrases.
---@param player IsoGameCharacter
---@param PhraseSetID string String needs to match a table with in ConditionalSpeech.Phrases.
function ConditionalSpeech.generateSpeechFrom(player, PhraseSetID, intensity, MAXintensity, volumeBlock, danger)
	if not player or not PhraseSetID then return end

	--print("p:",player, " - ",PhraseSetID, " (",intensity,"/", MAXintensity,") ", "@",volumeBlock," danger:", danger)

	if ConditionalSpeech.enabledPhraseSet(PhraseSetID) ~= true then return end

	if not intensity or intensity <=0 then intensity = 1 end

	if not MAXintensity or MAXintensity <=0 then MAXintensity = 1 end

	-- prevent the player from speaking too soon -- getTimestamp is in seconds
	local lastspoke = player:getModData().cs_lastspoke or {[1]=getTimestamp(), [2]=""}
	--delay between lines is 1 unless they're the same phraset, then it is 3
	if (lastspoke[1]+1 > getTimestamp()) or (lastspoke[1]+3 > getTimestamp() and lastspoke[2]==PhraseSetID) then
		return
	end

	local PhraseTable = phraseSets.Phrases[PhraseSetID]
	if not PhraseTable then
		return
	end

	local dialogue = cndSpeechUtil.rangedRandPick(PhraseTable,intensity,MAXintensity)
	if not dialogue then
		return
	end

	dialogue = ConditionalSpeech.resolveKeywords(dialogue, danger, player)
	if not dialogue then
		return
	end

	local vocal_volume = 0
	dialogue, vocal_volume = ConditionalSpeech.ProcessSpeech(player,dialogue,PhraseSetID, volumeBlock)

	ConditionalSpeech.Say(player, dialogue, vocal_volume)
end


--- Our own version of Say()
function ConditionalSpeech.Say(player, dialogue, vocal_volume)
	if (not player) or (not player:isLocalPlayer()) then return end

	--[debug]] print("CND-SPEECH: "..player:getFullName()," (vol:",vocal_volume,") : ",dialogue)
	ConditionalSpeech.applyVolumetricColor_Say(player,tostring(dialogue),vocal_volume)

	if SandboxVars.ConditionalSpeech.SpeechCanAttractZombies==true and player and vocal_volume and vocal_volume>0 then
		addSound(nil, player:getX(), player:getY(), player:getZ(), vocal_volume, vocal_volume)
	end
end


--- Cleans up the dialogue and applies filters.
---@param player IsoGameCharacter
---@param dialogue string
function ConditionalSpeech.ProcessSpeech(player, dialogue, PhraseSetID, volumeBlock, volumeOverride)

	--prevent MPCs from speaking if config is set to such
	if ConditionalSpeech.bIsNPC(player)==true then--and cndSpeechConfig.config.NPCsDontTalk==true then
		--DEBUG print("CND-SPEECH: NO NPC TALK ("..player:getFullName()..")")
		return
	end

	if PhraseSetID then
		-- prevent the player from speaking too soon -- getTimestamp is in seconds
		local lastspoke = player:getModData().cs_lastspoke or {[1]=getTimestamp(), [2]=""}
		if (lastspoke[1]+1 > getTimestamp()) or (lastspoke[1]+3 > getTimestamp() and lastspoke[2]==PhraseSetID) then
			return
		end
		player:getModData().cs_lastspoke = {[1]=getTimestamp(),[2]=PhraseSetID}
	end

	local fc = string.sub(dialogue, 1,1) --fc=first character
	local lc = string.sub(dialogue, -1) --lc=last character
	local vocal_volume = 0

	--avoid filtering/messing with *emotive* text
	if (fc~="*" and lc~="*") and (fc~="[" and lc~="]") and (fc~="<" and lc~=">") then

		--just in case of no punctuation add some
		if lc~="." and lc~="!" and lc~="?" then
			dialogue = dialogue .. "."
		end

		--pass moodle filters if player has a moodle array
		if player:getModData().cs_moodleTable then
			local textResult, volumeResult = ConditionalSpeech.passMoodleFilters(player,dialogue)--have other moods impact dialogue
			dialogue = textResult
			vocal_volume = volumeResult
		end

		--Proper sentence capitalization. Like so.
		dialogue = dialogue:gsub("[!?.]%s", "%0\0"):gsub("%f[%Z]%s*%l", dialogue.upper):gsub("%z", "")
	end

	if volumeOverride then
		vocal_volume = math.max(volumeOverride, vocal_volume)
	end

	if volumeBlock and (fc~="*" or lc~="*") then
		vocal_volume = 0
		dialogue = "(" .. dialogue .. ")"
	end

	return dialogue, vocal_volume
end


--- Blends speech color with gray on a scale with volume. This is called with in ConditionalSpeech.Speech.
---@param player IsoGameCharacter | IsoPlayer
function ConditionalSpeech.applyVolumetricColor_Say(player,text,vol)
	if not player or not text then return end

	if not vol then vol = 0 end

	local isAction = (string.sub(text,1,1)=="*" and string.sub(text,-1)=="*")
	if (vol <= 0) and (not isAction) and (SandboxVars.ConditionalSpeech.ShowOnlyAudibleSpeech==true) then return end

	local vc_shift = 0.40+(0.60*((vol or 0)/metaValues.volumeMax))--have a 0.3 base --difference of 0.7 is then multiplied against volume/maxvolume
	---@type ColorInfo
	local Text_Color = getCore():getMpTextColor()
	local tR, tG, tB = Text_Color:getR(), Text_Color:getG(), Text_Color:getB()
	local vibR, vibG, vibB = cndSpeechUtil.mostVibrantColor(tR, tG, tB)
	vibR, vibG, vibB = cndSpeechUtil.ensureReadable(vibR, vibG, vibB, 0.5)

	local text_color = { r = vibR*vc_shift, g = vibG*vc_shift, b = vibB*vc_shift, a = vc_shift}--alpha shift based on vc_shift, reaching the fully vibrant color at max volume
	local graybase = {r=0.45, g=0.45, b=0.45, a=1}--gray base text_color will be overlayed onto
	local return_color = {r=tR, g=tG, b=tB, a=1}--set up return color

	if (SandboxVars.ConditionalSpeech.SpeechCanAttractZombies==true) then
		return_color.a = 1 - (1 - text_color.a) * (1 - graybase.a)--alpha
		return_color.r = text_color.r * text_color.r / return_color.a + graybase.r * graybase.a * (1 - text_color.a) / return_color.a--red
		return_color.g = text_color.g * text_color.g / return_color.a + graybase.g * graybase.a * (1 - text_color.a) / return_color.a--green
		return_color.b = text_color.b * text_color.b / return_color.a + graybase.b * graybase.a * (1 - text_color.a) / return_color.a--blue
		player:setSpeakColour(Color.new(return_color.r,return_color.g,return_color.b,1))
	end

	--print(" --Text_Color: "..Text_Color:getR()..","..Text_Color:getG()..","..Text_Color:getB())
	--print(" --text_color: "..text_color.r..","..text_color.g..","..text_color.b)
	--print(" --return_color: "..return_color.r..","..return_color.g..","..return_color.b)

	if getDebug() then print(" ---applyVolumetric: "..player:getFullName()," (vol:",vol,") : ",text) end

	ConditionalSpeech.playerJustSpoke[player] = 3
	if isClient() then
		sendClientCommand(player, "cndSpeech", "addLineChatElement", {text=text, return_color=return_color, vol=vol, onlineID=player:getOnlineID()}) -- to server
	else
		player:addLineChatElement(text, return_color.r, return_color.g, return_color.b, UIFont.Medium, vol, "default", true, true, true, true, true, true)
	end
end


--- Apply filters to process say
local original_processSayMessage = processSayMessage
function processSayMessage(text, ...)
	text = ConditionalSpeech.ProcessSpeech(getPlayer(), text, nil, nil, metaValues.volumeMax/2)
	return original_processSayMessage(text, ...)
end

--[[
for moodleType,lvl in pairs(getPlayer():getModData().cs_moodleTable) do if lvl > 0 then print("moodleType: ",moodleType," = ",lvl) end end
]]

ConditionalSpeech.playerJustSpoke = {}

--- Tracks moodle levels overtime, runs generate speech.
---@param player IsoGameCharacter|IsoPlayer|IsoMovingObject|IsoObject
function ConditionalSpeech.check_PlayerStatus(player)
	if (not player) then--or (not player:getModData().cs_moodleTable) then
		return
	end

	if ConditionalSpeech.playerJustSpoke[player] then

		local pSpeaking = player:isSpeaking()
		local pSq = player:getCurrentSquare()

		local speakingIndoors = pSpeaking and pSq and pSq:isInARoom()
		if speakingIndoors then
			local stats = player:getStats()
			stats:set(CharacterStat.BOREDOM, stats:get(CharacterStat.BOREDOM) + (ZomboidGlobals.BoredomDecrease * getGameTime():getMultiplier()) )
		end

		if (not pSpeaking) then
			ConditionalSpeech.playerJustSpoke[player] = ConditionalSpeech.playerJustSpoke[player] - 1
			if ConditionalSpeech.playerJustSpoke[player] <= 0 then
				ConditionalSpeech.playerJustSpoke[player] = nil
			end
		end
	end

	local pModData = player:getModData()
	if not pModData then
		return
	end

	if (not pModData.cs_moodleTable) then
		ConditionalSpeech.load_n_set_Moodles(player)
	end
	if (not pModData.cs_moodleTable) then
		return
	end

	local playerStats = player:getStats()
	--panic is a troublesome moodle and can't be treated like the rest
	local playerMoodles = player:getMoodles()

	local panicLevel = playerMoodles and playerMoodles:getMoodleLevel(MoodleType.PANIC)or 0
	-- on fire condition
	if player:isOnFire() then
		playerStats:set(CharacterStat.PANIC, playerStats:get(CharacterStat.PANIC) + 100 )
		ConditionalSpeech.generateSpeechFrom(player,"Panic",panicLevel,4, false, true)
		return
	end

	local now = getTimestamp()
	if pModData.cs_lastMoodleScan and (now - pModData.cs_lastMoodleScan) < 1 then
		return
	end
	pModData.cs_lastMoodleScan = now

	local playerStrikes = ConditionalSpeech.zombieStrikes[player]
	if playerStrikes then
		for zombie,entry in pairs(playerStrikes) do
			if (now - entry.lastHit) > 120 or zombie:isDead() then
				playerStrikes[zombie] = nil
			end
		end
	end

	local zombiesNearBy = (playerStats:getNumVisibleZombies() > 0) or (player:getLastSeenZomboidTime() < 1)

	--prevent vocalization if any zombies are visible or chasing
	local volumeBlock = (cndSpeechUtil.prob(100-(panicLevel^2)) and zombiesNearBy)
	--check if agoraphobic is actively inducing panic
	local agora = (player:isOutside() and player:hasTrait(CharacterTrait.AGORAPHOBIC))
	local claustro = ((not player:isOutside()) and player:hasTrait(CharacterTrait.CLAUSTROPHOBIC))

	local impactedByPanic = (panicLevel>0 and zombiesNearBy)
	if impactedByPanic then
		pModData.cs_lastPanicTime = getTimestamp()+5
	end

	local spoke = false
	for moodleType,lvl in pairs(pModData.cs_moodleTable) do
		local storedmoodleLevel = lvl

		---@type MoodleType
		local moodle = MoodleType[moodleType]
		if moodle then
			local moodleID = moodle:getTranslationName()
			local currentMoodleLevel = playerMoodles:getMoodleLevel(moodle)
			--currentMoodleLevel(current mood level) is not equal to stored mood level then
			if currentMoodleLevel ~= storedmoodleLevel then
				--if moodlevel has increased
				if currentMoodleLevel > storedmoodleLevel then
					local phraseSet = moodleID

					local suppressedByPanic = (impactedByPanic) and (moodleID~="Panic") and (moodleID~="Pain") and (getTimestamp() < pModData.cs_lastPanicTime)
					local suppressedByFoodReaction = (moodleID~="Sick") and (moodleID~="Pain") and (getTimestamp() < (pModData.cs_lastFoodReactionTime or 0))

					if suppressedByPanic or suppressedByFoodReaction then
					else
						--space-phobic conditions met, set MoodleID\Phraset
						if moodleID=="Panic" then
							if agora then
								phraseSet = "Agoraphobic"
							elseif claustro then
								phraseSet = "Claustrophobic"
							elseif cndSpeechMemory.recent(player, "Kill", 180) and cndSpeechUtil.prob(35) then
								phraseSet = "PanicCallback"
							end
						end
						if moodleID=="Sick" and cndSpeechMemory.recent(player, "AteBadFood", 600) and cndSpeechUtil.prob(40) then
							phraseSet = "SickFromFood"
						end
						--pain overrides volumeBlock
						if moodleID == "Pain" then
							volumeBlock = false
						end
						--generate speech
						ConditionalSpeech.generateSpeechFrom(player, phraseSet, currentMoodleLevel,4, volumeBlock, zombiesNearBy)
					end
					spoke = true
				end
				--match stored mood level to current regardless of above outcome
				pModData.cs_moodleTable[moodleType] = currentMoodleLevel
			end
		end
	end

	if not spoke then
		local tellTime = pModData.CndSpeech_tellTime
		local validTime = ((getGameTime():getHour() == ConditionalSpeech.DUSK_TIME) or (getGameTime():getHour() == metaValues.DAWN_TIME))

		if tellTime and validTime then
			ConditionalSpeech.generateSpeechFrom(player,tellTime)
			pModData.CndSpeech_tellTime = false
		end
	end
end


--- Weapon Status Check
---@param player IsoGameCharacter
---@param weapon InventoryItem
function ConditionalSpeech.check_WeaponStatus(player,weapon)
	if player and weapon and weapon:getCategory() == "Weapon" and weapon:isRanged() then
		if (player.isShoving and not player:isShoving()) or (player.isDoShove and not player:isDoShove()) then
			if weapon:isJammed() then
				ConditionalSpeech.generateSpeechFrom(player,"GunJammed")
			elseif (weapon:haveChamber() and not weapon:isRoundChambered()) or (not weapon:haveChamber() and weapon:getCurrentAmmoCount() <= 0) then
				ConditionalSpeech.generateSpeechFrom(player,"OutOfAmmo")
			elseif weapon:getMaxAmmo()>0 then
				if player:getPerkLevel(Perks.Reloading)>=5 then

					if ConditionalSpeech.enabledPhraseSet("LowAmmo") == true then
						local dialogue, vocal_volume = ConditionalSpeech.ProcessSpeech(player,weapon:getCurrentAmmoCount().." "..getText("UI_shotsLeft"))
						if dialogue and vocal_volume then ConditionalSpeech.Say(player, dialogue, vocal_volume) end
					end
				elseif player:getPerkLevel(Perks.Reloading)>=2 then
					if weapon:getCurrentAmmoCount()<(weapon:getMaxAmmo()/4) then
						ConditionalSpeech.generateSpeechFrom(player,"LowAmmo")
					end
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
			if player:isOutside() and cndSpeechUtil.prob(75) then
				if TIME==ConditionalSpeech.DAWN_TIME then
					player:getModData().CndSpeech_tellTime = "OnDawn"
				elseif TIME==ConditionalSpeech.DUSK_TIME then
					player:getModData().CndSpeech_tellTime = "OnDusk"
				end
			end
		end
	end
end


--- Weapon Hit Tree Check
---@param owner IsoGameCharacter
---@param weapon HandWeapon
function ConditionalSpeech.check_WeaponHitTree(owner, weapon)
	if not owner then return end
	if not instanceof(owner, "IsoPlayer") then return end
	if ConditionalSpeech.isPanicking(owner) then return end

	local pModData = owner:getModData()
	local now = getTimestamp()

	if pModData.cs_lastTreeHit and (now - pModData.cs_lastTreeHit) > 10 then
		pModData.cs_treeHitStreak = 0
	end

	pModData.cs_treeHitStreak = (pModData.cs_treeHitStreak or 0) + 1
	pModData.cs_lastTreeHit = now

	if pModData.cs_treeHitStreak < 5 then return end
	if pModData.cs_lastTreeLine and (now - pModData.cs_lastTreeLine) < 120 then return end

	local chance = math.min(70, (pModData.cs_treeHitStreak-4)*15)
	if not cndSpeechUtil.prob(chance) then return end

	pModData.cs_lastTreeLine = now

	ConditionalSpeech.generateSpeechFrom(owner, "ChopTree", 1, 1, false, false)
end


--- Zombie Hit Check
---@param zombie IsoZombie
---@param wielder IsoGameCharacter
function ConditionalSpeech.check_ZombieHit(zombie, wielder, bodyPart, weapon)
	if (not zombie) or (not wielder) then return end
	if not instanceof(wielder, "IsoPlayer") then return end

	local now = getTimestamp()

	ConditionalSpeech.zombieStrikes[wielder] = ConditionalSpeech.zombieStrikes[wielder] or {}
	local playerStrikes = ConditionalSpeech.zombieStrikes[wielder]

	local entry = playerStrikes[zombie]
	if (not entry) or (now - entry.firstHit) > 120 then
		entry = {count=0, firstHit=now}
		playerStrikes[zombie] = entry
	end

	entry.count = entry.count+1
	entry.lastHit = now

	if entry.count < 4 then return end

	local pModData = wielder:getModData()
	if pModData.cs_lastMultiHitLine and (now - pModData.cs_lastMultiHitLine) < 180 then return end

	local chance = math.min(80, (entry.count-3)*15)
	if not cndSpeechUtil.prob(chance) then return end

	pModData.cs_lastMultiHitLine = now

	ConditionalSpeech.generateSpeechFrom(wielder, "MultiHit", 1, 1, false, false)
end


--- Zombie Kill Check
---@param zombie IsoZombie
function ConditionalSpeech.check_ZombieKill(zombie)
	if not zombie then return end

	local killer, killerDistSq = nil, nil

	for playerIndex=0, getNumActivePlayers()-1 do
		local playerObj = getSpecificPlayer(playerIndex)
		if playerObj and not playerObj:isDead() then
			local dx, dy = playerObj:getX()-zombie:getX(), playerObj:getY()-zombie:getY()
			local distSq = dx*dx + dy*dy

			if (not killerDistSq) or distSq < killerDistSq then
				killer, killerDistSq = playerObj, distSq
			end
		end
	end

	if (not killer) or (not killerDistSq) or killerDistSq > 9 then return end

	local pModData = killer:getModData()
	pModData.cs_killStreak = (pModData.cs_killStreak or 0) + 1

	cndSpeechMemory.remember(killer, "Kill", pModData.cs_killStreak)

	local now = getTimestamp()
	if pModData.cs_lastKillLine and (now - pModData.cs_lastKillLine) < 90 then return end
	if not cndSpeechUtil.prob(12) then return end

	pModData.cs_lastKillLine = now

	ConditionalSpeech.generateSpeechFrom(killer, "Kill", 1, 1, false, false)
end


--- Level Up Check
---@param player IsoGameCharacter
function ConditionalSpeech.check_LevelUp(player, perk, level, isSingleZero)
	if (not player) or (not level) or level<=0 then return end

	cndSpeechMemory.remember(player, "LevelUp", perk and perk:getName() or nil)

	if ConditionalSpeech.isPanicking(player) then return end

	ConditionalSpeech.generateSpeechFrom(player, "LevelUp", 1, 1, false, false)
end


--- New Room Check
---@param room IsoRoom
function ConditionalSpeech.check_NewRoom(room)
	if not room then return end

	local player = getPlayer()
	if not player then return end
	if ConditionalSpeech.isPanicking(player) then return end

	local pModData = player:getModData()
	local now = getTimestamp()

	if pModData.cs_lastExplore and (now - pModData.cs_lastExplore) < 240 then return end
	if not cndSpeechUtil.prob(20) then return end

	pModData.cs_lastExplore = now

	ConditionalSpeech.generateSpeechFrom(player, "Explore", 1, 1, false, false)
end


--- Counts the total holes across a character's worn clothing.
---@param player IsoGameCharacter
function ConditionalSpeech.countClothingHoles(player)
	local wornItems = player:getWornItems()
	if not wornItems then return 0 end

	local holes = 0
	for i=0, wornItems:size()-1 do
		local item = wornItems:getItemByIndex(i)
		if item and instanceof(item, "Clothing") and item.getHolesNumber then
			holes = holes + item:getHolesNumber()
		end
	end

	return holes
end


--- Player Damage Check
---@param player IsoGameCharacter
function ConditionalSpeech.check_PlayerGetDamage(player, damageType, damage)
	if not player then return end
	if damageType=="HUNGRY" or damageType=="THIRST" or damageType=="LOWWEIGHT" or damageType=="HEAVYLOAD" then return end

	local pModData = player:getModData()
	pModData.cs_lastInjuryTime = getTimestamp()+3
end


--- Clothing Updated Check
---@param player IsoGameCharacter
function ConditionalSpeech.check_ClothingUpdated(player)
	if not player then return end

	local holes = ConditionalSpeech.countClothingHoles(player)
	local pModData = player:getModData()

	if pModData.cs_lastHoles == nil then
		pModData.cs_lastHoles = holes
		return
	end

	if holes > pModData.cs_lastHoles then
		local recentlyInjured = pModData.cs_lastInjuryTime and getTimestamp() < pModData.cs_lastInjuryTime
		if (not recentlyInjured) and (not ConditionalSpeech.isPanicking(player)) then
			ConditionalSpeech.generateSpeechFrom(player, "Holes", 1, 1, false, false)
		end
	end

	pModData.cs_lastHoles = holes
end


--- Create Player Check
---@param playerIndex number
---@param player IsoGameCharacter
function ConditionalSpeech.check_CreatePlayer(playerIndex, player)
	if not player then return end

	local pModData = player:getModData()
	pModData.cs_lastHoles = ConditionalSpeech.countClothingHoles(player)
end


--- Ate Food Check
---@param player IsoGameCharacter
---@param food InventoryItem
function ConditionalSpeech.check_AteFood(player, food)
	if (not player) or (not food) then return end

	local pModData = player:getModData()

	cndSpeechMemory.remember(player, "AteFood", food.getName and food:getName() or nil)

	local reactionPhraseSet = nil

	if food.isRotten and food:isRotten() then
		reactionPhraseSet = "FoodRotten"
	elseif food.isbDangerousUncooked and food:isbDangerousUncooked() and (not food:isCooked()) and (not food:isBurnt()) then
		reactionPhraseSet = "FoodRaw"
	end

	if reactionPhraseSet then
		cndSpeechMemory.remember(player, "AteBadFood", food.getName and food:getName() or nil)
		pModData.cs_lastFoodReactionTime = getTimestamp()+6
		ConditionalSpeech.generateSpeechFrom(player, reactionPhraseSet, 1, 1, false, false)
	end
end


--- Vehicle Damage Check
---@param driver IsoGameCharacter
function ConditionalSpeech.check_VehicleDamage(driver)
	if not driver then return end
	if not instanceof(driver, "IsoPlayer") then return end

	local pModData = driver:getModData()
	local now = getTimestamp()

	if pModData.cs_lastVehicleDamageLine and (now - pModData.cs_lastVehicleDamageLine) < 20 then return end

	pModData.cs_lastVehicleDamageLine = now

	ConditionalSpeech.generateSpeechFrom(driver, "VehicleDamage", 1, 1, false, false)
end


--- Fill Container Check
---@param sourceName string
function ConditionalSpeech.check_FillContainer(sourceName, containerType, container)
	local player = getPlayer()
	if not player then return end
	if ConditionalSpeech.isPanicking(player) then return end

	local pModData = player:getModData()
	local now = getTimestamp()

	if pModData.cs_lastContainerLine and (now - pModData.cs_lastContainerLine) < 180 then return end
	if not cndSpeechUtil.prob(15) then return end

	pModData.cs_lastContainerLine = now

	ConditionalSpeech.generateSpeechFrom(player, "FoundLoot", 1, 1, false, false)
end


--- Animal Tracks Check
---@param player IsoGameCharacter
function ConditionalSpeech.check_AnimalTracks(player, tracks)
	if not player then return end
	if ConditionalSpeech.isPanicking(player) then return end

	local pModData = player:getModData()
	local now = getTimestamp()

	if pModData.cs_lastTracksLine and (now - pModData.cs_lastTracksLine) < 60 then return end

	pModData.cs_lastTracksLine = now

	ConditionalSpeech.generateSpeechFrom(player, "AnimalTracks", 1, 1, false, false)
end


--- Item Found Check
---@param player IsoGameCharacter
---@param itemType string
function ConditionalSpeech.check_ItemFound(player, itemType, amount)
	if not player then return end
	if ConditionalSpeech.isPanicking(player) then return end

	local pModData = player:getModData()
	local now = getTimestamp()

	if pModData.cs_lastFoundLine and (now - pModData.cs_lastFoundLine) < 120 then return end
	if not cndSpeechUtil.prob(20) then return end

	pModData.cs_lastFoundLine = now

	ConditionalSpeech.generateSpeechFrom(player, "Foraged", 1, 1, false, false)
end


return ConditionalSpeech
