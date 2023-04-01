-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityHistoryTinyGameController = class("ActivityHistoryTinyGameController", ControllerBase)
local base = ControllerBase
local HistoryTinyGameData = require("Game.ActivityHistoryTinyGame.Data.HistoryTinyGameData")
ActivityHistoryTinyGameController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  self.__HTGDataDic = {}
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self.__TaskReceiveCallback = BindCallback(self, self.__TaskReceive)
  MsgCenter:AddListener(eMsgEventId.TaskCommitComplete, self.__TaskReceiveCallback)
  self.__AvgPlayedCallBack = BindCallback(self, self.__AvgPlayed)
  MsgCenter:AddListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
  self.__ExpireDealCallback = BindCallback(self, self.__ExpireDeal)
end

ActivityHistoryTinyGameController.OnActivityOpen = function(self, actId)
  -- function num : 0_1 , upvalues : HistoryTinyGameData
  if (self.__HTGDataDic)[actId] ~= nil then
    return 
  end
  local HTGData = (HistoryTinyGameData.New)(actId)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__HTGDataDic)[actId] = HTGData
end

ActivityHistoryTinyGameController.OnActivityClose = function(self, actId)
  -- function num : 0_2 , upvalues : _ENV
  local HTGData = (self.__HTGDataDic)[actId]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__HTGDataDic)[actId] = nil
  if (table.count)(self.__HTGDataDic) <= 0 then
    ControllerManager:DeleteController(ControllerTypeId.HistoryTinyGameActivity)
  end
end

ActivityHistoryTinyGameController.UpdataSingleActivity = function(self, msg)
  -- function num : 0_3
  if msg == nil then
    return 
  end
  local actId = msg.actId
  local HTGData = self:GetDataByActId(actId)
  if HTGData == nil then
    self:OnActivityOpen(actId)
    HTGData = self:GetDataByActId(actId)
  end
  HTGData:UpdateHTGDataByMsg(msg)
  ;
  (self._frameCtrl):AddActivityDataUpdateTimeListen(HTGData:GetActFrameId(), HTGData:GetTinyGameNextTm() + 1, self.__ExpireDealCallback)
end

ActivityHistoryTinyGameController.__ExpireDeal = function(self, activityFrameId)
  -- function num : 0_4 , upvalues : _ENV
  local actFrameData = (self._frameCtrl):GetActivityFrameData(activityFrameId)
  local data = (self.__HTGDataDic)[actFrameData:GetActId()]
  if data == nil then
    return 
  end
  local tinyNetCtrl = NetworkManager:GetNetwork(NetworkTypeID.ActivityHistoryTinyGame)
  tinyNetCtrl:CS_ACTIVITY_TinyGame_RefreshQuestAll(data:GetActId(), function(args)
    -- function num : 0_4_0 , upvalues : _ENV, data, self, activityFrameId
    if args.Count == 0 then
      error("args.Count == 0")
      return 
    end
    local msg = args[0]
    data:UpdateHTGDailyTask(msg)
    ;
    (self._frameCtrl):AddActivityDataUpdateTimeListen(activityFrameId, data:GetTinyGameNextTm() + 1, self.__ExpireDealCallback)
    MsgCenter:Broadcast(eMsgEventId.ActivityTinyGameTaskExpired)
  end
)
end

ActivityHistoryTinyGameController.GetDataByActId = function(self, actId)
  -- function num : 0_5
  return (self.__HTGDataDic)[actId]
end

ActivityHistoryTinyGameController.GetOneHTGData = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for k,v in pairs(self.__HTGDataDic) do
    do return v end
  end
end

ActivityHistoryTinyGameController.TryOpenHistoryTinyGame = function(self, actId, allLoadOverCallabck, isOpenMain)
  -- function num : 0_7 , upvalues : _ENV
  if actId == nil then
    return false
  end
  local HTGData = self:GetDataByActId(actId)
  if HTGData == nil then
    return false
  end
  local win = UIManager:GetWindow(UIWindowTypeID.ActivityMiniGameMain)
  if win ~= nil then
    if allLoadOverCallabck ~= nil then
      allLoadOverCallabck()
    end
    if isOpenMain then
      win:OnHTGOpenSubUI(1)
    end
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActivityMiniGameMain, function(win)
    -- function num : 0_7_0 , upvalues : HTGData, _ENV, allLoadOverCallabck
    if HTGData == nil or not HTGData:IsActivityOpen() then
      (UIUtil.ReturnHome)()
      return 
    end
    if win ~= nil then
      local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWin ~= nil then
        win:SetFromWhichUI(eBaseWinFromWhere.home)
        homeWin:OpenOtherWin()
        local oasisCtrl = ControllerManager:GetController(ControllerTypeId.OasisController)
        if oasisCtrl ~= nil then
          (oasisCtrl.weatherCtrl):StopWeatherEffect()
        end
      end
      do
        do
          win:InitMiniGameGroupMain(HTGData, function()
      -- function num : 0_7_0_0 , upvalues : _ENV
      local oasisCtrl = ControllerManager:GetController(ControllerTypeId.OasisController)
      if oasisCtrl ~= nil then
        (oasisCtrl.weatherCtrl):RandomNewWeather()
      end
    end
)
          if allLoadOverCallabck ~= nil then
            allLoadOverCallabck()
          end
        end
      end
    end
  end
)
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local AVG2 = function()
    -- function num : 0_7_1 , upvalues : HTGData, avgPlayCtrl, _ENV
    local avgId2 = HTGData:GetSecondAvgId()
    if avgId2 ~= nil and avgId2 > 0 then
      local played = avgPlayCtrl:IsAvgPlayed(avgId2)
      if not played and HTGData:IsActivityRunning() then
        (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId2)
      end
    end
  end

  local avgId1 = HTGData:GetFirstAvgId()
  if avgId1 ~= nil and avgId1 > 0 then
    local played = avgPlayCtrl:IsAvgPlayed(avgId1)
    if not played and HTGData:IsActivityRunning() then
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId1, function()
    -- function num : 0_7_2 , upvalues : _ENV, HTGData
    GuideManager:StartNewGuide(HTGData:GetAfterFirstAvgGuideId())
  end
)
      return 
    end
  else
    do
      AVG2()
      return true
    end
  end
end

ActivityHistoryTinyGameController.__TaskUpdate = function(self, taskData)
  -- function num : 0_8 , upvalues : _ENV
  for k,v in pairs(self.__HTGDataDic) do
    v:RefreshHTGTaskReddot(taskData.id)
    v:RefreshHTGAvgReddot(nil, taskData.id)
  end
end

ActivityHistoryTinyGameController.__TaskReceive = function(self, taskStc)
  -- function num : 0_9 , upvalues : _ENV
  for k,v in pairs(self.__HTGDataDic) do
    v:RefreshHTGTaskReddot(taskStc.id)
    v:RefreshHTGAvgReddot(nil, taskStc.id)
  end
end

ActivityHistoryTinyGameController.__AvgPlayed = function(self, avgId)
  -- function num : 0_10 , upvalues : _ENV
  for k,v in pairs(self.__HTGDataDic) do
    v:RefreshHTGAvgReddot(avgId, nil)
  end
end

ActivityHistoryTinyGameController.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  MsgCenter:RemoveListener(eMsgEventId.TaskCommitComplete, self.__TaskReceiveCallback)
  MsgCenter:RemoveListener(eMsgEventId.AVGLogicPlayed, self.__AvgPlayedCallBack)
end

return ActivityHistoryTinyGameController

