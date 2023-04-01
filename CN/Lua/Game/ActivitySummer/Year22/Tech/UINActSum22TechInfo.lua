-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.CommonUI.FloatWin.UINFloatUINode")
local UINActSum22TechInfo = class("UINActSum22TechInfo", base)
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_InputUtility = CS.InputUtility
UINActSum22TechInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__onFingerDown = BindCallback(self, self._OnFingerDown)
end

UINActSum22TechInfo.SetActSum22TechInfoHideFnc = function(self, hideFunc)
  -- function num : 0_1
  self._hideFunc = hideFunc
end

UINActSum22TechInfo.InitActSum22TechInfo = function(self, techData, targetTransform)
  -- function num : 0_2 , upvalues : HAType, VAType, _ENV
  self:FloatTo(targetTransform, HAType.autoCenter, VAType.downAuto)
  local curLv = techData:GetCurLevel()
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  if (curLv == 0 and 1) or techData:IsActTechLevelLoop() then
    (((self.ui).tex_lv).text).text = tostring(curLv)
  else
    local maxLv = techData:GetMaxLevel()
    ;
    ((self.ui).tex_lv):SetIndex(0, tostring(curLv), tostring(maxLv))
  end
  do
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_BuffName).text = techData:GetAWTechName()
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).text = techData:GetTechDescription(nil, eLogicDesType.Warchess)
  end
end

UINActSum22TechInfo._OnFingerDown = function(self, leanFinger)
  -- function num : 0_3 , upvalues : cs_InputUtility, _ENV
  if not (cs_InputUtility.OverUIValidTag)(TagConsts.ValidTarget) then
    self:Hide()
  end
end

UINActSum22TechInfo.OnShow = function(self)
  -- function num : 0_4 , upvalues : base, cs_LeanTouch
  (base.OnShow)(self)
  ;
  (cs_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
end

UINActSum22TechInfo.OnHide = function(self)
  -- function num : 0_5 , upvalues : cs_LeanTouch, base
  (cs_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
  if self._hideFunc ~= nil then
    (self._hideFunc)()
  end
  ;
  (base.OnHide)(self)
end

UINActSum22TechInfo.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22TechInfo

