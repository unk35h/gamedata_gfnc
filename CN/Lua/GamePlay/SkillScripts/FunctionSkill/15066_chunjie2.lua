-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15066 = class("bs_15066", LuaSkillBase)
local base = LuaSkillBase
bs_15066.config = {buffId = 1059}
bs_15066.ctor = function(self)
  -- function num : 0_0
end

bs_15066.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15066_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_15066.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isMiss and isCrit and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] and not isTriggerSet and skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, 75)
  end
end

bs_15066.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15066

