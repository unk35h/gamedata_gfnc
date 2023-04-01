-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsExplosion = class("SmashingPenguinsExplosion", UIBaseNode)
local base = UIBaseNode
local CS_Animator = (CS.UnityEngine).Animator
SmashingPenguinsExplosion.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_Animator
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.animator = (self.gameObject):GetComponent(typeof(CS_Animator))
end

SmashingPenguinsExplosion.InitSmashingPenguinsExplosion = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (self.animator):Play("PenguinExplosion", 0, 0)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(0.6, function()
    -- function num : 0_1_0 , upvalues : self
    self:DestroySmashingPenguinsExplosionFx()
  end
)
end

SmashingPenguinsExplosion.DestroySmashingPenguinsExplosionFx = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    self:Delete()
    return 
  end
  ;
  (mainUI.explosionPool):HideOne(self)
end

SmashingPenguinsExplosion.OnHide = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
end

SmashingPenguinsExplosion.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
end

return SmashingPenguinsExplosion

