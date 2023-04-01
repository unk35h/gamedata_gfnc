-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonTowerSelect = class("UIDungeonTowerSelect", UIBaseWindow)
local base = UIBaseWindow
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
local UINDunTowerSelectItem = require("Game.DungeonCenter.TowerUI.UINDunTowerSelectItem")
local DungeonTypeTower = require("Game.DungeonCenter.Data.DungeonTypeTower")
UIDungeonTowerSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.OnBtnTowerRankClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.OnBtnTowerGotoClick)
  ;
  ((self.ui).towerItem):SetActive(false)
  self.__onDunTowerTypeSelect = BindCallback(self, self.OnDunTowerTypeSelect)
end

UIDungeonTowerSelect.InitDungeonTowerSelect = function(self, dunTowerCtrl, towerCat)
  -- function num : 0_1 , upvalues : DungeonLevelEnum, _ENV
  self.__dunTowerCtrl = dunTowerCtrl
  self.__towerItems = {}
  local normalItem = (self:__GenTowerSelectItem((DungeonLevelEnum.DunTowerCategory).Normal))
  local twinItem = nil
  local twinTowerList = (ConfigData.dungeon_tower_type).twin_towers
  if #twinTowerList > 0 then
    twinItem = self:__GenTowerSelectItem((DungeonLevelEnum.DunTowerCategory).TwinTower)
  end
  ;
  ((((CS.UnityEngine).UI).LayoutRebuilder).ForceRebuildLayoutImmediate)(((self.ui).rect_main).transform)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).rect_main).enabled = false
  if self._twinTowerListener == nil then
    self._twinTowerListener = function(node)
    -- function num : 0_1_0 , upvalues : self, DungeonLevelEnum
    local active = node:GetRedDotCount() > 0
    local twinItem = (self.__towerItems)[(DungeonLevelEnum.DunTowerCategory).TwinTower]
    if twinItem == nil then
      return 
    end
    twinItem:SetTowerReddot(active)
    if self.__selectItem == twinItem then
      ((self.ui).redDot_Enter):SetActive(active)
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end

    local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
    RedDotController:AddListener(twinTowerNode.nodePath, self._twinTowerListener)
    ;
    (self._twinTowerListener)(twinTowerNode)
  end
  do
    self:RefreshTowerSelectBlueDot()
    if not towerCat then
      local catId = (DungeonLevelEnum.DunTowerCategory).Normal
    end
    self:OnDunTowerTypeSelect(catId, (self.__towerItems)[catId], true)
    normalItem:__PlayInitTween(self.__selectItem)
    if twinItem ~= nil then
      twinItem:__PlayInitTween(self.__selectItem)
    end
  end
end

UIDungeonTowerSelect.RefreshTowerSelectBlueDot = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum, _ENV
  local twinItem = (self.__towerItems)[(DungeonLevelEnum.DunTowerCategory).TwinTower]
  if twinItem ~= nil then
    twinItem:SetTowerBluedot((PlayerDataCenter.dungeonTowerSData):HasNewDunTwinTower())
  end
  local normalItem = (self.__towerItems)[(DungeonLevelEnum.DunTowerCategory).Normal]
  if normalItem ~= nil then
    normalItem:SetTowerBluedot((PlayerDataCenter.dungeonTowerSData):IsNewNormalDunTower())
  end
end

UIDungeonTowerSelect.__GenTowerSelectItem = function(self, catId)
  -- function num : 0_3 , upvalues : UINDunTowerSelectItem
  local go = ((self.ui).towerItem):Instantiate()
  go:SetActive(true)
  local towerItem = (UINDunTowerSelectItem.New)()
  towerItem:Init(go)
  local name = ((self.ui).tex_TowerName):GetIndex(catId)
  towerItem:InitTowerSelectItem(catId, self.__onDunTowerTypeSelect, name)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.__towerItems)[catId] = towerItem
  return towerItem
end

UIDungeonTowerSelect.OnDunTowerTypeSelect = function(self, catId, towerItem, isinit)
  -- function num : 0_4 , upvalues : DungeonLevelEnum, _ENV
  if towerItem == nil then
    return 
  end
  if self.__selectItem == towerItem then
    return 
  end
  if self.__selectItem ~= nil then
    (self.__selectItem):SetTowerSelected(false, isinit)
  end
  self.__selectCatId = catId
  self.__selectItem = towerItem
  towerItem:SetTowerSelected(true, isinit)
  local isNoraml = catId == (DungeonLevelEnum.DunTowerCategory).Normal
  ;
  (((self.ui).btn_Rank).gameObject):SetActive(isNoraml)
  ;
  (((self.ui).tex_Progress).gameObject):SetActive(isNoraml)
  if isNoraml then
    local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerCompleteLevel()
    local totalLevel = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerTotalLevel()
    ;
    ((self.ui).tex_Progress):SetIndex(0, tostring(completeLevel), tostring(totalLevel))
    ;
    ((self.ui).redDot_Enter):SetActive(false)
  else
    local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
    ;
    ((self.ui).redDot_Enter):SetActive(twinTowerNode:GetRedDotCount() > 0)
  end
  if isinit then
    self:__SetUiIndex(catId)
  else
    self:PlaySwitchTweenAnim(catId)
  end
  ;
  ((self.ui).img_Background1):DOComplete()
  ;
  ((self.ui).img_Background1):DOFade(isNoraml and 1 or 0, 0.2)
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UIDungeonTowerSelect.GotoDunTowerByCat = function(self, catId)
  -- function num : 0_5 , upvalues : DungeonLevelEnum, _ENV, DungeonTypeTower
  if catId == (DungeonLevelEnum.DunTowerCategory).Normal then
    local towerId = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerId()
    do
      local towerTypeData = (DungeonTypeTower.New)(towerId)
      do
        local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
        UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerLevel, function(window)
    -- function num : 0_5_0 , upvalues : self, towerTypeData, completeLevel
    if window == nil then
      return 
    end
    window:InitDungeonTowerLevel(self.__dunTowerCtrl, towerTypeData, completeLevel)
  end
)
        local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
        local towerCfg = (ConfigData.dungeon_tower_type)[towerId]
        if userDataCache:SetNormalTowerLevel(towerCfg.total_level) then
          ((self.__towerItems)[(DungeonLevelEnum.DunTowerCategory).Normal]):SetTowerBluedot(false)
          ;
          (PlayerDataCenter.dungeonTowerSData):ClearNewDunTower(towerId)
          local sectorController = ControllerManager:GetController(ControllerTypeId.SectorController, false)
          if sectorController ~= nil then
            (sectorController.uiCanvas):UpdateDungeonTowerEntry()
          end
        end
      end
      do
        if catId == (DungeonLevelEnum.DunTowerCategory).TwinTower then
          local twinTowerList = (ConfigData.dungeon_tower_type).twin_towers
          if #twinTowerList == 1 then
            local towerId = twinTowerList[1]
            local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerId)
            UIManager:DeleteWindow(UIWindowTypeID.DungeonTowerLevel)
            UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerLevel, function(window)
    -- function num : 0_5_1 , upvalues : DungeonTypeTower, towerId, self, completeLevel
    if window == nil then
      return 
    end
    local towerTypeData = (DungeonTypeTower.New)(towerId)
    window:InitDungeonTowerLevel(self.__dunTowerCtrl, towerTypeData, completeLevel)
  end
)
          else
            do
              ;
              (self.__dunTowerCtrl):RequestRacingRankSelfInfo(function(myRankDetail)
    -- function num : 0_5_2 , upvalues : _ENV, self
    UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTwinTowerSelect, function(window)
      -- function num : 0_5_2_0 , upvalues : self, myRankDetail
      if window == nil then
        return 
      end
      window:InitDunTwinTowerSelect(self.__dunTowerCtrl, 0, myRankDetail)
    end
, UIWindowTypeID.DungeonTwinTowerSelectNoAni)
  end
)
            end
          end
        end
      end
    end
  end
end

UIDungeonTowerSelect.OnBtnTowerRankClick = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local towerId = (PlayerDataCenter.dungeonTowerSData):GetDefaultTowerId()
  local rankId = ((ConfigData.dungeon_tower_type)[towerId]).rank_id
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_6_0 , upvalues : rankId
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank(rankId)
  end
)
end

UIDungeonTowerSelect.OnBtnTowerGotoClick = function(self)
  -- function num : 0_7
  self:GotoDunTowerByCat(self.__selectCatId)
end

UIDungeonTowerSelect._OnClickBack = function(self, toHome)
  -- function num : 0_8
  (self.__dunTowerCtrl):ExitDungeonTower(toHome)
end

UIDungeonTowerSelect.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  do
    if self._twinTowerListener ~= nil then
      local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
      RedDotController:RemoveListener(twinTowerNode.nodePath, self._twinTowerListener)
    end
    for _,item in pairs(self.__towerItems) do
      item:Delete()
    end
    self.__towerItems = nil
    ;
    ((self.ui).img_Background1):DOKill()
    ;
    (base.OnDelete)(self)
  end
end

UIDungeonTowerSelect.PlaySwitchTweenAnim = function(self, catId)
  -- function num : 0_10 , upvalues : _ENV
  local __TowerNamePos = (((self.ui).tex_TowerName).transform).localPosition
  local Tweenitem = (self.ui).TweenAnimation
  Tweenitem:DORestartAllById("Start")
  Tweenitem:DORestartAllById("Fade")
  ;
  (Tweenitem.onComplete):AddListener(BindCallback(self, function()
    -- function num : 0_10_0 , upvalues : self, __TowerNamePos, catId, Tweenitem
    self:SetBack(__TowerNamePos)
    self:__SetUiIndex(catId)
    Tweenitem:DORestartAllById("FadeOut")
    Tweenitem:DORestartAllById("End")
  end
))
end

UIDungeonTowerSelect.__SetUiIndex = function(self, catId)
  -- function num : 0_11
  ((self.ui).tex_Pattern):SetIndex(catId)
  ;
  ((self.ui).tex_TowerName):SetIndex(catId)
  ;
  ((self.ui).tex_TowerMode):SetIndex(catId)
end

UIDungeonTowerSelect.SetBack = function(self, __TowerNamePos)
  -- function num : 0_12 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  (((self.ui).tex_TowerName).transform).localPosition = (Vector3.New)(__TowerNamePos.x - 37, __TowerNamePos.y, 0)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).tex_TowerMode).transform).localPosition = (Vector3.New)(0, 50, 0)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).tex_Pattern).transform).localPosition = (Vector3.New)(25.38, -25, 0)
end

return UIDungeonTowerSelect

