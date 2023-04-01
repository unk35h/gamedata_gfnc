-- params : ...
-- function num : 0 , upvalues : _ENV
local RecommeFormationNewData = class("RecommeFormationNewData")
local RecommeFormationSingleData = require("Game.Formation.Data.RecommeFormationNewSingleData")
RecommeFormationNewData.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.list = {}
  self.isDungeon = false
  self.__formationRuleCfg = (ConfigData.formation_rule)[0]
end

RecommeFormationNewData.CreateRecommeData = function(stageId)
  -- function num : 0_1 , upvalues : RecommeFormationNewData
  local data = RecommeFormationNewData:New()
  data.stageId = stageId
  return data
end

RecommeFormationNewData.GenRecommeSingleData = function(self, msg)
  -- function num : 0_2 , upvalues : _ENV, RecommeFormationSingleData
  self.refreshTime = msg.refreshTime or 0
  local data = msg.dataV2
  ;
  (table.sort)(data, function(a, b)
    -- function num : 0_2_0
    if b.winCount >= a.winCount then
      do return a.winCount == b.winCount end
      do return (a.data).power < (b.data).power end
      -- DECOMPILER ERROR: 4 unprocessed JMP targets
    end
  end
)
  for i = 1, #data do
    local singleData = (RecommeFormationSingleData.New)()
    singleData:SetRecommeSinglePara(self.isDungeon, self.stageId)
    singleData:InitRecommeSingleData(data[i], i)
    ;
    (table.insert)(self.list, singleData)
  end
end

RecommeFormationNewData.SetAsDungeonRecomme = function(self)
  -- function num : 0_3
  self.isDungeon = true
end

RecommeFormationNewData.SetFormationRuleId = function(self, ruleId)
  -- function num : 0_4 , upvalues : _ENV
  if ruleId <= 0 then
    return 
  end
  local formationRuleCfg = (ConfigData.formation_rule)[ruleId]
  self.__formationRuleCfg = formationRuleCfg
end

RecommeFormationNewData.GetRecommeMaxStageNum = function(self)
  -- function num : 0_5
  return (self.__formationRuleCfg).stage_num
end

return RecommeFormationNewData

