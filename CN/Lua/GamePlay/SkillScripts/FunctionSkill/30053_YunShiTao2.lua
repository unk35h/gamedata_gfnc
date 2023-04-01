-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30053 = class("bs_30053", LuaSkillBase)
local base = LuaSkillBase
bs_30053.config = {ysBuff = 1227}
bs_30053.ctor = function(self)
  -- function num : 0_0
end

bs_30053.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_30053_1", 1, self.OnSetHurt, self.caster)
end

bs_30053.OnSetHurt = function(self, context)
  -- function num : 0_2
  if self:IsReadyToTake() then
    self:PlayChipEffect()
    local buffTier = (context.target):GetBuffTier((self.config).ysBuff)
    if buffTier > 0 then
      context.hurt = context.hurt + context.hurt * buffTier * (self.arglist)[1] // 1000
    end
  end
end

bs_30053.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30053

