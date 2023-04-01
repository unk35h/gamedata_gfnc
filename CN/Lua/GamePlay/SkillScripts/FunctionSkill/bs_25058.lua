-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25058 = class("bs_25058", LuaSkillBase)
local base = LuaSkillBase
bs_25058.config = {hurtConfig = 3, buffId = 1059}
bs_25058.ctor = function(self)
  -- function num : 0_0
end

bs_25058.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_25058_3", 1, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_25058.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and isMiss and not isTriggerSet then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, (self.arglist)[2], (self.arglist)[3])
  end
end

bs_25058.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25058

