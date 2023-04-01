-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1018092 = class("bs_1018092", LuaSkillBase)
local base = LuaSkillBase
bs_1018092.config = {buffId_262 = 10180301}
bs_1018092.ctor = function(self)
  -- function num : 0_0
end

bs_1018092.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_1018092_2", 99, self.OnSetHurt, nil, self.caster)
end

bs_1018092.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target == self.caster then
    local tier = (self.caster):GetBuffTier((self.config).buffId_262)
    context.hurt = context.hurt * (1000 - (self.arglist)[1] * tier) // 1000
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_262, 1)
  end
end

bs_1018092.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1018092

