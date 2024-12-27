local phraseSets = {}

---unused phrase sets for moods
-- phraseSets.Phrases.Angry = nil
-- phraseSets.Phrases.Dead = nil
-- phraseSets.Phrases.CantSprint = nil
-- phraseSets.Phrases.Uncomfortable = nil
-- phraseSets.Phrases.NoxiousSmell = nil

phraseSets.Phrases = {}

phraseSets.Phrases.Drunk = {}
phraseSets.Phrases.HasACold = {}
phraseSets.Phrases.Windchill = {}
phraseSets.Phrases.Hyperthermia = {}
phraseSets.Phrases.Endurance = {}
phraseSets.Phrases.Bleeding = {}
phraseSets.Phrases.FoodEaten = {}
phraseSets.Phrases.Injured = {}
phraseSets.Phrases.Unhappy = {}
phraseSets.Phrases.Wet = {}
phraseSets.Phrases.Sick = {}
phraseSets.Phrases.HeavyLoad = {}
phraseSets.Phrases.OnDusk = {}
phraseSets.Phrases.OnDawn = {}
phraseSets.Phrases.GunJammed = {}
phraseSets.Phrases.LowAmmo = {}
phraseSets.Phrases.OutOfAmmo = {}
phraseSets.Phrases.Hungry = {}
phraseSets.Phrases.Thirst = {}
phraseSets.Phrases.Tired = {}
phraseSets.Phrases.Bored = {}
phraseSets.Phrases.Stress = {}
phraseSets.Phrases.Agoraphobic = {}
phraseSets.Phrases.Claustrophobic = {}
phraseSets.Phrases.Panic = {}
phraseSets.Phrases.Hypothermia = {}
phraseSets.Phrases.Pain = {}

---Load the above phraseSet IDs into a list used for the config menu.
phraseSets.PhrasesForConfig = {}
-- Swears are ranked by intensity
phraseSets.Phrases.SWEAR = {}
-- useful list of plosives for stammering
phraseSets.Phrases.Plosives = {}
phraseSets.Phrases.FOOD = {}
phraseSets.Phrases.SARCASM = {}
phraseSets.Phrases.Slurring = {}
phraseSets.Phrases.Congested = {}


function phraseSets.Load()

	for moodID,_ in pairs(phraseSets.Phrases) do

		table.insert(phraseSets.PhrasesForConfig,moodID)

		local phraseNum = 0
		while phraseNum < 1000 do
			phraseNum = phraseNum+1
			local phraseID = "UI_Phrases_"..moodID..phraseNum
			local foundPhrase = getTextOrNull(phraseID)
			--[debug]] print("CND-SPEECH: phraseNum:"..phraseNum.."  foundPhrase:"..foundPhrase)
			if (foundPhrase) then
				table.insert(phraseSets.Phrases[moodID], foundPhrase)
			else
				break
			end
		end
	end
end


return phraseSets