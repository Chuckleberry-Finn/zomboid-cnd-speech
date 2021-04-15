
--- Useful function to check if a value is in a list.
---@param tab table
---@param val any
---@return boolean
function is_valueIn(tab, val)
	for _,value in pairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end


--- Useful function to check if a key is in a keyed list.
---@param tab table
---@param key any
---@return boolean
function is_keyIn(tab, key)
	if tab[key] then
		return true
	end

	return false
end


--- Useful probability function - note: 101 = 0 to 100.
---@param x number @out of 100
---@return boolean
function is_prob(x)
	if ZombRand(101) < x then
		return true
	else
		return false
	end
end


--- Useful text splitter function - returns a list of characters.
---@param text
---@return table list of characters derived from 'text' arg
function splitText_byChar(text)
	local t={}

	for i = 1, #text do
		table.insert(t, text:sub(i,i))
	end

	return t
end


--- Useful function to pick a random entry from a numerated list.
---@param list table
---@return any from numerated/non-associative list
function pickFrom(list)
	return list[ZombRand(#list)+1]
end


--- Ranged Random Pick from numerated list
---@param table table
---@param intensity number chosen segment along the 'scale' arg
---@param scale number times 'table' is split
---@return any from chosen segment out of scaled non-associative list
function RangedRandPick(table,intensity,scale)

	if (not table) or (#table <= 0) then
		return nil
	end

	local weight = math.floor((#table/scale)+0.99) -- messy rounding to compensate for small table sizes
	local lower = 1+(weight*(intensity-1))
	local upper = weight+(weight*(intensity-1))
	local pick = ZombRand(lower,upper)+1

	if pick <= 0 then
		pick = 1
	end

	if pick > #table then
		pick = #table
	end

	pick = table[pick]

	return pick
end