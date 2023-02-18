-- sendServerCommand(module, command, player, args) end -- to client
local function onServerCommand(_module, _command, _data)
    --clientside
    if _module == "cndSpeech" and  _command == "addLineChatElement" then
        getPlayer():addLineChatElement(_data.text, _data.return_color.r, _data.return_color.g, _data.return_color.b, UIFont.Dialogue, _data.vol, "default", true, true, true, true, true, true)
    end
end
Events.OnServerCommand.Add(onServerCommand)--/server/ to client