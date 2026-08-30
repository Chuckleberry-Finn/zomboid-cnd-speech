local phraseSets = require "ConditionalSpeech_PhraseSet"
local config = require "ConditionalSpeech_Config"

local tickBoxes = {}

local function createModOptionsUI()
	if not PZAPI or not PZAPI.ModOptions then return end

	local moodIDs = {}
	for moodID,_ in pairs(phraseSets.Phrases) do
		if getTextOrNull("UI_Config_"..moodID) then
			table.insert(moodIDs, moodID)
		end
	end
	table.sort(moodIDs)

	local options = PZAPI.ModOptions:create("Conditional-Speech", getText("UI_ConfigMODID_Conditional-Speech"))

	options:addTitle(getText("UI_Config_moodTableToolTip"))

	for _,moodID in ipairs(moodIDs) do
		tickBoxes[moodID] = options:addTickBox("cndSpeech_Phrase_"..moodID, getText("UI_Config_"..moodID), true, nil)
	end

	PZAPI.ModOptions:load()
end


local function applyModOptionsLocking()
	if not PZAPI or not PZAPI.ModOptions then return end

	local editable = true
	if isClient() then
		local allow = SandboxVars.ConditionalSpeech and SandboxVars.ConditionalSpeech.AllowClientModOptions
		if allow == nil then allow = true end
		editable = allow
	end

	config.clientModOptionsEditable = editable
	config.applyDisabledPhraseSets()

	for moodID,tickBox in pairs(tickBoxes) do
		local lockedBySandbox = config.disabledPhraseSets and config.disabledPhraseSets[moodID]

		if lockedBySandbox then
			tickBox:setValue(false)
		end

		if lockedBySandbox or (not editable) then
			tickBox:setEnabled(false)
		end
	end
end

Events.OnGameBoot.Add(createModOptionsUI)
Events.OnGameStart.Add(applyModOptionsLocking)
