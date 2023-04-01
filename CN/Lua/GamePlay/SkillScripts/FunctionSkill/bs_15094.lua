-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15094 = class("bs_15094", LuaSkillBase)
local base = LuaSkillBase
bs_15094.config = {}
bs_15094.ctor = function(self)
  -- function num : 0_0
end

bs_15094.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_15094_2", 1, self.OnAfterAddBuff, self.caster, nil, nil, eBattleRoleBelong.enemy, nil, nil, eBuffFeatureType.Stun)
end

bs_15094.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_2 , upvalues : _ENV
  do
    if target.belongNum == eBattleRoleBelong.enemy and self:IsReadyToTake() then
      local shieldValue = (self.caster).maxHp * (self.arglist)[1] // 1000
      LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue, nil, true)
    end
    self:OnSkillTake()
  end
end

bs_15094.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15094

