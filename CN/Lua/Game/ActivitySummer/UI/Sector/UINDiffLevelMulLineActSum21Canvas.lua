-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDiffLevelMulLineCanvas = require("Game.Sector.SectorLevel.UINDiffLevelMulLineCanvas")
local UINDiffLevelMulLineActSum21Canvas = class("UINDiffLevelMulLineActSum21Canvas", UINDiffLevelMulLineCanvas)
local base = UINDiffLevelMulLineCanvas
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local cs_Material = (CS.UnityEngine).Material
local UINActChapterItem = require("Game.ActivitySummer.UI.Sector.UINActChapterItem")
UINDiffLevelMulLineActSum21Canvas.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINActChapterItem
  (base.OnInit)(self)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (((self.ui).switchTween).onComplete):AddListener(BindCallback(self, self.OnSwitchTweenComplete))
  ;
  (((self.ui).switchTween).onRewind):AddListener(BindCallback(self, self.OnSwitchTweenRewind))
  self.chapterItemPool = (UIItemPool.New)(UINActChapterItem, (self.ui).obj_chapterItem)
  ;
  ((self.ui).obj_chapterItem):SetActive(false)
  ;
  ((self.ui).obj_clock):SetActive(false)
  self.__OnRefreshTimeDayPass = BindCallback(self, self.RefreshSectorActivityCount)
  MsgCenter:AddListener(eMsgEventId.SectorActivityTimePass, self.__OnRefreshTimeDayPass)
end

UINDiffLevelMulLineActSum21Canvas.InitDiffLevelCanvas = function(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
  -- function num : 0_1 , upvalues : base
  (base.InitDiffLevelCanvas)(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
  self:RefreshSectorActivityCount()
  self:RefreshHardModeFx(difficulty)
end

UINDiffLevelMulLineActSum21Canvas.SetDungeonListInSector = function(self, dungeonDataDic, clickDungeonItemEvent, blueReddotFunc)
  -- function num : 0_2
end

UINDiffLevelMulLineActSum21Canvas.RefreshSectorActivityCount = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.sectorId == nil then
    return 
  end
  local actId, sectorIData, inTime = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorId(self.sectorId)
  self:CheckExtraMount(actId, sectorIData, inTime)
  self:SetChapterAndLockLayout(actId, sectorIData, inTime)
end

UINDiffLevelMulLineActSum21Canvas.RefillScrollRect = function(self, isOpenInfo)
  -- function num : 0_4 , upvalues : base
  (self.chapterItemPool):HideAll()
  self.extraCharpterTisItemDic = {}
  ;
  (base.RefillScrollRect)(self, isOpenInfo)
end

UINDiffLevelMulLineActSum21Canvas.PlayDiffLevelCanvasSwitchTween = function(self, isUpTween)
  -- function num : 0_5 , upvalues : _ENV
  ((self.gameObject).transform):SetAsLastSibling()
  if isUpTween then
    ((self.ui).switchTween):DORestart()
  else
    self.__isBackwardsTween = true
    ;
    ((self.ui).switchTween):DOComplete()
    ;
    ((self.ui).switchTween):DOPlayBackwards()
  end
  AudioManager:PlayAudioById(1073)
  local continueWindow = UIManager:ShowWindow(UIWindowTypeID.ClickContinue)
  continueWindow:InitContinue(nil, nil, nil, Color.clear, false)
end

UINDiffLevelMulLineActSum21Canvas.OnSwitchTweenComplete = function(self)
  -- function num : 0_6
  if self.__isBackwardsTween then
    return 
  end
  self:OnSwitchTweenEndEvent()
end

UINDiffLevelMulLineActSum21Canvas.OnSwitchTweenRewind = function(self)
  -- function num : 0_7
  if not self.__isBackwardsTween then
    return 
  end
  self.__isBackwardsTween = false
  self:OnSwitchTweenEndEvent()
end

UINDiffLevelMulLineActSum21Canvas.OnSwitchTweenEndEvent = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  ;
  ((self.ui).switchTween):DORewind()
  if self.tweenCompleteEvent ~= nil then
    (self.tweenCompleteEvent)()
  end
end

UINDiffLevelMulLineActSum21Canvas.CheckExtraMount = function(self, actId, sectorIData, inTime)
  -- function num : 0_9 , upvalues : _ENV
  ((self.ui).extraMount):SetActive(false)
  ;
  (((self.ui).tex_Time).gameObject):SetActive(false)
  if self._mulLineCountdownTimer ~= nil then
    TimerManager:StopTimer(self._mulLineCountdownTimer)
    self._mulLineCountdownTimer = nil
    self._countDownTime = nil
  end
  self.extraCharpterTisInfoDic = nil
  self.extraCharpterTisItemDic = nil
  ;
  (self.chapterItemPool):HideAll()
  if not inTime then
    return 
  end
  if (sectorIData:GetSectorICfg()).rechallenge_stage ~= self.sectorId then
    self:CalculateExtraCharterInfo(sectorIData)
    return 
  end
  local _, battleCount, allCount = sectorIData:GetSectorIBattleCount()
  local remainCount = allCount - battleCount
  ;
  ((self.ui).extraMount):SetActive(true)
  local sectorCfg = (ConfigData.sector)[self.sectorId]
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).sectorName).text = (LanguageUtil.GetLocaleText)(sectorCfg.name)
  ;
  ((self.ui).remainTimes):SetIndex(0, tostring(remainCount))
  local nextShowTime = sectorIData:GetNextExpireTimeInShow()
  if nextShowTime <= sectorIData:GetActivityEndTime() then
    self._countDownTime = sectorIData:GetNextExpireTimeInShow()
    ;
    (((self.ui).tex_Time).gameObject):SetActive(true)
    self._mulLineCountdownTimer = TimerManager:StartTimer(1, self.MulLineCountdown, self)
    self:MulLineCountdown()
  end
end

UINDiffLevelMulLineActSum21Canvas.MulLineCountdown = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self._countDownTime == nil then
    (((self.ui).tex_Time).gameObject):SetActive(false)
    TimerManager:StopTimer(self._mulLineCountdownTimer)
    self._mulLineCountdownTimer = nil
    return 
  end
  local coutdown = self._countDownTime - PlayerDataCenter.timestamp
  do
    if coutdown >= 0 then
      local str = TimeUtil:TimestampToTime(coutdown)
      ;
      ((self.ui).tex_Time):SetIndex(0, str)
      return 
    end
    local actId, sectorIData, inTime = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorId(self.sectorId)
    do
      if inTime then
        local nextShowTime = sectorIData:GetNextExpireTimeInShow()
        if nextShowTime <= sectorIData:GetActivityEndTime() then
          self._countDownTime = sectorIData:GetNextExpireTimeInShow()
          return 
        end
      end
      self._countDownTime = nil
      ;
      (((self.ui).tex_Time).gameObject):SetActive(false)
      TimerManager:StopTimer(self._mulLineCountdownTimer)
      self._mulLineCountdownTimer = nil
    end
  end
end

UINDiffLevelMulLineActSum21Canvas._CalculateScrollRectWidth = function(self)
  -- function num : 0_11 , upvalues : _ENV
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

UINDiffLevelMulLineActSum21Canvas.CalculateExtraCharterInfo = function(self, sectorIData)
  -- function num : 0_12 , upvalues : _ENV
  local chapterPosList = sectorIData:GetChapterPosList()
  if chapterPosList == nil then
    return 
  end
  self.extraCharpterTisInfoDic = {}
  for idx,pos in ipairs(chapterPosList) do
    if self.isVertical then
      local diff = pos[2]
      for i,lastLocalInfo in ipairs(self.lastLocalsDataList) do
        -- DECOMPILER ERROR at PC32: Confused about usage of register: R14 in 'UnsetPending'

        if lastLocalInfo.maxDistance < diff or i == #self.lastLocalsDataList then
          if not (self.extraCharpterTisInfoDic)[i] then
            do
              (self.extraCharpterTisInfoDic)[i] = {}
              -- DECOMPILER ERROR at PC39: Confused about usage of register: R14 in 'UnsetPending'

              ;
              ((self.extraCharpterTisInfoDic)[i])[idx] = {pos[1], diff}
              do break end
              diff = diff - lastLocalInfo.maxDistance
              -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC43: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    else
      do
        do
          local diff = pos[1]
          for i,lastLocalInfo in ipairs(self.lastLocalsDataList) do
            -- DECOMPILER ERROR at PC64: Confused about usage of register: R14 in 'UnsetPending'

            if diff < lastLocalInfo.maxDistance or i == #self.lastLocalsDataList then
              if not (self.extraCharpterTisInfoDic)[i] then
                do
                  (self.extraCharpterTisInfoDic)[i] = {}
                  -- DECOMPILER ERROR at PC71: Confused about usage of register: R14 in 'UnsetPending'

                  ;
                  ((self.extraCharpterTisInfoDic)[i])[idx] = {diff, pos[2]}
                  do break end
                  diff = diff - lastLocalInfo.maxDistance
                  -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC75: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
          -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

UINDiffLevelMulLineActSum21Canvas.ShowOrHideExtraCharterInfo = function(self, showPage, go, lastPage)
  -- function num : 0_13 , upvalues : _ENV
  local actId, sectorIData, inTime = (PlayerDataCenter.allActivitySectorIData):GetDataBySectorId(self.sectorId)
  if lastPage ~= nil and self.extraCharpterTisItemDic ~= nil then
    local lastOne = nil
    local extraCharpItemtDic = (self.extraCharpterTisItemDic)[lastPage]
    if extraCharpItemtDic ~= nil then
      for idx,item in pairs(extraCharpItemtDic) do
        (self.chapterItemPool):HideOne(item)
        if idx == 2 then
          ((self.ui).obj_clock):SetActive(false)
        end
      end
    end
  end
  do
    if showPage == nil or self.extraCharpterTisInfoDic == nil then
      return 
    end
    local extraCharpInfoDic = (self.extraCharpterTisInfoDic)[showPage]
    if extraCharpInfoDic == nil then
      return 
    end
    self.extraCharpterTisItemDic = {}
    local lastOne = nil
    for idx,pos in pairs(extraCharpInfoDic) do
      local item = (self.chapterItemPool):GetOne()
      ;
      (item.transform):SetParent(go.transform)
      ;
      (item.transform):SetAsFirstSibling()
      item:InitActChapterItem(idx, pos)
      -- DECOMPILER ERROR at PC70: Confused about usage of register: R15 in 'UnsetPending'

      if not (self.extraCharpterTisItemDic)[showPage] then
        do
          (self.extraCharpterTisItemDic)[showPage] = {}
          -- DECOMPILER ERROR at PC73: Confused about usage of register: R15 in 'UnsetPending'

          ;
          ((self.extraCharpterTisItemDic)[showPage])[idx] = item
          if idx == 2 then
            lastOne = item
          end
          -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC77: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    if lastOne == nil then
      return 
    end
    local unlock, timestamp = sectorIData:GetChapterHasUnlock()
    ;
    ((self.ui).obj_clock):SetActive(not unlock)
    if unlock then
      return 
    end
    ;
    (lastOne.transform):SetParent((self.ui).rect_cItemHolder)
    -- DECOMPILER ERROR at PC100: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (lastOne.transform).anchoredPosition = Vector2.zero
    local date = TimeUtil:TimestampToDate(timestamp, false, true)
    ;
    ((self.ui).tex_cUnlockTime):SetIndex(0, tostring(date.month), tostring(date.day))
  end
end

UINDiffLevelMulLineActSum21Canvas.SetChapterAndLockLayout = function(self, actId, sectorIData, inTimesectorIData)
  -- function num : 0_14
  if actId == nil or not inTimesectorIData then
    (self.chapterItemPool):HideAll()
    self.extraCharpterTisInfoDic = nil
    self.extraCharpterTisItemDic = nil
  end
end

UINDiffLevelMulLineActSum21Canvas.RefreshHardModeFx = function(self, difficulty)
  -- function num : 0_15 , upvalues : SectorLevelDetailEnum, cs_Material, _ENV
  if difficulty == (SectorLevelDetailEnum.eDifficulty).nightmare then
    if self.__NMBackgroundMat == nil then
      self.__NMBackgroundMat = cs_Material((self.ui).mat_uIM_rolo2)
    end
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).Img_background).material = self.__NMBackgroundMat
    if self.__NMBackgrounFx == nil then
      self.__NMBackgrounFx = ((self.ui).fXP_UI_SectorLevelMap2):Instantiate()
      ;
      ((self.__NMBackgrounFx).transform):SetParent(self.transform)
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.__NMBackgrounFx).transform).localScale = Vector3.one
      -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.__NMBackgrounFx).transform).localPosition = Vector3.zero
    end
    ;
    (self.__NMBackgrounFx):SetActive(true)
    ;
    ((self.ui).obj_redMask):SetActive(true)
  else
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).Img_background).material = nil
    if self.__NMBackgrounFx ~= nil then
      (self.__NMBackgrounFx):SetActive(false)
    end
    ;
    ((self.ui).obj_redMask):SetActive(false)
  end
end

UINDiffLevelMulLineActSum21Canvas.GetSectorDungeonItem = function(self, dungeonId)
  -- function num : 0_16
  return nil
end

UINDiffLevelMulLineActSum21Canvas.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityTimePass, self.__OnRefreshTimeDayPass)
  if self._mulLineCountdownTimer ~= nil then
    TimerManager:StopTimer(self._mulLineCountdownTimer)
    self._mulLineCountdownTimer = nil
  end
  if self.__NMBackgroundMat ~= nil then
    DestroyUnityObject(self.__NMBackgroundMat)
  end
  if self.__NMBackgrounFx ~= nil then
    DestroyUnityObject(self.__NMBackgrounFx)
  end
  self.resLoader = nil
  ;
  (self.chapterItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINDiffLevelMulLineActSum21Canvas

