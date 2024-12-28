--- Thank you to dhert
------ local options = PZAPI.ModOptions:getOptions("Conditional-Speech")
------ local option = options:getOption("cndSpeech_Phrase_"..moodID")

local phraseSets = require "ConditionalSpeech_PhraseSet"

local config = {}

function config.apply()

	local options = PZAPI.ModOptions:create("Conditional-Speech", getText("UI_ConfigMODID_Conditional-Speech"))

	options:addTickBox("cndSpch_SpeechCanAttractsZombies", getText("UI_Config_SpeechCanAttractsZombies"), true, getText("UI_Config_SpeechCanAttractsZombiesToolTip"))
	options:addTickBox("cndSpch_ShowOnlyAudibleSpeech", getText("UI_Config_ShowOnlyAudibleSpeech"), true, getText("UI_Config_ShowOnlyAudibleSpeechToolTip"))

	options:addTitle(getText("UI_Config_moodTableToolTip"))
	for _,moodID in pairs(phraseSets.PhrasesForConfig) do
		options:addTickBox("cndSpeech_Phrase_"..moodID, getText("UI_Config_"..moodID), true)
	end
end

return config
