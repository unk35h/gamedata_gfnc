-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsEntityBase = class("SmashingPenguinsEntityBase", UIBaseNode)
SmashingPenguinsEntityBase.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.canLookAtDir = true
  self.characterEntity = nil
  self.mainController = nil
end

SmashingPenguinsEntityBase.InitEntityData = function(self, characterEntity, controller)
  -- function num : 0_1
  self.characterEntity = characterEntity
  self.mainController = controller
end

SmashingPenguinsEntityBase.GetLocalUnityBorder = function(self)
  -- function num : 0_2
  local leftX = ((self.transform).localPosition).x + ((self.transform).rect).xMin
  local rightX = ((self.transform).localPosition).x + ((self.transform).rect).xMax
  local downY = ((self.transform).localPosition).y + ((self.transform).rect).yMin
  local upY = ((self.transform).localPosition).y + ((self.transform).rect).yMax
  return leftX, rightX, downY, upY
end

SmashingPenguinsEntityBase.LookAtDir = function(self, moveForward)
  -- function num : 0_3 , upvalues : _ENV
  local localScale = (self.transform).localScale
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.transform).localScale = localScale
  local forward = (Vector3.New)(moveForward.y, -moveForward.x, 0)
  local rotation = (Quaternion.LookRotation)(Vector3.forward, forward)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).rotation = rotation
end

return SmashingPenguinsEntityBase

