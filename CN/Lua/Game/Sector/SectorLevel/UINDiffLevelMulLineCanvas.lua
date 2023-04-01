-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDiffLevelMulLineCanvas = class("UINDiffLevelMulLineCanvas", UIBaseNode)
local base = UIBaseNode
local UINLevelMulLineGroup = require("Game.Sector.SectorLevel.UINLevelMulLineGroup")
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local sectorLevelUtil = require("Game.Sector.SectorLevel.SectorLevelUtil")
local cs_Material = (CS.UnityEngine).Material
local LoopVerticalScrollRect = ((CS.UnityEngine).UI).LoopVerticalScrollRect
local LoopHorizontalScrollRect = ((CS.UnityEngine).UI).LoopHorizontalScrollRect
local UINActChapterItem = require("Game.ActivitySummer.UI.Sector.UINActChapterItem")
local CS_Ease = ((CS.DG).Tweening).Ease
UINDiffLevelMulLineCanvas.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__levelGroupUI = {}
  ;
  (UIUtil.LuaUIBindingTable)(((self.ui).levelGroup).transform, self.__levelGroupUI)
  ;
  (UIUtil.AddButtonListener)((self.ui).contentVertical, self, self.__OnClickBg)
  ;
  (UIUtil.AddButtonListener)((self.ui).contentHorizontal, self, self.__OnClickBg)
  self.__inited = false
  self.scrollItemGoDic = {}
  self.scrollItemPageIdDic = {}
  self._sectorStageIdGroupMapping = {}
  self._sectorAvgIdGroupMapping = {}
  self.lastCompletedStage = {groupIndex = nil, id = nil, isState = nil}
end

UINDiffLevelMulLineCanvas.InitDiffLevelCanvas = function(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
  -- function num : 0_1 , upvalues : _ENV
  local isNeedInitData = self.sectorId ~= sectorId or self.difficulty ~= difficulty
  self.sectorId = sectorId
  if isUnCompleteEp then
    self.lastEpStateCfg = autoStateCfg
  else
    self.lastEpStateCfg = nil
  end
  self.spDic = self:GenAllSpecialListDic()
  self.difficulty = difficulty
  self.levelItemClickEvent = levelItemClickEvent
  self.levelAvgMainClickEvent = levelAvgMainClickEvent
  self.lAvgSubClickEvent = lAvgSubClickEvent
  self.tweenCompleteEvent = tweenCompleteEvent
  self.resLoader = resLoader
  self.sectorLevelTipsGuides = sectorLevelTipsGuides
  self.clickBackFunc = clickBackFunc
  local locateStageId, isWin = nil, nil
  if (PlayerDataCenter.sectorStage).lastSatgeData ~= nil then
    locateStageId = (((PlayerDataCenter.sectorStage).lastSatgeData).stageCfg).id
    isWin = ((PlayerDataCenter.sectorStage).lastSatgeData).isWin
  elseif autoStateCfg ~= nil then
    locateStageId = autoStateCfg.id
    isWin = false
  end
  self.isWin = isWin
  local sectorCfg = (ConfigData.sector)[sectorId]
  local levelArrangeType = (sectorCfg.level_arrange)[difficulty]
  local arrangeCfg = (ConfigData.level_arrange)[levelArrangeType]
  if arrangeCfg == nil then
    error((string.format)("Can\'t find level arrange Cfg,arrangeId:%s, difficulty:%s, sectorId:%s", levelArrangeType, difficulty, sectorId))
    return 
  end
  self.arrangeCfg = arrangeCfg
  local isVertical = (arrangeCfg[1]).vertical
  local verticalChange = self.isVertical ~= nil and self.isVertical ~= isVertical
  self.isVertical = isVertical
  if self.__inited and verticalChange then
    ((self.ui).scrollRect):ClearCells()
    local prefabSource = ((self.ui).scrollRect):GetPrefabSource()
    DestroyUnityObject((self.ui).scrollRect, true)
    self:AddScrollRect(prefabSource)
  end
  self:AddScrollRect()
  self.__inited = true
  if isNeedInitData or self.specialLevelList then
    self:InitLevelGroupData()
  end
  do
    if locateStageId ~= nil then
      local pageId = (self._sectorStageIdGroupMapping)[locateStageId]
      -- DECOMPILER ERROR at PC117: Confused about usage of register: R21 in 'UnsetPending'

      if pageId ~= nil then
        (self.lastCompletedStage).groupIndex = pageId
        -- DECOMPILER ERROR at PC119: Confused about usage of register: R21 in 'UnsetPending'

        ;
        (self.lastCompletedStage).id = locateStageId
        -- DECOMPILER ERROR at PC121: Confused about usage of register: R21 in 'UnsetPending'

        ;
        (self.lastCompletedStage).isState = true
      end
    end
    self:RefillScrollRect(isWin == false)
    -- DECOMPILER ERROR: 14 unprocessed JMP targets
  end
end

UINDiffLevelMulLineCanvas.SetDungeonListInSector = function(self, dungeonDataDic, clickDungeonItemEvent, blueReddotFunc)
  -- function num : 0_2
end

UINDiffLevelMulLineCanvas.SetSpecialLevelList = function(self, specialLevelList)
  -- function num : 0_3
  self.specialLevelList = specialLevelList
end

UINDiffLevelMulLineCanvas.SetSpecialLevelState = function(self, state)
  -- function num : 0_4
  self.levelState = state
end

UINDiffLevelMulLineCanvas.ResetLevelGroupDataBySpecialLevelList = function(self, specialLevelList)
  -- function num : 0_5
  self.specialLevelList = specialLevelList
  self:InitLevelGroupData()
  self:RefillScrollRect(self.isWin)
end

UINDiffLevelMulLineCanvas.SetBackground = function(self, texture)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  if not IsNull(texture) then
    ((self.ui).Img_background).texture = texture
  end
end

UINDiffLevelMulLineCanvas.InitLevelGroupData = function(self)
  -- function num : 0_7 , upvalues : sectorLevelUtil
  self.finalPage = nil
  self.splitPointPage = nil
  self.layourDic = nil
  self.levelGroupDataList = (sectorLevelUtil.GetLevelGroupByNormalMulLine)(self.arrangeCfg, self:GetLevelList(), self._sectorStageIdGroupMapping, self._sectorAvgIdGroupMapping)
end

UINDiffLevelMulLineCanvas.GetLevelList = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return (((ConfigData.sector_stage).sectorDiffDic)[self.sectorId])[self.difficulty]
end

UINDiffLevelMulLineCanvas.AddScrollRect = function(self, prefabSource)
  -- function num : 0_9 , upvalues : _ENV, LoopVerticalScrollRect, LoopHorizontalScrollRect
  ((self.ui).scrollRectGo):SetActive(false)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  if self.isVertical then
    (self.ui).scrollRect = ((self.ui).scrollRectGo):AddComponent(typeof(LoopVerticalScrollRect))
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).horizontal = false
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).content = ((self.ui).contentVertical).transform
  else
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.ui).scrollRect = ((self.ui).scrollRectGo):AddComponent(typeof(LoopHorizontalScrollRect))
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).vertical = false
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).scrollRect).content = ((self.ui).contentHorizontal).transform
  end
  if prefabSource == nil then
    ((self.ui).scrollRect):SetPrefab((self.ui).levelGroup)
  else
    ;
    ((self.ui).scrollRect):SetPrefabSource(prefabSource)
  end
  ;
  ((self.ui).scrollRectGo):SetActive(true)
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC77: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  -- DECOMPILER ERROR at PC84: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onReturnItem = BindCallback(self, self.__OnReturnItem)
end

UINDiffLevelMulLineCanvas.LocationSectorStageItem = function(self, id, isAvg)
  -- function num : 0_10
  if not isAvg then
    isAvg = false
  end
  local levelItem, groupItem, pageId = nil, nil, nil
  if isAvg then
    levelItem = self:GetSectorLAvgMainItem(id)
  else
    -- DECOMPILER ERROR at PC16: Overwrote pending register: R5 in 'AssignReg'

    -- DECOMPILER ERROR at PC17: Overwrote pending register: R4 in 'AssignReg'

    levelItem = self:GetSectorStageItem(id)
  end
  if levelItem == nil then
    return nil, nil
  end
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.lastCompletedStage).groupIndex = pageId
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.lastCompletedStage).id = id
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.lastCompletedStage).isState = not isAvg
  self:RefillScrollRect()
  return levelItem, groupItem
end

UINDiffLevelMulLineCanvas.GetSectorStageItem = function(self, stageId)
  -- function num : 0_11
  local pageIndex = (self._sectorStageIdGroupMapping)[stageId]
  if pageIndex == nil then
    return 
  end
  local groupItem = self:GetLevelGroupItemByIndex(pageIndex)
  if groupItem == nil then
    return 
  end
  return groupItem:GetLevelItemByIndex(stageId, true), groupItem, pageIndex
end

UINDiffLevelMulLineCanvas.GetSectorLAvgMainItem = function(self, avgId)
  -- function num : 0_12
  local pageIndex = (self._sectorAvgIdGroupMapping)[avgId]
  if pageIndex == nil then
    return 
  end
  local groupItem = self:GetLevelGroupItemByIndex(pageIndex)
  if groupItem == nil then
    return 
  end
  return groupItem:GetLevelItemByIndex(avgId, false), groupItem, pageIndex
end

UINDiffLevelMulLineCanvas.SetSectorStageItemBlueDot = function(self, stageId, show)
  -- function num : 0_13
  local levelItem = self:GetSectorStageItem(stageId)
  if levelItem ~= nil then
    levelItem:ShowBlueDotLevelItem(show)
  end
end

UINDiffLevelMulLineCanvas.SetStopTweenCompleteEvent = function(self, bool)
  -- function num : 0_14
end

UINDiffLevelMulLineCanvas.PlayDiffLevelCanvasSwitchTween = function(self, isUpTween)
  -- function num : 0_15
  self:OnSwitchTweenComplete()
end

UINDiffLevelMulLineCanvas.OnSwitchTweenComplete = function(self)
  -- function num : 0_16
  self:OnSwitchTweenEndEvent()
end

UINDiffLevelMulLineCanvas.OnSwitchTweenRewind = function(self)
  -- function num : 0_17
end

UINDiffLevelMulLineCanvas.OnSwitchTweenEndEvent = function(self)
  -- function num : 0_18
  if self.tweenCompleteEvent ~= nil then
    (self.tweenCompleteEvent)()
  end
end

UINDiffLevelMulLineCanvas.SetSectorLAvgMainItemBlueDot = function(self, avgId, show)
  -- function num : 0_19
  local lAvgMainItem = self:GetSectorLAvgMainItem(avgId)
  if lAvgMainItem ~= nil then
    lAvgMainItem:ShowBlueDotLAvgMain(show)
  end
end

UINDiffLevelMulLineCanvas.RefillScrollRect = function(self, isOpenInfo)
  -- function num : 0_20 , upvalues : _ENV
  self.scrollItemPageIdDic = {}
  local selectId = (self.lastCompletedStage).id or 0
  local isState = (self.lastCompletedStage).isState or false
  local groupIndex = (self.lastCompletedStage).groupIndex or 1
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).totalCount = #self.levelGroupDataList
  local indexOffset = groupIndex - 1
  local posOffset = 0
  if selectId > 0 then
    for layoutId,grouDatas in pairs((self.levelGroupDataList)[groupIndex]) do
      for index,groupData in ipairs(grouDatas) do
        if (isState and groupData.stageCfg ~= nil and (groupData.stageCfg).id == selectId) or not isState and groupData.avgCfg ~= nil and (groupData.avgCfg).id == selectId then
          local arrange = ((ConfigData.level_arrange)[layoutId])[index]
          if not self.isVertical or not -(arrange.pos)[2] - (self.__levelGroupUI).padding - (self.__levelGroupUI).lastPadding then
            posOffset = (arrange.pos)[1] - (self.__levelGroupUI).padding - (self.__levelGroupUI).lastPadding
          end
        end
      end
    end
    posOffset = posOffset + (self.__levelGroupUI).lastPadding
  end
  local remainLength = 0
  for i = groupIndex, #self.levelGroupDataList do
    local pageContent = (self.levelGroupDataList)[i]
    local endPos = nil
    for layoutId,grouDatas in pairs(pageContent) do
      local arrangeCfg = (ConfigData.level_arrange)[layoutId]
      local lastArrange = arrangeCfg[#grouDatas]
      if not self.isVertical or not (lastArrange.pos)[2] then
        local tempEndPos = (lastArrange.pos)[1]
      end
      if endPos == nil or ((self.isVertical and tempEndPos < endPos) or endPos < tempEndPos) then
        endPos = tempEndPos
      end
    end
    do
      do
        if endPos == nil or not endPos then
          endPos = 0
        end
        remainLength = remainLength + (math.abs)(endPos) + (self.__levelGroupUI).padding
        -- DECOMPILER ERROR at PC138: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  remainLength = remainLength - (posOffset)
  if not self.isVertical or not ((self.transform).rect).height then
    local viewLength = ((self.transform).rect).width
  end
  if viewLength < remainLength then
    ((self.ui).scrollRect):RefillCells(indexOffset, posOffset)
  else
    ;
    ((self.ui).scrollRect):RefillCellsFromEnd()
  end
  if isOpenInfo then
    local groupItem = self:GetLevelGroupItemByIndex(groupIndex)
    if groupItem ~= nil then
      local item = groupItem:GetLevelItemByIndex(selectId, isState)
      if item ~= nil and item.stageCfg ~= nil then
        item:OnClickLevelItem()
      else
        error("want to open a not levelItem\'s info, groupIndex:" .. tostring(groupIndex) .. ", id:" .. tostring(selectId))
      end
    end
  end
end

UINDiffLevelMulLineCanvas.__OnNewItem = function(self, go)
  -- function num : 0_21 , upvalues : UINLevelMulLineGroup
  local item = (UINLevelMulLineGroup.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.scrollItemGoDic)[go] = item
  self:_CalculateScrollRectWidth()
end

UINDiffLevelMulLineCanvas.__OnReturnItem = function(self, go)
  -- function num : 0_22 , upvalues : _ENV
  local item = (self.scrollItemGoDic)[go]
  if item == nil then
    error("OnReturnItem : Can\'t find item by gameObject")
    return 
  end
  item:OnReturnLevelGroup()
  self:_CalculateScrollRectWidth()
end

UINDiffLevelMulLineCanvas.__OnChangeItem = function(self, go, index)
  -- function num : 0_23 , upvalues : _ENV
  local item = (self.scrollItemGoDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local pageId = index + 1
  local lastIndex = (self.scrollItemPageIdDic)[go]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.scrollItemPageIdDic)[go] = pageId
  local levelGroupData = (self.levelGroupDataList)[pageId]
  local lastLocals = (self.lastLocalsDataList)[pageId - 1]
  item:SetSpecialLevelState(self.levelState)
  item:SetAllSpecialListDic(self.spDic)
  item:GenGroup(levelGroupData, lastLocals, self.finalPage == pageId, self.resLoader, (self.ui).lineHolder, self.levelItemClickEvent, self.levelAvgMainClickEvent, self.sectorLevelTipsGuides, self.lastEpStateCfg, self.sectorId)
  for _,content in pairs(levelGroupData) do
    for _,v in ipairs(content) do
      if v.stageCfg ~= nil then
        local levelItem = item:GetLevelItemByIndex((v.stageCfg).id, true)
        if levelItem ~= nil then
          if (PlayerDataCenter.sectorStage):IsStageUnlock((v.stageCfg).id) then
            local showBlueDot = not (PlayerDataCenter.sectorStage):IsStageComplete((v.stageCfg).id)
          end
          levelItem:ShowBlueDotLevelItem(showBlueDot)
        end
      elseif v.avgCfg ~= nil then
        local lAvgMainItem = item:GetLevelItemByIndex((v.avgCfg).id, false)
        if lAvgMainItem ~= nil then
          local avgId = (v.avgCfg).id
          local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
          if avgPlayCtrl:IsAvgUnlock(avgId) then
            local showBlueDot = not avgPlayCtrl:IsAvgPlayed(avgId)
          end
          lAvgMainItem:ShowBlueDotLAvgMain(showBlueDot)
        end
      end
    end
  end
  self:_CalculateScrollRectWidth()
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINDiffLevelMulLineCanvas.GenAllSpecialListDic = function(self)
  -- function num : 0_24
  return nil
end

UINDiffLevelMulLineCanvas.GetLevelGroupItemByIndex = function(self, index)
  -- function num : 0_25
  local go = ((self.ui).scrollRect):GetCellByIndex(index - 1)
  return (self.scrollItemGoDic)[go]
end

UINDiffLevelMulLineCanvas.RefreshUncompletedEp = function(self, lastEpStateCfg)
  -- function num : 0_26 , upvalues : _ENV
  self.lastEpStateCfg = lastEpStateCfg
  for k,v in ipairs(self.levelGroupDataList) do
    local groupItem = self:GetLevelGroupItemByIndex(k)
    if groupItem ~= nil then
      groupItem:RefreshUncompletedEp(lastEpStateCfg)
    end
  end
end

UINDiffLevelMulLineCanvas.RefreshLevelState = function(self)
  -- function num : 0_27 , upvalues : _ENV
  for k,v in ipairs(self.levelGroupDataList) do
    local groupItem = self:GetLevelGroupItemByIndex(k)
    if groupItem ~= nil then
      groupItem:RefreshLevelItemState()
    end
  end
end

UINDiffLevelMulLineCanvas.PlayDiffLevelContentTween = function(self, duration)
  -- function num : 0_28 , upvalues : CS_Ease
  if not self.isVertical then
    return 
  end
  if self.contentVerticalTween ~= nil then
    (self.contentVerticalTween):Kill()
  end
  self.contentVerticalTween = ((((self.ui).contentVertical).transform):DOAnchorPosX(0, duration)):SetEase(CS_Ease.InQuad)
end

UINDiffLevelMulLineCanvas.__OnClickBg = function(self)
  -- function num : 0_29
  if self.clickBackFunc ~= nil then
    (self.clickBackFunc)()
  end
end

UINDiffLevelMulLineCanvas._CalculateScrollRectWidth = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local width = 0
  for go,item in pairs(self.scrollItemGoDic) do
    local sizeDelta, _ = item:GetGroupSizeDelta()
    width = sizeDelta.x + width
  end
  local vec = (Vector2.New)(width, 0)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_Chapter).sizeDelta = vec
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_Lock).sizeDelta = vec
end

UINDiffLevelMulLineCanvas.GetSectorDungeonItem = function(self, dungeonId)
  -- function num : 0_31
  return nil
end

UINDiffLevelMulLineCanvas.OnDelete = function(self)
  -- function num : 0_32 , upvalues : _ENV, base
  if self.contentVerticalTween ~= nil then
    (self.contentVerticalTween):Kill()
  end
  for k,v in pairs(self.scrollItemGoDic) do
    v:Delete()
  end
  self.resLoader = nil
  ;
  (base.OnDelete)(self)
end

return UINDiffLevelMulLineCanvas

