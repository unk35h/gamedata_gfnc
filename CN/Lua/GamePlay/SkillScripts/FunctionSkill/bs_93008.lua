-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93008 = class("bs_93008", LuaSkillBase)
local base = LuaSkillBase
bs_93008.config = {effectId1 = 10970, effectId2 = 10971, effectId3 = 10972, 
hurt_config = {hit_formula = 0, basehurt_formula = 502, crit_formula = 0}
}
bs_93008.ctor = function(self)
  -- function num : 0_0
end

bs_93008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_93008", 90, self.OnSetHurt, self.caster)
  self.layer = 0
end

bs_93008.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.skill).isCommonAttack and context.sender == self.caster and context.isTriggerSet ~= true and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey then
    local targetRole = ((self.caster).recordTable).lastAttackRole
    if targetRole ~= nil then
      local damage = (self.caster).pow * ((self.arglist)[1] + (self.arglist)[2] * self.layer) // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {damage}, true)
      if self.layer < (self.arglist)[3] // 5 then
        LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId1, self)
      else
        if self.layer < (self.arglist)[3] // 2 then
          LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId2, self)
        else
          LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId3, self)
        end
      end
      if self.layer < (self.arglist)[3] then
        self.layer = self.layer + 1
      end
      skillResult:EndResult()
    end
  end
end

bs_93008.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and skill.isCommonAttack then
    local targetRole = ((self.caster).recordTable).lastAttackRole
    if targetRole ~= nil then
      local damage = (self.caster).pow * ((self.arglist)[1] + (self.arglist)[2] * self.layer)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {damage}, true)
      if self.layer < (self.arglist)[3] // 5 then
        LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId1, self)
      else
        if self.layer < (self.arglist)[3] // 2 then
          LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId2, self)
        else
          LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId3, self)
        end
      end
      if self.layer < (self.arglist)[3] then
        self.layer = self.layer + 1
      end
      skillResult:EndResult()
    end
  end
end

bs_93008.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93008

