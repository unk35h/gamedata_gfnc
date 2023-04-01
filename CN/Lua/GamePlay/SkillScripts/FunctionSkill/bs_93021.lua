-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93021 = class("bs_93021", LuaSkillBase)
local base = LuaSkillBase
bs_93021.config = {}
bs_93021.ctor = function(self)
  -- function num : 0_0
end

bs_93021.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_93021_4", 1, self.OnAfterPlaySkill)
end

bs_93021.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and skill.isCommonAttack then
    local shieldValue = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, shieldValue)
  end
end

bs_93021.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93021

