-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92059 = class("bs_92059", LuaSkillBase)
local base = LuaSkillBase
bs_92059.config = {buffId = 2052}
bs_92059.ctor = function(self)
  -- function num : 0_0
end

bs_92059.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_92059_3", 1, self.OnAfterHurt, self.caster)
end

bs_92059.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isTriggerSet and isCrit and not isMiss and skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_92059.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92059

