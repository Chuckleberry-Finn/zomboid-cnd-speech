require "OptionScreens/MainOptions"
require "ConditionalSpeech02_Core"

MainOptions_pickedMPTextColor = MainOptions.pickedMPTextColor
function MainOptions:pickedMPTextColor(color, mouseUp)
	MainOptions_pickedMPTextColor(self, color, mouseUp)
	ConditionalSpeech.setSpeakColor(getPlayer())
end