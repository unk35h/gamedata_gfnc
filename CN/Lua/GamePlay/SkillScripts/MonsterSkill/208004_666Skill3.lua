-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208004 = class("bs_208004", LuaSkillBase)
local base = LuaSkillBase
bs_208004.config = {effectId_hit = 208014, effectId_role = 208013, actionId_start_time = 15, actionId_end_time = 45, actionId_start = 1028, actionId_loop = 1029, actionId_end = 1030, action_speed = 1, buffId_lockCd = 170, buffId = 208005, hurtResultId = 2, selectId = 10001}
bs_208004.ctor = function(self)
  -- function num : 0_0
end

bs_208004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_208004_1", 1, self.OnAfterHurt, nil, self.caster)
  self.playskill = false
end

bs_208004.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.hurtRecord = 0
  self.playskill = true
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + (self.arglist)[1]
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, (self.config).action_speed)
  end
, nil)
  LuaSkillCtrl:StartTimer(nil, (self.config).actionId_start_time + (self.arglist)[1], function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_lockCd, 1, time, true)
  self:AbandonSkillCdAutoReset(true)
end

bs_208004.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  self.effectAtk = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_role, self, nil, nil, nil, true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1] + 3)
  local num = (self.arglist)[1] // 5 - 1
  LuaSkillCtrl:StartTimer(self, 5, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    local range = 2 - (self.caster).attackRange
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, range)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = (targetList[i]).targetRole
        if role.belongNum ~= (self.caster).belongNum and LuaSkillCtrl:IsAbleAttackTarget(self.caster, role, 2) then
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtResultId, {(self.arglist)[2]})
          skillResult:EndResult()
          LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
        end
      end
    end
  end
, self, num, 4)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], callnextskill)
end

bs_208004.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_4 , upvalues : _ENV
  if self.playskill == true and target == self.caster and hurt > 0 then
    self.hurtRecord = self.hurtRecord + hurt
    local upper = (self.caster).maxHp * (self.arglist)[3] // 1000
    if upper <= self.hurtRecord then
      self.hurtRecord = 0
      self.playskill = false
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[4])
      self:EndSkillAndCallNext()
    end
  end
end

bs_208004.EndSkillAndCallNext = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.effectAtk ~= nil then
    (self.effectAtk):Die()
    self.effectAtk = nil
  end
  LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
  if self.caster == nil then
    return 
  end
  self.hurtRecord = 0
  self.playskill = false
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_208004.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  ;
  (base.OnCasterDie)(self)
end

bs_208004.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  self.effectAtk = nil
  ;
  (base.LuaDispose)(self)
end

return bs_208004

