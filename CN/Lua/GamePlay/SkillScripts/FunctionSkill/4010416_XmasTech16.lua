-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010416 = class("bs_4010416", LuaSkillBase)
local base = LuaSkillBase
bs_4010416.config = {buffId = 1059}
bs_4010416.ctor = function(self)
  -- function num : 0_0
end

bs_4010416.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4010416_3", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_4010416.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum and isMiss then
    self:PlayChipEffect()
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId, (self.arglist)[1], 75)
  end
end

bs_4010416.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010416

