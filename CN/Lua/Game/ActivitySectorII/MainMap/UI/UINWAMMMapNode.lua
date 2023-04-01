-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWAMMMapNode = class("UINWAMMMapNode", UIBaseNode)
local base = UIBaseNode
local MapScaleLimit = {max = 3, min = 1}
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_Material = (CS.UnityEngine).Material
local cs_UIMnager = (CS.UIManager).Instance
local cs_Tweening = (CS.DG).Tweening
local cs_DoTween = cs_Tweening.DOTween
local UINWAMMMapLevelItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLevelItem")
local UINWAMMMapLevelPointItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLevelPointItem")
local UINWAMMMapLevelSelectItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLevelSelectItem")
local UINWAMMMapLevelCurItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLevelCurItem")
local UINWAMMMapLineItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLineItem")
local UINTextureItem = require("Game.ActivitySectorII.MainMap.UI.UINWin21SetLvTexItem")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINWAMMMapNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWAMMMapLevelItem, UINWAMMMapLevelPointItem, UINWAMMMapLevelSelectItem, UINWAMMMapLevelCurItem, UINWAMMMapLineItem, MapScaleLimit
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._onTap = BindCallback(self, self._OnTap)
  self._onGesture = BindCallback(self, self._OnGesture)
  self.__onClickLevel = BindCallback(self, self.__OnClickLevel)
  self._onFingerDown = BindCallback(self, self._OnFingerDown)
  self._onFingerUp = BindCallback(self, self._OnFingerUp)
  self._parentTransform = nil
  self._lastSelectLevel = nil
  self.__data2LevelItemDic = nil
  self.fartestCouldPlayLevelItem = nil
  self.wait2PlayUnlockTweemLevelItem = nil
  self.__isCouldPlayUnlockFocusTween = nil
  self.levelItemPool = (UIItemPool.New)(UINWAMMMapLevelItem, (self.ui).obj_baseItem)
  ;
  (((self.ui).obj_baseItem).transform):SetParent(((self.ui).obj_itemNode).transform)
  ;
  ((self.ui).obj_baseItem):SetActive(false)
  self.pointItemPool = (UIItemPool.New)(UINWAMMMapLevelPointItem, (self.ui).obj_pointItem)
  ;
  (((self.ui).obj_pointItem).transform):SetParent(((self.ui).obj_itemNode).transform)
  ;
  ((self.ui).obj_pointItem):SetActive(false)
  self.selectItem = (UINWAMMMapLevelSelectItem.New)()
  ;
  (self.selectItem):Init((self.ui).obj_selectItem)
  ;
  ((self.ui).obj_selectItem):SetActive(false)
  self.curItem = (UINWAMMMapLevelCurItem.New)()
  ;
  (self.curItem):Init((self.ui).obj_curLevelItem)
  ;
  ((self.ui).obj_curLevelItem):SetActive(false)
  self.lineItemPool = (UIItemPool.New)(UINWAMMMapLineItem, (self.ui).obj_lineItem)
  ;
  (((self.ui).obj_lineItem).transform):SetParent(((self.ui).obj_lineNode).transform)
  ;
  ((self.ui).obj_lineItem):SetActive(false)
  MapScaleLimit.max = (self.ui).float_maxScale
  self.__onEpGiveUp = BindCallback(self, self.__OnEpGiveUp)
  MsgCenter:AddListener(eMsgEventId.GiveUncompleteExploration, self.__onEpGiveUp)
  self:_InitTextureItems()
end

UINWAMMMapNode.OnShow = function(self)
  -- function num : 0_1
  self:__AddLeanTouch()
end

UINWAMMMapNode.OnHide = function(self)
  -- function num : 0_2
  self:__RemoveLeanTouch()
end

UINWAMMMapNode.__AddLeanTouch = function(self)
  -- function num : 0_3 , upvalues : cs_LeanTouch
  (cs_LeanTouch.OnFingerTap)("+", self._onTap)
  ;
  (cs_LeanTouch.OnGesture)("+", self._onGesture)
  ;
  (cs_LeanTouch.OnFingerDown)("+", self._onFingerDown)
  ;
  (cs_LeanTouch.OnFingerUp)("+", self._onFingerUp)
end

UINWAMMMapNode.__RemoveLeanTouch = function(self)
  -- function num : 0_4 , upvalues : cs_LeanTouch
  (cs_LeanTouch.OnFingerTap)("-", self._onTap)
  ;
  (cs_LeanTouch.OnGesture)("-", self._onGesture)
  ;
  (cs_LeanTouch.OnFingerDown)("-", self._onFingerDown)
  ;
  (cs_LeanTouch.OnFingerUp)("-", self._onFingerUp)
end

UINWAMMMapNode.SetDetailCantShow = function(self, cantShow)
  -- function num : 0_5
  self.cantShowDetail = cantShow
end

UINWAMMMapNode.InitWAMMMap = function(self, parentTransform, actId, setInfoNodeCallback, resloader, cantShowDetail)
  -- function num : 0_6 , upvalues : _ENV, SectorStageDetailHelper, cs_UIMnager, MapScaleLimit
  self._parentTransform = parentTransform
  self.actId = actId
  self.setInfoNodeCallback = setInfoNodeCallback
  self.resloader = resloader
  self.cantShowDetail = cantShowDetail
  self.wait2PlayUnlockTweemLevelItem = {}
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
  local playModoule = (SectorStageDetailHelper.SectorPlayMoudle)(sectorIIData:GetSectorIISectorId())
  self.__lastEpStateCfg = (SectorStageDetailHelper.TryGetUncompletedStateCfg)(playModoule)
  local BackgroundStretchSize = UIManager.BackgroundStretchSize
  self.__notchSize = BackgroundStretchSize.x * (cs_UIMnager.CurNotchValue / 100)
  local minScale = (math.max)(BackgroundStretchSize.x / (((self.ui).rect_Map).rect).width, BackgroundStretchSize.y / (((self.ui).rect_Map).rect).height)
  local defaultScale = (math.max)(minScale, (self.ui).float_deafultScale)
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R12 in 'UnsetPending'

  ;
  ((self.ui).rect_Map).localScale = (Vector3.New)(defaultScale, defaultScale, 1)
  MapScaleLimit.min = minScale
  local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
  local isAftertreatment = (aftertTeatmentCtrl ~= nil and aftertTeatmentCtrl:IsStartShowReward())
  self:__GenMapLevels(isAftertreatment)
  self:_PlayTextureItemTween()
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINWAMMMapNode.__GenMapLevels = function(self, isAftertreatment)
  -- function num : 0_7 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
  local mapDataList = sectorIIData:GetSectorIISectorMapDataList()
  ;
  (self.levelItemPool):HideAll()
  ;
  (self.pointItemPool):HideAll()
  ;
  (self.lineItemPool):HideAll()
  local battleLevelIndex = 0
  self.wait2ClearTweemLvItem = nil
  self.__data2LevelItemDic = {}
  for _,levelData in ipairs(mapDataList) do
    local isLastUnlock = levelData:GetIsLevelUnlock()
    local isLastClear = levelData:GetIsLevelClaer()
    levelData:RefreshSIILevelState()
    local isUnlock = levelData:GetIsLevelUnlock()
    local isClear = levelData:GetIsLevelClaer()
    if isUnlock then
      local levelItem = (self.levelItemPool):GetOne()
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (self.__data2LevelItemDic)[levelData] = levelItem
      levelItem:InitLevelItem(sectorIIData, levelData, self.resloader, self.__onClickLevel)
      for key,parentLevelData in pairs(levelData:GetSIILevelParentList()) do
        local lineItem = (self.lineItemPool):GetOne()
        lineItem:InitWAMMMapLine(parentLevelData:GetIsLevelLinePos(), levelData:GetIsLevelLinePos())
        levelItem:AddLine2SectorIILevel(lineItem)
      end
      if levelData:GetIsBattle() then
        battleLevelIndex = battleLevelIndex + 1
        local pointItem = (self.pointItemPool):GetOne()
        pointItem:InitLevelPointItem(true, battleLevelIndex)
        pointItem:SetArrowSprites(levelData:GetIsLevelClaer(), levelData:GetSectroIILevelIsHard())
        levelItem:SetPointItem2Level(pointItem)
        if isUnlock then
          self.fartestCouldPlayLevelItem = levelItem
        end
      end
      do
        do
          if not isLastUnlock then
            (table.insert)(self.wait2PlayUnlockTweemLevelItem, levelItem)
          end
          if isClear and not isLastClear then
            self.wait2ClearTweemLvItem = levelItem
          end
          -- DECOMPILER ERROR at PC105: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC105: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC105: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  sectorIIData:RefreshSectorIIReddot4Avg()
  if self.__lastEpStateCfg ~= nil then
    for _,levelItem in pairs((self.levelItemPool).listItem) do
      if (self.__lastEpStateCfg).id == (levelItem.levelData):GetLevelSageId() then
        self:__OnClickLevel(levelItem, levelItem.levelData)
      end
    end
  else
    do
      if self.fartestCouldPlayLevelItem ~= nil then
        self:__FocusLvItem(self.fartestCouldPlayLevelItem, false, false)
      end
      if not isAftertreatment then
        self:__PlayUnlockNewLevelTween()
      else
        local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
        aftertTeatmentCtrl:BindResultAfterAction(function()
    -- function num : 0_7_0 , upvalues : self
    self:__PlayUnlockNewLevelTween()
  end
)
      end
      do
        if self.fartestCouldPlayLevelItem ~= nil then
          (self.fartestCouldPlayLevelItem):SetcurItem2Level(self.curItem)
          ;
          (self.fartestCouldPlayLevelItem):TryChangeLine2DotedLine()
          ;
          ((self.fartestCouldPlayLevelItem).transform):SetAsLastSibling()
        end
      end
    end
  end
end

UINWAMMMapNode.__OnEpGiveUp = function(self)
  -- function num : 0_8
  self.__lastEpStateCfg = nil
end

UINWAMMMapNode.__PlayUnlockNewLevelTween = function(self)
  -- function num : 0_9 , upvalues : cs_DoTween, _ENV, cs_Tweening, MapScaleLimit
  if self.__sequence ~= nil then
    (self.__sequence):Kill()
    self.__sequence = nil
  end
  self.__isCouldPlayUnlockFocusTween = true
  local needAddLastOne = nil
  local sequence = (cs_DoTween.Sequence)()
  sequence:AppendCallback(function()
    -- function num : 0_9_0 , upvalues : self
    self:__RemoveLeanTouch()
  end
)
  if self.wait2ClearTweemLvItem ~= nil and #self.wait2PlayUnlockTweemLevelItem > 0 then
    sequence:AppendCallback(function()
    -- function num : 0_9_1 , upvalues : self
    self:__FocusLvItem(self.wait2ClearTweemLvItem, nil, true)
  end
)
    sequence:AppendInterval(1)
    local completeCom = (self.wait2ClearTweemLvItem):GetComplete()
    sequence:Append(((completeCom:DOScale(Vector3.zero, 0.3)):From()):SetEase((cs_Tweening.Ease).OutBack))
    sequence:AppendInterval(0.5)
  end
  do
    for _,levelItem in ipairs(self.wait2PlayUnlockTweemLevelItem) do
      if levelItem == self.fartestCouldPlayLevelItem then
        needAddLastOne = true
      else
        self:__add2Sequence(sequence, R11_PC58)
      end
    end
    if needAddLastOne then
      self:__add2Sequence(sequence, self.fartestCouldPlayLevelItem, true)
      sequence:AppendCallback(function()
    -- function num : 0_9_2 , upvalues : self, MapScaleLimit
    if self.__isCouldPlayUnlockFocusTween then
      (((self.ui).rect_Map):DOScale(MapScaleLimit.min, 0.5)):OnUpdate(function()
      -- function num : 0_9_2_0 , upvalues : self
      self:__OnScale(((self.fartestCouldPlayLevelItem).transform).localPosition)
    end
)
    end
  end
)
    end
    sequence:AppendCallback(function()
    -- function num : 0_9_3 , upvalues : self
    self:__AddLeanTouch()
  end
)
    self.__sequence = sequence
  end
end

UINWAMMMapNode.__add2Sequence = function(self, sequence, levelItem, isLast)
  -- function num : 0_10 , upvalues : _ENV
  sequence:AppendCallback(function()
    -- function num : 0_10_0 , upvalues : self, levelItem, isLast
    if self.__isCouldPlayUnlockFocusTween then
      self:__FocusLvItem(levelItem, isLast, true)
    end
  end
)
  for key,linewItem in pairs(levelItem.parentLines) do
    sequence:Join(((linewItem.transform):DOSizeDelta((Vector3.New)(0, 4, 1), 1.5)):From())
  end
  sequence:Append((((levelItem.ui).canvas_baseItem):DOFade(0, 0.3)):From())
  if isLast then
    sequence:AppendCallback(function()
    -- function num : 0_10_1 , upvalues : self
    (self.curItem):Show()
  end
)
  end
  sequence:AppendInterval(0.5)
end

UINWAMMMapNode.__FocusLvItem = function(self, levelItem, isLast, isUnlock)
  -- function num : 0_11 , upvalues : _ENV, MapScaleLimit
  local scale = (((self.ui).rect_Map).localScale).x
  if isUnlock then
    scale = (math.clamp)(2, MapScaleLimit.min, MapScaleLimit.max)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).rect_Map).localScale = (Vector3.New)(scale, scale, 1)
  end
  self:_UpdateBound(false, true)
  local screenMid = UIManager.BackgroundStretchSize / 2
  local uiPos = UIManager:Screen2UIPosition(screenMid, ((self.ui).obj_itemNode).transform, UIManager:GetUICamera())
  local move = (uiPos - (levelItem.transform).anchoredPosition) * scale
  local diffPos = (Vector3.New)(move.x, move.y, 0)
  local targetPos = ((self.ui).rect_Map).localPosition + diffPos
  self:_SetLimit(targetPos)
  ;
  ((self.ui).rect_Map):DOLocalMove(targetPos, 0.5)
  if isLast then
    (self.curItem):Hide()
  end
end

UINWAMMMapNode.__OnClickLevel = function(self, levelItem, levelData)
  -- function num : 0_12 , upvalues : _ENV, SectorStageDetailHelper
  if levelData:GetIsBattle() and self.__lastEpStateCfg ~= nil and (self.__lastEpStateCfg).id ~= levelData:GetLevelSageId() then
    local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
    local sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
    local playModoule = (SectorStageDetailHelper.SectorPlayMoudle)(sectorIIData:GetSectorIISectorId())
    ;
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)(playModoule)
    return 
  end
  do
    if self.cantShowDetail then
      return 
    end
    self.__isCouldPlayUnlockFocusTween = false
    if self._lastSelectLevel ~= nil then
      if self._lastSelectLevel == levelItem then
        return 
      end
      ;
      (self._lastSelectLevel):CancleSelectWALevel(self.selectItem)
      self._lastSelectLevel = nil
    end
    levelItem:SelectWALevel(self.selectItem)
    self._lastSelectLevel = levelItem
    self:ShowLevelDetailWindow(levelData, levelItem)
    if self.setInfoNodeCallback ~= nil then
      (self.setInfoNodeCallback)(false)
    end
  end
end

UINWAMMMapNode.ShowLevelDetailWindow = function(self, levelData, levelItem)
  -- function num : 0_13 , upvalues : _ENV
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local sectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevelDetail, function(window)
    -- function num : 0_13_0 , upvalues : self, sectorIIData, levelItem, levelData, _ENV
    local width, duration = window:GetLevelDetailWidthAndDuration()
    self.__isOpenDetail = true
    self.__detailWidth = width
    local leftEdgeItem = (window.ui).obj_leftEdge
    local isActivityRunning = sectorIIData:IsActivityRunning()
    window:SetActivityEndButCouldReview(isActivityRunning)
    window:SetLevelDetaiHideStartEvent(function(toHome)
      -- function num : 0_13_0_0 , upvalues : self, width, duration, levelItem, leftEdgeItem
      self.__isOpenDetail = false
      if not toHome then
        self:__PlayMoveLeftTween(false, width, duration, levelItem, leftEdgeItem)
      end
      if self._lastSelectLevel ~= nil then
        (self._lastSelectLevel):CancleSelectWALevel(self.selectItem)
        self._lastSelectLevel = nil
      end
      if self.setInfoNodeCallback ~= nil then
        (self.setInfoNodeCallback)(true)
      end
    end
)
    window:SetLevelDetaiHideEndEvent(function()
      -- function num : 0_13_0_1
    end
)
    self:__PlayMoveLeftTween(true, width, duration, levelItem, leftEdgeItem)
    local isBattle = levelData:GetIsBattle()
    local isLocked = not levelData:GetIsLevelUnlock()
    if isBattle then
      local stageCfg = levelData:GetLevelEpStageCfg()
      window:InitSectorLevelDetail(stageCfg.sector, stageCfg.id, isLocked)
      local buffList = {}
      local buffDic = sectorIIData:GetSectorII_UnlockedBuffList()
      for buffId,_ in pairs(buffDic) do
        (table.insert)(buffList, buffId)
      end
      window:SetAdditionBuffList(buffList)
    else
      do
        local sectorId = levelData:GetLevelSectorId()
        local avgCfg = levelData:GetLevelAvgCfg()
        window:InitSectorLevelAvgDetail(sectorId, avgCfg, function()
      -- function num : 0_13_0_2 , upvalues : levelData, levelItem
      levelData:RefreshSIILevelState()
      levelItem:RefreshSIILevel()
    end
, isLocked)
      end
    end
  end
)
end

UINWAMMMapNode._OnClickMapBg = function(self)
  -- function num : 0_14 , upvalues : _ENV
  self.distan = 0
  if self._lastSelectLevel ~= nil then
    (UIUtil.OnClickBack)()
  end
end

UINWAMMMapNode.RefreshSectroIIMapRedddot = function(self)
  -- function num : 0_15 , upvalues : _ENV
  for _,levelItem in pairs((self.levelItemPool).listItem) do
    levelItem:RefreshRedOrBlueDot()
  end
end

local DistanLimit = 800
UINWAMMMapNode._OnGesture = function(self, fingerList)
  -- function num : 0_16 , upvalues : cs_LeanTouch, DistanLimit
  local result = (cs_LeanTouch.RaycastGui)((fingerList[0]).ScreenPosition)
  if result.Count == 0 or not (((result[0]).gameObject).transform):IsChildOf((self.ui).rect_Map) then
    return 
  end
  do
    if fingerList.Count == 1 then
      local touch = fingerList[0]
      self:_CalculateMove(touch)
    end
    if fingerList.Count == 2 then
      local touch1 = fingerList[0]
      local touch2 = fingerList[1]
      self:_CalculateScale(touch1, touch2)
    end
    do
      local touch = fingerList[0]
      self.distan = (self.distan or 0) + (touch.ScreenPosition - touch.LastScreenPosition).magnitude
      if DistanLimit <= self.distan then
        self.distan = 0
        self:UpdateTextureItemTween()
      end
    end
  end
end

UINWAMMMapNode._OnFingerDown = function(self)
  -- function num : 0_17
  self.distan = 0
end

UINWAMMMapNode._OnFingerUp = function(self)
  -- function num : 0_18
  self.distan = 0
  self:UpdateTextureItemTween()
end

UINWAMMMapNode._OnTap = function(self, finger)
  -- function num : 0_19 , upvalues : cs_LeanTouch
  local result = (cs_LeanTouch.RaycastGui)(finger.ScreenPosition)
  if result.Count == 0 or (result[0]).gameObject ~= (self.ui).obj_img_Map then
    return 
  end
  self:_OnClickMapBg()
end

UINWAMMMapNode._CalculateMove = function(self, touch)
  -- function num : 0_20 , upvalues : _ENV
  self:_UpdateBound()
  local diffPos = touch.ScreenPosition - touch.LastScreenPosition
  diffPos = (Vector3.New)(diffPos.x, diffPos.y, 0)
  local targetPos = ((self.ui).rect_Map).localPosition + diffPos
  self:_SetLimit(targetPos)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).rect_Map).localPosition = targetPos
end

UINWAMMMapNode._CalculateScale = function(self, touch1, touch2)
  -- function num : 0_21 , upvalues : _ENV, MapScaleLimit
  local lastDiffX = (touch1.LastScreenPosition).x - (touch2.LastScreenPosition).x
  local lastDiffY = (touch1.LastScreenPosition).y - (touch2.LastScreenPosition).y
  local curDiffX = (touch1.ScreenPosition).x - (touch2.ScreenPosition).x
  local curDiffY = (touch1.ScreenPosition).y - (touch2.ScreenPosition).y
  local diff = (Mathf.Sqrt)((Mathf.Pow)(curDiffX, 2) + (Mathf.Pow)(curDiffY, 2)) - (Mathf.Sqrt)((Mathf.Pow)(lastDiffX, 2) + (Mathf.Pow)(lastDiffY, 2))
  local scale = (((self.ui).rect_Map).localScale).x + diff / 500 * (MapScaleLimit.max - MapScaleLimit.min)
  scale = (math.clamp)(scale, MapScaleLimit.min, MapScaleLimit.max)
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).rect_Map).localScale = (Vector3.New)(scale, scale, 1)
  local centerPos = (touch1.ScreenPosition + touch2.ScreenPosition) / 2
  local uiPos = UIManager:Screen2UIPosition(centerPos, self._parentTransform, UIManager.UICamera)
  self:__OnScale(uiPos)
end

UINWAMMMapNode.__OnScale = function(self, uiPos)
  -- function num : 0_22 , upvalues : _ENV
  local delX = uiPos.x - (((self.ui).rect_Map).localPosition).x
  local delY = uiPos.y - (((self.ui).rect_Map).localPosition).y
  local pivotX = delX / (((self.ui).rect_Map).rect).width / (((self.ui).rect_Map).localScale).x
  local pivotY = delY / (((self.ui).rect_Map).rect).height / (((self.ui).rect_Map).localScale).y
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).rect_Map).pivot = ((self.ui).rect_Map).pivot + (Vector2.New)(pivotX, pivotY)
  self:_UpdateBound(true)
  local targetPos = ((self.ui).rect_Map).localPosition + (Vector3.New)(delX, delY, 0)
  self:_SetLimit(targetPos)
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).rect_Map).localPosition = targetPos
end

UINWAMMMapNode._UpdateBound = function(self, onDrag, openSide)
  -- function num : 0_23
  if self.bound ~= nil and not onDrag and not openSide then
    return 
  end
  if self.bound == nil then
    self.bound = {}
  end
  local scale = ((self.ui).rect_Map).localScale
  local width = (((self.ui).rect_Map).rect).width * scale.x
  local height = (((self.ui).rect_Map).rect).height * scale.y
  local pivot = ((self.ui).rect_Map).pivot
  local parentRect = (self._parentTransform).rect
  local xMin = parentRect.xMin + width * pivot.x - self.__notchSize
  local xMax = parentRect.xMax - width * (1 - pivot.x) + self.__notchSize
  local yMin = parentRect.yMin + height * pivot.y
  local yMax = parentRect.yMax - height * (1 - pivot.y)
  if self.__isOpenDetail then
    xMax = xMax - self.__detailWidth
  end
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R12 in 'UnsetPending'

  ;
  (self.bound).xMin = xMin
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R12 in 'UnsetPending'

  ;
  (self.bound).xMax = xMax
  -- DECOMPILER ERROR at PC65: Confused about usage of register: R12 in 'UnsetPending'

  ;
  (self.bound).yMin = yMin
  -- DECOMPILER ERROR at PC67: Confused about usage of register: R12 in 'UnsetPending'

  ;
  (self.bound).yMax = yMax
end

UINWAMMMapNode._SetLimit = function(self, targetPos)
  -- function num : 0_24 , upvalues : _ENV
  if (self.bound).xMin <= (self.bound).xMax then
    targetPos.x = (math.clamp)(targetPos.x, (self.bound).xMin, (self.bound).xMax)
  else
    targetPos.x = (math.clamp)(targetPos.x, (self.bound).xMax, (self.bound).xMin)
  end
  if (self.bound).yMin <= (self.bound).yMax then
    targetPos.y = (math.clamp)(targetPos.y, (self.bound).yMin, (self.bound).yMax)
  else
    targetPos.y = (math.clamp)(targetPos.y, (self.bound).yMax, (self.bound).yMin)
  end
end

UINWAMMMapNode.__PlayMoveLeftTween = function(self, isLeft, width, duration, levelItem, leftEdgeItem)
  -- function num : 0_25 , upvalues : _ENV
  ((self.ui).rect_Map):DOKill()
  if isLeft then
    local lpos = (UIManager.UICamera):WorldToScreenPoint((leftEdgeItem.transform).position)
    local posItemNeed2 = (Vector2.New)(lpos.x / 2, lpos.y)
    local uiPos = UIManager:Screen2UIPosition(posItemNeed2, ((self.ui).obj_itemNode).transform, UIManager:GetUICamera())
    local scale = (((self.ui).rect_Map).localScale).x
    local move = (uiPos - (levelItem.transform).anchoredPosition) * scale
    self:_UpdateBound(false, true)
    local diffPos = (Vector3.New)(move.x, move.y, 0)
    local targetPos = ((self.ui).rect_Map).localPosition + diffPos
    self:_SetLimit(targetPos)
    ;
    ((self.ui).rect_Map):DOLocalMove(targetPos, duration)
  else
    do
      self:_UpdateBound(false, true)
      local targetPos = ((self.ui).rect_Map).localPosition
      self:_SetLimit(targetPos)
      ;
      ((self.ui).rect_Map):DOLocalMove(targetPos, duration)
    end
  end
end

local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UINWAMMMapNode._InitTextureItems = function(self)
  -- function num : 0_26 , upvalues : _ENV, UINTextureItem, cs_DoTween, cs_Ease
  self.texItemList = {}
  for k,go in ipairs((self.ui).texTweens) do
    local texItem = (UINTextureItem.New)(self)
    texItem:Init(go)
    texItem:InitWin21SetLvTexItem(cs_DoTween, cs_Ease)
    ;
    (table.insert)(self.texItemList, texItem)
  end
end

UINWAMMMapNode._PlayTextureItemTween = function(self)
  -- function num : 0_27 , upvalues : cs_DoTween, _ENV
  self.isInitTexTween = true
  if self.showTextureSeq ~= nil then
    (self.showTextureSeq):Kill()
    self.showTextureSeq = nil
  end
  local showTextureSeq = (cs_DoTween.Sequence)()
  for i = 1, #self.texItemList do
    local item = (self.texItemList)[i]
    do
      showTextureSeq:InsertCallback((i - 1) * 0.2, function()
    -- function num : 0_27_0 , upvalues : item
    item:PlayShowTween()
  end
)
    end
  end
  showTextureSeq:AppendInterval(0.6)
  showTextureSeq:AppendCallback(function()
    -- function num : 0_27_1 , upvalues : _ENV, self
    for k,v in ipairs(self.texItemList) do
      v:PlayHighlightTween()
    end
  end
)
  self.showTextureSeq = showTextureSeq
end

UINWAMMMapNode.UpdateTextureItemTween = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if self.isInitTexTween then
    self.isInitTexTween = false
    return 
  end
  for k,v in ipairs(self.texItemList) do
    v:OnMapGesture()
  end
end

UINWAMMMapNode.OnDelete = function(self)
  -- function num : 0_29 , upvalues : _ENV, base
  if self.__sequence ~= nil then
    (self.__sequence):Kill()
    self.__sequence = nil
  end
  if self.showTextureSeq ~= nil then
    (self.showTextureSeq):Kill()
    self.showTextureSeq = nil
  end
  ;
  (self.levelItemPool):DeleteAll()
  for i = 1, #self.texItemList do
    local item = (self.texItemList)[i]
    item:Delete()
  end
  self.texItemList = nil
  MsgCenter:RemoveListener(eMsgEventId.GiveUncompleteExploration, self.__onEpGiveUp)
  UIManager:DeleteWindow(UIWindowTypeID.SectorLevelDetail)
  ;
  (base.OnDelete)(self)
end

return UINWAMMMapNode

