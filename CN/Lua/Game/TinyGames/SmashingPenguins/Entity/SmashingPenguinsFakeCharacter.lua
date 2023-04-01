-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsCharacterEntity")
local SmashingPenguinsFakeCharacter = class("SmashingPenguinsFakeCharacter", base)
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsCharacterAnimState = SmashingPenguinsEnum.eCharacterAnimState
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local CS_UnityEngine_ForceMode = (CS.UnityEngine).ForceMode2D
SmashingPenguinsFakeCharacter._OnCollisionEnter = function(self, collider)
  -- function num : 0_0 , upvalues : SmashingPenguinsCharacterAnimState
  if self.canPlayRollAnim then
    self:SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Roll)
  end
end

SmashingPenguinsFakeCharacter.LookAtDir = function(self, moveForward, forceSet)
  -- function num : 0_1 , upvalues : _ENV
  if not forceSet and not self.canLookAtDir then
    moveForward.y = 0
  end
  local localScale = (self.transform).localScale
  if moveForward.x <= 0 then
    localScale.y = (math.abs)(localScale.y)
  else
    localScale.y = -(math.abs)(localScale.y)
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localScale = localScale
  local forward = (Vector3.New)(moveForward.y, -moveForward.x, 0)
  local rotation = (Quaternion.LookRotation)(Vector3.forward, forward)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.transform).rotation = rotation
end

return SmashingPenguinsFakeCharacter

