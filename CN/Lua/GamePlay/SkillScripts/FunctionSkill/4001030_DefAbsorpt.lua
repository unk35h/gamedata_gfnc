-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001030 = class("bs_4001030", LuaSkillBase)
local base = LuaSkillBase
bs_4001030.config = {buffId_good = 1268, buffId_bad = 1269, buffTier = 1}
bs_4001030.ctor = function(self)
  -- function num : 0_0
end

bs_4001030.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001030_1", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.enemy, eBattleRoleBelong.player)
end

bs_4001030.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target == self.caster and not isMiss then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_bad, (self.config).buffTier, (self.arglist)[3], true)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_good, (self.config).buffTier, (self.arglist)[3], true)
  end
end

bs_4001030.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001030

