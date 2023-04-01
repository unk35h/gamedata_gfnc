-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92047 = class("bs_92047", LuaSkillBase)
local base = LuaSkillBase
bs_92047.config = {effectId = 10987, 
heal_config = {baseheal_formula = 10087, correct_formula = 9990, heal_number = 0}
}
bs_92047.ctor = function(self)
  -- function num : 0_0
end

bs_92047.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
  self:AddAfterHurtTrigger("bs_92047_10", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, nil)
  self.heal_config = {}
end

bs_92047.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if target.belongNum == (self.caster).belongNum and self:IsReadyToTake() and not isTriggerSet then
    self:PlayChipEffect()
    self:OnSkillTake()
    local hurtheal = hurt * (self.arglist)[1] // 1000
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(target, 1, false)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    for i = 0, targetList.Count - 1 do
      local role = targetList[i]
      if role.belongNum == (self.caster).belongNum then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {hurtheal}, true, true)
      end
    end
  end
end

bs_92047.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92047

