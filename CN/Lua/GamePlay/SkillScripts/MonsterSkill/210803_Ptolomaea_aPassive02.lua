-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210803 = class("bs_210803", LuaSkillBase)
local base = LuaSkillBase
bs_210803.config = {buffId_power = 210801, configId = 5}
bs_210803.ctor = function(self)
  -- function num : 0_0
end

bs_210803.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_210803", 99, self.OnSetHurt, self.caster, nil, (self.caster).belongNum, nil, nil, nil, nil, nil, false)
end

bs_210803.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.target).belongNum ~= (self.caster).belongNum and context.hurt > 0 and context.isTriggerSet ~= true then
    local num = (self.caster):GetBuffTier((self.config).buffId_power)
    if num > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1] * num}, true)
      skillResult:EndResult()
    end
  end
end

bs_210803.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210803

