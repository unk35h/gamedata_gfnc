-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301501 = class("bs_301501", LuaSkillBase)
local base = LuaSkillBase
bs_301501.config = {select_id = 5, select_range = 1, buffStatue = 110013, buffSleep = 110014, buffWake = 110015, ExecuteInterval = 60, timeOffset = 15, effectId_Wake = 12043, effectId_Sleep = 12040, effectId_up = 12041, effectId_hit = 12044, 
HurtConfig = {basehurt_formula = 10087, hit_formula = 0, crit_formula = 0}
, start_time = 13, actionId_wake = 1045, action_speed = 1, actionId_sleep = 1046, audioId1 = 10103, audioId2 = 10101}
bs_301501.ctor = function(self)
  -- function num : 0_0
end

bs_301501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  self.state = 2
  self.stateHalo = nil
  self.effectHaloWake = nil
  self.effectHaloSleep = nil
  ;
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_301501_1", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnStateWake, self.OnWake)
  self:AddLuaTrigger(eSkillLuaTrigger.OnStateSleep, self.OnSleep)
end

bs_301501.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffStatue, 1)
  self.curAccFrame = 5
  if self.effectHaloWake ~= nil then
    (self.effectHaloWake):Die()
    self.effectHaloWake = nil
  end
  self.effectHaloSleep = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Sleep, self)
  local collisionStay = BindCallback(self, self.OnCollisionStay)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.stateHalo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 100, 0, eColliderInfluenceType.Enemy, nil, collisionStay, collisionExit, nil, false, false, nil, self.caster)
  self.Timer = LuaSkillCtrl:StartTimer(self, 1, BindCallback(self, self.OnCheckState), self, -1, 0)
end

bs_301501.OnCollisionStay = function(self, Collider, role)
  -- function num : 0_3 , upvalues : _ENV
  if self.state == 1 then
    if role:GetBuffTier((self.config).buffWake) <= 0 then
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffWake, 1)
    end
    if role:GetBuffTier((self.config).buffSleep) >= 0 then
      LuaSkillCtrl:DispelBuff(role, (self.config).buffSleep, 0, true)
    end
    if (self.arglist)[1] <= self.curAccFrame then
      LuaSkillCtrl:RemoveLife(role.maxHp * (self.arglist)[2] // 1000, self, role, fasle, nil, true, false, eHurtType.RealDmg)
      LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self)
    end
  else
    if role:GetBuffTier((self.config).buffWake) >= 0 then
      LuaSkillCtrl:DispelBuff(role, (self.config).buffWake, 0, true)
    end
    if role:GetBuffTier((self.config).buffSleep) <= 0 then
      LuaSkillCtrl:CallBuff(self, role, (self.config).buffSleep, 1)
    end
    if (self.arglist)[1] <= self.curAccFrame then
      local skills = role:GetBattleSkillList()
      if skills ~= nil then
        local count = skills.Count
        if count > 0 then
          for j = 0, count - 1 do
            if not (skills[j]).isCommonAttack then
              local curCd = (skills[j]).totalCDTime * (self.arglist)[3] // 1000
              LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curCd)
            end
          end
        end
      end
    end
  end
end

bs_301501.OnCollisionExit = function(self, collider, role)
  -- function num : 0_4 , upvalues : _ENV
  if role:GetBuffTier((self.config).buffWake) >= 1 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffWake, 0, true)
  end
  if role:GetBuffTier((self.config).buffSleep) >= 1 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffSleep, 0, true)
  end
end

bs_301501.OnCheckState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.state == 2 then
    if self.effectHaloWake ~= nil then
      (self.effectHaloWake):Die()
      self.effectHaloWake = nil
    end
    if self.effectHaloSleep == nil then
      self.effectHaloSleep = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Sleep, self)
    end
  else
    if self.effectHaloSleep ~= nil then
      (self.effectHaloSleep):Die()
      self.effectHaloSleep = nil
    end
    if self.effectHaloWake == nil then
      self.effectHaloWake = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Wake, self)
    end
  end
  if (self.arglist)[1] <= self.curAccFrame then
    self.curAccFrame = 0
  end
  self.curAccFrame = self.curAccFrame + 1
end

bs_301501.OnWake = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.state = 1
  if self.effectHaloSleep ~= nil then
    (self.effectHaloSleep):Die()
    self.effectHaloSleep = nil
  end
  if self.effectHaloWake == nil then
    self.effectHaloWake = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Wake, self)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_wake)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  end
end

bs_301501.OnSleep = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self.state = 2
  if self.effectHaloWake ~= nil then
    (self.effectHaloWake):Die()
    self.effectHaloWake = nil
  end
  if self.effectHaloSleep == nil then
    self.effectHaloSleep = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_Sleep, self)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_sleep)
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
  end
end

bs_301501.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.effectHaloWake ~= nil then
    (self.effectHaloWake):Die()
    self.effectHaloWake = nil
  end
  if self.effectHaloSleep ~= nil then
    (self.effectHaloSleep):Die()
    self.effectHaloSleep = nil
  end
  if self.Timer then
    (self.Timer):Stop()
    self.Timer = nil
  end
  if self.stateHalo ~= nil then
    (self.stateHalo):EndAndDisposeEmission()
    self.stateHalo = nil
  end
end

return bs_301501

