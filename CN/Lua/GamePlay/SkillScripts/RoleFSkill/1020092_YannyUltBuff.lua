-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1020092 = class("bs_1020092", LuaSkillBase)
local base = LuaSkillBase
bs_1020092.config = {buffId = 102003}
bs_1020092.ctor = function(self)
  -- function num : 0_0
end

bs_1020092.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddAfterHurtTrigger("bs_1020092_3", 1, self.OnAfterHurt, nil, self.caster)
end

bs_1020092.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and (self.caster):GetBuffTier((self.config).buffId) > 0 and not isMiss and hurt > 0 and LuaSkillCtrl:CallRange(1, 1000) <= ((self.caster).recordTable)["102009_UltBuff"] then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_1020092.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1020092

