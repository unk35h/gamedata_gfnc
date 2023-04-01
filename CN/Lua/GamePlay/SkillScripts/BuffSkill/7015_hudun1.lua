-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7015 = class("bs_7015", LuaSkillBase)
local base = LuaSkillBase
bs_7015.config = {buffId = 1265, buffTier = 1}
bs_7015.ctor = function(self)
  -- function num : 0_0
end

bs_7015.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_7015_1", 1, self.OnSetHurt, nil, self.caster)
end

bs_7015.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if not context.isMiss then
    context.hurt = 0
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0, true)
  end
end

bs_7015.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_7015

