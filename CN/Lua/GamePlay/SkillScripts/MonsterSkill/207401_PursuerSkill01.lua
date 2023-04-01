-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207401 = class("bs_207401", LuaSkillBase)
local base = LuaSkillBase
bs_207401.config = {buffId_speed = 207401, buffId_damage_increase = 207402, effectId_loop = 207402, effectId_end = 207403, skill_time = 20, actionId = 1004, action_speed = 1, start_time = 10}
bs_207401.ctor = function(self)
  -- function num : 0_0
end

bs_207401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBuffDieTrigger("bs_207401_buff_die", 1, self.OnBuffDie, nil, nil, (self.config).buffId_speed)
end

bs_207401.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
end

bs_207401.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_speed, 1, (self.arglist)[2])
  self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
  self:AddAfterHurtTrigger("bs_207401_1", 1, self.OnAfterHurt, self.caster)
  self.effect_loop_207401 = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self)
end

bs_207401.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if skill.isCommonAttack and sender == self.caster and not isMiss then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_damage_increase, 1)
  end
end

bs_207401.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_speed and removeType == eBuffRemoveType.Timeout then
    self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_damage_increase, 10, true)
    if self.effect_loop_207401 ~= nil then
      (self.effect_loop_207401):Die()
      self.effect_loop_207401 = nil
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_end, self)
  end
end

bs_207401.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effect_loop_207401 ~= nil then
    (self.effect_loop_207401):Die()
    self.effect_loop_207401 = nil
  end
end

bs_207401.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  self.effect_loop_207401 = nil
  ;
  (base.LuaDispose)(self)
end

return bs_207401

