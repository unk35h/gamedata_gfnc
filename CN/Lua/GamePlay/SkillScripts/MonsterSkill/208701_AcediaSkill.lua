-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208701 = class("bs_208701", LuaSkillBase)
local base = LuaSkillBase
bs_208701.config = {skill_time = 38, skill_speed = 1, start_time = 13, buffId_170 = 170, buffIdHDBJ = 208701, buffIdAtkUp = 208702, actionId_attack3 = 1025, actionIdstart = 1008, actionId_loop = 1007, actionId_end = 1009, action_speed = 1}
bs_208701.ctor = function(self)
  -- function num : 0_0
end

bs_208701.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_208701_2", 1, self.OnBreakShield)
end

bs_208701.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.arglist)[4] + (self.config).skill_time
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionIdstart, (self.config).skill_speed, (self.config).start_time, attackTrigger)
end

bs_208701.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  local value1 = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, value1)
  local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, eShieldType.normal)
  if SelfShieldValue ~= 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdHDBJ, 1)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, nil, true)
    LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[4])
    local atkUpTime = (self.arglist)[4] // 15
    self.passive = LuaSkillCtrl:StartTimer(self, 15, self.callBack, self, atkUpTime, 1)
    LuaSkillCtrl:StartTimer(self, (self.arglist)[4], function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    if self.passive ~= nil then
      (self.passive):Stop()
      self.passive = nil
    end
    local buff = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffIdHDBJ)
    if buff ~= nil then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdHDBJ, 0)
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
      LuaSkillCtrl:StopShowSkillDurationTime(self)
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
      LuaSkillCtrl:StartTimer(self, 28, function()
      -- function num : 0_3_0_0 , upvalues : self
      self:CancleCasterWait()
    end
)
    end
  end
)
  else
    do
      LuaSkillCtrl:StopShowSkillDurationTime(self)
      self:CancleCasterWait()
      LuaSkillCtrl:CallRoleAction(self.caster, 100)
      local buff1 = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffId_170)
      if buff1 ~= nil then
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
      end
    end
  end
end

bs_208701.callBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdAtkUp, 1)
end

bs_208701.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_5 , upvalues : _ENV
  if target == self.caster then
    local buff = LuaSkillCtrl:GetRoleBuffById(target, (self.config).buffIdHDBJ)
    if buff ~= nil then
      LuaSkillCtrl:DispelBuff(target, (self.config).buffIdHDBJ, 0)
      LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
      if self.passive ~= nil then
        (self.passive):Stop()
        self.passive = nil
      end
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
      LuaSkillCtrl:StopShowSkillDurationTime(self)
      LuaSkillCtrl:StartTimer(self, 28, function()
    -- function num : 0_5_0 , upvalues : self
    self:CancleCasterWait()
  end
)
    end
  end
end

bs_208701.Onover = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  self:CancleCasterWait()
  LuaSkillCtrl:CallRoleAction(self.caster, 100)
  local buff1 = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffId_170)
  if buff1 ~= nil then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
  end
end

bs_208701.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : _ENV, base
  if role == self.caster then
    LuaSkillCtrl:StopShowSkillDurationTime(self)
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, 100)
    local buff1 = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffId_170)
    if buff1 ~= nil then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_170, 0)
    end
    local buff = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffIdHDBJ)
    if buff ~= nil then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdHDBJ, 0)
    end
    if self.passive ~= nil then
      (self.passive):Stop()
      self.passive = nil
    end
    ;
    (base.OnBreakSkill)(self, role)
  end
end

bs_208701.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
end

bs_208701.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_208701

