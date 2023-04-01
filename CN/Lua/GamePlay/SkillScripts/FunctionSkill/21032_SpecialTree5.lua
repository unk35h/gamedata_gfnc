-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21032 = class("bs_21032", LuaSkillBase)
local base = LuaSkillBase
bs_21032.config = {
heal_config = {baseheal_formula = 501}
}
bs_21032.ctor = function(self)
  -- function num : 0_0
end

bs_21032.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_21032_1", 1, self.OnAfterHurt, self.caster)
end

bs_21032.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isMiss and hurt > 0 and not isTriggerSet then
    local value = hurt * (self.arglist)[1] // 1000
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 14, 10)
    if targetList.Count > 0 then
      local targetRole = (targetList[0]).targetRole
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true)
      skillResult:EndResult()
    end
  end
end

bs_21032.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21032

