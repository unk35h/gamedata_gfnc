-- params : ...
-- function num : 0 , upvalues : _ENV
local DynBattleRole = require("Game.Exploration.Data.DynBattleRole")
local DynSummonerAdapter = class("DynSummonerAdapter", DynBattleRole)
DynSummonerAdapter.ctor = function(self)
  -- function num : 0_0
  self.dataId = 0
  self.baseAttr = {}
  self.ratioAttr = {}
  self.extraAttr = {}
  self.attackRange = 1
end

DynSummonerAdapter.InitSummonerAdapter = function(self, career, camp, attackRange)
  -- function num : 0_1
  self._career = career
  self._camp = camp
  self.attackRange = attackRange
end

DynSummonerAdapter.GetCareer = function(self)
  -- function num : 0_2
  return self._career
end

DynSummonerAdapter.GetCamp = function(self)
  -- function num : 0_3
  return self._camp
end

return DynSummonerAdapter

