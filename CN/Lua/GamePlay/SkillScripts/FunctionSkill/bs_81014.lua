-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81014 = class("bs_81014", LuaSkillBase)
local base = LuaSkillBase
bs_81014.config = {buffId1 = 175, buffId2 = 1033, buffId3 = 198, buffId4 = 88}
bs_81014.ctor = function(self)
  -- function num : 0_0
end

bs_81014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_81014_2", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_81014_03", 1, self.OnAfterBattleStart)
  self.num = 0
end

bs_81014.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetlist.Count < 1 then
    return 
  end
  for i = targetlist.Count - 1, 0, -1 do
    local targetRole = targetlist[i]
    if targetRole.roleDataId == 40042 then
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId1, 1, nil, true)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId2, 1, nil, true)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId3, 1, nil, true)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId4, 1, nil, true)
    end
  end
  LuaSkillCtrl:StartAvgWithPauseGame("23winter_s20_0", nil, nil)
end

bs_81014.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum then
    self.num = self.num + 1
    if self.num >= 7 then
      LuaSkillCtrl:ForceEndBattle(true)
    end
  end
end

bs_81014.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81014

