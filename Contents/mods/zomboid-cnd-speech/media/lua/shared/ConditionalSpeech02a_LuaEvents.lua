if isServer() then return end

local ConditionalSpeech = require "ConditionalSpeech02_Core"
Events.OnCreatePlayer.Add(ConditionalSpeech.load_n_set_Moodles)--OnCreateLivingCharacter(playerObj) --Starts up ConditionalSpeech
Events.EveryHours.Add(ConditionalSpeech.check_Time)--EveryHours(?) --check every in-game hour for events
Events.OnWeaponSwing.Add(ConditionalSpeech.check_WeaponStatus) --OnWeaponSwing(playerObj,weapon)
Events.OnPlayerUpdate.Add(ConditionalSpeech.check_PlayerStatus) --OnPlayerUpdate(playerObj) --checks moodlestatus

local phraseSets = require "ConditionalSpeech04_PhraseSet"
Events.OnGameStart.Add(phraseSets.LoadFromTranslation)

local metaValues = require "ConditionalSpeech02b_metaValues"
Events.OnGameStart.Add(metaValues.createTrueArrayForPlosives())