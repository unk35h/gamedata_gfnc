-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15092 = class("bs_15092", LuaSkillBase)
local base = LuaSkillBase
bs_15092.config = {heal_resultId = 4}
bs_15092.ctor = function(self)
  -- function num : 0_0
end

bs_15092.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_15092_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_15092.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  do
    if sender == self.caster and LuaSkillCtrl:RoleContainsBuffFeature(target, eBuffFeatureType.Stun) and target.belongNum == eBattleRoleBelong.enemy and not isMiss and not isTriggerSet and self:IsReadyToTake() then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, sender)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[1]})
      skillResult:EndResult()
    end
    self:OnSkillTake()
  end
end

bs_15092.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15092

