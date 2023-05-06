-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010433 = class("bs_4010433", LuaSkillBase)
local base = LuaSkillBase
bs_4010433.config = {buffId = 2073}
bs_4010433.ctor = function(self)
  -- function num : 0_0
end

bs_4010433.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4010433", 1, self.OnBattleStart)
end

bs_4010433.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList1 = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  local targetList2 = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  for i = 0, targetList1.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList1[i], (self.config).buffId, 1)
  end
  for i = 0, targetList2.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList2[i], (self.config).buffId, 1, nil, false)
  end
end

bs_4010433.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010433

