-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1008 = class("bs_1008", LuaSkillBase)
local base = LuaSkillBase
bs_1008.config = {}
bs_1008.ctor = function(self)
  -- function num : 0_0
end

bs_1008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_100301_2", 1, self.OnSetHurt, nil, self.caster)
end

bs_1008.OnSetHurt = function(self, context)
  -- function num : 0_2
  if context.target == self.caster and (context.skill).SkillRange ~= nil and (context.skill).SkillRange > 1 then
    context.hurt = context.hurt * (1000 - (self.arglist)[1]) // 1000
  end
  if context.target == self.caster and (context.skill).SkillRange ~= nil and (context.skill).SkillRange == 1 then
    context.hurt = context.hurt * (1000 + (self.arglist)[2]) // 1000
  end
end

bs_1008.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1008

