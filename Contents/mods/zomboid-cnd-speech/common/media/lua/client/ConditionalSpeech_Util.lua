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


function cndSpeechUtil.perceivedLuminance(r, g, b)
	return 0.2126*r + 0.7152*g + 0.0722*b
end


function cndSpeechUtil.ensureReadable(r, g, b, minLuminance)
	minLuminance = minLuminance or 0.5

	local lum = cndSpeechUtil.perceivedLuminance(r, g, b)
	if lum >= minLuminance then return r, g, b end

	local t = (minLuminance - lum) / (1 - lum)
	if t > 1 then t = 1 end
	if t < 0 then t = 0 end

	return r + (1-r)*t, g + (1-g)*t, b + (1-b)*t
end


function cndSpeechUtil.mostVibrantColor(r, g, b)
	local maxC = math.max(r, g, b)
	local minC = math.min(r, g, b)
	local delta = maxC - minC

	if delta <= 0.001 or maxC <= 0.001 then
		return r, g, b
	end

	local h
	if maxC == r then
		h = ((g - b) / delta) % 6
	elseif maxC == g then
		h = ((b - r) / delta) + 2
	else
		h = ((r - g) / delta) + 4
	end
	h = h * 60
	if h < 0 then h = h + 360 end

	local x = 1 - math.abs((h/60) % 2 - 1)

	if h < 60 then return 1,x,0
	elseif h < 120 then return x,1,0
	elseif h < 180 then return 0,1,x
	elseif h < 240 then return 0,x,1
	elseif h < 300 then return x,0,1
	else return 1,0,x end
end


return cndSpeechUtil