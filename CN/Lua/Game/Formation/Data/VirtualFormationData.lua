-- params : ...
-- function num : 0 , upvalues : _ENV
local VirtualFormationData = class("VirtualFormationData")
local FormationData = require("Game.PlayerData.FormationData")
local CommanderSkillTreeData = require("Game.CommanderSkill.CommanderSkillTreeData")
VirtualFormationData.ctor = function(self, treeId, specialRuleGenerator)
  -- function num : 0_0 , upvalues : FormationData, _ENV
  self.formation = (FormationData.FromCustomData)(0, {}, 1, {})
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.formation).isVirtualFormation = true
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.formation).specialRuleGenerator = specialRuleGenerator
  local oriFormation = (PlayerDataCenter.formationDic)[1]
  if treeId ~= nil and (ConfigData.commander_skill)[treeId] ~= nil and (PlayerDataCenter.cstDataDic)[treeId] ~= nil then
    (self.formation):SetCustomCstData((PlayerDataCenter.cstDataDic)[treeId])
  else
    ;
    (self.formation):SetCustomCstData(oriFormation:GetFmtCSTData())
  end
  self.buffIds = {}
end

VirtualFormationData.TryRestoreFormation = function(self, weeklyFmt)
  -- function num : 0_1 , upvalues : _ENV
  if weeklyFmt == nil then
    weeklyFmt = {}
  else
    for k,lastHeroid in pairs(weeklyFmt) do
      if not (table.contain)((((self.formation).specialRuleGenerator).specialRuler).heroIds, lastHeroid) then
        weeklyFmt = {}
        break
      end
    end
  end
  do
    ;
    (self.formation):CleanFormation()
    for index,heroId in pairs(weeklyFmt) do
      (self.formation):SetHero2Formation(index, heroId)
    end
  end
end

VirtualFormationData.SetFormation = function(self, formation)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.formation).data = formation
end

VirtualFormationData.SetBuffList = function(self, buffIds)
  -- function num : 0_3
  self.buffIds = buffIds
end

VirtualFormationData.SetCst = function(self, cst)
  -- function num : 0_4
  (self.formation):SetCustomCstData(cst)
end

VirtualFormationData.GetCstTreeId = function(self)
  -- function num : 0_5
  return ((self.formation):GetCustomCstData()).treeId
end

VirtualFormationData.GetSctSkills = function(self)
  -- function num : 0_6
  return ((self.formation):GetCustomCstData()):GetUsingCmdSkillList()
end

VirtualFormationData.GetVirFmtCstData = function(self)
  -- function num : 0_7
  return (self.formation):GetCustomCstData()
end

return VirtualFormationData

