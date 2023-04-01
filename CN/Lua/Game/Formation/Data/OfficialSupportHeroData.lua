-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.PlayerData.Hero.FixedFmtHeroData")
local OfficialSupportHeroData = class("OfficialSupportHeroData", base)
OfficialSupportHeroData.ctor = function(self, data)
  -- function num : 0_0
  self.isOfficialSupport = true
  self.__officialSupportCfgId = nil
end

OfficialSupportHeroData.GenOfficialSupportHeroData = function(heroId, assisLvCfg, power)
  -- function num : 0_1 , upvalues : _ENV, base, OfficialSupportHeroData
  if assisLvCfg == nil then
    error("assisLvCfg is nil")
  end
  local heroData = (base._GenHeroDataBase)(OfficialSupportHeroData, heroId, assisLvCfg)
  heroData.__power = power
  return heroData
end

OfficialSupportHeroData.SetOfficialSupportCfgId = function(self, officialSupportCfgId)
  -- function num : 0_2
  self.__officialSupportCfgId = officialSupportCfgId
end

OfficialSupportHeroData.GetOfficialSupportCfgId = function(self)
  -- function num : 0_3
  return self.__officialSupportCfgId
end

OfficialSupportHeroData.AbleUpLevel = function(self)
  -- function num : 0_4
  return false
end

OfficialSupportHeroData.GenHeroCanQuickLevelUp = function(self)
  -- function num : 0_5
  return false
end

OfficialSupportHeroData.AbleUpgradeStar = function(self)
  -- function num : 0_6
  return false
end

OfficialSupportHeroData.AbleUpgrade2FullStar = function(self)
  -- function num : 0_7
  return false, false
end

OfficialSupportHeroData.GetFightingPower = function(self, attrDic)
  -- function num : 0_8 , upvalues : base
  if not self.__power then
    return (base.GetFightingPower)(self, attrDic)
  end
end

return OfficialSupportHeroData

