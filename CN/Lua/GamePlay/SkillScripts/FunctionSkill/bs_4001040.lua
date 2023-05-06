-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001040 = class("bs_4001040", LuaSkillBase)
local base = LuaSkillBase
bs_4001040.config = {buffId = 2073, buffId_blood = 195, buffId_fire = 1227, duration_blood = 75, duration_fire = 90}
bs_4001040.ctor = function(self)
  -- function num : 0_0
end

bs_4001040.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_4001040", 10, self.OnAfterHurt, self.caster, nil, nil, eBattleRoleBelong.enemy, nil, nil, nil, nil)
end

bs_4001040.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  local Giantbuff = (self.caster):GetBuffTier((self.config).buffId)
  if isMiss or Giantbuff == nil or Giantbuff < 1 and isTriggerSet then
    return 
  end
  if hurtType == eHurtType.PhysicsDmg then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_blood, 1, (self.config).duration_blood, true)
  end
  if hurtType == eHurtType.MagicDmg then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_fire, 1, (self.config).duration_fire, true)
  end
end

bs_4001040.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001040

