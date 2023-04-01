-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonTowerLevel = class("UIDungeonTowerLevel", UIBaseWindow)
local base = UIBaseWindow
local UINDunTowerLevelItem = require("Game.DungeonCenter.TowerUI.UINDunTowerLevelItem")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
UIDungeonTowerLevel.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickBack)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.CloseLevelDetailWindow)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ToBack, self, self.OnBtnGotoCurTowerLevel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ToNext, self, self.OnBtnGotoCurTowerLevel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_dataFile, self, self.OnDataFileClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.OnRankClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchTower, self, self.OnBtnSwitchTowerClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Racing, self, self.OnBtnRacingClick)
  -- DECOMPILER ERROR at PC60: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tower_loopScroll).onInstantiateItem = BindCallback(self, self.OnTowerNewItem)
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tower_loopScroll).onChangeItem = BindCallback(self, self.OnTowerItemChanged)
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tower_loopScroll).onReturnItem = BindCallback(self, self.OnTowerReturnItem)
  ;
  (((self.ui).tower_loopScroll).onValueChanged):AddListener(BindCallback(self, self.OnScrollValueChanged))
  self.__towerItemDic = {}
  self.resloader = ((CS.ResLoader).Create)()
  self.__OnTowerItemSelectedEvent = BindCallback(self, self.__OnTowerItemSelected)
end

UIDungeonTowerLevel.InitDungeonTowerLevel = function(self, dunTowerCtrl, towerTypeData, completeLevel)
  -- function num : 0_1
  self.__dunTowerCtrl = dunTowerCtrl
  self.__towerTypeData = towerTypeData
  self.__completeLevel = completeLevel or 0
  self.__isAllComplete = completeLevel == (self.__towerTypeData):GetTowerTotalLevel()
  self:InitTowerBaseInfoUI()
  self:InitTowerBackImage()
  self:InitTowerLevelListUI()
  local autoProgressShow = (self.__dunTowerCtrl):GetNeedAutoShowProgress()
  if autoProgressShow then
    self:InitLastTowerProgressShow()
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIDungeonTowerLevel.InitTowerBaseInfoUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:RefreshDunTowerNoun()
  local isTwinTower = (self.__towerTypeData):IsTypeTwinTower()
  local towerId = (self.__towerTypeData):GetDungeonTowerTypeId()
  local hasRacing = false
  if isTwinTower and (self.__towerTypeData):GetTowerRacingCfg() ~= nil then
    hasRacing = true
  end
  ;
  ((self.ui).obj_NormalTower):SetActive(not isTwinTower)
  ;
  ((self.ui).obj_TwinTower):SetActive(isTwinTower)
  ;
  (((self.ui).btn_Racing).gameObject):SetActive(not isTwinTower or hasRacing)
  local rankId = (self.__towerTypeData):GetTowerRankId()
  ;
  (((self.ui).btn_Rank).gameObject):SetActive(rankId > 0)
  ;
  ((self.ui).redDot_Racing):SetActive(false)
  if isTwinTower then
    local totalLevel = (self.__towerTypeData):GetTowerTotalLevel()
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Progress).text = tostring(self.__completeLevel * 100 // totalLevel) .. "%"
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_SwitchTowerName).text = (self.__towerTypeData):GetDungeonTowerName()
    ;
    (((self.ui).btn_dataFile).transform):SetParent((self.ui).dataFileRoot2)
    local isComplete, totalFrame = (PlayerDataCenter.dungeonTowerSData):GetTowerTotalRacingFrame((self.__towerTypeData):GetDungeonTowerTypeId())
    if isComplete then
      ((self.ui).tex_TotalTime):SetIndex(0, (BattleUtil.FrameToTimeString)(totalFrame, true))
    else
      ((self.ui).tex_TotalTime):SetIndex(1)
    end
    if self._racingRewardListener == nil then
      self._racingRewardListener = function(node)
    -- function num : 0_2_0 , upvalues : self
    if node.nodeId == (self.__towerTypeData):GetDungeonTowerTypeId() then
      self:__RefreshRacingReddot()
    end
  end

      RedDotController:AddListener(RedDotDynPath.DunTwinTowerReward, self._racingRewardListener)
    end
    self:__RefreshRacingReddot()
    local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
    local totalReddot = twinTowerNode:GetRedDotCount()
    local otherHasReddot = false
    if totalReddot > 0 then
      local curCount = 0
      local twinTowerNode = twinTowerNode:GetChild(towerId)
      if twinTowerNode ~= nil then
        curCount = twinTowerNode:GetRedDotCount()
      end
      if totalReddot - curCount > 0 then
        otherHasReddot = true
      end
    end
    ;
    ((self.ui).redDot_Switch):SetActive(otherHasReddot)
  else
    (((self.ui).btn_dataFile).transform):SetParent((self.ui).dataFileRoot1)
    -- DECOMPILER ERROR at PC163: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (self.__towerTypeData):GetDungeonTowerName()
  end
  -- DECOMPILER ERROR at PC169: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).btn_dataFile).transform).anchoredPosition = Vector2.zero
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UIDungeonTowerLevel.__RefreshRacingReddot = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local towerId = (self.__towerTypeData):GetDungeonTowerTypeId()
  local hasRedot = false
  local _, twinTowerNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.DungeonTower, RedDotStaticTypeId.DungeonTwinTower)
  local towerNode = twinTowerNode:GetChild(towerId)
  if towerNode:GetRedDotCount() <= 0 then
    hasRedot = towerNode == nil
    if not hasRedot then
      local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
      local readed = saveUserData:GetDunTwinTowerRacingReaded()
      if not readed then
        hasRedot = true
      end
    end
    ;
    ((self.ui).redDot_Racing):SetActive(hasRedot)
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIDungeonTowerLevel.RefreshDunTowerNoun = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local totalNum, unlockNum, unreadNum = (self.__towerTypeData):GetTowerAvgNounNumInfo()
  ;
  ((self.ui).tex_DataCount):SetIndex(0, tostring(unlockNum), tostring(totalNum))
  ;
  ((self.ui).blueDot_dateFile):SetActive(unreadNum > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIDungeonTowerLevel.InitTowerBackImage = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local cgSize = ((CS.UIManager).Instance).BackgroundStretchSize
  local bgSizeW = (self.ui).largeBgWidth
  local bgSizeH = (self.ui).largeBgHeight
  local rSizeW = cgSize.x
  local rSizeH = cgSize.x / bgSizeW * bgSizeH
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).dynBackImage).sizeDelta = (Vector2.New)(rSizeW, rSizeH)
  self.__totalBackHeight = rSizeH - cgSize.y
end

UIDungeonTowerLevel.InitLastTowerProgressShow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local lastLevel = (PlayerDataCenter.cacheSaveData):GetLastDunTowerProgress((self.__towerTypeData):GetDungeonTowerTypeId())
  ;
  (PlayerDataCenter.cacheSaveData):SaveLastDunTowerProgress((self.__towerTypeData):GetDungeonTowerTypeId(), self.__completeLevel)
  if lastLevel == nil or self.__completeLevel <= lastLevel then
    return 
  end
  local nCompleteLevel = self.__completeLevel
  local towerNounId = 0
  for i = lastLevel + 1, nCompleteLevel do
    local towerLevelData = (self.__towerTypeData):GetTowerLevelByNum(i)
    if towerLevelData ~= nil then
      local nounId = towerLevelData:GetTowerLevelNounId()
      if nounId > 0 then
        towerNounId = nounId
      end
    end
  end
  if towerNounId > 0 then
    self:__ShowNounUnlock(towerNounId, function()
    -- function num : 0_6_0 , upvalues : self, lastLevel, nCompleteLevel
    self:__PlayTowerUnlockLevelAni(lastLevel, nCompleteLevel)
  end
)
  else
    ;
    (UIUtil.AddOneCover)("DungeonTowerLevel")
    self.__effectTimerId = TimerManager:StartTimer(1, function()
    -- function num : 0_6_1 , upvalues : _ENV, self, lastLevel, nCompleteLevel
    (UIUtil.CloseOneCover)("DungeonTowerLevel")
    self:__PlayTowerUnlockLevelAni(lastLevel, nCompleteLevel)
  end
, nil, true, true)
  end
end

UIDungeonTowerLevel.__ShowNounUnlock = function(self, towerNounId, callback)
  -- function num : 0_7 , upvalues : _ENV
  if towerNounId <= 0 then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerSuccess, function(window)
    -- function num : 0_7_0 , upvalues : _ENV, towerNounId, callback
    if window == nil then
      return 
    end
    local nounCfg = (ConfigData.noun_des)[towerNounId]
    window:InitDunTowerNounUnlock((LanguageUtil.GetLocaleText)(nounCfg.name))
    window:SetBtnCloseAction(callback)
    AudioManager:PlayAudioById(1124)
  end
)
end

UIDungeonTowerLevel.__PlayTowerUnlockLevelAni = function(self, lCompleteLevel, nCompleteLevel)
  -- function num : 0_8 , upvalues : _ENV
  local startIndex = self:__GetScrollFillIndex(nCompleteLevel)
  ;
  (UIUtil.AddOneCover)("DungeonTowerLevel")
  local speed = (math.clamp)((nCompleteLevel - lCompleteLevel) * 500, 500, 10000)
  ;
  ((self.ui).tower_loopScroll):SrollToCell(startIndex, speed, function()
    -- function num : 0_8_0 , upvalues : _ENV, nCompleteLevel, self
    (UIUtil.CloseOneCover)("DungeonTowerLevel")
    if nCompleteLevel < (self.__towerTypeData):GetTowerTotalLevel() then
      local newLevelNum = nCompleteLevel + 1
      local towerLevelItem = self:GetLevelItemGoByIndex(newLevelNum)
      if towerLevelItem ~= nil then
        (UIUtil.AddOneCover)("DungeonTowerLevel")
        local towerLevelData = (self.__towerTypeData):GetTowerLevelByNum(newLevelNum)
        self.curLvEff = nil
        if towerLevelData ~= nil and towerLevelData:IsTowerFlagLevel() then
          self.curLvEff = (self.ui).eff_unlockNewLvGold
          AudioManager:PlayAudioById(1151)
        else
          self.curLvEff = (self.ui).eff_unlockNewLevel
          AudioManager:PlayAudioById(1150)
        end
        self:ShowUnlockNewLvEff(self.curLvEff, towerLevelItem.transform)
        self.__effectTimerId = TimerManager:StartTimer((self.ui).time_effUnlock, function()
      -- function num : 0_8_0_0 , upvalues : self, _ENV
      self:HideUnlockNewLvEff(self.curLvEff)
      self.curLvEff = nil
      ;
      (UIUtil.CloseOneCover)("DungeonTowerLevel")
    end
, nil, true)
        return 
      end
    end
  end
)
end

UIDungeonTowerLevel.ShowUnlockNewLvEff = function(self, objEff, parent)
  -- function num : 0_9 , upvalues : _ENV
  (objEff.transform):SetParent(parent)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (objEff.transform).anchoredPosition3D = Vector3.zero
  objEff:SetActive(true)
end

UIDungeonTowerLevel.HideUnlockNewLvEff = function(self, objEff)
  -- function num : 0_10
  objEff:SetActive(false)
  ;
  (objEff.transform):SetParent((self.ui).hideNode)
end

UIDungeonTowerLevel.InitTowerLevelListUI = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local totalItemCount = (self.__towerTypeData):GetTowerTotalLevel() + 2
  self.__totalItemCount = totalItemCount
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tower_loopScroll).totalCount = totalItemCount
  local baseItemHeight = ((self.ui).ly_towerItem).preferredHeight
  local scrollRectHeight = ((((self.ui).tower_loopScroll).transform).rect).height
  local ableScrollHeight = baseItemHeight * totalItemCount - scrollRectHeight
  self.__itemRatioUnit = baseItemHeight / ableScrollHeight
  self.__minSlideRatio = self.__itemRatioUnit / 2
  self.__cycleLayerRatio = 1 / self.__itemRatioUnit / (self.ui).cycleLayerCount
  self.__layerScrollDistance = (self.ui).layerScrollSpeed * baseItemHeight * (self.ui).cycleLayerCount
  self.__startLayerPos = 1 - (self.ui).startLayerOffset * self.__itemRatioUnit + scrollRectHeight / ableScrollHeight * 1.1
  local fillLevel = (PlayerDataCenter.cacheSaveData):GetLastDunTowerProgress((self.__towerTypeData):GetDungeonTowerTypeId())
  if fillLevel == nil or self.__completeLevel <= fillLevel then
    fillLevel = self.__completeLevel
  end
  local startIndex = self:__GetScrollFillIndex(fillLevel)
  ;
  ((self.ui).tower_loopScroll):RefillCells(startIndex)
  local posY = ((self.ui).tower_loopScroll).verticalNormalizedPosition
  self:__SetTowerLoopRectPosY(posY)
end

UIDungeonTowerLevel.__GetScrollFillIndex = function(self, levelNum)
  -- function num : 0_12 , upvalues : _ENV
  local startIndex = (math.clamp)(levelNum - 1, 0, (self.__towerTypeData):GetTowerTotalLevel())
  return startIndex
end

UIDungeonTowerLevel.OnTowerNewItem = function(self, go)
  -- function num : 0_13 , upvalues : UINDunTowerLevelItem
  local levelItem = (UINDunTowerLevelItem.New)()
  levelItem:Init(go)
  levelItem:BindTowerItemCommon((self.__towerTypeData):IsTypeTwinTower(), self.resloader, self.__OnTowerItemSelectedEvent, (self.ui).obj_SelectLevel, (self.ui).obj_NewLevel, (self.ui).obj_Down)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__towerItemDic)[go] = levelItem
end

UIDungeonTowerLevel.OnTowerReturnItem = function(self, go)
  -- function num : 0_14
  local levelItem = (self.__towerItemDic)[go]
  if levelItem == nil then
    return 
  end
  levelItem:ClearItemTowerLevel()
end

UIDungeonTowerLevel.OnTowerItemChanged = function(self, go, index)
  -- function num : 0_15 , upvalues : _ENV, DungeonLevelEnum
  local towerLevelItem = (self.__towerItemDic)[go]
  if towerLevelItem == nil then
    error("Can\'t find towerlevelItem by gameObject")
    return 
  end
  local num = index
  if num == 0 then
    towerLevelItem:InitTowerLevelItemKeep((DungeonLevelEnum.TowerLevelItemType).TopEmpty, (self.ui).obj_Top)
    return 
  end
  if num == (self.__towerTypeData):GetTowerTotalLevel() + 1 then
    towerLevelItem:InitTowerLevelItemKeep((DungeonLevelEnum.TowerLevelItemType).DownEmpty, (self.ui).obj_Top)
    return 
  end
  local towerLevelData = (self.__towerTypeData):GetTowerLevelByNum(num)
  if towerLevelData == nil then
    error("dungeon tower level cfg is null,level_num:" .. tostring(num))
    return 
  end
  towerLevelItem:InitTowerLevelItem(towerLevelData, self.__completeLevel)
  towerLevelItem:SetAsSelectTowerLevel(towerLevelData == self.__selectTowerLevelData)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIDungeonTowerLevel.OnScrollValueChanged = function(self, vec2)
  -- function num : 0_16
  local posY = vec2.y
  self:__SetTowerLoopRectPosY(posY)
end

UIDungeonTowerLevel.__SetTowerLoopRectPosY = function(self, posY)
  -- function num : 0_17 , upvalues : _ENV
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).dynBackImage).anchoredPosition = (Vector2.New)(0, self.__totalBackHeight * (math.clamp)(posY, 0, 1))
  local t = (self.__startLayerPos + posY) * self.__cycleLayerRatio
  local pos = t - (math.floor)(t)
  if pos > 0.5 then
    pos = -(1 - pos) * 2
  else
    pos = pos * 2
  end
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).middleLayerNode).transform).anchoredPosition = Vector2(0, pos * self.__layerScrollDistance)
  local lastRectY = posY
  if self.__loopRectY == nil then
    self.__loopRectY = posY
  end
  if not self.__isAllComplete and self.__selectTowerLevelData == nil and self.__minSlideRatio <= (math.abs)(lastRectY - self.__loopRectY) then
    self.__loopRectY = posY
    self:RefreshGotoCurLevel()
  end
end

UIDungeonTowerLevel.RefreshGotoCurLevel = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local levelNum = self.__completeLevel + 1
  local towerLevelItem = self:GetLevelItemGoByIndex(levelNum)
  if towerLevelItem ~= nil then
    (((self.ui).btn_ToBack).gameObject):SetActive(false)
    ;
    (((self.ui).btn_ToNext).gameObject):SetActive(false)
    return 
  end
  local isUp = false
  for go,towerItem in pairs(self.__towerItemDic) do
    local towerLevelData = towerItem:GetItemTowerLevelData()
    if towerLevelData ~= nil and levelNum < towerLevelData:GetDunTowerLevelNum() then
      isUp = true
      break
    end
  end
  do
    ;
    (((self.ui).btn_ToBack).gameObject):SetActive(isUp)
    ;
    (((self.ui).btn_ToNext).gameObject):SetActive(not isUp)
  end
end

UIDungeonTowerLevel.GetLevelItemGoByIndex = function(self, index)
  -- function num : 0_19
  local go = ((self.ui).tower_loopScroll):GetCellByIndex(index)
  do
    if go ~= nil then
      local towerLevelItem = (self.__towerItemDic)[go]
      return towerLevelItem
    end
    return nil
  end
end

UIDungeonTowerLevel.OnBtnGotoCurTowerLevel = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local startIndex = self:__GetScrollFillIndex(self.__completeLevel)
  ;
  (UIUtil.AddOneCover)("DungeonTowerLevel")
  AudioManager:PlayAudioById(1152)
  ;
  ((self.ui).tower_loopScroll):SrollToCell(startIndex, 10000, function()
    -- function num : 0_20_0 , upvalues : _ENV
    (UIUtil.CloseOneCover)("DungeonTowerLevel")
  end
)
end

UIDungeonTowerLevel.__OnTowerItemSelected = function(self, towerLevelItem, towerLevelData)
  -- function num : 0_21 , upvalues : _ENV
  if self.__selectTowerLevelData == towerLevelData then
    return 
  end
  ;
  (((self.ui).btn_ToBack).gameObject):SetActive(false)
  ;
  (((self.ui).btn_ToNext).gameObject):SetActive(false)
  if self.__selectTowerLevelData ~= nil then
    self:__CancelLastLevelSelect()
  end
  towerLevelItem:SetAsSelectTowerLevel(true)
  self.__selectTowerLevelData = towerLevelData
  local towerTypeId = (self.__towerTypeData):GetDungeonTowerTypeId()
  local isLocked = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel(towerTypeId) + 1 < towerLevelData:GetDunTowerLevelNum()
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(window)
    -- function num : 0_21_0 , upvalues : self, towerLevelData, isLocked
    window:SetDunLevelDetaiHideStartEvent(function()
      -- function num : 0_21_0_0 , upvalues : self
      self:__PlayMoveLeftTween(false)
      self:__CancelLastLevelSelect()
      self:RefreshGotoCurLevel()
    end
)
    window:SetDunLevelDetaiHideEndEvent(function()
      -- function num : 0_21_0_1
    end
)
    local width, duration = window:GetDLevelDetailWidthAndDuration()
    self:__PlayMoveLeftTween(true, width, duration)
    window:InitDungeonLevelDetail(towerLevelData, isLocked)
  end
)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIDungeonTowerLevel.__PlayMoveLeftTween = function(self, isLeft, offset, duration)
  -- function num : 0_22 , upvalues : _ENV
  local var = ((self.ui).obj_mainNode).transform
  do
    if self.__moveLeftTween == nil then
      local endValue = (Vector2.unity_vector2)(1 - offset / ((var.rect).width + (self.ui).moveLeftTwenOffset), 1)
      self.__moveLeftTween = (var:DOAnchorMax(endValue, duration)):SetAutoKill(false)
      self.__moveLeftTweenDuration = duration
    end
    if self.currentMoveLeft ~= nil and self.currentMoveLeft == isLeft then
      return 
    end
    self.currentMoveLeft = isLeft
    if isLeft then
      (self.__moveLeftTween):PlayForward()
    else
      ;
      (self.__moveLeftTween):PlayBackwards()
    end
  end
end

UIDungeonTowerLevel.__CancelLastLevelSelect = function(self)
  -- function num : 0_23
  if self.__selectTowerLevelData == nil then
    return 
  end
  local selectTowerData = self.__selectTowerLevelData
  self.__selectTowerLevelData = nil
  local towerItem = self:GetLevelItemGoByIndex(selectTowerData:GetDunTowerLevelNum())
  if towerItem ~= nil then
    towerItem:SetAsSelectTowerLevel(false)
  end
end

UIDungeonTowerLevel.CloseLevelDetailWindow = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.__selectTowerLevelData ~= nil then
    (UIUtil.OnClickBack)()
  end
end

UIDungeonTowerLevel._OnClickBack = function(self, toHome)
  -- function num : 0_25
  self:Delete()
end

UIDungeonTowerLevel.OnDataFileClicked = function(self)
  -- function num : 0_26 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.AvgNounDes, function(win)
    -- function num : 0_26_0 , upvalues : self
    win:InitAvgNounDes(false, nil, (self.__towerTypeData):GetTowerAvgNounType())
    win:BindAvgNounCloseEvent(function()
      -- function num : 0_26_0_0 , upvalues : self
      self:RefreshDunTowerNoun()
    end
)
  end
)
end

UIDungeonTowerLevel.OnRankClicked = function(self)
  -- function num : 0_27 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_27_0 , upvalues : self
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank((self.__towerTypeData):GetTowerRankId())
  end
)
end

UIDungeonTowerLevel.OnBtnSwitchTowerClick = function(self)
  -- function num : 0_28 , upvalues : _ENV
  (self.__dunTowerCtrl):RequestRacingRankSelfInfo(function(myRankDetail)
    -- function num : 0_28_0 , upvalues : _ENV, self
    UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTwinTowerSelect, function(window)
      -- function num : 0_28_0_0 , upvalues : self, myRankDetail
      if window == nil then
        return 
      end
      window:InitDunTwinTowerSelect(self.__dunTowerCtrl, (self.__towerTypeData):GetDungeonTowerTypeId(), myRankDetail)
    end
)
  end
)
end

UIDungeonTowerLevel.OnBtnRacingClick = function(self)
  -- function num : 0_29 , upvalues : _ENV
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  if saveUserData:SetDunTwinTowerRacingReaded(true) then
    self:__RefreshRacingReddot()
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonTowerRacing, function(window)
    -- function num : 0_29_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitTowerRacing(self.__towerTypeData)
  end
)
end

UIDungeonTowerLevel.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_30
  return function()
    -- function num : 0_30_0 , upvalues : self
    self:RefreshDunTowerNoun()
  end

end

UIDungeonTowerLevel.OnDelete = function(self)
  -- function num : 0_31 , upvalues : _ENV, base
  (UIUtil.CloseOneCover)("DungeonTowerLevel")
  if self._racingRewardListener ~= nil then
    RedDotController:RemoveListener(RedDotDynPath.DunTwinTowerReward, self._racingRewardListener)
  end
  TimerManager:StopTimer(self.__effectTimerId)
  if self.__moveLeftTween ~= nil then
    (self.__moveLeftTween):Kill()
    self.__moveLeftTween = nil
  end
  UIManager:DeleteWindow(UIWindowTypeID.DungeonLevelDetail)
  ;
  (base.OnDelete)(self)
end

return UIDungeonTowerLevel

