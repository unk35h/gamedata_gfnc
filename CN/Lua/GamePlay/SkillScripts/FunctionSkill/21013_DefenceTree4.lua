-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21013 = class("bs_21013", LuaSkillBase)
local base = LuaSkillBase
bs_21013.config = {buffId = 1252, effectId = 10942}
bs_21013.ctor = function(self)
  -- function num : 0_0
end

bs_21013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_21013_1", 1, self.OnAfterHurt, nil, self.caster)
  self.HpPercent = 1
end

bs_21013.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, isRealDmg, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and target.hp > 0 and target.hp * 1000 // target.maxHp < (self.arglist)[1] and self.HpPercent == 1 then
    self.HpPercent = 0
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
  end
end

bs_21013.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21013

