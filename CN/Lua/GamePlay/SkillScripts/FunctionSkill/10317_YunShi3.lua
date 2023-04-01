-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10317 = class("bs_10317", LuaSkillBase)
local base = LuaSkillBase
bs_10317.config = {ysBuff = 1227, 
hurt_config = {hit_formula = 0, basehurt_formula = 10076, crit_formula = 0}
, effectId = 12030}
bs_10317.ctor = function(self)
  -- function num : 0_0
end

bs_10317.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("10316_after_hurt", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
end

bs_10317.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if self:IsReadyToTake() and not isTriggerSet then
    local buffTier = target:GetBuffTier((self.config).ysBuff)
    if buffTier > 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
      skillResult:EndResult()
      self:PlayChipEffect()
      self:OnSkillTake()
    end
  end
end

bs_10317.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10317

