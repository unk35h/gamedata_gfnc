-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1005 = class("bs_1005", LuaSkillBase)
local base = LuaSkillBase
bs_1005.config = {}
bs_1005.ctor = function(self)
  -- function num : 0_0
end

bs_1005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_1005", 1, self.OnSetHurt, nil, self.caster)
end

bs_1005.OnSetHurt = function(self, context)
  -- function num : 0_2
  if context.target == self.caster and context.hurt_type == 1 then
    context.hurt = context.hurt * (1000 - (self.arglist)[1]) // 1000
  end
  if context.target == self.caster and context.hurt_type == 0 then
    context.hurt = context.hurt * (1000 + (self.arglist)[2]) // 1000
  end
end

bs_1005.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1005

