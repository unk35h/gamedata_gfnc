-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001217 = class("bs_4001217", LuaSkillBase)
local base = LuaSkillBase
bs_4001217.config = {
real_Config = {hit_formula = 0, basehurt_formula = 502, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0, hurt_type = 2}
}
bs_4001217.ctor = function(self)
  -- function num : 0_0
end

bs_4001217.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001217_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.normalSkill)
  self:AddTrigger(eSkillTriggerType.BeforePlaySkill, "bs_4001217_1", 1, self.OnBeforePlaySkill)
  self.attackTable = {}
end

bs_4001217.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and (context.skill).skillTag == eSkillTag.normalSkill then
    self.attackTable = {}
  end
end

bs_4001217.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and self.caster ~= target and not isMiss and skill.skillTag == eSkillTag.normalSkill then
    if (self.attackTable)[target] ~= nil then
      return 
    end
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.attackTable)[target] = true
    local damage = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallRealDamage(self, target, nil, (self.config).real_Config, {damage}, nil, true)
  end
end

bs_4001217.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001217

