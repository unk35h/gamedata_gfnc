-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10324 = class("bs_10324", LuaSkillBase)
local base = LuaSkillBase
bs_10324.config = {buffId = 1261, buffTier = 15}
bs_10324.ctor = function(self)
  -- function num : 0_0
end

bs_10324.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10324_3", 1, self.OnAfterHurt, self.caster)
end

bs_10324.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, nil, true)
  end
end

bs_10324.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10324

