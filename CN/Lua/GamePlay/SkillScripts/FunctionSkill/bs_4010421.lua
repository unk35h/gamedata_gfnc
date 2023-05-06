-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010421 = class("bs_4010421", LuaSkillBase)
local base = LuaSkillBase
bs_4010421.config = {hurtConfig = 3, buffId = 1227, duration = 90}
bs_4010421.ctor = function(self)
  -- function num : 0_0
end

bs_4010421.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010421_3", 1, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
end

bs_4010421.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and isMiss and not isTriggerSet then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]}, true)
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, (self.arglist)[2], (self.config).duration, true)
  end
end

bs_4010421.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010421

