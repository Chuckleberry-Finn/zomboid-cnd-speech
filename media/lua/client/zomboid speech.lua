LMSConditions = {}

LMSConditions.Endurance = nil
LMSConditions.Sick = nil
LMSConditions.Unhappy = nil
LMSConditions.Bleeding = nil
LMSConditions.Wet = nil
LMSConditions.HasACold = nil
LMSConditions.Angry = nil
LMSConditions.Injured = nil
LMSConditions.HeavyLoad = nil
LMSConditions.Drunk = nil
LMSConditions.Dead = nil
LMSConditions.Hyperthermia = nil
LMSConditions.Windchill = nil
LMSConditions.FoodEaten = nil

LMSConditions.Ammo = {
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

LMSConditions.Hungry = {
"I could use a snack",
"*stomach stirs*",
"I could use a bite to eat",
"I have to snack on something",
"I could go for a snack right now",
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

LMSConditions.KeyWords = {
["FOOD"] = {"a whole pizza","some pizza","a slice of pizza","a slice of cake","something tasty",
	"some cake","a bucket of chicken","a Spiffo burger","a Spiffo kid's meal","a bucket of Jay's Chicken",
	"an order of Jay's biscuits with gravy","eating anything"}
}

LMSConditions.Thirst = {
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

LMSConditions.Tired = {
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
"*you jerk yourself awake*",
"I can barely stand. I'm so tired."
}

LMSConditions.Bored = {
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

LMSConditions.Stress = {
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

LMSConditions.Panic = {
"ah!",
"ohh!",
"oooohh!",
"holy!",
"I need to get out of here!",
"why!?",
"ahhh!",
"I have to get the fuck out of here!",
"why!?",
"help!",
"please no!",
"somebody help!",
"somebody help me!",
"oh god! ahhh!"
}

LMSConditions.Hypothermia = {
"it is so cold",
"brrrrr",
"*shivers*"
}

LMSConditions.Zombie = {
"I'm turning into one of them",
"this is it",
"this is over",
"why me?",
"I'm going to turn into one of them, aren't I?"
}

LMSConditions.Pain = {
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

LMSConditions.Campfire = {"*sings*"}

-- Swears are ranked by intensity
LMSConditions.Swears = {
"crap",
"damn",
"god damn",
"shit",
"son of a bitch",
"fuck",
"fucking"
}

-- useful list of plosives for stammering
LMSConditions.Plosives = {"p","P","t","T","k","K","b","B","d","D","g","G","s","S","m","M"}


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

function pickFrom(list) --useful function to pick a random entry
	return list[(ZombRand(#list)+1)]
end


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
	for word in string.gmatch(text, "([^"..separator.."]+)") do
		table.insert(t, word)
	end
	return t
end

-- Useful text splitter function - returns a list of characters
function splitTextbyChar(text)
	if not text then return end
	local t={}
	for i = 1, #text do
		table.insert(t, text:sub(i,i)) end
	return t
end

function joinText(list, spaced)
	if not list or not istable(list) then return end
	local t = ""
	for key,value in ipairs(list) do
		t = t .. value
		if spaced > 0 and key ~= #list then t = t .. " " end
	end
	return t
end

--------------------------------------------------------------------------------

--Handler for filters
function LMSConditions.PassMoodleFilters(text)
	if text then
		local filterspassed = {} --[key]=value

		for key,_ in pairs(LMSConditions.MoodleTable) do --for each mood grab type/key
			local MoodleEntry = LMSConditions.MoodleTable[key]--direct reference to grab parts of value
			if MoodleEntry and MoodleEntry.level > 0 and MoodleEntry.filters ~= nil then --if we should bother with processing the mood

				for _,Filter in pairs(MoodleEntry.filters) do --for each filter in filters
					local needinsert = true --insertcheck, turns false if found
					for filterstored,levelof in pairs(filterspassed) do --for each filter already added for passing
						if filterstored==Filter then --if keys in filterspassed matches values in MoodleEntry.filters
							needinsert = false --found
							if MoodleEntry.level > levelof then filterspassed[filterstored]=MoodleEntry.level end
							--if currently handled mood level exceeds stored level
						end
					end
					if needinsert == true then table.insert(filterspassed, [Filter]=MoodleEntry.level) end
					--if needinsert still true add filter and moodlevel to passinglist
				end
			end
		end
		for FilterType,Intensity in pairs(filterspassed) do text = FilterType(text, Intensity) end
		--pass each collected filter with correspondin instensity/level
		return text
	end
end

-- SCREAM FILTER!
function LMSConditions.SCREAM_Filter(text, intensity)
	if text then
		text = replaceText(text, "%.", "%!")
		if prob(intensity*20) == true then return text:upper()
		else return text
		end
	end
end

-- S-s-stammer Filt-t-t-ter
function LMSConditions.Stammer_Filter(text, intensity)
	if intensity <= 0 then intensity = 1 end
	if text then
		local characters = splitTextbyChar(text)
		local post_characters = {}
		local max_stammer = intensity
		for _,value in ipairs(characters) do
			local c = value
			local chance = intensity*8
			if max_stammer > 0 and valueIn(LMSConditions.Plosives,value) == true then
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
function LMSConditions.panicSwear_Filter(text, intensity)
	if not intensity then intensity = ZombRand(4)+1 end
	if text then
		local pick = (ZombRand(math.floor(#LMSConditions.Swears/4))+1)*intensity
		--print("SWEARING PICKER: intensity:",intensity," (",pick,"/",#LMSConditions.Swears,")")
		if pick == 0 then pick = 1 end
		if pick > #LMSConditions.Swears then pick = #LMSConditions.Swears end
		local randswear = LMSConditions.Swears[pick]
		
		if not randswear then return text end
		randswear = randswear .. "."

		local chance = intensity*15
		while chance > 0 do
			if prob(chance)==true then randswear = randswear .. " " .. randswear end
			chance = chance-(30+ZombRand(10))
		end

		if prob(50)==true then text = randswear .. " " .. text
		else text = text .. " " .. randswear --50% before or after text
		end
		return text
	end
end

-- Logic for interlaced swears
function LMSConditions.interlacedSwear_Filter(text, intensity)
	if not intensity then intensity = 1 end
	if text then

		local skip_words = {"is","it","of","at","no","as"}
		local words = splitTextbyWord(text)
		if not words or #words <= 1 then return text end

		for key,value in ipairs(words) do
			if key ~= #words and prob(5*intensity) == true then
				if valueIn(skip_words,words[key+1]) ~= true then
					local swear = LMSConditions.RandomSwear()
					words[key] = value .. " " .. swear
				end
			end
		end
		return joinText(words, 1)
	end
end


-- This has to be under where the filters themselves are defined
LMSConditions.MoodleTable = {
[MoodleType.Endurance] = {level = 0, phrases = LMSConditions.Endurance, filters = nil },
[MoodleType.Tired] = {level = 0, phrases = LMSConditions.Tired, filters = nil },
[MoodleType.Hungry] = {level = 0, phrases = LMSConditions.Hungry, filters = nil },
[MoodleType.Panic] = {level = 0, phrases = LMSConditions.Panic, filters = {LMSConditions.panicSwear_Filter,LMSConditions.Stammer_Filter,LMSConditions.SCREAM_Filter} },
[MoodleType.Sick] = {level = 0, phrases = LMSConditions.Sick, filters = nil },
[MoodleType.Bored] = {level = 0, phrases = LMSConditions.Bored, filters = nil },
[MoodleType.Unhappy] = {level = 0, phrases = LMSConditions.Unhappy, filters = nil },
[MoodleType.Bleeding] = {level = 0, phrases = LMSConditions.Bleeding, filters = nil },
[MoodleType.Wet] = {level = 0, phrases = LMSConditions.Wet, filters = nil },
[MoodleType.HasACold] = {level = 0, phrases = LMSConditions.HasACold, filters = nil },
[MoodleType.Angry] = {level = 0, phrases = LMSConditions.Angry, filters = {LMSConditions.interlacedSwear_Filter,LMSConditions.SCREAM_Filter} },
[MoodleType.Stress] = {level = 0, phrases = LMSConditions.Stress, filters = nil },
[MoodleType.Thirst] = {level = 0, phrases = LMSConditions.Thirst, filters = nil },
[MoodleType.Injured] = {level = 0, phrases = LMSConditions.Injured, filters = nil },
[MoodleType.Pain] = {level = 0, phrases = LMSConditions.Pain, filters = {LMSConditions.interlacedSwear_Filter} },
[MoodleType.HeavyLoad] = {level = 0, phrases = LMSConditions.HeavyLoad, filters = nil },
[MoodleType.Drunk] = {level = 0, phrases = LMSConditions.Drunk, filters = nil },
[MoodleType.Dead] = {level = 0, phrases = LMSConditions.Dead, filters = nil },
[MoodleType.Zombie] = {level = 0, phrases = LMSConditions.Zombie, filters = nil },
[MoodleType.Hyperthermia] = {level = 0, phrases = LMSConditions.Hyperthermia, filters = nil },
[MoodleType.Hypothermia] = {level = 0, phrases = LMSConditions.Hypothermia, filters = {LMSConditions.Stammer_Filter} },
[MoodleType.Windchill] = {level = 0, phrases = LMSConditions.Windchill, filters = nil },
[MoodleType.FoodEaten] = {level = 0, phrases = LMSConditions.FoodEaten, filters = nil }
}

-- Start LMS --
function LMSConditions.Start() -- start up LMS
	getPlayer():getMoodles():Update() -- makes sure that the Moodles system is properly loaded
	LMSConditions.retrieveMoodles() -- matches moodles' levels to stored value
	Events.OnPlayerUpdate.Add(LMSConditions.doMoodleCheck) -- preps conditions checker
end

-- Retrieve Level Values --
function LMSConditions.retrieveMoodles() --uses the associative key as a reference
	for key,_ in pairs(LMSConditions.MoodleTable) do LMSConditions.MoodleTable[key].level = getPlayer():getMoodles():getMoodleLevel(key) end
end



--Generates speech from a given table/list of phrases - also cleans up the sentence and applies filters
function LMSConditions.generateSpeech(conditionTable)
	if conditionTable == false or not istable(conditionTable) then return end

	local randNumber = ZombRand(#conditionTable)+1
	local dialogue = conditionTable[randNumber]

	--[[debug]]local dialogue_backup = dialogue -- debug
	--[[debug]]if not dialogue then print("--ERR: Dialogue == false"," (",randNumber,"/",#conditionTable,")") return end --debug

	for KEY,WORDS in pairs(LMSConditions.KeyWords) dialogue = replaceText(dialogue, "<"..KEY..">", pickFrom(WORDS)) end

	local fc = string.sub(dialogue, 1,1) --fc=first character
	local lc = string.sub(dialogue, -1) --lc=last character

	if fc=="*" and lc=="*" then
	else
		if lc~="." and lc~="!" and lc~="?" then dialogue = dialogue .. "." end --just in case, if no punctuation add some.
		dialogue = LMSConditions.PassMoodleFilters(dialogue)--have other moods impact dialogue
		dialogue = dialogue:gsub("[!?.]%s", "%0\0"):gsub("%f[%Z]%s*%l", dialogue.upper):gsub("%z", "")
	end

	--local sentences = splitTextbyWord(dialogue,"%p") --Capitalize first letter of every sentence.
	--for key, value in ipairs(sentences) do sentences[key] = value:gsub("^%l", string.upper) end
	--dialogue = joinText(sentences, 1)

	print("- dialogue:",dialogue_backup," (",randNumber,"/",#conditionTable,")")
	print("--- processed:",dialogue)

	getPlayer():Say(dialogue)
end


--Tracks moodle levels overtime, runs generate speech
function LMSConditions.doMoodleCheck()
	for key,_ in pairs(LMSConditions.MoodleTable) do
		local MoodleEntry = LMSConditions.MoodleTable[key]
		if MoodleEntry.phrases ~= nil then
			local currentMoodleLevel = getPlayer():getMoodles():getMoodleLevel(key)
			if currentMoodleLevel ~= MoodleEntry.level then --currentMoodleLevel(current mood level) is not equal to stored mood level then
				if currentMoodleLevel > MoodleEntry.level then --if moodlevel has increased
					print("--sanity check 1 -- LMSConditions:doMoodleCheck ",key,"  stored level:",MoodleEntry.level,"  getlevel:",currentMoodleLevel)--,"/",getPlayer():getMoodles():getGoodBadNeutral(key))
					LMSConditions.generateSpeech(MoodleEntry.phrases, currentMoodleLevel)
				end
				MoodleEntry.level = currentMoodleLevel --match stored mood level to current- this is where the recorded level is lowered
			end
		end
	end
end


--[[
-- Campfire code is broken but I think it is trying to find players near by and create a group singing event which is a pretty cool idea.
LMSConditions.TimeOfRegister = false
function LMSConditions.isGetCampfire() -- I yonked most of this function from camping.lua.
	local players = IsoPlayer.getPlayers()
	for _,vCamp in pairs(camping.campfires) do
		local gridSquare = vCamp:getSquare()
		if vCamp.isLit and gridSquare then
			for i=0,players:size()-1 do
				local vPlayer = players:get(i)
				if vPlayer and not vPlayer:isDead() and vPlayer:getCurrentSquare() and vPlayer:getCurrentSquare():DistTo(gridSquare) <= 3 and LMSConditions.TimeOfRegister ~= os.date("%M") then
					LMSConditions.CampFireRegister = true
					LMSConditions.TimeOfRegister = os.date("%M")
					return true
				end
			end
		end
	end
end
]]


-- Out of Ammo
function LMSConditions.checkIfAttacking()
	local primary_weapon = getPlayer():getPrimaryHandItem()
	if primary_weapon and primary_weapon:getCategory() == "Weapon" and not getPlayer():isShoving() then
		if primary_weapon:isRanged() then
			if (primary_weapon:haveChamber() and not primary_weapon:isRoundChambered()) or (not primary_weapon:haveChamber() and primary_weapon:getCurrentAmmoCount() <= 0) then
				LMSConditions.generateSpeech(LMSConditions.Hungry)
			end
		end
	end
end

Events.OnLoad.Add(LMSConditions.Start)
Events.OnWeaponSwing.Add(LMSConditions.checkIfAttacking)
