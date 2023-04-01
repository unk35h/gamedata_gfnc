-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80006 = class("bs_80006", LuaSkillBase)
local base = LuaSkillBase
bs_80006.config = {selectId = 7, effectId2 = 10256, 
hurt_config = {hit_formula = 0, basehurt_formula = 3000}
, 
real_Config = {hit_formula = 0, def_formula = 0, basehurt_formula = 502, minhurt_formula = 9994, crit_formula = 0, crithur_ratio = 0, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = 2}
}
bs_80006.ctor = function(self)
  -- function num : 0_0
end

bs_80006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHealTrigger("bs_80006_4", 1, self.OnSetHeal, self.caster)
end

bs_80006.OnSetHeal = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and not context.isTriggerSet then
    local targetList = LuaSkillCtrl:CallTargetSelectWithRange(self, (self.config).selectId, 1, context.target)
    if targetList.Count > 0 then
      local targetRole2 = (targetList[0]).targetRole
      local dam = context.heal * (self.arglist)[1] // 1000
      LuaSkillCtrl:CallEffect(targetRole2, (self.config).effectId2, self)
      LuaSkillCtrl:CallRealDamage(self, targetRole2, nil, (self.config).real_Config, {dam}, true)
    end
  end
end

bs_80006.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80006

