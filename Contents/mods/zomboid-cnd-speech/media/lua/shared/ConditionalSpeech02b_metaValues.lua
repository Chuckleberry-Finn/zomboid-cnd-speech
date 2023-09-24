if isServer() then return end

local phrases = require "ConditionalSpeech04_PhraseSet"

local metaValues = {}

metaValues.volumeMax = 60
metaValues.DAWN_TIME = 6
metaValues.DUSK_TIME = 22

metaValues._Plosives = {}

function metaValues.createTrueArrayForPlosives()
    for _,phrase in pairs(phrases.Phrases.Plosives) do
        metaValues._Plosives[phrase] = true
    end
end

return metaValues