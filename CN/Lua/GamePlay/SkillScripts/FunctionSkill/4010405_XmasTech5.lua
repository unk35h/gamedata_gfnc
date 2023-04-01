-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010405 = class("bs_4010405", LuaSkillBase)
local base = LuaSkillBase
bs_4010405.config = {}
bs_4010405.ctor = function(self)
  -- function num : 0_0
end

bs_4010405.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010405_1", 1, self.OnAfterHurt, nil, self.caster)
  self.HpPercent = 1
end

bs_4010405.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, isRealDmg, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and target.hp > 0 and target.hp * 1000 // target.maxHp < (self.arglist)[1] and self.HpPercent == 1 then
    self.HpPercent = 0
    local value = (self.caster).maxHp * (self.arglist)[2] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, value)
  end
end

bs_4010405.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010405

