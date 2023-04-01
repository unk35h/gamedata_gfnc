-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_2109000 = class("bs_2109000", bs_1)
local base = bs_1
bs_2109000.config = {actionId_start = 1034, actionId_loop = 1035, actionId_end = 1036, action_speed = 1, actionId_start_time = 10, actionId_end_time = 13, effectId_trail = 210901, action1 = 1001, action2 = 1001, HurtConfigID = 17, effectId_target = 210903, effectId_lineStart = 210905, effectId_lineEnd = 210906, timeDuration = 15}
bs_2109000.config = setmetatable(bs_2109000.config, {__index = base.config})
bs_2109000.ctor = function(self)
  -- function num : 0_0
end

bs_2109000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = 110
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_2109000_1", 1, self.OnAfterBattleStart)
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_2109000.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CountDown)), nil, 119, 15)
end

bs_2109000.CountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.timeValue <= 0 then
    LuaSkillCtrl:ForceEndBattle(false)
  end
end

bs_2109000.PlaySkill = function(self, passdata)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.caster).recordTable).changeCount <= ((self.caster).recordTable).Count then
    ((self.caster).recordTable).onskill = true
    local last_target = ((self.caster).recordTable).lastAttackRole
    local target = nil
    if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 5) then
      target = last_target
    else
      local tempTarget = self:GetMoveSelectTarget()
      if tempTarget == nil then
        return 
      end
      target = tempTarget.targetRole
    end
    do
      if target ~= nil then
        local attackTrigger = BindCallback(self, self.OnAttackTrigger11, target)
        ;
        (self.caster):LookAtTarget(target)
        local skilltime = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
        self:CallCasterWait(skilltime)
        LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
      end
      do
        do
          self.loopAttack = LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop, (self.config).action_speed)
  end
, nil)
          self.finishAttack = LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time + self.loopTime, function()
    -- function num : 0_4_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
    if self.atk ~= nil then
      (self.atk):Stop()
      self.atk = nil
    end
    if self.targetEffect ~= nil then
      (self.targetEffect):Die()
      self.targetEffect = nil
    end
    if self.lineStart ~= nil then
      (self.lineStart):Die()
      self.lineStart = nil
    end
    if self.lineEnd ~= nil then
      (self.lineEnd):Die()
      self.lineEnd = nil
    end
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).onskill = false
  end
, nil)
          self:CheckAndRecordIsDoubleAttack(passdata)
          local data = nil
          if passdata ~= nil then
            data = setmetatable(passdata, {__index = self.config})
          else
            data = self.config
          end
          self:SetAttackRole(data)
          if self.lastAttackRole ~= nil and LuaSkillCtrl:IsAbleAttackTarget(self.caster, self.lastAttackRole, data.rangeOffset + (self.caster).attackRange, true) and LuaSkillCtrl:IsWorthAttacking(self, self.lastAttackRole) then
            (self.caster):LookAtTarget(self.lastAttackRole)
            if LuaSkillCtrl:IsAbleAttackCheckExcludedDir(self.caster, self.lastAttackRole, (self.config).atkDirectionRange) then
              self.rotateWaited = true
              LuaSkillCtrl:StartTimer(self, 3, BindCallback(self, self.RealPlaySkill, self.lastAttackRole, data))
            else
              self.rotateWaited = false
              self:RealPlaySkill(self.lastAttackRole, data)
            end
          else
            self.lastAttackRole = nil
            -- DECOMPILER ERROR at PC170: Confused about usage of register: R3 in 'UnsetPending'

            ;
            ((self.caster).recordTable).lastAttackRole = nil
            self:ClearDoubleAttackNum()
            self:CancleCasterWait()
          end
        end
      end
    end
  end
end

bs_2109000.OnAttackTrigger11 = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  self.targetEffect = LuaSkillCtrl:CallEffect(target, (self.config).effectId_target, self)
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  self.lineStart = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_lineStart, self)
  LuaSkillCtrl:StartTimer(self, 2, function()
    -- function num : 0_5_0 , upvalues : self, _ENV, target
    if self.lineEnd ~= nil then
      (self.lineEnd):Die()
      self.lineEnd = nil
    end
    self.lineEnd = LuaSkillCtrl:CallEffect(target, (self.config).effectId_lineEnd, self)
  end
)
  local times = 0
  self.atk = LuaSkillCtrl:StartTimer(self, 15, function()
    -- function num : 0_5_1 , upvalues : self, target, _ENV, times
    (self.caster):LookAtTarget(target)
    if target._curHp <= 0 then
      LuaSkillCtrl:CallBreakAllSkill(self.caster)
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {((self.caster).recordTable).AtkDam + times * ((self.caster).recordTable).AtkDamAdd})
    skillResult:EndResult()
    times = times + 1
  end
, nil, -1, 15)
end

bs_2109000.OnBreakSkill = function(self, role)
  -- function num : 0_6 , upvalues : base
  (base.OnBreakSkill)(self, role)
  if self.atk ~= nil then
    (self.atk):Stop()
    self.atk = nil
  end
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).onskill = false
end

bs_2109000.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
  if self.atk ~= nil then
    (self.atk):Stop()
    self.atk = nil
  end
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
end

bs_2109000.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
  if self.atk ~= nil then
    (self.atk):Stop()
    self.atk = nil
  end
  if self.targetEffect ~= nil then
    (self.targetEffect):Die()
    self.targetEffect = nil
  end
  if self.lineStart ~= nil then
    (self.lineStart):Die()
    self.lineStart = nil
  end
  if self.lineEnd ~= nil then
    (self.lineEnd):Die()
    self.lineEnd = nil
  end
end

return bs_2109000

