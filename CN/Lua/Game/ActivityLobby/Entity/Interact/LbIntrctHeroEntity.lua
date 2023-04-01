-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityLobby.Entity.Interact.LbInteractEntityBase")
local LbIntrctHeroEntity = class("LbIntrctHeroEntity", base)
LbIntrctHeroEntity.ctor = function(self)
  -- function num : 0_0
end

LbIntrctHeroEntity.InitLbInteractEntityGo = function(self)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitLbInteractEntityGo)(self)
  if IsNull(self.gameObject) then
    return 
  end
  self.animator = (self.gameObject):FindComponent(eUnityComponentID.Animator)
  self._characterUnit = (self.gameObject):GetComponent(typeof(CS.CharacterUnit))
  if IsNull(self._characterUnit) then
    error("cant get CharacterUnit on character, obj:" .. (self.gameObject).name)
  end
end

LbIntrctHeroEntity.LbHAnimatorCrossFade = function(self, aniName, transTime)
  -- function num : 0_2
  if not transTime then
    transTime = 0.25
  end
  ;
  (self.animator):CrossFadeInFixedTime(aniName, transTime)
end

LbIntrctHeroEntity.HideLbEnttRenderer = function(self, hide)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull(self._characterUnit) then
    return 
  end
  if self._renderList == nil then
    self._renderList = {}
    for i = 0, ((self._characterUnit).smrArray).Length - 1 do
      (table.insert)(self._renderList, ((self._characterUnit).smrArray)[i])
    end
    for i = 0, ((self._characterUnit).extraRendererArray).Length - 1 do
      (table.insert)(self._renderList, ((self._characterUnit).extraRendererArray)[i])
    end
  end
  do
    for k,renderer in ipairs(self._renderList) do
      (renderer.gameObject):SetActive(not hide)
    end
  end
end

return LbIntrctHeroEntity

