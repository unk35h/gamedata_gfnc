-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDiffLevelMulLineCanvas = require("Game.Sector.SectorLevel.UINDiffLevelMulLineCanvas")
local UINDiffLevelMulLineActWinter23Canvas = class("UINDiffLevelMulLineActWinter23Canvas", UINDiffLevelMulLineCanvas)
local base = UINDiffLevelMulLineCanvas
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local sectorLevelUtil = require("Game.Sector.SectorLevel.SectorLevelUtil")
UINDiffLevelMulLineActWinter23Canvas.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).switchTween).onComplete):AddListener(BindCallback(self, self.OnSwitchTweenComplete))
  ;
  (((self.ui).switchTween).onRewind):AddListener(BindCallback(self, self.OnSwitchTweenRewind))
end

UINDiffLevelMulLineActWinter23Canvas.InitDiffLevelCanvas = function(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
  -- function num : 0_1 , upvalues : base
  (base.InitDiffLevelCanvas)(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
end

UINDiffLevelMulLineActWinter23Canvas.InitLevelGroupData = function(self)
  -- function num : 0_2 , upvalues : sectorLevelUtil
  self.finalPage = nil
  self.splitPointPage = nil
  self.layourDic = nil
  self:_ReGenArrangeCfg()
  if self.levelState then
    self.levelGroupDataList = (sectorLevelUtil.GetLevelGroupByOneLineAndNoAvg)(self.arrangeCfg, self:GetLevelList(), self._sectorStageIdGroupMapping)
  else
    self.levelGroupDataList = (sectorLevelUtil.GetLevelGroupByNormalMulLine)(self.arrangeCfg, self:GetLevelList(), self._sectorStageIdGroupMapping, R5_PC14)
  end
end

UINDiffLevelMulLineActWinter23Canvas.SetSpecialLevelList = function(self, specialLevelList)
  -- function num : 0_3 , upvalues : base
  (base.SetSpecialLevelList)(self, specialLevelList)
  ;
  ((self.ui).obj_comingSoon):SetActive(false)
  self:RefreshSectorActivityExtraMount(specialLevelList)
end

UINDiffLevelMulLineActWinter23Canvas.ResetLevelGroupDataBySpecialLevelList = function(self, specialLevelList)
  -- function num : 0_4 , upvalues : base
  (base.ResetLevelGroupDataBySpecialLevelList)(self, specialLevelList)
  ;
  ((self.ui).obj_comingSoon):SetActive(false)
  self:RefreshSectorActivityExtraMount(specialLevelList)
end

UINDiffLevelMulLineActWinter23Canvas._ReGenArrangeCfg = function(self)
  -- function num : 0_5 , upvalues : _ENV, ActivityFrameEnum
  if self.levelState then
    local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(self.sectorId)
    if actData and not actData:IsActivityRunningTimeout() and actType == (ActivityFrameEnum.eActivityType).Winter23 then
      local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
      local activityData = win23Ctrl:GetWinter23DataByActId(actId)
      local newArrangeType = activityData:GetRepeatArrangeType()
      self.arrangeCfg = (ConfigData.level_arrange)[newArrangeType]
    end
  else
    do
      local sectorCfg = (ConfigData.sector)[self.sectorId]
      local levelArrangeType = (sectorCfg.level_arrange)[self.difficulty]
      local arrangeCfg = (ConfigData.level_arrange)[levelArrangeType]
      if arrangeCfg == nil then
        error((string.format)("Can\'t find level arrange Cfg,arrangeId:%s, difficulty:%s, sectorId:%s", levelArrangeType, difficulty, sectorId))
        return 
      end
      self.arrangeCfg = arrangeCfg
    end
  end
end

UINDiffLevelMulLineCanvas.GenAllSpecialListDic = function(self)
  -- function num : 0_6 , upvalues : _ENV, ActivityFrameEnum
  local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(self.sectorId)
  if actData and not actData:IsActivityRunningTimeout() and actType == (ActivityFrameEnum.eActivityType).Winter23 then
    local specialDic = {}
    local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
    local activityData = win23Ctrl:GetWinter23DataByActId(actId)
    local spList = activityData:GetRepeatStageList(self.sectorId)
    for i,v in pairs(spList) do
      specialDic[v] = true
    end
    return specialDic
  end
  do
    return nil
  end
end

UINDiffLevelMulLineActWinter23Canvas.RefreshSectorActivityExtraMount = function(self, specialLevelList)
  -- function num : 0_7 , upvalues : _ENV
  if #specialLevelList > 0 then
    return 
  end
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local activityData = win23Ctrl:GetWinter23Data()
    local delayTime = ((activityData:GetWinter23Cfg()).second_pre_para1)[1]
    ;
    ((self.ui).obj_comingSoon):SetActive(true)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).text = (string.format)("%02d", win23Ctrl:GetNowChapterId())
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Time).text = TimeUtil:TimestampToDateString(delayTime, false, true, ConfigData:GetTipContent(921))
  end
end

UINDiffLevelMulLineActWinter23Canvas.SetStopTweenCompleteEvent = function(self, bool)
  -- function num : 0_8
  self.stopTween = bool
end

UINDiffLevelMulLineActWinter23Canvas.PlayDiffLevelCanvasSwitchTween = function(self, isUpTween)
  -- function num : 0_9 , upvalues : _ENV
  ((self.gameObject).transform):SetAsLastSibling()
  if isUpTween then
    ((self.ui).switchTween):DORestart()
    ;
    ((self.ui).switchSubTween):DORestart()
  else
    self.__isBackwardsTween = true
    ;
    ((self.ui).switchTween):DOComplete()
    ;
    ((self.ui).switchTween):DOPlayBackwards()
    ;
    ((self.ui).switchSubTween):DOComplete()
    ;
    ((self.ui).switchSubTween):DOPlayBackwards()
  end
  local continueWindow = UIManager:ShowWindow(UIWindowTypeID.ClickContinue)
  continueWindow:InitContinue(nil, nil, nil, Color.clear, false)
end

UINDiffLevelMulLineActWinter23Canvas.OnSwitchTweenComplete = function(self)
  -- function num : 0_10
  if self.__isBackwardsTween then
    return 
  end
  self:OnSwitchTweenEndEvent()
end

UINDiffLevelMulLineActWinter23Canvas.OnSwitchTweenRewind = function(self)
  -- function num : 0_11
  if not self.__isBackwardsTween then
    return 
  end
  self.__isBackwardsTween = false
  self:OnSwitchTweenEndEvent()
end

UINDiffLevelMulLineActWinter23Canvas.OnSwitchTweenEndEvent = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  ;
  ((self.ui).switchTween):DORewind()
  ;
  ((self.ui).switchSubTween):DORewind()
  if self.tweenCompleteEvent ~= nil and not self.stopTween then
    (self.tweenCompleteEvent)()
  end
  self.stopTween = false
end

UINDiffLevelMulLineActWinter23Canvas.GetLevelList = function(self)
  -- function num : 0_13
  return self.specialLevelList
end

UINDiffLevelMulLineActWinter23Canvas.OnDelete = function(self)
  -- function num : 0_14 , upvalues : base
  (base.OnDelete)(self)
end

return UINDiffLevelMulLineActWinter23Canvas

