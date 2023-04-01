-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10298 = class("bs_10298", LuaSkillBase)
local base = LuaSkillBase
bs_10298.config = {buffId = 110003, buffTier = 1}
bs_10298.ctor = function(self)
  -- function num : 0_0
end

bs_10298.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHealTrigger("bs_10298_5", 1, self.OnAfterHeal, self.caster)
end

bs_10298.OnAfterHeal = function(self, sender, target, skill, heal, isStealHeal, isCrit, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and not isTriggerSet and self:IsReadyToTake() then
    local buffTier = target:GetBuffTier((self.config).buffId)
    if buffTier < (self.arglist)[2] then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.config).buffTier, nil, true)
      local a = 1
    else
      do
        if (self.arglist)[2] < buffTier then
          LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, (self.arglist)[2], nil, true)
        end
      end
    end
  end
end

bs_10298.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10298

