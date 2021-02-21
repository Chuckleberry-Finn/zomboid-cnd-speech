require "ConditionalSpeech_Util"
require "ConditionalSpeech_Core"

--- -=[ Instructions for Contributors ]=- ---
--- Firstly, thank you for stopping in; I hope you enjoy your time here.

--- to add more phrase sets: ConditionalSpeech.Phrases.WORD = {"phrase1","phrase2"}
--- to generate speech: ConditionalSpeech.generateSpeech("WORD")
--- Moodles automatically search for a phraseset matching their WORD
--- to use phrase set as keywords simply populate phrases with "<WORD>".

--- When Writing New Phrases:
--- Keep them short when you can.
--- Don't captilize anything other than 'I' or proper nouns.
--- Punctuation is fine, but keep in mind all '.' can become '!' - so avoid things like U.S.A. or F.B.I.
--- Avoid swears (as there is dynamic swearing built-in) instead use <SWEAR>.
--- For the moment any \*emotive actions\* have to be the entire phrase (which won't be filtered).

--- For more variety and to avoid bloat from repetative phrases, phrases can be used as Keywords to replace parts of another phrase at random.
--- Format: <WORD> in the phrase. Make sure there is a corresponding ConditionalSpeech.Phrases.WORD phrase-set.
--- When writing new Phrases to be used as keywords: Read through some lines with <WORD> to make sure it sounds correct before adding them in.


--[[ ---unused phrase sets for moods
ConditionalSpeech.Phrases.Endurance = nil
ConditionalSpeech.Phrases.Sick = nil
ConditionalSpeech.Phrases.Unhappy = nil
ConditionalSpeech.Phrases.Bleeding = nil
ConditionalSpeech.Phrases.Wet = nil
ConditionalSpeech.Phrases.HasACold = nil
ConditionalSpeech.Phrases.Angry = nil
ConditionalSpeech.Phrases.Injured = nil
ConditionalSpeech.Phrases.HeavyLoad = nil
ConditionalSpeech.Phrases.Drunk = nil
ConditionalSpeech.Phrases.Dead = nil
ConditionalSpeech.Phrases.Hyperthermia = nil
ConditionalSpeech.Phrases.Windchill = nil
ConditionalSpeech.Phrases.FoodEaten = nil
]]--


ConditionalSpeech.Phrases.Zombie = { -- Dead and Zombie Moodles seemingly only have 1 level -- they may not operate well with intensity argument in generate speech
	"I'm turning into one of them",
	"this is it",
	"this is over",
	"why me?",
	"I'm going to turn into one of them, aren't I?"
}

ConditionalSpeech.Phrases.OnDusk = {"getting dark","looks like the sun is going down","the sun is going down"}
ConditionalSpeech.Phrases.OnDawn = {"another day","made it to another day","the sun is coming up","the sun is rising"}

ConditionalSpeech.Phrases.GunJammed = {"jam","gun is jammed","damn thing is jammed","jammed"}

ConditionalSpeech.Phrases.OutOfAmmo = {
	"I'm out",
	"empty",
	"no ammo",
	"out of ammo",
	"there is no ammo",
	"gun is out of ammo",
	"this is empty",
	"this thing is empty",
	"gun is empty",
	"out of bullets",
	"no bullets",
	"there is no bullets"
}

ConditionalSpeech.Phrases.Hungry = {
	"I could use a snack",
	"*stomach stirs*",
	"I could use <FOOD>",
	"I have to snack on something",
	"<FOOD> would be nice right about now",
	"I should go get some food",
	"*stomach growls*",
	"I better get some food",
	"I should get something to eat",
	"my stomach is rumbling",
	"ugh, I really need something to eat",
	"I could go for <FOOD>",
	"I could go for <FOOD> right about now",
	"*stomach growls loudly*",
	"this gnawing hunger is driving me nuts!",
	"there has got to be some food somewhere",
	"I need food",
	"aaghhh. the hunger.",
	"where the <SWEAR> is some food!?",
	"I'm so hungry",
	"uhnnng. the hunger",
	"I'm starving"
}


ConditionalSpeech.Phrases.Thirst = {
	"my mouth is dry",
	"*clears throat*",
	"I could go for some water right now.",
	"a sip of water would be nice.",
	"I need something to drink.",
	"I should get something to drink.",
	"my mouth feels a bit dry.",
	"could use a good gulp of water right now.",
	"I should drink something.",
	"my mouth is so dry",
	"I really should get something to drink now.",
	"I need some water!",
	"there has to be water somewhere",
	"I need water"
}

ConditionalSpeech.Phrases.Tired = {
	"*yawn*",
	"I could use a nap.",
	"I feel sluggish.",
	"I should get some sleep.",
	"man, I could use a lie down.",
	"*long yawn*",
	"I should go to sleep soon",
	"I should go to bed soon",
	"I should probably call it a day soon",
	"I'm starting to get bags under my eyes.",
	"damn I'm tired.",
	"*extremely long yawn*",
	"I'm so tired",
	"man, I could use some sleep.",
	"I think I'm starting to lose it. I really need sleep.",
	"I can barely keep my eyes open",
	"I feel like I'm going to pass out",
	"how long has it been since I last slept?",
	"uhnng, I'm so tired",
	"I really should go to sleep soon.",
	"*your eyelids feel heavy*",
	"I can barely stand. I'm so tired."
}

ConditionalSpeech.Phrases.Bored = {
	"I should go do something.",
	"I could use something to do",
	"*sigh*",
	"there has got to be something to do",
	"well, this is boring",
	"man I'm bored",
	"so little to do, so little to see",
	"I'm bored as <SWEAR>>",
	"*long sigh*",
	"so bored.",
	"I'm bored as hell.",
	"*deep sigh*",
	"I really need something to do",
	"there has gotta be something to do! something! anything! aghh!",
	"sticking spoons in my eyes would be better than this",
	"this is boredom is driving me insane!"
}

ConditionalSpeech.Phrases.Stress = {
	"feeling stressed",
	"I need to relax somehow",
	"*deep breath*",
	"I need to relax",
	"ugh",
	"I could use some relaxation",
	"*deep long breath*",
	"I could really use a bit of relaxation",
	"can't anymore",
	"this fucking stress",
	"fuck this bullshit"
}

ConditionalSpeech.Phrases.Panic = {
	"uh oh!",
	"oh!",
	"ohh!",
	"ah!",
	"ahh!",
	"holy!",
	"<SWEAR>",
	"ah <SWEAR>!",
	"oh <SWEAR>!",
	"holy!",
	"holy <SWEAR_adj>!",
	"I need to get out of here!",
	"why!?",
	"ahhh!",
	"I have to get the <SWEAR_adj> out of here!",
	"why!?",
	"please no!",
	"somebody help!",
	"somebody help me!",
	"oh god! ahhh!"
}

ConditionalSpeech.Phrases.Hypothermia = { "it is so cold", "brrrrr", "*shivers*" }

ConditionalSpeech.Phrases.Pain = {
	"ouch",
	"ow",
	"argh",
	"that hurts",
	"ouch",
	"ow",
	"aagghh",
	"that hurts",
	"aaaaghhh",
	"arrgh",
	"owww",
	"that hurts like hell",
	"arrrgh",
	"the pain",
	"make it stop",
	"aagghhh",
	"aaaggghhh",
	"oh god",
	"aaghh"
}

ConditionalSpeech.Phrases.Campfire = {"*sings*"}

-- Swears are ranked by intensity
ConditionalSpeech.Phrases.SWEAR = {"crap","damn","god damn","shit","fuck"}
ConditionalSpeech.Phrases.SWEAR_adj = {"heck","hell","shit","fuck"}

-- useful list of plosives for stammering
ConditionalSpeech.Phrases.Plosives = {"f","F","p","P","t","T","k","K","b","B","d","D","g","G","s","S","m","M"}

ConditionalSpeech.Phrases.FOOD = {"a bite to eat","a whole pizza","some pizza","a slice of pizza","a slice of cake","something tasty",
								  "some cake","a bucket of chicken","some chicken","a Spiffo burger","a Spiffo kid's meal","a bucket of Jay's Chicken",
								  "an order of Jay's biscuits with gravy","eating anything","anything to eat","a snack"}

ConditionalSpeech.Phrases.SARCASM = {"just great","awesome","fantastic","just what I needed"}
