-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209502 = class("bs_209502", LuaSkillBase)
local base = LuaSkillBase
bs_209502.config = {effectid_1 = 209504, effectid_2 = 209505, actionId = 1055, actionId_time = 64, action_speed = 1, buffId = 209504, HurtConfigID = 3, effect_trail = 209506, buffId_1 = 209505, actionId1 = 1001, actionId_start_time1 = 7, skilltime1 = 26}
bs_209502.ctor = function(self)
  -- function num : 0_0
end

bs_209502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnTuringSkill, self.OnTuringSkill)
  self.arg3 = ((self.caster).recordTable).arg_3
end

bs_209502.OnAfterBattleStart = function(self, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV
  if summonerEntity == self.caster then
    local time = (self.config).actionId_time
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_1, self, nil)
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_2, self, nil)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, time)
  end
end

bs_209502.OnTuringSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local time = (self.config).skilltime1
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId1, (self.config).action_speed)
  LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time1, (BindCallback(self, self.OnAttackTrigger)), nil)
end

bs_209502.OnAttackTrigger = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local target = ((self.caster).recordTable).lastAttackRole
  LuaSkillCtrl:CallEffectWithArg(target, (self.config).effect_trail, self, nil, false, self.Dodamage)
end

bs_209502.Dodamage = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and effect.dataId == (self.config).effect_trail then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {self.arg3})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_1, 1, (self.arglist)[2])
  end
end

bs_209502.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209502

