-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91012 = class("bs_91012", LuaSkillBase)
local base = LuaSkillBase
bs_91012.config = {buffId = 2010, buffTier = 5}
bs_91012.ctor = function(self)
  -- function num : 0_0
end

bs_91012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_91012_10", 1, self.OnRoleDie)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91012_1", 1, self.OnAfterBattleStart)
end

bs_91012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
end

bs_91012.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if killer == self.caster and role.belongNum ~= 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  end
end

bs_91012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91012

