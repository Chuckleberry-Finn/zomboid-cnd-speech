if isServer() then return end

local cndSpeechUtil = {}

function cndSpeechUtil.prob(x) return ZombRand(101) < x end


function cndSpeechUtil.splitTextByChar(text)
	local t={}
	for i = 1, #text do table.insert(t, text:sub(i,i)) end
	return t
end


function cndSpeechUtil.pickFrom(list) return list[ZombRand(#list)+1] end


function cndSpeechUtil.rangedRandPick(table,intensity,scale)
	if (not table) or (#table <= 0) then return nil end

	local weight = math.floor((#table/scale)+0.99) -- messy rounding to compensate for small table sizes
	local lower = 1+(weight*(intensity-1))
	local upper = weight+(weight*(intensity-1))
	local pick = ZombRand(lower,upper)+1

	if pick <= 0 then pick = 1 end
	if pick > #table then pick = #table end

	pick = table[pick]

	return pick
end


return cndSpeechUtil