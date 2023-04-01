-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10327 = class("bs_10327", LuaSkillBase)
local base = LuaSkillBase
bs_10327.config = {buffId = 66, buffTier = 1, effectId = 10994, 
hurt_config = {hit_formula = 0, basehurt_formula = 10031, crit_formula = 0}
}
bs_10327.ctor = function(self)
  -- function num : 0_0
end

bs_10327.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10327_14", 90, self.OnAfterHurt, self.caster, nil, nil)
end

bs_10327.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    self:OnSkillTake()
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, 15, true)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    skillResult:EndResult()
  end
end

bs_10327.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10327

