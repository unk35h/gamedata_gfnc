-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_209205 = class("bs_209205", LuaSkillBase)
local base = LuaSkillBase
bs_209205.config = {skill_time = 54, actionId = 1105, action_speed = 1, start_time = 15, buffId_speed = 209203, effectId = 209212}
bs_209205.ctor = function(self)
  -- function num : 0_0
end

bs_209205.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_209205.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:CallBuff(self, self.caster, 170, 1, (self.config).skill_time)
  self:AbandonSkillCdAutoReset(true)
end

bs_209205.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId_speed, 1, (self.arglist)[3])
    end
  end
  do
    self:EndSkillAndCallNext()
  end
end

bs_209205.EndSkillAndCallNext = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_209205.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209205

