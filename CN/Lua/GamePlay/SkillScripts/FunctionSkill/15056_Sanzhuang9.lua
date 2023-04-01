-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15056 = class("bs_15056", LuaSkillBase)
local base = LuaSkillBase
bs_15056.config = {}
bs_15056.ctor = function(self)
  -- function num : 0_0
end

bs_15056.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_15056_13", 1, self.OnAfterPlaySkill)
end

bs_15056.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if not skill.isCommonAttack and role == self.caster then
    local sheildValue = (self.caster).skill_intensity * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, sheildValue)
  end
end

bs_15056.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15056

