--		 _______________________________________________________________________
--		|																 	    |
--		|	-----------------------------------------------------------------	|
--		|	-----------------------------------------------------------------	|
--		|	----														 ----	|
--		|	----     ________               __     ______                ----	|
--		|	----    / ____/ /_  ___  ____ _/ /_   / ____/___  ________   ----	|
--		|	----   / /   / __ \/ _ \/ __ `/ __/  / /   / __ \/ ___/ _ \  ----	|
--		|	----  / /___/ / / /  __/ /_/ / /_   / /___/ /_/ / /  /  __/  ----	|
--		|	----  \____/_/ /_/\___/\__,_/\__/   \____/\____/_/   \___/   ----	|
--		|	----                                                         ----	|
--		|	----  													   	 ----	|
--		|	-----------------------------------------------------------------	|
--		|	-----------------------------------------------------------------	|
--		|_______________________________________________________________________|


CheatCoreLMS = {}

----------------------------------------------
--Needs/stats/whatever they're called toggle--
----------------------------------------------
CheatCoreLMS.ToggleAllStats = false
----------------------------------------------

CheatCoreLMS.SyncVariables = function() -- on game start, syncs up the enabled persistent cheats to the normal variables
	local notifyPlayer = {}
	local stringNotice = "Values Loaded: "
	
	if getPlayer():getModData().IsGhost == true then -- detects a persistent cheat
		CheatCoreLMS.IsGhost = true
		table.insert(notifyPlayer, "Ghost Mode, ") -- adds this to the table of enabled cheats
	else
		getPlayer():getModData().IsGhost = false
	end
	
	if getPlayer():getModData().IsGod == true then
		CheatCoreLMS.IsGod = true
		table.insert(notifyPlayer, "God Mode, ")
	else
		getPlayer():getModData().IsGod = false
	end
	
	if getPlayer():getModData().AreConditionsNotDisabled == false then
		LMSWindow.AreConditionsNotDisabled = false
		table.insert(notifyPlayer, "Conditional Speech Disabled, ")
	end
	
	if #notifyPlayer > 0 then -- if there are persistent cheats enabled, carries through with notifying the player
		for i = 1,#notifyPlayer do
			if i ~= #notifyPlayer then
				stringNotice = stringNotice..notifyPlayer[i]
			else
				--local subbedString = string.sub(stringNotice, -2) -- extracts last two characters, which are always ", ". just fixes a small grammatical annoyance that it would cause.
				local finishedString = string.gsub(notifyPlayer[i], ", ", "") -- replaces the characters extracted by subbedString with nothing
				stringNotice = stringNotice..finishedString
			end
		end
		print("[LET ME SPEAK] "..stringNotice) -- for TIS Support devs/staff/whatever. this is so that, in the event of a player forgetting a cheat was on and reporting it to the Support forum thinking it was a bug, the devs could take one look at the console and easily detect the persons mistake
		getPlayer():Say(stringNotice) -- lets player know which cheats are enabled
	end
end

CheatCoreLMS.HandleToggle = function(DisplayName, VariableToToggle, Optional, Optional2) -- CheatType is the string to add to the getPlayer():Say() function, VariableToToggle is the variable to toggle (woah, right?) in string form, and Optional is the optional function to call.
	if VariableToToggle ~= nil then
		local function convertVariable()
			if string.match(VariableToToggle, "CheatCoreLMS.") then
				return string.gsub(VariableToToggle, "CheatCoreLMS.", "")
			elseif string.match(VariableToToggle, "LMSWindow.") then
				return string.gsub(VariableToToggle, "LMSWindow.", "")
			else
				return false
			end
		end
		
		local function checkForBrushes()
			if VariableToToggle ~= "CheatCoreLMS.IsGod" and VariableToToggle ~= "CheatCoreLMS.IsGhost" and VariableToToggle ~= "LMSWindow.AreConditionsNotDisabled" or convertVariable() == false then
				return true
			else
				return false
			end
		end
		
		local checkForCheats;
		local returnCheats;
		
		if convertVariable() ~= false then
			checkForCheats = loadstring("return getPlayer():getModData()."..convertVariable())
			returnCheats = loadstring("getPlayer():getModData()."..convertVariable().." = not getPlayer():getModData()."..convertVariable())
		else
			checkForCheats = loadstring("return nil")
			returnCheats = nil
		end
		
		
		if loadstring("return "..VariableToToggle)() == nil then
			loadstring(VariableToToggle.." = false")()
			if not checkForBrushes() then
				loadstring("getPlayer():getModData()."..convertVariable().." = false")()
			end
		end
		if loadstring("return "..VariableToToggle)() == false or checkForCheats() == false then
			loadstring(VariableToToggle.." = true")() -- concatenates the VariableToToggle string into the " = true" statement, so that I no longer need dedicated toggle functions for every cheat.
			if not checkForBrushes() then
				returnCheats()
			end
			if DisplayName ~= nil then
				getPlayer():Say(DisplayName.." enabled.")
			end
		elseif loadstring("return "..VariableToToggle)() == true or checkForCheats() == true then
			loadstring(VariableToToggle.." = false")()
			if not checkForBrushes() then
				returnCheats()
			end
			if DisplayName ~= nil then
				getPlayer():Say(DisplayName.." disabled.")
			end
		end
		if not checkForBrushes() then
			loadstring(VariableToToggle.." = getPlayer():getModData()."..convertVariable())()
		end
		if VariableToToggle == "CheatCoreLMS.buildCheat" then
			ISBuildMenu.cheat = CheatCoreLMS.buildCheat
		end
	end
	if Optional ~= nil then -- checks if the OptionalCall argument was passed
		loadstring(Optional)()
	end
	if Optional2 ~= nil then
		loadstring(Optional2)()
	end
end

CheatCoreLMS.HandleCheck = function(variableToCheck, cheatName, optionalSecondVariable, optionalCheatName)
	local sayString = {}
	if loadstring("return "..variableToCheck)() ~= true then
		loadstring(variableToCheck.." = true")()
		table.insert(sayString, cheatName)
	end
	if optionalSecondVariable ~= nil then
		if loadstring("return "..optionalSecondVariable)() ~= true then
			loadstring(optionalSecondVariable.." = true")()
			table.insert(sayString, optionalCheatName)
		end
	end
	if #sayString > 1 then
		getPlayer():Say(cheatName.." And "..optionalCheatName.." Enabled")
	elseif #sayString == 1 then
		getPlayer():Say(cheatName.." Enabled")
	end
end
--[[ -- this was a beta. scrapped the newer HandleCheck because I didn't need it.
CheatCoreLMS.HandleCheck = function(variableToCheck, cheatName, optionalSecondVariable, optionalCheatName, doDisable, optionalDoDisable)
	local sayString = {}
	if loadstring("return "..variableToCheck)() ~= true or doDisable == true and loadstring("return "..variableToCheck)() == true then
		if doDisable ~= true then loadstring(variableToCheck.." = true")() else loadstring(variableToCheck.." = false")() end
		table.insert(sayString, cheatName)
	end
	if optionalSecondVariable ~= nil then
		if loadstring("return "..optionalSecondVariable)() ~= true then
			if optionalDoDisable ~= true then loadstring(optionalSecondVariable.." = true")() else loadstring(optionalSecondVariable.." = true")() end
			table.insert(sayString, optionalCheatName)
		end
	end
	if #sayString > 1 then
		local state1 = loadstring("return "..variableToCheck)()
		local state2 = loadstring("return "..optionalSecondVariable)()
		
		if state1 == true then state1 = " Enabled" else state1 = " Disabled" end
		if state2 == true then state2 = " Enabled" else state2 = " Disabled" end
		
		getPlayer():Say(cheatName..state1..", "..optionalCheatName..state2)
	else
		if doDisable ~= true then getPlayer():Say(cheatName.." Enabled") else getPlayer():Say(cheatName.." Disabled") end
	end
end
--]]
CheatCoreLMS.SetTime = function(TimeToSet, DayOrMonth)
	local time = getGameTime() -- gets game time
	local DayOrMonth = string.gsub(DayOrMonth, "%a", string.upper, 1)
	
	if DayOrMonth == "Time" and TimeToSet <= 24 then
		time:setTimeOfDay( TimeToSet ) -- sets game time to whatever was passed to it.
		getPlayer():Say("Time successfully changed to "..TimeToSet..":00.")
	end
	
	if DayOrMonth == "Day" then
		time:setDay( time:getDay() + TimeToSet )
		
		if time:getDay() == TimeToSet and time:getDay() <= time:daysInMonth(time:getYear(), time:getMonth()) then
			getPlayer():Say("Day successfully changed to "..TimeToSet)
		else 
			if time:getDay() >= time:daysInMonth(time:getYear(), time:getMonth()) then
				time:setMonth( time:getMonth() + 1 )
				time:setDay( TimeToSet - time:daysInMonth(time:getYear(), time:getMonth()) ) 
			end
		end
	end
	if DayOrMonth == "Month" then
		local roundToProperMonth = time:getMonth() + TimeToSet
		time:setMonth( time:getMonth() + TimeToSet )
		
		if time:getMonth() > 12 and TimeToSet <= 12 then
			time:setYear( time:getYear() + 1 )
			time:setMonth( roundToProperMonth - 12 )
		end
	end
	
	if DayOrMonth == "Year" or DayOrMonth == "year" then
		time:setYear( time:getYear() + TimeToSet )
	end
end

CheatCoreLMS.DoLearnRecipes = function()
	local recipes = getAllRecipes()
	for i = 0,recipes:size() - 1 do
		local recipe = recipes:get(i)
		if not getPlayer():isRecipeKnown(recipe) and recipe:needToBeLearn() then
			getPlayer():getKnownRecipes():add(recipe:getOriginalname())
			getPlayer():Say("All recipes learned.")
		end
	end
end

CheatCoreLMS.DoRefillAmmo = function()
    local primaryHandItemData = getPlayer():getPrimaryHandItem():getModData();
	primaryHandItemData.currentCapacity = primaryHandItemData.maxCapacity
end

CheatCoreLMS.DoMaxSkill = function(SkillToSet, ToLevel)
	getPlayer():getXp():setXPToLevel(SkillToSet, tonumber(ToLevel));
	getPlayer():setNumberOfPerksToPick(tonumber(ToLevel));
end

CheatCoreLMS.DoGhostMode = function()
	if not getPlayer():isGhostMode() and CheatCoreLMS.IsGhost == true or not getPlayer():isGhostMode() and getPlayer():getModData().IsGhost == true then -- checks if player is already ghostmode
		getPlayer():setGhostMode(true)
	elseif CheatCoreLMS.IsGhost == false then
		getPlayer():setGhostMode(false)
	end
end

CheatCoreLMS.DoRepair = function()
	local ToolToRepair = getPlayer():getPrimaryHandItem() -- gets the item in the players hand
	ToolToRepair:setCondition( getPlayer():getPrimaryHandItem():getConditionMax() ) -- gets the maximum condition and sets it to it
end

CheatCoreLMS.SpawnZombieNow = function()
	if CheatCoreLMS.ZombieBrushEnabled == true then
		local mx = getMouseXScaled();
		local my = getMouseYScaled();
		local player = getPlayer();
		local wz = player:getZ();
		local wx, wy = ISCoordConversion.ToWorld(mx, my, wz);
		local versionNumber = tonumber(string.match(getCore():getVersionNumber(), "%d+")) -- saves version number to variable, for checking versions
	
		if versionNumber <= 31 then -- checks for build 31 and below
			for i = 1,CheatCoreLMS.ZombiesToSpawn do
				getVirtualZombieManager():createRealZombieNow(wx,wy,wz);
			end
		else
			if versionNumber >= 32 then -- handles this differently if it is build 32 or above
				spawnHorde(wx,wy,wx,wy,wz,CheatCoreLMS.ZombiesToSpawn)
			end
		end
	end
end

CheatCoreLMS.DoHeal = function()
	getPlayer():Say("Player healed.")
	getPlayer():getBodyDamage():RestoreToFullHealth();
end

CheatCoreLMS.doRound = function(number)
	return number % 1 >= 0.5 and math.ceil(number) or math.floor(number)
end

CheatCoreLMS.readFile = function(modID, fileName, tableIndex, numberOfLines, optionalMatchLine)
	if CheatCoreLMS.fileTable == nil then
		CheatCoreLMS.fileTable = {}
	end
	local readFile = getModFileReader(modID, fileName, true)
	if numberOfLines ~= nil then
		for i = 1,numberOfLines do
			local scanLine = readFile:readLine()
			if scanLine ~= nil then
				CheatCoreLMS.fileTable[i] = scanLine
			else
				CheatCoreLMS.fileTable[i] = " "
			end
		end
		readFile:close()
	else
		local count = 0
		local function keepScanning()
			local scanLine = readFile:readLine()
			if scanLine ~= nil then
				count = count + 1
				if optionalMatchLine == nil then
					CheatCoreLMS.fileTable[count] = scanLine
				else
					if scanLine ~= optionalMatchLine then
						keepScanning()
					else
						return scanLine
					end
				end
				keepScanning()
			end
		end
		keepScanning()
	end
end

CheatCoreLMS.setHome = function(homeNumber)
	loadstring("CheatCoreLMS.Home"..tostring(homeNumber).."X = "..CheatCoreLMS.doRound(getPlayer():getX()))()
	loadstring("CheatCoreLMS.Home"..tostring(homeNumber).."Y = "..CheatCoreLMS.doRound(getPlayer():getY()))()
	local returnX = loadstring("return CheatCoreLMS.Home"..tostring(homeNumber).."X")
	local returnY = loadstring("return CheatCoreLMS.Home"..tostring(homeNumber).."Y")
	CheatCoreLMS.readFile("cheatmenu", "SavedHomes.txt", 5)
	CheatCoreLMS.fileTable[homeNumber] = "Home"..tostring(homeNumber).." "..returnX().." "..returnY()
	CheatCoreLMS.writeFile(CheatCoreLMS.fileTable, "cheatmenu", "SavedHomes.txt")
end

CheatCoreLMS.writeFile = function(tableToWrite, modID, fileName)
	local writeFile = getModFileWriter(modID, fileName, true, false)
	for i = 1,#tableToWrite do
		writeFile:write(tableToWrite[i].."\r\n");
	end
	writeFile:close();
end

CheatCoreLMS.checkCoords = function(number1, number2)
	local doRound = CheatCoreLMS.doRound(number2)
	if doRound >= number1 then
		return doRound - number1
	else
		return number1 - doRound
	end
end

CheatCoreLMS.updateCompass = function()
	local newText = "";
	for i,v in ipairs(ISUICheatWindow.compassLines) do
		if i == #ISUICheatWindow.compassLines then
			v = string.gsub(v, " <LINE> $", "") 
		end
		newText = newText .. v;
	end
	ISUICheatWindow.HomeWindow.text = newText
	ISUICheatWindow.HomeWindow:paginate()
end

CheatCoreLMS.returnDirection = function(X, Y) -- unused
	local wx, wy = getPlayer():getX(), getPlayer():getY()
	wx = math.floor(wx);
	wy = math.floor(wy);
	local cell = getWorld():getCell();
	local sq = cell:getGridSquare(wx, wy, getPlayer():getZ());
	local sqObjs = sq:getObjects();
	local sqSize = sqObjs:size();
	for i = sqSize-1, 0, -1 do
		local obj = sqObjs:get(i);
		local direction = getDirectionTo(getPlayer(), obj)
		if direction == "N" then
			return "North"
		elseif direction == "NW" then
			return "North East"
		elseif direction == "NE" then
			return "North West"
		elseif direction == "S" then
			return "South"
		elseif direction == "SW" then
			return "South West"
		elseif direction == "SE" then
			return "South East"
		elseif direction == "W" then
			return "West"
		elseif direction == "E" then
			return "East"
		end
	end
end

CheatCoreLMS.updateCoords = function()
	if ISUICheatWindow ~= nil then
		if ISUICheatWindow:getIsVisible() then
			ISUICheatWindow.compassLines[2] = "-------------Your Coords-------------".." <LINE> ".."X: "..CheatCoreLMS.doRound(getPlayer():getX()).." Y: "..CheatCoreLMS.doRound(getPlayer():getY()).." <LINE> "
			if CheatCoreLMS.MarkedX ~= nil and CheatCoreLMS.MarkedY ~= nil then	
				ISUICheatWindow.compassLines[1] = "-----"..CheatCoreLMS.DisplayName.." Coords-----".." <LINE> ".."X: "..CheatCoreLMS.MarkedX.." Y: "..CheatCoreLMS.MarkedY.." <LINE> "
				ISUICheatWindow.compassLines[3] = "-----Distance to Destination-----".." <LINE> ".."X: "..CheatCoreLMS.checkCoords(tonumber(CheatCoreLMS.MarkedX), getPlayer():getX()).." Y: "..CheatCoreLMS.checkCoords(tonumber(CheatCoreLMS.MarkedY), getPlayer():getY()).." <LINE> "
				--ISUICheatWindow.compassLines[4] = "-----Direction to Destination-----".." <LINE> "..CheatCoreLMS.returnDirection()
			end
			CheatCoreLMS.updateCompass()
		end
	end
end

CheatCoreLMS.markHome = function(homeNumber, optionalDestinationName, optionalX, optionalY, optionalDoTeleport)
	local splitTable = {}
	local tableKey = 0
	if homeNumber ~= nil and homeNumber ~= 0 then
		CheatCoreLMS.readFile("cheatmenu", "SavedHomes.txt", 5)
		for i in string.gmatch(CheatCoreLMS.fileTable[homeNumber], "%S+") do
			splitTable[tableKey] = i
			tableKey = tableKey + 1
		end
		CheatCoreLMS.DisplayName = "Home"..homeNumber
		CheatCoreLMS.MarkedX = splitTable[1]
		CheatCoreLMS.MarkedY = splitTable[2]
	elseif homeNumber == 0 or homeNumber == nil then
		CheatCoreLMS.DisplayName = optionalDestinationName
		CheatCoreLMS.MarkedX = optionalX
		CheatCoreLMS.MarkedY = optionalY
	end
	if optionalDoTeleport ~= true and not ISUICheatWindow:getIsVisible() then
		ISUICheatWindow:setVisible(true);
		CheatCoreLMS.updateCoords()
	elseif optionalDoTeleport == true then
		getPlayer():setX(tonumber(CheatCoreLMS.MarkedX));
		getPlayer():setY(tonumber(CheatCoreLMS.MarkedY));
		getPlayer():setZ(0);
		getPlayer():setLx(getPlayer():getX());
		getPlayer():setLy(getPlayer():getY());
		getPlayer():setLz(getPlayer():getZ());
	end
end

--end of the custom Cheat Menu home functions--

CheatCoreLMS.OnKeyKeepPressed = function(_keyPressed)

	---------------
	--Delete Mode--
	---------------
	if CheatCoreLMS.IsDelete == true and _keyPressed == 45 then
		local mx = getMouseXScaled();
		local my = getMouseYScaled();
		local wz = getPlayer():getZ();
		local wx, wy = ISCoordConversion.ToWorld(mx, my, wz);
		wx = math.floor(wx);
		wy = math.floor(wy);
		local cell = getWorld():getCell();
		local sq = cell:getGridSquare(wx, wy, wz);
		
		if not sq:getFloor() and CheatCoreLMS.IsTerraforming == true and CheatCoreLMS.DoNotFill ~= true then
			local rand;
			if #CheatCoreLMS.TerraformRanges > 1 then
				rand = ZombRand(CheatCoreLMS.TerraformRanges[1],CheatCoreLMS.TerraformRanges[2] + 1)
				if CheatCoreLMS.BannedRanges ~= nil then
					for i = 1,#CheatCoreLMS.BannedRanges do
						if rand == CheatCoreLMS.BannedRanges[i] then
							rand = rand + ZombRand(1,2 + 1) <= CheatCoreLMS.TerraformRanges[2] or rand - ZombRand(1,2 + 1) 
						end
					end
				end
			else
				rand = CheatCoreLMS.TerraformRanges[1]
			end
			local generatedTile = CheatCoreLMS.Terraform..tostring(rand)
			
			local obj = IsoObject.new(cell, sq, generatedTile)
			sq:AddTileObject(obj)
		end
		
		local sqObjs = sq:getObjects();
		local sqSize = sqObjs:size();
		for i = sqSize-1, 0, -1 do
			local obj = sqObjs:get(i);
			--print(obj:getSprite():getName())
			if getPlayer():getZ() == sq:getZ() then -- checks for floor on ground, otherwise it'd leave a gaping hole
				local stairObjects = buildUtil.getStairObjects(obj)
				if #stairObjects > 0 then
					for i=1,#stairObjects do
						stairObjects[i]:getSquare():RemoveTileObject(stairObjects[i])
					end
				else
					if CheatCoreLMS.DoNotDeleteFloor ~= true and i > 0 or CheatCoreLMS.DoNotDeleteFloor ~= true and sq:getZ() > 0 or CheatCoreLMS.DoNotDeleteFloor == true and i > 0 or CheatCoreLMS.IsTerraforming == true then
						if CheatCoreLMS.IsTerraforming ~= true then
							--if obj:getSprite():getName() == "carpentry_02_56" then
								--sq:RemoveTileObject(obj)
							--end
							sq:RemoveTileObject(obj)
							sq:getSpecialObjects():remove(obj);
							sq:getObjects():remove(obj);
						end
						if CheatCoreLMS.IsTerraforming == true then
							local rand;
							if #CheatCoreLMS.TerraformRanges > 1 then
								rand = ZombRand(CheatCoreLMS.TerraformRanges[1],CheatCoreLMS.TerraformRanges[2] + 1)
								if CheatCoreLMS.BannedRanges ~= nil then
									for i = 1,#CheatCoreLMS.BannedRanges do
										if rand == CheatCoreLMS.BannedRanges[i] then
											rand = rand + ZombRand(1,2 + 1) <= CheatCoreLMS.TerraformRanges[2] or rand - ZombRand(1,2 + 1) 
										end
									end
								end
							else
								rand = CheatCoreLMS.TerraformRanges[1]
							end
							local generatedTile = CheatCoreLMS.Terraform..tostring(rand)
							if generatedTile ~= obj:getSprite():getName() then
								sq:getSpecialObjects():remove(obj);
								sq:getObjects():remove(obj);
								sq:addFloor(generatedTile)
							end
						end
					end
				end
			end
		end
	end
end

CheatCoreLMS.OnKeyPressed = function(_keyPressed)

	-------------------
	--Barricade Brush--
	-------------------
	if CheatCoreLMS.IsBarricade == true and _keyPressed == 44 then
		local mx = getMouseXScaled();
		local my = getMouseYScaled();
		local wz = getPlayer():getZ();
		local wx, wy = ISCoordConversion.ToWorld(mx, my, wz);
		wx = math.floor(wx);
		wy = math.floor(wy);
		local cell = getWorld():getCell();
		local sq = cell:getGridSquare(wx, wy, wz);
		local sqObjs = sq:getObjects();
		local sqSize = sqObjs:size();
		local planks = {}
		local worldobjects = sq:getWorldObjects()
		local previousPlanks = getPlayer():getInventory():getNumberOfItem("Plank") -- I store the count of the players nails and planks for later use
		local previousNails = getPlayer():getInventory():getNumberOfItem("Nails")
		local previousEquippedItem = getPlayer():getSecondaryHandItem()
		local hasAddedHammer = false
		local removalCount = 0
		local objectToBarricade;
		local barricadeLevel;
		
		if getPlayer():getSecondaryHandItem() ~= "Hammer" and getPlayer():getInventory():contains("Hammer") then -- checks if the player has a hammer equipped
			ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), getPlayer():getInventory():FindAndReturn("Hammer"), 0, false, false));
		elseif not getPlayer():getInventory():contains("Hammer") then
			hasAddedHammer = true
			getPlayer():getInventory():AddItem("Base.Hammer")
			ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), getPlayer():getInventory():FindAndReturn("Hammer"), 0, false, false));
		end
		
		CheatCoreLMS.syncInventory = function()
			getPlayer():getInventory():RemoveAll("Plank") -- I remove all planks and nails from the inventory, and re-add them later.
			getPlayer():getInventory():RemoveAll("Nails")
			if previousPlanks ~= 0 then
				for i = 1,previousPlanks do
					getPlayer():getInventory():AddItem("Base.Plank")
				end
			end
			if previousNails ~= 0 then
				for i = 1,previousNails do
					getPlayer():getInventory():AddItem("Base.Nails")
					for i = 1,4 do -- for some reason, adding Base.Nails once gives 5 nails. I remove 4 from every iteration to return the exact number of nails the player had in his inventory beforehand.
						getPlayer():getInventory():RemoveOneOf("Nails")
					end
				end
			end
			if previousEquippedItem ~= nil then
				ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), previousEquippedItem, 0, false, false));
				if hasAddedHammer == true then
					getPlayer():getInventory():RemoveOneOf("Hammer")
				end
			end
		end
		
		for i = sqSize-1, 0, -1 do
			local obj = sqObjs:get(i);
			if instanceof(obj, "IsoWindow") or instanceof(obj, "IsoWoodenWall") or instanceof(obj, "IsoDoor") or instanceof(obj, "IsoThumpable") then
				objectToBarricade = obj -- I store the returned instance into a variable
				barricadeLevel = obj:getBarricade()
				if CheatCoreLMS.BarricadeDoDelete == true and barricadeLevel > 0 then
					ISTimedActionQueue.add(ISUnbarricadeAction:new(getPlayer(), objectToBarricade, 0))
					CheatCoreLMS.doWait = os.date("%S") -- waits for the planks from ISUnbarricadeAction to be added
					CheatCoreLMS.canSync = true
				elseif CheatCoreLMS.BarricadeDoDelete ~= true and barricadeLevel < 4 then
					for i = 1,CheatCoreLMS.BarricadeLevel do
						getPlayer():getInventory():AddItem("Base.Plank") -- I add the necessary amount of planks and nails required to barricade the object.
						getPlayer():getInventory():AddItem("Base.Nails")
						for i = 1,4 do
							getPlayer():getInventory():RemoveOneOf("Nails")
						end
						local requiredPlanks = getPlayer():getInventory():getNumberOfItem("Plank")
						local requiredNails = getPlayer():getInventory():getNumberOfItem("Nails")
						ISTimedActionQueue.add(ISBarricadeAction:new(getPlayer(), objectToBarricade, 0));
						if CheatCoreLMS.BarricadeLevel ~= 1 then
							if i == CheatCoreLMS.BarricadeLevel and requiredPlanks == requiredPlanks * CheatCoreLMS.BarricadeLevel and requiredNails == requiredNails * CheatCoreLMS.BarricadeLevel then
								CheatCoreLMS.syncInventory()
							end
						end
					end
				end
			end
		end
	end
	
	------------
	--Fly Mode--
	------------
	
	if CheatCoreLMS.IsFly == true then
		if CheatCoreLMS.FlightHeight == nil then CheatCoreLMS.FlightHeight = 0 end -- makes sure that it's a number
		
		if _keyPressed == 200 and getPlayer():getZ() < 5 then -- checks for up arrow and makes sure the players height isn't above the game's limit. note for anyone viewing this code: if this isn't the height limit for your game (either through mods or vanilla updates), feel free to change it
			CheatCoreLMS.FlightHeight = CheatCoreLMS.FlightHeight + 1
		elseif _keyPressed == 208 and getPlayer():getZ() > 0 then
			CheatCoreLMS.FlightHeight = CheatCoreLMS.FlightHeight - 1
		end
	end
	
end

CheatCoreLMS.DoFireNow = function()
	if CheatCoreLMS.FireBrushEnabled == true then
		local mx = getMouseXScaled();
		local my = getMouseYScaled();
		local player = getPlayer();
		local wz = math.floor(player:getZ());
		local wx, wy = ISCoordConversion.ToWorld(mx, my, wz);
		wx = math.floor(wx);
		wy = math.floor(wy);
		local cell = getWorld():getCell();
		local GridToBurn = cell:getGridSquare(wx, wy, wz)
		GridToBurn:StartFire();
	end
end

CheatCoreLMS.DoCarryweightCheat = function()
	--[[
	if CheatCoreLMS.ItemWeightTable == nil then -- this was a beta. It was scrapped in favor for an item with -99999 weight to prevent issues with dropping, but it's still fully functional (despite there being no trigger, as I do that after the initial testing phase)
		CheatCoreLMS.ItemWeightTable = {}
	end
	local inv = getPlayer():getInventory()
	local invItems = inv:getItems()
	for i = 0, invItems:size() -1 do
		local item = invItems:get(i)
		
		if CheatCoreLMS.ItemWeightTable[item:getDisplayName()] == nil then
			CheatCoreLMS.ItemWeightTable[item:getDisplayName()] = item:getActualWeight()
		end
		item:setActualWeight(0)
	end

	local inv = getPlayer():getInventory()
	local invItems = inv:getItems()
	for k,v in pairs(CheatCoreLMS.ItemWeightTable) do
		for i = 0, invItems:size() -1 do
			local item = invItems:get(i)
			if item:getDisplayName() == k then
				item:setActualWeight(v)
			end
		end
	end
	--]]
	if not getPlayer():getInventory():contains("CMInfiniteCarryweight") then
		getPlayer():Say("Infinite Carryweight Enabled.")
		getPlayer():getInventory():AddItem("cheatmenu.CMInfiniteCarryweight")
		getPlayer():setMaxWeightBase( 999999 );
	else
		getPlayer():Say("Infinite Carryweight Disabled.")
		getPlayer():getInventory():RemoveOneOf("CMInfiniteCarryweight")
		getPlayer():setMaxWeightBase( 8 );
	end
end
CheatCoreLMS.AllStatsToggle = function()
	if CheatCoreLMS.ToggleAllStats == false then
		getPlayer():Say("Infinite stats enabled.")
		CheatCoreLMS.IsHunger = true
		CheatCoreLMS.IsThirst = true
		CheatCoreLMS.IsPanic = true
		CheatCoreLMS.IsSanity = true
		CheatCoreLMS.IsStress = true
		CheatCoreLMS.IsBoredom = true
		CheatCoreLMS.IsAnger = true
		CheatCoreLMS.IsPain = true
		CheatCoreLMS.IsSick = true
		CheatCoreLMS.IsEndurance = true
		CheatCoreLMS.IsFitness = true
		CheatCoreLMS.IsSleep = true
		CheatCoreLMS.IsTemperature = true
		CheatCoreLMS.IsWet = true
		CheatCoreLMS.IsDrunk = true
		CheatCoreLMS.IsUnhappy = true
		
		CheatCoreLMS.ToggleAllStats = true
	else
		getPlayer():Say("Infinite stats disabled.")
		CheatCoreLMS.IsHunger = false
		CheatCoreLMS.IsThirst = false
		CheatCoreLMS.IsPanic = false
		CheatCoreLMS.IsSanity = false
		CheatCoreLMS.IsStress = false
		CheatCoreLMS.IsBoredom = false
		CheatCoreLMS.IsAnger = false
		CheatCoreLMS.IsPain = false
		CheatCoreLMS.IsSick = false
		CheatCoreLMS.IsEndurance = false
		CheatCoreLMS.IsFitness = false
		CheatCoreLMS.IsSleep = false
		CheatCoreLMS.IsTemperature = false
		CheatCoreLMS.IsWet = false
		CheatCoreLMS.IsDrunk = false
		CheatCoreLMS.IsUnhappy = false
		
		CheatCoreLMS.ToggleAllStats = false
	end
end

CheatCoreLMS.DoCheats = function()
	
	if CheatCoreLMS.IsGod == true or getPlayer():getModData().IsGod == true then
		getPlayer():getBodyDamage():RestoreToFullHealth();
	end
	
	if CheatCoreLMS.IsAmmo == true then
		local primaryHandItemData = getPlayer():getPrimaryHandItem():getModData();
		if primaryHandItemData.currentCapacity >= 0 then
			primaryHandItemData.currentCapacity = primaryHandItemData.maxCapacity
		end
	end
	
	CheatCoreLMS.DoGhostMode()
	
	if CheatCoreLMS.IsHunger == true then
		getPlayer():getStats():setHunger(0);
	end
	
	if CheatCoreLMS.IsThirst == true then
		getPlayer():getStats():setThirst(0);
	end
	
	if CheatCoreLMS.IsPanic == true then
		getPlayer():getStats():setPanic(0);
	end
	
	if CheatCoreLMS.IsSanity == true then
		getPlayer():getStats():setSanity(1);
	end
	
	if CheatCoreLMS.IsStress == true then
		getPlayer():getStats():setStress(0);
	end
	
	if CheatCoreLMS.IsBoredom == true then
		getPlayer():getStats():setBoredom(0);
	end
	
	if CheatCoreLMS.IsAnger == true then
		getPlayer():getStats():setAnger(0);
	end
	
	if CheatCoreLMS.IsPain == true then
		getPlayer():getStats():setPain(0);
	end
	
	if CheatCoreLMS.IsSick == true then
		getPlayer():getStats():setSickness(0)
	end
	
	if CheatCoreLMS.IsEndurance == true then
		getPlayer():getStats():setEndurance(1);
	end
	
	if CheatCoreLMS.IsFitness == true then
		getPlayer():getStats():setFitness(1);
	end
	
	if CheatCoreLMS.IsSleep == true then
		getPlayer():getStats():setFatigue(0);
	end
	
	if CheatCoreLMS.IsTemperature == true then
		getPlayer():getBodyDamage():setTemperature(30);
	end
	
	if CheatCoreLMS.IsWet == true then
		getPlayer():getBodyDamage():setWetness(0);
	end
	
	if CheatCoreLMS.IsDrunk == true then
		getPlayer():getStats():setDrunkenness(0);
	end
	
	if CheatCoreLMS.IsUnhappy == true then
		getPlayer():getBodyDamage():setUnhappynessLevel(0);
	end
	
	if getPlayer():getBodyDamage():getHealth() <= 5 and CheatCoreLMS.DoPreventDeath == true then
		getPlayer():getBodyDamage():RestoreToFullHealth();
	end
	
	if CheatCoreLMS.IsRepair == true and getPlayer():getPrimaryHandItem():getCondition() ~= getPlayer():getPrimaryHandItem():getConditionMax() then
		CheatCoreLMS.DoRepair()
	end
end

CheatCoreLMS.DoTickCheats = function()
	if getPlayer():getBodyDamage():getHealth() <= 5 and CheatCoreLMS.DoPreventDeath == true then
		getPlayer():getBodyDamage():RestoreToFullHealth();
	end
	
	if CheatCoreLMS.IsMelee == true and CheatCoreLMS.SavedWeapon ~= getPlayer():getPrimaryHandItem() and not getPlayer():getPrimaryHandItem():isRanged() and CheatCoreLMS.doWait ~= os.date("%S") then
		CheatCoreLMS.DoWeaponDamage(true)
	elseif CheatCoreLMS.IsMelee == true and CheatCoreLMS.HasSwitchedWeapon ~= getPlayer():getPrimaryHandItem():getName() and getPlayer():getPrimaryHandItem():isRanged() then
		CheatCoreLMS.DoWeaponDamage()
	end
	
	if CheatCoreLMS.doWait ~= nil and os.date("%S") ~= CheatCoreLMS.doWait and CheatCoreLMS.canSync == true then
		CheatCoreLMS.canSync = false
		CheatCoreLMS.syncInventory()
		CheatCoreLMS.doWait = nil
	end
	
	if CheatCoreLMS.IsFly == true and CheatCoreLMS.FlightHeight ~= nil then
		getPlayer():setZ(CheatCoreLMS.FlightHeight) -- makes sure the player doesn't fall
		
		local wz = math.floor(getPlayer():getZ())
		local wx,wy = math.floor(getPlayer():getX()), math.floor(getPlayer():getY())
		local cell = getWorld():getCell()
		local sq = cell:getGridSquare(wx,wy,wz);
		

		if wz > 0 then
			if sq == nil then
				sq = IsoGridSquare.new(cell, nil, wx, wy, wz)
				cell:ConnectNewSquare(sq, false)
			end
			
			sq = cell:getGridSquare(wx + 1,wy + 1,wz);
			
			if sq == nil then
				sq = IsoGridSquare.new(cell, nil, wx + 1, wy + 1, wz)
				cell:ConnectNewSquare(sq, false)
			end
		end
	end
end

CheatCoreLMS.DoWeaponDamage = function(hasSwitched)

	local weapon = getPlayer():getPrimaryHandItem()
	local secondaryWeapon = getPlayer():getSecondaryHandItem()
	--[[
	local originalMinDamage;
	local originalMaxDamage;
	local originalDoorDamage;
	local originalTreeDamage;
	]]
		
		
	if CheatCoreLMS.IsMelee == true and not getPlayer():getPrimaryHandItem():isRanged() and hasSwitched ~= true then
	
		CheatCoreLMS.SavedWeapon = getPlayer():getPrimaryHandItem()
		CheatCoreLMS.SecondarySavedWeapon = getPlayer():getSecondaryHandItem()
		--[[
		originalMinDamage = weapon:getMinDamage() -- gets the original value, to make it toggleable
		originalMaxDamage = weapon:getMaxDamage()
		originalDoorDamage = weapon:getDoorDamage()
		originalTreeDamage = weapon:getTreeDamage()
		--]]
		weapon:setMinDamage( weapon:getMinDamage() + 999 );
		weapon:setMaxDamage( weapon:getMaxDamage() + 999 );
		weapon:setDoorDamage( weapon:getDoorDamage() + 999 );
		weapon:setTreeDamage( weapon:getTreeDamage() + 999 );
		CheatCoreLMS.InstaKillCheatInitialized = true
	elseif CheatCoreLMS.IsMelee == true and getPlayer():getPrimaryHandItem():isRanged() == true or hasSwitched == true and CheatCoreLMS.IsMelee == true then
		local isSavedWeaponTwoHanded = false
		local isTwoHanded = false
		CheatCoreLMS.InstaKillCheatInitialized = true
		
		if secondaryWeapon == weapon then isTwoHanded = true end -- checks if the equipped items are actually one two handed weapon
		if CheatCoreLMS.SavedWeapon == CheatCoreLMS.SecondarySavedWeapon then isSavedWeaponTwoHanded = true end
		
		ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), CheatCoreLMS.SavedWeapon, 0, true, isSavedWeaponTwoHanded)); -- equips last valid melee weapon
		--[[
		CheatCoreLMS.SavedWeapon:setMinDamage( CheatCoreLMS.SavedWeapon:getMinDamage() - 999 ); -- returns the original weapon values
		CheatCoreLMS.SavedWeapon:setMaxDamage( CheatCoreLMS.SavedWeapon:getMaxDamage() - 999 );
		CheatCoreLMS.SavedWeapon:setDoorDamage( CheatCoreLMS.SavedWeapon:getDoorDamage() - 999 );
		CheatCoreLMS.SavedWeapon:setTreeDamage( CheatCoreLMS.SavedWeapon:getTreeDamage() - 999 );
		--]]
		
		if hasSwitched == true then -- refreshes values, if it's a melee weapon. does this to ensure cheat continuity.
			CheatCoreLMS.SavedWeapon:setMinDamage( CheatCoreLMS.SavedWeapon:getMinDamage() - 999 ); -- returns the original weapon values
			CheatCoreLMS.SavedWeapon:setMaxDamage( CheatCoreLMS.SavedWeapon:getMaxDamage() - 999 );
			CheatCoreLMS.SavedWeapon:setDoorDamage( CheatCoreLMS.SavedWeapon:getDoorDamage() - 999 );
			CheatCoreLMS.SavedWeapon:setTreeDamage( CheatCoreLMS.SavedWeapon:getTreeDamage() - 999 );
			
			CheatCoreLMS.doWait = os.date("%S") -- prevents an infinite loop from occurring
			
			ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), weapon, 0, true, isTwoHanded)); -- now that we're done, I re-equip the current (changed) weapon
			
			CheatCoreLMS.SavedWeapon = getPlayer():getPrimaryHandItem()
			CheatCoreLMS.SecondarySavedWeapon = getPlayer():getSecondaryHandItem()
			
			local weapon = getPlayer():getPrimaryHandItem()
			
			weapon:setMinDamage( weapon:getMinDamage() + 999 );
			weapon:setMaxDamage( weapon:getMaxDamage() + 999 );
			weapon:setDoorDamage( weapon:getDoorDamage() + 999 );
			weapon:setTreeDamage( weapon:getTreeDamage() + 999 );
			
			getPlayer():Say("Reinitialized Melee Insta-Kill cheat.")
		else
			ISTimedActionQueue.add(ISEquipWeaponAction:new(getPlayer(), weapon, 0, true, isTwoHanded)); -- now that we're done, I re-equip the current non-melee weapon
			getPlayer():Say("Non-melee weapon detected! Melee Insta-Kill disabled.")
			CheatCoreLMS.IsMelee = false
		end
	end
	if CheatCoreLMS.IsMelee == false and CheatCoreLMS.InstaKillCheatInitialized == true then
		CheatCoreLMS.InstaKillCheatInitialized = false
		CheatCoreLMS.SavedWeapon:setMinDamage( CheatCoreLMS.SavedWeapon:getMinDamage() - 999 ); -- returns the original weapon values
		CheatCoreLMS.SavedWeapon:setMaxDamage( CheatCoreLMS.SavedWeapon:getMaxDamage() - 999 );
		CheatCoreLMS.SavedWeapon:setDoorDamage( CheatCoreLMS.SavedWeapon:getDoorDamage() - 999 );
		CheatCoreLMS.SavedWeapon:setTreeDamage( CheatCoreLMS.SavedWeapon:getTreeDamage() - 999 );
		--[[
		if weapon == secondaryWeapon then
			secondaryWeapon:setMinDamage( originalMinDamage ); -- returns the original weapon values
			secondaryWeapon:setMaxDamage( originalMaxDamage );
			secondaryWeapon:setDoorDamage( originalDoorDamage );
			secondaryWeapon:setTreeDamage( originalTreeDamage );
		end
		--]]
	end	
end

CheatCoreLMS.DoNoReload = function()

	if CheatCoreLMS.IsMelee == true then -- checks to make sure that IsMelee is enabled, and if it is then it disables it.
		CheatCoreLMS.DoWeaponDamage()
	end
	
	
	local weapon = getPlayer():getPrimaryHandItem()
	
	
	if CheatCoreLMS.NoReload == true then
		originalRecoilDelay = weapon:getRecoilDelay() -- again, saves the normal values into variables
		
		weapon:setRecoilDelay( 0 ) -- due to how the games code works, I can't set it under 0, or the class file that handles this function will just set it back to 0.
	end
	
	if CheatCoreLMS.NoReload == false then
		weapon:setRecoilDelay( originalRecoilDelay ) -- and again, it then restores the old values when disabled
	end
end

CheatCoreLMS.DoMaxAllSkills = function()

		getPlayer():Say("All skills maxed!")
		
		local player = getPlayer():getXp()
		
		player:setXPToLevel(Perks.Sprinting, 10);
		player:setXPToLevel(Perks.Lightfoot, 10);
		player:setXPToLevel(Perks.Nimble, 10);
		player:setXPToLevel(Perks.Sneak, 10);
		player:setXPToLevel(Perks.Cooking, 10);
		player:setXPToLevel(Perks.Woodwork, 10);
		player:setXPToLevel(Perks.Farming, 10);
		player:setXPToLevel(Perks.Axe, 10);
		player:setXPToLevel(Perks.Blunt, 10);
		player:setXPToLevel(Perks.Aiming, 10);
		player:setXPToLevel(Perks.Reloading, 10);
		player:setXPToLevel(Perks.Fishing, 10);
		player:setXPToLevel(Perks.Trapping, 10);
		player:setXPToLevel(Perks.BluntGuard, 10);
		player:setXPToLevel(Perks.BluntMaintenance, 10);
		player:setXPToLevel(Perks.BladeGuard, 10);
		player:setXPToLevel(Perks.BladeMaintenance, 10);
		player:setXPToLevel(Perks.PlantScavenging, 10);
		player:setXPToLevel(Perks.Doctor, 10);
		player:setXPToLevel(Perks.Electricity, 10);
		
		getPlayer():setNumberOfPerksToPick(10*20);
		
end

CheatCoreLMS.OnGameStart = function()
	--[[
	if getPlayer():getInventory():contains("CMInfiniteCarryweight") then
		getPlayer():getInventory():RemoveOneOf("CMInfiniteCarryweight")
	end
	--]]
	CheatCoreLMS.keyBindTable = {}
	CheatCoreLMS.readFile("LetMeSpeak", "keybindings.txt")
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
end

CheatCoreLMS.HandleKeyBinds = function(_keyPressed)
	if LMSWindow ~= nil then
		if not LMSWindow:getIsVisible() then
			if CheatCoreLMS.keyBindTable ~= nil then
				for k,v in pairs(CheatCoreLMS.keyBindTable) do
					if tonumber(k) == _keyPressed then
						ISTextEntryBox:doCommand(v)
					end
				end
			end
		end
	end
end

if isClient() == true and isAdmin() == true or isClient() == false and isAdmin() == false then
	Events.OnPlayerUpdate.Add(CheatCoreLMS.DoCheats);
	Events.OnTick.Add(CheatCoreLMS.DoTickCheats);
	Events.OnMouseDown.Add(CheatCoreLMS.DoFireNow);
	Events.OnMouseDown.Add(CheatCoreLMS.SpawnZombieNow);
	Events.OnKeyKeepPressed.Add(CheatCoreLMS.OnKeyKeepPressed);
	Events.OnKeyPressed.Add(CheatCoreLMS.OnKeyPressed);
	Events.OnKeyPressed.Add(CheatCoreLMS.HandleKeyBinds);
	--Events.OnPlayerMove.Add(CheatCoreLMS.updateCoords); -- only used in Cheat Menu
	Events.OnLoad.Add(CheatCoreLMS.SyncVariables)
	Events.OnGameStart.Add(CheatCoreLMS.OnGameStart)
end