ConditionalSpeech = {}
ConditionalSpeech.Phrases = {}

--- -=[ Instructions for Contributors ]=- ---
--- Firstly, thank you for stopping in; I hope you enjoy your time here.

--- to add more phrase sets: ConditionalSpeech.Phrases.WORD = {"phrase1","phrase2"}
--- to generate speech: ConditionalSpeech.generateSpeech("WORD")
--- Moodles automatically search for a phraseset matching their MoodleType.WORD
--- to use phrase set as keywords simply populate phrases with "<WORD>".

--- When Writing New Phrases:
--- Keep them short when you can.
--- Don't captilize anything other than 'I' or proper nouns.
--- Punctuation is fine, but keep in mind all '.' can become '!' - so avoid things like U.S.A. or F.B.I.
--- Avoid swears (as there is dynamic swearing built-in) instead use <SWEAR>.
--- For the moment any \*emotive actions\* have to be the entire phrase (which won't be filtered).
---
--- For more variety and to avoid bloat from repetative phrases, phrases can be used as Keywords to replace parts of another phrase at random.
--- Format: <WORD> in the phrase. Make sure there is a corresponding ConditionalSpeech.Phrases.WORD phrase-set.
--- When writing new Phrases to be used as keywords: Read through some lines with <WORD> to make sure it sounds correct before adding them in.


--[[ ---unused phrase sets for moods
ConditionalSpeech.Phrases.Endurance = nil
ConditionalSpeech.Phrases.Sick = nil
ConditionalSpeech.Phrases.Unhappy = nil
ConditionalSpeech.Phrases.Bleeding = nil
ConditionalSpeech.Phrases.Wet = nil
ConditionalSpeech.Phrases.HasACold = nil
ConditionalSpeech.Phrases.Angry = nil
ConditionalSpeech.Phrases.Injured = nil
ConditionalSpeech.Phrases.HeavyLoad = nil
ConditionalSpeech.Phrases.Drunk = nil
ConditionalSpeech.Phrases.Dead = nil
ConditionalSpeech.Phrases.Hyperthermia = nil
ConditionalSpeech.Phrases.Windchill = nil
ConditionalSpeech.Phrases.FoodEaten = nil
]]--

ConditionalSpeech.Phrases.OnDusk = {"getting dark","looks like the sun is going down","the sun is going down"}
ConditionalSpeech.Phrases.OnDawn = {"another day","made it to another day","the sun is coming up","the sun is rising"}

ConditionalSpeech.Phrases.GunJammed = {"jam!","gun is jammed!","damn thing is jammed!","jammed!"}

ConditionalSpeech.Phrases.OutOfAmmo = {
"I'm out",
"empty",
"no ammo",
"out of ammo",
"there is no ammo",
"gun is out of ammo",
"this is empty",
"this thing is empty",
"gun is empty",
"out of bullets",
"no bullets",
"there is no bullets"
}

ConditionalSpeech.Phrases.Hungry = {
"I could use a snack",
"*stomach stirs*",
"I could use <FOOD>",
"I have to snack on something",
"<FOOD> would be nice right about now",
"I should go get some food",
"*stomach growls*",
"I better get some food",
"I should get something to eat",
"my stomach is rumbling",
"ugh, I really need something to eat",
"I could go for <FOOD>",
"I could go for <FOOD> right about now",
"*stomach growls loudly*",
"this gnawing hunger is driving me nuts!",
"there has got to be some food somewhere",
"I need food",
"aaghhh. the hunger.",
"where the fuck is some food!?",
"I'm so hungry",
"uhnnng. the hunger",
"I'm starving"
}


ConditionalSpeech.Phrases.Thirst = {
"I could go for some water right now.",
"a sip of water would be nice.",
"I need something to drink.",
"I should get something to drink.",
"my mouth feels a bit dry.",
"could use a good gulp of water right now.",
"I should drink something.",
"my mouth is dry",
"*clears throat*",
"my mouth is so dry",
"I really should get something to drink now.",
"I need some water!",
"there has to be water somewhere",
"I need water"
}

ConditionalSpeech.Phrases.Tired = {
"*yawn*",
"I could use a nap.",
"I feel sluggish.",
"I should get some sleep.",
"man, I could use a lie down.",
"*long yawn*",
"I should go to sleep soon",
"I should go to bed soon",
"I should probably call it a day soon",
"I'm starting to get bags under my eyes.",
"damn I'm tired.",
"*extremely long yawn*",
"I'm so tired.",
"man, I could use some sleep.",
"I think I'm starting to lose it. I really need sleep.",
"I'm so fucking tired",
"I can barely keep my eyes open",
"I feel like I'm going to pass out",
"how long has it been since I last slept?",
"uhnng, I'm so fucking tired.",
"I really should go to sleep soon.",
"*your eyelids feel heavy*",
"I can barely stand. I'm so tired."
}

ConditionalSpeech.Phrases.Bored = {
"I should go do something.",
"I could use something to do",
"*sigh*",
"there has got to be something to do",
"well, this is boring",
"man I'm bored",
"so little to do, so little to see",
"I'm bored as fuck",
"*long sigh*",
"so fucking bored.",
"I'm bored as hell.",
"so fucking bored!",
"*deep sigh*",
"I really need something to do",
"there has gotta be something to do! something! anything! aghh!",
"sticking spoons in my eyes would be better than this",
"there has to be something to do! this is driving me insane!"
}

ConditionalSpeech.Phrases.Stress = {
"feeling stressed",
"I need to relax somehow",
"*deep breath*",
"I need to relax",
"ugh",
"I could use some relaxation",
"*deep long breath*",
"I could really use a bit of relaxation",
"can't anymore",
"this fucking stress",
"fuck this bullshit"
}

ConditionalSpeech.Phrases.Panic = {
"ah!",
"ohh!",
"oooohh!",
"holy!",
"I need to get out of here!",
"why!?",
"ahhh!",
"I have to get the fuck out of here!",
"why!?",
"please no!",
"somebody help!",
"somebody help me!",
"oh god! ahhh!"
}

ConditionalSpeech.Phrases.Hypothermia = {
"it is so cold",
"brrrrr",
"*shivers*"
}

ConditionalSpeech.Phrases.Zombie = {
"I'm turning into one of them",
"this is it",
"this is over",
"why me?",
"I'm going to turn into one of them, aren't I?"
}

ConditionalSpeech.Phrases.Pain = {
"ouch",
"ow",
"argh",
"that hurts",
"ouch",
"ow",
"aagghh",
"that hurts",
"aaaaghhh",
"arrgh",
"owww",
"that hurts like hell",
"arrrgh",
"the pain",
"make it stop",
"aagghhh",
"aaaggghhh",
"oh god",
"aaghh"
}

ConditionalSpeech.Phrases.Campfire = {"*sings*"}

-- Swears are ranked by intensity
ConditionalSpeech.Phrases.SWEAR = {"crap","damn","god damn","shit","son of a bitch","fuck","fucking"}

-- useful list of plosives for stammering
ConditionalSpeech.Phrases.Plosives = {"p","P","t","T","k","K","b","B","d","D","g","G","s","S","m","M"}

ConditionalSpeech.Phrases.FOOD = {"a bite to eat","a whole pizza","some pizza","a slice of pizza","a slice of cake","something tasty",
	"some cake","a bucket of chicken","some chicken","a Spiffo burger","a Spiffo kid's meal","a bucket of Jay's Chicken",
	"an order of Jay's biscuits with gravy","eating anything","anything to eat","a snack"}

ConditionalSpeech.Phrases.SARCASM = {"just great","awesome","fantastic","just what I needed"}


--------------------------- USEFUL FUNCTIONS ------------------------------
--useful istable() proc for sanity checks
function istable(t) return (type(t) == 'table') end

--useful function to check if value in list
function valueIn(tab, val)
	if not tab or not val then return false end
	for _,value in pairs(tab) do if value == val then return true end end
	return false
end

--useful function to check if key in list
function keyIn(tab, k)
	if not tab or not k then return false end
	for key,_ in pairs(tab) do if key == k then return true end end
	return false
end

--useful function to pick a random entry
function pickFrom(list) return list[(ZombRand(#list)+1)] end

-- Useful replace text function
function replaceText(text, findthis, replacewith)
	if not text or not findthis or not replacewith then return end
	return text:gsub(findthis, replacewith)
end

-- Useful probability function - note: 101 = 0 to 100
function prob(x) if ZombRand(101) < x then return true else return false end end

-- Useful text splitter function - returns a list of words
function splitTextbyWord(text, separator)
	if not text then return end
	if not separator then separator = "%s" end
	local t={}
	for word in string.gmatch(text, "([^"..separator.."]+)") do table.insert(t, word) end
	return t
end

-- Useful text splitter function - returns a list of characters
function splitTextbyChar(text)
	if not text then return end
	local t={}
	for i = 1, #text do table.insert(t, text:sub(i,i)) end
	return t
end

function joinText(list, spaced)
	if not list or not istable(list) then return end
	local t = ""
	for key,value in pairs(list) do
		t = t .. value
		if spaced > 0 and key ~= #list then t = t .. " " end
	end
	return t
end


function WeightedRandPick(table,intensity,maxintensity)
	local pick = (ZombRand(math.floor(#table/maxintensity))+1)*intensity
	if pick <= 0 then pick = 1 end
	if pick > #table then pick = #table end
	pick = table[pick]
	if pick then
		return pick
	else
		return nil
	end
end


------------------------------------------ FILTERS ----------------------------------------------
--Handler for filters
function ConditionalSpeech.PassMoodleFilters(text,mothermoodle)
	if text then
		local filterspassed = {} --[key]=value

		--[[debug]] print("PassMoodleFilter: ",text," (mothermoodle:",mothermoodle,")")
		for MoodID,_ in pairs(ConditionalSpeech.MoodleTable) do --for each mood grab type/key
			local MoodleEntry = ConditionalSpeech.MoodleTable[MoodID]--direct reference to grab vars in value
			--[debug]] print("-- PassMoodleFilter: passing:",MoodID)
			-- panic filter doesn't play well with others: "shit! shit! shit! I need a snack!"
			if mothermoodle~="Panic" and MoodID=="Panic" then
				--[debug]] print("--- PassMoodleFilter: ignoring:",MoodID)
				MoodleEntry = nil
			end

			if MoodleEntry and MoodleEntry.level > 0 and MoodleEntry.filters ~= nil then
				--[[debug]] print("---- PassMoodleFilter: juggling: key:",MoodID)
				--if we should bother with processing the mood
				for _,Filter in pairs(MoodleEntry.filters) do --for each filter in filters
					local needinsert = true --insertcheck, turns false if found
					for filterstored,levelof in pairs(filterspassed) do --for each filter already added for passing
						--[[debug]] print("----== juggler: key:",filterstored,"  value:",filterstored)
						if filterstored==Filter then --if keys in filterspassed matches values in MoodleEntry.filters
							needinsert = false --found
							if MoodleEntry.level > levelof then
								filterspassed[filterstored] = MoodleEntry.level
							end
							--if currently handled mood level exceeds stored level
						end
					end
					if needinsert == true then --if needinsert still true add filter and moodlevel to passinglist
						--table.insert(filterspassed, Filter)
						filterspassed[Filter] = MoodleEntry.level
					end
				end
			end
		end

		for FilterType,Intensity in pairs(filterspassed) do
			--[[debug]] print("-=-=-=-=-=-=- Run Filter: key:",FilterType,"  value:",Intensity)
			text = FilterType(text, Intensity)
		end

		--pass each collected filter with correspondin instensity/level
		return text
	end
end

-- SCREAM FILTER!
function ConditionalSpeech.SCREAM_Filter(text, intensity)
	if text then
		--[debug]] print("FILTER CALLED:  (SCREAM_Filter)",text," intensity:",intensity)
		text = replaceText(text, "%.", "%!")
		if prob(intensity*20) == true then return text:upper()
		else return text
		end
	end
end

-- S-s-stammer Filt-t-t-ter
function ConditionalSpeech.Stammer_Filter(text, intensity)
	if intensity <= 0 then intensity = 1 end
	if text then
		--[debug]] print("FILTER CALLED:  (Stammer_Filter)",text," intensity:",intensity)
		local characters = splitTextbyChar(text)
		local post_characters = {}
		local max_stammer = intensity
		for _,value in pairs(characters) do
			local c = value
			local chance = intensity*8
			if max_stammer > 0 and valueIn(ConditionalSpeech.Phrases.Plosives,value) == true then
				max_stammer = max_stammer-1
				while chance > 0 do
					if prob(chance)==true then c = c .. "-" .. c end
					chance = chance-(30+ZombRand(15))
				end
			end
			table.insert(post_characters, c)
		end
		return joinText(post_characters,0)
	end
end


-- Logic for repeated swearing
function ConditionalSpeech.panicSwear_Filter(text, intensity)
	if not intensity then intensity = ZombRand(4)+1 end
	if text then
		--[debug]] print("FILTER CALLED:  (panicSwear_Filter)",text," intensity:",intensity)

		local randswear = WeightedRandPick(ConditionalSpeech.Phrases.SWEAR,intensity,4)

		if randswear then
			randswear = randswear .. "."

			local chance = intensity*15
			while chance > 0 do
				if prob(chance)==true then randswear = randswear .. " " .. randswear end
				chance = chance-(30+ZombRand(10))
			end

			if prob(50)==true then text = randswear .. " " .. text
			else text = text .. " " .. randswear --50% before or after text
			end
		end
		return text
	end
end

-- Logic for interlaced swears
function ConditionalSpeech.interlacedSwear_Filter(text, intensity)
	if not intensity then intensity = 1 end
	if text then
		--[debug]] print("FILTER CALLED:  (interlacedSwear_Filter)",text," intensity:",intensity)
		local skip_words = {"is","it","of","at","no","as"}
		local words = splitTextbyWord(text)
		if not words or #words <= 1 then return text end

		for key,value in pairs(words) do
			if key ~= #words and prob(5*intensity) == true then
				if valueIn(skip_words,words[key+1]) ~= true then
					local swear = WeightedRandPick(ConditionalSpeech.Phrases.SWEAR,intensity,4)
					if swear then
						words[key] = value .. " " .. swear
					end
				end
			end
		end
		return joinText(words, 1)
	end
end

-------- Moodle Handler (Stores levels over time and has a filterlist to refer back to -------------
-- This has to be under where the filters themselves are defined
ConditionalSpeech.MoodleTable = {
[MoodleType.Endurance] = {level = 0, filters = nil },
[MoodleType.Tired] = {level = 0, filters = nil },
[MoodleType.Hungry] = {level = 0, filters = nil },
[MoodleType.Panic] = {level = 0, filters = {ConditionalSpeech.panicSwear_Filter,ConditionalSpeech.Stammer_Filter,ConditionalSpeech.SCREAM_Filter} },
[MoodleType.Sick] = {level = 0, filters = nil },
[MoodleType.Bored] = {level = 0, filters = nil },
[MoodleType.Unhappy] = {level = 0, filters = nil },
[MoodleType.Bleeding] = {level = 0, filters = nil },
[MoodleType.Wet] = {level = 0, filters = nil },
[MoodleType.HasACold] = {level = 0, filters = nil },
[MoodleType.Angry] = {level = 0, filters = {ConditionalSpeech.interlacedSwear_Filter,ConditionalSpeech.SCREAM_Filter} },
[MoodleType.Stress] = {level = 0, filters = nil },
[MoodleType.Thirst] = {level = 0, filters = nil },
[MoodleType.Injured] = {level = 0, filters = nil },
[MoodleType.Pain] = {level = 0, filters = {ConditionalSpeech.interlacedSwear_Filter} },
[MoodleType.HeavyLoad] = {level = 0, filters = nil },
[MoodleType.Drunk] = {level = 0, filters = nil },
[MoodleType.Dead] = {level = 0, filters = nil },
[MoodleType.Zombie] = {level = 0, filters = nil },
[MoodleType.Hyperthermia] = {level = 0, filters = nil },
[MoodleType.Hypothermia] = {level = 0, filters = {ConditionalSpeech.Stammer_Filter} },
[MoodleType.Windchill] = {level = 0, filters = nil },
[MoodleType.FoodEaten] = {level = 0, filters = nil }
}

-- Start Up LMS --
function ConditionalSpeech.Start() -- start up LMS
	getPlayer():getMoodles():Update() -- makes sure that the Moodles system is properly loaded
	ConditionalSpeech.retrieveMoodles() -- matches moodles' levels to stored value
	Events.OnPlayerUpdate.Add(ConditionalSpeech.doMoodleCheck) -- preps conditions checker
end

-- Retrieve Level Values --
function ConditionalSpeech.retrieveMoodles() --uses the associative key as a reference
	for key,_ in pairs(ConditionalSpeech.MoodleTable) do ConditionalSpeech.MoodleTable[key].level = getPlayer():getMoodles():getMoodleLevel(key) end
end


--Generates speech from a given table/list of phrases - also cleans up the sentence and applies filters
function ConditionalSpeech.generateSpeech(ID)

	local PhraseTable = ConditionalSpeech.Phrases[ID]

	if PhraseTable == false or not istable(PhraseTable) then return end

	local randNumber = ZombRand(#PhraseTable)+1 --needs +1 to offset 0 start
	local dialogue = PhraseTable[randNumber]

	--[[debug]]local dialogue_backup = dialogue -- debug
	--[[debug]]if not dialogue then print("--ERR: Dialogue == false"," (",randNumber,"/",#PhraseTable,")") return end --debug
	
	--replace KEYWORDS found with randomly picked words
	for KEYWORD,REPLACEWORDS in pairs(ConditionalSpeech.Phrases) do dialogue = replaceText(dialogue, "<"..KEYWORD..">", pickFrom(REPLACEWORDS)) end

	local fc = string.sub(dialogue, 1,1) --fc=first character
	local lc = string.sub(dialogue, -1) --lc=last character

	if fc=="*" and lc=="*" then --avoid filtering/messing with *emotive* text
	else
		if lc~="." and lc~="!" and lc~="?" then dialogue = dialogue .. "." end --just in case of no punctuation add some.
		dialogue = ConditionalSpeech.PassMoodleFilters(dialogue,mothermoodle)--have other moods impact dialogue
		dialogue = dialogue:gsub("[!?.]%s", "%0\0"):gsub("%f[%Z]%s*%l", dialogue.upper):gsub("%z", "")--Proper sentence capitalization. Like so.
	end

	--[[debug]]print("    dialogue:",dialogue_backup," (",randNumber,"/",#PhraseTable,")")
	--[[debug]]print("    processed:",dialogue)
	--[[debug]]print("  -------------------------------------------------------------------")

	getPlayer():Say(dialogue)
end


--Tracks moodle levels overtime, runs generate speech
function ConditionalSpeech.doMoodleCheck()
	for key,_ in pairs(ConditionalSpeech.MoodleTable) do
		local MoodleEntry = ConditionalSpeech.MoodleTable[key]
		--[[debug]] print("-----X ConditionalSpeech:doMoodleCheck ",key)
		if MoodleEntry.phrases ~= nil then
			local currentMoodleLevel = getPlayer():getMoodles():getMoodleLevel(key)
			if currentMoodleLevel ~= MoodleEntry.level then --currentMoodleLevel(current mood level) is not equal to stored mood level then
				if currentMoodleLevel > MoodleEntry.level then --if moodlevel has increased
					--[[debug]] print("-----XX ConditionalSpeech:doMoodleCheck ",key,"  stored level:",MoodleEntry.level,"  getlevel:",currentMoodleLevel)--,"/",getPlayer():getMoodles():getGoodBadNeutral(key))
					ConditionalSpeech.generateSpeech(key)
				end
				MoodleEntry.level = currentMoodleLevel --match stored mood level to current- this is where the recorded level is lowered
			end
		end
	end
end


--[[
-- Campfire code is broken but I think it is trying to find players near by and create a group singing event which is a pretty cool idea.
ConditionalSpeech.TimeOfRegister = false
function ConditionalSpeech.isGetCampfire() -- I yonked most of this function from camping.lua.
	local players = IsoPlayer.getPlayers()
	for _,vCamp in pairs(camping.campfires) do
		local gridSquare = vCamp:getSquare()
		if vCamp.isLit and gridSquare then
			for i=0,players:size()-1 do
				local vPlayer = players:get(i)
				if vPlayer and not vPlayer:isDead() and vPlayer:getCurrentSquare() and vPlayer:getCurrentSquare():DistTo(gridSquare) <= 3 and ConditionalSpeech.TimeOfRegister ~= os.date("%M") then
					ConditionalSpeech.CampFireRegister = true
					ConditionalSpeech.TimeOfRegister = os.date("%M")
					return true
				end
			end
		end
	end
end
]]


-- Out of Ammo
function ConditionalSpeech.check_OutOfAmmo()
	local primary_weapon = getPlayer():getPrimaryHandItem()
	if primary_weapon and primary_weapon:getCategory() == "Weapon" and primary_weapon:isRanged() and not getPlayer():isShoving() then
		if primary_weapon:isJammed() then ConditionalSpeech.generateSpeech(ConditionalSpeech.GunJammed)
		else
			if (primary_weapon:haveChamber() and not primary_weapon:isRoundChambered()) or (not primary_weapon:haveChamber() and primary_weapon:getCurrentAmmoCount() <= 0) then
				ConditionalSpeech.generateSpeech("OutOfAmmo")
			end
		end
	end
end

function ConditionalSpeech.check_Time()
	local TIME = math.floor(getGameTime():getTimeOfDay())
	--[debug]]print("-=-=- check_Dawn: getTimeOfDay:",TIME, "   outside?",getPlayer():isOutside())
	if getPlayer():isOutside() and prob(75)==true then
		if TIME==6 then ConditionalSpeech.generateSpeech("OnDawn")
		else if TIME==22 then ConditionalSpeech.generateSpeech("OnDusk") end
		end
	end
end

--Events.EveryDays.Add()
Events.EveryHours.Add(ConditionalSpeech.check_Time)
Events.OnLoad.Add(ConditionalSpeech.Start)
Events.OnWeaponSwing.Add(ConditionalSpeech.check_OutOfAmmo)




--Events.OnWeaponHitCharacter
--Events.OnWeaponHitTree
--Events.OnWeaponSwingHitPoint
--Events.onWeaponHitXp = function(owner, weapon, hitObject, damage)
--Events.EveryTenMinutes
--Events.EveryDays
--Events.EveryHours
--Events.OnEnterVehicle.Add()
--Events.OnExitVehicle.Add()
--Events.OnVehicleDamageTexture.Add()
--Events.LevelPerk.Add(xpUpdate.levelPerk)
--Events.OnZombieDead

--	player:getDescriptor():isFemale()
--	player:getDescriptor():getForename()
--	player:getDescriptor():getSurname()
--	player:getDescriptor():getProfession()

--	for i=0,player:getTraits():size() -1 do
--	local trait = player:getTraits():get(i)

--LuaEventManager.AddEvent("function")