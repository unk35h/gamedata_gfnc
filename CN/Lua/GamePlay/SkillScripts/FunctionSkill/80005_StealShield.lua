-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80005 = class("bs_80005", LuaSkillBase)
local base = LuaSkillBase
bs_80005.config = {effectId1 = 10243}
bs_80005.ctor = function(self)
  -- function num : 0_0
end

bs_80005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnAfterShieldHurt, "bs_80005_4", 1, self.OnAfterShieldHurt)
end

bs_80005.OnAfterShieldHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and not context.isTriggerSet and (context.skill).isCommonAttack and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey and LuaSkillCtrl:GetShield(context.target) > 0 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
    local Value = (math.max)(1, (self.arglist)[1] * context.shield_cost_hurt // 1000)
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, Value)
  end
end

bs_80005.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80005

