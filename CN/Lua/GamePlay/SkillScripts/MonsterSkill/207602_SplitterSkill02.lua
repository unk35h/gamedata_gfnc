-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207602 = class("bs_207602", LuaSkillBase)
local base = LuaSkillBase
bs_207602.config = {BuffId_bleed = 195}
bs_207602.ctor = function(self)
  -- function num : 0_0
end

bs_207602.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_207602_1", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_207602.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack and sender == self.caster and not isMiss then
    LuaSkillCtrl:CallBuff(self, target, (self.config).BuffId_bleed, (self.arglist)[1] / 10, (self.arglist)[2])
  end
end

bs_207602.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207602

