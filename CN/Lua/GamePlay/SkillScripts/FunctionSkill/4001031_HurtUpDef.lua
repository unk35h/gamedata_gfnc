-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001031 = class("bs_4001031", LuaSkillBase)
local base = LuaSkillBase
bs_4001031.config = {buffId = 1272, duration = 75}
bs_4001031.ctor = function(self)
  -- function num : 0_0
end

bs_4001031.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001031_1", 1, self.OnAfterHurt, nil, nil, nil, eBattleRoleBelong.player)
end

bs_4001031.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster == target and not isMiss and not isTriggerSet then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_4001031.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001031

