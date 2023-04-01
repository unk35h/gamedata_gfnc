-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonTwinTowerSelect = class("UIDungeonTwinTowerSelect", UIBaseWindow)
local base = UIBaseWindow
local UINDunTwinTowerSelectItem = require("Game.DungeonCenter.TowerUI.UINDunTwinTowerSelectItem")
local DungeonTypeTower = require("Game.DungeonCenter.Data.DungeonTypeTower")
local CS_ClientConsts = CS.ClientConsts
UIDungeonTwinTowerSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDunTwinTowerSelectItem
  (UIUtil.SetTopStatus)(self, self._OnClickTowerReturn, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self._OnBtnCancelClick)
  self.__twinTowerPool = (UIItemPool.New)(UINDunTwinTowerSelectItem, (self.ui).towerItem, false)
  self.__onSelectTwinTower = BindCallback(self, self.OnSelectTwinTower)
end

UIDungeonTwinTowerSelect.InitDunTwinTowerSelect = function(self, dunTowerCtrl, selectTowerId, myRankDetail)
  -- function num : 0_1 , upvalues : _ENV
  self.__dunTowerCtrl = dunTowerCtrl
  self.__selectTowerId = selectTowerId or 0
  self:__InitTwinTowerList(myRankDetail)
  self.__onSelectTwinTower = BindCallback(self, self.OnSelectTwinTower)
end

UIDungeonTwinTowerSelect.__InitTwinTowerList = function(self, myRankDetail)
  -- function num : 0_2 , upvalues : _ENV, DungeonTypeTower, CS_ClientConsts
  (self.__twinTowerPool):HideAll()
  self.__twinItemDic = {}
  local time = 0
  local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
  self.__twinTowerNode = twinTowerNode
  local defaultIndex = (math.max)(1, (PlayerDataCenter.dungeonTowerSData):GetTwinTowerFirstNoComplete())
  local towerCount = #(ConfigData.dungeon_tower_type).twin_towers
  for index,towerId in pairs((ConfigData.dungeon_tower_type).twin_towers) do
    local towerTypeData = (DungeonTypeTower.New)(towerId, true)
    local twinTowerItem = ((self.__twinTowerPool):GetOne())
    local myRank = nil
    if myRankDetail ~= nil then
      myRank = myRankDetail[towerId]
    end
    twinTowerItem:InitTwinTowerSelectItem(towerTypeData, self.__selectTowerId, myRank, self.__onSelectTwinTower)
    time = time + 1
    twinTowerItem:__PlayThemeTween(time)
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R15 in 'UnsetPending'

    ;
    (self.__twinItemDic)[towerId] = twinTowerItem
    if self.__selectTowerId == towerId then
      defaultIndex = index
    end
    self:__RefreshTwinSelectReddot(towerId)
    local blueDot = (PlayerDataCenter.dungeonTowerSData):IsNewDunTower(towerId)
    twinTowerItem:SetTwinTowerItemBluedot(blueDot)
  end
  ;
  (((self.ui).obj_Lock).transform):SetAsLastSibling()
  ;
  ((((self.ui).cg_Lock):DOFade(0, 0.3)):From()):SetDelay((time + 1) * 0.15)
  if CS_ClientConsts.IsAudit then
    (((self.ui).obj_Lock).gameObject):SetActive(false)
  end
  if self._racingRewardListener == nil then
    self._racingRewardListener = function(node)
    -- function num : 0_2_0 , upvalues : self
    local towerId = node.nodeId
    self:__RefreshTwinSelectReddot(towerId)
  end

    RedDotController:AddListener(RedDotDynPath.DunTwinTowerReward, self._racingRewardListener)
  end
  -- DECOMPILER ERROR at PC116: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).verticalNormalizedPosition = 1 - (defaultIndex - 1) / towerCount
end

UIDungeonTwinTowerSelect.__RefreshTwinSelectReddot = function(self, towerId)
  -- function num : 0_3
  local twinTowerItem = (self.__twinItemDic)[towerId]
  if twinTowerItem == nil then
    return 
  end
  local towerNode = (self.__twinTowerNode):GetChild(towerId)
  local hasRedot = false
  if towerNode:GetRedDotCount() <= 0 then
    hasRedot = towerNode == nil
    twinTowerItem:SetTwinTowerItemReddot(hasRedot)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIDungeonTwinTowerSelect.OnSelectTwinTower = function(self, towerTypeData)
  -- function num : 0_4 , upvalues : _ENV
  local towerId = towerTypeData:GetDungeonTowerTypeId()
  ;
  (UIUtil.OnClickBack)()
  if towerId == self.__selectTowerId then
    return 
  end
  local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if userDataCache:SetTwinTowerNewReaded(towerId, true) then
    (PlayerDataCenter.dungeonTowerSData):ClearNewDunTower(towerId)
    local selectWindow = UIManager:GetWindow(UIWindowTypeID.DungeonTowerSelect)
    if selectWindow ~= nil then
      selectWindow:RefreshTowerSelectBlueDot()
    end
    local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
    if sectorController ~= nil then
      (sectorController.uiCanvas):UpdateDungeonTowerEntry()
    end
  end
  do
    towerTypeData:GenTowerLevelListData()
    local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
    UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerLevel, function(window)
    -- function num : 0_4_0 , upvalues : self, towerTypeData, completeLevel
    if window == nil then
      return 
    end
    window:CloseLevelDetailWindow()
    window:InitDungeonTowerLevel(self.__dunTowerCtrl, towerTypeData, completeLevel)
  end
)
  end
end

UIDungeonTwinTowerSelect._OnBtnCancelClick = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIDungeonTwinTowerSelect._OnClickTowerReturn = function(self)
  -- function num : 0_6
  self:Delete()
end

UIDungeonTwinTowerSelect.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  if self._racingRewardListener ~= nil then
    RedDotController:RemoveListener(RedDotDynPath.DunTwinTowerReward, self._racingRewardListener)
  end
  ;
  ((self.ui).cg_Lock):DOKill()
  ;
  (self.__twinTowerPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UIDungeonTwinTowerSelect

