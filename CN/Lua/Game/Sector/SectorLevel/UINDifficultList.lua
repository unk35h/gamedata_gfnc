-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDifficultList = class("UINDifficultList", UIBaseNode)
local base = UIBaseNode
local UINInfinityLevelCanvas = require("Game.Sector.SectorLevel.UINInfinityLevelCanvas")
local UINActSummerLvLeftInfo = require("Game.ActivitySummer.UI.UINActSummerLvLeftInfo")
local UINActWinter23ChapterButtonGroup = require("Game.ActivityWinter23.UI.Sector.UINActWinter23ChapterButtonGroup")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local activityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local LevelCanvasClassType = {
[1] = {prefab = "UI_SectorLevelMap", CanvasClass = require("Game.Sector.SectorLevel.UINDiffLevelCanvas")}
, 
[2] = {prefab = "UI_ActSum21LvMap", CanvasClass = require("Game.ActivitySummer.UI.Sector.UINDiffLevelMulLineActSum21Canvas")}
, 
[3] = {prefab = "UI_CharDunMap", CanvasClass = require("Game.Sector.SectorLevel.UINCharDunLevelCanvas")}
, 
[4] = {prefab = "UI_SectorLevelMap", CanvasClass = require("Game.Sector.SectorLevel.UINDiffLevelCanvas")}
, 
[5] = {prefab = "UI_Winter23ChapterMap", CanvasClass = require("Game.ActivityWinter23.UI.Sector.UINDiffLevelMulLineActWinter23Canvas")}
}
local CS_Edge = ((CS.UnityEngine).RectTransform).Edge
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_UIMnager = (CS.UIManager).Instance
local difficultyLvBgNameCfg = {[1] = "pic_big", [2] = "hard_pic", [(ConfigData.sector_stage).difficultyCount + 1] = "endless_pic"}
UINDifficultList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.isShowingInfinity = false
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__onChangeDiffComplete = BindCallback(self, self.OnChangeLevelDifficultyComplete)
  self.__sectorLevelTipsGuides = {}
  self.__OnMainAvgStateChange = BindCallback(self, self._OnMainAvgStateChange)
  self.__OnMainLevelStateChange = BindCallback(self, self._OnMainLevelStateChange)
  self.__OnListenSectorRunEnd = BindCallback(self, self.OnListenSectorRunEnd)
  MsgCenter:AddListener(eMsgEventId.SectorActivityRunEnd, self.__OnListenSectorRunEnd)
  self.__OnListenHeroGrowRunEnd = BindCallback(self, self.OnListenHeroGrowRunEnd)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityRunEnd, self.__OnListenHeroGrowRunEnd)
  self._OnChallengeTaskCompleteFunc = BindCallback(self, self._OnChallengeTaskComplete)
  MsgCenter:AddListener(eMsgEventId.OnChallengeTaskComplete, self._OnChallengeTaskCompleteFunc)
end

UINDifficultList.PreSetSectorExtraDungeon = function(self, sectorId, dungeonDataDic, clickDungeonItemEvent, blueReddotFunc)
  -- function num : 0_1
  self._dungeonReplyOnSectorId = sectorId
  self._extradungeonDataDic = dungeonDataDic
  self._clickDungeonEvent = clickDungeonItemEvent
  self._dungeonBlueReddotFunc = blueReddotFunc
end

UINDifficultList.PreSetSectorSpecialState = function(self, state)
  -- function num : 0_2
  self.levelState = state
end

UINDifficultList.PreSetSectorSpecialLevelList = function(self, specialLevelList)
  -- function num : 0_3
  self.specialLevelList = specialLevelList
end

UINDifficultList.InitDifficeltLevel = function(self, resLoader, sectorId, autoStateCfg, isUnCompleteEp, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, clickBackFunc)
  -- function num : 0_4 , upvalues : _ENV
  self.resLoader = resLoader
  self.sectorId = sectorId
  if isUnCompleteEp then
    self.lastEpStateCfg = autoStateCfg
  else
    self.lastEpStateCfg = nil
  end
  self.levelItemClickEvent = levelItemClickEvent
  self.levelAvgMainClickEvent = levelAvgMainClickEvent
  self.lAvgSubClickEvent = lAvgSubClickEvent
  self.clickBackFunc = clickBackFunc
  self:CheckShowExtraMount()
  local lastSelectDiff = nil
  if autoStateCfg ~= nil then
    lastSelectDiff = autoStateCfg.difficulty
  else
    lastSelectDiff = (PlayerDataCenter.sectorStage):GetSelectDifficult(sectorId)
  end
  if lastSelectDiff == (ConfigData.sector_stage).difficultyCount + 1 then
    self.infinityLevelCanvas = self:GetInfinityLevelCanvasItem()
    ;
    (self.infinityLevelCanvas):InitInfinityLevelCanvas(sectorId, autoStateCfg, isUnCompleteEp, function()
    -- function num : 0_4_0 , upvalues : self
    if self.diffLevelCanva ~= nil then
      (self.diffLevelCanvas):Hide()
    end
  end
, self.resLoader)
    self.isShowingInfinity = true
  else
    if self.diffLevelCanvas == nil then
      self.diffLevelCanvas = self:GetDiffLevelCanvasItem(lastSelectDiff)
    end
    ;
    (self.diffLevelCanvas):SetBackground(self:GetBgTexture(lastSelectDiff))
    if (self.diffLevelCanvas).SetSpecialLevelState then
      (self.diffLevelCanvas):SetSpecialLevelState(self.levelState)
    end
    if self.specialLevelList then
      (self.diffLevelCanvas):SetSpecialLevelList(self.specialLevelList)
    end
    ;
    (self.diffLevelCanvas):InitDiffLevelCanvas(sectorId, autoStateCfg, isUnCompleteEp, lastSelectDiff, self.levelItemClickEvent, self.levelAvgMainClickEvent, self.lAvgSubClickEvent, self.__onChangeDiffComplete, self.resLoader, self.__sectorLevelTipsGuides, self.clickBackFunc)
    if sectorId == self._dungeonReplyOnSectorId then
      (self.diffLevelCanvas):SetDungeonListInSector(self._extradungeonDataDic, self._clickDungeonEvent, self._dungeonBlueReddotFunc)
    end
  end
  MsgCenter:AddListener(eMsgEventId.OnMainLevelStateChange, self.__OnMainLevelStateChange)
  MsgCenter:AddListener(eMsgEventId.OnMainAvgStateChange, self.__OnMainAvgStateChange)
end

UINDifficultList._OnMainLevelStateChange = function(self, sectorId, difficulty, stageId)
  -- function num : 0_5 , upvalues : _ENV
  if sectorId == self.sectorId and difficulty == (PlayerDataCenter.sectorStage):GetSelectDifficult(sectorId) then
    if (PlayerDataCenter.sectorStage):IsStageUnlock(stageId) then
      local show = not (PlayerDataCenter.sectorStage):IsStageComplete(stageId)
    end
    ;
    (self.diffLevelCanvas):SetSectorStageItemBlueDot(stageId, show)
  end
end

UINDifficultList._OnMainAvgStateChange = function(self, sectorId, difficulty, avgId)
  -- function num : 0_6 , upvalues : _ENV
  if sectorId == self.sectorId and difficulty == (PlayerDataCenter.sectorStage):GetSelectDifficult(sectorId) then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    if avgPlayCtrl:IsAvgUnlock(avgId) then
      local show = not avgPlayCtrl:IsAvgPlayed(avgId)
    end
    ;
    (self.diffLevelCanvas):SetSectorLAvgMainItemBlueDot(avgId, show)
  end
end

UINDifficultList.GetDiffLevelCanvasItem = function(self, difficulty)
  -- function num : 0_7 , upvalues : _ENV, LevelCanvasClassType
  local sectorType = ((ConfigData.sector)[self.sectorId]).sector_type
  local DiffLevelClassCfg = LevelCanvasClassType[sectorType or 0]
  if DiffLevelClassCfg == nil then
    DiffLevelClassCfg = LevelCanvasClassType[1]
  end
  local prefab = (self.resLoader):LoadABAsset(PathConsts:GetUIPrefabPath(DiffLevelClassCfg.prefab))
  local go = prefab:Instantiate()
  local rectTransform = go.transform
  rectTransform:SetParent(self.transform)
  rectTransform.localScale = (Vector3.New)(1, 1, 1)
  rectTransform:SetAsLastSibling()
  rectTransform.localPosition = (Vector3.New)(0, 0, 0)
  rectTransform.offsetMax = (Vector2.New)(0, 0)
  rectTransform.offsetMin = (Vector2.New)(0, 0)
  local item = ((DiffLevelClassCfg.CanvasClass).New)()
  item:Init(go)
  self:ResetLevelCanvasSize(item)
  return item
end

UINDifficultList.GetInfinityLevelCanvasItem = function(self)
  -- function num : 0_8 , upvalues : _ENV, UINInfinityLevelCanvas
  if self.infinityLevelCanvas ~= nil then
    return self.infinityLevelCanvas
  end
  local item = nil
  local prefab = (self.resLoader):LoadABAsset(PathConsts:GetUIPrefabPath("UI_SectorLevelInfinityMap"))
  local go = prefab:Instantiate()
  local rectTransform = go.transform
  rectTransform:SetParent(self.transform)
  rectTransform.localScale = (Vector3.New)(1, 1, 1)
  rectTransform:SetAsLastSibling()
  rectTransform.localPosition = (Vector3.New)(0, 0, 0)
  rectTransform.offsetMax = (Vector2.New)(0, 0)
  rectTransform.offsetMin = (Vector2.New)(0, 0)
  item = (UINInfinityLevelCanvas.New)()
  item:Init(go)
  local difficulty = (ConfigData.sector_stage).difficultyCount + 1
  item:SetBackground(self:GetBgTexture(difficulty))
  return item
end

UINDifficultList.GetBgTexture = function(self, difficulty)
  -- function num : 0_9 , upvalues : _ENV, difficultyLvBgNameCfg
  if self.bgTextureCacheDic == nil then
    self.bgTextureCacheDic = {}
  end
  local sectorCfg = (ConfigData.sector)[self.sectorId]
  if sectorCfg == nil then
    return nil
  end
  local difficultyBgName = difficultyLvBgNameCfg[difficulty] or difficultyLvBgNameCfg[1]
  local textureName = sectorCfg[difficultyBgName]
  if textureName == nil then
    return nil
  end
  local bgTexture = (self.bgTextureCacheDic)[textureName]
  do
    if bgTexture == nil then
      local path = PathConsts:GetSectorBackgroundPath(textureName)
      bgTexture = (self.resLoader):LoadABAsset(path)
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.bgTextureCacheDic)[textureName] = bgTexture
    end
    return bgTexture
  end
end

UINDifficultList.ChangeLevelDifficulty = function(self, difficulty, sectorId)
  -- function num : 0_10 , upvalues : _ENV
  if self.diffLevelCanvas and (self.diffLevelCanvas).SetSpecialLevelState then
    (self.diffLevelCanvas):SetSpecialLevelState(self.levelState)
  end
  local lastSelectDiff = (PlayerDataCenter.sectorStage):GetSelectDifficult(self.sectorId)
  if self.diffLevelCanvas and lastSelectDiff == difficulty and sectorId == self.sectorId and self.specialLevelList then
    (self.diffLevelCanvas):ResetLevelGroupDataBySpecialLevelList(self.specialLevelList)
    if (self.diffLevelCanvas).PlayDiffLevelCanvasSwitchTween then
      if (self.diffLevelCanvas).SetStopTweenCompleteEvent then
        (self.diffLevelCanvas):SetStopTweenCompleteEvent(true)
      end
      ;
      (self.diffLevelCanvas):PlayDiffLevelCanvasSwitchTween(false)
    end
    return 
  end
  if lastSelectDiff == difficulty and sectorId == self.sectorId then
    return 
  end
  if sectorId ~= nil then
    self.sectorId = sectorId
    if (PlayerDataCenter.sectorStage):GetSelectSectorId() ~= sectorId then
      (PlayerDataCenter.sectorStage):SetSelectSectorId(sectorId)
    end
  end
  local isUpTween = lastSelectDiff < difficulty
  ;
  (PlayerDataCenter.sectorStage):SetSelectDifficult(difficulty)
  if difficulty == (ConfigData.sector_stage).difficultyCount + 1 then
    self.infinityLevelCanvas = self:GetInfinityLevelCanvasItem()
    ;
    (self.infinityLevelCanvas):Show()
    ;
    (self.infinityLevelCanvas):InitInfinityLevelCanvas(self.sectorId, self.lastEpStateCfg, true, function()
    -- function num : 0_10_0 , upvalues : self
    if self.diffLevelCanva ~= nil then
      (self.diffLevelCanvas):Hide()
    end
  end
)
    if self.diffLevelCanvas ~= nil then
      (self.diffLevelCanvas):PlayDiffLevelCanvasSwitchTween(true)
    end
    self.isShowingInfinity = true
    return 
  else
    self.isShowingInfinity = false
  end
  if self.newDiffLevelCanvas == nil then
    self.newDiffLevelCanvas = self:GetDiffLevelCanvasItem(difficulty)
  end
  ;
  (self.newDiffLevelCanvas):SetBackground(self:GetBgTexture(difficulty))
  local lastEpStateCfg = nil
  if self.lastEpStateCfg ~= nil and (self.lastEpStateCfg).sector == self.sectorId and (self.lastEpStateCfg).difficulty == difficulty then
    lastEpStateCfg = self.lastEpStateCfg
  end
  ;
  (self.newDiffLevelCanvas):Show()
  if (self.newDiffLevelCanvas).SetSpecialLevelState then
    (self.newDiffLevelCanvas):SetSpecialLevelState(self.levelState)
  end
  if self.specialLevelList then
    (self.newDiffLevelCanvas):SetSpecialLevelList(self.specialLevelList)
  end
  ;
  (self.newDiffLevelCanvas):InitDiffLevelCanvas(self.sectorId, lastEpStateCfg, true, difficulty, self.levelItemClickEvent, self.levelAvgMainClickEvent, self.lAvgSubClickEvent, self.__onChangeDiffComplete, self.resLoader, self.__sectorLevelTipsGuides, self.clickBackFunc)
  if self.sectorId == self._dungeonReplyOnSectorId then
    (self.newDiffLevelCanvas):SetDungeonListInSector(self._extradungeonDataDic, self._clickDungeonEvent, self._dungeonBlueReddotFunc)
  end
  if isUpTween and (self.diffLevelCanvas).PlayDiffLevelCanvasSwitchTween then
    (self.diffLevelCanvas):PlayDiffLevelCanvasSwitchTween(isUpTween)
  end
  if (self.newDiffLevelCanvas).PlayDiffLevelCanvasSwitchTween then
    (self.newDiffLevelCanvas):PlayDiffLevelCanvasSwitchTween(isUpTween)
  end
  -- DECOMPILER ERROR: 11 unprocessed JMP targets
end

UINDifficultList.OnChangeLevelDifficultyComplete = function(self)
  -- function num : 0_11
  self.diffLevelCanvas = self.newDiffLevelCanvas
  if not self.isShowingInfinity and self.infinityLevelCanvas ~= nil then
    (self.infinityLevelCanvas):Hide()
  end
  if self.newDiffLevelCanvas ~= nil then
    (self.newDiffLevelCanvas):Hide()
  end
end

UINDifficultList.PlayMoveLeftTween = function(self, isLeft, offset, duration)
  -- function num : 0_12 , upvalues : _ENV, cs_DoTween
  if self.activityType == nil then
    return 
  end
  if self.__moveLeftSeq == nil then
    local endValue = (Vector2.New)(1 - offset / (((self.transform).rect).width + (self.ui).moveLeftTwenOffset), 1)
    local seq = (cs_DoTween.Sequence)()
    seq:SetAutoKill(false)
    seq:Append((self.transform):DOAnchorMax(endValue, duration))
    self:TrySetExtraMount(seq, isLeft, duration)
    self.__moveLeftSeq = seq
    self.__moveLeftSeqDuration = duration
  end
  do
    if isLeft then
      (self.__moveLeftSeq):PlayForward()
    else
      ;
      (self.__moveLeftSeq):PlayBackwards()
      ;
      (self.diffLevelCanvas):PlayDiffLevelContentTween(self.__moveLeftSeqDuration)
    end
  end
end

UINDifficultList.PlayMoveLongLeftTween = function(self, isLeft, offset, duration)
  -- function num : 0_13 , upvalues : activityFrameEnum, _ENV, cs_DoTween
  if self.activityType == nil then
    return 
  end
  if self.activityType == (activityFrameEnum.eActivityType).Winter23 then
    return 
  end
  if self.__moveLeftLongSeq == nil then
    offset = offset * 2
    local endValue = (Vector2.New)(1 - offset / (((self.transform).rect).width + (self.ui).moveLeftTwenOffset), 1)
    local seq = (cs_DoTween.Sequence)()
    seq:SetAutoKill(false)
    seq:Append((self.transform):DOAnchorMax(endValue, duration))
    self:TrySetExtraMount(seq, isLeft, duration)
    self.__moveLeftLongSeq = seq
    self.__moveLeftLongSeqDuration = duration
  end
  do
    if isLeft then
      (self.__moveLeftLongSeq):PlayForward()
    else
      ;
      (self.__moveLeftLongSeq):PlayBackwards()
      ;
      (self.diffLevelCanvas):PlayDiffLevelContentTween(self.__moveLeftLongSeqDuration)
    end
  end
end

UINDifficultList.TrySetExtraMount = function(self, seq, isLeft, duration)
  -- function num : 0_14 , upvalues : cs_UIMnager, _ENV
  if self.extraMount == nil or self._extraMountWidth == nil then
    return 
  end
  local n = (cs_UIMnager.BackgroundStretchSize).x * (cs_UIMnager.CurNotchValue / 100)
  local value = isLeft and -(self._extraMountWidth + n) / ((self.transform).rect).width or 0
  seq:Join((self.transform):DOAnchorMin((Vector2.New)(value, 0), duration))
end

UINDifficultList.RefreshUncompletedEp = function(self, lastEpStateCfg)
  -- function num : 0_15
  self.lastEpStateCfg = lastEpStateCfg
  if self.isShowingInfinity then
    (self.infinityLevelCanvas):RefreshUncompletedEp(lastEpStateCfg)
  else
    ;
    (self.diffLevelCanvas):RefreshUncompletedEp(lastEpStateCfg)
  end
end

UINDifficultList.RefreshCurDiffLevelState = function(self)
  -- function num : 0_16
  if self.diffLevelCanvas ~= nil then
    (self.diffLevelCanvas):RefreshLevelState()
  end
end

UINDifficultList.LocationSectorStageItem = function(self, id, isAvg)
  -- function num : 0_17
  if self.diffLevelCanvas == nil then
    return nil, nil
  end
  return (self.diffLevelCanvas):LocationSectorStageItem(id, isAvg)
end

UINDifficultList.GetSectorStageItem = function(self, stageId)
  -- function num : 0_18
  if self.diffLevelCanvas == nil then
    return nil
  end
  return (self.diffLevelCanvas):GetSectorStageItem(stageId)
end

UINDifficultList.GetSectorLAvgMainItem = function(self, avgId)
  -- function num : 0_19
  if self.diffLevelCanvas == nil then
    return nil
  end
  return (self.diffLevelCanvas):GetSectorLAvgMainItem(avgId)
end

UINDifficultList.GetSectorDungeonItem = function(self, dungeonId)
  -- function num : 0_20
  if self.diffLevelCanvas == nil then
    return nil
  end
  return (self.diffLevelCanvas):GetSectorDungeonItem(dungeonId)
end

UINDifficultList.SetSectorStageItemTipsGuide = function(self, id, isAvg, show_dir)
  -- function num : 0_21
  local tipsGuideDic = (self.__sectorLevelTipsGuides)[isAvg]
  if tipsGuideDic == nil then
    tipsGuideDic = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.__sectorLevelTipsGuides)[isAvg] = tipsGuideDic
  end
  tipsGuideDic[id] = show_dir
  local stageItem, levelGroup = self:LocationSectorStageItem(id, isAvg)
  if stageItem ~= nil and levelGroup ~= nil then
    levelGroup:SectorLevelTryTipsGuide(stageItem, id, isAvg)
  end
end

UINDifficultList.ClearSectorStageItemTipsGuide = function(self, id, isAvg)
  -- function num : 0_22
  local tipsGuideDic = (self.__sectorLevelTipsGuides)[isAvg]
  if tipsGuideDic == nil then
    return 
  end
  tipsGuideDic[id] = nil
  local stageItem, levelGroup = self:LocationSectorStageItem(id, isAvg)
  if stageItem ~= nil and levelGroup ~= nil then
    levelGroup:SectorLevelClearTipsGuide(stageItem)
  end
end

UINDifficultList.CheckShowExtraMount = function(self)
  -- function num : 0_23 , upvalues : _ENV, activityFrameEnum
  local actType, actId, actData = (PlayerDataCenter.sectorEntranceHandler):GetActivityDataBySectorId(self.sectorId)
  if actData and actType == (activityFrameEnum.eActivityType).SectorI then
    local _, activityData, inTime = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorId(self.sectorId)
    self:CheckSectorIShowExtraMount(actId, activityData, inTime)
  else
    do
      if actData and actType == (activityFrameEnum.eActivityType).Winter23 then
        local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
        local activityData = win23Ctrl:GetWinter23DataByActId(actId)
        self:CheckWinterShowExtraMount(actId, activityData, not actData:IsActivityRunningTimeout(), win23Ctrl)
      end
      do
        self.activityType = actType
      end
    end
  end
end

UINDifficultList.CheckSectorIShowExtraMount = function(self, actId, activityData, inTime)
  -- function num : 0_24 , upvalues : _ENV, UINActSummerLvLeftInfo, SectorStageDetailHelper, CS_Edge
  local isHasLeftInfo = not inTime or not activityData:IsActivityRunning() or (activityData:GetSectorICfg()).rechallenge_stage ~= self.sectorId
  if not isHasLeftInfo then
    self._extraMountAnchorType = nil
    self._extraMountWidth = 0
    if self.extraMount ~= nil then
      (self.extraMount):Delete()
      self.extraMount = nil
      self:RecoverCanvasSize()
    end
    return 
  end
  if self.extraMount ~= nil then
    return 
  end
  self._extraMountAnchorType = nil
  self._extraMountWidth = 0
  local prefab = (self.resLoader):LoadABAsset(PathConsts:GetUIPrefabPath("UI_ActSum21LvLeftInfo"))
  local go = prefab:Instantiate(self.transform)
  self.extraMount = (UINActSummerLvLeftInfo.New)()
  ;
  (self.extraMount):Init(go)
  ;
  (self.extraMount):InittSummerLvLeftInfo(activityData, self.sectorId, function(sectroId)
    -- function num : 0_24_0 , upvalues : SectorStageDetailHelper, self
    if not (SectorStageDetailHelper.IsSectorNoCollide)(sectroId, true) then
      return 
    end
    if self.clickBackFunc ~= nil then
      (self.clickBackFunc)()
    end
    self:ChangeLevelDifficulty(1, sectroId)
    ;
    (self.extraMount):RefreshSectorId(sectroId)
    ;
    ((self.extraMount).transform):SetAsLastSibling()
  end
)
  ;
  ((self.extraMount).transform):SetAsLastSibling()
  if (((self.extraMount).transform).anchorMin).x == 0 and (((self.extraMount).transform).anchorMax).x == 0 then
    self._extraMountAnchorType = CS_Edge.Left
  elseif (((self.extraMount).transform).anchorMin).x == 1 and (((self.extraMount).transform).anchorMax).x == 1 then
    self._extraMountAnchorType = CS_Edge.Right
  end
  self._extraMountWidth = (((self.extraMount).transform).sizeDelta).x
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINDifficultList.CheckWinterShowExtraMount = function(self, actId, activityData, inTime, win23Ctrl)
  -- function num : 0_25 , upvalues : _ENV, UINActWinter23ChapterButtonGroup, SectorStageDetailHelper
  local prefab = (self.resLoader):LoadABAsset(PathConsts:GetUIPrefabPath("UI_Winter23ChapterButtonGroup"))
  local parent = (UIManager:GetWindow(UIWindowTypeID.SectorLevel)):GetSectorInfoNode()
  local go = prefab:Instantiate(parent)
  parent:SetActive(true)
  self.extraMount = (UINActWinter23ChapterButtonGroup.New)()
  ;
  (self.extraMount):Init(go)
  local chapterId = win23Ctrl and win23Ctrl:GetNowChapterId() or 1
  ;
  (self.extraMount):InitWinter23ChapterButtonGroup(activityData, self.sectorId, chapterId, self.levelState, function(sectroId)
    -- function num : 0_25_0 , upvalues : SectorStageDetailHelper, self
    if not (SectorStageDetailHelper.IsSectorNoCollide)(sectroId, true) then
      return 
    end
    if self.clickBackFunc ~= nil then
      (self.clickBackFunc)()
    end
    self:ChangeLevelDifficulty(1, sectroId)
    ;
    (self.extraMount):RefreshSectorId(sectroId)
    ;
    ((self.extraMount).transform):SetAsLastSibling()
  end
, nil, self.resLoader)
  ;
  ((self.extraMount).transform):SetAsLastSibling()
end

UINDifficultList.ResetLevelCanvasSize = function(self, levelCanvas)
  -- function num : 0_26 , upvalues : CS_Edge, _ENV
  if self.extraMount ~= nil then
    ((self.extraMount).transform):SetAsLastSibling()
  end
  if self._extraMountAnchorType == nil then
    return 
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  if self._extraMountAnchorType == CS_Edge.Left then
    (levelCanvas.transform).offsetMin = (Vector2.New)(self._extraMountWidth, 0)
  else
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

    if self._extraMountAnchorType == CS_Edge.Right then
      (levelCanvas.transform).offsetMax = (Vector2.New)(-self._extraMountWidth, 0)
    end
  end
end

UINDifficultList.RecoverCanvasSize = function(self)
  -- function num : 0_27 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  if self.diffLevelCanvas ~= nil then
    ((self.diffLevelCanvas).transform).offsetMin = (Vector2.New)(0, 0)
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  if self.newDiffLevelCanvas ~= nil then
    ((self.newDiffLevelCanvas).transform).offsetMax = (Vector2.New)(0, 0)
  end
end

UINDifficultList.OnListenSectorRunEnd = function(self, actId)
  -- function num : 0_28 , upvalues : _ENV
  local id, data, inTime = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorId(self.sectorId)
  if id ~= actId then
    return 
  end
  if self.sectorId == (data:GetSectorICfg()).hard_stage then
    self:CheckShowExtraMount()
    local detailUI = UIManager:GetWindow(UIWindowTypeID.SectorLevelDetail)
    if detailUI ~= nil then
      detailUI:RefreshDtailNormalNode()
    end
    return 
  end
  do
    ;
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector, false)
  end
end

UINDifficultList.OnListenHeroGrowRunEnd = function(self, actId)
  -- function num : 0_29 , upvalues : _ENV
  local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow)
  do
    if heroGrowCtrl ~= nil then
      local id, isChallenge, canFight = heroGrowCtrl:IsHeroGrowChallengeSector(self.sectorId)
      if id == nil or canFight then
        return 
      end
    end
    ;
    (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.Sector, false)
  end
end

UINDifficultList._OnChallengeTaskComplete = function(self, stageId)
  -- function num : 0_30
  local stageItem = self:GetSectorStageItem(stageId)
  if stageItem == nil then
    return 
  end
  stageItem:UpdLvItemChallengeTask()
end

UINDifficultList.OnDelete = function(self)
  -- function num : 0_31 , upvalues : _ENV, base
  if self.__moveLeftSeq ~= nil then
    (self.__moveLeftSeq):Kill()
    self.__moveLeftSeq = nil
  end
  if self.__moveLeftLongSeq ~= nil then
    (self.__moveLeftLongSeq):Kill()
    self.__moveLeftLongSeq = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.OnMainAvgStateChange, self.__OnMainAvgStateChange)
  MsgCenter:RemoveListener(eMsgEventId.OnMainLevelStateChange, self.__OnMainLevelStateChange)
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityRunEnd, self.__OnListenSectorRunEnd)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityRunEnd, self.__OnListenHeroGrowRunEnd)
  MsgCenter:RemoveListener(eMsgEventId.OnChallengeTaskComplete, self._OnChallengeTaskCompleteFunc)
  if self.infinityLevelCanvas ~= nil then
    (self.infinityLevelCanvas):Delete()
  end
  if self.diffLevelCanvas ~= nil then
    (self.diffLevelCanvas):Delete()
  end
  if self.newDiffLevelCanvas ~= nil then
    (self.newDiffLevelCanvas):Delete()
  end
  if self.extraMount ~= nil then
    (self.extraMount):Delete()
    self.extraMount = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINDifficultList

