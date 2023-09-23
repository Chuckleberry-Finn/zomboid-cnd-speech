Events.OnGameBoot.Add(function() print("Conditional Speech: ver:0.9--FEB-18-23") end)

--[[

ConditionalSpeech_Filter = {}
function is_valueIn(tab, val) for _,value in pairs(tab) do if value == val then return true end end return false end
function is_prob(n) return (math.random(0,100) < n) end
function splitText_byChar(text) local t={} for i = 1, #text do table.insert(t, text:sub(i,i)) end return t end

ConditionalSpeech = {}
ConditionalSpeech.Phrases = {}
ConditionalSpeech.Phrases.Slurring = {"o:u","s:ch","a:ah","u:oo","c:k"}

--]]