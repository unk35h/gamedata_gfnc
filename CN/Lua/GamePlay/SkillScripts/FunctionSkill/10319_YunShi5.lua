-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10319 = class("bs_10319", LuaSkillBase)
local base = LuaSkillBase
bs_10319.config = {ysBuff = 1227}
bs_10319.ctor = function(self)
  -- function num : 0_0
end

bs_10319.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_10319_1", 1, self.OnSetHurt, nil, self.caster, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_10319.OnSetHurt = function(self, context)
  -- function num : 0_2
  if self:IsReadyToTake() then
    local buffTier = (context.sender):GetBuffTier((self.config).ysBuff)
    if buffTier > 0 then
      context.hurt = context.hurt - context.hurt * (self.arglist)[1] * buffTier // 1000
      self:PlayChipEffect()
    end
  end
end

bs_10319.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10319

