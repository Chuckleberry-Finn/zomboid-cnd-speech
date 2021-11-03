require "_EasyConfig_Chucked"
require "OptionScreens/ServerSettingsScreen"
require "OptionScreens/SandBoxOptions"

cndSpeechConfig = cndSpeechConfig or {}

cndSpeechConfig.config = {
	NPCsDontTalk = false,
	SpeechCanAttractsZombies = true,
	ShowOnlyAudibleSpeech = false,
}

cndSpeechConfig.modId = "Conditional-Speech" -- needs to the same as in your mod.info
cndSpeechConfig.name = "Conditional Speech" -- the name that will be shown in the MOD tab

cndSpeechConfig.menu = {
	NPCsDontTalk = {type = "Tickbox", title = "Disable Non-Players' Speech",},
	NPCsDontTalkToolTip = {type = "Text", text = "Non-player characters (NPCs) don't speak with Conditional Speech.\n", a=0.65, customX=-100},
	generalSpaceA = {type = "Space"},

	SpeechCanAttractsZombies = {type = "Tickbox", title = "Speech Can Attract Zombies",},
	SpeechCanAttractsZombiesToolTip = {type = "Text", text = "Even in extreme circumstances zombies can't hear conditional speech.\n", a=0.65, customX=-100},
	generalSpaceB = {type = "Space"},

	ShowOnlyAudibleSpeech = {type = "Tickbox", title = "Show Only Audible Speech",},
	ShowOnlyAudibleSpeechToolTip = {type = "Text", text = "Show only speech that can actually be heard.\n", a=0.65, customX=-100},
	generalSpaceC = {type = "Space"},
}

function cndSpeechConfig.loadMoodTableToConfig()
	cndSpeechConfig.menu.generalSpaceD = {type = "Space"}
	cndSpeechConfig.menu.moodTableToolTip = {type = "Text", text = "Phrase Sets:", a=0.65, customX=-20}
	for key,moodID in pairs(ConditionalSpeech.PhrasesForConfig) do
		cndSpeechConfig.menu[moodID] = {type = "Tickbox", title = moodID, tooltip = "", }
		cndSpeechConfig.config[moodID] = cndSpeechConfig.config[moodID] or true
	end
end

EasyConfig_Chucked = EasyConfig_Chucked or {}
EasyConfig_Chucked.mods = EasyConfig_Chucked.mods or {}
EasyConfig_Chucked.mods[cndSpeechConfig.modId] = cndSpeechConfig

Events.OnGameBoot.Add(cndSpeechConfig.loadMoodTableToConfig)