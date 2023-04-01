-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunTowerLevelItem = class("UINDunTowerLevelItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local CS_ClientConsts = CS.ClientConsts
UINDunTowerLevelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead, UINBaseItemWithReceived, DungeonLevelEnum
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_towerItem, self, self.OnTowerItemClicked)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
  self.rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self.__lastItemType = (DungeonLevelEnum.TowerLevelItemType).NormalItem
  self:SetAsSelectTowerLevel(false)
end

UINDunTowerLevelItem.BindTowerItemCommon = function(self, isTwinTower, resloader, clickEvent, objSelect, objNewLevel, downConstraint)
  -- function num : 0_1
  self.__isTwinTower = isTwinTower
  self.__resloader = resloader
  self.__clickEvent = clickEvent
  self.__objSelect = objSelect
  self.__objNewLevel = objNewLevel
  self.__downConstraint = downConstraint
end

UINDunTowerLevelItem.InitTowerLevelItem = function(self, towerLevelData, completeLevel)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  self.__towerLevelData = towerLevelData
  local towerFlag = towerLevelData:IsTowerFlagLevel()
  self.__towerFlag = towerFlag
  local itemType = (DungeonLevelEnum.TowerLevelItemType).NormalItem
  if self.__lastItemType ~= itemType then
    self:ClearItemPositionConstraint()
    self.__lastItemType = itemType
    ;
    (((self.ui).btn_towerItem).gameObject):SetActive(true)
    ;
    (((self.ui).isTopOrDownNode).gameObject):SetActive(false)
    ;
    ((self.ui).towerComingSoon):SetActive(false)
  end
  self:RefreshTowerItemInfo(completeLevel)
end

UINDunTowerLevelItem.InitTowerLevelItemKeep = function(self, itemType, topObj)
  -- function num : 0_3 , upvalues : DungeonLevelEnum, _ENV, CS_ClientConsts
  if self.__lastItemType ~= itemType then
    self:ClearItemPositionConstraint()
    self.__lastItemType = itemType
    ;
    (((self.ui).btn_towerItem).gameObject):SetActive(false)
    ;
    (((self.ui).isTopOrDownNode).gameObject):SetActive(true)
    if itemType == (DungeonLevelEnum.TowerLevelItemType).TopEmpty then
      topObj:SetParent((self.ui).isTopOrDownNode)
      topObj.anchoredPosition3D = Vector3.zero
      ;
      (topObj.gameObject):SetActive(true)
      ;
      ((self.ui).towerComingSoon):SetActive(false)
    else
      ;
      (topObj.gameObject):SetActive(false)
      local constraintSource = (self.__downConstraint):GetSource(0)
      constraintSource.sourceTransform = (self.ui).isTopOrDownNode
      ;
      (self.__downConstraint):SetSource(0, constraintSource)
      ;
      ((self.__downConstraint).gameObject):SetActive(true)
      ;
      ((self.ui).towerComingSoon):SetActive(true)
      local showComingSoon = (not self.__isTwinTower and not CS_ClientConsts.IsAudit)
      ;
      ((self.ui).tex_ComingSoon):SetActive(showComingSoon)
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINDunTowerLevelItem.SetAsSelectTowerLevel = function(self, selected)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).selectHolder):SetActive(selected)
  if selected then
    (self.__objSelect):SetParent(((self.ui).selectHolder).transform)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.__objSelect).anchoredPosition = Vector2.zero
    if self.__isCompelete then
      ((self.ui).obj_Completed):SetActive(false)
    end
  else
    if self.__isCompelete then
      ((self.ui).obj_Completed):SetActive(true)
    end
  end
end

UINDunTowerLevelItem.SetTowerNewLevelState = function(self, isnew)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).newLevelHolder):SetActive(isnew)
  local index = 0
  if isnew then
    index = 1
    ;
    (self.__objNewLevel):SetParent(((self.ui).newLevelHolder).transform)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__objNewLevel).anchoredPosition = Vector2.zero
  end
  if self.__towerFlag then
    index = index + 2
  end
  ;
  ((self.ui).img_Bottom):SetIndex(index)
end

UINDunTowerLevelItem.GetItemTowerLevelData = function(self)
  -- function num : 0_6
  return self.__towerLevelData
end

UINDunTowerLevelItem.ClearItemTowerLevel = function(self)
  -- function num : 0_7
  self:ClearItemPositionConstraint()
  self.__towerLevelData = nil
  self.__lastItemType = nil
end

UINDunTowerLevelItem.ClearItemPositionConstraint = function(self)
  -- function num : 0_8 , upvalues : DungeonLevelEnum
  if self.__lastItemType == (DungeonLevelEnum.TowerLevelItemType).DownEmpty then
    ((self.__downConstraint).gameObject):SetActive(false)
  end
end

UINDunTowerLevelItem.RefreshTowerItemInfo = function(self, completeLevel)
  -- function num : 0_9 , upvalues : _ENV
  local levelNum = (self.__towerLevelData):GetDunTowerLevelNum()
  local isCompelete = levelNum <= completeLevel
  local isNewLevel = levelNum == completeLevel + 1
  local isLock = completeLevel + 1 < levelNum
  self.__isCompelete = isCompelete
  self:__InitFirstRewardList(isCompelete)
  ;
  ((self.ui).obj_Completed):SetActive(isCompelete)
  if isCompelete then
    ((self.ui).obj_time):SetActive(self.__isTwinTower)
    if self.__isTwinTower then
      local frame = (PlayerDataCenter.dungeonTowerSData):GetTowerLevelRacingFrame((self.__towerLevelData):GetDungeonTowerType(), (self.__towerLevelData):GetDunTowerLevelNum())
      ;
      ((self.ui).tex_CompleteTime):SetIndex(0, (BattleUtil.FrameToTimeString)(frame, true))
    end
  end
  self:SetTowerNewLevelState(isNewLevel)
  ;
  ((self.ui).obj_Locked):SetActive(isLock)
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_FloorNum).text = (string.format)("%03d", levelNum)
  if isNewLevel then
    local userInfoData = PlayerDataCenter.inforData
    ;
    (self.userHeadNode):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), self.__resloader)
    ;
    (self.userHeadNode):Show()
  else
    (self.userHeadNode):Hide()
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINDunTowerLevelItem.__InitFirstRewardList = function(self, isPacked)
  -- function num : 0_10 , upvalues : _ENV
  (self.rewardPool):HideAll()
  local first_reward_ids, first_reward_nums = (self.__towerLevelData):GetDungeonFirstReward()
  for i,itemId in pairs(first_reward_ids) do
    local itemCfg = (ConfigData.item)[itemId]
    local count = first_reward_nums[i]
    local item = (self.rewardPool):GetOne(true)
    item:InitItemWithCount(itemCfg, count, nil, isPacked)
  end
end

UINDunTowerLevelItem.OnTowerItemClicked = function(self)
  -- function num : 0_11
  if self.__clickEvent ~= nil then
    (self.__clickEvent)(self, self.__towerLevelData)
  end
end

UINDunTowerLevelItem.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
end

return UINDunTowerLevelItem

