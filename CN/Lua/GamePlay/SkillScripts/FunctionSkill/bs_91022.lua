-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91022 = class("bs_91022", LuaSkillBase)
local base = LuaSkillBase
bs_91022.config = {buffId = 2044}
bs_91022.ctor = function(self)
  -- function num : 0_0
end

bs_91022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_91022_3", 1, self.OnAfterHurt, nil, nil, nil, (self.caster).belongNum)
end

bs_91022.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss and not isTriggerSet then
    local buffTier = sender:GetBuffTier((self.config).buffId)
    if (self.arglist)[3] <= buffTier then
      return 
    end
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
    self:PlayChipEffect()
  end
end

bs_91022.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91022

