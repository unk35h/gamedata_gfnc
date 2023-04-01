-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104704 = class("bs_104704", LuaSkillBase)
local base = LuaSkillBase
bs_104704.config = {
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0}
}
bs_104704.ctor = function(self)
  -- function num : 0_0
end

bs_104704.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("104704_14", 90, self.OnSetHurt)
end

bs_104704.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and not context.isTriggerSet and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and (context.skill).isCommonAttack then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
    local prob = ((self.caster).recordTable).buffNum
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {prob}, true)
    skillResult:EndResult()
  end
end

bs_104704.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104704

