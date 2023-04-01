-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_80011 = class("bs_80011", LuaSkillBase)
local base = LuaSkillBase
bs_80011.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0}
}
bs_80011.ctor = function(self)
  -- function num : 0_0
end

bs_80011.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHealTrigger("bs_80011_1", 1, self.OnSetHeal, self.caster)
  self:AddAfterHurtTrigger("bs_80011_2", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_80011.OnSetHeal = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and self:IsReadyToTake() and not context.isTriggerSet and (context.target).roleType == eBattleRoleType.character and (context.target).belongNum == (self.caster).belongNum and (context.target).maxHp - (context.target).hp < context.heal then
    self:OnSkillTake()
    local exHeal = (context.heal - (context.target).maxHp + (context.target).hp) * (self.arglist)[1] // 1000
    if exHeal <= 0 then
      exHeal = context.heal
    end
    local sheildValue = exHeal
    LuaSkillCtrl:AddRoleShield(context.target, eShieldType.Normal, sheildValue)
  end
end

bs_80011.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if skill.isCommonAttack and not isMiss and not isTriggerSet then
    local sheidValue = LuaSkillCtrl:GetRoleAllShield(sender) * (self.arglist)[2] // 1000
    if sheidValue > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {sheidValue}, true)
      skillResult:EndResult()
    end
  end
end

bs_80011.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_80011

