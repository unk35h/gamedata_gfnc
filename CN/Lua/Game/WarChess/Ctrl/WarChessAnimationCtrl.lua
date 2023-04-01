-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessAnimationCtrl = class("WarChessAnimationCtrl", base)
local cs_Animations = (CS.UnityEngine).Animations
local cs_ResLoader = CS.ResLoader
local util = require("XLua.Common.xlua_util")
local Stack = require("Framework.Lib.Stack")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eUnitCat = eWarChessEnum.eUnitCat
local WarChessFXData = require("Game.WarChess.Data.WarChessFXData")
WarChessAnimationCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.resloader = (cs_ResLoader.Create)()
  self.__isLoadOver = false
  self.__isPlayingAnimationOfFX = false
  self.__isPlayingTip = false
  self.__isInMovieMode = false
  self.__effectPoolDic = {}
  self.__effectPrefabDic = {}
  self.__bornFxDic = {}
  self.__moveableFxDic = {}
  self.__monsterMoveableFxDic = {}
  self.__monsterAlarmFxDic = {}
  self.__monsterLinkFxDic = {}
  self.__curMoveableGridDic = nil
  self.__commonFxDic = {}
  self.__teamBindFxResDic = {}
  self.__teamBindFxDic = {}
  self.__needRefreshFxNum = 0
  self.__PlayAnimationFxDic = {}
  self.__waitPlayDic = {}
  self.__couldShowMoveableFX = true
  self.__onCameraMove = BindCallback(self, self.__OnCameraMove)
  MsgCenter:AddListener(eMsgEventId.WC_CameraMove, self.__onCameraMove)
  self.__onDeployTeamChange = BindCallback(self, self.__OnDeployTeamChange)
  MsgCenter:AddListener(eMsgEventId.WC_DeployTeamChange, self.__onDeployTeamChange)
  self.__onSelectTeam = BindCallback(self, self.__OnSelectTeam)
  MsgCenter:AddListener(eMsgEventId.WC_SelectTeam, self.__onSelectTeam)
  self.__onEntityUpdate = BindCallback(self, self.__OnEntityUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_EntityInfoUpdate, self.__onEntityUpdate)
end

WarChessAnimationCtrl.AddWCAnimationWaitPlay = function(self, key)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__waitPlayDic)[key] = true
end

WarChessAnimationCtrl.RemoveWCAnimationWaitPlay = function(self, key)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__waitPlayDic)[key] = nil
  self:PlayWCAllShow()
end

WarChessAnimationCtrl.PlayWCAllShow = function(self)
  -- function num : 0_3 , upvalues : _ENV, WarChessHelper, util
  if (table.count)(self.__waitPlayDic) > 0 then
    return 
  end
  local PlayAllShowGroup = function()
    -- function num : 0_3_0 , upvalues : self, _ENV, WarChessHelper
    self.__isPlayingAnimationOfFX = true
    ;
    ((self.wcCtrl).wcCamCtrl):RecordCamCurPos()
    ;
    ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(false)
    ;
    ((self.wcCtrl).wcCamCtrl):ShowWcCamCanUIClickBlock()
    local groupList = {}
    for groupId,groupData in pairs(self.__PlayAnimationFxDic) do
      (table.insert)(groupList, groupId)
    end
    ;
    (table.sort)(groupList)
    local focusedFlag = false
    for index,groupId in ipairs(groupList) do
      local groupData = (self.__PlayAnimationFxDic)[groupId]
      if groupId == 0 then
        for _,playFunc in pairs(groupData.playFuncList) do
          playFunc()
        end
      else
        do
          do
            do
              if not self.__isPlayingTip and not focusedFlag then
                local foucusPos = nil
                for _,pos in pairs(groupData.foucusPosList) do
                  local x, y = (WarChessHelper.Coordination2Pos)(pos)
                  if foucusPos == nil then
                    foucusPos = (Vector3.New)(x, 0, y)
                  else
                    foucusPos = (foucusPos + (Vector3.New)(x, 0, y)) / 2
                  end
                end
                ;
                ((self.wcCtrl).wcCamCtrl):SetWcCamFollowPos(foucusPos)
                focusedFlag = true
                ;
                (coroutine.yield)(((CS.UnityEngine).WaitForSeconds)(0.5))
              end
              for _,playFunc in pairs(groupData.playFuncList) do
                playFunc()
              end
              ;
              (coroutine.yield)(((CS.UnityEngine).WaitForSeconds)(1.5))
              -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC111: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
    self.__isPlayingAnimationOfFX = false
    ;
    ((self.wcCtrl).wcCamCtrl):RecorverCamPos()
    ;
    ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(true)
    ;
    ((self.wcCtrl).wcCamCtrl):CloseWcCamCanUIClickBlock()
    self.__playAllShowCo = nil
    self.__PlayAnimationFxDic = {}
  end

  self.__playAllShowCo = (GR.StartCoroutine)((util.cs_generator)(PlayAllShowGroup))
end

WarChessAnimationCtrl.__AddShowGroup = function(self, groupId, foucusPos, playFunc)
  -- function num : 0_4 , upvalues : _ENV
  if not groupId then
    groupId = 0
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  if (self.__PlayAnimationFxDic)[groupId] == nil then
    (self.__PlayAnimationFxDic)[groupId] = {
playFuncList = {}
, 
foucusPosList = {}
}
  end
  ;
  (table.insert)(((self.__PlayAnimationFxDic)[groupId]).playFuncList, playFunc)
  ;
  (table.insert)(((self.__PlayAnimationFxDic)[groupId]).foucusPosList, foucusPos)
end

WarChessAnimationCtrl.UpdateAnimations = function(self, unitAnimationClips)
  -- function num : 0_5 , upvalues : _ENV, WarChessHelper, eUnitCat
  for _,UnitAnimationClip in ipairs(unitAnimationClips) do
    do
      local groupId = UnitAnimationClip.groupId
      local pos = (UnitAnimationClip.pos).pos
      self:__AddShowGroup(groupId, pos, function()
    -- function num : 0_5_0 , upvalues : UnitAnimationClip, WarChessHelper, _ENV, eUnitCat, self
    local gid = (UnitAnimationClip.pos).gid
    local pos = (UnitAnimationClip.pos).pos
    local entityCat = UnitAnimationClip.entityCat
    local animaId = UnitAnimationClip.id & 255
    local animaTrigger = UnitAnimationClip.id & 256 > 0
    local x, y = (WarChessHelper.Coordination2Pos)(pos)
    local logicPos = (Vector2.New)(x, y)
    if entityCat == eUnitCat.entity then
      local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPos(gid, logicPos)
      if entityData ~= nil then
        entityData:PlayEntityAnimation(animaId, animaTrigger)
        ;
        (self.PlayAniSound)(animaId, entityData:GetWcEntityAniAudioDic())
        if isGameDev then
          print(tostring(entityData:GetEntityLogicPos()) .. "entity play animation:" .. tostring(animaId))
        end
      end
    elseif entityCat == eUnitCat.grid then
      local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(gid, logicPos)
      if gridData ~= nil then
        local gridGo = ((self.wcCtrl).mapCtrl):GetAreaObjectByGridData(gridData)
        if not IsNull(gridGo) then
          local gridGoAnimState = gridGo:GetComponentInChildren(typeof(CS.WarChessGridAnimState))
          if gridGoAnimState ~= nil then
            gridGoAnimState:SetStageValue(animaId)
            ;
            (self.PlayAniSound)(animaId, gridData:GetWcGridAniAudioDic())
            if animaTrigger then
              gridGoAnimState:Tigger()
            end
            local nameHash = gridGoAnimState:GetCurrentStateNameHash()
            gridData:SaveGridAnimArg(nameHash, animaId)
            if isGameDev then
              print(tostring(gridData:GetGridLogicPos()) .. "grid play animation:" .. tostring(animaId))
            end
          end
        end
      end
    end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
    end
  end
end

WarChessAnimationCtrl.PlayAniSound = function(animaId, aniAudioDic)
  -- function num : 0_6 , upvalues : _ENV
  if aniAudioDic == nil or aniAudioDic[animaId] == nil then
    return 
  end
  AudioManager:PlayAudioById(aniAudioDic[animaId])
end

WarChessAnimationCtrl.GetIsPlayingAnimation = function(self)
  -- function num : 0_7
  return self.__isPlayingAnimationOfFX
end

WarChessAnimationCtrl.UpdateWCTip = function(self, tipsDiffMsg)
  -- function num : 0_8 , upvalues : _ENV, eWarChessEnum
  for _,tipsDiff in ipairs(tipsDiffMsg) do
    local cat = tipsDiff.cat
    do
      local pm1 = tipsDiff.pm1
      if cat == 1 then
        local callback = nil
        callback = function()
    -- function num : 0_8_0 , upvalues : _ENV, pm1, self, eWarChessEnum, cat, callback
    local tipCfgs = (ConfigData.warchess_tip)[pm1]
    if tipCfgs == nil then
      error("war chess tipCfgs not exist tip parament:" .. tostring(pm1))
      return 
    end
    self.__isPlayingTip = true
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessTalkDialog, function(window)
      -- function num : 0_8_0_0 , upvalues : tipCfgs, self, pm1, _ENV, eWarChessEnum, cat
      if window ~= nil then
        window:InitWCMiniTV(tipCfgs, function()
        -- function num : 0_8_0_0_0 , upvalues : self, pm1, _ENV, eWarChessEnum, cat
        self.__isPlayingTip = false
        ;
        ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_AvgOver(pm1, 2)
        WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCTipPlayOver, nil, nil, cat << 32 | pm1)
      end
)
      end
    end
)
    ;
    ((self.wcCtrl).teamCtrl):StartPlayEventsRemove(callback)
  end

        if ((self.wcCtrl).teamCtrl).startPlayAnimaPlaying then
          ((self.wcCtrl).teamCtrl):StartPlayEventsAdd(callback)
        else
          callback()
        end
      else
        do
          if cat == 2 then
            local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
            avgCtrl:StartAvg(nil, pm1, function()
    -- function num : 0_8_1 , upvalues : self, pm1, _ENV, eWarChessEnum, cat
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_AvgOver(pm1, 1)
    WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCTipPlayOver, nil, nil, cat << 32 | pm1)
  end
)
          else
            do
              if pm1 ~= 1 then
                local isOpen = cat ~= 3
                if isOpen then
                  UIManager:ShowWindow(UIWindowTypeID.MovieBlack)
                  UIManager:HideWindow(UIWindowTypeID.WarChessMain)
                  UIManager:HideWindow(UIWindowTypeID.WarChessInfo)
                  self.__isInMovieMode = true
                else
                  local mianWin = UIManager:GetWindow(UIWindowTypeID.WarChessMain)
                  local infoWin = UIManager:GetWindow(UIWindowTypeID.WarChessInfo)
                  if mianWin ~= nil then
                    mianWin:Show()
                  end
                  if infoWin ~= nil then
                    infoWin:Show()
                  end
                  local win = UIManager:GetWindow(UIWindowTypeID.MovieBlack)
                  if win ~= nil then
                    win:SlowClose(1, function()
    -- function num : 0_8_2 , upvalues : self
    self.__isInMovieMode = false
  end
)
                  end
                end
                -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
          -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

WarChessAnimationCtrl.UpdateWCFXs = function(self, unitFxes)
  -- function num : 0_9 , upvalues : _ENV, WarChessHelper, eUnitCat, WarChessFXData
  for _,unitFx in ipairs(unitFxes) do
    local groupId = unitFx.groupId
    do
      local pos = (unitFx.pos).pos
      local x, y = (WarChessHelper.Coordination2Pos)(pos)
      local logicPos = (Vector2.New)(x, y)
      local gid = (unitFx.pos).gid
      local entityCat = unitFx.entityCat
      local fxId = unitFx.id
      local isDelete = unitFx.isDelete
      local isOnce = unitFx.isOnce
      local isBind = unitFx.isBind
      local RunFunc = nil
      if entityCat == eUnitCat.entity then
        local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPos(gid, logicPos)
        if entityData ~= nil then
          local fxDic = entityData:GetFxDataDic()
          do
            if isDelete then
              local fxData = fxDic[fxId]
              if fxData ~= nil then
                fxDic[fxId] = nil
                local moveableFX = (self.__commonFxDic)[fxData]
                if moveableFX ~= nil then
                  RunFunc = function()
    -- function num : 0_9_0 , upvalues : self, fxData, moveableFX
    self:RecycleWCEffect(fxData:GetWCFxResName(), moveableFX)
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.__commonFxDic)[fxData] = nil
  end

                end
              end
            else
              do
                if fxDic[fxId] == nil then
                  local fxData = (WarChessFXData.New)(false, fxId, isOnce, isBind, entityData)
                  fxDic[fxId] = fxData
                  local showPos = entityData:GetEntityShowPos()
                  RunFunc = function()
    -- function num : 0_9_1 , upvalues : isBind, _ENV, isOnce, self, fxData, showPos, fxDic, fxId
    if isBind then
      warn("bind effect not support yet")
    else
      if isOnce then
        local effectGo = self:ShowWCEffect(fxData:GetWCFxResName(), showPos)
        do
          (self.PlayEffSound)(fxData:GetWCFxAudioId())
          -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

          ;
          (self.__commonFxDic)[fxData] = effectGo
          self:UpdateWCEffect(fxData)
          TimerManager:StartTimer(5, function()
      -- function num : 0_9_1_0 , upvalues : self, fxData, effectGo, fxDic, fxId
      self:RecycleWCEffect(fxData:GetWCFxResName(), effectGo)
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.__commonFxDic)[fxData] = nil
      fxDic[fxId] = nil
    end
, self, true)
        end
      end
    end
  end

                end
              end
            end
            do
              if entityCat == eUnitCat.grid then
                local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(gid, logicPos)
                if gridData ~= nil then
                  local fxDic = gridData:GetFxDataDic()
                  if isDelete then
                    local fxData = fxDic[fxId]
                    if fxData ~= nil then
                      fxDic[fxId] = nil
                      RunFunc = function()
    -- function num : 0_9_2 , upvalues : self, fxData
    local moveableFX = (self.__commonFxDic)[fxData]
    if moveableFX ~= nil then
      self:RecycleWCEffect(fxData:GetWCFxResName(), moveableFX)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

      ;
      (self.__commonFxDic)[fxData] = nil
    end
  end

                    end
                  else
                    do
                      do
                        do
                          if fxDic[fxId] == nil then
                            local fxData = (WarChessFXData.New)(true, fxId, isOnce, isBind, gridData)
                            fxDic[fxId] = fxData
                            local showPos = gridData:GetGridShowPos()
                            RunFunc = function()
    -- function num : 0_9_3 , upvalues : isOnce, self, fxData, showPos, _ENV, fxDic, fxId
    if isOnce then
      local effectGo = self:ShowWCEffect(fxData:GetWCFxResName(), showPos)
      do
        (self.PlayEffSound)(fxData:GetWCFxAudioId())
        -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

        ;
        (self.__commonFxDic)[fxData] = effectGo
        self:UpdateWCEffect(fxData)
        TimerManager:StartTimer(5, function()
      -- function num : 0_9_3_0 , upvalues : self, fxData, effectGo, fxDic, fxId
      self:RecycleWCEffect(fxData:GetWCFxResName(), effectGo)
      -- DECOMPILER ERROR at PC9: Confused about usage of register: R0 in 'UnsetPending'

      ;
      (self.__commonFxDic)[fxData] = nil
      fxDic[fxId] = nil
    end
, self, true)
      end
    end
  end

                          end
                          gridData, fxDic = self:__AddShowGroup, self
                          gridData(fxDic, groupId, pos, function()
    -- function num : 0_9_4 , upvalues : RunFunc, self
    if RunFunc ~= nil then
      RunFunc()
    end
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshVisableFX(curView)
    end
  end
)
                        end
                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out IF_STMT

                        -- DECOMPILER ERROR at PC115: LeaveBlock: unexpected jumping out DO_STMT

                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

WarChessAnimationCtrl.PlayEffSound = function(audioId)
  -- function num : 0_10 , upvalues : _ENV
  if audioId == nil then
    return 
  end
  if audioId > 0 then
    AudioManager:PlayAudioById(audioId)
  end
end

WarChessAnimationCtrl.ShowWCEffect = function(self, effectName, showPos, bindGo)
  -- function num : 0_11 , upvalues : _ENV
  if (string.IsNullOrEmpty)(effectName) then
    error("fx name is nill pos:" .. tostring(showPos))
    return nil
  end
  local effectRoot = ((self.wcCtrl).bind).trans_effectRoot
  local stack = (self.__effectPoolDic)[effectName]
  local effectGo = nil
  if stack ~= nil and not stack:Empty() then
    effectGo = stack:Pop()
  else
    local effectPrefab = (self.__effectPrefabDic)[effectName]
    if effectPrefab == nil then
      effectPrefab = (self.resloader):LoadABAsset(PathConsts:GetWarChessEffectPrefabPath(effectName))
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.__effectPrefabDic)[effectName] = effectPrefab
    end
    effectGo = effectPrefab:Instantiate(effectRoot)
  end
  do
    if IsNull(effectGo) then
      error("can\'t get fx go pos:" .. tostring(showPos) .. " fxName:" .. tostring(effectName))
      return 
    end
    ;
    (effectGo.transform):SetParent(effectRoot)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (effectGo.transform).position = showPos
    if bindGo ~= nil then
      (effectGo.transform):SetParent(bindGo.transform)
    end
    effectGo:SetActive(true)
    return effectGo
  end
end

WarChessAnimationCtrl.RecycleWCEffect = function(self, effectName, effectGo)
  -- function num : 0_12 , upvalues : _ENV, Stack
  if IsNull(effectGo) then
    return 
  end
  local recycleRoot = ((self.wcCtrl).bind).trans_effectRecycle
  local stack = (self.__effectPoolDic)[effectName]
  if stack == nil then
    stack = (Stack.New)()
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.__effectPoolDic)[effectName] = stack
  end
  stack:Push(effectGo)
  ;
  (effectGo.transform):SetParent(recycleRoot)
  effectGo:SetActive(false)
end

WarChessAnimationCtrl.UpdateWCEffect = function(self, fxData)
  -- function num : 0_13 , upvalues : _ENV
  local effectGo = (self.__commonFxDic)[fxData]
  if effectGo == nil then
    return 
  end
  if fxData:GetWCFXIsNeedFillCount() then
    local num = fxData:GetWCFXCoutNum()
    if num ~= nil then
      local effectUnit = effectGo:GetComponent(typeof(CS.EffectUnit))
      effectUnit:SetCountValue(num)
    end
  end
end

WarChessAnimationCtrl.RefreshAllWCBornFX = function(self, curView)
  -- function num : 0_14 , upvalues : _ENV, WarChessHelper
  local wait2RemoveList = {}
  for gridData,BornLoopFX in pairs(self.__bornFxDic) do
    local gridPos = gridData:GetGridLogicPos()
    if not (WarChessHelper.IsPointInRect)(curView, gridPos.x, gridPos.y) then
      self:RecycleWCEffect("FXP_BornPositionLoop", BornLoopFX)
      ;
      (table.insert)(wait2RemoveList, gridData)
    end
  end
  for _,gridData in pairs(wait2RemoveList) do
    do
      -- DECOMPILER ERROR at PC30: Confused about usage of register: R8 in 'UnsetPending'

      (self.__bornFxDic)[gridData] = nil
    end
  end
  for x = curView.xMin, curView.xMax do
    for y = curView.yMin, curView.yMax do
      local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
      do
        -- DECOMPILER ERROR at PC63: Unhandled construct in 'MakeBoolean' P1

        if gridData ~= nil and gridData:GetCouldShowBornFX() and (self.__bornFxDic)[gridData] == nil then
          local BornLoopFX = self:ShowWCEffect("FXP_BornPositionLoop", gridData:GetGridShowPos())
          -- DECOMPILER ERROR at PC64: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (self.__bornFxDic)[gridData] = BornLoopFX
        end
        local BornLoopFX = (self.__bornFxDic)[gridData]
        if BornLoopFX ~= nil then
          self:RecycleWCEffect("FXP_BornPositionLoop", BornLoopFX)
          -- DECOMPILER ERROR at PC75: Confused about usage of register: R13 in 'UnsetPending'

          ;
          (self.__bornFxDic)[gridData] = nil
          local BornEbdFX = self:ShowWCEffect("FXP_BornPositionEnd", gridData:GetGridShowPos())
          TimerManager:StartTimer(2, function()
    -- function num : 0_14_0 , upvalues : _ENV, BornEbdFX, self
    if IsNull(BornEbdFX) then
      return 
    end
    self:RecycleWCEffect("FXP_BornPositionEnd", BornEbdFX)
  end
, self, true)
        end
        do
          -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
end

WarChessAnimationCtrl.RefreshWCMoveableFX = function(self, curView)
  -- function num : 0_15 , upvalues : _ENV, WarChessHelper
  if self.__curMoveableGridDic == nil or not self.__couldShowMoveableFX then
    for gridData,moveableFX in pairs(self.__moveableFxDic) do
      self:RecycleWCEffect("FXP_MovableRange", moveableFX)
    end
    self.__moveableFxDic = {}
  else
    local wait2RemoveList = {}
    for gridData,moveableFX in pairs(self.__moveableFxDic) do
      local gridPos = gridData:GetGridLogicPos()
      if not (WarChessHelper.IsPointInRect)(curView, gridPos.x, gridPos.y) then
        self:RecycleWCEffect("FXP_MovableRange", moveableFX)
        ;
        (table.insert)(wait2RemoveList, gridData)
      end
    end
    for _,gridData in pairs(wait2RemoveList) do
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R8 in 'UnsetPending'

      (self.__moveableFxDic)[gridData] = nil
    end
    for x = curView.xMin, curView.xMax do
      for y = curView.yMin, curView.yMax do
        local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
        do
          -- DECOMPILER ERROR at PC82: Unhandled construct in 'MakeBoolean' P1

          -- DECOMPILER ERROR at PC82: Unhandled construct in 'MakeBoolean' P1

          if gridData ~= nil and (self.__curMoveableGridDic)[gridData] ~= nil and (self.__moveableFxDic)[gridData] == nil then
            local moveableFX = self:ShowWCEffect("FXP_MovableRange", gridData:GetGridShowPos())
            -- DECOMPILER ERROR at PC83: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self.__moveableFxDic)[gridData] = moveableFX
          end
          do
            local moveableFX = (self.__moveableFxDic)[gridData]
            if moveableFX ~= nil then
              self:RecycleWCEffect("FXP_MovableRange", moveableFX)
              -- DECOMPILER ERROR at PC94: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (self.__moveableFxDic)[gridData] = nil
            end
            -- DECOMPILER ERROR at PC95: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
    end
  end
end

WarChessAnimationCtrl.WCSetMoveableFXVisiabel = function(self, teamData)
  -- function num : 0_16
  self:__OnSelectTeam(teamData)
end

WarChessAnimationCtrl.RefreshWCMonsterMoveableFX = function(self, curView)
  -- function num : 0_17 , upvalues : _ENV, WarChessHelper
  if self.monsterMoveableGridDic == nil then
    for gridData,moveableFX in pairs(self.__monsterMoveableFxDic) do
      self:RecycleWCEffect("FXP_MovableRange_monster", moveableFX)
    end
    self.__monsterMoveableFxDic = {}
  else
    local wait2RemoveList = {}
    for gridData,moveableFX in pairs(self.__monsterMoveableFxDic) do
      local gridPos = gridData:GetGridLogicPos()
      if not (WarChessHelper.IsPointInRect)(curView, gridPos.x, gridPos.y) then
        self:RecycleWCEffect("FXP_MovableRange_monster", moveableFX)
        ;
        (table.insert)(wait2RemoveList, gridData)
      end
    end
    for _,gridData in pairs(wait2RemoveList) do
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

      (self.__monsterMoveableFxDic)[gridData] = nil
    end
    for x = curView.xMin, curView.xMax do
      for y = curView.yMin, curView.yMax do
        local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
        do
          -- DECOMPILER ERROR at PC79: Unhandled construct in 'MakeBoolean' P1

          -- DECOMPILER ERROR at PC79: Unhandled construct in 'MakeBoolean' P1

          if gridData ~= nil and (self.monsterMoveableGridDic)[gridData] ~= nil and (self.__monsterMoveableFxDic)[gridData] == nil then
            local moveableFX = self:ShowWCEffect("FXP_MovableRange_monster", gridData:GetGridShowPos())
            -- DECOMPILER ERROR at PC80: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self.__monsterMoveableFxDic)[gridData] = moveableFX
          end
          do
            local moveableFX = (self.__monsterMoveableFxDic)[gridData]
            if moveableFX ~= nil then
              self:RecycleWCEffect("FXP_MovableRange_monster", moveableFX)
              -- DECOMPILER ERROR at PC91: Confused about usage of register: R13 in 'UnsetPending'

              ;
              (self.__monsterMoveableFxDic)[gridData] = nil
            end
            -- DECOMPILER ERROR at PC92: LeaveBlock: unexpected jumping out DO_STMT

          end
        end
      end
    end
  end
end

WarChessAnimationCtrl.SetMonsterMoveableGridDic = function(self, monsterMoveableGridDic, levelNubDic)
  -- function num : 0_18 , upvalues : _ENV
  if self.__monsterMoveableSpreadTimer then
    TimerManager:StopTimer(self.__monsterMoveableSpreadTimer)
    self.__monsterMoveableSpreadTimer = nil
  end
  if monsterMoveableGridDic and levelNubDic then
    local nubIdxSet = {}
    do
      for idx,_ in pairs(levelNubDic) do
        (table.insert)(nubIdxSet, idx)
      end
      local LevelCount = (table.count)(levelNubDic)
      local intervalSeconds = 0
      local popFinishSeconds = 0.5
      intervalSeconds = popFinishSeconds / 3
      if LevelCount > 3 then
        intervalSeconds = popFinishSeconds / LevelCount
      end
      self.monsterMoveableGridDic = {}
      self.__monsterMoveableSpreadTimer = TimerManager:StartTimer(intervalSeconds, function()
    -- function num : 0_18_0 , upvalues : nubIdxSet, self, _ENV, levelNubDic
    if #nubIdxSet < 1 or not self.monsterMoveableGridDic then
      TimerManager:StopTimer(self.__monsterMoveableSpreadTimer)
      self.__monsterMoveableSpreadTimer = nil
      return 
    end
    for gridData,_ in pairs(levelNubDic[(table.remove)(nubIdxSet, 1)]) do
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

      (self.monsterMoveableGridDic)[gridData] = true
    end
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshWCMonsterMoveableFX(curView)
    end
  end
, self)
    end
  else
    do
      self.monsterMoveableGridDic = nil
      local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
      if ok then
        local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
        self:RefreshWCMonsterMoveableFX(curView)
      end
    end
  end
end

WarChessAnimationCtrl.RefreshWCMonsterAlarmFX = function(self, entityData)
  -- function num : 0_19 , upvalues : _ENV
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  if self.monsterAlarmGridDic == nil or (self.monsterAlarmGridDic)[entityData] == nil then
    if not (self.__monsterAlarmFxDic)[entityData] then
      (self.__monsterAlarmFxDic)[entityData] = {}
      for gridData,moveableFX in pairs((self.__monsterAlarmFxDic)[entityData]) do
        self:RecycleWCEffect("FXP_jingjie_dige01", moveableFX)
      end
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self.__monsterAlarmFxDic)[entityData] = {}
      for gridData,isHave in pairs((self.monsterAlarmGridDic)[entityData]) do
        -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

        if not (self.__monsterAlarmFxDic)[entityData] then
          (self.__monsterAlarmFxDic)[entityData] = {}
          do
            if ((self.__monsterAlarmFxDic)[entityData])[gridData] == nil then
              local moveableFX = self:ShowWCEffect("FXP_jingjie_dige01", gridData:GetGridShowPos())
              -- DECOMPILER ERROR at PC53: Confused about usage of register: R8 in 'UnsetPending'

              ;
              ((self.__monsterAlarmFxDic)[entityData])[gridData] = moveableFX
            end
            -- DECOMPILER ERROR at PC54: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC54: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

WarChessAnimationCtrl.SetMonsterAlarmGridDic = function(self, monsterAlarmGridDic, levelNubDic, entityData, distance)
  -- function num : 0_20 , upvalues : _ENV
  if monsterAlarmGridDic and levelNubDic then
    local nubIdxSet = {}
    for idx,_ in pairs(levelNubDic) do
      (table.insert)(nubIdxSet, idx)
    end
    if #nubIdxSet < 1 then
      return 
    end
    if not self.monsterAlarmGridDic then
      self.monsterAlarmGridDic = {}
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

      if not (self.monsterAlarmGridDic)[entityData] then
        do
          (self.monsterAlarmGridDic)[entityData] = {}
          for i,idx in pairs(nubIdxSet) do
            if idx <= distance then
              for gridData,_ in pairs(levelNubDic[idx]) do
                -- DECOMPILER ERROR at PC44: Confused about usage of register: R16 in 'UnsetPending'

                ((self.monsterAlarmGridDic)[entityData])[gridData] = true
              end
            end
          end
          self:RefreshWCMonsterAlarmFX(entityData)
          self.monsterAlarmGridDic = nil
          self:RefreshWCMonsterAlarmFX(entityData)
        end
      end
    end
  end
end

WarChessAnimationCtrl.RefeshAllEntityLinkFx = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local groupListDic = ((self.wcCtrl).mapCtrl):GetAllLinkedEntityGroupData()
  for groupId,groupList in pairs(groupListDic) do
    if #groupList < 2 then
      error("Symbiotic(linked) num less then 2")
    else
      if (self.__monsterLinkFxDic)[groupId] ~= nil then
        for _,linkFxGo in pairs((self.__monsterLinkFxDic)[groupId]) do
          self:RecycleWCEffect("FXP_battle_Monster_lx", linkFxGo)
        end
      end
      do
        -- DECOMPILER ERROR at PC32: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.__monsterLinkFxDic)[groupId] = {}
        do
          local lastEntityData = nil
          for _,entityData in pairs(groupList) do
            if lastEntityData ~= nil then
              local linkFxGo = self:ShowWCEffect("FXP_battle_Monster_lx", entityData:GetEntityShowPos())
              local startBindPoint = entityData:GetEntityShowPos() + (Vector3.Temp)(0, 0.25, 0)
              local endBindPoint = lastEntityData:GetEntityShowPos() + (Vector3.Temp)(0, 0.25, 0)
              local effectUnit = linkFxGo:GetComponent(typeof(CS.EffectUnit))
              effectUnit:SetLineEffect(startBindPoint, endBindPoint)
              ;
              (table.insert)((self.__monsterLinkFxDic)[groupId], linkFxGo)
            end
            do
              do
                lastEntityData = entityData
                -- DECOMPILER ERROR at PC80: LeaveBlock: unexpected jumping out DO_STMT

              end
            end
          end
          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

WarChessAnimationCtrl.__OnEntityUpdate = function(self, entityData, isDelete)
  -- function num : 0_22 , upvalues : _ENV
  if not isDelete then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if not (self.__monsterAlarmFxDic)[entityData] then
    (self.__monsterAlarmFxDic)[entityData] = {}
    for gridData,moveableFX in pairs((self.__monsterAlarmFxDic)[entityData]) do
      self:RecycleWCEffect("FXP_jingjie_dige01", moveableFX)
    end
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.__monsterAlarmFxDic)[entityData] = {}
    local groupId = entityData:GetEntitySymbioticId()
    if groupId ~= nil then
      local LinkFxList = (self.__monsterLinkFxDic)[groupId]
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

      if LinkFxList ~= nil then
        (self.__monsterLinkFxDic)[groupId] = nil
        for _,linkFxGo in pairs(LinkFxList) do
          self:RecycleWCEffect("FXP_battle_Monster_lx", linkFxGo)
        end
      end
    end
  end
end

WarChessAnimationCtrl.RefreshVisableFX = function(self, curView)
  -- function num : 0_23 , upvalues : _ENV, WarChessHelper
  local wait2RemoveList = {}
  for fxData,moveableFX in pairs(self.__commonFxDic) do
    local gridPos = fxData:GetWCFxLogicPos()
    if fxData:GetWCFXIsNotOnce() and (gridPos == nil or not (WarChessHelper.IsPointInRect)(curView, gridPos.x, gridPos.y)) then
      self:RecycleWCEffect(fxData:GetWCFxResName(), moveableFX)
      ;
      (table.insert)(wait2RemoveList, fxData)
    end
  end
  for _,fxData in pairs(wait2RemoveList) do
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

    (self.__commonFxDic)[fxData] = nil
  end
  for x = curView.xMin, curView.xMax do
    for y = curView.yMin, curView.yMax do
      local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
      local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPosXY(nil, x, y)
      if gridData ~= nil then
        local fxDic = gridData:GetFxDataDic()
        for _,fxData in pairs(fxDic) do
          if fxData:GetWCFXIsNotOnce() and (self.__commonFxDic)[fxData] == nil then
            local effectName = fxData:GetWCFxResName()
            local fx = self:ShowWCEffect(effectName, gridData:GetGridShowPos())
            -- DECOMPILER ERROR at PC86: Confused about usage of register: R21 in 'UnsetPending'

            ;
            (self.__commonFxDic)[fxData] = fx
            self:UpdateWCEffect(fxData)
          end
        end
      end
      do
        if entityData ~= nil then
          local fxDic = entityData:GetFxDataDic()
          for _,fxData in pairs(fxDic) do
            if fxData:GetWCFXIsNotOnce() and (self.__commonFxDic)[fxData] == nil then
              local effectName = fxData:GetWCFxResName()
              local fx = self:ShowWCEffect(effectName, entityData:GetEntityShowPos())
              entityData:SetEntityEffect(effectName, fx)
              -- DECOMPILER ERROR at PC120: Confused about usage of register: R21 in 'UnsetPending'

              ;
              (self.__commonFxDic)[fxData] = fx
              self:UpdateWCEffect(fxData)
            end
          end
        end
        do
          -- DECOMPILER ERROR at PC126: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
  end
end

WarChessAnimationCtrl.RefreshSingleCommonFX = function(self, data, savedFxes, isGrid)
  -- function num : 0_24 , upvalues : _ENV, WarChessFXData
  local fxDic = data:GetFxDataDic()
  for _,fx in pairs(savedFxes) do
    local fxId = fx.id
    local isOnce = false
    local isBind = fx.isBind
    do
      do
        if fxDic[fxId] == nil then
          local fxData = (WarChessFXData.New)(isGrid, fxId, isOnce, isBind, data)
          fxDic[fxId] = fxData
        end
        if self.__isLoadOver then
          if self.__needRefreshFxNum > 0 then
            self.__needRefreshFxNum = self.__needRefreshFxNum + 1
          else
            TimerManager:AddLateCommand(function()
    -- function num : 0_24_0 , upvalues : self
    self.__NeedRefreshFxDataList = 0
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshVisableFX(curView)
    end
  end
)
          end
        end
        -- DECOMPILER ERROR at PC34: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

WarChessAnimationCtrl.UpdateSingleWCFX = function(self, data)
  -- function num : 0_25 , upvalues : _ENV
  local fxDic = data:GetFxDataDic()
  for _,fxData in pairs(fxDic) do
    self:UpdateWCEffect(fxData)
  end
end

WarChessAnimationCtrl.RemoveSingleWCFX = function(self, data)
  -- function num : 0_26 , upvalues : _ENV
  local fxDic = data:GetFxDataDic()
  if fxDic == nil then
    return 
  end
  for _,fxData in pairs(fxDic) do
    local effectGo = (self.__commonFxDic)[fxData]
    if effectGo == nil then
      return 
    end
    self:RecycleWCEffect(fxData:GetWCFxResName(), effectGo)
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.__commonFxDic)[fxData] = nil
  end
end

WarChessAnimationCtrl.__OnCameraMove = function(self, ok, curView, lastView)
  -- function num : 0_27
  if ok then
    self:RefreshAllWCBornFX(curView)
    self:RefreshWCMoveableFX(curView)
    self:RefreshWCMonsterMoveableFX(curView)
    self:RefreshVisableFX(curView)
  end
end

WarChessAnimationCtrl.__OnDeployTeamChange = function(self)
  -- function num : 0_28
  local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
  if ok then
    local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
    self:RefreshAllWCBornFX(curView)
  end
end

WarChessAnimationCtrl.__OnSelectTeam = function(self, teamData)
  -- function num : 0_29 , upvalues : _ENV
  if self.__moveableSpreadTimer then
    TimerManager:StopTimer(self.__moveableSpreadTimer)
    self.__moveableSpreadTimer = nil
  end
  local couldShow = not self.__couldShowMoveableFX or teamData ~= nil
  if couldShow then
    ((self.wcCtrl).teamCtrl):CalTeamCouldMoveGridDic(teamData)
    local levelNubDic = teamData:GetWCTeamLevelNubDic()
    do
      local nubIdxSet = {}
      for idx,_ in pairs(levelNubDic) do
        (table.insert)(nubIdxSet, idx)
      end
      local LevelCount = (table.count)(levelNubDic)
      local intervalSeconds = 0
      local popFinishSeconds = 0.5
      intervalSeconds = popFinishSeconds / 3
      if LevelCount > 3 then
        intervalSeconds = popFinishSeconds / LevelCount
      end
      self.__curMoveableGridDic = {}
      self.__moveableSpreadTimer = TimerManager:StartTimer(intervalSeconds, function()
    -- function num : 0_29_0 , upvalues : nubIdxSet, self, _ENV, levelNubDic
    if #nubIdxSet < 1 or not self.__curMoveableGridDic then
      TimerManager:StopTimer(self.__moveableSpreadTimer)
      self.__moveableSpreadTimer = nil
      return 
    end
    for gridData,_ in pairs(levelNubDic[(table.remove)(nubIdxSet, 1)]) do
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

      (self.__curMoveableGridDic)[gridData] = true
    end
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshWCMoveableFX(curView)
    end
  end
, self)
    end
  else
    self.__curMoveableGridDic = nil
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshWCMoveableFX(curView)
    end
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

WarChessAnimationCtrl.SetCouldShowMoveableFX = function(self, isShow)
  -- function num : 0_30 , upvalues : _ENV
  if self.__couldShowMoveableFX == isShow then
    return 
  end
  if isShow then
    local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshWCMoveableFX(curView)
    end
  else
    do
      for gridData,moveableFX in pairs(self.__moveableFxDic) do
        self:RecycleWCEffect("FXP_MovableRange", moveableFX)
      end
      self.__moveableFxDic = {}
      self.__couldShowMoveableFX = isShow
    end
  end
end

WarChessAnimationCtrl.UpdateWCSelectedFX = function(self, isShow, logicPos)
  -- function num : 0_31 , upvalues : _ENV
  if isShow then
    local showPos = (Vector3.New)(logicPos.x, 0, logicPos.y)
    if self.__selectFX == nil then
      self.__selectFX = self:ShowWCEffect("FXP_Select", showPos)
    else
      ;
      ((self.__selectFX).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.__selectFX).transform).position = showPos
    end
  else
    do
      if self.__selectFX ~= nil then
        ((self.__selectFX).gameObject):SetActive(false)
      end
    end
  end
end

WarChessAnimationCtrl.AddBindFx4Team = function(self, teamData, eHeroBindFxType, fxResName)
  -- function num : 0_32
  local teamIndex = teamData:GetWCTeamIndex()
  local key = teamIndex << 8 | eHeroBindFxType
  -- DECOMPILER ERROR at PC16: Unhandled construct in 'MakeBoolean' P1

  -- DECOMPILER ERROR at PC16: Unhandled construct in 'MakeBoolean' P1

  if (self.__teamBindFxResDic)[key] ~= nil and (self.__teamBindFxResDic)[key] == fxResName and (self.__teamBindFxDic)[key] ~= nil then
    return 
  end
  self:RemoveBindFxFromTeam(teamData, eHeroBindFxType)
  local heroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity(teamIndex, nil, nil)
  local teamPos = heroEntity:WCHeroEntityGetShowPos()
  local heroEntityRoot = heroEntity:GetWCHeroParentGo()
  local fxGo = self:ShowWCEffect(fxResName, teamPos, heroEntityRoot)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.__teamBindFxResDic)[key] = fxResName
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (self.__teamBindFxDic)[key] = fxGo
  return fxGo
end

WarChessAnimationCtrl.RemoveBindFxFromTeam = function(self, teamData, eHeroBindFxType)
  -- function num : 0_33
  local teamIndex = teamData:GetWCTeamIndex()
  local key = teamIndex << 8 | eHeroBindFxType
  local fxResName = (self.__teamBindFxResDic)[key]
  local fxGo = (self.__teamBindFxDic)[key]
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R7 in 'UnsetPending'

  if fxResName ~= nil then
    (self.__teamBindFxResDic)[key] = nil
  end
  if fxGo ~= nil then
    self:RecycleWCEffect(fxResName, fxGo)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__teamBindFxDic)[key] = nil
  end
  return fxGo
end

WarChessAnimationCtrl.OnSceneLoadOver = function(self)
  -- function num : 0_34
  local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
  do
    if ok then
      local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
      self:RefreshAllWCBornFX(curView)
      self:RefreshVisableFX(curView)
      ;
      ((self.wcCtrl).mapCtrl):AfterAnimationCtrlLoadOver()
    end
    self.__isLoadOver = true
  end
end

WarChessAnimationCtrl.OnSceneUnload = function(self)
  -- function num : 0_35 , upvalues : _ENV
  self.__isLoadOver = false
  self.__isPlayingAnimationOfFX = false
  self.__effectPoolDic = {}
  self.__effectPrefabDic = {}
  self.__bornFxDic = {}
  self.__moveableFxDic = {}
  self.__monsterMoveableFxDic = {}
  self.__monsterAlarmFxDic = {}
  self.__monsterLinkFxDic = {}
  self.__curMoveableGridDic = {}
  self.__commonFxDic = {}
  self.__teamBindFxDic = {}
  self.__selectFX = nil
  if self.__playAllShowCo ~= nil then
    (GR.StopCoroutine)(self.__playAllShowCo)
    ;
    ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(true)
    self.__playAllShowCo = nil
  end
end

WarChessAnimationCtrl.CleanAllFx = function(self)
  -- function num : 0_36 , upvalues : _ENV
  if self.__playAllShowCo ~= nil then
    (GR.StopCoroutine)(self.__playAllShowCo)
    ;
    ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(true)
    self.__playAllShowCo = nil
  end
  for fxData,moveableFX in pairs(self.__commonFxDic) do
    self:RecycleWCEffect(fxData:GetWCFxResName(), moveableFX)
  end
  self.__commonFxDic = {}
  for gridData,BornLoopFX in pairs(self.__bornFxDic) do
    self:RecycleWCEffect("FXP_BornPositionLoop", BornLoopFX)
  end
  self.__bornFxDic = {}
  for gridData,moveableFX in pairs(self.__moveableFxDic) do
    self:RecycleWCEffect("FXP_MovableRange", moveableFX)
  end
  self.__curMoveableGridDic = {}
  self.__moveableFxDic = {}
  for gridData,moveableFX in pairs(self.__monsterMoveableFxDic) do
    self:RecycleWCEffect("FXP_MovableRange_monster", moveableFX)
  end
  self.__monsterMoveableFxDic = {}
  for entityData,fxDic in pairs(self.__monsterAlarmFxDic) do
    for gridData,alarmFX in pairs(fxDic) do
      self:RecycleWCEffect("FXP_jingjie_dige01", alarmFX)
    end
  end
  self.__monsterAlarmFxDic = {}
  for groupId,LinkFxList in pairs(self.__monsterLinkFxDic) do
    for _,linkFxGo in pairs(LinkFxList) do
      self:RecycleWCEffect("FXP_battle_Monster_lx", linkFxGo)
    end
  end
  self.__monsterLinkFxDic = {}
  if self.__selectFX ~= nil then
    ((self.__selectFX).gameObject):SetActive(false)
  end
end

WarChessAnimationCtrl.Delete = function(self)
  -- function num : 0_37 , upvalues : _ENV
  self:CleanAllFx()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.WC_CameraMove, self.__onCameraMove)
  MsgCenter:RemoveListener(eMsgEventId.WC_DeployTeamChange, self.__onDeployTeamChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_SelectTeam, self.__onSelectTeam)
  MsgCenter:RemoveListener(eMsgEventId.WC_EntityInfoUpdate, self.__onEntityUpdate)
end

return WarChessAnimationCtrl

