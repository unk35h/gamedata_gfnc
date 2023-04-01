-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15059 = class("bs_15059", LuaSkillBase)
local base = LuaSkillBase
bs_15059.config = {}
bs_15059.ctor = function(self)
  -- function num : 0_0
end

bs_15059.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHealTrigger("bs_15059_4", 1, self.OnSetHeal, self.caster)
end

bs_15059.OnSetHeal = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and self:IsReadyToTake() and not context.isTriggerSet and (context.target).maxHp - (context.target).hp < context.heal then
    self:OnSkillTake()
    local exHeal = (context.heal - (context.target).maxHp + (context.target).hp) * (self.arglist)[1] // 1000
    if exHeal <= 0 then
      exHeal = context.heal
    end
    local sheildValue = exHeal
    LuaSkillCtrl:AddRoleShield(context.target, eShieldType.Normal, sheildValue)
  end
end

bs_15059.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15059

