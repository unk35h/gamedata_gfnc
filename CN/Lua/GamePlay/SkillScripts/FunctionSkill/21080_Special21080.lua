-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21080 = class("bs_21080", LuaSkillBase)
local base = LuaSkillBase
bs_21080.config = {
heal_config = {baseheal_formula = 501}
}
bs_21080.ctor = function(self)
  -- function num : 0_0
end

bs_21080.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_21080_5", 1, self.OnAfterPlaySkill)
  self.targetRole1 = nil
end

bs_21080.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and skill.isCommonAttack and skill.moveSelectTarget ~= nil and (skill.moveSelectTarget).targetRole ~= self.targetRole1 then
    if self.targetRole1 == nil then
      self.targetRole1 = (skill.moveSelectTarget).targetRole
    else
      self.targetRole1 = (skill.moveSelectTarget).targetRole
      local value = (self.caster).maxHp * (self.arglist)[1] // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
      LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value}, true)
      skillResult:EndResult()
    end
  end
end

bs_21080.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if skill.isCommonAttack and self.target ~= nil and LuaSkillCtrl:GetRoleComAtkSkillMoveSelectTarget(self.caster) ~= self.target then
    self.target = LuaSkillCtrl:GetRoleComAtkSkillMoveSelectTarget(self.caster)
    local value = (self.caster).maxHp * (self.arglist)[1] // 1000
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {value})
    skillResult:EndResult()
  end
end

bs_21080.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  self.targetRole1 = nil
  self.target = nil
end

bs_21080.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  self.targetRole1 = nil
  self.target = nil
end

return bs_21080

