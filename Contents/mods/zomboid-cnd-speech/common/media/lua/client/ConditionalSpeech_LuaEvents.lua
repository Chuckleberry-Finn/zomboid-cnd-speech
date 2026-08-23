local ConditionalSpeech = require "ConditionalSpeech_Core"
Events.OnCreatePlayer.Add(ConditionalSpeech.load_n_set_Moodles)--OnCreateLivingCharacter(playerObj) --Starts up ConditionalSpeech
Events.EveryHours.Add(ConditionalSpeech.check_Time)--EveryHours(?) --check every in-game hour for events
Events.OnWeaponSwing.Add(ConditionalSpeech.check_WeaponStatus) --OnWeaponSwing(playerObj,weapon)
Events.OnPlayerUpdate.Add(ConditionalSpeech.check_PlayerStatus) --OnPlayerUpdate(playerObj) --checks moodlestatus

Events.OnHitZombie.Add(ConditionalSpeech.check_ZombieHit)
Events.OnWeaponHitTree.Add(ConditionalSpeech.check_WeaponHitTree)
Events.OnZombieDead.Add(ConditionalSpeech.check_ZombieKill)
Events.LevelPerk.Add(ConditionalSpeech.check_LevelUp)
Events.OnSeeNewRoom.Add(ConditionalSpeech.check_NewRoom)
Events.OnPlayerGetDamage.Add(ConditionalSpeech.check_PlayerGetDamage)
Events.OnClothingUpdated.Add(ConditionalSpeech.check_ClothingUpdated)
Events.OnCreatePlayer.Add(ConditionalSpeech.check_CreatePlayer)
Events.OnVehicleDamageTexture.Add(ConditionalSpeech.check_VehicleDamage)
Events.OnFillContainer.Add(ConditionalSpeech.check_FillContainer)
Events.OnAnimalTracks.Add(ConditionalSpeech.check_AnimalTracks)
Events.OnItemFound.Add(ConditionalSpeech.check_ItemFound)

if ISEatFoodAction then
	local ConditionalSpeech_EatFood_perform = ISEatFoodAction.perform
	function ISEatFoodAction:perform()
		ConditionalSpeech_EatFood_perform(self)
		ConditionalSpeech.check_AteFood(self.character, self.item)
	end
end

local phraseSets = require "ConditionalSpeech_PhraseSet"
Events.OnGameBoot.Add(phraseSets.Load)

local metaValues = require "ConditionalSpeech_metaValues"
Events.OnGameBoot.Add(metaValues.createTrueArrayForPlosives)

require "ConditionalSpeech_ModOptions"