-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelDungeonLine = class("UINLevelDungeonLine", UIBaseNode)
local base = UIBaseNode
UINLevelDungeonLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINLevelDungeonLine.InitLevelDungeonLine = function(self, startPos, angle, length)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R4 in 'UnsetPending'

  (self.transform).localPosition = startPos
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.transform).localEulerAngles = (Vector3.New)(0, 0, angle)
  local sizeDelta = (self.transform).sizeDelta
  sizeDelta.x = length
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = sizeDelta
end

return UINLevelDungeonLine

