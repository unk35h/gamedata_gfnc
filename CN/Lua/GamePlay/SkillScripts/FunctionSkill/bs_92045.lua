-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92045 = class("bs_92045", LuaSkillBase)
local base = LuaSkillBase
bs_92045.config = {buffId = 2042, buffTier = 1}
bs_92045.ctor = function(self)
  -- function num : 0_0
end

bs_92045.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_92044_10", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.player)
end

bs_92045.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.player then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
    self:PlayChipEffect()
  end
end

bs_92045.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92045

