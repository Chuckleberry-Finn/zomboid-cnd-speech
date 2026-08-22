local Memory = {}

Memory.DEFAULT_TTL = 60 * 5

--- Remembers a notable event for a player.
---@param player IsoGameCharacter
---@param tag string
function Memory.remember(player, tag, data)
	if (not player) or (not tag) then return end

	local pModData = player:getModData()
	if not pModData then return end

	pModData.cs_memory = pModData.cs_memory or {}
	pModData.cs_memory[tag] = { time = getTimestamp(), data = data }
end


--- Fetches a remembered event if it's still within maxAge seconds.
---@param player IsoGameCharacter
---@param tag string
function Memory.recent(player, tag, maxAge)
	if (not player) or (not tag) then return nil end

	local pModData = player:getModData()
	local entry = pModData and pModData.cs_memory and pModData.cs_memory[tag]
	if not entry then return nil end

	maxAge = maxAge or Memory.DEFAULT_TTL

	if (getTimestamp() - entry.time) > maxAge then
		return nil
	end

	return entry.data, entry.time
end


--- Clears a remembered tag, or everything if tag is nil.
---@param player IsoGameCharacter
---@param tag string
function Memory.forget(player, tag)
	local pModData = player and player:getModData()
	if (not pModData) or (not pModData.cs_memory) then return end

	if tag then
		pModData.cs_memory[tag] = nil
	else
		pModData.cs_memory = {}
	end
end


return Memory
