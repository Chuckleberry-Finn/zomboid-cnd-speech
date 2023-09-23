Events.OnGameBoot.Add(function() print("Conditional Speech: ver:0.9--FEB-18-23") end)

--[[

function is_valueIn(tab, val) for _,value in pairs(tab) do if value == val then return true end end return false end
function splitText_byChar(text) local t={} for i=1, #text do table.insert(t, text:sub(i,i)) end return t end
function is_prob(n) return (math.random(0,100) < n) end

ConditionalSpeech_Filter = {}

ConditionalSpeech = {}
ConditionalSpeech.Phrases = {}
ConditionalSpeech.Phrases.Slurring = {"o:u","s:ch","a:ah","u:oo","c:k"}
ConditionalSpeech.Phrases.Plosives = {"f","F","p","P","t","T","k","K","b","B","d","D","g","G","s","S","m","M"}

--]]