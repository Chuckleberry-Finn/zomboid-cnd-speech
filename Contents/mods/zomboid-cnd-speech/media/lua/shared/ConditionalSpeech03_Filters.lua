if isServer() then return end

require "ConditionalSpeech02_Core"

--- Filter Template
--[[
function ConditionalSpeech_Filter.TEMPLATE(text, intensity)
    --volume shift is optional to include
	local volumeShift = 0
	--- Actual filter stuff here
	local results = filterResults:new(text,volumeShift)

	return results
	end
end
]]


--- Object type for filter results handling
---@class filterResults : ISBaseObject
filterResults = ISBaseObject:derive("filterResults")

---@param return_text string @text being returned after text has been filtered
---@param return_vol number @volume value
---@return self
function filterResults:new(return_text,return_vol)

    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.return_text = return_text
    o.return_vol = return_vol

    return o
end


--- Blurt Out
function ConditionalSpeech_Filter.BlurtOut(text, intensity)
    local volumeShift = 0

    if is_prob(((intensity^2)+intensity)*4) then
        volumeShift = ConditionalSpeech.VolumeMAX/6
    end

    local results = filterResults:new(text,volumeShift)
    return results
end


--- SCREAM FILTER!
function ConditionalSpeech_Filter.SCREAM(text, intensity)

    local volumeShift = ConditionalSpeech.VolumeMAX/2

    text = text:gsub("%.", "%!")
    if is_prob(((intensity^2)+intensity)*4) then
        volumeShift = ConditionalSpeech.VolumeMAX
    end

    local results = filterResults:new(text,volumeShift)
    return results
end


--- S-s-s-stutter Filter -- impacts leading letters
function ConditionalSpeech_Filter.Stutter(text, intensity)

    local words = luautils.split(text)
    local post_words = {}
    local max_stutter = intensity

    for _,value in pairs(words) do

        local w = value
        local fc = string.sub(w, 1,1) --fc=first character

        if max_stutter > 0 and is_valueIn(ConditionalSpeech.Phrases.Plosives,fc) then
            max_stutter = max_stutter-1

            local chance = intensity*16

            while chance > 0 do
                if is_prob(chance) then
                    w = fc .. "-" .. w
                end
                chance = chance-(31+ZombRand(15))
            end
        end

        table.insert(post_words, w)
    end

    text = table.concat(post_words," ")

    local results = filterResults:new(text)
    return results
end


--- S-s-stammer-r-r Filt-t-t-ter -- impacts throughout
function ConditionalSpeech_Filter.Stammer(text, intensity)

    local characters = splitText_byChar(text)
    local post_characters = {}
    local max_stammer = intensity

    for _,value in pairs(characters) do

        local c = value

        if max_stammer > 0 and is_valueIn(ConditionalSpeech.Phrases.Plosives,c) then

            local chance = intensity*8
            max_stammer = max_stammer-1

            while chance > 0 do
                if is_prob(chance) then c = c .. "-" .. c end
                chance = chance-(31+ZombRand(15))
            end
        end

        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)

    local results = filterResults:new(text)
    return results
end


--- Logic for repeated swearing
function ConditionalSpeech_Filter.panicSwear(text, intensity)

    local randswear = RangedRandPick(ConditionalSpeech.Phrases.SWEAR,intensity,4)

    if randswear then
        randswear = randswear .. "."

        local chance = intensity*15

        while chance > 0 do
            if is_prob(chance) then randswear = randswear .. " " .. randswear end
            chance = chance-(31+ZombRand(10))
        end

        if is_prob(50) then
            text = randswear .. " " .. text
        else
            text = text .. " " .. randswear --50% before or after text
        end
    end

    local results = filterResults:new(text)
    return results
end


--- Logic for slurring
function ConditionalSpeech_Filter.Slurring(text, intensity)

    local characters = splitText_byChar(text)
    local post_characters = {}
    local max_slurring = intensity

    local replaceCharacters = {}
    for _,string in pairs(ConditionalSpeech.Phrases.Slurring) do
        local find, replace = string:match("(.+):(.+)")
        --print("<"..find..">:<"..replace..">")
        replaceCharacters[find] = replace
    end

    for _,value in pairs(characters) do
        local c = value
        if c~=" " and max_slurring > 0 and replaceCharacters[c] then

            local chance = intensity*33
            max_slurring = max_slurring-1

            if is_prob(chance/1.5) and is_valueIn(ConditionalSpeech.Phrases.Plosives,c) then c = "'" end
            if is_prob(chance/3) then c = c.."'" end
            if is_prob(chance) then c = (replaceCharacters[c] or c) end
        end

        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)

    local results = filterResults:new(text)
    return results
end


--- Logic for congested
function ConditionalSpeech_Filter.Congested(text, intensity)

    local characters = splitText_byChar(text)
    local post_characters = {}
    local max_slurring = intensity

    local replaceCharacters = {}
    for _,string in pairs(ConditionalSpeech.Phrases.Congested) do
        local find, replace = string:match("(.+):(.+)")
        --print("<"..find..">:<"..replace..">")
        replaceCharacters[find] = replace
    end

    for _,value in pairs(characters) do
        local c = value
        if c~=" " and max_slurring > 0 and replaceCharacters[c] then
            local chance = intensity*44
            max_slurring = max_slurring-1
            if is_prob(chance) then c = (replaceCharacters[c] or c) end
        end
        table.insert(post_characters, c)
    end

    text = table.concat(post_characters)

    local results = filterResults:new(text)
    return results
end