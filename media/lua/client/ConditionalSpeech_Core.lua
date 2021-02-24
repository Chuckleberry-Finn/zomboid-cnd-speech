require "ConditionalSpeech_Util"
require "ConditionalSpeech_PhraseSet"

ConditionalSpeech = {}
ConditionalSpeech.Speakers = {}
ConditionalSpeech.Phrases = {}

VolumeMAX = 30

------------------------------------------ FILTERS ----------------------------------------------

--- Handler for filters. Text passed through will have mood defined filters applied. Called from with in ConditionalSpeech.Speech.
---@param player IsoGameCharacter
function ConditionalSpeech.PassMoodleFilters(player,text)
	if text and player then
		local filtersToPass = {} --[key]=value
		for MoodID,lvl in pairs(player:getModData().MoodleArray) do --for each mood grab type and lvl
			local storedmoodleLevel = lvl --player:getModData().MoodleArray[MoodID]--key = Mood, value = level
			local filtersToCheck = ConditionalSpeech.MoodleArray[MoodID]
			if storedmoodleLevel ~= nil and storedmoodleLevel > 0 and filtersToCheck ~= nil then --if we should bother with processing the mood
				for _,Filter in pairs(filtersToCheck) do --for each filter in filtersToCheck
					local needinsert = true --insertcheck, turns false if found
					for filterstored,levelof in pairs(filtersToPass) do --for each filter already added for passing
						if filterstored==Filter then --if keys in filtersToPass matches values in MoodleEntry
							needinsert = false --found
							if storedmoodleLevel > levelof then filtersToPass[filterstored] = storedmoodleLevel end --if currently handled mood level exceeds stored level, replace
						end
					end
					if needinsert == true then --if needinsert still true add a new filter(key) and moodlevel(value) to passinglist
						filtersToPass[Filter] = storedmoodleLevel
					end
				end
			end
		end
		local filtered_vv = 0
		--pass each collected filter with correspondin instensity/level

		for FilterType,Intensity in pairs(filtersToPass) do
			if valueIn(ConditionalSpeech.volumeSensitiveFilters, FilterType)==false then
				local filterresults = FilterType(text, Intensity)
				text = filterresults["return_text"]
				if filterresults["return_vol"] > filtered_vv then filtered_vv = filterresults["return_vol"] end
				filtersToPass[FilterType] = nil
			end
		end

		if filtered_vv > 0 then
			for FilterType,Intensity in pairs(filtersToPass) do
				if valueIn(ConditionalSpeech.volumeSensitiveFilters, FilterType)==true then
					local filterresults = FilterType(text, Intensity)
					text = filterresults["return_text"]
					if filterresults["return_vol"] > filtered_vv then filtered_vv = filterresults["return_vol"] end
					filtersToPass[FilterType] = nil
				end
			end
		end

		local results = {["dia_logue"]=text,["voc_vol"]=filtered_vv}
		return results
	end
end


--- Filter Template
--[[
function ConditionalSpeech.TEMPLATE(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0 --VolumeMAX
		--- Stuff Here
		local results = {["return_text"]=text,["return_vol"]=vol}
		return results
	end
end
]]


--- Blurt Out
function ConditionalSpeech.BlurtOut_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0
		if prob(intensity*20) == true then
			vol = VolumeMAX/5
		end
		local results = {["return_text"]=text,["return_vol"]=vol}
		return results
	end
end


--- SCREAM FILTER!
function ConditionalSpeech.SCREAM_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = VolumeMAX/2
		text = replaceText(text, "%.", "%!")
		if prob(intensity*20) == true then
			text = text:upper()
			vol = VolumeMAX
		end
		local results = {["return_text"]=text,["return_vol"]=vol}
		return results
	end
end


--- S-s-s-stutter Filter -- impacts leading letters
function ConditionalSpeech.Stutter_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0
		local words = splitTextbyWord(text)
		local post_words = {}
		local max_stutter = intensity
		for _,value in pairs(words) do
			local w = value
			local fc = string.sub(w, 1,1) --fc=first character
			if max_stutter > 0 and valueIn(ConditionalSpeech.Phrases.Plosives,fc) == true then
				max_stutter = max_stutter-1
				local chance = intensity*16
				while chance > 0 do
					if prob(chance)==true then w = fc .. "-" .. w end
					chance = chance-(31+ZombRand(15))
				end
			end
			table.insert(post_words, w)
		end
		local results = {["return_text"]=joinText(post_words,1),["return_vol"]=vol}
		return results
	end
end


--- S-s-stammer-r-r Filt-t-t-ter -- impacts throughout
function ConditionalSpeech.Stammer_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0
		local characters = splitTextByChar(text)
		local post_characters = {}
		local max_stammer = intensity
		for _,value in pairs(characters) do
			local c = value
			if max_stammer > 0 and valueIn(ConditionalSpeech.Phrases.Plosives,c) == true then
				local chance = intensity*8
				max_stammer = max_stammer-1
				while chance > 0 do
					if prob(chance)==true then c = c .. "-" .. c end
					chance = chance-(31+ZombRand(15))
				end
			end
			table.insert(post_characters, c)
		end
		local results = {["return_text"]=joinText(post_characters,0),["return_vol"]=vol}
		return results
	end
end


--- Logic for repeated swearing
function ConditionalSpeech.panicSwear_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0
		local randswear = RangedRandPick(ConditionalSpeech.Phrases.SWEAR,intensity,4)

		if randswear then
			randswear = randswear .. "."

			local chance = intensity*15
			while chance > 0 do
				if prob(chance)==true then randswear = randswear .. " " .. randswear end
				chance = chance-(31+ZombRand(10))
			end

			if prob(50)==true then text = randswear .. " " .. text
			else text = text .. " " .. randswear --50% before or after text
			end
		end
		local results = {["return_text"]=text,["return_vol"]=vol}
		return results
	end
end


--- Logic for interlaced swears
function ConditionalSpeech.interlacedSwear_Filter(text, intensity)
	if intensity == nil then intensity = 1 end
	if text then
		local vol = 0
		local skip_words = {"is","it","of","at","no","as","the","this","should","could","would"}
		local words = splitTextbyWord(text)
		if #words <= 1 then return text end

		for key,value in pairs(words) do
			if key ~= #words and prob(5*intensity) == true then
				if valueIn(skip_words,words[key+1]) ~= true then
					local swear = RangedRandPick(ConditionalSpeech.Phrases.SWEAR,intensity,4)
					if valueIn(skip_words,words[key]) == true then
						if swear=="fuck" then swear = "fucking" end
						if swear=="shit" then swear = "shiting" end
					end
					if swear then words[key] = value .. " " .. swear end
				end
			end
		end
		local results = {["return_text"]=joinText(words, 1),["return_vol"]=vol}
		return results
	end
end


-------- Moodle Handler - filterlist to refer back to -------------
ConditionalSpeech.volumeSensitiveFilters = {ConditionalSpeech.Stammer_Filter}
--volumeSensitiveFilters are filters that shouldn't run if volume is 0
ConditionalSpeech.MoodleArray = { -- This has to be under where the filters themselves are defined
["Endurance"] = {ConditionalSpeech.BlurtOut_Filter},
["Tired"] = {ConditionalSpeech.BlurtOut_Filter},
["Hungry"] = nil,
["Panic"] = {ConditionalSpeech.panicSwear_Filter,ConditionalSpeech.BlurtOut_Filter,ConditionalSpeech.SCREAM_Filter,ConditionalSpeech.Stutter_Filter},
["Sick"] = nil,
["Bored"] = {ConditionalSpeech.BlurtOut_Filter},
["Unhappy"] = nil,
["Bleeding"] = {ConditionalSpeech.BlurtOut_Filter},
["Wet"] = nil,
["HasACold"] = nil,
["Angry"] = {ConditionalSpeech.interlacedSwear_Filter,ConditionalSpeech.SCREAM_Filter},
["Stress"] = nil,
["Thirst"] = nil,
["Injured"] = nil,
["Pain"] = {ConditionalSpeech.BlurtOut_Filter,ConditionalSpeech.interlacedSwear_Filter},
["HeavyLoad"] = nil,
["Drunk"] = {ConditionalSpeech.BlurtOut_Filter},
--[Dead] = nil,
--[Zombie] = nil,
["Hyperthermia"] = nil,
["Hypothermia"] = {ConditionalSpeech.Stammer_Filter,ConditionalSpeech.BlurtOut_Filter},
["Windchill"] = nil,
["FoodEaten"] = nil
}


--- Generates speech from a given table/list of phrases.
---@param player IsoGameCharacter
---@param PhraseSetID string String needs to match a table with in ConditionalSpeech.Phrases.
function ConditionalSpeech.generateSpeechFrom(player,PhraseSetID,intensity,MAXintensity)
	if player == nil or PhraseSetID == nil then return end
	if intensity == nil or intensity <=0 then intensity = 1 end
	if MAXintensity == nil or MAXintensity <=0 then MAXintensity = 1 end
	if player:getModData().cs_lastspoke==nil then return end
	if player:getModData().cs_lastspoke+1 > getTimestamp() then return end
	local PhraseTable = ConditionalSpeech.Phrases[PhraseSetID]
	if PhraseTable == nil then return end
	local dialogue = RangedRandPick(PhraseTable,intensity,MAXintensity)
	if dialogue == nil then return end
	--replace KEYWORDS found with randomly picked words
	for KEYWORD,REPLACEWORDS in pairs(ConditionalSpeech.Phrases) do dialogue = replaceText(dialogue, "<"..KEYWORD..">", pickFrom(REPLACEWORDS)) end
	ConditionalSpeech.Speech(player,dialogue)

end

--- Cleans up the dialogue, applies filters, and applies volumetric color.
---@param player IsoGameCharacter
---@param dialogue string
function ConditionalSpeech.Speech(player,dialogue)
	if player:getModData().cs_lastspoke==nil then return end
	if player:getModData().cs_lastspoke+1 > getTimestamp() then return end
	player:getModData().cs_lastspoke = getTimestamp()
	local fc = string.sub(dialogue, 1,1) --fc=first character
	local lc = string.sub(dialogue, -1) --lc=last character
	local vocal_volume = 0

	if fc=="*" and lc=="*" then --avoid filtering/messing with *emotive* text
	else
		if lc~="." and lc~="!" and lc~="?" then dialogue = dialogue .. "." end --just in case of no punctuation add some.

		if player:getModData().MoodleArray ~= nil then
			local conditional_speech = ConditionalSpeech.PassMoodleFilters(player,dialogue)--have other moods impact dialogue
			dialogue = conditional_speech["dia_logue"]
			vocal_volume = conditional_speech["voc_vol"]
		end
		dialogue = dialogue:gsub("[!?.]%s", "%0\0"):gsub("%f[%Z]%s*%l", dialogue.upper):gsub("%z", "")--Proper sentence capitalization. Like so.
	end

	--[[debug]] print(player:getDescriptor():getForename(),player:getDescriptor():getSurname(),"  vol:",vocal_volume,"  ",dialogue)

	dialogue = tostring(dialogue)
	ConditionalSpeech.applyVolumetricColor_Say(player,dialogue,vocal_volume)
	addSound(player, player:getX(), player:getY(), player:getZ(), vocal_volume, vocal_volume)

end


--- Blends speech color with gray on a scale with volume. This is called with in ConditionalSpeech.Speech.
---@param player IsoGameCharacter
function ConditionalSpeech.applyVolumetricColor_Say(player,text,vol)
	if player == nil or text == nil then return end
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


--- Retrieve MoodLevel Values and Set up MoodArray per player.
---@param ID number IDs are assigned upon player creation via OneCreatePlayer().
function ConditionalSpeech.load_n_set_Moodles(ID)
	if ID == nil then return end
	local player = getSpecificPlayer(ID)
	if player == nil then return end -- if no playerObj return
	table.insert(ConditionalSpeech.Speakers, player) --store speaker in list
	player:getMoodles():Update() -- makes sure that the Moodles system is properly loaded
	player:getModData().cs_lastspoke = getTimestamp()
	player:getModData().MoodleArray = {} --creates empty list
	for moodID,_ in pairs(ConditionalSpeech.MoodleArray) do
		local foundlevel = player:getMoodles():getMoodleLevel(MoodleType[moodID])
		if foundlevel==nil then foundlevel = 0 end
		player:getModData().MoodleArray[moodID] = foundlevel-- matches moodles' levels to stored value
	end
end


--- Tracks moodle levels overtime, runs generate speech.
---@param player IsoGameCharacter
function ConditionalSpeech.check_PlayerStatus(player)
	if player == nil then return end

	if player:isOnFire() then
		player:getStats():setPanic(player:getStats():getPanic()+100)
		ConditionalSpeech.generateSpeechFrom(player,"FEAR",player:getMoodles():getMoodleLevel(MoodleType.Panic),4)
		return
	end

	if player:getModData().MoodleArray == nil then return end

	for MoodleID,lvl in pairs(player:getModData().MoodleArray) do --checking moodlearray
		local storedmoodleLevel = lvl
		local currentMoodleLevel = player:getMoodles():getMoodleLevel(MoodleType[MoodleID])
		if currentMoodleLevel ~= storedmoodleLevel then --currentMoodleLevel(current mood level) is not equal to stored mood level then
			if currentMoodleLevel > storedmoodleLevel then --if moodlevel has increased
				if (player:getMoodles():getMoodleLevel(MoodleType.Panic) <= 0) then --can't think in panic
					ConditionalSpeech.generateSpeechFrom(player,MoodleID,storedmoodleLevel,4)
				elseif MoodleID=="Panic" then

					local stats = player:getStats()
					local numZombies = stats:getNumVisibleZombies() + stats:getNumChasingZombies()

					if numZombies<=0 and player:isOutside() and player:HasTrait("Agoraphobic") then
						ConditionalSpeech.generateSpeechFrom(player,"Agoraphobic")
					end
				end
			end
			player:getModData().MoodleArray[MoodleID] = currentMoodleLevel --match stored mood level to current- this is where the recorded level is lowered
		end
	end
end


--- Weapon Status Check
---@param player IsoGameCharacter
---@param weapon InventoryItem
function ConditionalSpeech.check_WeaponStatus(player,weapon)
	if player == nil or weapon == nil then return end
	if weapon and weapon:getCategory() == "Weapon" and weapon:isRanged() and not player:isShoving() then
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
				if player:isOutside() and prob(75)==true then
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
