if isServer() then return end

local cndSpeechUtil = require "ConditionalSpeech00_Util"
local phraseSets = require "ConditionalSpeech04_PhraseSet"
local metaValues = require "ConditionalSpeech02b_metaValues"

--- Filter Template
--[[
function conditionalSpeechFilter.TEMPLATE(text, intensity)
    --volume shift is optional to include
	local volumeShift = 0
	--- Actual filter stuff here

	return text,volumeShift
end
]]
local conditionalSpeechFilter = {}



--- Blurt Out
function conditionalSpeechFilter.BlurtOut(text, intensity)
    local volumeShift = 0
    if cndSpeechUtil.prob(((intensity^2)+intensity)*4) then volumeShift = metaValues.volumeMax/6 end
    return text, volumeShift
end


--- SCREAM FILTER!
function conditionalSpeechFilter.SCREAM(text, intensity)
    local volumeShift = metaValues.volumeMax/2
    text = text:gsub("%.", "%!")
    if cndSpeechUtil.prob(((intensity^2)+intensity)*4) then volumeShift = metaValues.volumeMax end
    return text,volumeShift
end


--- S-s-s-stutter Filter -- impacts leading letters
function conditionalSpeechFilter.Stutter(text, intensity)

    local words = luautils.split(text)
    local post_words = {}
    local max_stutter = intensity

    for _,value in pairs(words) do

        local w = value
        local fc = string.sub(w, 1,1) --fc=first character

        if max_stutter > 0 and metaValues._Plosives[fc] then
            max_stutter = max_stutter-1

            local chance = intensity*16

            while chance > 0 do
                if cndSpeechUtil.prob(chance) then
                    w = fc .. "-" .. w
                end
                chance = chance-(31+ZombRand(15))
            end
        end

        table.insert(post_words, w)
    end

    text = table.concat(post_words," ")
    return text
end


--- S-s-stammer-r-r Filt-t-t-ter -- impacts throughout
function conditionalSpeechFilter.Stammer(text, intensity)

    local characters = cndSpeechUtil.splitTextByChar(text)
    local post_characters = {}
    local max_stammer = intensity

    for _,value in pairs(characters) do

        local c = value

        if max_stammer > 0 and metaValues._Plosives[c] then

            local chance = intensity*8
            max_stammer = max_stammer-1

            while chance > 0 do
                if cndSpeechUtil.prob(chance) then c = c .. "-" .. c end
                chance = chance-(31+ZombRand(15))
            end
        end

        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)
    return text
end


--- Logic for repeated swearing
function conditionalSpeechFilter.panicSwear(text, intensity)

    local randswear = cndSpeechUtil.rangedRandPick(phraseSets.Phrases.SWEAR,intensity,4)

    if randswear then
        randswear = randswear .. "."

        local chance = intensity*15

        while chance > 0 do
            if cndSpeechUtil.prob(chance) then randswear = randswear .. " " .. randswear end
            chance = chance-(31+ZombRand(10))
        end

        if cndSpeechUtil.prob(50) then
            text = randswear .. " " .. text
        else
            text = text .. " " .. randswear --50% before or after text
        end
    end

    return text
end


--- Logic for slurring
function conditionalSpeechFilter.Slurring(text, intensity)

    local characters = cndSpeechUtil.splitTextByChar(text)
    local post_characters = {}

    local replaceCharacters = {}
    for _,string in pairs(phraseSets.Phrases.Slurring) do
        local find, replace = string:match("(.+):(.+)")
        --print("<"..find..">:<"..replace..">")
        replaceCharacters[find] = replace
    end

    for _,value in pairs(characters) do
        local c = value
        if c~=" " and replaceCharacters[c] then
            local chance = intensity*20
            if cndSpeechUtil.prob(chance) then c = (replaceCharacters[c] or c) end
        end
        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)

    return text
end


--- Logic for congested
function conditionalSpeechFilter.Congested(text, intensity)

    local characters = cndSpeechUtil.splitTextByChar(text)
    local post_characters = {}
    local _intensity = intensity

    local replaceCharacters = {}
    for _,string in pairs(phraseSets.Phrases.Congested) do
        local find, replace = string:match("(.+):(.+)")
        --print("<"..find..">:<"..replace..">")
        replaceCharacters[find] = replace
    end

    for _,value in pairs(characters) do
        local c = value
        if c~=" " and _intensity > 0 and replaceCharacters[c] then
            local chance = intensity*25
            _intensity = _intensity-1
            if cndSpeechUtil.prob(chance) then c = (replaceCharacters[c] or c) end
        end
        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)

    return text
end


return conditionalSpeechFilter