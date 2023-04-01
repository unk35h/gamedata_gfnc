-- params : ...
-- function num : 0 , upvalues : _ENV
local AvgController = class("AvgController", ControllerBase)
local base = ControllerBase
local util = require("XLua.Common.xlua_util")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local CS_LanguageGlobal = CS.LanguageGlobal
local TAStrTag = "<TA>"
local CommanderNameStrTag = "<cmdr>"
AvgController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.avgWaitingList = {}
  self.autoPlayMode = false
  self.actDelayRatio = 1
  self.speedupMode = false
  self.__onAvgComplete = BindCallback(self, self.OnAvgComplete)
end

AvgController.StartAvg = function(self, chapterName, avgId, completeFunc, shieldControlSwitch, isGuideAvg, ignoreTimeScale)
  -- function num : 0_1 , upvalues : _ENV, util
  if (string.IsNullOrEmpty)(chapterName) and avgId == nil then
    error("Avg chapterName IsNullOrEmpty:" .. tostring(chapterName) .. " " .. tostring(avgId))
    return 
  end
  do
    if avgId ~= nil and (string.IsNullOrEmpty)(chapterName) then
      local avgCfg = (ConfigData.story_avg)[avgId]
      if avgCfg == nil then
        error("avg story cfg is null,id:" .. tostring(avgId))
        return 
      end
      chapterName = avgCfg.script_id
    end
    local wating = {chapterName = chapterName, completeFunc = completeFunc, avgId = avgId, shieldControlSwitch = shieldControlSwitch or false, isGuideAvg = isGuideAvg or false, ignoreTimeScale = ignoreTimeScale or false}
    ;
    (table.insert)(self.avgWaitingList, wating)
    if self.__playCoroutine == nil then
      self.__playCoroutine = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.PlayCoroutineFunc)))
    end
    MsgCenter:Broadcast(eMsgEventId.AVGPlayStart)
  end
end

AvgController.PlayCoroutineFunc = function(self)
  -- function num : 0_2 , upvalues : _ENV
  while 1 do
    while 1 do
      if #self.avgWaitingList > 0 then
        if UIManager:GetWindow(UIWindowTypeID.CommonReward) ~= nil or UIManager:IsWindowInLoading(UIWindowTypeID.CommonReward) then
          (coroutine.yield)(nil)
          -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC22: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    local waiting = (table.remove)(self.avgWaitingList, 1)
    self.avgCachePlayParam = waiting
    while not waiting.isGuideAvg and GuideManager.inGuide do
      (coroutine.yield)(nil)
    end
    self:ShowAvg(waiting.chapterName, waiting.completeFunc, waiting.shieldControlSwitch, waiting.ignoreTimeScale)
    while 1 do
      if self.avgIsPlaying and (UIManager:GetWindow(UIWindowTypeID.Avg) ~= nil or UIManager:IsWindowInLoading(UIWindowTypeID.Avg)) then
        (coroutine.yield)(nil)
        -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC68: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
    while 1 do
      if UIManager:GetWindow(UIWindowTypeID.CommonReward) ~= nil or UIManager:IsWindowInLoading(UIWindowTypeID.CommonReward) then
        (coroutine.yield)(nil)
        -- DECOMPILER ERROR at PC87: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC87: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
    while waiting.isGuideAvg or GuideManager.inGuide do
      (coroutine.yield)(nil)
    end
  end
  do
    self.__playCoroutine = nil
    self:Delete()
    MsgCenter:Broadcast(eMsgEventId.AVGCtrlPlayEnd)
  end
end

AvgController.ShowAvg = function(self, chapterName, completeFunc, shieldControlSwitch, ignoreTimeScale)
  -- function num : 0_3 , upvalues : _ENV
  if self.avgIsPlaying then
    if self.avgCachePlayParam ~= nil then
      error((string.format)("正在进行缓存播放模式,不可以直接播放avg(%s),请先结束缓存播放模式(delete controller)", chapterName))
      if completeFunc ~= nil then
        completeFunc()
      end
      return 
    end
    self:ClearCurAvg()
  end
  if (string.IsNullOrEmpty)(chapterName) then
    error("Avg chapterName IsNullOrEmpty")
    if completeFunc ~= nil then
      completeFunc()
    end
    return 
  end
  AudioManager:RecordCurBgm()
  AudioManager:RemoveAllVoice(true)
  self.completeFunc = completeFunc
  self.__originTimeScale = (Time.unity_time).timeScale
  self._hasError = nil
  if not self:LoadAvgCfg(chapterName) then
    return 
  end
  self.__ignoreTimeScale = ignoreTimeScale or false
  self.__shieldControlSwitch = shieldControlSwitch or false
  self.chapterName = chapterName
  self:_VerifyCustomSkip()
  self:ChangeSpeed()
  self.recordDataList = {}
  self.avgIsPlaying = true
  self._reqCompleteAllAvg = false
  UIManager:ShowWindowAsync(UIWindowTypeID.Avg, function(window)
    -- function num : 0_3_0 , upvalues : self, shieldControlSwitch
    if window == nil then
      return 
    end
    self.avgWindow = window
    window:InitAvgSystem(self)
    window:SetTopControlActive(not shieldControlSwitch)
    self:PlayAvgAct(1)
  end
)
end

AvgController.PlayAvgAct = function(self, actId)
  -- function num : 0_4 , upvalues : _ENV
  local nextActCfg = (self.avgCfg)[actId]
  if nextActCfg == nil then
    warn("没有该 actId : " .. tostring(actId))
    return 
  end
  self.curActId = actId
  self.avgActComplete = false
  ;
  (self.avgWindow):PlayAvgAct(nextActCfg)
  self:RecordAct(nextActCfg, actId)
end

AvgController.PlayNextAvgAct = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.curActId == nil then
    return 
  end
  local nextActCfg = (self.avgCfg)[self.curActId]
  if nextActCfg.isEnd then
    return 
  end
  local nextActId = nil
  if nextActCfg.nextId == nil then
    nextActId = self.curActId + 1
  else
    nextActId = nextActCfg.nextId
  end
  if (self.avgCfg)[nextActId] == nil then
    return 
  end
  local nextActCfg = (self.avgCfg)[nextActId]
  if nextActCfg == nil then
    warn("没有该 actId : " .. tostring(nextActId))
    return 
  end
  do
    if nextActCfg.branch ~= nil and (nextActCfg.branch).disableSelected ~= nil then
      local canNotSelectNum = 0
      for index,branchCfg in ipairs(nextActCfg.branch) do
        if branchCfg.jumpAct ~= nil and self:GetIsBranchSelected(nextActId, index) then
          canNotSelectNum = canNotSelectNum + 1
        end
      end
      if #nextActCfg.branch <= canNotSelectNum then
        self:PlayAvgAct((nextActCfg.branch).finalAct)
        return 
      end
    end
    self:PlayAvgAct(nextActId)
  end
end

AvgController.ClickContinueAvg = function(self)
  -- function num : 0_6
  if self.autoPlayMode then
    self:ClearDelayPlatNextTimer()
  end
  if self:AvgIsEnd(self.curActId) then
    self:CompleteAllAvg()
    return 
  end
  self:PlayNextAvgAct()
end

AvgController.OnAvgActComplete = function(self, selectBranchIndex, jumpAct, jumpChapter, contentLen)
  -- function num : 0_7 , upvalues : _ENV
  self.avgActComplete = true
  ;
  (self.avgWindow):StopAvgVoice()
  local avgIsEnd = self:AvgIsEnd(self.curActId)
  if avgIsEnd and not self.autoPlayMode then
    return false
  end
  if jumpAct ~= nil then
    if (self.avgCfg)[jumpAct] == nil then
      self:AvgLogError("没有该分支,id = " .. tostring(jumpAct))
      return 
    end
    self:RecordSelectedBranch(selectBranchIndex)
    self:PlayAvgAct(jumpAct)
    return true
  else
    if not (string.IsNullOrEmpty)(jumpChapter) then
      self:JumpChapter(jumpChapter)
      return true
    else
      if not self.autoPlayMode then
        return false
      end
      if self.actDelayRatio ~= 1 or not (ConfigData.buildinConfig).AvgActDelayFactor1 then
        local ratio = (ConfigData.buildinConfig).AvgActDelayFactor2
      end
      local duration = (ConfigData.buildinConfig).AvgActDelayBase + contentLen * ratio
      self.__delayPlatNextTimerId = TimerManager:StartTimer(duration, function()
    -- function num : 0_7_0 , upvalues : self, avgIsEnd
    self.__delayPlatNextTimerId = nil
    if self.avgCfg == nil then
      return 
    end
    if avgIsEnd then
      self:CompleteAllAvg()
    else
      self:PlayNextAvgAct()
    end
  end
, nil, true, false, self:AvgIgnoreTimeScale())
      return true
    end
  end
end

AvgController.AvgIsEnd = function(self, actId)
  -- function num : 0_8
  local nextActCfg = self:GetAvgNextActCfg(actId)
  if nextActCfg.isEnd then
    return true
  end
  if nextActCfg.nextId ~= nil then
    return false
  end
  if (self.avgCfg)[actId + 1] == nil then
    return true
  end
  return false
end

AvgController.LoadAvgCfg = function(self, storyName)
  -- function num : 0_9 , upvalues : _ENV, CS_LanguageGlobal
  local cfgPath = "AvgConfig." .. storyName .. ".AvgCfg_" .. storyName
  local ok, err = pcall(function()
    -- function num : 0_9_0 , upvalues : self, _ENV, cfgPath
    self.avgCfg = require(cfgPath)
    self.avgCfgPath = cfgPath
    return true
  end
)
  if not ok then
    error("Can\'t get AvgCfg, path = " .. cfgPath .. ",\n" .. err)
    self:CompleteAllAvg(true)
    return 
  end
  local lang = (CS_LanguageGlobal.GetLanguageStr)()
  local langPath = "AvgConfig." .. storyName .. ".AvgLang_" .. storyName .. "_" .. lang
  local ok, err = pcall(function()
    -- function num : 0_9_1 , upvalues : self, _ENV, langPath
    self.avgLangCfg = require(langPath)
    self.avgLangPath = langPath
    return true
  end
)
  if not ok then
    error("Can\'t get AvgLanguage, path = " .. langPath .. ",\n" .. err)
    self:CompleteAllAvg(true)
    return 
  end
  return true
end

AvgController.UnloadAvgCfg = function(self)
  -- function num : 0_10 , upvalues : _ENV
  self.avgCfg = nil
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self.avgCfgPath ~= nil then
    (package.loaded)[self.avgCfgPath] = nil
    self.avgCfgPath = nil
  end
  self.avgLangCfg = nil
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  if self.avgLangPath ~= nil then
    (package.loaded)[self.avgLangPath] = nil
    self.avgLangPath = nil
  end
  collectgarbage()
end

local getSheFunc = function(self, id, content)
  -- function num : 0_11 , upvalues : _ENV
  do
    if PlayerDataCenter.inforData ~= nil and (PlayerDataCenter.inforData):GetSex() then
      local sheContent = (self.avgLangCfg)[-id]
      if not (string.IsNullOrEmpty)(sheContent) or not content then
        content = sheContent
      end
    end
    return content
  end
end

local getTaDiffFunc = function(self, id, content)
  -- function num : 0_12 , upvalues : _ENV, TAStrTag
  local isGirl = (PlayerDataCenter.inforData ~= nil and (PlayerDataCenter.inforData):GetSex())
  do
    if not isGirl or not ConfigData:GetTipContent(12101) then
      local taStr = ConfigData:GetTipContent(12100)
    end
    content = (string.gsub)(content, TAStrTag, taStr)
    do return content end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

local getTaAndSheFunc = function(self, id, content)
  -- function num : 0_13 , upvalues : getSheFunc, getTaDiffFunc
  content = getSheFunc(self, id, content)
  content = getTaDiffFunc(self, id, content)
  return content
end

local GetLanguageContentFunc = {[eLanguageType.ZH_CN] = getTaAndSheFunc, [eLanguageType.ZH_TW] = getTaAndSheFunc, [eLanguageType.EN_US] = getTaAndSheFunc, [eLanguageType.JA_JP] = getSheFunc, [eLanguageType.KO_KR] = function(self, id, content)
  -- function num : 0_14
  return content
end
}
AvgController.GetAvgLanguage = function(self, id)
  -- function num : 0_15 , upvalues : _ENV, CS_LanguageGlobal, GetLanguageContentFunc, CommanderNameStrTag
  local content = (self.avgLangCfg)[id]
  if (string.IsNullOrEmpty)(content) then
    warn("Avg language is nil, contentId = " .. tostring(id))
    return ""
  end
  local languageInt = (CS_LanguageGlobal.GetLanguageInt)()
  local getLangContentFunc = GetLanguageContentFunc[languageInt]
  if getLangContentFunc == nil then
    error("Cant get getLangContentFunc")
  else
    content = getLangContentFunc(self, id, content)
  end
  if (string.find)(content, CommanderNameStrTag) and PlayerDataCenter.playerName ~= nil then
    content = (string.gsub)(content, CommanderNameStrTag, PlayerDataCenter.playerName)
  end
  return content
end

AvgController.SwitchAvgAutoPlay = function(self)
  -- function num : 0_16
  local delayRatio = self.actDelayRatio
  local autoPlayMode = self.autoPlayMode
  if autoPlayMode then
    if delayRatio == 1 then
      delayRatio = 2
    else
      autoPlayMode = false
      delayRatio = 1
    end
  else
    autoPlayMode = true
    delayRatio = 1
  end
  return self:SetAvgAutoPlayMode(autoPlayMode, delayRatio)
end

AvgController.SetStartAutoPlayAvg = function(self)
  -- function num : 0_17 , upvalues : _ENV
  self:SetAvgAutoPlayMode(true, 2)
  local avgWindow = UIManager:GetWindow(UIWindowTypeID.Avg)
  if avgWindow ~= nil then
    avgWindow:RefreshAutoPlay(true, 2)
  end
end

AvgController.SetAvgAutoPlayMode = function(self, autoPlayMode, delayRatio)
  -- function num : 0_18 , upvalues : _ENV
  self.autoPlayMode = autoPlayMode
  if self.autoPlayMode then
    if self.avgActComplete then
      self:ClearDelayPlatNextTimer()
      self:PlayNextAvgAct()
    else
      local avgWindow = UIManager:GetWindow(UIWindowTypeID.Avg)
      if avgWindow ~= nil then
        avgWindow:TryAvgContinuePlay()
      end
    end
  else
    do
      self:ClearDelayPlatNextTimer()
      self.actDelayRatio = delayRatio or 1
      return self.autoPlayMode, self.actDelayRatio
    end
  end
end

AvgController.CloseAvgAutoPlayMode = function(self)
  -- function num : 0_19
  return self:SetAvgAutoPlayMode(false, 1)
end

AvgController.GetAvgAutoPlayMode = function(self)
  -- function num : 0_20
  return self.autoPlayMode, self.actDelayRatio
end

AvgController.SwitchAvgSpeedup = function(self)
  -- function num : 0_21
  self.speedupMode = not self.speedupMode
  self:ChangeSpeed()
  return self.speedupMode
end

AvgController.GetAvgSpeedupMode = function(self)
  -- function num : 0_22
  return self.speedupMode
end

AvgController.ChangeSpeed = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if self:AvgIgnoreTimeScale() then
    return 
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (Time.unity_time).timeScale = self.speedupMode and (ConfigData.game_config).AvgSpeedupTimescale or 1
end

AvgController.ClearDelayPlatNextTimer = function(self)
  -- function num : 0_24 , upvalues : _ENV
  TimerManager:StopTimer(self.__delayPlatNextTimerId)
  self.__delayPlatNextTimerId = nil
end

AvgController.RecordAct = function(self, nextActCfg, actId)
  -- function num : 0_25 , upvalues : _ENV
  if nextActCfg.content == nil and nextActCfg.branch == nil then
    return 
  end
  local recordData = {actId = actId, selectedActBranchIdx = nil}
  ;
  (table.insert)(self.recordDataList, recordData)
end

AvgController.RecordSelectedBranch = function(self, selectedActBranch)
  -- function num : 0_26 , upvalues : _ENV
  local recordData = (self.recordDataList)[#self.recordDataList]
  if recordData == nil then
    warn("Current recordData is nil.")
    return 
  end
  recordData.selectedActBranchIdx = selectedActBranch
end

AvgController.GetAvgRecordData = function(self)
  -- function num : 0_27 , upvalues : _ENV
  local list = {}
  for k,v in ipairs(self.recordDataList) do
    list[k] = v
  end
  return list
end

AvgController.GetIsBranchSelected = function(self, actId, branchActId)
  -- function num : 0_28 , upvalues : _ENV
  for index,recordData in ipairs(self.recordDataList) do
    if recordData.actId == actId and recordData.selectedActBranchIdx == branchActId then
      return true
    end
  end
  return false
end

AvgController.GetAvgNextActCfg = function(self, actId)
  -- function num : 0_29 , upvalues : _ENV
  local nextActCfg = (self.avgCfg)[actId]
  if nextActCfg == nil then
    self:AvgLogError("Can\'t get nextActCfg, actId = " .. tostring(actId))
    return table.emptytable
  end
  return nextActCfg
end

AvgController.GetCurActId = function(self)
  -- function num : 0_30
  return self.curActId
end

AvgController.GetCurChapterName = function(self)
  -- function num : 0_31
  return self.chapterName
end

AvgController.JumpChapter = function(self, chapterName)
  -- function num : 0_32
  self:ClearCurAvg()
  self:ShowAvg(chapterName, self.completeFunc, self.__shieldControlSwitch, self.__ignoreTimeScale)
end

AvgController.AvgIgnoreTimeScale = function(self)
  -- function num : 0_33
  return self.__ignoreTimeScale
end

AvgController.SkipAvg = function(self)
  -- function num : 0_34
  local skip2EndActId = ((self.avgCfg)[1]).skip2EndActId
  if skip2EndActId ~= nil and (self.avgCfg)[skip2EndActId] ~= nil and ((self.avgCfg)[skip2EndActId]).isEnd == true and self.curActId ~= skip2EndActId then
    self:ClearDelayPlatNextTimer()
    ;
    (self.avgWindow):EndAllAvgTween()
    self:PlayAvgAct(skip2EndActId)
    return 
  end
  self:CompleteAllAvg()
end

AvgController.CompleteAllAvg = function(self, hasError)
  -- function num : 0_35 , upvalues : _ENV
  self._hasError = hasError
  if self._reqCompleteAllAvg then
    return 
  end
  self._reqCompleteAllAvg = true
  do
    if self.avgCachePlayParam ~= nil and (self.avgCachePlayParam).avgId ~= nil then
      local storyCfg = (ConfigData.story_avg)[(self.avgCachePlayParam).avgId]
    end
    if storyCfg == nil or not storyCfg.no_send or not (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed((self.avgCachePlayParam).avgId) then
      (ControllerManager:GetController(ControllerTypeId.AvgPlay)):RecordAvgPlayed((self.avgCachePlayParam).avgId)
      self._heroIdSnapShoot = PlayerDataCenter:GetHeroIdSnapShoot()
      self:CalAvgTransDic((self.avgCachePlayParam).avgId)
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Avg)):CS_AVG_Complete((self.avgCachePlayParam).avgId, self.__onAvgComplete)
      return 
    end
    self:OnAvgComplete(nil)
  end
end

AvgController.__CallAvgCompleteFunc = function(self)
  -- function num : 0_36
  local completeFunc = self.completeFunc
  self.completeFunc = nil
  if completeFunc ~= nil then
    completeFunc()
  end
end

AvgController.CalAvgTransDic = function(self, avgId)
  -- function num : 0_37 , upvalues : _ENV
  local storyCfg = (ConfigData.story_avg)[avgId]
  local rewardIds = {}
  local rewardNums = {}
  local rewardDic = {}
  for index,id in pairs(storyCfg.rewardIds) do
    rewardDic[id] = (rewardDic[id] or 0) + (storyCfg.rewardNums)[index]
  end
  for index,id in pairs(storyCfg.activityRewardIds) do
    rewardDic[id] = (rewardDic[id] or 0) + (storyCfg.activityRewardNums)[index]
  end
  for id,num in pairs(rewardDic) do
    (table.insert)(rewardIds, id)
    ;
    (table.insert)(rewardNums, num)
  end
  local crTransDic = PlayerDataCenter:CalCrItemTransDic(rewardIds, rewardNums)
  self.crTransDic = crTransDic
end

AvgController.OnAvgComplete = function(self, objList)
  -- function num : 0_38 , upvalues : _ENV, CommonRewardData
  local hasReward = false
  if objList ~= nil and objList.Count > 1 and self.avgCachePlayParam ~= nil then
    local ok = objList[0]
    local rewardDic = objList[1]
    if ok and (table.count)(rewardDic) > 0 then
      hasReward = true
      local rewardIds = {}
      do
        local rewardNums = {}
        for id,num in pairs(rewardDic) do
          (table.insert)(rewardIds, id)
          ;
          (table.insert)(rewardNums, num)
        end
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_38_0 , upvalues : self, CommonRewardData, rewardIds, rewardNums
    if window == nil then
      self:__CallAvgCompleteFunc()
      return 
    end
    local CRData = ((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)):SetCRItemTransDic(self.crTransDic)):SetCRShowOverFunc(function()
      -- function num : 0_38_0_0 , upvalues : self
      self:__CallAvgCompleteFunc()
    end
)
    window:AddAndTryShowReward(CRData)
  end
)
      end
    end
  end
  do
    self:ClearCurAvg()
    self.avgIsPlaying = false
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (Time.unity_time).timeScale = self.__originTimeScale
    AudioManager:RemoveBgmSourceFader()
    AudioManager:ResumeLastBgm()
    AudioManager:RemoveAllVoice(true)
    if self.avgCachePlayParam == nil then
      self:Delete()
    end
    if not hasReward then
      self:__CallAvgCompleteFunc()
    end
  end
end

AvgController.ClearCurAvg = function(self)
  -- function num : 0_39 , upvalues : _ENV
  local avgWindow = UIManager:GetWindow(UIWindowTypeID.Avg)
  if avgWindow ~= nil then
    avgWindow:CloseUIAVGSystem()
  end
  self:ClearDelayPlatNextTimer()
  self:UnloadAvgCfg()
end

AvgController.RecordAvgAudioSheet = function(self, sheetName)
  -- function num : 0_40 , upvalues : _ENV
  if sheetName == eAuCueSheet.UI then
    return 
  end
  if self._waitRemoveSheet == nil then
    self._waitRemoveSheet = {}
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._waitRemoveSheet)[sheetName] = true
end

AvgController.IsAvgPlaying = function(self)
  -- function num : 0_41
  return self.avgIsPlaying
end

AvgController.AvgLogError = function(self, msg)
  -- function num : 0_42 , upvalues : _ENV
  msg = msg .. (string.format)("\n Avg chapterName:%s, actId:%s", self.chapterName, self.curActId)
  error(msg)
  if not isGameDev then
    self:CompleteAllAvg(true)
  end
end

AvgController._RemoveCueSheet = function(self)
  -- function num : 0_43 , upvalues : _ENV
  if self._waitRemoveSheet == nil then
    return 
  end
  for sheetName,v in pairs(self._waitRemoveSheet) do
    AudioManager:RemoveCueSheet(sheetName)
  end
  self._waitRemoveSheet = nil
end

AvgController._VerifyCustomSkip = function(self)
  -- function num : 0_44 , upvalues : _ENV
  if (self.avgCfg)[1] == nil then
    error((string.format)("[Avg] act 1 is null, chapterName:%s", self.chapterName))
    return 
  end
  local skipTextId = ((self.avgCfg)[1]).SkipScenario
  local storyAvgId = ((self.avgCfg)[1]).storyAvgId
  if skipTextId == nil then
    return 
  end
  if self.avgCachePlayParam ~= nil and (self.avgCachePlayParam).avgId ~= nil then
    return 
  end
  local storyCfg = (ConfigData.story_avg)[storyAvgId]
  if storyCfg == nil then
    warn((string.format)("[Avg] Cant get storyCfg, storyAvgId:%s, chapterName:%s", storyAvgId, self.chapterName))
    return 
  end
  if storyCfg.script_id ~= self.chapterName then
    warn((string.format)("[Avg] storyAvgId error, storyAvgId:%s, chapterName:%s, storyCfg.script_id:", storyAvgId, self.chapterName, storyCfg.script_id))
    return 
  end
end

AvgController.TryGetAvgCustomSkip = function(self)
  -- function num : 0_45
  local skipTextId = ((self.avgCfg)[1]).SkipScenario
  local storyAvgId = nil
  if self.avgCachePlayParam ~= nil and (self.avgCachePlayParam).avgId ~= nil then
    storyAvgId = (self.avgCachePlayParam).avgId
  else
    storyAvgId = ((self.avgCfg)[1]).storyAvgId
  end
  return skipTextId, storyAvgId
end

AvgController.OnDelete = function(self)
  -- function num : 0_46 , upvalues : _ENV, base
  self:ClearCurAvg()
  if self.__playCoroutine ~= nil then
    (GR.StopCoroutine)(self.__playCoroutine)
    self.__playCoroutine = nil
  end
  self:_RemoveCueSheet()
  ;
  (base.OnDelete)(self)
end

return AvgController

