-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonSceneBaseCtrl = class("DungeonSceneBaseCtrl")
local util = require("XLua.Common.xlua_util")
local CameraEffectUtil = require("Game.Exploration.Util.CameraEffectUtil")
local ExclusiveWeaponEffectUtil = require("Game.ExclusiveWeaponEffect.ExclusiveWeaponEffectUtil")
local cs_ResLoader = CS.ResLoader
local cs_BattlePosData = CS.BattlePosData
local CS_CameraController = CS.CameraController
DungeonSceneBaseCtrl.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.heroResLoaderDic = {}
  self.__inRoleChanging = false
  self.__OnEpFouceBattleBossStart = BindCallback(self, self.OnEpStartFouceBattleBoss, true)
  MsgCenter:AddListener(eMsgEventId.OnStartFocusBossTimeLine, self.__OnEpFouceBattleBossStart)
  self.__OnEpFouceBattleBossEnd = BindCallback(self, self.OnEpStartFouceBattleBoss, false)
  MsgCenter:AddListener(eMsgEventId.OnEndFocusBossTimeLine, self.__OnEpFouceBattleBossEnd)
end

DungeonSceneBaseCtrl.SaveReuseHeroResloader = function(self, heroResDic)
  -- function num : 0_1
  self.__reuseHeroResDic = heroResDic
end

DungeonSceneBaseCtrl.__PreLoadCharacterAndSkill = function(self, dynPlayer, heroPrefabs, heroObjectDic, noshow)
  -- function num : 0_2 , upvalues : _ENV, cs_ResLoader, ExclusiveWeaponEffectUtil
  local waitList = {}
  local perfectModelLevel = -1
  if (BattleUtil.IsInTDBattle)() then
    perfectModelLevel = (ConfigData.buildinConfig).TowerModelLevel
  end
  for heroId,dynHero in pairs(dynPlayer.heroDic) do
    if dynHero ~= nil then
      local modelPath = PathConsts:GetCharacterModelPathEx(dynHero:GetResModelName(), dynHero.modelSpecSign, perfectModelLevel)
      local resloader = (self.heroResLoaderDic)[heroId]
      if resloader == nil then
        resloader = (cs_ResLoader.Create)()
        -- DECOMPILER ERROR at PC31: Confused about usage of register: R14 in 'UnsetPending'

        ;
        (self.heroResLoaderDic)[heroId] = resloader
      end
      local wait = resloader:LoadABAssetAsyncAwait(modelPath)
      waitList[heroId] = wait
    end
  end
  for heroId,wait in pairs(waitList) do
    (coroutine.yield)(wait)
    heroPrefabs[heroId] = wait.Result
  end
  if self.__reuseHeroResDic ~= nil then
    for heroId,resloader in pairs(self.__reuseHeroResDic) do
      resloader:Put2Pool()
    end
    self.__reuseHeroResDic = nil
  end
  self.heroModelHolder = (((CS.UnityEngine).GameObject)("HeroModelHolder")).transform
  local size_row, size_col, delopyRow, gridScaleFactor = self:GetBattleFieldSizeBySceneId()
  local battlePos = (CS.BattlePosData)(size_row, size_col, (ConfigData.game_config).battleMap_bench_count, gridScaleFactor)
  for heroId,heroPrefab in pairs(heroPrefabs) do
    local heroGo = heroPrefab:Instantiate(self.heroModelHolder)
    local dynHero = (dynPlayer.heroDic)[heroId]
    local logicPos = nil
    if dynHero.onBench then
      logicPos = ((battlePos.benchLogicPosMap)[dynHero.y]):ToVector3()
    else
      logicPos = ((battlePos.boardLogicPosMap):GetValue(dynHero.x, dynHero.y)):ToVector3()
    end
    -- DECOMPILER ERROR at PC109: Confused about usage of register: R20 in 'UnsetPending'

    ;
    (heroGo.transform).position = logicPos
    -- DECOMPILER ERROR at PC112: Confused about usage of register: R20 in 'UnsetPending'

    ;
    (self.heroObjectDic)[dynHero.dataId] = heroGo
    if noshow then
      heroGo:SetActive(false)
    end
    ;
    (coroutine.yield)()
    ExclusiveWeaponEffectUtil:PlayEWEffectByHeroData(dynHero.heroData, heroGo, (ExclusiveWeaponEffectUtil.EEwEffectType).Battle)
  end
  for heroId,dynHero in pairs(dynPlayer.heroDic) do
    local originSkillList = dynHero:GetOriginSkillList()
    for _,skill in pairs(originSkillList) do
      skill:PreloadSkill(self.effectPoolCtrl, dynHero)
    end
    ;
    (coroutine.yield)()
  end
end

DungeonSceneBaseCtrl.__InitDungeonSceneEffect = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.effectPoolCtrl = (CS.EffectPoolController)()
  ;
  (self.effectPoolCtrl):OnInit()
  local resloader = (self.effectPoolCtrl).resloader
  local leapBackEffectPath = "FX/Common/FX_Transition/FXP_Transition_Back" .. PathConsts.PrefabExtension
  local effectWaitBack = resloader:LoadABAssetAsyncAwait(leapBackEffectPath)
  local leapEffectPath = "FX/Common/FX_Transition/FXP_Transition" .. PathConsts.PrefabExtension
  local effectWait = resloader:LoadABAssetAsyncAwait(leapEffectPath)
  local lightWait = resloader:LoadABAssetAsyncAwait("FX/Common/FX_Lightpoles/FXP_Lightpoles" .. PathConsts.PrefabExtension)
  ;
  (coroutine.yield)(effectWaitBack)
  local roleDisappearEffectPrefab = effectWaitBack.Result
  self.__roleDisappearEffectCode = roleDisappearEffectPrefab.name
  ;
  (self.effectPoolCtrl):AddCommonPrefab(roleDisappearEffectPrefab)
  ;
  (coroutine.yield)(effectWait)
  local roleAppearEffectPrefab = effectWait.Result
  self.__roleAppearEffectCode = roleAppearEffectPrefab.name
  ;
  (self.effectPoolCtrl):AddCommonPrefab(roleAppearEffectPrefab)
  ;
  (coroutine.yield)(lightWait)
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R9 in 'UnsetPending'

  if (BattleUtil.IsInTDBattle)() then
    (CS.BattleConsts).DeployPlayerGrid = "FX/Common/FX_UI/FXP_pickHexagonPlayer/FXUI_pickHexagonPlayer_tower"
  else
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (CS.BattleConsts).DeployPlayerGrid = (ConfigData.game_config).deployPlayerGridSrc
  end
  self:__InitDungeonCameraEffect(resloader)
end

DungeonSceneBaseCtrl.__InitDungeonCameraEffect = function(self, resloader)
  -- function num : 0_4 , upvalues : _ENV, CameraEffectUtil
  if not ExplorationManager:IsInExploration() then
    return 
  end
  local floorId = ExplorationManager.floorId
  if floorId == nil then
    return 
  end
  local explorationConfig = (ConfigData.exploration)[floorId]
  if explorationConfig == nil then
    error("explorationConfig is nil !! check ExplorationManager.floorId" .. tostring(ExplorationManager.floorId))
    return 
  end
  local sceen_camera_effect_id = explorationConfig.sceen_camera_effect_id
  if sceen_camera_effect_id == 0 then
    return 
  end
  if explorationConfig.effective_range ~= 0 then
    return 
  end
  if (CameraEffectUtil.CameraEffectFunction)[sceen_camera_effect_id] == nil then
    return 
  end
  self.sceen_camera_effect_id = sceen_camera_effect_id
  ;
  ((CameraEffectUtil.CameraEffectFunction)[sceen_camera_effect_id])()
end

DungeonSceneBaseCtrl.GetRoleAppearEffect = function(self)
  -- function num : 0_5
  return (self.effectPoolCtrl):GetCommonEffect(self.__roleAppearEffectCode)
end

DungeonSceneBaseCtrl.GetRoleDisappearEffect = function(self)
  -- function num : 0_6
  return (self.effectPoolCtrl):GetCommonEffect(self.__roleDisappearEffectCode)
end

DungeonSceneBaseCtrl.GetDungeonCrazyTime = function(self)
  -- function num : 0_7
end

DungeonSceneBaseCtrl.GetBattleFieldSizeBySceneId = function(self)
  -- function num : 0_8
end

DungeonSceneBaseCtrl.CheckAndOpenSepcialMode = function(self, sceneCfg)
  -- function num : 0_9 , upvalues : CS_CameraController, _ENV
  if sceneCfg.depth_support then
    local mainCam = (CS_CameraController.Instance).MainCamera
    if not IsNull(mainCam) then
      mainCam.depthTextureMode = ((CS.UnityEngine).DepthTextureMode).Depth
    end
  end
end

DungeonSceneBaseCtrl.SwithCameraCtrlState = function(self, cameraState)
  -- function num : 0_10 , upvalues : CS_CameraController
  (CS_CameraController.Instance):SetControlState(cameraState)
end

DungeonSceneBaseCtrl.SceneResetBattleCamera = function(self)
  -- function num : 0_11 , upvalues : CS_CameraController
  (CS_CameraController.Instance):BattleCameraReset()
end

DungeonSceneBaseCtrl.SetEpMapCameraCullMask = function(self, LayerMaskEnum)
  -- function num : 0_12 , upvalues : CS_CameraController
  local epMapCamera = (CS_CameraController.Instance).EpMapCamera
  if epMapCamera then
    epMapCamera.cullingMask = 1 << LayerMaskEnum
  end
end

DungeonSceneBaseCtrl.EnterBattleDeployFormation = function(self, callBack)
  -- function num : 0_13 , upvalues : _ENV
  if IsNull((self.bind).tl_BtDeployFormation) then
    error("tl_BtDeployFormation is nil")
    return 
  end
  self._enterFmtCallBack = callBack
  ;
  (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(self.__onSkipTimeline, false, nil, Color.clear, false)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.bind).vcam_BattleDeployFormation).enabled = true
  if not self._OnEnterFmtFunc then
    self._OnEnterFmtFunc = BindCallback(self, self._OnEnd_EnterBattleDeployFormation)
    return (TimelineUtil.Play)((self.bind).tl_BtDeployFormation, self._OnEnterFmtFunc)
  end
end

DungeonSceneBaseCtrl._OnEnd_EnterBattleDeployFormation = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  if self._enterFmtCallBack ~= nil then
    (self._enterFmtCallBack)()
  end
end

DungeonSceneBaseCtrl.ExitBattleDeployFormation = function(self, callBack)
  -- function num : 0_15 , upvalues : _ENV
  if IsNull((self.bind).tl_BtDeployFormation) then
    error("tl_BtDeployFormation is nil")
    return 
  end
  self._exitFmtCallBack = callBack
  ;
  (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(self.__onSkipTimeline, false, nil, Color.clear, false)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.bind).vcam_BattleDeployFormation).enabled = false
  if not self._OnExitFmtFunc then
    self._OnExitFmtFunc = BindCallback(self, self._OnEnd_ExitBattleDeployFormation)
    return (TimelineUtil.Rewind)((self.bind).tl_BtDeployFormation, self._OnExitFmtFunc)
  end
end

DungeonSceneBaseCtrl._OnEnd_ExitBattleDeployFormation = function(self)
  -- function num : 0_16 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  if self._exitFmtCallBack ~= nil then
    (self._exitFmtCallBack)()
  end
end

DungeonSceneBaseCtrl.IsRoleChangingState = function(self)
  -- function num : 0_17
  return self.__inRoleChanging
end

DungeonSceneBaseCtrl.ChangeEpHeroModel = function(self, srcDynHeroList, tarDynHeroList, onFinish, immediateDeleteOldHero)
  -- function num : 0_18 , upvalues : _ENV, cs_BattlePosData, cs_ResLoader, util
  if self.__inRoleChanging then
    error("当前已经在助战更换角色中...")
    return 
  end
  self.__inRoleChanging = true
  AudioManager:RemoveCueSheetsWithPrefix(eAuCueSheet.Prefix_Character)
  for k,dynHero in ipairs(srcDynHeroList) do
    local srcHeroId = dynHero.dataId
    local srcResLoader = (self.heroResLoaderDic)[srcHeroId]
    if srcResLoader ~= nil then
      local srcObj = (self.heroObjectDic)[srcHeroId]
      if immediateDeleteOldHero then
        DestroyUnityObject(srcObj)
        srcResLoader:Put2Pool()
      else
        if not self._waitDeleteHero then
          do
            self._waitDeleteHero = {
resloaderList = {}
, 
gameObjectList = {}
}
            ;
            (table.insert)((self._waitDeleteHero).gameObjectList, srcObj)
            ;
            (table.insert)((self._waitDeleteHero).resloaderList, srcResLoader)
            -- DECOMPILER ERROR at PC54: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self.heroObjectDic)[srcHeroId] = nil
            -- DECOMPILER ERROR at PC56: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self.heroPrefabs)[srcHeroId] = nil
            -- DECOMPILER ERROR at PC58: Confused about usage of register: R13 in 'UnsetPending'

            ;
            (self.heroResLoaderDic)[srcHeroId] = nil
            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC59: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local loadFunc = function()
    -- function num : 0_18_0 , upvalues : _ENV, cs_BattlePosData, tarDynHeroList, cs_ResLoader, self, onFinish
    local size_row, size_col, delopyRow, gridScalFactor = (BattleUtil.GetCurSceneBattleFieldSize)()
    local battlePos = cs_BattlePosData(size_row, size_col, (ConfigData.game_config).battleMap_bench_count, gridScalFactor)
    local waitList = {}
    for k,dynHero in ipairs(tarDynHeroList) do
      local heroId = dynHero.dataId
      local modelPath = PathConsts:GetCharacterModelPathEx(dynHero:GetResModelName(), dynHero.modelSpecSign)
      local resLoader = (cs_ResLoader.Create)()
      -- DECOMPILER ERROR at PC26: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self.heroResLoaderDic)[heroId] = resLoader
      local wait = resLoader:LoadABAssetAsyncAwait(modelPath)
      waitList[k] = wait
    end
    for k,dynHero in ipairs(tarDynHeroList) do
      local heroId = dynHero.dataId
      local wait = waitList[k]
      ;
      (coroutine.yield)(wait)
      local heroPrefab = wait.Result
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R14 in 'UnsetPending'

      ;
      (self.heroPrefabs)[heroId] = heroPrefab
      local heroGo = (heroPrefab:Instantiate(self.heroModelHolder))
      local logicPos = nil
      if dynHero.onBench then
        logicPos = ((battlePos.benchLogicPosMap)[dynHero.y]):ToVector3()
      else
        logicPos = ((battlePos.boardLogicPosMap):GetValue(dynHero.x, dynHero.y)):ToVector3()
      end
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (heroGo.transform).position = logicPos
      -- DECOMPILER ERROR at PC72: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (self.heroObjectDic)[dynHero.dataId] = heroGo
      ;
      (coroutine.yield)(nil)
    end
    self.__inRoleChanging = false
    self.__changeEpHeroModelCo = nil
    onFinish()
  end

  self:_ClearChangeEpHeroModelCo()
  self.__changeEpHeroModelCo = (GR.StartCoroutine)((util.cs_generator)(loadFunc))
end

DungeonSceneBaseCtrl.DeleteChangeEpHeroOldModel = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self._waitDeleteHero == nil then
    return 
  end
  do
    while #(self._waitDeleteHero).resloaderList > 0 do
      local resloader = (table.remove)((self._waitDeleteHero).resloaderList)
      resloader:Put2Pool()
    end
    while #(self._waitDeleteHero).gameObjectList > 0 do
      local go = (table.remove)((self._waitDeleteHero).gameObjectList)
      DestroyUnityObject(go)
    end
  end
end

DungeonSceneBaseCtrl._ClearChangeEpHeroModelCo = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.__changeEpHeroModelCo ~= nil then
    (GR.StopCoroutine)(self.__changeEpHeroModelCo)
    self.__changeEpHeroModelCo = nil
  end
end

DungeonSceneBaseCtrl.OnEpStartFouceBattleBoss = function(self, isHide)
  -- function num : 0_21 , upvalues : _ENV, util, CS_CameraController
  if not isHide then
    self.__bossCulling = false
    if self.__alreadyHiddenRole ~= nil then
      for role,_ in pairs(self.__alreadyHiddenRole) do
        -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

        ((role.lsObject).transform).localScale = Vector3.one
      end
    end
    do
      if self.__bossCullCoroutine ~= nil then
        (GR.StopCoroutine)(self.__bossCullCoroutine)
        self.__bossCullCoroutine = nil
      end
      do return  end
      self.__alreadyHiddenRole = {}
      self.__bossCulling = true
      local continueCulling = function(cameraInstance, curBattleController)
    -- function num : 0_21_0 , upvalues : _ENV, self
    if cameraInstance == nil or cameraInstance.GeneralCullingFocusPos == Vector3.down then
      if isGameDev then
        error("没有设置具体聚焦的单位，但是执行了TimeLine的剔除事件")
      end
      return 
    end
    while self.__bossCulling do
      local battleCtrl = curBattleController
      local camDir = cameraInstance.GeneralCullingFocusPos - (cameraInstance.transform).position
      local radius = (Vector3.SqrMagnitude)(camDir) + cameraInstance.cullingRangeOffset
      if battleCtrl ~= nil then
        self:DetectedHideRoleList(cameraInstance, (cameraInstance.transform).position, camDir, radius, (battleCtrl.EnemyTeamController).battleOriginRoleList)
        self:DetectedHideRoleList(cameraInstance, (cameraInstance.transform).position, camDir, radius, (battleCtrl.NeutralTeamController).dungeonRoleList)
        self:DetectedHideRoleList(cameraInstance, (cameraInstance.transform).position, camDir, radius, (battleCtrl.PlayerTeamController).battleOriginRoleList)
        self:DetectedHideRoleList(cameraInstance, (cameraInstance.transform).position, camDir, radius, (battleCtrl.PlayerTeamController).dungeonRoleList)
      end
      ;
      (coroutine.yield)(nil)
    end
  end

      self.__bossCullCoroutine = (GR.StartCoroutine)((util.cs_generator)(continueCulling, CS_CameraController.Instance, ((CS.BattleManager).Instance).CurBattleController))
    end
  end
end

DungeonSceneBaseCtrl.DetectedHideRoleList = function(self, cameraInstance, camPos, camDir, powRadius, roles)
  -- function num : 0_22 , upvalues : _ENV
  if cameraInstance == nil or cameraInstance.GeneralCullingFocusPos == Vector3.down then
    return 
  end
  for i = 0, roles.Count - 1 do
    local role = roles[i]
    if not (self.__alreadyHiddenRole)[role] and role.lsObject ~= nil and not role.isDead then
      local roleTrans = (role.lsObject).transform
      if not IsNull(roleTrans) and roleTrans.localPosition ~= cameraInstance.GeneralCullingFocusPos then
        local tempDir = roleTrans.localPosition - camPos
        local angle = (Vector3.Angle)(camDir, tempDir)
        if angle <= 90 then
          local dist = (Vector3.SqrMagnitude)(tempDir)
          if dist <= powRadius then
            roleTrans.localScale = Vector3.zero
            -- DECOMPILER ERROR at PC54: Confused about usage of register: R15 in 'UnsetPending'

            ;
            (self.__alreadyHiddenRole)[role] = true
          end
        end
      end
    end
  end
end

DungeonSceneBaseCtrl.BattleSceneDisposeMember = function(self)
  -- function num : 0_23 , upvalues : _ENV, CameraEffectUtil
  self:_ClearChangeEpHeroModelCo()
  self:DeleteChangeEpHeroOldModel()
  if self.effectPoolCtrl ~= nil then
    (self.effectPoolCtrl):Dispose()
    self.effectPoolCtrl = nil
  end
  if self.heroResLoaderDic ~= nil then
    for k,resLoader in pairs(self.heroResLoaderDic) do
      resLoader:Put2Pool()
    end
    self.heroResLoaderDic = nil
  end
  if self.sceen_camera_effect_id ~= nil and (CameraEffectUtil.CloseCameraEffectFunction)[self.sceen_camera_effect_id] ~= nil then
    ((CameraEffectUtil.CloseCameraEffectFunction)[self.sceen_camera_effect_id])()
  end
  if self.__reuseHeroResDic ~= nil then
    for k,resLoader in pairs(self.__reuseHeroResDic) do
      resLoader:Put2Pool()
    end
    self.__reuseHeroResDic = nil
  end
  if self.__bossCullCoroutine ~= nil then
    (GR.StopCoroutine)(self.__bossCullCoroutine)
    self.__bossCullCoroutine = nil
  end
end

DungeonSceneBaseCtrl.OnDelete = function(self)
  -- function num : 0_24 , upvalues : _ENV
  self:BattleSceneDisposeMember()
  MsgCenter:RemoveListener(eMsgEventId.OnStartFocusBossTimeLine, self.__OnEpFouceBattleBossStart)
  MsgCenter:RemoveListener(eMsgEventId.OnEndFocusBossTimeLine, self.__OnEpFouceBattleBossEnd)
end

return DungeonSceneBaseCtrl

