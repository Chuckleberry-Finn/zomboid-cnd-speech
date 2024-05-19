-- sendServerCommand(module, command, player, args) end -- to client
local function onServerCommand(_module, _command, _data)
    --clientside
    if _module == "cndSpeech" and  _command == "addLineChatElement" then
        getPlayer():addLineChatElement(_data.text, _data.return_color.r, _data.return_color.g, _data.return_color.b, UIFont.Dialogue, _data.vol, "default", true, true, true, true, true, true)
        getPlayer():getBodyDamage():setBoredomLevel( getPlayer():getBodyDamage():getBoredomLevel() + (ZomboidGlobals.BoredomDecrease * getGameTime():getMultiplier()))
    end
end
Events.OnServerCommand.Add(onServerCommand)--/server/ to client

if getActivatedMods():contains("ChuckleberryFinnAlertSystem") then
    local modCountSystem = require "chuckleberryFinnModding_modCountSystem"
    if modCountSystem then modCountSystem.pullAndAddModID() end
else print("WARNING: Highly recommended to install `ChuckleberryFinnAlertSystem` (Workshop ID: `3077900375`) for latest news and updates.") end