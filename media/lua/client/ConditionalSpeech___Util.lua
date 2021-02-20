require "ConditionalSpeech_Core"
require "ConditionalSpeech_PhraseSet"

--------------------------- USEFUL FUNCTIONS ------------------------------
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

function joinText(list, spaced)--spaced is 0 or 1
	if not list then return end
	local t = ""
	for key,value in pairs(list) do
		t = t .. value
		if spaced > 0 and key ~= #list then t = t .. " " end
	end
	return t
end

--useful function to pick a random entry from a numerated list
function pickFrom(list) if type(list)=="table" then return list[ZombRand(#list)+1] else return end end

-- Ranged Random Pick from list
function RangedRandPick(table,intensity,maxintensity)
	if table == nil then return end

	local weight = math.floor((#table/maxintensity)+0.99) -- messy rounding to compensate for small table sizes
	local lower = 1+(weight*(intensity-1))
	local upper = weight+(weight*(intensity-1))
	local pick = ZombRand(lower,upper)+1

	--[[debug]] print("WeightedRandPick: table:",pick,"/",#table,"  l/u:",lower,"/",upper," (intensity:",intensity,"/",maxintensity,")")

	if pick <= 0 then pick = 1 end
	if pick > #table then pick = #table end

	pick = table[pick]
	if pick then return pick
	else return nil
	end
end