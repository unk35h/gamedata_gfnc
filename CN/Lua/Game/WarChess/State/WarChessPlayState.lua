-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.State.Base.WarChessStateBase")
local WarChessPlayState = class("WarChessPlayState", base)
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_Physics = CS.PhysicsUtility
local cs_MessageCommon = CS.MessageCommon
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WarChessPlayState.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__CurSelectedTeamIndex = nil
  self.__isInteracting = false
  self.__isMovingTeam = false
  self.__moveTeamCallback = nil
  self.__moveOverCallback = nil
  self.__autoMoveCallback = nil
  self.__isMovingMonster = false
  self.__movingMonsterFuncDic = {}
  self.__isWaitingEntityAnimation = false
  self.__isPopingAPReduceAnimation = {}
  self.__isPressTeam = nil
  self.__pressTeam = nil
  self.__pressedTeamTime = nil
  self.__isWaitingTapAnotherTeam = nil
  self.__onTapAnotherTeamCallback = nil
  self.__isInCustomInput = false
  self.__customInputCallback = nil
  self.__onTeamMoveEndAction = BindCallback(self, self._WCMoveComplete)
  self.__onFingerTap = BindCallback(self, self.__OnFingerTap)
  self.__onFingerDown = BindCallback(self, self.__OnFingerDown)
  self.__onFingerSet = BindCallback(self, self.__OnFingerSet)
  self.__onFingerUp = BindCallback(self, self.__OnFingerUp)
  self.__onUpdate = BindCallback(self, self.__OnUpdate)
  self.__onInteractOver = BindCallback(self, self.__OnInteractOver)
  UpdateManager:AddUpdate(self.__onUpdate)
end

WarChessPlayState.OnEnterState = function(self)
  -- function num : 0_1 , upvalues : _ENV, CS_LeanTouch, eWarChessEnum
  self.__camMain = UIManager:GetMainCamera()
  ;
  (CS_LeanTouch.OnFingerTap)("+", self.__onFingerTap)
  ;
  (CS_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
  ;
  (CS_LeanTouch.OnFingerSet)("+", self.__onFingerSet)
  ;
  (CS_LeanTouch.OnFingerUp)("+", self.__onFingerUp)
  local teamData = nil
  if self.__CurSelectedTeamIndex ~= nil then
    teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
    MsgCenter:Broadcast(eMsgEventId.WC_SelectTeam, teamData)
  else
    ;
    ((self.wcCtrl).animaCtrl):UpdateWCSelectedFX(false)
    MsgCenter:Broadcast(eMsgEventId.WC_SelectTeam, nil)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessInfo, function(win)
    -- function num : 0_1_0 , upvalues : self
    if win ~= nil then
      win:InitWCInfo(self.wcCtrl)
    end
  end
)
  ;
  (UIUtil.AddOneCover)("WaitWCPlay")
  ;
  ((self.wcCtrl).teamCtrl):SetBornOverCallback(function()
    -- function num : 0_1_1 , upvalues : _ENV, self, eWarChessEnum, teamData
    (UIUtil.CloseOneCover)("WaitWCPlay")
    if (self.wcCtrl):GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle and ((self.wcCtrl).battleCtrl):GetIsInBattleScene() then
      return 
    end
    local globalData = WarChessManager:GetWCGlobalData()
    local enterPlayCount = globalData:GetEnterPlayCount()
    globalData:SetEnterPlayCount(enterPlayCount + 1)
    WarChessSeasonManager:OnWCEnterPlayState()
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessMain, function(win)
      -- function num : 0_1_1_0 , upvalues : self, eWarChessEnum, teamData, enterPlayCount, _ENV
      if (self.wcCtrl):GetWCSurSubSystemCat() == (eWarChessEnum.eSystemCat).battle then
        -- DECOMPILER ERROR at PC16: Unhandled construct in 'MakeBoolean' P1

        if ((self.wcCtrl).battleCtrl):GetIsInBattleScene() and win ~= nil then
          win:Delete()
        end
        return 
      end
      if win ~= nil then
        win:InitWarChessPlay(self, teamData)
      end
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R1 in 'UnsetPending'

      if enterPlayCount == 0 and not (self.wcCtrl):IsWCReconnected() then
        ((self.wcCtrl).teamCtrl).startPlayAnimaPlaying = true
        ;
        ((self.wcCtrl).palySquCtrl):AterEnterPlayState()
      end
      if GuideManager:TryTriggerGuide(eGuideCondition.WCLevelFirstStart) then
        WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCEnterPlay)
        WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCDynEnterPlay)
      end
    end
)
  end
)
end

WarChessPlayState.GetCurSelectedTeamData = function(self)
  -- function num : 0_2
  if self.__CurSelectedTeamIndex ~= nil then
    local teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
    return teamData
  end
end

WarChessPlayState.IsMovingMonster = function(self)
  -- function num : 0_3
  return self.__isMovingMonster
end

WarChessPlayState._WCMoveComplete = function(self)
  -- function num : 0_4
  self.__isMovingTeam = false
  local moveOverCallback = self.__moveOverCallback
  local autoMoveCallback = self.__autoMoveCallback
  self.__moveOverCallback = nil
  self.__autoMoveCallback = nil
  self.__moveTeamCallback = nil
  ;
  (self.wcCtrl):RunAllSystemChange()
  if moveOverCallback ~= nil then
    moveOverCallback()
  end
  if autoMoveCallback ~= nil then
    autoMoveCallback()
  end
end

WarChessPlayState.IsMovingTeam = function(self)
  -- function num : 0_5
  return self.__isMovingTeam
end

WarChessPlayState.__OnUpdate = function(self)
  -- function num : 0_6 , upvalues : _ENV
  do
    if self.__isMovingTeam and self.__moveTeamCallback ~= nil then
      local moveComplete = (self.__moveTeamCallback)()
      if moveComplete then
        TimerManager:AddLateCommand(self.__onTeamMoveEndAction)
        self.__moveTeamCallback = nil
      end
    end
    if self.__isMovingMonster then
      for entityId,moveUpdateFunc in pairs(self.__movingMonsterFuncDic) do
        local isFinish = moveUpdateFunc()
        -- DECOMPILER ERROR at PC27: Confused about usage of register: R7 in 'UnsetPending'

        if isFinish then
          (self.__movingMonsterFuncDic)[entityId] = nil
          if (table.count)(self.__movingMonsterFuncDic) <= 0 then
            self.__isMovingMonster = false
            ;
            (self.wcCtrl):RunAllSystemChange()
          end
        end
      end
    end
  end
end

WarChessPlayState.__OnFingerTap = function(self, finger)
  -- function num : 0_7
  if finger == nil or finger.StartedOverGui or finger.IsOverGui then
    return 
  end
  do
    -- DECOMPILER ERROR at PC19: Unhandled construct in 'MakeBoolean' P1

    if self.__isInCustomInput and self.__customInputCallback ~= nil then
      local pos = ((self.wcCtrl).inputCtrl):GetMouseCurentGroundPos()
      ;
      (self.__customInputCallback)(pos)
    end
    do return  end
    if self.__isMovingTeam or self:IsMovingMonster() or self.__isInteracting or self.__isWaitingEntityAnimation or (self.wcCtrl):IsWCInSubSystem() or ((self.wcCtrl).animaCtrl):GetIsPlayingAnimation() then
      return 
    end
    ;
    (((self.wcCtrl).inputCtrl):GetMouseCurentGroundPos())
    local pos = nil
    local isOK, logicPos = nil, nil
    if pos ~= nil then
      isOK = self:TrySelectTeam(pos)
      -- DECOMPILER ERROR at PC65: Overwrote pending register: R4 in 'AssignReg'

      if not isOK then
        isOK = self:TryClickGrid(pos)
      end
    end
    if not isOK then
      self:WCHideInteract()
      return 
    end
    ;
    ((self.wcCtrl).animaCtrl):UpdateWCSelectedFX(self.__CurSelectedTeamIndex ~= nil, logicPos)
    self:CheckWCGuideClick()
    if self.__isWaitingTapAnotherTeam then
      self:SetIsWaitingTapAnotherTeam(false)
      self.__onTapAnotherTeamCallback = nil
    end
    self.__isPressTeam = false
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

WarChessPlayState.__OnFingerDown = function(self, finger)
  -- function num : 0_8
  if finger == nil or finger.StartedOverGui or finger.IsOverGui then
    return 
  end
  if self.__isMovingTeam or self:IsMovingMonster() or self.__isInteracting or self.__isWaitingEntityAnimation or (self.wcCtrl):IsWCInSubSystem() or ((self.wcCtrl).animaCtrl):GetIsPlayingAnimation() then
    return 
  end
  local pos = ((self.wcCtrl).inputCtrl):GetMouseCurentGroundPos()
  local isOk, teamData = self:__TryGetTeamDataFromPos(pos)
  if isOk then
    self.__isPressTeam = true
    self.__pressTeam = teamData
    self.__pressedTeamTime = 0
  end
end

WarChessPlayState.__OnFingerSet = function(self, finger)
  -- function num : 0_9 , upvalues : _ENV
  if self.__isPressTeam then
    self.__pressedTeamTime = self.__pressedTeamTime + Time.deltaTime
    local wcLevelCfg = WarChessManager:GetWCLevelCfg()
    local couldExchangeTeams = wcLevelCfg.exchange
    if couldExchangeTeams and self.__pressedTeamTime > 0.2 then
      ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(false)
      local longPressTeamRate = self.__pressedTeamTime / (ConfigData.buildinConfig).WarchessLongPressTeamTime
      local fingerScreenPos = finger.ScreenPosition
      MsgCenter:Broadcast(eMsgEventId.WC_LongPressRateChange, longPressTeamRate, fingerScreenPos)
    end
  end
end

WarChessPlayState.__OnFingerUp = function(self, finger)
  -- function num : 0_10 , upvalues : _ENV
  if self.__isPressTeam then
    ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(true)
    local teamIndex = (self.__pressTeam):GetWCTeamIndex()
    if self.__CurSelectedTeamIndex == nil then
      self:WCPlayStateSelectTeam(self.__pressTeam)
    end
    local wcLevelCfg = WarChessManager:GetWCLevelCfg()
    local couldExchangeTeams = wcLevelCfg.exchange
    if couldExchangeTeams and (ConfigData.buildinConfig).WarchessLongPressTeamTime < self.__pressedTeamTime then
      if teamIndex == self.__CurSelectedTeamIndex then
        self:__PopTeamInteract()
      else
        self:__PopTeamInteract(self.__pressTeam)
      end
    end
  end
  do
    MsgCenter:Broadcast(eMsgEventId.WC_LongPressRateChange, nil)
    self.__isPressTeam = false
    self.__pressedTeamTime = 0
  end
end

WarChessPlayState.__TryGetTeamDataFromPos = function(self, pos)
  -- function num : 0_11 , upvalues : CS_Physics, _ENV
  local teamData = nil
  local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByGrounPos(nil, pos)
  do
    if gridData ~= nil then
      local logicPos = gridData:GetGridLogicPos()
      teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByLogicPos(logicPos)
    end
    if teamData == nil then
      local hits = (CS_Physics.Raycast)(self.__camMain, 1 << LayerMask.Character, true)
      for i = 0, hits.Length - 1 do
        local hitCollider = (hits[i]).transform
        if not IsNull(hitCollider) then
          teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByGo(((hitCollider.transform).parent).gameObject)
          if teamData == nil then
            return false
          else
            break
          end
        end
      end
    end
    do
      if teamData == nil then
        return false
      end
      return true, teamData
    end
  end
end

WarChessPlayState.TrySelectTeam = function(self, pos)
  -- function num : 0_12
  local isOk, teamData = self:__TryGetTeamDataFromPos(pos)
  if not isOk then
    return false
  end
  local logicPos = teamData:GetWCTeamLogicPos()
  if not self:IsCorrectGuideClick(logicPos) then
    return false
  end
  if self.__isWaitingTapAnotherTeam then
    (self.__onTapAnotherTeamCallback)(teamData)
    return true, logicPos
  end
  self:WCPlayStateSelectTeam(teamData)
  return true, logicPos
end

WarChessPlayState.WCPlayStateSelectTeam = function(self, teamData, dontDisSelect, isForce)
  -- function num : 0_13 , upvalues : _ENV
  if not isForce and (self.__isMovingTeam or self.__isInteracting or (self.wcCtrl):IsWCInSubSystem()) then
    return false
  end
  if self.__isWaitingTapAnotherTeam then
    self:SetIsWaitingTapAnotherTeam(false)
    self.__onTapAnotherTeamCallback = nil
  end
  local teamIndex = teamData:GetWCTeamIndex()
  if self.__CurSelectedTeamIndex ~= teamIndex then
    self.__CurSelectedTeamIndex = teamIndex
    MsgCenter:Broadcast(eMsgEventId.WC_SelectTeam, teamData)
  else
    if dontDisSelect then
      return true, true
    end
    self:WCPlayDeselectTeam()
  end
  self:WCHideInteract()
  return true, false
end

WarChessPlayState.WCPlayDeselectTeam = function(self)
  -- function num : 0_14 , upvalues : _ENV
  self.__CurSelectedTeamIndex = nil
  MsgCenter:Broadcast(eMsgEventId.WC_SelectTeam, nil)
end

WarChessPlayState.__PopTeamInteract = function(self, targetTeamData)
  -- function num : 0_15 , upvalues : _ENV
  local sourceTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
  local win_wcInfo = UIManager:GetWindow(UIWindowTypeID.WarChessInfo)
  if win_wcInfo == nil then
    return false
  end
  local actCallback = function()
    -- function num : 0_15_0 , upvalues : targetTeamData, self, _ENV
    if targetTeamData ~= nil then
      self:__TeamExchangePos(targetTeamData)
      return 
    end
    self:SetIsWaitingTapAnotherTeam(true)
    self.__onTapAnotherTeamCallback = BindCallback(self, self.__TeamExchangePos)
  end

  local costAP = 0
  local typeIndex = 4
  self.__isPopedData = nil
  if targetTeamData ~= nil then
    win_wcInfo:PopCustomInteractUI(targetTeamData, actCallback, costAP, typeIndex)
  else
    win_wcInfo:PopCustomInteractUI(sourceTeamData, actCallback, costAP, typeIndex)
  end
end

WarChessPlayState.__TeamExchangePos = function(self, targetTeamData)
  -- function num : 0_16 , upvalues : _ENV
  local sourceTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
  if targetTeamData == sourceTeamData then
    self:SetIsWaitingTapAnotherTeam(false)
    return 
  end
  local s_wid, s_tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(sourceTeamData)
  local t_wid, t_tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(targetTeamData)
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_WarChessExchangePos(s_wid, s_tid, t_wid, t_tid, function()
    -- function num : 0_16_0 , upvalues : self, sourceTeamData, targetTeamData, _ENV
    (sourceTeamData:GetWCTeamIndex())
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    local sorceHeroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity(sourceTeamData:GetWCTeamIndex, nil, nil)
    local sourceTeamPos = sorceHeroEntity:WCHeroEntityGetShowPos()
    local targetHeroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity((targetTeamData:GetWCTeamIndex()), nil, nil)
    local targetTeamPos = targetHeroEntity:WCHeroEntityGetShowPos()
    ;
    ((self.wcCtrl).wcCamCtrl):SetWcCamFollowPos(sourceTeamPos)
    ;
    ((self.wcCtrl).teamCtrl):ReSetTeamStandGridData()
    ;
    ((self.wcCtrl).teamCtrl):CalTeamCouldMoveGridDic(sourceTeamData)
    ;
    ((self.wcCtrl).teamCtrl):CalTeamCouldMoveGridDic(targetTeamData)
    local fxGo_t = ((self.wcCtrl).animaCtrl):ShowWCEffect("FXP_CSMBlueIn", targetTeamPos)
    local fxGo_s = ((self.wcCtrl).animaCtrl):ShowWCEffect("FXP_CSMBlueIn", sourceTeamPos)
    TimerManager:StartTimer(5, function()
      -- function num : 0_16_0_0 , upvalues : self, fxGo_t, fxGo_s
      if self.wcCtrl == nil or (self.wcCtrl).animaCtrl == nil then
        return 
      end
      ;
      ((self.wcCtrl).animaCtrl):RecycleWCEffect("FXP_CSMBlueIn", fxGo_t)
      ;
      ((self.wcCtrl).animaCtrl):RecycleWCEffect("FXP_CSMBlueIn", fxGo_s)
    end
, self, true)
  end
)
end

WarChessPlayState.TryClickGrid = function(self, pos)
  -- function num : 0_17 , upvalues : _ENV, cs_MessageCommon
  local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByGrounPos(nil, pos)
  if gridData == nil then
    AudioManager:PlayAudioById(1243)
    return false
  end
  local logicPos = gridData:GetGridLogicPos()
  if not self:IsCorrectGuideClick(logicPos) then
    return false
  end
  local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPos(nil, logicPos)
  if self.__CurSelectedTeamIndex ~= nil then
    local teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
    if teamData == nil then
      return false
    end
    do
      if entityData ~= nil then
        local isOK = self:__PopEntityInteract(entityData, teamData)
        if isOK then
          return true, logicPos
        end
      end
      local isOK = self:__PopGridInteract(gridData, teamData)
      if isOK then
        return true, logicPos
      end
      do
        local isOK = self:Walk2Grid(gridData, nil)
        if isOK then
          self:WCHideInteract()
          return true, logicPos
        else
          AudioManager:PlayAudioById(1243)
          ;
          (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8510))
        end
        do
          if entityData ~= nil then
            local isOK = self:__PopEntityInteract(entityData, nil)
            if isOK then
              return true, logicPos
            end
          end
          local isOK = self:__PopGridInteract(gridData, nil)
          if isOK then
            return true, logicPos
          end
        end
      end
    end
  end
end

WarChessPlayState.Walk2Grid = function(self, gridData, moveOverCallback, isAutoMove)
  -- function num : 0_18 , upvalues : _ENV
  local isOK, moveTeamCallback = ((self.wcCtrl).teamCtrl):MoveWCTeam2Grid(self.__CurSelectedTeamIndex, gridData)
  if isOK then
    local teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamIndex(self.__CurSelectedTeamIndex)
    local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
    self.__isMovingTeam = true
    if isAutoMove then
      self.__moveTeamCallback = moveTeamCallback
      self.__moveOverCallback = moveOverCallback
      return true
    end
    ;
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_MoveTo(wid, tid, gridData, function(argList)
    -- function num : 0_18_0 , upvalues : _ENV, self, moveTeamCallback, moveOverCallback
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    if isSucess then
      self.__moveTeamCallback = moveTeamCallback
      self.__moveOverCallback = moveOverCallback
    else
      self.__isMovingTeam = false
    end
  end
)
    return true
  end
  do
    if moveOverCallback ~= nil then
      moveOverCallback()
    end
    return false
  end
end

WarChessPlayState.Turn2Grid = function(self, gridData, moveOverCallback)
  -- function num : 0_19
  local isOK, moveTeamCallback = ((self.wcCtrl).teamCtrl):SetTeamFace2Grid(self.__CurSelectedTeamIndex, gridData)
  if isOK then
    self.__moveTeamCallback = moveTeamCallback
    self.__isMovingTeam = true
    self.__moveOverCallback = moveOverCallback
    return true
  end
  if moveOverCallback ~= nil then
    moveOverCallback()
  end
  return false
end

WarChessPlayState.SeTryAutoMoveMoverOverCallback = function(self, callback)
  -- function num : 0_20
  self.__autoMoveCallback = callback
end

WarChessPlayState.__OnInteractOver = function(self)
  -- function num : 0_21
  self.__isInteracting = false
end

WarChessPlayState.__PopEntityInteract = function(self, entityData, teamData)
  -- function num : 0_22 , upvalues : _ENV, cs_MessageCommon
  local win_wcInfo = UIManager:GetWindow(UIWindowTypeID.WarChessInfo)
  if win_wcInfo == nil then
    return false
  end
  local interacts = entityData:GetEntityInteractions()
  local unit = entityData:GetEntityUnit()
  local isOK = win_wcInfo:PopInteractUI(interacts, entityData, unit, teamData, function(interactCfg, isAutoOpenInfo)
    -- function num : 0_22_0 , upvalues : self, teamData, _ENV, cs_MessageCommon, entityData
    if not isAutoOpenInfo then
      self.__isPopedData = nil
    end
    ;
    ((self.wcCtrl).mapCtrl):TryShowWCMonsterCouldMoveRange(false)
    local costAP = ((self.wcCtrl).interactCtrl):GetWCIneractionAPCost(interactCfg)
    if teamData ~= nil and teamData:GetTeamActionPoint() < costAP then
      AudioManager:PlayAudioById(1245)
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8519))
      return 
    end
    local curOver = false
    local isSubOk = ((self.wcCtrl).interactCtrl):WCDealEntityInteract(entityData, teamData, interactCfg, function()
      -- function num : 0_22_0_0 , upvalues : self, curOver, teamData, _ENV, entityData
      self:__onInteractOver()
      curOver = true
      if teamData ~= nil then
        ((self.wcCtrl).animaCtrl):UpdateWCSelectedFX(true, teamData:GetWCTeamLogicPos())
      end
      MsgCenter:Broadcast(eMsgEventId.WC_EntityInfoUpdate, entityData)
    end
)
    if isSubOk then
      if curOver then
        return 
      end
      self.__isInteracting = true
    else
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8510))
    end
  end
)
  if isOK then
    if self.__CurSelectedTeamIndex == nil then
      ((self.wcCtrl).mapCtrl):TryShowWCMonsterCouldMoveRange(true, entityData)
    end
    if self.__isPopedData ~= nil and self.__isPopedData == entityData then
      (win_wcInfo.OPNode):WCOpDoubleClick()
      self.__isPopedData = nil
    else
      if teamData ~= nil then
        self.__isPopedData = entityData
      end
    end
  end
  return isOK
end

WarChessPlayState.__PopGridInteract = function(self, gridData, teamData)
  -- function num : 0_23 , upvalues : _ENV, cs_MessageCommon
  local win_wcInfo = UIManager:GetWindow(UIWindowTypeID.WarChessInfo)
  if win_wcInfo == nil then
    return false
  end
  local interacts = gridData:GetGridInteractions()
  local unit = gridData:GetGridUnit()
  local isOK = win_wcInfo:PopInteractUI(interacts, gridData, unit, teamData, function(interactCfg, isAutoOpenInfo)
    -- function num : 0_23_0 , upvalues : self, teamData, _ENV, cs_MessageCommon, gridData
    if not isAutoOpenInfo then
      self.__isPopedData = nil
    end
    local costAP = ((self.wcCtrl).interactCtrl):GetWCIneractionAPCost(interactCfg)
    if teamData ~= nil and teamData:GetTeamActionPoint() < costAP then
      AudioManager:PlayAudioById(1245)
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8519))
      return 
    end
    local curOver = false
    local isSubOk = ((self.wcCtrl).interactCtrl):WCDealGridInteract(gridData, teamData, interactCfg, function()
      -- function num : 0_23_0_0 , upvalues : self, curOver, teamData, _ENV, gridData
      self:__onInteractOver()
      curOver = true
      if teamData ~= nil then
        ((self.wcCtrl).animaCtrl):UpdateWCSelectedFX(true, teamData:GetWCTeamLogicPos())
      end
      MsgCenter:Broadcast(eMsgEventId.WC_GridInfoUpdate, gridData)
    end
)
    if isSubOk then
      if curOver then
        return 
      end
      self.__isInteracting = true
    else
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8510))
    end
  end
)
  if isOK then
    if self.__isPopedData ~= nil and self.__isPopedData == gridData then
      (win_wcInfo.OPNode):WCOpDoubleClick()
      self.__isPopedData = nil
    else
      if teamData ~= nil then
        self.__isPopedData = gridData
      end
    end
  end
  return isOK
end

WarChessPlayState.WCHideInteract = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local win_wcInfo = UIManager:GetWindow(UIWindowTypeID.WarChessInfo)
  if win_wcInfo == nil then
    return false
  end
  ;
  (win_wcInfo.OPNode):Hide()
  ;
  (win_wcInfo.MonsterTagNode):Hide()
  win_wcInfo:HideShowInfo()
  self.__isPopedData = nil
  ;
  ((self.wcCtrl).mapCtrl):TryShowWCMonsterCouldMoveRange(false)
end

WarChessPlayState.WCAddMonsterMove = function(self, entityId, moveUpdateFunc)
  -- function num : 0_25
  if self.__movingMonsterFuncDic == nil then
    self.__movingMonsterFuncDic = {}
  end
  self.__isMovingMonster = true
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__movingMonsterFuncDic)[entityId] = moveUpdateFunc
end

WarChessPlayState.SetWCGridClickGuide = function(self, x, y, endAction)
  -- function num : 0_26
  self._clickGuide = {x = x, y = y, guideAction = endAction, complete = false}
end

WarChessPlayState.IsCorrectGuideClick = function(self, pos)
  -- function num : 0_27
  if self._clickGuide == nil then
    return true
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  if pos.x == (self._clickGuide).x and pos.y == (self._clickGuide).y then
    (self._clickGuide).complete = true
    return true
  end
  return false
end

WarChessPlayState.CheckWCGuideClick = function(self)
  -- function num : 0_28
  if self._clickGuide == nil or (self._clickGuide).complete ~= true then
    return 
  end
  local action = (self._clickGuide).guideAction
  self._clickGuide = nil
  if action ~= nil then
    action()
  end
end

WarChessPlayState.SetIsWaitingEntityAnimation = function(self, bool)
  -- function num : 0_29
  self.__isWaitingEntityAnimation = bool
end

WarChessPlayState.GetIsWaitingEntityAnimation = function(self)
  -- function num : 0_30
  return self.__isWaitingEntityAnimation
end

WarChessPlayState.SetIsWaitingAPReduceAnimation = function(self, teamIndex, bool)
  -- function num : 0_31
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.__isPopingAPReduceAnimation)[teamIndex] = bool
  ;
  (self.wcCtrl):RunAllSystemChange()
end

WarChessPlayState.GetIsWaitingAPReduceAnimation = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local isHaveWait = false
  for teamIndex,bool in pairs(self.__isPopingAPReduceAnimation) do
    if bool then
      isHaveWait = true
      break
    end
  end
  do
    return isHaveWait
  end
end

WarChessPlayState.SetIsWaitingTapAnotherTeam = function(self, bool)
  -- function num : 0_33 , upvalues : cs_MessageCommon, _ENV
  self.__isWaitingTapAnotherTeam = bool
  if bool then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8529))
  end
  ;
  ((self.wcCtrl).animaCtrl):SetCouldShowMoveableFX(not bool)
  local teamDataDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  for _,teamData in pairs(teamDataDic) do
    local teamIndex = teamData:GetWCTeamIndex()
    local heroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity(teamIndex, nil, nil)
    local teamPos = heroEntity:WCHeroEntityGetShowPos()
    do
      do
        -- DECOMPILER ERROR at PC48: Unhandled construct in 'MakeBoolean' P1

        if (not bool or teamIndex ~= self.__CurSelectedTeamIndex) and bool and heroEntity.couldSelectFxGo == nil then
          local fxGo = ((self.wcCtrl).animaCtrl):ShowWCEffect("FXP_BornPositionLoop", teamPos)
          heroEntity.couldSelectFxGo = fxGo
        end
        if heroEntity.couldSelectFxGo ~= nil then
          ((self.wcCtrl).animaCtrl):RecycleWCEffect("FXP_BornPositionLoop", heroEntity.couldSelectFxGo)
          heroEntity.couldSelectFxGo = nil
        end
        -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

WarChessPlayState.SetWCCustomInput = function(self, isOpen, callback)
  -- function num : 0_34 , upvalues : _ENV
  if self.__isInCustomInput == isOpen and isOpen then
    warn("custom input callback may not correct: corverd by other custom input")
  end
  self.__isInCustomInput = isOpen
  self.__customInputCallback = callback
end

WarChessPlayState.OnExitState = function(self)
  -- function num : 0_35 , upvalues : CS_LeanTouch, _ENV
  (CS_LeanTouch.OnFingerTap)("-", self.__onFingerTap)
  ;
  (CS_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
  ;
  (CS_LeanTouch.OnFingerSet)("-", self.__onFingerSet)
  ;
  (CS_LeanTouch.OnFingerUp)("-", self.__onFingerUp)
  self.__isMovingTeam = false
  self.__isMovingMonster = false
  self.__moveTeamCallback = nil
  self.__moveOverCallback = nil
  self.__movingMonsterFuncDic = nil
  ;
  (UIUtil.CloseOneCover)("WaitWCPlay")
  UIManager:HideWindow(UIWindowTypeID.WarChessInfo)
  UIManager:HideWindow(UIWindowTypeID.WarChessMain)
end

WarChessPlayState.IsCanOpenMenu = function(self)
  -- function num : 0_36
  if self.__isMovingTeam or self:IsMovingMonster() or self.__isInteracting or self.__isWaitingEntityAnimation or (self.wcCtrl):IsWCInSubSystem() or ((self.wcCtrl).animaCtrl):GetIsPlayingAnimation() then
    return false
  end
  return true
end

return WarChessPlayState

