-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsEntityBase")
local SmashingPenguinsBombEntity = class("SmashingPenguinsBombEntity", base)
SmashingPenguinsBombEntity.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  local listener = ((CS.ColliderEventListener).Get)(self.transform)
  listener:TriggerEnter2DEvent("+", BindCallback(self, self._OnTriggerEnter))
  listener:TriggerExit2DEvent("+", BindCallback(self, self._OnTriggerLeave))
end

SmashingPenguinsBombEntity.InitEntityData = function(self, characterEntity, controller)
  -- function num : 0_1 , upvalues : base
  self.isUsed = false
  ;
  (base.InitEntityData)(self, characterEntity, controller)
end

SmashingPenguinsBombEntity._OnTriggerEnter = function(self, collider)
  -- function num : 0_2
  if self.isUsed then
    return 
  end
  if collider.gameObject == (self.characterEntity).gameObject then
    if (self.mainController).getBomb then
      (self.mainController):ReGetBomb(self)
      return 
    end
    self:SetBombGotten()
  end
end

SmashingPenguinsBombEntity._OnTriggerLeave = function(self)
  -- function num : 0_3
  (self.mainController):RemoveReGetBomb(self)
end

SmashingPenguinsBombEntity.SetBombGotten = function(self)
  -- function num : 0_4
  (self.mainController):GetBomb()
  self.isUsed = true
  self:Hide()
end

SmashingPenguinsBombEntity.OnHide = function(self)
  -- function num : 0_5
  (self.mainController):RemoveReGetBomb(self)
end

return SmashingPenguinsBombEntity

