require "_EasyConfig_Chucked"
require "OptionScreens/ServerSettingsScreen"
require "OptionScreens/SandBoxOptions"

cndSpeechConfig = cndSpeechConfig or {}

cndSpeechConfig.config = {
	NPCsDontTalk = false,
	SpeechCanAttractsZombies = true,
}

cndSpeechConfig.modId = "Conditional-Speech" -- needs to the same as in your mod.info
cndSpeechConfig.name = "Conditional Speech" -- the name that will be shown in the MOD tab

cndSpeechConfig.menu = {
	NPCsDontTalk = {type = "Tickbox", title = "Disable Non-Players' Speech", tooltip = "Non-player characters (NPCs) don't speak with Conditional Speech.",},
	SpeechCanAttractsZombies = {type = "Tickbox", title = "Speech Can Attract Zombies", tooltip = "Even in extreme circumstances zombies can't hear conditional speech.",},
}


EasyConfig_Chucked = EasyConfig_Chucked or {}
EasyConfig_Chucked.mods = EasyConfig_Chucked.mods or {}
EasyConfig_Chucked.mods[cndSpeechConfig.modId] = cndSpeechConfig