-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106100 = class("bs_106100", LuaSkillBase)
local base = LuaSkillBase
bs_106100.config = {effectId_action = 106101, actionId_start = 1031, actionId_loop = 1032, actionId_end = 1033, action_speed = 1, actionId_start_time = 6}
bs_106100.ctor = function(self)
  -- function num : 0_0
end

bs_106100.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = 40
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).NeedRestart = true
end

bs_106100.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.caster).recordTable).NeedRestart == true then
    ((self.caster).recordTable).NeedRestart = false
    self.effect_loop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_action, self, nil)
    local moveTarget = self:GetMoveSelectTarget()
    if moveTarget ~= nil then
      (self.caster):LookAtTarget(moveTarget.targetRole)
    end
    local time = (self.config).actionId_start_time + self.loopTime
    self:CallCasterWait(time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, nil)
  else
    do
      local time = self.loopTime
      self:CallCasterWait(time)
    end
  end
end

bs_106100.OnBreakSkill = function(self, role)
  -- function num : 0_3 , upvalues : base
  (base.OnBreakSkill)(self, role)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).NeedRestart = true
  if self.effect_loop ~= nil then
    (self.effect_loop):Die()
    self.effect_loop = nil
  end
end

bs_106100.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.effect_loop ~= nil then
    (self.effect_loop):Die()
    self.effect_loop = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_106100.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  self.effect_loop = nil
  ;
  (base.LuaDispose)(self)
end

return bs_106100

