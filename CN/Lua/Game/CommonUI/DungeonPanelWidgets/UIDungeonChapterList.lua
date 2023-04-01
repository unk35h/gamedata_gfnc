-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonChapterList = class("UIDungeonChapterList", UIBaseNode)
local base = UIBaseNode
local eDungeonStageState = (require("Game.Dungeon.DungeonStageData")).eDungeonStageState
local eDungeonEnum = require("Game.Dungeon.eDungeonEnum")
local UINStOUnlockConditionItem = require("Game.StrategyOverview.UI.Side.UINStOUnlockConditionItem")
local cs_MessageCommon = CS.MessageCommon
local JumpManager = require("Game.Jump.JumpManager")
UIDungeonChapterList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINStOUnlockConditionItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.__onBattleStart)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AutoBattle, self, self.__onAutoBattleSet)
  self.__RefreshAutoBattleBtnState = BindCallback(self, self.RefreshAutoBattleBtnState)
  MsgCenter:AddListener(eMsgEventId.StaminaUpdate, self.__RefreshAutoBattleBtnState)
  MsgCenter:AddListener(eMsgEventId.OnBattleDungeonLimitChange, self.__RefreshAutoBattleBtnState)
  ;
  ((self.ui).obj_conditItem):SetActive(false)
  self.conditionItemPool = (UIItemPool.New)(UINStOUnlockConditionItem, (self.ui).obj_conditItem)
  self.isShowDetailRect = false
end

UIDungeonChapterList.CreatePool = function(self, chapterItemClass, fstRewardItemClass, mbDropItemClass)
  -- function num : 0_1 , upvalues : _ENV
  local itemPool, fstRewardPool, mbDropPool = nil, nil, nil
  if chapterItemClass ~= nil then
    itemPool = (UIItemPool.New)(chapterItemClass, (self.ui).chapterItem)
  end
  if fstRewardItemClass ~= nil then
    fstRewardPool = (UIItemPool.New)(fstRewardItemClass, (self.ui).firstReward)
  end
  if mbDropItemClass ~= nil then
    mbDropPool = (UIItemPool.New)(mbDropItemClass, (self.ui).maybeReward)
  end
  return itemPool, fstRewardPool, mbDropPool
end

UIDungeonChapterList.UpdateWithChapterList = function(self, chapterItemList, dungeonData, onStartBattleEvent)
  -- function num : 0_2 , upvalues : _ENV, eDungeonStageState
  self.chapterItemList = chapterItemList
  self.onStartBattleEvent = onStartBattleEvent
  self.dungeonData = dungeonData
  local lastSelectStageId = (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):GetLastDungeonStageId(dungeonData:GetDungeonId())
  local completeCount = dungeonData:GetDungeonStageCompletedCount()
  local totalCount = dungeonData:GetDungeonStageCount()
  self.chapterCount = totalCount
  local itemClickEvent = BindCallback(self, self.OnShowDetailRectAndSetSelectChapter)
  local updateLimitDisplayEvent = BindCallback(self, self.UpdateChapterLimitDisplay)
  if #chapterItemList > 0 then
    local availableItem = nil
    local lastUnlockedItems = {}
    for k,v in ipairs(chapterItemList) do
      if v ~= nil then
        v.onClickAction = itemClickEvent
        v.updateLimitDisplayEvent = updateLimitDisplayEvent
        if v.state ~= eDungeonStageState.lock then
          (table.insert)(lastUnlockedItems, v)
          if availableItem == nil and lastSelectStageId == v.chapterId then
            availableItem = v
          end
        end
      end
    end
    if availableItem == nil and (self.dungeonData).isFrageDungeon and #lastUnlockedItems > 0 then
      for _,_item in ipairs(lastUnlockedItems) do
        if _item ~= nil and _item.state ~= eDungeonStageState.noData and not (_item.dungeonStageData):GetIsReach2Limit() then
          availableItem = _item
        end
      end
      if availableItem == nil then
        availableItem = lastUnlockedItems[#lastUnlockedItems]
      end
    else
      if availableItem == nil then
        if #lastUnlockedItems > 0 then
          availableItem = lastUnlockedItems[#lastUnlockedItems]
        else
          availableItem = chapterItemList[1]
        end
      end
    end
    if availableItem ~= nil then
      availableItem:__onClick()
    end
  end
  do
    self:UpdateChapterProgress(completeCount, totalCount)
  end
end

UIDungeonChapterList.RefreshAutoBattleBtnState = function(self)
  -- function num : 0_3 , upvalues : eDungeonStageState, _ENV
  if self.dungeonData == nil or (self.dungeonData).dungeonTypeData == nil or self.selectChapterItem == nil then
    (((self.ui).btn_AutoBattle).gameObject):SetActive(false)
    return 
  end
  local hasAutoBattle = false
  if (self.selectChapterItem).state == eDungeonStageState.lock then
    hasAutoBattle = not (self.dungeonData):IsFrageDungeon()
    local dungeonType = ((self.dungeonData).dungeonTypeData):GetDungeonType()
    do
      local materialCfg = (ConfigData.material_dungeon)[(self.dungeonData).dungeonId]
      hasAutoBattle = materialCfg ~= nil and not materialCfg.auto or (self.selectChapterItem).state ~= eDungeonStageState.lock
      ;
      (((self.ui).btn_AutoBattle).gameObject):SetActive(hasAutoBattle)
      if hasAutoBattle then
        local locked = not PlayerDataCenter:IsDungeonCompletedWithoutSupport((self.selectChapterItem).chapterId)
        ;
        ((self.ui).img_Locked):SetActive(locked)
        if ((self.selectChapterItem).dungeonStageData):GetIsReach2Limit() then
          ((self.ui).img_Mask):SetActive(true)
        else
          local sKeyEmpty = PlayerDataCenter:GetItemCount(ConstGlobalItem.SKey) < (self.selectChapterItem).costStrengthNum
          local flag, limitTimes = (self.dungeonData):GetDungeonAutoBattleMaxLimit()
          ;
          ((self.ui).img_Mask):SetActive(locked or sKeyEmpty or not flag or limitTimes == 0)
        end
      end
      -- DECOMPILER ERROR: 10 unprocessed JMP targets
    end
  end
end

UIDungeonChapterList.UpdateChapterLimitDisplay = function(self, matDungeonItem)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).tex_LimitCount):SetIndex(0, tostring(matDungeonItem.usedLimit), tostring(matDungeonItem.dailyLimit))
end

UIDungeonChapterList.UpdateChapterProgress = function(self, completeCount, totalCount)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).img_Bar).fillAmount = (completeCount - 1) / (totalCount - 1)
end

UIDungeonChapterList.OnShowDetailRectAndSetSelectChapter = function(self, show, chapterItem)
  -- function num : 0_6 , upvalues : _ENV, eDungeonStageState, cs_MessageCommon
  self._autoBattleCount = 0
  ;
  (self.conditionItemPool):HideAll()
  if chapterItem ~= nil then
    self.selectChapterItem = chapterItem
    ;
    ((self.ui).tex_Point):SetIndex(0, tostring(chapterItem.costStrengthNum))
    if chapterItem.state == eDungeonStageState.lock then
      (((self.ui).btn_Battle).gameObject):SetActive(false)
      ;
      ((self.ui).obj_conditNode):SetActive(true)
      if not IsNull((self.ui).obj_ATHDecompose) then
        ((self.ui).obj_ATHDecompose):SetActive(false)
      end
      self:__GetLockItem(chapterItem.lockDatas)
      ;
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(chapterItem.lockReason)
    else
      ;
      (((self.ui).btn_Battle).gameObject):SetActive(true)
      ;
      ((self.ui).obj_conditNode):SetActive(false)
      if not IsNull((self.ui).obj_ATHDecompose) then
        ((self.ui).obj_ATHDecompose):SetActive(true)
      end
    end
    ;
    (((self.ui).img_chapterSelect).transform):SetParent(chapterItem.transform, false)
    ;
    ((self.ui).img_chapterSelect):SetActive(true)
    self:RefreshAutoBattleBtnState()
  end
  if chapterItem == nil then
    do return self.isShowDetailRect ~= show end
    if show then
      self.isShowDetailRect = true
      ;
      ((self.ui).levelDetailTween):DOPlayForward()
    end
    do return show end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIDungeonChapterList.__GetLockItem = function(self, lockDatas)
  -- function num : 0_7 , upvalues : _ENV
  for k,condition in ipairs(lockDatas) do
    if k >= 3 then
      error("UIDungeonChapterList 不支持3条 需要改UI")
      break
    end
    local conditionItem = (self.conditionItemPool):GetOne()
    conditionItem:InitStOUnlockConditionItem(condition.unlock, condition.lockReason)
  end
end

UIDungeonChapterList.__onBattleStart = function(self)
  -- function num : 0_8
  if self.onStartBattleEvent ~= nil then
    (self.onStartBattleEvent)()
  end
end

UIDungeonChapterList.__onAutoBattleSet = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_MessageCommon, JumpManager
  if not PlayerDataCenter:IsDungeonCompletedWithoutSupport((self.selectChapterItem).chapterId) then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8101))
    return 
  end
  if ((self.selectChapterItem).dungeonStageData):GetIsReach2Limit() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.BattleDungeon_DailyLimit))
    return 
  end
  if (self.dungeonData):GetDungeonPlayLeftLimitNum() == 0 then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.BattleDungeon_DailyLimit))
    return 
  end
  if PlayerDataCenter:GetItemCount(ConstGlobalItem.SKey) < (self.selectChapterItem).costStrengthNum then
    JumpManager:Jump((JumpManager.eJumpTarget).BuyStamina)
    return 
  end
  UIManager:CreateWindowAsync(UIWindowTypeID.BattleAutoMode, function(window)
    -- function num : 0_9_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitDungeonAutoSet((self.selectChapterItem).dungeonStageData, function(autoCount)
      -- function num : 0_9_0_0 , upvalues : self
      if self.onStartBattleEvent ~= nil then
        (self.onStartBattleEvent)(autoCount)
      end
    end
)
  end
)
end

UIDungeonChapterList.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.StaminaUpdate, self.__RefreshAutoBattleBtnState)
  MsgCenter:RemoveListener(eMsgEventId.OnBattleDungeonLimitChange, self.__RefreshAutoBattleBtnState)
  ;
  (self.conditionItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIDungeonChapterList

