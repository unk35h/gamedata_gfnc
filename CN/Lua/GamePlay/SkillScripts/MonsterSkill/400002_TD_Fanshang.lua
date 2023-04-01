-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_400002 = class("bs_400002", LuaSkillBase)
local base = LuaSkillBase
bs_400002.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10031, crit_formula = 0}
}
bs_400002.ctor = function(self)
  -- function num : 0_0
end

bs_400002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_400002_3", 1, self.OnAfterHurt, nil, self.caster)
end

bs_400002.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss and not isTriggerSet then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
    skillResult:EndResult()
  end
end

bs_400002.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_400002

