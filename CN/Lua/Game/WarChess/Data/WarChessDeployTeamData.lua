-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessDeployTeamData = class("WarChessDeployTeamData")
WarChessDeployTeamData.ctor = function(self, index, fmtData)
  -- function num : 0_0
  self.__index = index
  self.__fmtData = fmtData
  self.__teamName = nil
  self.__bornPoint = nil
  self.__firstHeroData = nil
  self.__teamPower = nil
  self.__isFixedTeam = false
  self.__inheritTeamIndex = nil
  self:RefreshFmtData()
end

WarChessDeployTeamData.RefreshFmtData = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self:__RefreshFirstHeroId()
  self.__teamName = (self.__fmtData).name
  if (string.IsNullOrEmpty)(self.__teamName) then
    self.__teamName = (string.format)(ConfigData:GetTipContent(TipContent.WarChess_TeamDefaultName), tostring(self.__index))
  end
end

WarChessDeployTeamData.GetFirstHeroData = function(self)
  -- function num : 0_2
  return self.__firstHeroData
end

WarChessDeployTeamData.SetInheritTeamIndex = function(self, inheritTeamIndex)
  -- function num : 0_3
  self.__inheritTeamIndex = inheritTeamIndex
end

WarChessDeployTeamData.GetInheritTeamIndex = function(self)
  -- function num : 0_4
  return self.__inheritTeamIndex
end

WarChessDeployTeamData.GetFmtId = function(self)
  -- function num : 0_5
  return (self.__fmtData).id
end

WarChessDeployTeamData.GetFmtCSTId = function(self)
  -- function num : 0_6
  return (self.__fmtData).cstId
end

WarChessDeployTeamData.SetDTeamIsFixedTeam = function(self, bool)
  -- function num : 0_7
  self.__isFixedTeam = bool
end

WarChessDeployTeamData.GetDTeamIsFixedTeam = function(self)
  -- function num : 0_8
  return self.__isFixedTeam
end

WarChessDeployTeamData.SetBornPoint = function(self, bornPoint)
  -- function num : 0_9
  self.__bornPoint = bornPoint
end

WarChessDeployTeamData.GetBornPoint = function(self)
  -- function num : 0_10
  return self.__bornPoint
end

WarChessDeployTeamData.GetIsDeploied = function(self)
  -- function num : 0_11
  do return self:GetBornPoint() ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessDeployTeamData.GetDTeamIndex = function(self)
  -- function num : 0_12
  return self.__index
end

WarChessDeployTeamData.GetDTeamHeroData = function(self, index)
  -- function num : 0_13
  return (self.__fmtData):GetFormationHeroData(index)
end

WarChessDeployTeamData.GetDTeamHeroDic = function(self)
  -- function num : 0_14
  return (self.__fmtData):GetFormationHeroDic(false)
end

WarChessDeployTeamData.SetDTeamTeamPower = function(self, power)
  -- function num : 0_15
  self.__teamPower = power
end

WarChessDeployTeamData.GetDTeamTeamPower = function(self)
  -- function num : 0_16
  return self.__teamPower
end

WarChessDeployTeamData.GetDTeamName = function(self)
  -- function num : 0_17
  return self.__teamName
end

WarChessDeployTeamData.GetTeamMemberHeroDataList = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local heroDataList = {}
  for i = 1, ((ConfigData.formation_rule)[0]).stage_num do
    local heroData = (self.__fmtData):GetFormationHeroData(i)
    ;
    (table.insert)(heroDataList, heroData)
  end
  return heroDataList
end

WarChessDeployTeamData.__RefreshFirstHeroId = function(self)
  -- function num : 0_19 , upvalues : _ENV
  for i = 1, ((ConfigData.formation_rule)[0]).stage_num do
    local heroData = (self.__fmtData):GetFormationHeroData(i)
    if heroData ~= nil then
      self.__firstHeroData = heroData
      return 
    end
  end
  self.__firstHeroData = nil
end

WarChessDeployTeamData.GetWcDTeamFmtData = function(self)
  -- function num : 0_20
  return self.__fmtData
end

WarChessDeployTeamData.GetOfficeAssistData = function(self)
  -- function num : 0_21
  return (self.__fmtData):GetFmtOfficeAssistData()
end

return WarChessDeployTeamData

