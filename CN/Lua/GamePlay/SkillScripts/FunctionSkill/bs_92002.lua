-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92002 = class("bs_92002", LuaSkillBase)
local base = LuaSkillBase
bs_92002.config = {buffId = 195, buffTier = 1, effectId = 10644, 
hurtConfig = {hit_formula = 0, basehurt_formula = 10031, crit_formula = 0}
}
bs_92002.ctor = function(self)
  -- function num : 0_0
end

bs_92002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.BeforePlaySkill, "bs_92002_11", 2, self.OnBeforePlaySkill)
end

bs_92002.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2
  if role == self.caster and not (context.skill).isCommonAttack then
    self:OnShout()
  end
end

bs_92002.OnShout = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetList ~= nil and targetList.Count < 1 then
    return 
  end
  if targetList == nil then
    return 
  end
  self:PlayChipEffect()
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  for i = 0, targetList.Count - 1 do
    local targetRole = (targetList[i]).targetRole
    if targetRole.belongNum ~= 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurtConfig, nil, true)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, (self.arglist)[2], 75)
    end
  end
end

bs_92002.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92002

