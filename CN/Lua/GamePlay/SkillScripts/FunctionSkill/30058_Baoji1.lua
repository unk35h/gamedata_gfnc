-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30058 = class("bs_30058", LuaSkillBase)
local base = LuaSkillBase
bs_30058.config = {configId1 = 27, effectId = 10993}
bs_30058.ctor = function(self)
  -- function num : 0_0
end

bs_30058.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_30058_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_30058.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if not isMiss and isCrit and self:IsReadyToTake() and not isTriggerSet and skill.isCommonAttack then
    self:OnSkillTake()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId1)
    skillResult:EndResult()
  end
end

bs_30058.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30058

