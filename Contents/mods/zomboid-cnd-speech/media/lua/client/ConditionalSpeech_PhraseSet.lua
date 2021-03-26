require "ConditionalSpeech__Core"

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
-- Dead and Zombie Moodles seemingly only have 1 level -- they may not operate well with intensity argument in generate speech
ConditionalSpeech.Phrases.Zombie = {}
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
ConditionalSpeech.Phrases.Panic = {}
ConditionalSpeech.Phrases.Hypothermia = {}
ConditionalSpeech.Phrases.Pain = {}
-- Swears are ranked by intensity
ConditionalSpeech.Phrases.SWEAR = {}
-- useful list of plosives for stammering
ConditionalSpeech.Phrases.Plosives = {}
ConditionalSpeech.Phrases.FOOD = {}
ConditionalSpeech.Phrases.SARCASM = {}


function SetPhraseSetLANGUAGE()

	for k,_ in pairs(ConditionalSpeech.Phrases) do

		local phraseNum = 0

		while phraseNum < 100 do
			phraseNum = phraseNum+1
			local foundPhrase = ""
			local phraseID = "UI_Phrases_"..k..phraseNum
			foundPhrase = getText(phraseID)
			print("phraseNum:"..phraseNum.."  foundPhrase:"..foundPhrase)
			if (foundPhrase == phraseID) then
				break
			else
				table.insert(ConditionalSpeech.Phrases[k], foundPhrase)
			end
		end
	end
end

Events.OnGameStart.Add(SetPhraseSetLANGUAGE)