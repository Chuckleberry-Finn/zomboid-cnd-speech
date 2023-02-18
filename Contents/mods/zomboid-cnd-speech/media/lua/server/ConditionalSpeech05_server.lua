--sendClientCommand(player, module, command, args) end -- to server
local function onClientCommand(_module, _command, _player, _data)
    --serverside
    if _module == "cndSpeech" and _command == "addLineChatElement" then
        sendServerCommand(_player, _module, _command, _data)
    end
end
Events.OnClientCommand.Add(onClientCommand)--/client/ to server