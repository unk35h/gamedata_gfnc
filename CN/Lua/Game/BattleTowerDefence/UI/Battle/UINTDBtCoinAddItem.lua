-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTDBtCoinAddItem = class("UINTDBtCoinAddItem", UIBaseNode)
local base = UIBaseNode
local headOffset = (Vector3.New)(0, 1.5, 0)
UINTDBtCoinAddItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._returnFxFunc = BindCallback(self, self._OnReturnFx)
end

UINTDBtCoinAddItem.InitTDBtCoinAddItem = function(self, coinNum, position, returnFunc)
  -- function num : 0_1 , upvalues : _ENV, headOffset
  self.returnFunc = returnFunc
  ;
  ((self.ui).effectCommon):InitEffectCommon(self._returnFxFunc, (self.gameObject).name)
  if coinNum >= 99 then
    error("Unsurpported num:" .. tostring(coinNum))
    return 
  end
  local num1 = coinNum // 10
  local num2 = coinNum % 10
  local mat = ((self.ui).psRender).material
  mat:SetInt("_Count1", num1)
  mat:SetInt("_Count2", num2)
  local uiPos = UIManager:World2UIPosition(position + headOffset)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = uiPos
end

UINTDBtCoinAddItem._OnReturnFx = function(self, effectCommon)
  -- function num : 0_2
  if effectCommon ~= (self.ui).effectCommon then
    return 
  end
  if self.returnFunc ~= nil then
    (self.returnFunc)(self)
  end
end

UINTDBtCoinAddItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINTDBtCoinAddItem

