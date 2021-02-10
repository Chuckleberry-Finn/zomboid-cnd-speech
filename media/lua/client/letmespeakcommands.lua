function ISTextEntryBox:onCommandEntered()
	local LMSText = LMSWindow.LMSChatBar:getText()
	if LMSText ~= " " and LMSText ~= "" and LMSText ~= nil then
		LMSWindow.lastTextCount = LMSWindow.lastTextCount + 1
		LMSWindow.lastText[LMSWindow.lastTextCount] = LMSText
		LMSWindow.DoNotRepeatNextTime = false
		
		if LMSWindow:getIsVisible() then
			ISTextEntryBox:doCommand(LMSText)
		end
	else
		LMSWindow.LMSChatBar:clear();
		LMSWindow.LMSChatBar:unfocus();
		LMSWindow:setVisible(false);
	end
end

function ISTextEntryBox:onPressDown()
	LMSWindow.lastTextCount = LMSWindow.lastTextCount + 1
	if LMSWindow.lastText[LMSWindow.lastTextCount] ~= nil then
		LMSWindow.LMSChatBar:setText(LMSWindow.lastText[LMSWindow.lastTextCount])
	else
		LMSWindow.lastTextCount = LMSWindow.lastTextCount - 1
	end
end

function ISTextEntryBox:onPressUp()
	if LMSWindow.DoNotRepeatNextTime ~= true then
		LMSWindow.DoNotRepeatNextTime = true
		LMSWindow.LMSChatBar:setText(LMSWindow.lastText[LMSWindow.lastTextCount])
		return
	end
	
	LMSWindow.lastTextCount = LMSWindow.lastTextCount - 1
	
	if LMSWindow.lastTextCount < 1 then LMSWindow.lastTextCount = 1 end
	
	if LMSWindow.lastText[LMSWindow.lastTextCount] ~= nil then
		LMSWindow.LMSChatBar:setText(LMSWindow.lastText[LMSWindow.lastTextCount])
	else
		LMSWindow.lastTextCount = LMSWindow.lastTextCount + 1
	end
end

function ISTextEntryBox:doCommand(commandText)
	local LMSText = commandText
	local LMSTable = {}
	local LMSKey = 0
	local LMSDoNotHide = false
	local LMSDoNotClear = false
	local LMSKeepVisible = false
	if not string.find(LMSText, "/", 1) then
		getPlayer():Say(LMSText);
		LMSWindow:updateChat(LMSText)
	elseif string.match(LMSText, "/") then
		for i in string.gmatch(LMSText, "%S+") do
			LMSTable[LMSKey] = i
			LMSKey = LMSKey + 1
		end
		
		if LMSText == "/godmode" then
			CheatCoreLMS.HandleToggle("God Mode", "CheatCoreLMS.IsGod", nil)
		end
		
		if LMSText == "/creative" then
			CheatCoreLMS.HandleToggle("Creative Mode", "ISBuildMenu.cheat")
		end
		
		if LMSText == "/deletemode" then
			CheatCoreLMS.HandleToggle("Delete Mode (X to Delete)", "CheatCoreLMS.IsDelete")
		end
		
		if LMSText == "/heal" then
			CheatCoreLMS.DoHeal()
		end
		
		if LMSText == "/refillammo" then
			CheatCoreLMS.DoRefillAmmo()
		end
		
		if LMSText == "/repair" then
			CheatCoreLMS.DoRepair()
		end
		
		if LMSText == "/ghostmode" then
			CheatCoreLMS.HandleToggle("Ghost Mode", "CheatCoreLMS.IsGhost")
		end
		
		if LMSText == "/infiniteammo" then
			CheatCoreLMS.HandleToggle("Infinite Ammo", "CheatCoreLMS.IsAmmo")
		end
		
		if LMSText == "/infinitedurability" then
			CheatCoreLMS.HandleToggle("Infinite Durability", "CheatCoreLMS.IsRepair")
		end
		
		if LMSText == "/instakill" then
			CheatCoreLMS.HandleToggle("Instakill", "CheatCoreLMS.IsMelee", "CheatCoreLMS.DoWeaponDamage()")
		end
		
		if LMSText == "/noshotdelay" then
			CheatCoreLMS.HandleToggle("No Shot Delay", "CheatCoreLMS.NoReload", "CheatCoreLMS.DoNoReload()")
		end
		
		if LMSText == "/debuginfo" then
			local saveTable = getSaveDirectoryTable() 
			for i = 1,#saveTable do
				print(saveTable[i])
			end
		end
		
		if LMSText == "/toggleconditionalspeech" then
			CheatCoreLMS.HandleToggle("Conditional speech", "LMSWindow.AreConditionsNotDisabled")
		end
		
		if string.match(LMSText, "/toggleneed ") then
			local LMSTextToToggleNeed = "CheatCoreLMS.Is"..string.gsub(LMSTable[1], "%a", string.upper, 1)
			if not string.match(LMSTable[1], "all") then
				CheatCoreLMS.HandleToggle(LMSTable[1], LMSTextToToggleNeed)
			elseif string.match(LMSTable[1], "all") then
				CheatCoreLMS.HandleToggle(nil, nil, CheatCoreLMS.AllStatsToggle())
			end
		end
		
		if LMSText == "/firebrush" then
			CheatCoreLMS.HandleToggle("Fire Brush", "CheatCoreLMS.FireBrushEnabled")
		end
		
		if string.match(LMSText, "/zombiebrush ") then
			if CheatCoreLMS.ZombieBrushEnabled ~= true and string.gmatch(LMSTable[1], "%d+") then
				CheatCoreLMS.HandleToggle("Zombie Brush", "CheatCoreLMS.ZombieBrushEnabled", "CheatCoreLMS.ZombiesToSpawn = "..LMSTable[1])
			elseif CheatCoreLMS.ZombieBrushEnabled == true then
				if LMSTable[1] == "disable" or LMSTable[1] == "off" or LMSTable[1] == "toggle" or LMSTable[1] == "0" then
					CheatCoreLMS.HandleToggle("Zombie Brush", "CheatCoreLMS.ZombieBrushEnabled")
				end
			end
		end
		
		if string.match(LMSText, "/levelskill ") then
			if tonumber(LMSTable[2]) ~= nil and LMSTable[1] ~= "all" then
				loadstring("CheatCoreLMS.DoMaxSkill("..LMSTable[1]..", "..LMSTable[2]..")")()
			elseif LMSTable[1] == "all" then
				CheatCoreLMS.DoMaxAllSkills()
			end
		end
		
		if string.match(LMSText, "/settime ") and string.gmatch(LMSTable[1], "%d+") and LMSTable[2] ~= nil then
			CheatCoreLMS.SetTime(tonumber(LMSTable[1]), LMSTable[2])
		end
		
		if string.match(LMSText, "/barricadebrush ") then
			if string.gmatch(LMSTable[1], "%d+") and tonumber(LMSTable[1]) <= 4 then
				CheatCoreLMS.HandleToggle("Barricade Brush", nil, "CheatCoreLMS.HandleCheck('CheatCoreLMS.IsBarricade', 'Barricade Brush')", "CheatCoreLMS.BarricadeLevel = "..LMSTable[1])
			elseif CheatCoreLMS.IsBarricade == true then
				if LMSTable[1] == "disable" or LMSTable[1] == "off" or LMSTable[1] == "toggle" or LMSTable[1] == "0" then
					CheatCoreLMS.HandleToggle("Barricade Brush", "CheatCoreLMS.IsBarricade")
				end
			end
		end
		if string.match(LMSText, "/teleport ") then
			local coordTable = {}
			local isZ;
			for i = 1,#LMSTable do
				if string.gmatch(LMSTable[i], "%d+") then
					coordTable[i] = tonumber(LMSTable[i])
				end
				for i = 1,#coordTable do
					if #coordTable > 1 then
						if coordTable[3] ~= nil then
							isZ = true
						else
							coordTable[3] = getPlayer():getZ()
						end
						getPlayer():setX(coordTable[1]);
						getPlayer():setY(coordTable[2]);
						getPlayer():setZ(coordTable[3]);
						getPlayer():setLx(coordTable[1]);
						getPlayer():setLy(coordTable[2]);
						getPlayer():setLz(coordTable[3]);
					end
				end
			end
		end
		if string.match(LMSText, "/help") then
			LMSKeepVisible = true
			if LMSTable[1] ~= nil then
				if tonumber(LMSTable[1]) ~= nil then
					for i,v in ipairs(LMSHelp.general["page"..LMSTable[1]]) do
						LMSWindow:updateChat(v, true)
					end
				else
					LMSWindow:updateChat(LMSHelp.general.specificHelp[LMSTable[1]], true)
				end
			else
				for i,v in ipairs(LMSHelp.general.page1) do
					LMSWindow:updateChat(v, true)
				end
			end
		end
		if string.match(LMSText, "/additem ") then
			local base = "Base"
			local count = 1
			if LMSTable[3] ~= nil then
				base = LMSTable[3]
			end
			if tonumber(LMSTable[2]) ~= nil then
				count = tonumber(LMSTable[2])
			end
			for i = 1,count do
				getPlayer():getInventory():AddItem(base.."."..LMSTable[1])
			end
			if getPlayer():HasItem(LMSTable[1]) then
				getPlayer():Say(count.." "..LMSTable[1].."(s) from item base "..base.." added.")
			else
				LMSWindow:updateChat("Invalid item. Tip: They're case sensitive", true)
				LMSKeepVisible = true
			end
		end
		if string.match(LMSText, "/keybind ") then
			local keybind = ""
			local keyNumber = nil
			local commit = false
			local doNotWrite = false
			local overwriteLine;
			local isConflict;
			
			if LMSTable[1] ~= nil then
				LMSTable[1] = string.upper(LMSTable[1])
				if tonumber(LMSTable[1]) == nil then
					keybind = tostring(Keyboard.getKeyIndex(LMSTable[1]))
				else
					keybind = tostring(LMSTable[1])
				end
				keyNumber = keybind
			end
			
			for i = 1,#keyBinding do
				if tonumber(keyNumber) == keyBinding[i].key then
					LMSWindow:updateChat("Error: key conflict. The chosen keybind is the same as the keybind for "..keyBinding[i].value, true)
					LMSKeepVisible = true
					isConflict = true
				end
			end
			
			for i = 2,#LMSTable do
				if LMSTable[i] ~= nil then
					keybind = keybind.." "..LMSTable[i]
					if i == #LMSTable and isConflict ~= true then
						commit = true
					end
				end
			end
			if commit == true then
				if CheatCoreLMS.keyBindTable == nil then CheatCoreLMS.keyBindTable = {} end
				CheatCoreLMS.readFile("LetMeSpeak", "keybinds.txt")
				for k,v in pairs(CheatCoreLMS.fileTable) do
					for i in string.gmatch(v, "%S+") do
						if i == keyNumber then
							doNotWrite = true
							overwriteLine = k
						end
					end
				end
				
				if doNotWrite ~= true then
					CheatCoreLMS.fileTable[#CheatCoreLMS.fileTable + 1] = keybind
				else
					CheatCoreLMS.fileTable[overwriteLine] = keybind
				end
				
				CheatCoreLMS.writeFile(CheatCoreLMS.fileTable, "LetMeSpeak", "keybindings.txt")
				
				for k,v in pairs(CheatCoreLMS.fileTable) do
					local fileContents = {}
					local bindedCommand = ""
					for i in string.gmatch(v, "%S+") do
						fileContents[#fileContents+1] = i
					end
					for i = 2,#fileContents do
						bindedCommand = bindedCommand..fileContents[i]
					end
					CheatCoreLMS.keyBindTable[fileContents[1]] = bindedCommand
				end
				getPlayer():Say("Keybind successfully added.")
			end
		end
		if string.match(LMSText, "/unkeybind ") then
			local keybind = ""
			local keyNumber = nil
			local commit = false
			local doNotWrite = false
			local overwriteLine;
			local isConflict;
			
			if LMSTable[1] ~= nil then
				LMSTable[1] = string.upper(LMSTable[1])
				if tonumber(LMSTable[1]) == nil then
					keybind = tostring(Keyboard.getKeyIndex(LMSTable[1]))
				else
					keybind = tostring(LMSTable[1])
				end
			
				keyNumber = keybind
			end
			CheatCoreLMS.readFile("LetMeSpeak", "keybinds.txt")
			
			for k,v in pairs(CheatCoreLMS.fileTable) do
				for i in string.gmatch(v, "%S+") do
					if i == keyNumber then
						table.remove(CheatCoreLMS.fileTable, k)
						CheatCoreLMS.writeFile(CheatCoreLMS.fileTable, "LetMeSpeak", "keybindings.txt")
						CheatCoreLMS.keyBindTable[keyNumber] = nil
						getPlayer():Say("Keybind successfully removed.")
						break
					end
				end
			end
		end
		if string.match(LMSText, "/keybinds") then
			local list = ""
			if CheatCoreLMS.keyBindTable ~= nil then -- makes sure there are keybinds
				for k,v in pairs (CheatCoreLMS.keyBindTable) do
					list = list..v.." is bound to "..Keyboard.getKeyName(tonumber(k)).." <LINE> "
				end
				LMSWindow:updateChat(list, true)
				LMSKeepVisible = true
			else
				LMSWindow:updateChat("No key bindings have been set.", true) -- otherwise, display an error message
				LMSKeepVisible = true
			end
		end
		if string.match(LMSText, "/lua ") then
			local LMSTextToLua = string.gsub(LMSText, "/lua ", "")
			local loadLua = loadstring(LMSTextToLua)
			loadLua()
		end
	end
	
	if LMSDoNotClear ~= true and LMSDoNotHide ~= true and LMSKeepVisible ~= true then
		LMSWindow.LMSChatBar:clear();
		LMSWindow.LMSChatBar:unfocus();
		LMSWindow:setVisible(false);
	elseif LMSDoNotClear == true then
		LMSWindow.LMSChatBar:unfocus();
		LMSDoNotClear = false
	elseif LMSDoNotHide == true then
		LMSWindow.LMSChatBar:clear();
		LMSWindow.LMSChatBar:unfocus();
		LMSDoNotHide = false
	elseif LMSKeepVisible == true then
		LMSWindow.LMSChatBar:clear();
		LMSKeepVisible = false
	end
end