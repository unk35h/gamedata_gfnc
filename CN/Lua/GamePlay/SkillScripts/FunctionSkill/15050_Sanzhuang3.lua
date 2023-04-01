-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15050 = class("bs_15050", LuaSkillBase)
local base = LuaSkillBase
bs_15050.config = {buffId = 1242, buffTier = 1}
bs_15050.ctor = function(self)
  -- function num : 0_0
end

bs_15050.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHealTrigger("bs_15050_2", 1, self.OnAfterHeal, nil, self.caster)
end

bs_15050.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  end
end

bs_15050.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15050

