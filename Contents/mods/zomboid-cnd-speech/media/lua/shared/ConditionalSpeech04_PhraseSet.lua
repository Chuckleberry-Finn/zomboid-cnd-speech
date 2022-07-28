require "ConditionalSpeech02_Core"

---unused phrase sets for moods
-- ConditionalSpeech.Phrases.Angry = nil
-- ConditionalSpeech.Phrases.Dead = nil

ConditionalSpeech.Phrases.Drunk = {}
ConditionalSpeech.Phrases.HasACold = {}
ConditionalSpeech.Phrases.Windchill = {}
ConditionalSpeech.Phrases.Hyperthermia = {}
ConditionalSpeech.Phrases.Endurance = {}
ConditionalSpeech.Phrases.Bleeding = {}
ConditionalSpeech.Phrases.FoodEaten = {}
ConditionalSpeech.Phrases.Injured = {}
ConditionalSpeech.Phrases.Unhappy = {}
ConditionalSpeech.Phrases.Wet = {}
ConditionalSpeech.Phrases.Sick = {}
ConditionalSpeech.Phrases.HeavyLoad = {}
ConditionalSpeech.Phrases.OnDusk = {}
ConditionalSpeech.Phrases.OnDawn = {}
ConditionalSpeech.Phrases.GunJammed = {}
ConditionalSpeech.Phrases.LowAmmo = {}
ConditionalSpeech.Phrases.OutOfAmmo = {}
ConditionalSpeech.Phrases.Hungry = {}
ConditionalSpeech.Phrases.Thirst = {}
ConditionalSpeech.Phrases.Tired = {}
ConditionalSpeech.Phrases.Bored = {}
ConditionalSpeech.Phrases.Stress = {}
ConditionalSpeech.Phrases.Agoraphobic = {}
ConditionalSpeech.Phrases.Claustrophobic = {}
ConditionalSpeech.Phrases.Panic = {}
ConditionalSpeech.Phrases.Hypothermia = {}
ConditionalSpeech.Phrases.Pain = {}

---Load the above phraseSet IDs into a list used for the config menu.
ConditionalSpeech.PhrasesForConfig = {}
for moodID,phrases in pairs(ConditionalSpeech.Phrases) do
	table.insert(ConditionalSpeech.PhrasesForConfig,moodID)
end

-- Swears are ranked by intensity
ConditionalSpeech.Phrases.SWEAR = {}
-- useful list of plosives for stammering
ConditionalSpeech.Phrases.Plosives = {}
ConditionalSpeech.Phrases.FOOD = {}
ConditionalSpeech.Phrases.SARCASM = {}


function SetPhraseSetLANGUAGE()
	--[debug]] print("CND-SPEECH: Ignore the following ERRORS they are apart of the phrase loading process.")
	for k,_ in pairs(ConditionalSpeech.Phrases) do

		local phraseNum = 0
		while phraseNum < 1000 do
			phraseNum = phraseNum+1
			local foundPhrase = ""
			local phraseID = "UI_Phrases_"..k..phraseNum

			foundPhrase = getTextOrNull(phraseID)
			--[debug]] print("CND-SPEECH: phraseNum:"..phraseNum.."  foundPhrase:"..foundPhrase)
			if (foundPhrase) then
				table.insert(ConditionalSpeech.Phrases[k], foundPhrase)
			else
				break
			end
		end
	end
end

Events.OnGameStart.Add(SetPhraseSetLANGUAGE)