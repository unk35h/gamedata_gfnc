-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityWhiteDayController = class("ActivityWhiteDayController", ControllerBase)
local base = ControllerBase
local ActWhiteDayData = require("Game.ActivityWhiteDay.Data.ActWhiteDayData")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local ActivityWhiteDaySceneCtrl = require("Game.ActivityWhiteDay.ActivityWhiteDaySceneCtrl")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
ActivityWhiteDayController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, eDynConfigData, ActivityWhiteDaySceneCtrl
  self.whiteDayNetWork = NetworkManager:GetNetwork(NetworkTypeID.WhiteDay)
  self.__AWDDataDic = {}
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_factory)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_order)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_line)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_assist_hero)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_photo)
  ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_event)
  self.__onItemUpdate = BindCallback(self, self.__OnItemUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  self.__onTaskUpdate = BindCallback(self, self.__OnTaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__onTaskUpdate)
  self.__OnWDSceneDestroy = BindCallback(self, self.OnWDSceneDestroy)
  self._wdSceneCtrl = (ActivityWhiteDaySceneCtrl.New)(self)
  self.orderReddotTimerId = TimerManager:StartTimer(1, self.__OnTimeUpdate, self, false, nil, true)
  self.__2048GameCtrl = nil
end

ActivityWhiteDayController.GetWhiteDaySceneCtrl = function(self)
  -- function num : 0_1
  return self._wdSceneCtrl
end

ActivityWhiteDayController.OnWhiteDayActivityOpen = function(self, actId)
  -- function num : 0_2 , upvalues : ActWhiteDayData
  if (self.__AWDDataDic)[actId] ~= nil then
    return 
  end
  local AWDData = (ActWhiteDayData.New)(actId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__AWDDataDic)[actId] = AWDData
end

ActivityWhiteDayController.OnWhiteDayActivityClose = function(self, actId)
  -- function num : 0_3 , upvalues : _ENV
  local AWDData = (self.__AWDDataDic)[actId]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__AWDDataDic)[actId] = nil
  if (table.count)(self.__AWDDataDic) <= 0 then
    ControllerManager:DeleteController(ControllerTypeId.WhiteDay)
  end
end

ActivityWhiteDayController.UpdataSingleWhiteDayActivity = function(self, msg)
  -- function num : 0_4
  if msg == nil then
    return 
  end
  local actId = msg.actId
  local AWDData = self:GetWhiteDayDataByActId(actId)
  if AWDData == nil then
    self:OnWhiteDayActivityOpen(actId)
    AWDData = self:GetWhiteDayDataByActId(actId)
  end
  AWDData:UpdateByAWDByMsg(msg)
  self:__RefreshWDTask()
end

ActivityWhiteDayController.UpdateAllWhiteDayActivity = function(self, msgs)
  -- function num : 0_5 , upvalues : _ENV
  if msgs == nil then
    return 
  end
  for _,msg in pairs(msgs) do
    self:UpdataSingleWhiteDayActivity(msg)
  end
end

ActivityWhiteDayController.GetWhiteDayDataByActId = function(self, actId)
  -- function num : 0_6
  return (self.__AWDDataDic)[actId]
end

ActivityWhiteDayController.GetWDFactoryLineUIPos = function(self, lineId)
  -- function num : 0_7
  return (self._wdSceneCtrl):GetWDFactoryLineUIPos(lineId)
end

ActivityWhiteDayController._PlayNormalBgm = function(self)
  -- function num : 0_8 , upvalues : _ENV
  AudioManager:PlayAudioById(3320)
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Home).name, (eAuSelct.Home).oasisDay)
end

ActivityWhiteDayController.TryOpenWhiteDay = function(self, actId, allLoadOverCallabck)
  -- function num : 0_9 , upvalues : _ENV
  if actId == nil then
    return false
  end
  local AWDData = self:GetWhiteDayDataByActId(actId)
  if AWDData == nil then
    return false
  end
  if UIManager:GetWindow(UIWindowTypeID.WhiteDay) ~= nil then
    if allLoadOverCallabck ~= nil then
      allLoadOverCallabck()
    end
    return 
  end
  if AWDData:IsActivityOpen() and not AWDData:IsActivityRunning() then
    UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayAlbum, function(window)
    -- function num : 0_9_0 , upvalues : self, AWDData
    if window == nil then
      return 
    end
    window:InitWDAlbun(self, AWDData)
  end
)
    return 
  end
  local openFunc = function()
    -- function num : 0_9_1 , upvalues : AWDData, self, _ENV, allLoadOverCallabck
    if AWDData == nil or not AWDData:IsActivityRunning() then
      self:CloseWhiteDay()
      return 
    end
    local sceneName = (AWDData:GetWDCfg()).scene
    if #sceneName == 0 then
      error(" whiteSceneName is NIL")
      return 
    end
    UIManager:DeleteAllWindow()
    ;
    (UIUtil.AddOneCover)("TryOpenWhiteDay", SafePack(nil, nil, nil, Color.black, false))
    ;
    ((CS.GSceneManager).Instance):LoadSceneByAB(sceneName, function()
      -- function num : 0_9_1_0 , upvalues : self, sceneName, _ENV, AWDData, allLoadOverCallabck
      self._curLoadedSceneName = sceneName
      ;
      (UIUtil.CloseOneCover)("TryOpenWhiteDay")
      if AWDData == nil or not AWDData:IsActivityRunning() then
        self:CloseWhiteDay()
        return 
      end
      MsgCenter:AddListener(eMsgEventId.OnSceneUnload, self.__OnWDSceneDestroy)
      ;
      (self._wdSceneCtrl):OnEnterWhiteDayScene(AWDData)
      UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDay, function(win)
        -- function num : 0_9_1_0_0 , upvalues : AWDData, _ENV, self, allLoadOverCallabck
        if AWDData == nil or not AWDData:IsActivityRunning() then
          (UIUtil.ReturnHome)()
          return 
        end
        if win ~= nil then
          win:InitWhiteDayUI(self, AWDData)
        end
        if allLoadOverCallabck ~= nil then
          allLoadOverCallabck()
        end
        GuideManager:TryTriggerGuide(eGuideCondition.ActWhiteDayMain)
      end
)
    end
)
    self:_PlayNormalBgm()
  end

  local avgId = AWDData:GetAWDFirstEnterAvgId()
  if avgId ~= nil and avgId > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed(avgId)
    if not played and AWDData:IsActivityRunning() then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId, openFunc)
    else
      openFunc()
    end
  else
    do
      openFunc()
      return true
    end
  end
end

ActivityWhiteDayController.CloseWhiteDay = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:DeleteAllWindow()
  ;
  (UIUtil.AddOneCover)("WDBack2Main", SafePack(nil, nil, nil, Color.black, false))
  ;
  ((CS.GSceneManager).Instance):LoadSceneByAB((Consts.SceneName).Main, function()
    -- function num : 0_10_0 , upvalues : _ENV
    (UIUtil.CloseOneCover)("WDBack2Main")
    ;
    (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
    UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
      -- function num : 0_10_0_0 , upvalues : _ENV
      if window == nil then
        return 
      end
      window:SetFrom2Home(AreaConst.FactoryDorm, true)
    end
)
  end
)
end

ActivityWhiteDayController.OnWDSceneDestroy = function(self, sceneNmae)
  -- function num : 0_11 , upvalues : _ENV
  if sceneNmae == self._curLoadedSceneName then
    self._curLoadedSceneName = nil
    if self._wdSceneCtrl ~= nil then
      (self._wdSceneCtrl):OnExitWhiteDayScene()
    end
    MsgCenter:RemoveListener(eMsgEventId.OnSceneUnload, self.__OnWDSceneDestroy)
  end
end

ActivityWhiteDayController.OpenWhitrDaySector = function(self, AWDData, successCallback)
  -- function num : 0_12 , upvalues : SectorStageDetailHelper, _ENV
  local sectorId = AWDData:GetAWDSectorId()
  if not (SectorStageDetailHelper.IsSectorNoCollide)(sectorId, true) then
    return 
  end
  UIManager:HideWindow(UIWindowTypeID.WhiteDay)
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevel, function(window)
    -- function num : 0_12_0 , upvalues : successCallback, sectorId, _ENV
    if window == nil then
      return 
    end
    if successCallback ~= nil then
      successCallback()
    end
    window:InitSectorLevel(sectorId, function()
      -- function num : 0_12_0_0 , upvalues : _ENV
      UIManager:ShowWindowOnly(UIWindowTypeID.WhiteDay)
    end
, nil, nil, nil)
    window:SetCustomEnterFmtCallback(function(enterFmtData)
      -- function num : 0_12_0_1
      if enterFmtData ~= nil then
        enterFmtData:SetFmtForbidSupport(true)
        enterFmtData:SetIsShowSupportHolder(true)
      end
    end
)
  end
)
end

ActivityWhiteDayController.IsWDSector = function(self, sectorId)
  -- function num : 0_13 , upvalues : _ENV
  for actId,AWDData in pairs(self.__AWDDataDic) do
    if AWDData:GetAWDSectorId() == sectorId then
      return true, AWDData
    end
  end
  return false
end

ActivityWhiteDayController.TryEnterWDSector = function(self, sectorId, successCallback)
  -- function num : 0_14
  local isWDSector, AWDData = self:IsWDSector(sectorId)
  do
    if isWDSector and AWDData:IsActivityRunning() then
      local actId = AWDData:GetActId()
      self:TryOpenWhiteDay(actId, function()
    -- function num : 0_14_0 , upvalues : self, AWDData, successCallback
    self:OpenWhitrDaySector(AWDData, successCallback)
  end
)
      return true
    end
    return false
  end
end

ActivityWhiteDayController.WDTryShowFactroyLevelUp = function(self, AWDData, callback)
  -- function num : 0_15 , upvalues : _ENV
  local beforeLevelUpLevel = AWDData:GetWDBeforeLevelUpLevel()
  AWDData:SetWDHasShowedLevelUp()
  if beforeLevelUpLevel == nil then
    if callback ~= nil then
      callback()
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayFactoryLevelUp, function(window)
    -- function num : 0_15_0 , upvalues : callback, AWDData, beforeLevelUpLevel
    if window == nil then
      if callback ~= nil then
        callback()
      end
      return 
    end
    window:InitWDFactoryLevelUp(AWDData, beforeLevelUpLevel, callback)
  end
)
end

ActivityWhiteDayController.SetWD2048GameCtrl = function(self, ctrl)
  -- function num : 0_16
  self.__2048GameCtrl = ctrl
end

ActivityWhiteDayController.GetWD2048GameCtrl = function(self)
  -- function num : 0_17
  return self.__2048GameCtrl
end

ActivityWhiteDayController.WDStartLineOrder = function(self, actFrameId, orderId, assistHeroId, lineId)
  -- function num : 0_18 , upvalues : _ENV
  (self.whiteDayNetWork):CS_Activity_Factory_Product(actFrameId, lineId, orderId, assistHeroId, function()
    -- function num : 0_18_0 , upvalues : _ENV, lineId, self, assistHeroId
    MsgCenter:Broadcast(eMsgEventId.WhiteDayOrderChange, lineId)
    ;
    (self._wdSceneCtrl):AddWDBindRole(lineId, assistHeroId)
    local voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.InFactory, nil, assistHeroId)
    local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
    cvCtr:PlayCv(assistHeroId, voiceId)
  end
)
end

ActivityWhiteDayController.WDAccLineOrder = function(self, actFrameId, itemId, itemNum, lineId, callback)
  -- function num : 0_19 , upvalues : _ENV
  (self.whiteDayNetWork):CS_Activity_Factory_Order_Speed(actFrameId, lineId, itemId, itemNum, function()
    -- function num : 0_19_0 , upvalues : _ENV, lineId, callback
    MsgCenter:Broadcast(eMsgEventId.WhiteDayOrderChange, lineId, true)
    if callback ~= nil then
      callback()
    end
  end
)
end

ActivityWhiteDayController.WDFinishLineOrder = function(self, actFrameId, lineId, callback)
  -- function num : 0_20 , upvalues : _ENV
  (self.whiteDayNetWork):CS_Activity_Factory_Collect(actFrameId, lineId, function(args)
    -- function num : 0_20_0 , upvalues : _ENV, lineId, callback, self
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local rewardDic = args[0]
    MsgCenter:Broadcast(eMsgEventId.WhiteDayOrderChange, lineId)
    if callback ~= nil then
      callback(rewardDic)
    end
    ;
    (self._wdSceneCtrl):RemoveWDBindRole(lineId)
  end
)
end

ActivityWhiteDayController.WDRandomPickPhoto = function(self, AWDData, callback)
  -- function num : 0_21 , upvalues : _ENV
  local actFrameId = AWDData:GetActFrameId()
  ;
  (self.whiteDayNetWork):CS_Activity_Polariod_Lottery(actFrameId, function(args)
    -- function num : 0_21_0 , upvalues : _ENV, callback, AWDData
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local photoId = args[0]
    MsgCenter:Broadcast(eMsgEventId.WhiteDayPhotoChange, photoId)
    if callback ~= nil then
      callback(photoId)
    end
    AWDData:RefreshWDReddot4AlbumAvg()
  end
)
end

ActivityWhiteDayController.WDPickPhoto = function(self, AWDData, photoId, callback)
  -- function num : 0_22 , upvalues : _ENV
  local actFrameId = AWDData:GetActFrameId()
  ;
  (self.whiteDayNetWork):CS_Activity_Polariod_SelfSelect(actFrameId, photoId, function()
    -- function num : 0_22_0 , upvalues : _ENV, photoId, callback, AWDData
    MsgCenter:Broadcast(eMsgEventId.WhiteDayPhotoChange, photoId)
    if callback ~= nil then
      callback(photoId)
    end
    AWDData:RefreshWDReddot4AlbumAvg()
  end
)
end

ActivityWhiteDayController.WDEndlessTaskCommit = function(self, AWDData, taskId, callback)
  -- function num : 0_23 , upvalues : _ENV
  local actFrameId = AWDData:GetActFrameId()
  local network = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  network:CS_Activity_Quest_Commit(actFrameId, taskId, callback)
end

ActivityWhiteDayController.WDTaskCommit = function(self, AWDData, taskData, callback)
  -- function num : 0_24 , upvalues : _ENV
  (NetworkManager:GetNetwork(NetworkTypeID.Task)):SendCommitQuest(taskData, function()
    -- function num : 0_24_0 , upvalues : callback, AWDData
    if callback ~= nil then
      callback()
    end
    AWDData:RefreshWDReddot4Task()
  end
)
end

ActivityWhiteDayController.__OnItemUpdate = function(self, itemUpdate, resourceData, itemUpdateCount)
  -- function num : 0_25 , upvalues : _ENV
  for actId,AWDData in pairs(self.__AWDDataDic) do
    for itemId,_ in pairs(itemUpdate) do
      if itemUpdateCount[itemId] ~= nil and itemUpdateCount[itemId] > 0 then
        local randomItemId = AWDData:GetWDRandomPhotoItemIdAndNum()
        local pickItemId = AWDData:GetWDExchangePhotoItemIdAndNum()
        if randomItemId == itemId or pickItemId == itemId then
          AWDData:SetWDReddot4Album(true)
          break
        end
      end
    end
  end
end

ActivityWhiteDayController.__OnTaskUpdate = function(self)
  -- function num : 0_26 , upvalues : _ENV
  for actId,AWDData in pairs(self.__AWDDataDic) do
    AWDData:RefreshWDReddot4Task()
  end
end

ActivityWhiteDayController.__OnTimeUpdate = function(self)
  -- function num : 0_27 , upvalues : _ENV
  for actId,AWDData in pairs(self.__AWDDataDic) do
    AWDData:RefreshWDReddot4Order()
  end
end

ActivityWhiteDayController.__RefreshWDTask = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.WhiteDayTask)
  if win ~= nil then
    win:RefreshWDTaskList()
  end
end

ActivityWhiteDayController.OnDelete = function(self)
  -- function num : 0_29 , upvalues : _ENV, eDynConfigData, base
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_factory)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_order)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_line)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_assist_hero)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_photo)
  ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_event)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__onItemUpdate)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__onTaskUpdate)
  ;
  (base.OnDelete)(self)
  if self.orderReddotTimerId ~= nil then
    TimerManager:StopTimer(self.orderReddotTimerId)
    self.orderReddotTimerId = nil
  end
  ;
  (self._wdSceneCtrl):Delete()
  self._wdSceneCtrl = nil
end

return ActivityWhiteDayController

