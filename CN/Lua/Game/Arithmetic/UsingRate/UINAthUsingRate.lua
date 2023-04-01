-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINAthUsingRate = class("UINAthUsingRate", base)
local UINAthUsingRateItem = require("Game.Arithmetic.UsingRate.UINAthUsingRateItem")
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_InputUtility = CS.InputUtility
UINAthUsingRate.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAthUsingRateItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowWindow, self, self._OnClickShowWin)
  self._rateItemPool = (UIItemPool.New)(UINAthUsingRateItem, (self.ui).usingRateItem, false)
  self:_HideDetailWin()
  self.__onFingerDown = BindCallback(self, self._OnFingerDown)
end

UINAthUsingRate.InitAthUsingRate = function(self, showWinFunc)
  -- function num : 0_1
  self._showWinFunc = showWinFunc
end

UINAthUsingRate._OnClickShowWin = function(self)
  -- function num : 0_2
  if ((self.ui).obj_window).activeInHierarchy then
    self:_HideDetailWin()
    return 
  end
  if self._showWinFunc then
    (self._showWinFunc)()
  end
end

UINAthUsingRate.ShowAthUsingRateDetail = function(self, heroData, athAreaId)
  -- function num : 0_3 , upvalues : _ENV
  self._heroData = heroData
  self._athAreaId = athAreaId
  if not self._UpdUsingRateWinFunc then
    self._UpdUsingRateWinFunc = BindCallback(self, self._UpdUsingRateWin)
    ;
    (PlayerDataCenter.allAthData):GetHeroAthStat((self._heroData).dataId, self._UpdUsingRateWinFunc)
  end
end

UINAthUsingRate._UpdUsingRateWin = function(self, heroAthStat)
  -- function num : 0_4 , upvalues : _ENV, cs_LeanTouch
  local heroName = (self._heroData):GetName()
  local areaCfg = (ConfigData.ath_area)[self._athAreaId]
  if areaCfg == nil then
    error("Can\'t find ath areaCfg, areaId = " .. tostring(self._athAreaId))
    return 
  end
  local areaName = (LanguageUtil.GetLocaleText)(areaCfg.name2)
  ;
  ((self.ui).tex_NameRange):SetIndex(0, heroName, areaName)
  ;
  (self._rateItemPool):HideAll()
  local affixList = ((heroAthStat.slots)[self._athAreaId]).affix
  for k,elem in ipairs(affixList) do
    local rateItem = (self._rateItemPool):GetOne()
    rateItem:InitAthUsingRateItem(elem)
  end
  do
    if #(self._rateItemPool).listItem < 3 then
      ((self.ui).obj_window):SetActive(true)
      ;
      ((self.ui).obj_WindowOpenMask):SetActive(true)
      ;
      (cs_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
      self._addFingerListner = true
    end
  end
end

UINAthUsingRate.Show = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Algorithm_Rate) then
    self:Hide()
    return 
  end
  ;
  (base.Show)(self)
end

UINAthUsingRate._HideDetailWin = function(self)
  -- function num : 0_6
  ((self.ui).obj_window):SetActive(false)
  ;
  ((self.ui).obj_WindowOpenMask):SetActive(false)
  self:_RemoveFingerDownListner()
end

UINAthUsingRate._OnFingerDown = function(self, leanFinger)
  -- function num : 0_7 , upvalues : cs_InputUtility, _ENV
  if not (cs_InputUtility.OverUIValidTag)(TagConsts.ValidTarget) then
    self:_HideDetailWin()
  end
end

UINAthUsingRate._RemoveFingerDownListner = function(self)
  -- function num : 0_8 , upvalues : cs_LeanTouch
  if self._addFingerListner then
    (cs_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
    self._addFingerListner = false
  end
end

UINAthUsingRate.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self._rateItemPool):DeleteAll()
  self:_RemoveFingerDownListner()
  ;
  (base.OnDelete)(self)
end

return UINAthUsingRate

