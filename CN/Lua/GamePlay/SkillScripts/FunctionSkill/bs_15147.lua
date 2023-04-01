-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15147 = class("bs_15147", LuaSkillBase)
local base = LuaSkillBase
bs_15147.config = {
heal_config = {baseheal_formula = 501, heal_number = 0, correct_formula = 9990}
}
bs_15147.ctor = function(self)
  -- function num : 0_0
end

bs_15147.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_15147", 1, self.OnRoleDie, nil, nil, nil, (self.caster).belongNum, nil, eBattleRoleType.character)
end

bs_15147.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum and role.roleType == 1 then
    self:PlayChipEffect()
    local healNum = role.maxHp * (self.arglist)[1] // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {healNum}, true, true)
    skillResult:EndResult()
  end
end

bs_15147.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15147

