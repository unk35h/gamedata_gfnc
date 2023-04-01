-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92044 = class("bs_92044", LuaSkillBase)
local base = LuaSkillBase
bs_92044.config = {buffId = 2041, buffTier = 1, effectId = 1008}
bs_92044.ctor = function(self)
  -- function num : 0_0
end

bs_92044.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_92044_10", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.player)
end

bs_92044.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
    self:PlayChipEffect()
  end
end

bs_92044.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92044

