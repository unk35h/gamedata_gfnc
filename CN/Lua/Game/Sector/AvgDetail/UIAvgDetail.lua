-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAvgDetail = class("UIAvgDetail", UIBaseWindow)
local base = UIBaseWindow
local UINLevelDetailRewardItem = require("Game.Sector.SectorLevelDetail.Nodes.UINLevelDetailRewardItem")
local UINStOUnlockConditionItem = require("Game.StrategyOverview.UI.Side.UINStOUnlockConditionItem")
UIAvgDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINStOUnlockConditionItem, UINLevelDetailRewardItem
  (UIUtil.SetTopStatus)(self, self.OnCloseAvgDetail)
  self._resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClockCloseBg)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ViewAvg, self, self.OnClickPlay)
  self._conditionItemPool = (UIItemPool.New)(UINStOUnlockConditionItem, (self.ui).conditionItem)
  ;
  ((self.ui).conditionItem):SetActive(false)
  self._rewardItemPool = (UIItemPool.New)(UINLevelDetailRewardItem, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  ;
  (((self.ui).detailNode).onComplete):AddListener(BindCallback(self, self.__OnMoveTweenComplete))
  ;
  (((self.ui).detailNode).onRewind):AddListener(BindCallback(self, self.__OnMoveTweenRewind))
end

UIAvgDetail.InitAvgDetail = function(self, data_UIAvgDetail)
  -- function num : 0_1
  self._data = data_UIAvgDetail
  self._closeCallback = (self._data):GetAvgDetailCloseCallback()
  self._avgId = (self._data):GetAvgDetailAvgId()
  self._avgCfg = (self._data):GetAvgDetailAvgCfg()
  self:__InitBaseInfo()
  self:__InitReward()
  self:__InitViewState()
  ;
  (((self.ui).btn_Close).gameObject):SetActive((self._data):GetAvgDetailCloseBgOpen())
  self:__PlayEnterTween()
end

UIAvgDetail.__InitBaseInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local path = (self._data):GetAvgDetailAvgBannerTexPath()
  do
    if path ~= nil then
      local tex = (self._resloader):LoadABAsset(PathConsts:GetSectorBackgroundPath(path))
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

      if tex ~= nil then
        ((self.ui).img_LevelPic).texture = tex
      end
    end
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_IdName).text = (self._data):GetAvgDetailExTitle() or ""
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_LevelName).text = (LanguageUtil.GetLocaleText)((self._avgCfg).name)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_LevelInfo).text = (LanguageUtil.GetLocaleText)((self._avgCfg).describe)
    self:__PlayEnterTween()
  end
end

UIAvgDetail.__InitReward = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not (self._data):GetAvgDetailRewardShowState() then
    ((self.ui).rewardRank):SetActive(false)
    return 
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local played = (self._data):GetAvgDetailPlayed()
  local rewardDic = {}
  local actCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actFrameData = actCtrl:GetActivityFrameData((self._avgCfg).activity_id)
  if actFrameData ~= nil and actFrameData:IsActivityOpen() and not actFrameData:IsActivityRunningTimeout() then
    for i,itemId in ipairs((self._avgCfg).activityRewardIds) do
      local count = rewardDic[itemId] or 0
      rewardDic[itemId] = count + ((self._avgCfg).activityRewardNums)[i]
    end
  end
  do
    local extraReward = (self._data):GetAvgDetailExtraReward()
    if extraReward ~= nil then
      for itemId,itemCount in pairs(extraReward) do
        local count = rewardDic[itemId] or 0
        rewardDic[itemId] = count + itemCount
      end
    end
    do
      for k,itemId in ipairs((self._avgCfg).rewardIds) do
        local count = rewardDic[itemId] or 0
        rewardDic[itemId] = count + ((self._avgCfg).rewardNums)[k]
      end
      local isShow = (table.count)(rewardDic) > 0
      if not isShow then
        ((self.ui).rewardRank):SetActive(false)
        return 
      end
      ;
      ((self.ui).rewardRank):SetActive(true)
      local itemClickCallback = BindCallback(self, self.__ShowRewardDetail)
      local rewardCount = 0
      local rewardCountMax = (self.ui).AvgDropItemLimt or 5
      local rewardIdList = self:__GetRewardShowSort(rewardDic)
      ;
      (self._rewardItemPool):HideAll()
      for _,itemId in ipairs(rewardIdList) do
        local itemNum = rewardDic[itemId]
        if rewardCountMax > rewardCount then
          rewardCount = rewardCount + 1
          local rewardItem = (self._rewardItemPool):GetOne()
          do
            local itemCfg = (ConfigData.item)[itemId]
            rewardItem:InitItemWithCount(itemCfg, itemNum, itemClickCallback, played)
            -- DECOMPILER ERROR at PC146: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC146: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      -- DECOMPILER ERROR: 5 unprocessed JMP targets
    end
  end
end

UIAvgDetail.__GetRewardShowSort = function(self, rewardDic)
  -- function num : 0_4 , upvalues : _ENV
  local rewardIds = {}
  for k,v in pairs(rewardDic) do
    (table.insert)(rewardIds, k)
  end
  ;
  (table.sort)(rewardIds, function(a, b)
    -- function num : 0_4_0 , upvalues : _ENV
    local aItem = (ConfigData.item)[a]
    local bItem = (ConfigData.item)[b]
    if bItem.quality >= aItem.quality then
      do return aItem.quality == bItem.quality end
      do return a < b end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  return rewardIds
end

UIAvgDetail.__InitViewState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local isUnlock = avgPlayCtrl:IsAvgUnlock(self._avgId)
  local extraLockList = (self._data):GetAvgDetailExtraCondition()
  if isUnlock and extraLockList ~= nil then
    for i,v in ipairs(extraLockList) do
      if not v.unlock then
        isUnlock = false
        break
      end
    end
  end
  do
    ;
    (((self.ui).btn_ViewAvg).gameObject):SetActive(isUnlock)
    ;
    ((self.ui).unlockCondition):SetActive(not isUnlock)
    if isUnlock then
      return 
    end
    local conditionList = (CheckCondition.GetUnlockAndInfoList)((self._avgCfg).pre_condition, (self._avgCfg).pre_para1, (self._avgCfg).pre_para2)
    ;
    (self._conditionItemPool):HideAll()
    for i,v in ipairs(conditionList) do
      local item = (self._conditionItemPool):GetOne()
      item:InitStOUnlockConditionItem(v.unlock, v.lockReason)
    end
    if extraLockList ~= nil then
      for i,v in ipairs(extraLockList) do
        local item = (self._conditionItemPool):GetOne()
        item:InitStOUnlockConditionItem(v.unlock, v.lockReason)
      end
    end
  end
end

UIAvgDetail.OnClickPlay = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
  local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
  avgCtrl:StartAvg((self._avgCfg).script_id, (self._avgCfg).id, function()
    -- function num : 0_6_0 , upvalues : _ENV
    (AvgUtil.ShowMainCamera)(true)
  end
)
  ;
  (AvgUtil.ShowMainCamera)(false)
end

UIAvgDetail.OnClockCloseBg = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIAvgDetail.__ShowRewardDetail = function(self, itemCfg)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_8_0 , upvalues : itemCfg
    if win ~= nil then
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
end

UIAvgDetail.GetAvgDetailDetailMoveWidthAndTime = function(self)
  -- function num : 0_9
  if self._tempMoveWidth == nil then
    self._tempMoveWidth = ((((self.ui).detailNode).transform).sizeDelta).x
    self._tempMoveTime = ((self.ui).detailNode).duration
  end
  return self._tempMoveWidth, self._tempMoveTime
end

UIAvgDetail.__PlayEnterTween = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._uiIsShow then
    return 
  end
  self._uiIsShow = true
  ;
  (UIUtil.AddOneCover)("UIAvgDetail")
  ;
  ((self.ui).detailNode):DOPlayForward()
  AudioManager:PlayAudioById(1033)
  local func = (self._data):GetAvgDetailOpenTweenBeginCallback()
  if func ~= nil then
    func()
  end
end

UIAvgDetail.__PlayCloseTween = function(self)
  -- function num : 0_11 , upvalues : _ENV
  (UIUtil.AddOneCover)("UIAvgDetail")
  ;
  ((self.ui).detailNode):DOPlayBackwards()
  AudioManager:PlayAudioById(1034)
  local func = (self._data):GetAvgDetailCloseTweenBeginCallback()
  if func ~= nil then
    func()
  end
end

UIAvgDetail.__OnMoveTweenComplete = function(self)
  -- function num : 0_12 , upvalues : _ENV
  (UIUtil.CloseOneCover)("UIAvgDetail")
end

UIAvgDetail.__OnMoveTweenRewind = function(self)
  -- function num : 0_13 , upvalues : _ENV
  (UIUtil.CloseOneCover)("UIAvgDetail")
  self:Delete()
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
end

UIAvgDetail.OnCloseAvgDetail = function(self, isHome)
  -- function num : 0_14
  if isHome then
    self:Delete()
    if self._closeCallback ~= nil then
      (self._closeCallback)()
    end
  else
    self:__PlayCloseTween()
  end
end

return UIAvgDetail

