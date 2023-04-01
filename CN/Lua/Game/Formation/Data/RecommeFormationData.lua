-- params : ...
-- function num : 0 , upvalues : _ENV
local RecommeFormationData = class("RecommeFormationData")
local RecommeFormationSingleData = require("Game.Formation.Data.RecommeFormationSingleData")
RecommeFormationData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.list = {}
  self.isDungeon = false
  self.recommeSupoortChip = true
  self.__formationRuleCfg = (ConfigData.formation_rule)[0]
end

RecommeFormationData.CreateRecommeData = function(stageId)
  -- function num : 0_1 , upvalues : RecommeFormationData
  local data = RecommeFormationData:New()
  data.stageId = stageId
  return data
end

RecommeFormationData.GenRecommeSingleData = function(self, msg)
  -- function num : 0_2 , upvalues : RecommeFormationSingleData, _ENV
  self.refreshTime = msg.refreshTime or 0
  for i = 1, #msg.data do
    local singleData = (RecommeFormationSingleData.New)()
    singleData:SetRecommeSinglePara(self.isDungeon, self.stageId)
    singleData:InitRecommeSingleData((msg.data)[i], self.__formationRuleCfg)
    ;
    (table.insert)(self.list, singleData)
  end
end

RecommeFormationData.SetAsDungeonRecomme = function(self)
  -- function num : 0_3
  self.isDungeon = true
end

RecommeFormationData.SetRecommeSupportChip = function(self, active)
  -- function num : 0_4
  self.recommeSupoortChip = active
end

RecommeFormationData.SetFormationRuleId = function(self, ruleId)
  -- function num : 0_5 , upvalues : _ENV
  if ruleId <= 0 then
    return 
  end
  local formationRuleCfg = (ConfigData.formation_rule)[ruleId]
  self.__formationRuleCfg = formationRuleCfg
end

RecommeFormationData.GetRecommeMaxStageNum = function(self)
  -- function num : 0_6
  return (self.__formationRuleCfg).stage_num
end

RecommeFormationData.GetRecommeMaxBenchNum = function(self)
  -- function num : 0_7
  return (self.__formationRuleCfg).bench_num
end

RecommeFormationData.SortByPower = function(self)
  -- function num : 0_8 , upvalues : _ENV, RecommeFormationData
  (table.sort)(self.list, RecommeFormationData.__DefaultSort)
end

RecommeFormationData.SortByHeroCount = function(self)
  -- function num : 0_9 , upvalues : _ENV, RecommeFormationData
  for key,value in pairs(self.list) do
    value.haveCount = value:GetHaveCount()
  end
  ;
  (table.sort)(self.list, RecommeFormationData.__CountSort)
end

RecommeFormationData.__CountSort = function(a, b)
  -- function num : 0_10 , upvalues : RecommeFormationData
  local aHasAll = a.haveCount == a.heroCount
  local bHasAll = b.haveCount == b.heroCount
  if aHasAll ~= bHasAll then
    return aHasAll
  end
  if a.heroCount ~= b.heroCount then
    if a.heroCount >= b.heroCount then
      do return not aHasAll end
      do return (RecommeFormationData.__DefaultSort)(a, b) end
      if b.haveCount >= a.haveCount then
        do return a.haveCount == b.haveCount end
        do return (RecommeFormationData.__DefaultSort)(a, b) end
        -- DECOMPILER ERROR: 8 unprocessed JMP targets
      end
    end
  end
end

RecommeFormationData.__DefaultSort = function(a, b)
  -- function num : 0_11
  if a.power >= b.power then
    do return a.power == b.power end
    if a.heroCount >= b.heroCount then
      do return a.heroCount == b.heroCount end
      if a.starMax >= b.starMax then
        do return a.starMax == b.starMax end
        if a.levelMax >= b.levelMax then
          do return a.levelMax == b.levelMax end
          do return a.idAddtion < b.idAddtion end
          -- DECOMPILER ERROR: 9 unprocessed JMP targets
        end
      end
    end
  end
end

return RecommeFormationData

