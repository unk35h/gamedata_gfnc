-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelMulLineGroup = class("UINLevelMulLineGroup", UIBaseNode)
local base = UIBaseNode
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local UINLevelSimpleItem = require("Game.ActivitySummer.UI.Sector.UINActLevelSimpleItem")
local UINLevelWin23Item = require("Game.ActivityWinter23.UI.Sector.UINActLevelWin23Item")
local UINLevelAvgMain = require("Game.ActivitySummer.UI.Sector.UINActLevelAvgMain")
local UINLevelAvgWin23Main = require("Game.ActivityWinter23.UI.Sector.UINActLevelAvgWin23Main")
local UINLevelLine = require("Game.Sector.SectorLevel.UINLevelLine")
local eLevelLineType = require("Game.Sector.Enum.eLevelLineType")
local UINLevelItemType = {[(SectorLevelDetailEnum.eSectorType).ActSum21] = UINLevelSimpleItem, [(SectorLevelDetailEnum.eSectorType).ActWin23] = UINLevelWin23Item}
local UINAvgItemType = {[(SectorLevelDetailEnum.eSectorType).ActSum21] = UINLevelAvgMain, [(SectorLevelDetailEnum.eSectorType).ActWin23] = UINLevelAvgWin23Main}
local UINSpLevelItemType = {[(SectorLevelDetailEnum.eSectorType).ActWin23] = require("Game.ActivityWinter23.UI.Sector.UINActLevelWin23RepeatItem")}
UINLevelMulLineGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelLine
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).levelItem):SetActive(false)
  ;
  ((self.ui).plotItem):SetActive(false)
  ;
  ((self.ui).lineItem):SetActive(false)
  self.levelLineItem = (UIItemPool.New)(UINLevelLine, (self.ui).lineItem)
end

UINLevelMulLineGroup.SetSpecialLevelState = function(self, state)
  -- function num : 0_1
  if self.specialLevelStater ~= state then
    if self.levelItemPool then
      (self.levelItemPool):DeleteAll()
      self.levelItemPool = nil
    end
    if self.lAvgMainItemPool then
      (self.lAvgMainItemPool):DeleteAll()
      self.lAvgMainItemPool = nil
    end
    if self.spItemPool then
      (self.spItemPool):DeleteAll()
      self.spItemPool = nil
    end
  end
  self.specialLevelStater = state
end

UINLevelMulLineGroup.GenGroup = function(self, pageContent, lastLocals, isFinalPage, resLoader, lineHolder, levelItemClickEvent, levelAvgMainClickEvent, sectorLevelTipsGuides, lastEpStateCfg, sectorId)
  -- function num : 0_2 , upvalues : _ENV, UINLevelItemType, UINLevelSimpleItem, UINAvgItemType, UINLevelAvgMain, UINSpLevelItemType
  self.lastEpStateCfg = lastEpStateCfg
  self.sectorLevelTipsGuides = sectorLevelTipsGuides
  self.levelItemClickEvent = levelItemClickEvent
  self.lAvgMainClickEvent = levelAvgMainClickEvent
  self.resLoader = resLoader
  local sectorCfg = (ConfigData.sector)[sectorId]
  if not sectorCfg or not UINLevelItemType[sectorCfg.sector_type] then
    self.levelItemPool = (UIItemPool.New)(self.levelItemPool or UINLevelSimpleItem, (self.ui).levelItem)
    if not sectorCfg or not UINAvgItemType[sectorCfg.sector_type] then
      self.lAvgMainItemPool = (UIItemPool.New)(self.lAvgMainItemPool or UINLevelAvgMain, (self.ui).plotItem)
      if not sectorCfg or not UINSpLevelItemType[sectorCfg.sector_type] then
        self.spItemPool = (UIItemPool.New)(not self.spDict or self.spItemPool or UINLevelSimpleItem, (self.ui).repeatItem)
        local sizeDelta = self:__GenGroupSetRect(pageContent, isFinalPage)
        self:__GenGroupSetStage(pageContent, lastLocals, isFinalPage)
        ;
        ((self.ui).lineList):SetParent(lineHolder)
      end
    end
  end
end

UINLevelMulLineGroup.__GenGroupSetRect = function(self, pageContent, isFinalPage)
  -- function num : 0_3 , upvalues : _ENV
  local extraPadding = (self.ui).padding
  if isFinalPage then
    extraPadding = extraPadding + (self.ui).lastPadding
  end
  local func_arrange = function(arrangeCfg, posIndex)
    -- function num : 0_3_0 , upvalues : _ENV, self
    local size = 0
    for k,v in ipairs(arrangeCfg) do
      local value = (math.abs)((v.pos)[posIndex])
      size = (math.max)(size, value)
    end
    local res = size + (self.ui).storyLineLength + (self.ui).padding
    local parentWidth = ((((self.transform).parent).parent).rect).width
    return (math.max)(res, parentWidth)
  end

  local func_layout = function(arrangeCfg, index, posIndex, defaultValue)
    -- function num : 0_3_1 , upvalues : _ENV, extraPadding
    local lastCfg = arrangeCfg[index]
    local temp = (math.abs)((lastCfg.pos)[posIndex]) + extraPadding
    return defaultValue < temp and temp or defaultValue
  end

  local isVertical = nil
  local width = 0
  local height = 0
  for layoutId,content in pairs(pageContent) do
    local arrangeCfg = (ConfigData.level_arrange)[layoutId]
    if isVertical == nil then
      isVertical = (arrangeCfg[1]).vertical
      if isVertical then
        width = func_arrange(arrangeCfg, 1)
      else
        height = func_arrange(arrangeCfg, 2)
      end
    end
    if isVertical then
      height = func_layout(arrangeCfg, #content, 2, height)
    else
      width = func_layout(arrangeCfg, #content, 1, width)
    end
  end
  self._width = width
  self._height = height
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).layoutElement).preferredWidth = width
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).layoutElement).preferredHeight = height
  local sizeDelta = (Vector2.New)(width, height)
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = sizeDelta
  -- DECOMPILER ERROR at PC72: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).lineList).sizeDelta = sizeDelta
  return sizeDelta
end

UINLevelMulLineGroup.__GenGroupSetStage = function(self, pageContent, lastLocals, isFinalPage)
  -- function num : 0_4 , upvalues : _ENV, eLevelLineType
  local stageLineFunc = function(lineType, startPos, angle, length, isFirstStage, tempItem, lastTab)
    -- function num : 0_4_0 , upvalues : self, _ENV
    local lineItem = (self.levelLineItem):GetOne()
    lineItem:InitLevelLine(lineType, startPos, angle, length)
    local itemConnectedLine = self.itemConnectedLineDic
    if itemConnectedLine == nil then
      itemConnectedLine = {}
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self.itemConnectedLineDic)[tempItem] = itemConnectedLine
    end
    if lastTab == nil then
      error("lastTab is Null")
      return 
    end
    itemConnectedLine[lastTab] = lineItem
  end

  local calculateStageLineFunc = function(lastPos, startPos, isVertical, tab, tempItem, lastTab)
    -- function num : 0_4_1 , upvalues : _ENV, eLevelLineType, stageLineFunc
    local lineType = nil
    local length = (Vector3.Distance)(lastPos, startPos)
    local dirVector = lastPos - startPos
    local angle = (Vector3.Angle)(Vector3.right, dirVector)
    if not isVertical and dirVector.y < 0 then
      angle = angle * -1
    end
    if tab.stageCfg ~= nil and (PlayerDataCenter.sectorStage):IsStageComplete((tab.stageCfg).id) then
      lineType = eLevelLineType.BetweenLevelFull
    else
      if tab.avgCfg ~= nil and (ControllerManager:GetController(ControllerTypeId.AvgPlay)):IsAvgPlayed((tab.avgCfg).id) then
        lineType = eLevelLineType.BetweenLevelFull
      else
        lineType = eLevelLineType.BetweenLevel
      end
    end
    stageLineFunc(lineType, startPos, angle, length, false, tempItem, lastTab)
  end

  ;
  (self.levelItemPool):HideAll()
  ;
  (self.lAvgMainItemPool):HideAll()
  ;
  (self.levelLineItem):HideAll()
  if self.spItemPool then
    (self.spItemPool):HideAll()
  end
  self.itemConnectedLineDic = {}
  self.__itemDic = {}
  local sectorLevelWindow = UIManager:GetWindow(UIWindowTypeID.SectorLevel)
  if sectorLevelWindow == nil then
    return 
  end
  local selectedLvId = sectorLevelWindow:GetSelectedStageId()
  local selectedLAvgMainId = (sectorLevelWindow:GetSelectedLAvgMainId())
  local lastPos = nil
  for layoutId,content in pairs(pageContent) do
    local arrangeCfg = (ConfigData.level_arrange)[layoutId]
    for k,v in ipairs(content) do
      local isVertical = (arrangeCfg[1]).vertical
      local startPos = nil
      local randomSeed = 0
      local tempItem = {levelItem = nil, lAvgMainItem = nil}
      if v.stageCfg ~= nil then
        local stageCfg = v.stageCfg
        local levelItem = nil
        if self:CheckLevelIsSpecial(stageCfg.id) and self.spItemPool then
          levelItem = (self.spItemPool):GetOne()
        else
          levelItem = (self.levelItemPool):GetOne()
        end
        tempItem.levelItem = levelItem
        levelItem:InitSectorLevelItem(stageCfg, arrangeCfg[k], self.levelItemClickEvent, self.resLoader)
        if self.lastEpStateCfg ~= nil then
          if (self.lastEpStateCfg).id == stageCfg.id then
            levelItem:OnClickLevelItem()
            levelItem:LevelItemShowContinue(true)
          else
            levelItem:DisableSelectLevelItem(true)
          end
        end
        if selectedLvId == stageCfg.id then
          levelItem:SeletedLevelItem(true, false)
        end
        startPos = (levelItem.transform).localPosition
        randomSeed = stageCfg.id
        -- DECOMPILER ERROR at PC112: Confused about usage of register: R27 in 'UnsetPending'

        ;
        (self.__itemDic)[stageCfg.id * 10 + 1] = levelItem
        self:SectorLevelTryTipsGuide(levelItem, stageCfg.id, false)
      else
        do
          if v.avgCfg ~= nil then
            local avgCfg = v.avgCfg
            local lAvgMainItem = (self.lAvgMainItemPool):GetOne()
            tempItem.lAvgMainItem = lAvgMainItem
            lAvgMainItem:InitActLAvgMain(avgCfg, arrangeCfg[k], self.lAvgMainClickEvent, self.resLoader)
            startPos = (lAvgMainItem.transform).localPosition
            randomSeed = avgCfg.id
            -- DECOMPILER ERROR at PC140: Confused about usage of register: R27 in 'UnsetPending'

            ;
            (self.__itemDic)[avgCfg.id * 10 + 2] = lAvgMainItem
            if selectedLAvgMainId == avgCfg.id then
              lAvgMainItem:SelectedLAvgMain(true)
            end
            self:SectorLevelTryTipsGuide(lAvgMainItem, avgCfg.id, true)
          else
            do
              error("levelGroupData error")
              -- DECOMPILER ERROR at PC167: Unhandled construct in 'MakeBoolean' P1

              if v.stageCfg and (v.stageCfg).is_special and lastPos ~= nil then
                local lastTab = content[k - 1]
                local centerPos = nil
                if isVertical then
                  centerPos = (Vector3.New)(lastPos.x, startPos.y, startPos.z)
                else
                  centerPos = (Vector3.New)(startPos.x, lastPos.y, startPos.z)
                end
                calculateStageLineFunc(centerPos, startPos, isVertical, v, tempItem, lastTab)
              end
              do
                local angle = 0
                local length, lineType = nil, nil
                do
                  local isFirstStage = k == 1 and lastLocals == nil or lastLocals.locals == nil or #lastLocals.locals == 0
                  if not isVertical or not 90 then
                    angle = not isFirstStage or 180
                  end
                  length = (self.ui).padding
                  lineType = eLevelLineType.BetweenLevelFull
                  lastPos = (Vector3.New)(startPos.x, startPos.y, startPos.z)
                  if k == 1 then
                    for _,lastInfo in ipairs(lastLocals.locals) do
                      local lastLocal = lastInfo.pos
                      local lastTab = lastInfo.tab
                      if lastTab.connecId == v.connecId or (table.contain)(v.preStages, lastTab.connecId) then
                        lastPos = (Vector3.New)(startPos.x, startPos.y, startPos.z)
                        if isVertical then
                          lastPos.x = lastLocal[1]
                          lastPos.y = ((self.ui).layoutElement).preferredHeight / 2 + (self.ui).padding + (lastLocals.maxDistance - lastLocal[2])
                        else
                          lastPos.x = -((self.ui).layoutElement).preferredWidth / 2 - (self.ui).padding - (lastLocals.maxDistance - lastLocal[1])
                          lastPos.y = lastLocal[2]
                        end
                        calculateStageLineFunc(lastPos, startPos, isVertical, v, tempItem, lastTab)
                      end
                    end
                  else
                    local lastTab = content[k - 1]
                    calculateStageLineFunc(lastPos, startPos, isVertical, v, tempItem, lastTab)
                  end
                  lastPos = startPos
                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC308: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
    end
  end
  -- DECOMPILER ERROR: 12 unprocessed JMP targets
end

UINLevelMulLineGroup.CheckLevelIsSpecial = function(self, stage)
  -- function num : 0_5
  if self.spDict and (self.spDict)[stage] then
    return true
  end
  return false
end

UINLevelMulLineGroup.SetAllSpecialListDic = function(self, dic)
  -- function num : 0_6
  self.spDict = dic
end

UINLevelMulLineGroup.DesyroyLastTipsGuide = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.lastSectorTipsGuide ~= nil then
    for k,v in pairs(self.lastSectorTipsGuide) do
      DestroyUnityObject(v.gameObject)
    end
    self.lastSectorTipsGuide = nil
  end
end

UINLevelMulLineGroup.SectorLevelTryTipsGuide = function(self, item, id, isAvg)
  -- function num : 0_8 , upvalues : _ENV
  if (self.sectorLevelTipsGuides)[isAvg] ~= nil then
    local tipsGuideDic = (self.sectorLevelTipsGuides)[isAvg]
    if tipsGuideDic[id] ~= nil then
      local show_dir = tipsGuideDic[id]
      do
        (self.resLoader):LoadABAssetAsync(PathConsts:GetUIPrefabPath(GuideUtil.TipsGuidePrefabName), function(guidePrefab)
    -- function num : 0_8_0 , upvalues : _ENV, item, show_dir, self
    local guideItem = (GuideUtil.ShowTipsGuide)(item.transform, guidePrefab, show_dir)
    if not self.lastSectorTipsGuide then
      self.lastSectorTipsGuide = {}
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.lastSectorTipsGuide)[item] = guideItem
    end
  end
)
      end
    end
  end
end

UINLevelMulLineGroup.SectorLevelClearTipsGuide = function(self, item)
  -- function num : 0_9 , upvalues : _ENV
  if IsNull(item.gameObject) then
    return 
  end
  local tipsGuideNodeName = (GuideUtil.GetTipsGuideNodeName)((item.gameObject).name)
  local tipsGuideNode = (item.transform):Find(tipsGuideNodeName)
  if not IsNull(tipsGuideNode) then
    DestroyUnityObject(tipsGuideNode.gameObject)
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

  if self.lastSectorTipsGuide ~= nil then
    (self.lastSectorTipsGuide)[item] = nil
  end
end

UINLevelMulLineGroup.GetLevelItemByIndex = function(self, id, isState)
  -- function num : 0_10
  return (self.__itemDic)[id * 10 + (isState and 1 or 2)]
end

UINLevelMulLineGroup.__GetDecorateLineAngle = function(self, isVertical, isFirstStage, isLastStage, lineIndex, isLeft)
  -- function num : 0_11 , upvalues : _ENV
  local angle = nil
  local offset = isVertical and 0 or 90
  if isFirstStage then
    if lineIndex == 1 then
      angle = (math.random)((self.ui).range_start1A + offset, (self.ui).range_start1B + offset)
    else
      angle = (math.random)((self.ui).range_start2A + offset, (self.ui).range_start2B + offset)
    end
  else
    if isLastStage then
      if lineIndex == 1 then
        angle = (math.random)((self.ui).range_end1A + offset, (self.ui).range_end1B + offset)
      else
        angle = (math.random)((self.ui).range_end2A + offset, (self.ui).range_end2B + offset)
      end
    else
      if isLeft then
        if lineIndex == 1 then
          angle = (math.random)((self.ui).range_left1A + offset, (self.ui).range_left1B + offset)
        else
          angle = (math.random)((self.ui).range_left2A + offset, (self.ui).range_left2B + offset)
        end
      else
        if lineIndex == 1 then
          angle = (math.random)((self.ui).range_right1A + offset, (self.ui).range_right1B + offset)
        else
          angle = (math.random)((self.ui).range_right2A + offset, (self.ui).range_right2B + offset)
        end
      end
    end
  end
  return angle
end

UINLevelMulLineGroup.RefreshUncompletedEp = function(self, lastEpStateCfg)
  -- function num : 0_12 , upvalues : _ENV
  self.lastEpStateCfg = lastEpStateCfg
  for k,levelItem in ipairs((self.levelItemPool).listItem) do
    if lastEpStateCfg == nil then
      levelItem:DisableSelectLevelItem(false)
      levelItem:LevelItemShowContinue(false)
    else
      if lastEpStateCfg.num == (levelItem:GetLevelStageData()).num then
        levelItem:OnClickLevelItem()
        levelItem:LevelItemShowContinue(true)
      else
        levelItem:DisableSelectLevelItem(true)
      end
    end
  end
  if not self.spItemPool then
    return 
  end
  for k,levelItem in ipairs((self.spItemPool).listItem) do
    if lastEpStateCfg == nil then
      levelItem:DisableSelectLevelItem(false)
      levelItem:LevelItemShowContinue(false)
    else
      if lastEpStateCfg.num == (levelItem:GetLevelStageData()).num then
        levelItem:OnClickLevelItem()
        levelItem:LevelItemShowContinue(true)
      else
        levelItem:DisableSelectLevelItem(true)
      end
    end
  end
end

UINLevelMulLineGroup.RefreshLevelItemState = function(self)
  -- function num : 0_13 , upvalues : _ENV
  for k,v in ipairs((self.levelItemPool).listItem) do
    v:RefreshLevelState()
  end
  for k,v in ipairs((self.lAvgMainItemPool).listItem) do
    v:RefreshLAvgMainState()
  end
  if self.spItemPool then
    for k,v in ipairs((self.spItemPool).listItem) do
      v:RefreshLevelState()
    end
  end
  do
    self:RefreshLevelConnectLineState()
  end
end

UINLevelMulLineGroup.RefreshLevelConnectLineState = function(self)
  -- function num : 0_14 , upvalues : _ENV, eLevelLineType
  for k,lineItem in pairs(self.itemConnectedLineDic) do
    local isComplete = false
    if k.levelItem ~= nil then
      local stageCfg = (k.levelItem):GetLevelStageData()
      isComplete = (PlayerDataCenter.sectorStage):IsStageComplete(stageCfg.id)
    else
      do
        if k.lAvgMainItem ~= nil then
          local avgCfg = (k.lAvgMainItem):GetLAvgMainCfg()
          local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
          isComplete = avgPlayCtrl:IsAvgPlayed(avgCfg.id)
        end
        do
          if not isComplete then
            for i,v in pairs(lineItem) do
              v:RefreshLevelLineState(eLevelLineType.BetweenLevel)
            end
          else
            do
              for i,v in pairs(lineItem) do
                local lastComplete = isComplete
                if (v.tab).stageCfg ~= nil then
                  lastComplete = (PlayerDataCenter.sectorStage):IsStageComplete(((v.tab).stageCfg).id)
                end
                local lineType = lastComplete and eLevelLineType.BetweenLevelFull or eLevelLineType.BetweenLevel
                v:RefreshLevelLineState(lineType)
              end
              do
                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
end

UINLevelMulLineGroup.OnReturnLevelGroup = function(self)
  -- function num : 0_15 , upvalues : _ENV
  ((self.ui).lineList):SetParent((self.ui).lineRoot)
  for k,v in ipairs((self.lAvgMainItemPool).listItem) do
    v:OnReturnLAvgMainItem()
  end
end

UINLevelMulLineGroup.GetGroupSizeDelta = function(self)
  -- function num : 0_16
  return (self.transform).sizeDelta
end

UINLevelMulLineGroup.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (self.levelItemPool):DeleteAll()
  ;
  (self.lAvgMainItemPool):DeleteAll()
  ;
  (self.levelLineItem):DeleteAll()
  if self.spItemPool then
    (self.spItemPool):DeleteAll()
  end
  ;
  (base.OnDelete)(self)
end

return UINLevelMulLineGroup

