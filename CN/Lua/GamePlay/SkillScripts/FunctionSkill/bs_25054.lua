-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25054 = class("bs_25054", LuaSkillBase)
local base = LuaSkillBase
bs_25054.config = {heal_resultId = 4}
bs_25054.ctor = function(self)
  -- function num : 0_0
end

bs_25054.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_25054_3", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_25054.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum and isMiss then
    self:PlayChipEffect()
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[1]})
    skillResult:EndResult()
  end
end

bs_25054.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25054

