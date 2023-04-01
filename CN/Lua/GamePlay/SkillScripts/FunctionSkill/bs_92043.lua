-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92043 = class("bs_92043", LuaSkillBase)
local base = LuaSkillBase
bs_92043.config = {baseheal_formula = 10011, effectId = 1008}
bs_92043.ctor = function(self)
  -- function num : 0_0
end

bs_92043.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_102506_2", 1, self.OnRoleDie, nil, nil, nil, eBattleRoleBelong.player)
end

bs_92043.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.player then
    local sheildNum = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).baseheal_formula, self.caster, role, self)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, sheildNum)
    self:PlayChipEffect()
  end
end

bs_92043.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92043

