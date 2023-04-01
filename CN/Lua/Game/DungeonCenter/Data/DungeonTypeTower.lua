-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonTypeTower = class("DungeonTypeTower")
local DungeonLevelTower = require("Game.DungeonCenter.Data.DungeonLevelTower")
DungeonTypeTower.ctor = function(self, typeId, noGenList)
  -- function num : 0_0 , upvalues : _ENV
  self.__typeId = typeId
  self.__towerTypeCfg = (ConfigData.dungeon_tower_type)[typeId]
  self.__listGened = false
  if not noGenList then
    noGenList = false
  end
  if not noGenList then
    self:GenTowerLevelListData()
  end
end

DungeonTypeTower.GenTowerLevelListData = function(self)
  -- function num : 0_1 , upvalues : _ENV, DungeonLevelTower
  if self.__listGened then
    return 
  end
  self.__listGened = true
  self.__towerLevelList = {}
  for num,levelId in pairs((self.__towerTypeCfg).tower_list) do
    local towerLevelData = (DungeonLevelTower.New)(levelId)
    towerLevelData:BindLevelTowerTypeData(self)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self.__towerLevelList)[num] = towerLevelData
  end
end

DungeonTypeTower.GetDungeonTowerTypeId = function(self)
  -- function num : 0_2
  return self.__typeId
end

DungeonTypeTower.GetTowerLevelList = function(self)
  -- function num : 0_3
  return self.__towerLevelList
end

DungeonTypeTower.GetTowerLevelByNum = function(self, num)
  -- function num : 0_4
  return (self.__towerLevelList)[num]
end

DungeonTypeTower.GetTowerTotalLevel = function(self)
  -- function num : 0_5
  return (self.__towerTypeCfg).total_level
end

DungeonTypeTower.GetTowerRankId = function(self)
  -- function num : 0_6
  return (self.__towerTypeCfg).rank_id
end

DungeonTypeTower.IsTypeTwinTower = function(self)
  -- function num : 0_7
  do return (self.__towerTypeCfg).tower_cat == 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DungeonTypeTower.GetTowerCategory = function(self)
  -- function num : 0_8
  return (self.__towerTypeCfg).tower_cat
end

DungeonTypeTower.GetDungeonTowerName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__towerTypeCfg).tower_name)
end

DungeonTypeTower.GetDungeonTowerDesc = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__towerTypeCfg).tower_des)
end

DungeonTypeTower.GetDungeonTowerLvName = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__towerTypeCfg).level_name)
end

DungeonTypeTower.GetTowerFormationRuleId = function(self)
  -- function num : 0_12
  return (self.__towerTypeCfg).formation_rule
end

DungeonTypeTower.GetTowerRewardInfo = function(self)
  -- function num : 0_13
  return (self.__towerTypeCfg).tower_reward_ids, (self.__towerTypeCfg).tower_reward_nums
end

DungeonTypeTower.GetDungeonTowerSystemName = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local systemName = (LanguageUtil.GetLocaleText)(((ConfigData.system_open)[proto_csmsg_SystemFunctionID.SystemFunctionID_DungeonTower]).name)
  return systemName
end

DungeonTypeTower.GetTowerAvgNounType = function(self)
  -- function num : 0_15 , upvalues : _ENV
  return ((ConfigData.noun_des_type).spec_noun)[1]
end

DungeonTypeTower.GetTowerAvgNounNumInfo = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local nounList = ((ConfigData.noun_des).typeListDic)[self:GetTowerAvgNounType()]
  local totalNum = #nounList
  local unlockCount = 0
  local unReadCount = 0
  local userSaveData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  for _,desId in pairs(nounList) do
    local nounDesCfg = (ConfigData.noun_des)[desId]
    if (CheckCondition.CheckLua)(nounDesCfg.pre_condition, nounDesCfg.pre_para1, nounDesCfg.pre_para2) then
      unlockCount = unlockCount + 1
      if not userSaveData:GetAvgNounIsRead(desId) then
        unReadCount = unReadCount + 1
      end
    end
  end
  return totalNum, unlockCount, unReadCount
end

DungeonTypeTower.GetTowerRacingCfg = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local racingCfg = (ConfigData.dungeon_tower_racing)[self.__typeId]
  return racingCfg
end

return DungeonTypeTower

