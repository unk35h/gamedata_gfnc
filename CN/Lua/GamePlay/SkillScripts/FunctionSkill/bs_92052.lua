-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92052 = class("bs_92052", LuaSkillBase)
local base = LuaSkillBase
bs_92052.config = {buffId = 2036, buffTier = 1}
bs_92052.ctor = function(self)
  -- function num : 0_0
end

bs_92052.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_92052_1", 1, self.OnRoleDie)
end

bs_92052.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and role.belongNum ~= 0 then
    self:PlayChipEffect()
    local heal_Num = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {heal_Num}, true, true)
  end
end

bs_92052.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92052

