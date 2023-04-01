-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonBattleBaseCtrl = class("DungeonBattleBaseCtrl")
local CS_BattleManager_Ins = (CS.BattleManager).Instance
local util = require("XLua.Common.xlua_util")
local ExclusiveWeaponEffectUtil = require("Game.ExclusiveWeaponEffect.ExclusiveWeaponEffectUtil")
local CS_AnimationEffectController_Ins = (CS.AnimationEffectController).Instance
local CS_CameraController = CS.CameraController
local CS_WaitForSeconds = (CS.UnityEngine).WaitForSeconds
local CS_ResLoader = CS.ResLoader
DungeonBattleBaseCtrl.eBattleEndType = {Victory = 0, Failure = 1, Retreat = 2, Restart = 3, Sneak = 5}
DungeonBattleBaseCtrl.GetHeroObjectDic = function(self)
  -- function num : 0_0
end

DungeonBattleBaseCtrl.OnBattleStateChange = function(self, battleCtrl, stateId, isDeployRoom)
  -- function num : 0_1
end

DungeonBattleBaseCtrl.GetRoleAppearEffect = function(self)
  -- function num : 0_2
end

DungeonBattleBaseCtrl.GetRoleDisappearEffect = function(self)
  -- function num : 0_3
end

DungeonBattleBaseCtrl.BattleLoadReady = function(self, battleController)
  -- function num : 0_4 , upvalues : _ENV
  if self.__OnDragTileChanged == nil then
    self.__OnDragTileChanged = BindCallback(self, self.OnDragTileChanged)
    ;
    ((CS.MsgDispatcher).AddListener)(eCsMsgEventType.OnDeployDragTileChanged, self.__OnDragTileChanged)
  end
end

DungeonBattleBaseCtrl.OnDragTileChanged = function(self, targetTile, isPlayer, draggingRole)
  -- function num : 0_5 , upvalues : CS_AnimationEffectController_Ins
  CS_AnimationEffectController_Ins:KillRoleEffect((draggingRole.lsObject).gameObject)
  CS_AnimationEffectController_Ins:RecycleRoleEffect((draggingRole.lsObject).gameObject)
end

DungeonBattleBaseCtrl.OnBattleStart = function(self, battleCtrl)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.BattleCrazyMode, function(window)
    -- function num : 0_6_0 , upvalues : battleCtrl
    if window == nil then
      return 
    end
    window:InjectCrazyTime(battleCtrl.CrazyTime)
    window:OnBattleStartCrazyMode(battleCtrl)
  end
)
end

DungeonBattleBaseCtrl.ReqStartBattle = function(self, battleRoomData, originRoleList, battleAction)
  -- function num : 0_7 , upvalues : _ENV
  local uiBattle = UIManager:GetWindow(UIWindowTypeID.Battle)
  if uiBattle ~= nil and uiBattle.active then
    uiBattle:HideRetreatAndCampBondBtn()
  end
  local uiTDBattle = UIManager:GetWindow(UIWindowTypeID.TDBattle)
  if uiTDBattle ~= nil then
    uiTDBattle:OnTdBattleStart()
  end
end

DungeonBattleBaseCtrl.OnBattleEnd = function(self, battleEndState, evenId, dealBattleEndEvent)
  -- function num : 0_8
  dealBattleEndEvent(evenId)
end

DungeonBattleBaseCtrl.ReqBattleSettle = function(self, battleEndState, requestData)
  -- function num : 0_9
end

DungeonBattleBaseCtrl.CreateBattleSettleMisc = function(self, battleCtrl)
  -- function num : 0_10
  local battlePlayerController = battleCtrl.PlayerController
  local misc = {}
  misc.totalFrame = battleCtrl.frame
  misc.inputData = self:StoreInputCmdToSettleMsg(battlePlayerController)
  return misc
end

DungeonBattleBaseCtrl.CreateBattleSettleValid = function(self, battleCtrl, requestData)
  -- function num : 0_11 , upvalues : _ENV
  local battlePlayerController = battleCtrl.PlayerController
  local valid = {}
  local score = {}
  for k,v in pairs(requestData.gameScore) do
    score[k] = v
  end
  valid.score = score
  valid.activeAlgConsume = self:GetBattleConsumeSkillChipUseTimeDic(battlePlayerController)
  return valid
end

DungeonBattleBaseCtrl.StoreInputCmdToSettleMsg = function(self, csbattlePlayerController)
  -- function num : 0_12 , upvalues : _ENV
  local inputData = {}
  if csbattlePlayerController ~= nil then
    local inputs = csbattlePlayerController:GetInputCmd()
    if inputs ~= nil and inputs.Count > 0 then
      for i = 0, inputs.Count - 1 do
        local inputModel = self:PackInputModel(inputs[i])
        ;
        (table.insert)(inputData, inputModel)
      end
    end
  end
  do
    if #inputData > 0 then
      return inputData
    end
    return nil
  end
end

DungeonBattleBaseCtrl.__UpdatePlayerPosOnTDSettle = function(self, roleDataId, x, y)
  -- function num : 0_13 , upvalues : _ENV
  if (ConfigData.buildinConfig).BenchX <= x then
    y = 0
  end
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil then
    return 
  end
  local dynHero = (dynPlayer.heroDic)[roleDataId]
  if dynHero ~= nil then
    dynHero:SetCoordXY(x, y, (ConfigData.buildinConfig).BenchX)
    return dynHero.coord
  end
  return nil
end

DungeonBattleBaseCtrl.PackInputModel = function(self, csInputCmd)
  -- function num : 0_14 , upvalues : _ENV
  local inputModel = {}
  inputModel.frame = csInputCmd.frameId
  inputModel.skillId = csInputCmd.skillId
  inputModel.casterId = csInputCmd.casterId
  inputModel.ultimateSkill = csInputCmd.isUltSkill
  inputModel.inputType = csInputCmd.inputType
  local selectTiles = csInputCmd.selectTiles
  inputModel.select_role_coords = {}
  if selectTiles ~= nil and selectTiles.Count > 0 then
    for i = 0, selectTiles.Count - 1 do
      (table.insert)(inputModel.select_role_coords, selectTiles[i])
    end
  end
  do
    inputModel.inputcoord = csInputCmd.selectCoord
    return inputModel
  end
end

DungeonBattleBaseCtrl.VictoryBattleEndCoroutine = function(self, battleEndState)
  -- function num : 0_15
end

DungeonBattleBaseCtrl.ReqBattleFreshFormation = function(self, battleController)
  -- function num : 0_16
end

DungeonBattleBaseCtrl.ReqGiveUpBattle = function(self, battleController)
  -- function num : 0_17
end

DungeonBattleBaseCtrl.ReqRestartBattle = function(self, battleController)
  -- function num : 0_18
  battleController:RestartBattle()
end

DungeonBattleBaseCtrl.OnDeployCoordChanged = function(self, battleController, entity)
  -- function num : 0_19 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.OnDeployCoordChanged, entity)
end

DungeonBattleBaseCtrl.OnDeployEndDragRole = function(self, battleController, entity)
  -- function num : 0_20 , upvalues : ExclusiveWeaponEffectUtil
  ExclusiveWeaponEffectUtil:BattleRoleEntityPlayEWEffect(entity)
end

DungeonBattleBaseCtrl.OnBattleEffectClicked = function(self, battleController, battleEffectGrid)
  -- function num : 0_21 , upvalues : _ENV
  local worldPos = nil
  if battleEffectGrid.onBench then
    worldPos = (battleController.battleFieldData):GetBenchUnityPos(battleEffectGrid.y)
  else
    worldPos = (battleController.battleFieldData):GetGridUnityPos(battleEffectGrid.x, battleEffectGrid.y)
  end
  ;
  (UIManager:ShowWindow(UIWindowTypeID.BattleEffectGirdInfo)):InitBattleGridInfo(battleEffectGrid.gridData, worldPos)
  AudioManager:PlayAudioById(1079)
end

DungeonBattleBaseCtrl.OnBattleObjectLoadComplete = function(self, battleController)
  -- function num : 0_22 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.OnBattleReady)
end

DungeonBattleBaseCtrl.GetBattleConsumeSkillChipUseTimeDic = function(self, battlePlayerController)
  -- function num : 0_23 , upvalues : _ENV
  local activeAlgConsume = {}
  local skillList = battlePlayerController:GetPlayerSkillList()
  if skillList == nil then
    return nil
  end
  for i = 0, skillList.Count - 1 do
    local battleSkill = skillList[i]
    if battleSkill.skillType == eBattleSkillLogicType.ChipConsume and battleSkill.curUseTime > 0 then
      activeAlgConsume[battleSkill.itemId] = battleSkill.curUseTime
    end
  end
  return activeAlgConsume
end

DungeonBattleBaseCtrl.PlayRoleWinActionAndEffect = function(self, playerRoleList, mvpRole)
  -- function num : 0_24 , upvalues : _ENV
  for key,role in pairs(playerRoleList) do
    if not role.roleOnBench then
      local heroCfg = (ConfigData.resource_model)[role.resSrcId]
      if heroCfg ~= nil then
        local playEffect = false
        if role == mvpRole then
          playEffect = true
        else
          playEffect = heroCfg.non_mvp_effect
        end
        if playEffect then
          for _,effectId in ipairs(heroCfg.win_effect_id) do
            role:PlayWinEffect(effectId)
          end
        end
      end
      do
        do
          role:BreakActionLayerWithEmptyAction((ConfigData.buildinConfig).ExtraAtionEmptyAction)
          ;
          (role.lsObject):ResetGameObjectPosition()
          -- DECOMPILER ERROR at PC43: Confused about usage of register: R9 in 'UnsetPending'

          ;
          (role.lsObject).localRotation = ((CS.TrueSync).TSQuaternion).identity
          role:PlayWinAction()
          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC46: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

DungeonBattleBaseCtrl.GetRoleMvpCameraOffset = function(self, role)
  -- function num : 0_25 , upvalues : _ENV
  if role == nil then
    return 
  end
  if role.character == nil then
    return 
  end
  if (role.character).heroData == nil then
    return 
  end
  local heroId = role.roleDataId
  local skinId = ((role.character).heroData).skinId
  local mvpCfg = (ConfigData.battle_mvp)[skinId]
  do
    if mvpCfg == nil then
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg == nil then
        return 
      end
      skinId = heroCfg.default_skin
      mvpCfg = (ConfigData.battle_mvp)[skinId]
    end
    if mvpCfg == nil then
      return 
    end
    local offset = ((ConfigData.battle_mvp)[skinId]).camera_offset_vector3
    if #offset == 3 then
      return (Vector3.New)(offset[1], offset[2], offset[3])
    end
  end
end

DungeonBattleBaseCtrl.BeforeCreateStageBoss = function(self, battleController, sourceMonsterEntity, newBoss)
  -- function num : 0_26
end

DungeonBattleBaseCtrl.OnCreateStageBoss = function(self, battleController, newMonsterEntity)
  -- function num : 0_27 , upvalues : _ENV, util
  if newMonsterEntity.parentRoleEntity == nil then
    error("parentRoleEntity == nil")
    return 
  end
  local stageGroupId = ((newMonsterEntity.parentRoleEntity).character):GetDynMonsterStageGroup()
  local monsterStageGroupCfg = (ConfigData.monster_stage)[stageGroupId]
  local stage = (newMonsterEntity.character).stage
  if monsterStageGroupCfg == nil or monsterStageGroupCfg[stage] == nil then
    error((string.format)("Cant get monster_stage, stageGroupId:%s, monsterId:%s, stage:%s", stageGroupId, newMonsterEntity.roleDataId, stage))
    return 
  end
  local monsterStageCfg = monsterStageGroupCfg[stage]
  if (string.IsNullOrEmpty)(monsterStageCfg.avg_name) and not monsterStageCfg.timeline_enable then
    return 
  end
  if self._stageBossCo ~= nil then
    error("self._stageBossCo ~= nil")
    return 
  end
  if not self._stageBossTab then
    self._stageBossTab = {}
    -- DECOMPILER ERROR at PC55: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._stageBossTab).battleController = battleController
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._stageBossTab).newMonsterEntity = newMonsterEntity
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._stageBossTab).monsterStageCfg = monsterStageCfg
    if not self._CoStageBossShowFunc then
      self._CoStageBossShowFunc = BindCallback(self, self._CoStageBossShow)
      self._stageBossCo = (GR.StartCoroutine)((util.cs_generator)(self._CoStageBossShowFunc))
    end
  end
end

DungeonBattleBaseCtrl._CoStageBossShow = function(self)
  -- function num : 0_28 , upvalues : _ENV, CS_ResLoader, CS_CameraController, CS_WaitForSeconds
  local battleController = (self._stageBossTab).battleController
  local newMonsterEntity = (self._stageBossTab).newMonsterEntity
  local monsterStageCfg = (self._stageBossTab).monsterStageCfg
  battleController:SetFreeze(newMonsterEntity)
  local waitAvg = false
  if not (string.IsNullOrEmpty)(monsterStageCfg.avg_name) then
    waitAvg = true
    local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
    avgCtrl:ShowAvg(monsterStageCfg.avg_name, function()
    -- function num : 0_28_0 , upvalues : waitAvg
    waitAvg = false
  end
, false, false)
  end
  do
    while waitAvg do
      (coroutine.yield)(nil)
    end
    local waitTimeline = false
    if monsterStageCfg.timeline_enable then
      waitTimeline = true
      local skillModle = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
      if skillModle ~= nil then
        skillModle:BattleHideAllUITween(true)
      end
      MsgCenter:Broadcast(eMsgEventId.OnMonsterStageShowStart)
      local newMonsterTransform = (newMonsterEntity.lsObject).transform
      local showEffectGo = nil
      if not (string.IsNullOrEmpty)(monsterStageCfg.action_effect) then
        local effectPath = monsterStageCfg.action_effect .. PathConsts.PrefabExtension
        if not self._monsterStageResloader then
          self._monsterStageResloader = (CS_ResLoader.Create)()
          do
            local prefab = (self._monsterStageResloader):LoadABAsset(effectPath)
            if not IsNull(prefab) then
              showEffectGo = prefab:Instantiate()
              ;
              (showEffectGo.transform):SetPositionAndRotation(newMonsterTransform.position, newMonsterTransform.rotation)
            end
            if monsterStageCfg.audio_id > 0 then
              AudioManager:PlayAudioById(monsterStageCfg.audio_id)
            end
            ;
            (CS_CameraController.Instance):SetMonStageVcam(newMonsterTransform)
            ;
            (TimelineUtil.Play)((CS_CameraController.Instance).monsterStageTimeline, function()
    -- function num : 0_28_1 , upvalues : waitTimeline
    waitTimeline = false
  end
)
            local actionComp = newMonsterEntity:GetActionComponent()
            if actionComp ~= nil then
              actionComp:SetAnimatorById(monsterStageCfg.action_id)
            end
            ;
            (coroutine.yield)(CS_WaitForSeconds(monsterStageCfg.action_time))
            while waitTimeline do
              (coroutine.yield)(nil)
            end
            ;
            (CS_CameraController.Instance):EndMonsterStageTimeline()
            do
              local skillModle = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
              if skillModle ~= nil then
                skillModle:BattleHideAllUITween(false)
              end
              DestroyUnityObject(showEffectGo)
              MsgCenter:Broadcast(eMsgEventId.OnMonsterStageShowEnd)
              LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnMonsterStageCreat, newMonsterEntity)
              battleController:SetUnFreeze(newMonsterEntity)
              self._stageBossCo = nil
            end
          end
        end
      end
    end
  end
end

DungeonBattleBaseCtrl.OnDelete = function(self)
  -- function num : 0_29 , upvalues : CS_BattleManager_Ins, _ENV
  CS_BattleManager_Ins:ClearBattleCache()
  if self._stageBossCo ~= nil then
    (GR.StopCoroutine)(self._stageBossCo)
    self._stageBossCo = nil
  end
  if self._monsterStageResloader ~= nil then
    (self._monsterStageResloader):Put2Pool()
    self._monsterStageResloader = nil
  end
  if self.__OnDragTileChanged ~= nil then
    ((CS.MsgDispatcher).RemoveListener)(eCsMsgEventType.OnDeployDragTileChanged, self.__OnDragTileChanged)
    self.__OnDragTileChanged = nil
  end
end

return DungeonBattleBaseCtrl

