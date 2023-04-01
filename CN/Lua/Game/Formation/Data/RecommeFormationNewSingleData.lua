-- params : ...
-- function num : 0 , upvalues : _ENV
local RecommeFormationSingleData = class("RecommeFormationSingleData")
RecommeFormationSingleData.ctor = function(self)
  -- function num : 0_0
end

RecommeFormationSingleData.SetRecommeSinglePara = function(self, isDungeon, stageId)
  -- function num : 0_1
  self._isDungeon = isDungeon
  self._stageId = stageId
end

RecommeFormationSingleData.InitRecommeSingleData = function(self, data, rank)
  -- function num : 0_2
  self.winCount = data.winCount
  self.power = (data.data).power
  self.rank = rank
  self.recommanHeroList = {}
  self:GenHeroList((data.data).heroIds)
end

RecommeFormationSingleData.GenHeroList = function(self, heroIds)
  -- function num : 0_3 , upvalues : _ENV
  local heroList = (CommonUtil.SplitStrToNumber)(heroIds, "_")
  for i = 1, #heroList do
    (table.insert)(self.recommanHeroList, {basicId = heroList[i]})
  end
end

RecommeFormationSingleData.IsAllowCopy = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  for index,data in pairs(self.recommanHeroList) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[data.basicId] ~= nil then
      return true
    end
  end
  return false
end

RecommeFormationSingleData.GetHaveCount = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  local count = 0
  for index,data in pairs(self.recommanHeroList) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[data.basicId] ~= nil then
      count = count + 1
    end
  end
  return count
end

RecommeFormationSingleData.CopyFormation = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local indexMax = ConfigData:GetFormationHeroCount()
  local res = {}
  for index,data in pairs(self.recommanHeroList) do
    if index <= indexMax and (PlayerDataCenter.heroDic)[data.basicId] ~= nil then
      res[index] = data.basicId
    end
  end
  return res
end

return RecommeFormationSingleData

