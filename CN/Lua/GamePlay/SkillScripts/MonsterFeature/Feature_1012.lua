-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1012 = class("bs_1012", LuaSkillBase)
local base = LuaSkillBase
bs_1012.config = {buffId_slience = 26}
bs_1012.ctor = function(self)
  -- function num : 0_0
end

bs_1012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1012", 9, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
end

bs_1012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isTriggerSet ~= true and hurt > 0 and skill.isCommonAttack and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_slience, 1, (self.arglist)[2], true)
  end
end

bs_1012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1012

