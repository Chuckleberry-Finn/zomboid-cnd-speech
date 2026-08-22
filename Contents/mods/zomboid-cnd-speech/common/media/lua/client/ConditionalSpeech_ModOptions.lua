local phraseSets = require "ConditionalSpeech_PhraseSet"
local config = require "ConditionalSpeech_Config"

local function applyModOptions()
	if not PZAPI or not PZAPI.ModOptions then return end

	local editable = true
	if isClient() then
		local allow = SandboxVars.ConditionalSpeech and SandboxVars.ConditionalSpeech.AllowClientModOptions
		if allow == nil then allow = true end
		editable = allow
	end

	config.clientModOptionsEditable = editable

	local moodIDs = {}
	for moodID,_ in pairs(phraseSets.Phrases) do
		if getTextOrNull("UI_Config_"..moodID) then
			table.insert(moodIDs, moodID)
		end
	end
	table.sort(moodIDs)

	config.applyDisabledPhraseSets()

	local options = PZAPI.ModOptions:create("Conditional-Speech", getText("UI_ConfigMODID_Conditional-Speech"))

	options:addTitle(getText("UI_Config_moodTableToolTip"))

	for _,moodID in ipairs(moodIDs) do
		local lockedBySandbox = config.disabledPhraseSets and config.disabledPhraseSets[moodID]
		local currentlyEnabled = not lockedBySandbox

		local tickBox = options:addTickBox("cndSpeech_Phrase_"..moodID, getText("UI_Config_"..moodID), currentlyEnabled, nil)

		if lockedBySandbox or (not editable) then
			tickBox:setEnabled(false)
		end
	end
end

Events.OnGameStart.Add(applyModOptions)
