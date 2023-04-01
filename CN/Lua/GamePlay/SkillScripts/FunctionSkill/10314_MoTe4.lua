-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10314 = class("bs_10314", LuaSkillBase)
local base = LuaSkillBase
bs_10314.config = {buffId = 66, buffTier = 1, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, effectId = 12029}
bs_10314.ctor = function(self)
  -- function num : 0_0
end

bs_10314.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_10314_3", 3, self.OnAfterPlaySkill)
  self:AddAfterHurtTrigger("bs_10314_2", 1, self.OnAfterHurt, self.caster)
  self.isYunShi = false
end

bs_10314.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if ((self.caster).recordTable)["104502_active"] == false then
    return 
  end
  if not skill.isCommonAttack and not self.isShouci then
    self.isYunShi = true
  end
end

bs_10314.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and target == ((self.caster).recordTable).lastAttackRole and self.isYunShi and not isTriggerSet then
    self.isYunShi = false
    self:PlayChipEffect()
    self:OnSkillTake()
    local target = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
    if target == nil then
      return 
    end
    local duration = (self.arglist)[1] // (self.arglist)[2]
    local arriveCallBack = BindCallback(self, self.OnArriveAction, target)
    if self.timer == nil then
      self.timer = LuaSkillCtrl:StartTimer(nil, duration, arriveCallBack, nil, (self.arglist)[2] - 1, duration)
    end
  end
end

bs_10314.OnArriveAction = function(self, target)
  -- function num : 0_4 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
  skillResult:BuffResult((self.config).buffId, (self.config).buffTier, (self.arglist)[3])
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
  skillResult:EndResult()
end

bs_10314.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_10314.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

return bs_10314

