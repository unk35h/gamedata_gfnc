-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum22Map = class("UIActSum22Map", UIBaseWindow)
local base = UIBaseWindow
local UINActSum22MapItem = require("Game.ActivitySummer.Year22.LevelMap.UINActSum22MapItem")
local UINActSum22MapSelected = require("Game.ActivitySummer.Year22.LevelMap.UINActSum22MapSelected")
local UINWAMMMapLineItem = require("Game.ActivitySectorII.MainMap.UI.LevelItem.UINWAMMMapLineItem")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivitySectorIIIEnum = require("Game.ActivitySectorIII.ActivitySectorIIIEnum")
local util = require("XLua.Common.xlua_util")
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_DOTween = ((CS.DG).Tweening).DOTween
local scaleRate = 500
local ANI_TIME = 0.5
local DIFF_VECOT3_OPEN = (Vector3.New)(-500, 0, 0)
local CS_UnityEngine_Time = (CS.UnityEngine).Time
UIActSum22Map.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActSum22MapItem, UINWAMMMapLineItem, UINActSum22MapSelected
  (UIUtil.SetTopStatus)(self, self.OnClickMapClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Map, self, self.OnClickExitDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Tech, self, self._OnClickTech)
  self._levelItemPool = (UIItemPool.New)(UINActSum22MapItem, (self.ui).baseItem)
  ;
  ((self.ui).baseItem):SetActive(false)
  self._lineItemPool = (UIItemPool.New)(UINWAMMMapLineItem, (self.ui).line)
  ;
  ((self.ui).line):SetActive(false)
  self._selectNode = (UINActSum22MapSelected.New)()
  ;
  (self._selectNode):Init((self.ui).selectItem)
  ;
  (self._selectNode):Hide()
  self.__OnSelectLevelItemCallback = BindCallback(self, self.__OnSelectLevelItem)
  self.__OnGestureCallback = BindCallback(self, self.__OnGesture)
  self.__OnFingerUpCallback = BindCallback(self, self.__OnFingerUp)
  for k,anim in ipairs((self.ui).anim_iconList) do
    (anim:get_Item((anim.clip).name)).time = k * 0.75
  end
  self.__OnClickExitDetailCallback = BindCallback(self, self.OnClickExitDetail)
  MsgCenter:AddListener(eMsgEventId.GiveUncompleteExploration, self.__OnClickExitDetailCallback)
  self.__ReCalDragparamCallback = BindCallback(self, self.__ReCalDragparam)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__ReCalDragparamCallback)
  self._mapItemDic = {}
end

UIActSum22Map.OnShow = function(self)
  -- function num : 0_1 , upvalues : base, cs_LeanTouch
  (base.OnShow)(self)
  ;
  (cs_LeanTouch.OnGesture)("+", self.__OnGestureCallback)
  ;
  (cs_LeanTouch.OnFingerUp)("+", self.__OnFingerUpCallback)
end

UIActSum22Map.OnHide = function(self)
  -- function num : 0_2 , upvalues : base, cs_LeanTouch
  (base.OnHide)(self)
  ;
  (cs_LeanTouch.OnGesture)("-", self.__OnGestureCallback)
  ;
  (cs_LeanTouch.OnFingerUp)("-", self.__OnFingerUpCallback)
end

UIActSum22Map.InitSum22Map = function(self, sum22Data, callback)
  -- function num : 0_3 , upvalues : ActivitySectorIIIEnum, _ENV, util
  self._sum22Data = sum22Data
  self._callback = callback
  local actReddot = (self._sum22Data):GetActivityReddot()
  if actReddot ~= nil then
    self._techReddot = actReddot:GetChild((ActivitySectorIIIEnum.eActRedDotTypeId).tech)
    self._UpdTechRedDotFunc = BindCallback(self, self._UpdTechRedDot)
    self:_UpdTechRedDot(self._techReddot)
    RedDotController:AddListener((self._techReddot).nodePath, self._UpdTechRedDotFunc)
  end
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self:__InitDragparam()
  self._sector = ((self._sum22Data):GetSectorIIIMainCfg()).main_sector
  self._isLockHard = false
  self._isLockMain2nd = false
  local needTimedown = false
  self._hardUnlockTime = (self._sum22Data):GetSectorIIIHardOpenTime()
  self._mainNextUnlockTime = (self._sum22Data):GetSectorIIIMainNextOpenTime()
  if PlayerDataCenter.timestamp < self._hardUnlockTime then
    ((self.ui).unlockHolder):SetActive(false)
    ;
    ((self.ui).lockHolder):SetActive(true)
    local timeData = TimeUtil:TimestampToDate(self._hardUnlockTime, false, true)
    ;
    ((self.ui).img_DiffcultArea):SetIndex(0)
    ;
    ((self.ui).tex_DayCount):SetIndex(0, (string.format)("%02d", timeData.month), (string.format)("%02d", timeData.day), (string.format)("%02d", timeData.hour), (string.format)("%02d", timeData.min))
    self._isLockHard = true
  else
    do
      self:__UnlockHardLevel()
      if PlayerDataCenter.timestamp < self._mainNextUnlockTime then
        ((self.ui).lockHolder_main):SetActive(true)
        local timeData = TimeUtil:TimestampToDate(self._mainNextUnlockTime, false, true)
        ;
        ((self.ui).tex_DayCount_main):SetIndex(0, (string.format)("%02d", timeData.month), (string.format)("%02d", timeData.day), (string.format)("%02d", timeData.hour), (string.format)("%02d", timeData.min))
        self._isLockMain2nd = true
      else
        do
          ;
          ((self.ui).lockHolder_main):SetActive(false)
          self._isMoving = true
          self._delayCO = (GR.StartCoroutine)((util.cs_generator)(function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    (coroutine.yield)(((CS.UnityEngine).WaitForSeconds)(0.5))
    self._delayCO = nil
    self._isMoving = false
    self:__DelayDealInit()
  end
))
        end
      end
    end
  end
end

UIActSum22Map.__DelayDealInit = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self:__GenMap()
  if self._isInitHard or self._isInitMain2nd then
    self._timerId = TimerManager:StartTimer(1, self.__CountDownTime, self)
    self:__CountDownTime()
  end
end

UIActSum22Map.__GenMap = function(self)
  -- function num : 0_5 , upvalues : SectorStageDetailHelper, _ENV
  self._sectorStageDataList = (self._sum22Data):GetSectorIIISectorMain()
  local sectorStage2nd = ((self._sum22Data):GetSectorIIIMainCfg()).main2nd_id
  local playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(self._sector)
  local _, unCompleteStageId = (SectorStageDetailHelper.HasUnCompleteStage)(playMoudle)
  local defaultSelectItem, lastStageItem = nil, nil
  local newUnlockStageDatas = {}
  local newUnlockIndexDatas = {}
  for index,levelData in ipairs(self._sectorStageDataList) do
    local oldUnlockState = levelData:GetIsLevelUnlock()
    levelData:RefreshSIILevelState()
    if (self._mapItemDic)[levelData] == nil and (levelData:GetSectroIILevelIsHard()) then
      local stageId = levelData:GetLevelSageId()
      if stageId == nil or PlayerDataCenter.timestamp >= self._mainNextUnlockTime or sectorStage2nd > stageId then
        if levelData:GetIsLevelUnlock() then
          if not oldUnlockState then
            (table.insert)(newUnlockStageDatas, levelData)
            ;
            (table.insert)(newUnlockIndexDatas, index)
          else
            local item = (self._levelItemPool):GetOne()
            item:InitSum22MapItem(levelData, index, self.__OnSelectLevelItemCallback)
            -- DECOMPILER ERROR at PC72: Confused about usage of register: R17 in 'UnsetPending'

            ;
            (item.transform).localPosition = levelData:GetIsLevelPos()
            ;
            (item.transform):SetParent((self.ui).levelLayer)
            -- DECOMPILER ERROR at PC79: Confused about usage of register: R17 in 'UnsetPending'

            ;
            (self._mapItemDic)[levelData] = item
            lastStageItem = item
            if unCompleteStageId ~= nil and stageId == unCompleteStageId then
              defaultSelectItem = item
            end
            if index ~= 1 and not levelData:IsSectorIIIStageIsolated() then
              local preData = (self._sectorStageDataList)[index - 1]
              local startPos = preData:GetIsLevelLinePos()
              local endPos = levelData:GetIsLevelLinePos()
              local line = (self._lineItemPool):GetOne()
              line:InitWAMMMapLine(startPos, endPos)
              ;
              (line.transform):SetParent((self.ui).lineLayer)
            end
          end
        end
        do
          -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  if #newUnlockStageDatas > 0 then
    self:__TrackLevel(newUnlockStageDatas, newUnlockIndexDatas, defaultSelectItem)
  else
    if defaultSelectItem ~= nil then
      self:__ForceLevel(defaultSelectItem, true)
    else
      if lastStageItem ~= nil then
        self:__ForceLevel(lastStageItem)
      end
    end
  end
end

UIActSum22Map.__UnlockHardLevel = function(self)
  -- function num : 0_6
  ((self.ui).lockHolder):SetActive(false)
  ;
  ((self.ui).unlockHolder):SetActive(true)
  ;
  ((self.ui).img_DiffcultArea):SetIndex(1)
end

UIActSum22Map.__UnlockMain2nd = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self._sectorStageDataList = (self._sum22Data):GetSectorIIISectorMain()
  local sectorStage2nd = ((self._sum22Data):GetSectorIIIMainCfg()).main2nd_id
  for index,levelData in pairs(self._sectorStageDataList) do
    levelData:RefreshSIILevelState()
    if not levelData:GetSectroIILevelIsHard() and levelData:GetLevelSageId() >= sectorStage2nd and levelData:GetIsLevelUnlock() then
      local item = (self._levelItemPool):GetOne()
      item:InitSum22MapItem(levelData, index, self.__OnSelectLevelItemCallback)
      -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (item.transform).localPosition = levelData:GetIsLevelPos()
      ;
      (item.transform):SetParent((self.ui).levelLayer)
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self._mapItemDic)[levelData] = item
      if index ~= 1 and not levelData:IsSectorIIIStageIsolated() then
        local preData = (self._sectorStageDataList)[index - 1]
        local startPos = preData:GetIsLevelLinePos()
        local endPos = levelData:GetIsLevelLinePos()
        local line = (self._lineItemPool):GetOne()
        line:InitWAMMMapLine(startPos, endPos)
        ;
        (line.transform):SetParent((self.ui).lineLayer)
      end
    end
  end
end

UIActSum22Map.__CountDownTime = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self._isLockHard and self._hardUnlockTime <= PlayerDataCenter.timestamp then
    self._isLockHard = false
    self:__UnlockHardLevel()
  end
  if self._isLockMain2nd and self._mainNextUnlockTime <= PlayerDataCenter.timestamp then
    self._isLockMain2nd = false
    self:__UnlockMain2nd()
  end
  if not self._isLockHard and not self._isLockMain2nd and self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
end

UIActSum22Map.__OnSelectLevelItem = function(self, levelData, levelItem)
  -- function num : 0_9 , upvalues : SectorStageDetailHelper, _ENV
  if self._isMoving or self._isDraging then
    return 
  end
  local playMoudle = (SectorStageDetailHelper.SectorPlayMoudle)(self._sector)
  local has, unCompleteStageId = (SectorStageDetailHelper.HasUnCompleteStage)(playMoudle)
  if has and unCompleteStageId ~= levelData.stageId then
    (SectorStageDetailHelper.TryToShowCurrentLevelTips)(playMoudle)
    return 
  end
  if self._selectLevelItem == levelItem then
    return 
  end
  if self._selectLevelItem ~= nil then
    (self._selectLevelItem):SetSum22MapItemSelectState(false)
  end
  self._selectLevelItem = levelItem
  ;
  (self._selectLevelItem):SetSum22MapItemSelectState(true)
  ;
  (self._selectNode):Show()
  ;
  (self._selectNode):InitMapSelected(levelData)
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self._selectNode).transform).localPosition = (levelItem.transform).localPosition
  UIManager:ShowWindowAsync(UIWindowTypeID.SectorLevelDetail, function(win)
    -- function num : 0_9_0 , upvalues : levelData, self, _ENV, levelItem
    if win == nil then
      return 
    end
    if levelData:GetIsBattle() then
      win:InitSectorLevelDetail(self._sector, (levelData:GetLevelEpStageCfg()).id, not levelData:GetIsLevelUnlock())
    else
      win:InitSectorLevelAvgDetail(self._sector, levelData:GetLevelAvgCfg(), function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self, levelData, levelItem
      if not IsNull(self.transform) then
        levelData:RefreshSIILevelState()
        levelItem:RefreshSum22MapItemCompleteState()
        self:__GenMap()
      end
    end
, not levelData:GetIsLevelUnlock())
    end
    self:__MovingWhenOpenLevel(levelItem)
    win:SetLevelDetaiHideStartEvent(function()
      -- function num : 0_9_0_1 , upvalues : _ENV, self, levelItem
      if IsNull(self.transform) then
        return 
      end
      self:__MovingWhenExitLevel(levelItem)
      ;
      (self._selectLevelItem):SetSum22MapItemSelectState(false)
      self._selectLevelItem = nil
    end
)
    win:SetLevelDetaiHideEndEvent(function()
      -- function num : 0_9_0_2 , upvalues : _ENV, self
      if IsNull(self.transform) then
        return 
      end
      ;
      (self._selectNode):Hide()
    end
)
  end
)
end

UIActSum22Map.OnClickExitDetail = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if not self._isDraging then
    local detailWin = UIManager:GetWindow(UIWindowTypeID.SectorLevelDetail)
    if detailWin ~= nil and detailWin.active and self._selectLevelItem ~= nil then
      (UIUtil.OnClickBackByUiTab)(self)
    end
  end
end

UIActSum22Map._OnClickTech = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ActSum22StrategyMain, function(win)
    -- function num : 0_11_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitActSum22StrategyMain(self._sum22Data)
  end
)
end

UIActSum22Map._UpdTechRedDot = function(self, node)
  -- function num : 0_12
  ((self.ui).techBlueDot):SetActive(node:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIActSum22Map.__MovingWhenExitLevel = function(self, levelItem)
  -- function num : 0_13 , upvalues : cs_DOTween, _ENV, ANI_TIME
  if self._movingTween ~= nil then
    (self._movingTween):Kill()
    self._movingTween = nil
  end
  self._isMoving = true
  self._movingTween = (cs_DOTween.Sequence)()
  ;
  (self._movingTween):Append(((self.ui).map_parent):DOLocalMove(Vector3.zero, ANI_TIME))
  ;
  (self._movingTween):AppendCallback(function()
    -- function num : 0_13_0 , upvalues : self
    self._isMoving = false
    self._movingTween = nil
  end
)
  ;
  (self._movingTween):SetAutoKill(true)
end

UIActSum22Map.__MovingWhenOpenLevel = function(self, levelItem)
  -- function num : 0_14 , upvalues : cs_DOTween, ANI_TIME, DIFF_VECOT3_OPEN
  if self._movingTween ~= nil then
    (self._movingTween):Kill()
    self._movingTween = nil
  end
  self._isMoving = true
  local targetPos = self:__GetCenterPos(levelItem)
  self._movingTween = (cs_DOTween.Sequence)()
  ;
  (self._movingTween):Append(((self.ui).map):DOLocalMove(targetPos, ANI_TIME))
  ;
  (self._movingTween):Join(((self.ui).map_parent):DOLocalMove(DIFF_VECOT3_OPEN, ANI_TIME))
  ;
  (self._movingTween):AppendCallback(function()
    -- function num : 0_14_0 , upvalues : self
    self._isMoving = false
    self._movingTween = nil
  end
)
  ;
  (self._movingTween):SetAutoKill(true)
end

UIActSum22Map.__ForceLevel = function(self, levelItem, isOpen)
  -- function num : 0_15 , upvalues : cs_DOTween, ANI_TIME
  if self._movingTween ~= nil then
    (self._movingTween):Kill()
    self._movingTween = nil
  end
  self._isMoving = true
  local targetPos = self:__GetCenterPos(levelItem)
  self._movingTween = (cs_DOTween.Sequence)()
  ;
  (self._movingTween):Append(((self.ui).map):DOLocalMove(targetPos, ANI_TIME))
  ;
  (self._movingTween):AppendCallback(function()
    -- function num : 0_15_0 , upvalues : self, isOpen, levelItem
    self._isMoving = false
    self._movingTween = nil
    if isOpen then
      self:__OnSelectLevelItem(levelItem:GetSum22SectorLevelData(), levelItem)
    end
  end
)
  ;
  (self._movingTween):SetAutoKill(true)
end

UIActSum22Map.__TrackLevel = function(self, newUnlockStageDatas, newUnlockIndexDatas, defaultSelectItem)
  -- function num : 0_16 , upvalues : cs_DOTween, _ENV, ANI_TIME, CS_UnityEngine_Time, util
  if self._movingTween ~= nil then
    (self._movingTween):Kill()
    self._movingTween = nil
  end
  self._isMoving = true
  self._movingTween = (cs_DOTween.Sequence)()
  local curScale = (self._scaleLimitSize)[2]
  local lastScaleSize = ((self.ui).map).localScale
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).map).localScale = (Vector3.New)(curScale, curScale, curScale)
  self:__CalLimitDragRange(curScale)
  local pos = self:__GetMapCorrectPos(((self.ui).map).localPosition)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).map).localPosition = pos
  for i,levelData in ipairs(newUnlockStageDatas) do
    do
      local index = newUnlockIndexDatas[i]
      local item = (self._levelItemPool):GetOne()
      item:InitSum22MapItem(levelData, index, self.__OnSelectLevelItemCallback)
      -- DECOMPILER ERROR at PC52: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (item.transform).localPosition = levelData:GetIsLevelPos()
      ;
      (item.transform):SetParent((self.ui).levelLayer)
      item:Hide()
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self._mapItemDic)[levelData] = item
      local targetPos = self:__GetCenterPos(item)
      ;
      (self._movingTween):Append(((self.ui).map):DOLocalMove(targetPos, ANI_TIME))
      ;
      (self._movingTween):AppendCallback(function()
    -- function num : 0_16_0 , upvalues : item
    item:Show()
  end
)
      ;
      (self._movingTween):AppendInterval(ANI_TIME)
      if index > 1 and not levelData:IsSectorIIIStageIsolated() then
        (self._movingTween):AppendCallback(function()
    -- function num : 0_16_1 , upvalues : self, index, levelData
    local preData = (self._sectorStageDataList)[index - 1]
    local startPos = preData:GetIsLevelLinePos()
    local endPos = levelData:GetIsLevelLinePos()
    local line = (self._lineItemPool):GetOne()
    line:InitWAMMMapLine(startPos, endPos)
    ;
    (line.transform):SetParent((self.ui).lineLayer)
  end
)
        ;
        (self._movingTween):AppendInterval(ANI_TIME * 3)
      end
    end
  end
  ;
  (self._movingTween):AppendCallback(function()
    -- function num : 0_16_2 , upvalues : CS_UnityEngine_Time, _ENV, ANI_TIME, self, lastScaleSize, curScale, defaultSelectItem, util
    local time = CS_UnityEngine_Time.time
    local coFunc = function()
      -- function num : 0_16_2_0 , upvalues : _ENV, CS_UnityEngine_Time, time, ANI_TIME, self, lastScaleSize, curScale, defaultSelectItem
      while 1 do
        (coroutine.yield)(nil)
        local diff = CS_UnityEngine_Time.time - time
        -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

        if ANI_TIME <= diff then
          ((self.ui).map).localScale = lastScaleSize
          self:__CalLimitDragRange(lastScaleSize.x)
          local pos = self:__GetMapCorrectPos(((self.ui).map).localPosition)
          -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.ui).map).localPosition = pos
          break
        end
        do
          local scale = curScale - (curScale - lastScaleSize.x) * (diff / ANI_TIME)
          -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.ui).map).localScale = (Vector3.New)(scale, scale, scale)
          self:__CalLimitDragRange(scale)
          do
            local pos = self:__GetMapCorrectPos(((self.ui).map).localPosition)
            -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

            ;
            ((self.ui).map).localPosition = pos
            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
      self._coFunc = nil
      self._isMoving = false
      self._movingTween = nil
      if defaultSelectItem ~= nil then
        self:__ForceLevel(defaultSelectItem, true)
      end
    end

    self._coFunc = (GR.StartCoroutine)((util.cs_generator)(coFunc))
  end
)
end

UIActSum22Map.__GetCenterPos = function(self, levelItem)
  -- function num : 0_17 , upvalues : _ENV
  local targetPos = (((self.ui).map).parent):InverseTransformPoint((levelItem.transform).position)
  targetPos = (Vector3.New)(((((self.ui).map).transform).localPosition).x - targetPos.x, ((((self.ui).map).transform).localPosition).y - targetPos.y, 0)
  targetPos = self:__GetMapCorrectPos(targetPos)
  return targetPos
end

UIActSum22Map.__InitDragparam = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local scaleZoom = ((self._sum22Data):GetSectorIIIMainCfg()).scale_zoom
  local xMap = (((self.ui).map).rect).width
  local yMap = (((self.ui).map).rect).height
  self._defaultMapSize = {xMap, yMap}
  local BackgroundStretchSize = UIManager.BackgroundStretchSize
  local scaleLimitMin = (math.max)(BackgroundStretchSize.x / xMap, BackgroundStretchSize.y / yMap, scaleZoom[2])
  self._scaleLimitSize = {scaleLimitMin, (math.max)(scaleLimitMin, scaleZoom[1])}
  local curScale = scaleZoom[3]
  curScale = (math.clamp)(curScale, (self._scaleLimitSize)[1], (self._scaleLimitSize)[2])
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).map).localScale = (Vector3.New)(curScale, curScale, curScale)
  self:__CalLimitDragRange(curScale)
end

UIActSum22Map.__ReCalDragparam = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local scaleZoom = ((self._sum22Data):GetSectorIIIMainCfg()).scale_zoom
  local xMap = (self._defaultMapSize)[1]
  local yMap = (self._defaultMapSize)[2]
  local BackgroundStretchSize = UIManager.BackgroundStretchSize
  local scaleLimitMin = (math.max)(BackgroundStretchSize.x / xMap, BackgroundStretchSize.y / yMap, scaleZoom[2])
  self._scaleLimitSize = {scaleLimitMin, (math.max)(scaleLimitMin, scaleZoom[1])}
  self:__CalLimitDragRange((((self.ui).map).localScale).x)
  local pos = self:__GetMapCorrectPos(((self.ui).map).localPosition)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).map).localPosition = pos
end

UIActSum22Map.__CalLimitDragRange = function(self, scale)
  -- function num : 0_20 , upvalues : _ENV
  local BackgroundStretchSize = UIManager.BackgroundStretchSize
  if self._dragLimitRange == nil then
    self._dragLimitRange = {}
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dragLimitRange)[1] = (math.max)(0, ((self._defaultMapSize)[1] * scale - BackgroundStretchSize.x) / 2)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._dragLimitRange)[2] = (math.max)(0, ((self._defaultMapSize)[2] * scale - BackgroundStretchSize.y) / 2)
end

UIActSum22Map.__GetMapCorrectPos = function(self, pos)
  -- function num : 0_21 , upvalues : _ENV
  pos.x = (math.clamp)(pos.x, -(self._dragLimitRange)[1], (self._dragLimitRange)[1])
  pos.y = (math.clamp)(pos.y, -(self._dragLimitRange)[2], (self._dragLimitRange)[2])
  return pos
end

UIActSum22Map.__OnGesture = function(self, fingerList)
  -- function num : 0_22 , upvalues : cs_LeanTouch, _ENV
  if self._isMoving then
    return 
  end
  local result = (cs_LeanTouch.RaycastGui)((fingerList[0]).ScreenPosition)
  if result.Count == 0 or not (((result[0]).gameObject).transform):IsChildOf((self.ui).map) then
    return 
  end
  if (Vector2.Distance)((fingerList[0]).ScreenPosition, (fingerList[0]).LastScreenPosition) < 0.0001 then
    return 
  end
  if fingerList.Count == 1 then
    local finger = fingerList[0]
    if not self._isDraging and (Vector2.Distance)(finger.StartScreenPosition, finger.ScreenPosition) > 30 then
      self._isDraging = true
    end
    self:__OnMoveMap(finger)
  else
    do
      if fingerList.Count == 2 then
        self._isDraging = true
        self:__OnScaleMap(fingerList[0], fingerList[1])
      end
    end
  end
end

UIActSum22Map.__OnFingerUp = function(self)
  -- function num : 0_23
  self._isDraging = false
end

UIActSum22Map.__OnMoveMap = function(self, touch)
  -- function num : 0_24 , upvalues : _ENV
  local diffPos = touch.ScreenPosition - touch.LastScreenPosition
  diffPos = (Vector3.New)(diffPos.x, diffPos.y, 0)
  local targetPos = ((self.ui).map).localPosition + diffPos
  local targetPos = self:__GetMapCorrectPos(targetPos)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).map).localPosition = targetPos
end

UIActSum22Map.__OnScaleMap = function(self, touch1, touch2)
  -- function num : 0_25 , upvalues : _ENV, scaleRate
  local lastDiffX = (touch1.LastScreenPosition).x - (touch2.LastScreenPosition).x
  local lastDiffY = (touch1.LastScreenPosition).y - (touch2.LastScreenPosition).y
  local curDiffX = (touch1.ScreenPosition).x - (touch2.ScreenPosition).x
  local curDiffY = (touch1.ScreenPosition).y - (touch2.ScreenPosition).y
  local diff = (math.sqrt)(curDiffX ^ 2 + curDiffY ^ 2) - (math.sqrt)(lastDiffX ^ 2 + lastDiffY ^ 2)
  local lastScale = (((self.ui).map).localScale).x
  local scale = (math.clamp)(lastScale + diff / scaleRate, (self._scaleLimitSize)[1], (self._scaleLimitSize)[2])
  if scale == lastScale then
    return 
  end
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).map).localScale = (Vector3.New)(scale, scale, scale)
  self:__CalLimitDragRange(scale)
  local pos = self:__GetMapCorrectPos(((self.ui).map).localPosition)
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).map).localPosition = pos
end

UIActSum22Map.OnClickMapClose = function(self)
  -- function num : 0_26 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.SectorLevelDetail)
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIActSum22Map.OnDelete = function(self)
  -- function num : 0_27 , upvalues : _ENV, base
  if self._techReddot ~= nil then
    RedDotController:RemoveListener((self._techReddot).nodePath, self._UpdTechRedDotFunc)
  end
  MsgCenter:RemoveListener(eMsgEventId.GiveUncompleteExploration, self.__OnClickExitDetailCallback)
  MsgCenter:RemoveListener(eMsgEventId.OnScreenSizeChanged, self.__ReCalDragparamCallback)
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._movingTween ~= nil then
    (self._movingTween):Kill()
    self._movingTween = nil
  end
  if self._delayCO ~= nil then
    (GR.StopCoroutine)(self._delayCO)
    self._delayCO = nil
  end
  if self._coFunc ~= nil then
    (GR.StopCoroutine)(self._coFunc)
    self._coFunc = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIActSum22Map

