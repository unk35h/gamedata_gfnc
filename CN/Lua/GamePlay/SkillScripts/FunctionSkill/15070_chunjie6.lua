-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15070 = class("bs_15070", LuaSkillBase)
local base = LuaSkillBase
bs_15070.config = {configId1 = 28}
bs_15070.ctor = function(self)
  -- function num : 0_0
end

bs_15070.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_15070_1", 1, self.OnSetHurt, nil, self.caster)
  self.damageValue = 0
end

bs_15070.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.hurt > 0 and not context.isTriggerSet then
    if (self.caster).magic_pen <= (self.caster).def then
      self.damageValue = (self.caster).def
    else
      self.damageValue = (self.caster).magic_pen
    end
    if self.damageValue > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.sender)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId1, {self.damageValue}, true)
      skillResult:EndResult()
    end
  end
end

bs_15070.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15070

