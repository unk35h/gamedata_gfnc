-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210302 = class("bs_210302", LuaSkillBase)
local base = LuaSkillBase
bs_210302.config = {skill_time = 18, start_time = 15, actionId = 1002, action_speed = 1, buffId_241 = 241, buffId_242 = 210301, buffId_196 = 196, 
HurtConfig_ex = {hit_formula = 0, basehurt_formula = 10125, crit_formula = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, effectId_skill = 210304, effectId_bnfffire = 100307, audioId1 = 329}
bs_210302.ctor = function(self)
  -- function num : 0_0
end

bs_210302.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_210302_3", 1, self.OnAfterHurt, self.caster)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arg2 = (self.arglist)[1]
end

bs_210302.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_skill, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, (self.config).start_time, true)
end

bs_210302.OnAttackTrigger = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.caster).recordTable).attack = 2
end

bs_210302.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack and ((self.caster).recordTable).attack == 2 and not isMiss then
    LuaSkillCtrl:CallBuffRepeated(self, target, (self.config).buffId_242, 1, (self.arglist)[2], nil, self.OnBuffExecute)
  end
end

bs_210302.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig_ex, {buff.tier}, true)
  skillResult:EndResult()
end

bs_210302.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_210302
