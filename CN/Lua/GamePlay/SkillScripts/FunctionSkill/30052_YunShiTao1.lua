-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30052 = class("bs_30052", LuaSkillBase)
local base = LuaSkillBase
bs_30052.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10182, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, effectId = 10936, ysBuff = 1227}
bs_30052.ctor = function(self)
  -- function num : 0_0
end

bs_30052.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_30052_3", 3, self.OnAfterPlaySkill)
  self:AddAfterHurtTrigger("bs_30052_2", 1, self.OnAfterHurt, self.caster)
  self.isYunShi = false
end

bs_30052.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if not skill.isCommonAttack and not self.isYunShi then
    self.isYunShi = true
  end
end

bs_30052.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and target == ((self.caster).recordTable).lastAttackRole and self.isYunShi and not isTriggerSet then
    self.isYunShi = false
    self:PlayChipEffect()
    self:OnSkillTake()
    local arriveCallBack = BindCallback(self, self.OnArriveAction, target)
    LuaSkillCtrl:StartTimer(nil, 15, arriveCallBack)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  end
end

bs_30052.OnArriveAction = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role, (self.config).aoe_config)
  if (skillResult.roleList).Count > 0 then
    for i = 0, (skillResult.roleList).Count - 1 do
      local targetRole = (skillResult.roleList)[i]
      local buffTier = targetRole:GetBuffTier((self.config).ysBuff)
      if buffTier == nil then
        return 
      end
      local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResult(self, skillResult1, (self.config).hurt_config, {buffTier})
      skillResult1:EndResult()
    end
  end
  do
    skillResult:EndResult()
  end
end

bs_30052.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30052

