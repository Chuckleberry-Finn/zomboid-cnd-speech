local ConditionalSpeech = require "ConditionalSpeech_Core"
Events.OnCreatePlayer.Add(ConditionalSpeech.load_n_set_Moodles)--OnCreateLivingCharacter(playerObj) --Starts up ConditionalSpeech
Events.EveryHours.Add(ConditionalSpeech.check_Time)--EveryHours(?) --check every in-game hour for events
Events.OnWeaponSwing.Add(ConditionalSpeech.check_WeaponStatus) --OnWeaponSwing(playerObj,weapon)
Events.OnPlayerUpdate.Add(ConditionalSpeech.check_PlayerStatus) --OnPlayerUpdate(playerObj) --checks moodlestatus

local phraseSets = require "ConditionalSpeech_PhraseSet"
Events.OnGameBoot.Add(phraseSets.Load)

local config = require "ConditionalSpeech_Config"
Events.OnGameBoot.Add(config.apply)

local metaValues = require "ConditionalSpeech_metaValues"
Events.OnGameBoot.Add(metaValues.createTrueArrayForPlosives())