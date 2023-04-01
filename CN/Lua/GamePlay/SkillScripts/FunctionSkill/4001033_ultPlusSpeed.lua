-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001033 = class("bs_4001033", LuaSkillBase)
local base = LuaSkillBase
bs_4001033.config = {buffId = 2020}
bs_4001033.ctor = function(self)
  -- function num : 0_0
end

bs_4001033.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_4001033_1", 1, self.OnAfterPlaySkill)
end

bs_4001033.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.skillTag ~= eSkillTag.ultSkill then
    return 
  end
  local target_List = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  for i = 0, target_List.Count - 1 do
    LuaSkillCtrl:CallBuff(self, target_List[i], (self.config).buffId, 1, (self.arglist)[2], true)
  end
end

bs_4001033.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001033

