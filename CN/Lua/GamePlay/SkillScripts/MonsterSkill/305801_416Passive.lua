-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_305801 = class("bs_305801", LuaSkillBase)
local base = LuaSkillBase
bs_305801.config = {effectId_xb = 105801, hurtConfig = 13, buffIdys = 105801, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 2}
}
bs_305801.ctor = function(self)
  -- function num : 0_0
end

bs_305801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_305803_2", 1, self.OnRoleDie)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["305801_Roll"] = (self.arglist)[1]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["305801_arg2"] = (self.arglist)[2]
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["305801_arg3"] = (self.arglist)[3]
end

bs_305801.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if (killer == self.caster or role:GetBuffTier((self.config).buffIdys) >= 1) and role.belongNum ~= (self.caster).belongNum and role.hp == 0 and role ~= nil and role.belongNum ~= eBattleRoleBelong.neutral then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_xb, self)
    LuaSkillCtrl:StartTimer(nil, 12, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, role
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[4]})
    skillResult:EndResult()
  end
)
  end
end

bs_305801.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_305801

