-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessMapCtrl = class("WarChessMapCtrl", base)
local cs_GameObject = (CS.UnityEngine).GameObject
local cs_ResLoader = CS.ResLoader
local cs_wcAnmation = CS.WarChessGridAnimState
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local WarChessAreaData = require("Game.WarChess.Data.WarChessAreaData")
local WarChessGridData = require("Game.WarChess.Data.WarChessGridData")
local WCEntityClassDic = require("Game.WarChess.Data.SpecificEntityData.WCEntityClassDic")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local IDLE_1_HASH = (((CS.UnityEngine).Animator).StringToHash)("idle_1")
WarChessMapCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__bfList = nil
  self.__CurShowBFId = nil
  self.__worldSize = nil
  self.__areaMap = nil
  self.__areaDataListDic = nil
  self.__gridDataListDic = nil
  self.__entityDataListDic = nil
  self.__areaDataDic = nil
  self.__gridDataDic = nil
  self.__entityDataDic = nil
  self.__entityDataUIDDic = nil
  self.__fogSightDic = nil
  self.__couldDeployGridDic = nil
  self.__cacheLinkdeGroupListDic = nil
end

WarChessMapCtrl.SetWCMapData = function(self, battleFieldList)
  -- function num : 0_1 , upvalues : _ENV
  self.__bfList = {}
  self.__areaDataListDic = {}
  self.__gridDataListDic = {}
  self.__entityDataListDic = {}
  self.__fogSightDic = {}
  self.__worldSize = {}
  for _,bfMsg in ipairs(battleFieldList) do
    local BFId = bfMsg.gid
    if self.__CurShowBFId == nil then
      self.__CurShowBFId = BFId
    end
    ;
    (table.insert)(self.__bfList, BFId)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__areaDataListDic)[BFId] = bfMsg.areas
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__gridDataListDic)[BFId] = bfMsg.grids
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__entityDataListDic)[BFId] = bfMsg.gears
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__fogSightDic)[BFId] = {}
    -- DECOMPILER ERROR at PC48: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__worldSize)[BFId] = (Vector4.New)(0, 0, bfMsg.sizeX - 1, bfMsg.sizeY - 1)
    for coordination,_ in pairs(bfMsg.sight) do
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R13 in 'UnsetPending'

      ((self.__fogSightDic)[BFId])[coordination] = true
    end
  end
end

WarChessMapCtrl.GenMap = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.__areaDataDic = {}
  self.__gridDataDic = {}
  self.__entityDataDic = {}
  self.__entityDataUIDDic = {}
  self.__couldDeployGridDic = {}
  self.__loadOverFuncList = {}
  local __asyncWaitList = {}
  local asyncWaitList, loadOverFuncList = self:__LoadArea(self.__CurShowBFId)
  ;
  (table.insertto)(__asyncWaitList, asyncWaitList)
  ;
  (table.insertto)(self.__loadOverFuncList, loadOverFuncList)
  local asyncWaitList, loadOverFuncList = self:__GenEntitys(self.__CurShowBFId)
  ;
  (table.insertto)(__asyncWaitList, asyncWaitList)
  ;
  (table.insertto)(self.__loadOverFuncList, loadOverFuncList)
  self:__GenGrids(self.__CurShowBFId)
  return __asyncWaitList
end

WarChessMapCtrl.RewindMap = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:__GenGrids(self.__CurShowBFId)
  for BFId,entityDataXYDic in pairs(self.__entityDataDic) do
    for x,entityDataYDic in pairs(entityDataXYDic) do
      for y,entityData in pairs(entityDataYDic) do
        entityData:WCDeleteEntityGo()
        self:WCDeleteEntity(entityData)
      end
    end
  end
  self.__loadOverFuncList = {}
  local __asyncWaitList = {}
  local asyncWaitList, loadOverFuncList = self:__GenEntitys(self.__CurShowBFId)
  ;
  (table.insertto)(__asyncWaitList, asyncWaitList)
  ;
  (table.insertto)(self.__loadOverFuncList, loadOverFuncList)
  return __asyncWaitList
end

WarChessMapCtrl.__LoadArea = function(self, BFId)
  -- function num : 0_4 , upvalues : _ENV, WarChessAreaData
  local modelRoot = ((self.wcCtrl).bind).trans_AreaRoot
  self.__areaMap = {}
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__areaMap)[BFId] = {}
  local allAsyncWaitList = {}
  local allLoadOverFunc = {}
  for theBFId,areaDataList in pairs(self.__areaDataListDic) do
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R10 in 'UnsetPending'

    if theBFId == BFId then
      (self.__areaDataDic)[BFId] = {}
      for areaPos,areaMsg in pairs(areaDataList) do
        local wcAreaData = (WarChessAreaData.New)(areaPos, areaMsg)
        local asyncWaitList, loadOverFunc = wcAreaData:LoadWCArea(modelRoot)
        ;
        (table.insertto)(allAsyncWaitList, asyncWaitList)
        ;
        (table.insert)(allLoadOverFunc, loadOverFunc)
        -- DECOMPILER ERROR at PC42: Confused about usage of register: R18 in 'UnsetPending'

        ;
        ((self.__areaDataDic)[BFId])[areaPos] = wcAreaData
        wcAreaData:GenWcAreaGridPosDic((self.__areaMap)[BFId])
      end
    end
  end
  return allAsyncWaitList, allLoadOverFunc
end

WarChessMapCtrl.GetGridAreaPos = function(self, BFId, gridCoord)
  -- function num : 0_5 , upvalues : _ENV
  if (self.__areaMap)[BFId] and ((self.__areaMap)[BFId])[gridCoord] then
    return ((self.__areaMap)[BFId])[gridCoord]
  end
  error((string.format)("cant get grid area pos, BFId:%s, gridCoord:%s", BFId, gridCoord))
  return 0
end

WarChessMapCtrl.ReLoadArea = function(self, BFId)
  -- function num : 0_6 , upvalues : _ENV
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local areaDataDic = (self.__areaDataDic)[BFId]
  if areaDataDic == nil then
    error("can\'t reload wc area")
    return 
  end
  local modelRoot = ((self.wcCtrl).bind).trans_AreaRoot
  local allAsyncWaitList = {}
  local allLoadOverFunc = {}
  for areaPos,wcAreaData in pairs(areaDataDic) do
    local asyncWaitList, loadOverFunc = wcAreaData:LoadWCArea(modelRoot)
    ;
    (table.insertto)(allAsyncWaitList, asyncWaitList)
    ;
    (table.insert)(allLoadOverFunc, loadOverFunc)
  end
  self.__loadOverFuncList = allLoadOverFunc
  return allAsyncWaitList
end

WarChessMapCtrl.__GenGrids = function(self, BFId)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.__gridDataDic)[BFId] = {}
  local fogDic = (self.__fogSightDic)[BFId]
  for pos,gridCfgMsg in pairs((self.__gridDataListDic)[BFId]) do
    self:__GenGrid(BFId, gridCfgMsg, fogDic)
  end
  self.__gridDataListDic = nil
end

WarChessMapCtrl.__GenGrid = function(self, BFId, gridCfgMsg, fogDic)
  -- function num : 0_8 , upvalues : WarChessHelper, _ENV, WarChessGridData
  local x, y = (WarChessHelper.Coordination2Pos)(gridCfgMsg.pos)
  local worldLogicPos = (Vector2.New)(x, y)
  local coordination = (WarChessHelper.Pos2Coordination)(worldLogicPos)
  local areaCoord = self:GetGridAreaPos(BFId, gridCfgMsg.pos)
  local gridData = (WarChessGridData.New)(BFId, worldLogicPos, gridCfgMsg, areaCoord)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R10 in 'UnsetPending'

  if ((self.__gridDataDic)[BFId])[x] == nil then
    ((self.__gridDataDic)[BFId])[x] = {}
  end
  if fogDic[coordination] then
    gridData:SetWCGridIsInFog(false)
  end
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R10 in 'UnsetPending'

  ;
  (((self.__gridDataDic)[BFId])[x])[y] = gridData
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R10 in 'UnsetPending'

  if gridData:GetIsBornPoint() then
    (self.__couldDeployGridDic)[gridData] = true
  end
  return gridData
end

WarChessMapCtrl.__GenEntitys = function(self, BFId)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  (self.__entityDataDic)[BFId] = {}
  local allAsyncWaitList = {}
  local allLoadOverFunc = {}
  for uid,unitCfg in pairs((self.__entityDataListDic)[BFId]) do
    local asyncWait, loadOverFunc = self:__GenEntity(BFId, unitCfg, nil, nil)
    ;
    (table.insert)(allAsyncWaitList, asyncWait)
    ;
    (table.insert)(allLoadOverFunc, loadOverFunc)
  end
  self.__entityDataListDic = nil
  return allAsyncWaitList, allLoadOverFunc
end

WarChessMapCtrl.__GenEntity = function(self, BFId, unitCfg, notWait, bind)
  -- function num : 0_10 , upvalues : WarChessHelper, _ENV, WCEntityClassDic, eWarChessEnum
  local x, y = (WarChessHelper.Coordination2Pos)(unitCfg.pos)
  local worldLogicPos = (Vector2.New)(x, y)
  local clientType = ((ConfigData.warchess_entity_res)[unitCfg.resId]).client_cat
  if not WCEntityClassDic[clientType] then
    local entityClass = WCEntityClassDic[(eWarChessEnum.eEntityShowCat).common]
  end
  local entityData = (entityClass.New)(BFId, worldLogicPos, unitCfg)
  local asyncWait, loadOverFunc = entityData:InitWCEntity(notWait, bind)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R13 in 'UnsetPending'

  if ((self.__entityDataDic)[BFId])[x] == nil then
    ((self.__entityDataDic)[BFId])[x] = {}
  end
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R13 in 'UnsetPending'

  ;
  (((self.__entityDataDic)[BFId])[x])[y] = entityData
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R13 in 'UnsetPending'

  ;
  (self.__entityDataUIDDic)[unitCfg.id] = entityData
  entityData:SetEntityFxData(entityData:GetResEffectID(), (self.wcCtrl).animaCtrl)
  if not notWait then
    return asyncWait, loadOverFunc
  end
  return entityData
end

WarChessMapCtrl.ReLoadEntitys = function(self, BFId)
  -- function num : 0_11 , upvalues : _ENV
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local entityDataXYDic = (self.__entityDataDic)[BFId]
  if entityDataXYDic == nil then
    return 
  end
  for _,entityDataXDic in pairs(entityDataXYDic) do
    for _,entityData in pairs(entityDataXDic) do
      entityData:InitWCEntity(true, (self.wcCtrl).bind)
    end
  end
end

WarChessMapCtrl.ReapplyWCGridAnimation = function(self, gridData, isNewOne)
  -- function num : 0_12 , upvalues : _ENV, cs_wcAnmation
  if isNewOne then
    local gridCfgMsg = gridData:GetGridUnit()
    if gridCfgMsg.lastAnimationClipId ~= 0 then
      local gridGo = self:GetAreaObjectByGridData(gridData)
      if not IsNull(gridGo) then
        local gridGoAnimState = gridGo:GetComponentInChildren(typeof(cs_wcAnmation))
        if not IsNull(gridGoAnimState) then
          gridGoAnimState:SetStageValue(gridCfgMsg.lastAnimationClipId)
          local nameHash = gridGoAnimState:GetCurrentStateNameHash()
          gridData:SaveGridAnimArg(nameHash, gridCfgMsg.lastAnimationClipId)
        end
      end
    end
    do
      do
        if gridCfgMsg.fx ~= nil and #gridCfgMsg.fx > 0 then
          ((self.wcCtrl).animaCtrl):RefreshSingleCommonFX(gridData, gridCfgMsg.fx, true)
        end
        do return  end
        local saveAnim = gridData:GetGridAnimArg()
        if saveAnim ~= nil then
          local gridGo = self:GetAreaObjectByGridData(gridData)
          if gridGo ~= nil then
            local gridGoAnimState = gridGo:GetComponentInChildren(typeof(cs_wcAnmation))
            if gridGoAnimState ~= nil then
              gridGoAnimState:ReSetState(saveAnim.nameHash, saveAnim.animaId)
            end
          end
        end
      end
    end
  end
end

WarChessMapCtrl.ReapplyWCEntityAnimation = function(self, entityData, isNewOne)
  -- function num : 0_13
  do
    if isNewOne then
      local unitCfg = entityData:GetEntityUnit()
      if unitCfg.lastAnimationClipId ~= 0 then
        entityData:PlayEntityAnimation(unitCfg.lastAnimationClipId, nil)
      end
      if unitCfg.fx ~= nil and #unitCfg.fx > 0 then
        ((self.wcCtrl).animaCtrl):RefreshSingleCommonFX(entityData, unitCfg.fx, false)
      end
      return 
    end
    local saveAnim = entityData:GetEnitityAnimArg()
    if saveAnim ~= nil then
      entityData:ReapplyEntityAnimation(saveAnim)
    end
  end
end

WarChessMapCtrl.OnSceneLoadOver = function(self, isInit)
  -- function num : 0_14 , upvalues : _ENV
  for _,func in pairs(self.__loadOverFuncList) do
    if func ~= nil then
      func((self.wcCtrl).bind)
    end
  end
  for BFId,gridDataXYDic in pairs(self.__gridDataDic) do
    for x,gridDataYDic in pairs(gridDataXYDic) do
      for y,gridData in pairs(gridDataYDic) do
        self:ReapplyWCGridAnimation(gridData, isInit)
      end
    end
  end
  for BFId,entityDataXYDic in pairs(self.__entityDataDic) do
    for x,entityDataYDic in pairs(entityDataXYDic) do
      for y,entityData in pairs(entityDataYDic) do
        self:ReapplyWCEntityAnimation(entityData, isInit)
      end
    end
  end
  self.__loadOverFuncList = nil
end

WarChessMapCtrl.AfterAnimationCtrlLoadOver = function(self)
  -- function num : 0_15
  self:RefreshAllAlarmEntity()
  ;
  ((self.wcCtrl).animaCtrl):RefeshAllEntityLinkFx()
end

WarChessMapCtrl.UpdateMapUnits = function(self, unitUpdates)
  -- function num : 0_16 , upvalues : _ENV, WarChessHelper
  local isNeedCleanCacheLinkedGroup = false
  for BFId,unitUpdate in pairs(unitUpdates) do
    for coordination,unit in pairs(unitUpdate.gridUpdate) do
      local x, y = (WarChessHelper.Coordination2Pos)(unit.pos)
      local gridData = nil
      if (self.__gridDataDic)[BFId] ~= nil and ((self.__gridDataDic)[BFId])[x] ~= nil then
        gridData = (((self.__gridDataDic)[BFId])[x])[y]
      end
      if gridData ~= nil then
        gridData:SetWCGridUnitCfg(unit)
        ;
        ((self.wcCtrl).animaCtrl):UpdateSingleWCFX(gridData)
      else
        local fogDic = (self.__fogSightDic)[BFId]
        gridData = self:__GenGrid(BFId, unit, fogDic)
        self:ReapplyWCGridAnimation(gridData, true)
      end
      do
        do
          MsgCenter:Broadcast(eMsgEventId.WC_GridInfoUpdate, gridData)
          -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out DO_STMT

        end
      end
    end
    for uid,unit in pairs(unitUpdate.gearUpdate) do
      local entityData = (self.__entityDataUIDDic)[uid]
      if entityData ~= nil then
        entityData:SetWCEntityUnitCfg(unit)
        local curPos = entityData:GetEntityLogicPos()
        local x, y = (WarChessHelper.Coordination2Pos)(unit.pos)
        if curPos.x ~= x or curPos.y ~= y then
          local oldPos = entityData:GetEntityLogicPos()
          do
            do
              do
                if (self.__entityDataDic)[BFId] ~= nil and ((self.__entityDataDic)[BFId])[oldPos.x] ~= nil then
                  local oldPosEntityData = (((self.__entityDataDic)[BFId])[oldPos.x])[oldPos.y]
                  -- DECOMPILER ERROR at PC104: Confused about usage of register: R19 in 'UnsetPending'

                  if oldPosEntityData == entityData then
                    (((self.__entityDataDic)[BFId])[oldPos.x])[oldPos.y] = nil
                  end
                end
                -- DECOMPILER ERROR at PC111: Confused about usage of register: R18 in 'UnsetPending'

                if (self.__entityDataDic)[BFId] == nil then
                  (self.__entityDataDic)[BFId] = {}
                end
                -- DECOMPILER ERROR at PC120: Confused about usage of register: R18 in 'UnsetPending'

                if ((self.__entityDataDic)[BFId])[x] == nil then
                  ((self.__entityDataDic)[BFId])[x] = {}
                end
                -- DECOMPILER ERROR at PC124: Confused about usage of register: R18 in 'UnsetPending'

                ;
                (((self.__entityDataDic)[BFId])[x])[y] = entityData
                if isGameDev then
                  print((string.format)("uid:%s 从%d,%d 移动到%d,%d", tostring(unit), oldPos.x, oldPos.y, x, y))
                end
                entityData:SetNewPos(x, y)
                ;
                ((self.wcCtrl).animaCtrl):UpdateSingleWCFX(entityData)
                do
                  do
                    local x, y = (WarChessHelper.Coordination2Pos)(unit.pos)
                    entityData = self:__GenEntity(BFId, unit, true, (self.wcCtrl).bind)
                    self:ReapplyWCEntityAnimation(entityData, true)
                    isNeedCleanCacheLinkedGroup = entityData:GetEntitySymbioticId() ~= nil
                    MsgCenter:Broadcast(eMsgEventId.WC_EntityInfoUpdate, entityData)
                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC178: LeaveBlock: unexpected jumping out IF_STMT

                  end
                end
              end
            end
          end
        end
      end
    end
  end
  if isNeedCleanCacheLinkedGroup then
    self:CleanCachedLinkedGroupListDic()
    ;
    ((self.wcCtrl).animaCtrl):RefeshAllEntityLinkFx()
  end
  self:RefreshAllAlarmEntity()
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

WarChessMapCtrl.UpdateMapUnitsDelete = function(self, unitUpdates)
  -- function num : 0_17 , upvalues : _ENV
  local isNeedCleanCacheLinkedGroup = nil
  for BFId,unitUpdate in pairs(unitUpdates) do
    for uid,_ in pairs(unitUpdate.gearDestroy) do
      local entityData = (self.__entityDataUIDDic)[uid]
      if entityData ~= nil then
        entityData:SetWCEntityIsAlive(false)
        entityData:PlayEntityAnimation(-1)
        self:WCDeleteEntity(entityData)
        isNeedCleanCacheLinkedGroup = entityData:GetEntitySymbioticId() ~= nil
        MsgCenter:Broadcast(eMsgEventId.WC_EntityInfoUpdate, entityData, true)
      end
    end
  end
  if isNeedCleanCacheLinkedGroup then
    self:CleanCachedLinkedGroupListDic()
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

WarChessMapCtrl.GetMapFogInfo = function(self, BFId)
  -- function num : 0_18
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local mapFogInfo = {}
  mapFogInfo.openFogOfWar = self:IsOpenFogOfWar()
  local size = (self.__worldSize)[BFId]
  local width = size.z - size.x
  local height = size.w - size.y
  mapFogInfo.mapWidth = width
  mapFogInfo.mapHeight = height
  return mapFogInfo
end

WarChessMapCtrl.IsOpenFogOfWar = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local levelId = WarChessManager:GetWCLevelId()
  local levelData = (ConfigData.warchess_level)[levelId]
  if levelData ~= nil and levelData.open_fog_of_war ~= nil then
    return levelData.open_fog_of_war
  end
  return true
end

WarChessMapCtrl.GetWcMapSizeV4 = function(self, BFId)
  -- function num : 0_20
  if not BFId then
    BFId = self.__CurShowBFId
  end
  return (self.__worldSize)[BFId]
end

WarChessMapCtrl.GetWCFogData = function(self, BFId)
  -- function num : 0_21
  if not BFId then
    BFId = self.__CurShowBFId
  end
  return (self.__fogSightDic)[BFId]
end

WarChessMapCtrl.UpdateWCFogData = function(self, sightDiff)
  -- function num : 0_22 , upvalues : _ENV, WarChessHelper
  for BFId,diffDatas in pairs(sightDiff) do
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R7 in 'UnsetPending'

    if (self.__fogSightDic)[BFId] == nil then
      (self.__fogSightDic)[BFId] = {}
    end
    for coordination,bool in pairs(diffDatas.update) do
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R12 in 'UnsetPending'

      ((self.__fogSightDic)[BFId])[coordination] = bool
      local x, y = (WarChessHelper.Coordination2Pos)(coordination)
      local gridData = ((self.__gridDataDic)[BFId])[x] ~= nil and (((self.__gridDataDic)[BFId])[x])[y] or nil
      if gridData ~= nil then
        gridData:SetWCGridIsInFog(not bool)
      end
    end
  end
  self:RefreshAllAlarmEntity()
end

WarChessMapCtrl.GetGridDataDic = function(self, BFId)
  -- function num : 0_23
  if not BFId then
    BFId = self.__CurShowBFId
  end
  return (self.__gridDataDic)[BFId]
end

WarChessMapCtrl.WCDeleteEntity = function(self, entityData)
  -- function num : 0_24
  local BFId = entityData:GetWCEntityBFId()
  local pos = entityData:GetEntityLogicPos()
  local x, y = pos.x, pos.y
  local dataDic = (self.__entityDataDic)[BFId]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R7 in 'UnsetPending'

  if dataDic ~= nil and dataDic[x] ~= nil and (dataDic[x])[y] == entityData then
    (dataDic[x])[y] = nil
  end
  local uid = entityData:GetEntityUnitId()
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.__entityDataUIDDic)[uid] = nil
end

WarChessMapCtrl.GetGridDataByGrounPos = function(self, BFId, pos)
  -- function num : 0_25 , upvalues : _ENV
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local x = (math.floor)(pos.x + 0.5)
  local y = (math.floor)(pos.z + 0.5)
  if ((self.__gridDataDic)[BFId])[x] == nil then
    return 
  end
  return (((self.__gridDataDic)[BFId])[x])[y]
end

WarChessMapCtrl.GetGridDataByLogicPos = function(self, BFId, pos)
  -- function num : 0_26
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local x = pos.x
  local y = pos.y
  return self:GetGridDataByLogicXY(BFId, x, y)
end

WarChessMapCtrl.GetGridDataByLogicXY = function(self, BFId, x, y)
  -- function num : 0_27
  if not BFId then
    BFId = self.__CurShowBFId
  end
  if ((self.__gridDataDic)[BFId])[x] == nil then
    return 
  end
  return (((self.__gridDataDic)[BFId])[x])[y]
end

WarChessMapCtrl.GetEntityDataByLogicPos = function(self, BFId, pos)
  -- function num : 0_28
  if not BFId then
    BFId = self.__CurShowBFId
  end
  local x = pos.x
  local y = pos.y
  return self:GetEntityDataByLogicPosXY(BFId, x, y)
end

WarChessMapCtrl.GetEntityDataByLogicPosXY = function(self, BFId, x, y)
  -- function num : 0_29
  if not BFId then
    BFId = self.__CurShowBFId
  end
  if ((self.__entityDataDic)[BFId])[x] == nil then
    return 
  end
  return (((self.__entityDataDic)[BFId])[x])[y]
end

WarChessMapCtrl.GetAreaObjectByGridData = function(self, gridData, isGround)
  -- function num : 0_30 , upvalues : _ENV
  local logicPos = gridData:GetGridLogicPos()
  local BFId = gridData:GetWCGridBFId()
  local areaPos = gridData:GetWcGridAreaCoordination()
  if (self.__areaDataDic)[BFId] then
    local areaData = ((self.__areaDataDic)[BFId])[areaPos]
  end
  if areaData == nil then
    error((string.format)("cant get areaData, BFId:%s, gridCoord:%s", BFId, areaPos))
    return nil
  end
  return self:GetAreaObjectByXY(BFId, areaData, logicPos.x, logicPos.y, isGround)
end

WarChessMapCtrl.GetAreaObjectByXY = function(self, BFId, areaData, x, y, isGround)
  -- function num : 0_31 , upvalues : WarChessHelper, _ENV
  if not BFId then
    BFId = self.__CurShowBFId
  end
  if areaData == nil then
    local coordination = (WarChessHelper.PosXy2Coordination)(x, y)
    local areaPos = self:GetGridAreaPos(BFId, coordination)
    if (self.__areaDataDic)[BFId] then
      areaData = ((self.__areaDataDic)[BFId])[areaPos]
    end
  end
  do
    x = (WarChessHelper.GenGridInAreaPos)(x, y, areaData)
    local go = nil
    if isGround then
      go = areaData:GetWCAreaGroundGo(x, y)
    else
      go = areaData:GetWCAreaGo(x, y)
    end
    if go == nil then
      error("can\'t get  gridGo, pls chekck is update pfefab script:WCAreaRoot")
    end
    return go
  end
end

WarChessMapCtrl.TryShowWCMonsterCouldMoveRange = function(self, isShow, entityData)
  -- function num : 0_32 , upvalues : WarChessHelper
  if isShow then
    local isOK = (WarChessHelper.CheckEnemyCanMove)(entityData)
    if isOK then
      local teamLogicPos = entityData:GetEntityLogicPos()
      local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamLogicPos)
      local couldReachGridDic, _, levelNubDic = (WarChessHelper.BSFAllCouldReachGrid)(self, startGrid, entityData, true)
      ;
      ((self.wcCtrl).animaCtrl):SetMonsterMoveableGridDic(couldReachGridDic, levelNubDic)
    else
      do
        do
          ;
          ((self.wcCtrl).animaCtrl):SetMonsterMoveableGridDic(nil)
          ;
          ((self.wcCtrl).animaCtrl):SetMonsterMoveableGridDic(nil)
        end
      end
    end
  end
end

WarChessMapCtrl.ReSetEveryAnimation2DefaultState = function(self)
  -- function num : 0_33 , upvalues : _ENV, cs_wcAnmation, IDLE_1_HASH
  for BFId,gridDataXYDic in pairs(self.__gridDataDic) do
    for x,gridDataYDic in pairs(gridDataXYDic) do
      for y,gridData in pairs(gridDataYDic) do
        local gridGo = self:GetAreaObjectByGridData(gridData)
        if not IsNull(gridGo) then
          local gridGoAnimState = gridGo:GetComponentInChildren(typeof(cs_wcAnmation))
          if gridGoAnimState ~= nil and (gridGoAnimState.gridAnimator):HasState(0, IDLE_1_HASH) then
            gridGoAnimState:ReSetState(IDLE_1_HASH, 1)
          end
        end
      end
    end
  end
end

WarChessMapCtrl.GetAllCouldBornGrid = function(self)
  -- function num : 0_34
  return self.__couldDeployGridDic
end

WarChessMapCtrl.CleanCachedLinkedGroupListDic = function(self)
  -- function num : 0_35
  self.__cacheLinkdeGroupListDic = nil
end

WarChessMapCtrl.GetAllLinkedEntityGroupData = function(self)
  -- function num : 0_36 , upvalues : _ENV
  if self.__cacheLinkdeGroupListDic ~= nil then
    return self.__cacheLinkdeGroupListDic
  end
  local groupListDic = {}
  for BFId,entityDataXYDic in pairs(self.__entityDataDic) do
    for x,entityDataYDic in pairs(entityDataXYDic) do
      for y,entityData in pairs(entityDataYDic) do
        local symbioticId = entityData:GetEntitySymbioticId()
        if symbioticId ~= nil then
          if groupListDic[symbioticId] == nil then
            groupListDic[symbioticId] = {}
          end
          ;
          (table.insert)(groupListDic[symbioticId], entityData)
        end
      end
    end
  end
  self.__cacheLinkdeGroupListDic = groupListDic
  return groupListDic
end

WarChessMapCtrl.RefreshAllAlarmEntity = function(self)
  -- function num : 0_37 , upvalues : _ENV
  for BFId,entityDataXYDic in pairs(self.__entityDataDic) do
    for x,entityDataYDic in pairs(entityDataXYDic) do
      for y,entityData in pairs(entityDataYDic) do
        self:RefreshAlarmEntity(entityData)
      end
    end
  end
end

WarChessMapCtrl.RefreshAlarmEntity = function(self, entityData)
  -- function num : 0_38 , upvalues : WarChessHelper
  if entityData:GetEntityIsMonster() then
    local alarmCfg = entityData:GetAlarmCfg()
    if alarmCfg.isAlarm then
      local teamLogicPos = entityData:GetEntityLogicPos()
      local startGrid = self:GetGridDataByLogicPos(nil, teamLogicPos)
      local couldReachGridDic, _, levelNubDic = (WarChessHelper.BSFAllCouldReachGrid)(self, startGrid, entityData, true, true)
      ;
      ((self.wcCtrl).animaCtrl):SetMonsterAlarmGridDic(couldReachGridDic, levelNubDic, entityData, alarmCfg.distance)
    end
  end
end

WarChessMapCtrl.OnSceneUnload = function(self)
  -- function num : 0_39 , upvalues : _ENV
  for gearId,entityData in pairs(self.__entityDataUIDDic) do
    entityData:WCEntityDataOnSceneUnload()
    entityData:WCDeleteEntityGo()
  end
end

return WarChessMapCtrl

