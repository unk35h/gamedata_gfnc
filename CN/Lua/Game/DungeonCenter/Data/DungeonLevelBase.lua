-- params : ...
-- function num : 0 , upvalues : _ENV
local DungeonLevelBase = class("DungeonLevelBase")
local DungeonLevelEnum = require("Game.DungeonCenter.DungeonLevelEnum")
DungeonLevelBase.ctor = function(self, stageId)
  -- function num : 0_0 , upvalues : _ENV
  self.__stageId = stageId
  self.__dungeonStageCfg = (ConfigData.battle_dungeon)[stageId]
end

DungeonLevelBase.GetDungeonLevelStageId = function(self)
  -- function num : 0_1
  return self.__stageId
end

DungeonLevelBase.GetDungeonLevelType = function(self)
  -- function num : 0_2 , upvalues : DungeonLevelEnum
  return (DungeonLevelEnum.DunLevelType).None
end

DungeonLevelBase.GetDungeonLevelName = function(self)
  -- function num : 0_3 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.__dungeonStageCfg).name)
end

DungeonLevelBase.GetDungeonInfoDesc = function(self)
  -- function num : 0_4
end

DungeonLevelBase.GetDungeonLevelPic = function(self)
  -- function num : 0_5
end

DungeonLevelBase.GetRecommendCombat = function(self)
  -- function num : 0_6
  return (self.__dungeonStageCfg).combat
end

DungeonLevelBase.GetRecommendBenchCombat = function(self)
  -- function num : 0_7
  return (self.__dungeonStageCfg).bench_combat
end

DungeonLevelBase.GetEnterLevelCost = function(self)
  -- function num : 0_8 , upvalues : _ENV
  return ConstGlobalItem.SKey
end

DungeonLevelBase.GetLevelResourceGroup = function(self)
  -- function num : 0_9
  return self:GetEnterLevelCost()
end

DungeonLevelBase.GetConsumeKeyNum = function(self)
  -- function num : 0_10 , upvalues : _ENV
  for index,id in pairs((self.__dungeonStageCfg).cost_itemIds) do
    if id == ConstGlobalItem.SKey then
      return ((self.__dungeonStageCfg).cost_itemNums)[index]
    end
  end
  return 0
end

DungeonLevelBase.GetEnterLevelCostItemName = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local costId = self:GetEnterLevelCost()
  if costId == nil then
    return ""
  end
  return ConfigData:GetItemName(costId)
end

DungeonLevelBase.GetDungeonFirstReward = function(self)
  -- function num : 0_12
  return (self.__dungeonStageCfg).first_reward_ids, (self.__dungeonStageCfg).first_reward_nums
end

DungeonLevelBase.GetDungeonBuffListCfg = function(self)
  -- function num : 0_13
  return (self.__dungeonStageCfg).protocol
end

DungeonLevelBase.HasRecommendFormation = function(self)
  -- function num : 0_14
  return false
end

DungeonLevelBase.GetLevelUnlockConditionCfg = function(self)
  -- function num : 0_15
  return (self.__dungeonStageCfg).pre_condition, (self.__dungeonStageCfg).pre_para1, (self.__dungeonStageCfg).pre_para2
end

DungeonLevelBase.GetSpecialUnlockInfo = function(self)
  -- function num : 0_16
  return nil
end

DungeonLevelBase.GetIsLevelUnlock = function(self)
  -- function num : 0_17 , upvalues : _ENV
  return (CheckCondition.CheckLua)(self:GetLevelUnlockConditionCfg())
end

DungeonLevelBase.GetEnterChipSelectCfg = function(self)
  -- function num : 0_18
  return (self.__dungeonStageCfg).enter_chip_select
end

DungeonLevelBase.DealDungeonResult = function(self, msg)
  -- function num : 0_19
end

DungeonLevelBase.GetDunServerRacingFrame = function(self)
  -- function num : 0_20
  return -1
end

DungeonLevelBase.IsDunCustomTicket = function(self)
  -- function num : 0_21 , upvalues : DungeonLevelEnum
  local dunLevelType = self:GetDungeonLevelType()
  return (DungeonLevelEnum.DunCustomTicket)[dunLevelType] or false
end

DungeonLevelBase.GetDunExtraBuffDic = function(self)
  -- function num : 0_22
  return nil
end

DungeonLevelBase.GetDunExtraDelectedBuffDic = function(self)
  -- function num : 0_23
  return nil
end

DungeonLevelBase.GetIsCouldPlayOnce = function(self)
  -- function num : 0_24 , upvalues : _ENV
  local ticketItemId = self:GetEnterLevelCost()
  local ticketItemCount = PlayerDataCenter:GetItemCount(ticketItemId)
  local ticketSingleCost = self:GetConsumeKeyNum()
  do return ticketSingleCost <= ticketItemCount end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return DungeonLevelBase

