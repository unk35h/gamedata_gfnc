-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30059 = class("bs_30059", LuaSkillBase)
local base = LuaSkillBase
bs_30059.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 502, crit_formula = 0, correct_formula = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, effectId = 10929}
bs_30059.ctor = function(self)
  -- function num : 0_0
end

bs_30059.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_30059_2", 1, self.OnAfterHurt, self.caster)
end

bs_30059.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and isCrit then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
    if targetlist.Count < 1 then
      return 
    end
    local target = (targetlist[0]).targetRole
    if target == nil then
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    local damage = hurt * (self.arglist)[1] // 1000
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {damage}, true)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  end
end

bs_30059.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30059

