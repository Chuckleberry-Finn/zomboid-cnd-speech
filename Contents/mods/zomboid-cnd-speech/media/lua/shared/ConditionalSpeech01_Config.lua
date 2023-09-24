if isServer() then return end

require "EasyConfigChucked1_Main"
require "OptionScreens/ServerSettingsScreen"
require "OptionScreens/SandBoxOptions"

local phraseSets = require "ConditionalSpeech04_PhraseSet"

cndSpeechConfig = cndSpeechConfig or {}

cndSpeechConfig.config = {
	--NPCsDontTalk = true,
	SpeechCanAttractsZombies = true,
	ShowOnlyAudibleSpeech = false,
}

cndSpeechConfig.modId = "Conditional-Speech" -- needs to the same as in your mod.info

cndSpeechConfig.menu = {
	--NPCsDontTalk = {type = "Tickbox", title = "Disable Non-Players' Speech",},
	--NPCsDontTalkToolTip = {type = "Text", text = "Non-player characters (NPCs) don't speak with Conditional Speech.\n", a=0.65, customX=-100},
	--generalSpaceA = {type = "Space"},

	SpeechCanAttractsZombies = {type = "Tickbox",},
	SpeechCanAttractsZombiesToolTip = {type = "Text", a=0.65, customX=-100, addAfter="\n"},
	generalSpaceB = {type = "Space"},

	ShowOnlyAudibleSpeech = {type = "Tickbox",},
	ShowOnlyAudibleSpeechToolTip = {type = "Text", a=0.65, customX=-100, addAfter="\n"},
	generalSpaceC = {type = "Space"},
}

function cndSpeechConfig.loadMoodTableToConfig()
	cndSpeechConfig.menu.generalSpaceD = {type = "Space"}
	cndSpeechConfig.menu.moodTableToolTip = {type = "Text", a=0.65, customX=-20}
	for key,moodID in pairs(phraseSets.PhrasesForConfig) do
		cndSpeechConfig.menu[moodID] = {type = "Tickbox", title = moodID, tooltip = "", }
		cndSpeechConfig.config[moodID] = cndSpeechConfig.config[moodID] or true
	end
end

EasyConfig_Chucked = EasyConfig_Chucked or {}
EasyConfig_Chucked.mods = EasyConfig_Chucked.mods or {}
EasyConfig_Chucked.mods[cndSpeechConfig.modId] = cndSpeechConfig

Events.OnGameBoot.Add(cndSpeechConfig.loadMoodTableToConfig)