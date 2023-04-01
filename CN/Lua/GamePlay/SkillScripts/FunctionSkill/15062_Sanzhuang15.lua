-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15062 = class("bs_15062", LuaSkillBase)
local base = LuaSkillBase
bs_15062.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10077, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 2}
, buffId = 66, buffTier = 1, effectId = 10951, effectIdHit = 10952}
bs_15062.ctor = function(self)
  -- function num : 0_0
end

bs_15062.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.OnBreakShield, "bs_15062_2", 1, self.OnBreakShield)
end

bs_15062.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum ~= (self.caster).belongNum and self:IsReadyToTake() and sender == self.caster then
    self:OnSkillTake()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
    skillResult:BuffResult((self.config).buffId, (self.config).buffTier, (self.arglist)[1])
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    if (skillResult.roleList).Count > 0 then
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        LuaSkillCtrl:CallEffect(role, (self.config).effectIdHit, self)
      end
    end
    do
      skillResult:EndResult()
    end
  end
end

bs_15062.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15062

