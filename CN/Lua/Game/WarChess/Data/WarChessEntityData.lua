-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessEntityData = class("WarChessEntityData")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local WCMonsterEntity = require("Game.WarChess.Entity.WCMonsterEntity")
local WCCommonEntity = require("Game.WarChess.Entity.WCCommonEntity")
local WarChessFXData = require("Game.WarChess.Data.WarChessFXData")
local WarChessConditionCheck = require("Game.WarChess.ConditionCheck.WarChessConditionCheck")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local WarChessSeasonUtil = require("Game.WarChessSeason.WarChessSeasonUtil")
WarChessEntityData.ctor = function(self, BFId, worldLogicPos, unitCfg)
  -- function num : 0_0 , upvalues : _ENV
  self.unitCfg = unitCfg
  self.BFId = BFId
  self.worldLogicPos = worldLogicPos
  self.pos = (Vector3.New)(worldLogicPos.x, 0, worldLogicPos.y)
  self.isAlive = true
  self.__totalHp = 1
  self.__monsterBattleRoomId = nil
  self.__monsterDropIconList = nil
  self.__monsterRandomRotate = nil
  self.__entity = nil
  self.__FXDataDic = {}
  self.__headIconOverraidId = nil
  self.__alarmCfg = nil
  self.__symbioticId = nil
  self.__wantedMonster = nil
  local entityResCfg = (ConfigData.warchess_entity_res)[unitCfg.resId]
  if entityResCfg == nil then
    error((string.format)("Cant get warchess_entity_res, id = %s", unitCfg.resId))
    return 
  end
  self._entityResCfg = entityResCfg
  self:TryReGenWCMonsterHP((self.unitCfg).battleSystemData)
  self:__GenBattleRoomID()
  self:__GenDropIcons()
  self:SetEntityHeadIcon((self.unitCfg).unitUI)
  self:__GenAlarmCfg()
  self:UpdateWCEntityAddParam((self.unitCfg).ohtherParam)
end

WarChessEntityData.InitWCEntity = function(self, notWait, bind)
  -- function num : 0_1 , upvalues : WCMonsterEntity, WCCommonEntity
  if (self.unitCfg).cat == 1 then
    local entity = (WCMonsterEntity.New)(self)
    self.__entity = entity
  else
    do
      do
        local entity = (WCCommonEntity.New)(self)
        self.__entity = entity
        return (self.__entity):PreLoadModel(notWait, bind)
      end
    end
  end
end

WarChessEntityData.SetWCEntityUnitCfg = function(self, unit)
  -- function num : 0_2
  self.unitCfg = unit
  self:__GenBattleRoomID()
  self:__GenDropIcons()
  self:SetEntityHeadIcon((self.unitCfg).unitUI)
  self:__GenAlarmCfg()
  self:UpdateWCEntityAddParam((self.unitCfg).ohtherParam)
end

WarChessEntityData.SetNewPos = function(self, x, y)
  -- function num : 0_3 , upvalues : _ENV
  local oldLogPos = self.worldLogicPos
  self.worldLogicPos = (Vector2.New)(x, y)
  self.pos = (Vector3.New)(x, 0, y)
  ;
  (self.__entity):WCEntitySetPos(self.pos, true, oldLogPos, self.worldLogicPos)
end

WarChessEntityData.UpdateWCEntityAddParam = function(self, unitParam)
  -- function num : 0_4
  if unitParam == nil then
    self.__symbioticId = nil
    self.__wantedMonster = nil
    return 
  end
  if unitParam.symbiotic ~= nil and unitParam.symbiotic ~= 0 then
    self.__symbioticId = unitParam.symbiotic
  else
    self.__symbioticId = nil
  end
  self.__wantedMonster = unitParam.wantedMonster
end

WarChessEntityData.WCEntityGetParentGO = function(self)
  -- function num : 0_5
  return (self.__entity):WCEntityGetParentGO()
end

WarChessEntityData.GetWCEntityBFId = function(self)
  -- function num : 0_6
  return self.BFId
end

WarChessEntityData.GetEntityLogicPos = function(self)
  -- function num : 0_7
  return self.worldLogicPos
end

WarChessEntityData.GetEntityShowPos = function(self)
  -- function num : 0_8
  return (self.__entity):WCEntityGetShowPos()
end

WarChessEntityData.SetWCEntityIsAlive = function(self, bool)
  -- function num : 0_9 , upvalues : _ENV
  if bool == false and isGameDev then
    print(tostring(self.pos) .. "的entity死了")
  end
  self.isAlive = bool
end

WarChessEntityData.GetWCEntityIsAlive = function(self)
  -- function num : 0_10
  return self.isAlive
end

WarChessEntityData.GetWCEntityCouldPass = function(self, isMonster)
  -- function num : 0_11
  if not self:GetWCEntityIsAlive() then
    return true
  end
  if isMonster then
    return self:GetEntityIsMonster()
  end
  return false
end

WarChessEntityData.GetResModelName = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId ~= nil then
      local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
      if monsterGroupCfg == nil then
        error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      else
        local monsterGroupId = monsterGroupCfg.team_id
        local monsterTeamList = (ConfigData.warchess_monster_team_data)[monsterGroupId]
        if monsterTeamList == nil then
          error("warchess_room_monster表怪物组ID不满足条件 >3000000 and <4000000 monsterGroupId:" .. tostring(monsterGroupId))
        else
          if monsterTeamList[1] == nil then
            error("warchess_room_monster表怪物组 不存在一号怪物 monsterGroupId:" .. tostring(monsterGroupId))
          else
            local monsterId = (monsterTeamList[1]).monster_id
            local monsterCfg = (ConfigData.monster)[monsterId]
            if monsterCfg ~= nil then
              local resId = monsterCfg.src_id
              local is_shadow = monsterCfg.is_shadow
              local resCfg = (ConfigData.resource_model)[resId]
              local firstMonsterRes = resCfg.res_Name
              if isGameDev then
                print("monsterId:" .. tostring(monsterId) .. " battleRoomId:" .. tostring(battleRoomId))
              end
              return firstMonsterRes, is_shadow
            end
          end
        end
      end
    end
  end
  do
    return (self._entityResCfg).prefeb
  end
end

WarChessEntityData.AutoAddFx = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId == nil then
      return 
    end
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
    if monsterGroupCfg == nil then
      error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      return 
    end
    local fxId = monsterGroupCfg.special_effect
    if fxId ~= nil and fxId ~= 0 then
      self:UpdateEntityMonsterFX(true, fxId)
      return 
    end
  end
end

WarChessEntityData.GetMonsterMatConfig = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId == nil then
      return nil
    end
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
    if monsterGroupCfg == nil then
      error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      return nil
    end
    return monsterGroupCfg.outline_enable, monsterGroupCfg.outline_color, monsterGroupCfg.outiline_hdr, monsterGroupCfg.outline_wider, monsterGroupCfg.outline_scale
  end
  do
    return nil
  end
end

WarChessEntityData.GetIsEmptyEntity = function(self)
  -- function num : 0_15
  return (self._entityResCfg).is_effect
end

WarChessEntityData.GetInteractShowOffset = function(self)
  -- function num : 0_16
  return (self._entityResCfg).height
end

WarChessEntityData.GetEntityUnit = function(self)
  -- function num : 0_17
  return self.unitCfg
end

WarChessEntityData.GetEntityUnitId = function(self)
  -- function num : 0_18
  return (self.unitCfg).id
end

WarChessEntityData.GetEntityInteractions = function(self)
  -- function num : 0_19
  return (self.unitCfg).interactions
end

WarChessEntityData.GetEntityCouldInteract = function(self)
  -- function num : 0_20 , upvalues : _ENV, WarChessConditionCheck
  if #self:GetEntityInteractions() < 1 then
    return false
  end
  local isHaveCouldUseOne = false
  for _,interaction in pairs(self:GetEntityInteractions()) do
    if (WarChessConditionCheck.CheckGridConditionTree)(self:GetEntityUnit(), interaction) then
      isHaveCouldUseOne = true
      break
    end
  end
  do
    return isHaveCouldUseOne
  end
end

WarChessEntityData.GetEntityInteractionRange = function(self)
  -- function num : 0_21
  return (self.unitCfg).opRange
end

WarChessEntityData.GetEntityIsMonster = function(self)
  -- function num : 0_22
  return (self._entityResCfg).is_monster
end

WarChessEntityData.IsWCUnitMonster = function(self)
  -- function num : 0_23
  return self:GetEntityIsMonster()
end

WarChessEntityData.GetFirstEntityInertactWithCat = function(self, specificCat)
  -- function num : 0_24 , upvalues : _ENV
  for _,interactCfg in pairs((self.unitCfg).interactions) do
    if interactCfg.cat == specificCat then
      return interactCfg
    end
  end
  return nil
end

WarChessEntityData.SaveEnitityAnimArg = function(self, nameHash, animaId)
  -- function num : 0_25
  self.__saveAnimData = {nameHash = nameHash, animaId = animaId}
end

WarChessEntityData.GetEnitityAnimArg = function(self)
  -- function num : 0_26
  return self.__saveAnimData
end

WarChessEntityData.PlayEntityAnimation = function(self, animaId, trigger, callback)
  -- function num : 0_27
  if (self._entityResCfg).is_monster then
    (self.__entity):PlayWCMonsterAnimation(animaId, trigger, callback)
  else
    ;
    (self.__entity):PlayWCEntityAnimation(animaId, trigger)
    if callback ~= nil then
      callback()
    end
  end
end

WarChessEntityData.ReapplyEntityAnimation = function(self, saveAnim)
  -- function num : 0_28
  if (self._entityResCfg).is_monster then
    (self.__entity):SetWCEntityAnimation(saveAnim.nameHash, saveAnim.animaId)
  end
end

WarChessEntityData.PlayMonsetAttackAnimation = function(self, teamData, callback)
  -- function num : 0_29 , upvalues : _ENV
  local attack_animation_play_rate = 1.5
  if (self._entityResCfg).is_monster then
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    local index = teamData:GetWCTeamIndex()
    local heroEntity = (wcCtrl.teamCtrl):GetWCHeroEntity(index, nil, nil)
    local showPos = heroEntity:WCHeroEntityGetShowPos()
    ;
    (self.__entity):PlayAttackAnimation(showPos, attack_animation_play_rate)
    self.__monsterAttackTimerId = TimerManager:StartTimer(1 / attack_animation_play_rate, function()
    -- function num : 0_29_0 , upvalues : self, callback
    (self.__entity):EndPlayAttackAnimation()
    if callback ~= nil then
      callback()
    end
    self.__monsterAttackTimerId = nil
  end
, self, true)
  else
    do
      if callback ~= nil then
        callback()
      end
    end
  end
end

WarChessEntityData.GetFxDataDic = function(self)
  -- function num : 0_30
  return self.__FXDataDic
end

WarChessEntityData.GetBattleRoomID = function(self)
  -- function num : 0_31
  return self.__monsterBattleRoomId
end

WarChessEntityData.__GenBattleRoomID = function(self)
  -- function num : 0_32 , upvalues : _ENV, eWarChessEnum, WarChessSeasonUtil
  if self.unitCfg == nil then
    self.__monsterBattleRoomId = nil
    return 
  end
  local interactions = (self.unitCfg).interactions
  if interactions == nil then
    self.__monsterBattleRoomId = nil
    return 
  end
  for _,interactionCfg in pairs(interactions) do
    local triggers = interactionCfg.triggers
    if triggers ~= nil then
      for _,trigger in pairs(triggers) do
        if trigger.cat == (eWarChessEnum.eTriggerConditionType).openSubSystem and trigger.pms ~= nil and (trigger.pms)[1] == proto_object_WarChessSystemCat.WarChessSystemCatBattleV2 then
          self.__monsterBattleRoomId = (trigger.pms)[2]
          self.__monsterBattleRoomId = (WarChessSeasonUtil.TryReplaceBattleRoomId)(self.__monsterBattleRoomId)
          return 
        end
      end
    end
  end
  self.__monsterBattleRoomId = nil
end

WarChessEntityData.__GenDropIcons = function(self)
  -- function num : 0_33 , upvalues : _ENV
  if self.__monsterBattleRoomId == nil then
    self.__monsterDropIconList = nil
    return 
  end
  local monsterGroupCfg = (ConfigData.warchess_room_monster)[self.__monsterBattleRoomId]
  if monsterGroupCfg == nil then
    error("warchess_room_monster not exist battleRoomId:" .. tostring(self.__monsterBattleRoomId))
    self.__monsterDropIconList = nil
    return 
  end
  self.__monsterDropIconList = monsterGroupCfg.dorp_icon
end

WarChessEntityData.GetDropIcons = function(self)
  -- function num : 0_34
  return self.__monsterDropIconList
end

WarChessEntityData.__GenAlarmCfg = function(self)
  -- function num : 0_35 , upvalues : _ENV, WarChessHelper, eWarChessEnum
  if self.unitCfg == nil then
    self.__alarmCfg = {isAlarm = false, distance = 0}
    return 
  end
  if self:GetEntityIsMonster() then
    local triggers = (self.unitCfg).triggers
    if triggers then
      for i,v in pairs(triggers) do
        if v.cond then
          local pms = (WarChessHelper.DFSCondUnit)(v.cond, (eWarChessEnum.eConditionCat).checkIsHaveTeamInRange)
          if pms then
            self.__alarmCfg = {isAlarm = true, distance = pms[1]}
            return 
          end
        end
      end
    end
  end
  do
    self.__alarmCfg = {isAlarm = false, distance = 0}
  end
end

WarChessEntityData.GetAlarmCfg = function(self)
  -- function num : 0_36
  return self.__alarmCfg
end

WarChessEntityData.TryReGenWCMonsterHP = function(self, battleSystemData)
  -- function num : 0_37 , upvalues : _ENV, ExplorationEnum
  if battleSystemData == nil then
    return 
  end
  local hpDic = {}
  for uid,monsterMsg in pairs(battleSystemData.monsters) do
    if (monsterMsg.stc).cat == (ExplorationEnum.EnemyRoleType).monster then
      hpDic[uid] = (monsterMsg.dyc).hpPer
    end
  end
  self:GenWCMonsterHP(hpDic)
end

WarChessEntityData.GenWCMonsterHP = function(self, hpDic)
  -- function num : 0_38 , upvalues : _ENV
  local count = 0
  local totalRate = 0
  for _,hpPer in pairs(hpDic) do
    totalRate = totalRate + hpPer
    count = count + 1
  end
  self.__totalHp = (totalRate) / (count) / 10000
end

WarChessEntityData.GetWCMonsterHP = function(self)
  -- function num : 0_39
  if (self.unitCfg).monsterHurtHpRecord ~= nil then
    return self.__totalHp - (self.unitCfg).monsterHurtHpRecord / 10000
  end
  return self.__totalHp
end

WarChessEntityData.GetWCUnitInterActIcon = function(self)
  -- function num : 0_40 , upvalues : _ENV
  local iconId = (self._entityResCfg).icon
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId ~= nil then
      local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
      if monsterGroupCfg == nil then
        error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      else
        iconId = monsterGroupCfg.icon
      end
    end
  end
  do
    local iconCfg = (ConfigData.warchess_Interact_icon)[iconId]
    if iconCfg == nil then
      return nil
    end
    return iconCfg.icon_name
  end
end

WarChessEntityData.IsBossMonster = function(self)
  -- function num : 0_41 , upvalues : _ENV, eWarChessEnum
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId == nil then
      return false
    end
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
    if monsterGroupCfg == nil then
      error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      return false
    end
    return monsterGroupCfg.type == eWarChessEnum.BattleRoomTypeBoss
  end
  do return false end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

WarChessEntityData.GetWcEntitySuccessAudio = function(self)
  -- function num : 0_42
  return (self._entityResCfg).successAudio
end

WarChessEntityData.GetWcEntityAniAudioDic = function(self)
  -- function num : 0_43
  return (self._entityResCfg).aniAudioDic
end

WarChessEntityData.GetWCEntityRotate = function(self, isNum)
  -- function num : 0_44 , upvalues : _ENV, WarChessHelper
  if self.unitCfg == nil then
    return 
  end
  local entityCatCfg = (ConfigData.warchess_entity_cat)[(self.unitCfg).cat]
  if entityCatCfg ~= nil and entityCatCfg.rotate then
    local p = ((self.unitCfg).pms)[entityCatCfg.rotate_index + 1]
    if p == nil then
      return 
    end
    if isNum then
      return p
    end
    local rotate = (WarChessHelper.rotateValue)[p]
    return rotate
  end
end

WarChessEntityData.GetWCEntityBindPoint = function(self, name)
  -- function num : 0_45 , upvalues : _ENV
  if self.__entity ~= nil then
    return ((self.__entity).entityGo):FindComponent(name, eUnityComponentID.Transform)
  end
end

WarChessEntityData.CleanTimerAndTween = function(self)
  -- function num : 0_46 , upvalues : _ENV
  if self.__monsterAttackTimerId ~= nil then
    TimerManager:StopTimer(self.__monsterAttackTimerId)
    self.__monsterAttackTimerId = nil
  end
end

WarChessEntityData.WCDeleteEntityGo = function(self)
  -- function num : 0_47 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  self:CleanTimerAndTween()
  ;
  (wcCtrl.animaCtrl):RemoveSingleWCFX(self)
  if self.__entity ~= nil then
    (self.__entity):Delete()
  end
end

WarChessEntityData.GetCouldWalkLength = function(self)
  -- function num : 0_48 , upvalues : _ENV, WarChessHelper
  if not self:GetEntityIsMonster() then
    error("common entity not have move abiliity")
    return nil
  end
  local isOK, maxPathLength = (WarChessHelper.CheckEnemyCanMove)(self)
  if isOK then
    return maxPathLength
  end
  return nil
end

WarChessEntityData.GetFxCount = function(self)
  -- function num : 0_49 , upvalues : eWarChessEnum
  if (self.unitCfg).cat == (eWarChessEnum.eEntityCat).counterDownChest then
    return ((self.unitCfg).pms)[1]
  end
  return nil
end

WarChessEntityData.SetEntityHeadIcon = function(self, unitUI)
  -- function num : 0_50
  if unitUI == nil or unitUI.off == 0 then
    self.__headIconOverraidId = nil
    return 
  end
  local headId = unitUI.id
  self.__headIconOverraidId = headId
end

WarChessEntityData.GetEntityHeadIcon = function(self)
  -- function num : 0_51
  return self.__headIconOverraidId
end

WarChessEntityData.GetEntitySymbioticId = function(self)
  -- function num : 0_52
  return self.__symbioticId
end

WarChessEntityData.UpdateEntityMonsterFX = function(self, isAdd, fxid)
  -- function num : 0_53 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if fxid == nil or fxid == 0 then
    error("wanted fx not exist")
    return 
  end
  if isAdd and (self:GetFxDataDic())[fxid] == nil then
    (wcCtrl.animaCtrl):UpdateClientFxData(self, fxid, true, false, true, nil)
  end
  if not isAdd and (self:GetFxDataDic())[fxid] ~= nil then
    (wcCtrl.animaCtrl):UpdateClientFxData(self, fxid, false, false, true, nil)
  end
end

WarChessEntityData.UpdateEntityWantedMonsterFX = function(self)
  -- function num : 0_54 , upvalues : _ENV
  local fxid = (ConfigData.game_config).wcWantedMonsterId
  self:UpdateEntityMonsterFX(self.__wantedMonster, fxid)
end

WarChessEntityData.GetEntityRandonRotate = function(self)
  -- function num : 0_55 , upvalues : _ENV, WarChessHelper
  if self:GetEntityIsMonster() then
    local battleRoomId = self:GetBattleRoomID()
    if battleRoomId == nil then
      return nil
    end
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
    if monsterGroupCfg.random_rotate == nil or #monsterGroupCfg.random_rotate < 2 then
      return nil
    end
    local min = (monsterGroupCfg.random_rotate)[1]
    local max = (monsterGroupCfg.random_rotate)[2]
    if self.__monsterRandomRotate == nil then
      self.__monsterRandomRotate = (WarChessHelper.GetRandomRotate)(min, max)
    end
    return self.__monsterRandomRotate
  end
  do
    return nil
  end
end

WarChessEntityData.WCEntityDataOnSceneUnload = function(self)
  -- function num : 0_56
  self:CleanTimerAndTween()
  if self.__entity ~= nil then
    (self.__entity):EntityOnSceneUnload()
  end
end

return WarChessEntityData

