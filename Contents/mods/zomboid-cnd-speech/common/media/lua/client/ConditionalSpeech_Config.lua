local config = {}

config.disabledPhraseSets = nil--{}
config.sandboxValue = 0

function config.applyDisabledPhraseSets()

    local sandboxLength = string.len(SandboxVars.ConditionalSpeech.DisablePhrases)
    local valueMismatch = (config.sandboxValue ~= sandboxLength)

    print("valueMismatch: ", valueMismatch, "   a:", config.sandboxValue, " <> b:", sandboxLength, "    config.disabledPhraseSets:", (not not config.disabledPhraseSets))

    if config.disabledPhraseSets and (not valueMismatch) then return end

    config.disabledPhraseSets = {}
    config.sandboxValue = sandboxLength

	--SandboxVars.ConditionalSpeech.SpeechCanAttractsZombies
	--SandboxVars.ConditionalSpeech.ShowOnlyAudibleSpeech
	--SandboxVars.ConditionalSpeech.DisablePhrases

    for token in string.gmatch(SandboxVars.ConditionalSpeech.DisablePhrases, "[^,]+") do
        config.disabledPhraseSets[token] = true
    end
end

return config
