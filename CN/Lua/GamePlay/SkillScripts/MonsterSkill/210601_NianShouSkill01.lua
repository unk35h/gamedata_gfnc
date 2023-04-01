-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210601 = class("bs_210601", LuaSkillBase)
local base = LuaSkillBase
bs_210601.config = {buffId_critcore = 210602, buffId_lockCd = 170, buffId_debuff = 210601, effect_hit = 210603, effect_atk = 210604, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, action_speed = 1, actionId_start_time = 15, actionId_end_time = 40, configId = 3}
bs_210601.ctor = function(self)
  -- function num : 0_0
end

bs_210601.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = (self.arglist)[1]
end

bs_210601.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:OnSkillTake()
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  self.loopAttack = LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, (self.config).action_speed)
  end
, nil)
  self.finishAttack = LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time + self.loopTime, function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
    if self.effect_atk ~= nil then
      (self.effect_atk):Die()
      self.effect_atk = nil
    end
    if self.atk ~= nil then
      (self.atk):Stop()
      self.atk = nil
    end
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_lockCd, 1, time, true)
  self:AbandonSkillCdAutoReset(true)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  self.callnext = LuaSkillCtrl:StartTimer(self, time, callnextskill)
end

bs_210601.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  if (self.caster):GetBuffTier((self.config).buffId_critcore) > 0 then
    LuaSkillCtrl:StartShowSkillDurationTime(self, self.loopTime + 2)
    self.effect_atk = LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_atk, self)
    LuaSkillCtrl:CallBattleCamShakeByParam(0, 1, 0.5, 50)
    self.atk = LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBattleCamShakeByParam(0, 2, 0.5, 50)
    if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Exiled) then
      if self.effect_atk ~= nil then
        (self.effect_atk):Die()
        self.effect_atk = nil
      end
      if self.atk ~= nil then
        (self.atk):Stop()
        self.atk = nil
      end
      if self.callnext ~= nil then
        (self.callnext):Stop()
        self.callnext = nil
      end
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
      local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
      LuaSkillCtrl:StartTimer(self, (self.config).actionId_end_time, callnextskill)
    end
    do
      if (self.caster):GetBuffTier((self.config).buffId_critcore) == 0 then
        if self.effect_atk ~= nil then
          (self.effect_atk):Die()
          self.effect_atk = nil
        end
        if self.atk ~= nil then
          (self.atk):Stop()
          self.atk = nil
        end
        if self.callnext ~= nil then
          (self.callnext):Stop()
          self.callnext = nil
        end
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
        local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
        LuaSkillCtrl:StartTimer(self, (self.config).actionId_end_time, callnextskill)
      end
      do
        local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
        if targetList.Count > 0 then
          for i = targetList.Count - 1, 0, -1 do
            local role = targetList[i]
            if role ~= nil and role.hp > 0 then
              LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_debuff, 1, (self.arglist)[4])
              local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
              LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[2]})
              skillResult:EndResult()
              LuaSkillCtrl:CallEffect(role, (self.config).effect_hit, self)
            end
          end
        end
      end
    end
  end
, nil, -1, 10)
  else
    if (self.caster):GetBuffTier((self.config).buffId_critcore) == 0 then
      if self.callnext ~= nil then
        (self.callnext):Stop()
        self.callnext = nil
      end
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
      local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
      LuaSkillCtrl:StartTimer(self, (self.config).actionId_end_time, callnextskill)
    end
  end
end

bs_210601.EndSkillAndCallNext = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.effect_atk ~= nil then
    (self.effect_atk):Die()
    self.effect_atk = nil
  end
  if self.atk ~= nil then
    (self.atk):Stop()
    self.atk = nil
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critcore, 1, nil)
  LuaSkillCtrl:DispelBuff(self.caster, 170, 0)
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  ;
  (self.caster):CallUnFreezeNextSkill()
  LuaSkillCtrl:StopShowSkillDurationTime(self)
end

bs_210601.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effect_atk ~= nil then
    (self.effect_atk):Die()
    self.effect_atk = nil
  end
  if self.atk ~= nil then
    (self.atk):Stop()
    self.atk = nil
  end
end

bs_210601.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.effect_atk = nil
  self.atk = nil
  self.callnext = nil
end

return bs_210601

