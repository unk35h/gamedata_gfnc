-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1010 = class("bs_1010", LuaSkillBase)
local base = LuaSkillBase
bs_1010.config = {buffId_unarm = 205}
bs_1010.ctor = function(self)
  -- function num : 0_0
end

bs_1010.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1010", 9, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack, false)
end

bs_1010.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isTriggerSet ~= true and hurt > 0 and skill.isCommonAttack and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_unarm, 1, (self.arglist)[2], true)
  end
end

bs_1010.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1010

