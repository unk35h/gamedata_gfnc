-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105704 = class("bs_105704", LuaSkillBase)
local base = LuaSkillBase
bs_105704.config = {buffId = 105702, buffId1 = 105706}
bs_105704.ctor = function(self)
  -- function num : 0_0
end

bs_105704.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnDamageEnd, self.OnDamageEnd, self)
end

bs_105704.OnDamageEnd = function(self, skill)
  -- function num : 0_2 , upvalues : _ENV
  if skill.caster == self.caster and (self.caster):GetBuffTier((self.config).buffId) > 0 and (skill.cskill).isNormalSkill then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  end
  if skill.caster == self.caster and (self.caster):GetBuffTier((self.config).buffId1) > 0 and (skill.cskill).isNormalSkill then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId1, 1)
  end
end

bs_105704.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105704

