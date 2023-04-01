-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204501 = class("bs_204501", LuaSkillBase)
local base = LuaSkillBase
bs_204501.config = {effectid_start = 204504, effectId_loop = 204507, effectid_sj = 204506, effect_end = 204505, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, 
HealConfig = {baseheal_formula = 3022}
, 
HurtConfig = {basehurt_formula = 10078, minhurt_formula = 9994, hit_formula = 0, crit_formula = 0, correct_formula = 9989}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, buff_lockcd = 204501, buff_defence = 204502, buff_taunt = 67, start_time = 43, end_time = 40}
bs_204501.ctor = function(self)
  -- function num : 0_0
end

bs_204501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_204501_3", 1, self.OnAfterHurt, nil, self.caster)
end

bs_204501.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  self:CallCasterWait((self.config).start_time + (self.arglist)[1] + (self.config).end_time)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_start, self)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, 1, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_lockcd, 1, (self.config).start_time + (self.arglist)[1], true)
end

bs_204501.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buff_defence, 1, (self.arglist)[1], true)
  self:tauntEnermy()
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_defence, 0, true)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_lockcd, 0, true)
    self:onOverHeal()
  end
)
end

bs_204501.tauntEnermy = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 1, false)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).belongNum == eBattleRoleBelong.player and not (targetlist[i]):IsUnSelect(self.caster) then
        LuaSkillCtrl:CallBuff(self, targetlist[i], (self.config).buff_taunt, 1, (self.arglist)[1])
      end
    end
  end
end

bs_204501.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_5 , upvalues : _ENV
  if target == self.caster and target:GetBuffTier((self.config).buff_defence) > 0 and isTriggerSet ~= true and skill.isCommonAttack == true then
    LuaSkillCtrl:CallEffect(sender, (self.config).effectid_sj, self, self.SkillEventFunc)
  end
end

bs_204501.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:PlayAuHit(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig)
    skillResult:EndResult()
  end
end

bs_204501.onOverHeal = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
  LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {(self.arglist)[4]})
  skillResult:EndResult()
end

bs_204501.OnBreakSkill = function(self, role)
  -- function num : 0_8 , upvalues : _ENV, base
  if role == self.caster then
    LuaSkillCtrl:StopShowSkillDurationTime(self)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_defence, 1, true)
    LuaSkillCtrl:CallRoleAction(self.caster, 100)
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_lockcd, 0, true)
    self:CancleCasterWait()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_204501.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204501

