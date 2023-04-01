-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSummerLvLeftInfo = class("UINActSummerLvLeftInfo", UIBaseNode)
local base = UIBaseNode
local UINActSummerLvSwitchBtn = require("Game.ActivitySummer.UI.UINActSummerLvSwitchBtn")
UINActSummerLvLeftInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActSummerLvSwitchBtn
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickSummerIntro)
  self.lvBtnPool = (UIItemPool.New)(UINActSummerLvSwitchBtn, (self.ui).btn_DiffSwitch)
  ;
  ((self.ui).btn_DiffSwitch):SetActive(false)
  self.__OnSelectLv = BindCallback(self, self.OnSelectSummerLv)
end

UINActSummerLvLeftInfo.InittSummerLvLeftInfo = function(self, summerData, curSectorId, selectFunc, outDataFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.summerData = summerData
  local summerCfg = summerData:GetSectorICfg()
  self.selectFunc = selectFunc
  self.outDataFunc = outDataFunc
  self.curSectorId = curSectorId
  self._outDataTime = (self.summerData):GetActivityEndTime()
  self.sectorList = {summerCfg.easy_stage, summerCfg.hard_stage}
  ;
  (self.lvBtnPool):HideAll()
  for i,sectorId in ipairs(self.sectorList) do
    local item = (self.lvBtnPool):GetOne()
    item:InitSummerLvBtn(i, self.__OnSelectLv)
  end
  self:RefreshSelectBtnState()
  if PlayerDataCenter.timestamp < self._outDataTime and self.timerId == nil then
    self.timerId = TimerManager:StartTimer(1, self.OnTimerSummerCutDown, self)
  end
  self:OnTimerSummerCutDown()
end

UINActSummerLvLeftInfo.RefreshSectorId = function(self, sectorId)
  -- function num : 0_2
  self.curSectorId = sectorId
  self:RefreshSelectBtnState()
end

UINActSummerLvLeftInfo.OnSelectSummerLv = function(self, index)
  -- function num : 0_3 , upvalues : _ENV
  local selectSectorId = (self.sectorList)[index]
  if self.selectFunc == nil or selectSectorId == nil or selectSectorId == self.curSectorId then
    return 
  end
  ;
  (self.selectFunc)(selectSectorId)
  ;
  (PlayerDataCenter.sectorStage):SetSelectSectorId(selectSectorId)
end

UINActSummerLvLeftInfo.OnClickSummerIntro = function(self)
  -- function num : 0_4 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_4_0 , upvalues : _ENV
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(7005), ConfigData:GetTipContent(7010))
  end
)
end

UINActSummerLvLeftInfo.RefreshSelectBtnState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for i,item in ipairs((self.lvBtnPool).listItem) do
    item:SetSummerLvState(self.curSectorId == (self.sectorList)[i])
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINActSummerLvLeftInfo.OnTimerSummerCutDown = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._outDataTime <= PlayerDataCenter.timestamp then
    if self.timerId ~= nil then
      TimerManager:StopTimer(self.timerId)
      self.timerId = nil
    end
    if self.outDataFunc ~= nil then
      (self.outDataFunc)()
    end
    return 
  end
  local remainTime = self._outDataTime - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remainTime, false, true)
  if d > 0 then
    ((self.ui).tex_Timer):SetIndex(0, tostring(d), (string.format)("%02d", h), (string.format)("%02d", m))
  else
    if h > 0 then
      ((self.ui).tex_Timer):SetIndex(1, (string.format)("%02d", h), (string.format)("%02d", m))
    else
      if m <= 0 or not m then
        m = 1
      end
      ;
      ((self.ui).tex_Timer):SetIndex(2, (string.format)("%02d", m))
    end
  end
end

UINActSummerLvLeftInfo.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  (self.lvBtnPool):DeleteAll()
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINActSummerLvLeftInfo

