-- params : ...
-- function num : 0 , upvalues : _ENV
local PlayerBonus = class("PlayerBonus")
require("Framework.Network.NetworkProto")
local PlayerBonusElem = require("Game.PlayerData.PlayerBonus.PlayerBonusElem")
PlayerBonus.ctor = function(self)
  -- function num : 0_0
  self.__broadcast = {}
  self.allBunosDataDic = {}
end

PlayerBonus.InitPlayerBonus = function(self)
  -- function num : 0_1 , upvalues : _ENV
  for k,v in pairs(ConfigData.init_logic) do
    for i = 1, #v.logic do
      self:InstallPlayerBonus(proto_csmsg_SystemFunctionID.SystemFunctionID_BaseSystem, 0, (v.logic)[i], (v.para1)[i], (v.para2)[i], (v.para3)[i])
    end
  end
end

PlayerBonus.InstallPlayerBonus = function(self, module, id, ...)
  -- function num : 0_2 , upvalues : _ENV, PlayerBonusElem
  local uid = self:__GetUid(module, id)
  local logicTab = {...}
  if #logicTab < 2 then
    error("InstallBonus: logic param error")
    return 
  end
  local logic = logicTab[1]
  local bonusElem = (self.allBunosDataDic)[logic]
  if bonusElem == nil then
    bonusElem = (PlayerBonusElem.New)()
    bonusElem:InitPlayerBonusElem(logic)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.allBunosDataDic)[logic] = bonusElem
  end
  bonusElem:InstallBonus(uid, logicTab[2], logicTab[3], logicTab[4])
end

PlayerBonus.UninstallPlayerBonus = function(self, module, id, logic)
  -- function num : 0_3
  local uid = self:__GetUid(module, id)
  local bonusElem = (self.allBunosDataDic)[logic]
  if bonusElem ~= nil then
    bonusElem:UninstallBonus(uid)
  end
end

PlayerBonus.CheckPlayerBonusBroadcast = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (self.__broadcast).warehouse then
    MsgCenter:Broadcast(eMsgEventId.UpdateWarehouse)
    ;
    (PlayerDataCenter.allEffectorData):OnUpdateItemCeil()
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.__broadcast).warehouse = false
  end
  ;
  (PlayerDataCenter.allEffectorData):OnARGItemChnage()
  if (self.__broadcast).AutoRecoverItem then
    MsgCenter:Broadcast(eMsgEventId.UpdateAutoRecoverItemSpeed)
    ;
    (PlayerDataCenter.allEffectorData):OnUpdateItemGenerateSpeed()
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self.__broadcast).AutoRecoverItem = false
  end
end

PlayerBonus.AddPlayerBonusBroadcast = function(self, name)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.__broadcast)[name] = true
end

PlayerBonus.__GetUid = function(self, module, id)
  -- function num : 0_6
  return module << 32 | id
end

PlayerBonus.GetWarehouseCapcity = function(self, id)
  -- function num : 0_7 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.ResourceLimit]
  if bonusElem == nil then
    return 0
  end
  local value = (bonusElem.totalData)[id]
  return value
end

PlayerBonus.GetFactoryPipelieCount = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.FactoryPipelie]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetGlobalExpCeiling = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.GlobalExpCeiling]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetStaminaCeiling = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.StaminaCeiling]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetStaminaOutput = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.StaminaOutput]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetResOutputEfficiency = function(self, id)
  -- function num : 0_12 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.ResOutputEfficiency]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetBuildQueueCount = function(self, id)
  -- function num : 0_13 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.BuildQueue]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetBuildSpeed = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.BuildSpeed]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetGlobalExpRatio = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.GlobalExpRatio]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetOverClock = function(self, id)
  -- function num : 0_16 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.OverClock]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetOverClockFreeNum = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.OverClockFreeNum]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetFocusPointCeiling = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.FocusPointCeiling]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetBattleExpBonus = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.BattleExpBonus]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetDynSkillUpgrade = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DynSkillUpgrade]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetPlayerAttr = function(self, id)
  -- function num : 0_21 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DynPlayerAttrBuff]
  if bonusElem == nil then
    return 0
  end
  local value = (bonusElem.totalData)[id]
  return value
end

PlayerBonus.GetDungeonMultReward = function(self, dungeonType, weekNum)
  -- function num : 0_22 , upvalues : _ENV
  local dgCfg = (ConfigData.battle_dungeon_dungeon)[dungeonType]
  if dgCfg ~= nil and dgCfg.share_twice > 0 then
    return self:GetDungeonShareMultReward(dgCfg.share_twice, weekNum)
  end
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonRewardRate]
  if bonusElem == nil then
    return 0
  end
  if dungeonType == nil then
    local dungeonTypeList = {}
    do
      local addDungeonFunc = function(bElem)
    -- function num : 0_22_0 , upvalues : _ENV, weekNum, dungeonTypeList
    for theDungeonType,weekNumDic in pairs(bElem.totalData) do
      if weekNumDic[weekNum] ~= nil and weekNumDic[weekNum] > 0 then
        (table.insert)(dungeonTypeList, theDungeonType)
      end
    end
  end

      addDungeonFunc(bonusElem)
      bonusElem = (self.allBunosDataDic)[eLogicType.DungeonShareRewardRate]
      if bonusElem ~= nil then
        addDungeonFunc(bonusElem)
      end
      return #dungeonTypeList > 0, dungeonTypeList
    end
  end
  if (bonusElem.totalData)[dungeonType] == nil or ((bonusElem.totalData)[dungeonType])[weekNum] == nil then
    return 0
  end
  do return ((bonusElem.totalData)[dungeonType])[weekNum] end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

PlayerBonus.GetDungeonShareMultReward = function(self, shareId, weekNum)
  -- function num : 0_23 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonShareRewardRate]
  if bonusElem == nil then
    return 0
  end
  if (bonusElem.totalData)[shareId] == nil or ((bonusElem.totalData)[shareId])[weekNum] == nil then
    return 0
  end
  return ((bonusElem.totalData)[shareId])[weekNum]
end

PlayerBonus.IsDungeonHasMultReward = function(self, dungeonType)
  -- function num : 0_24 , upvalues : _ENV
  local dgCfg = (ConfigData.battle_dungeon_dungeon)[dungeonType]
  if dgCfg ~= nil and dgCfg.share_twice > 0 then
    return self:IsDungeonHasShareMultReward(dgCfg.share_twice)
  end
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonRewardRate]
  if bonusElem == nil then
    return false
  end
  if (bonusElem.totalData)[dungeonType] == nil then
    return false
  end
  for k,v in pairs((bonusElem.totalData)[dungeonType]) do
    if v > 0 then
      return true
    end
  end
  return false
end

PlayerBonus.IsDungeonHasShareMultReward = function(self, shareId)
  -- function num : 0_25 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonShareRewardRate]
  if bonusElem == nil then
    return false
  end
  if (bonusElem.totalData)[shareId] == nil then
    return false
  end
  for k,v in pairs((bonusElem.totalData)[shareId]) do
    if v > 0 then
      return true
    end
  end
  return false
end

PlayerBonus.GetDungeonMultRewardCurActivityIdDic = function(self, dungeonType)
  -- function num : 0_26 , upvalues : _ENV
  local dgCfg = (ConfigData.battle_dungeon_dungeon)[dungeonType]
  if dgCfg ~= nil and dgCfg.share_twice > 0 then
    return self:GetDungeonShareMultRewardCurActivityIdDic(dgCfg.share_twice)
  end
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonRewardRate]
  if bonusElem == nil then
    return table.emptytable
  end
  if not (bonusElem.dungeonActivityIdDic)[dungeonType] then
    return table.emptytable
  end
end

PlayerBonus.GetDungeonShareMultRewardCurActivityIdDic = function(self, shareId)
  -- function num : 0_27 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonShareRewardRate]
  if bonusElem == nil then
    return table.emptytable
  end
  if not (bonusElem.dungeonActivityIdDic)[shareId] then
    return table.emptytable
  end
end

PlayerBonus.GetHeroLevelCeiling = function(self)
  -- function num : 0_28 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.HeroLevelCeiling]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetAutoRecoverItemSpeed = function(self, id)
  -- function num : 0_29 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.AutoRecoverItem]
  if bonusElem == nil then
    return 0
  end
  local value = (bonusElem.totalData)[id]
  return value
end

PlayerBonus.GetDungeonCountAdd = function(self, id)
  -- function num : 0_30 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.DungeonCountAdd]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetFactoryEfficiency = function(self, id)
  -- function num : 0_31 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.FactoryEfficiency]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetResOutputCeiling = function(self, id)
  -- function num : 0_32 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.ResOutputCeiling]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[id]
end

PlayerBonus.GetChipCeilingCostReduce = function(self)
  -- function num : 0_33 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.ChipCeilingCostReduce]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetEpInitItemAddtion = function(self)
  -- function num : 0_34 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.EpInitItemAddtion]
  if bonusElem == nil then
    return nil
  end
  return bonusElem.totalData
end

PlayerBonus.GetEpBattleRoomGetExr = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.EpBattleRoomGetExr]
  if bonusElem == nil then
    return nil
  end
  return bonusElem.totalData
end

PlayerBonus.GetSupportCountAddtion = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.SupportCountAddtion]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetHpRecoverInRecoveryRoom = function(self)
  -- function num : 0_37 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.HpRecoverInRecoveryRoom]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.GetOverClockCountAddtion = function(self)
  -- function num : 0_38 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.OverClockCountAddtion]
  if bonusElem == nil then
    return 0
  end
  return bonusElem.totalData
end

PlayerBonus.Get_Activity_PointMultRate = function(self, actFrameId)
  -- function num : 0_39 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_PointMultRate]
  if bonusElem == nil then
    return table.emptytable
  end
  if not (bonusElem.totalData)[actFrameId] then
    return table.emptytable
  end
end

PlayerBonus.Get_Activity_Stamina2PointMultRate = function(self, actFrameId)
  -- function num : 0_40 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_Stamina2PointMultRate]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[actFrameId] or 0
end

PlayerBonus.Get_Activity_EffiMultRate = function(self, actFrameId)
  -- function num : 0_41 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_EffiMultRate]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[actFrameId] or 0
end

PlayerBonus.Get_Activity_ChipGroupLevel = function(self, actFrameId)
  -- function num : 0_42 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_ChipGroupLevel]
  if bonusElem == nil then
    return {}
  end
  if not (bonusElem.totalData)[actFrameId] then
    return {}
  end
end

PlayerBonus.Get_Activity_UnlockBuff = function(self, actFrameId)
  -- function num : 0_43 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_UnlockBuff]
  if bonusElem == nil then
    return {}
  end
  if not (bonusElem.totalData)[actFrameId] then
    return {}
  end
end

PlayerBonus.Get_Activity_DeleteBuff = function(self, actFrameId)
  -- function num : 0_44 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_DeleteBuff]
  if bonusElem == nil then
    return {}
  end
  if not (bonusElem.totalData)[actFrameId] then
    return {}
  end
end

PlayerBonus.Get_Activity_PowTestChipGroupLimitAdd = function(self, actFrameId)
  -- function num : 0_45 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_PowTestChipGroupLimitAdd]
  if bonusElem == nil then
    return {}
  end
  if not (bonusElem.totalData)[actFrameId] then
    return {}
  end
end

PlayerBonus.Get_Activity_ChipGroupCarryLimitAdd = function(self, actFrameId)
  -- function num : 0_46 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.Activity_ChipGroupCarryLimitAdd]
  if bonusElem == nil then
    return 0
  end
  return (bonusElem.totalData)[actFrameId] or 0
end

PlayerBonus.GetCtgrCampBuff = function(self, camp, attriId)
  -- function num : 0_47 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.CampBuff]
  if bonusElem == nil then
    return table.emptytable
  end
  local categoryValueDic = {}
  for uid,data in pairs(bonusElem.categoryDataDic) do
    if data[camp] ~= nil and (data[camp])[attriId] ~= nil then
      categoryValueDic[uid] = (data[camp])[attriId]
    end
  end
  return categoryValueDic
end

PlayerBonus.GetCtgrCareerBuff = function(self, career, attriId)
  -- function num : 0_48 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.CareerBuff]
  if bonusElem == nil then
    return table.emptytable
  end
  local categoryValueDic = {}
  for uid,data in pairs(bonusElem.categoryDataDic) do
    if data[career] ~= nil and (data[career])[attriId] ~= nil then
      categoryValueDic[uid] = (data[career])[attriId]
    end
  end
  return categoryValueDic
end

PlayerBonus.GetCtgrAllHeroBuff = function(self, attriId)
  -- function num : 0_49 , upvalues : _ENV
  local bonusElem = (self.allBunosDataDic)[eLogicType.AllHeroBuff]
  if bonusElem == nil then
    return table.emptytable
  end
  local categoryValueDic = {}
  for uid,data in pairs(bonusElem.categoryDataDic) do
    if data[attriId] ~= nil then
      categoryValueDic[uid] = data[attriId]
    end
  end
  return categoryValueDic
end

return PlayerBonus

