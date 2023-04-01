-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsEntityBase")
local SmashingPenguinsWindEntity = class("SmashingPenguinsWindEntity", base)
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsCharacterAnimState = SmashingPenguinsEnum.eCharacterAnimState
SmashingPenguinsWindEntity.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  local listener = ((CS.ColliderEventListener).Get)(self.transform)
  listener:TriggerEnter2DEvent("+", BindCallback(self, self._OnTriggerEnter))
end

SmashingPenguinsWindEntity._OnTriggerEnter = function(self, collider)
  -- function num : 0_1 , upvalues : _ENV, SmashingPenguinsConfig, SmashingPenguinsCharacterAnimState
  if collider.gameObject == (self.characterEntity).gameObject then
    AudioManager:PlayAudioById(1281)
    local force = (Vector2.New)((SmashingPenguinsConfig.WindForce).x, (SmashingPenguinsConfig.WindForce).y)
    local forceDir = force.normalized
    local forcePower = force.magnitude
    local velocity = ((self.characterEntity).rigidbody).velocity
    if velocity.x > 0 then
      velocity.x = velocity.x * (SmashingPenguinsConfig.VelocityMultipleBeforeWind).x
    end
    if velocity.y < 0 then
      velocity.y = velocity.y * (SmashingPenguinsConfig.VelocityMultipleBeforeWind).y
    end
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.characterEntity).rigidbody).velocity = velocity
    ;
    (self.characterEntity):AddForceToSmashingPenguinsCharacter(forceDir, forcePower)
    ;
    (self.characterEntity):SetSmashingPenguinsAnimState(SmashingPenguinsCharacterAnimState.Roll)
  end
end

return SmashingPenguinsWindEntity

