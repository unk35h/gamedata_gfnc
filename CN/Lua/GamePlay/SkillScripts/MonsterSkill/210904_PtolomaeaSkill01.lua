-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210904 = class("bs_210904", LuaSkillBase)
local base = LuaSkillBase
bs_210904.config = {actionId_start = 1022, actionId_loop = 1023, actionId_end = 1024, action_speed = 1, actionId_start_time = 20, actionId_end_time = 30, buffId_hitfly = 130, HurtConfigID = 3, effect_hit = 210910, effect_end = 210911, effect_loop = 210912}
bs_210904.ctor = function(self)
  -- function num : 0_0
end

bs_210904.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = 105
end

bs_210904.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self.times = 0
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).onskill = true
  self:OnSkillTake()
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
  self:CallCasterWait(time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).actionId_start_time, attackTrigger)
  self.finishAttack = LuaSkillCtrl:StartTimer(self, (self.config).actionId_start_time + self.loopTime, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, (self.config).action_speed)
    if self.effect_atk ~= nil then
      (self.effect_atk):Die()
      self.effect_atk = nil
    end
    if self.atk ~= nil then
      (self.atk):Stop()
      self.atk = nil
    end
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.caster).recordTable).onskill = false
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, time, true)
end

bs_210904.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartShowSkillDurationTime(self, self.loopTime)
  self.effect_atk = LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_loop, self)
  self.atk = LuaSkillCtrl:StartTimer(self, 15, function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    if self.times < 7 then
      self.times = self.times + 1
      local tar = nil
      local targets = LuaSkillCtrl:CallTargetSelect(self, 42, 10)
      if targets ~= nil then
        for i = 0, targets.Count - 1 do
          local role = (targets[i]).targetRole
          if not LuaSkillCtrl:IsObstacle(role) then
            tar = role
            break
          end
        end
        do
          if tar ~= nil then
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, tar)
            LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[1]})
            skillResult:EndResult()
            LuaSkillCtrl:CallBuff(self, tar, (self.config).buffId_hitfly, 1, 10)
            local tar_grid = LuaSkillCtrl:GetGridWithRole(tar)
            local targrid = LuaSkillCtrl:GetTargetWithGrid(tar_grid.x, tar_grid.y)
            LuaSkillCtrl:CallEffect(targrid, (self.config).effect_hit, self)
          end
          do
            if self.times >= 7 then
              LuaSkillCtrl:StartTimer(self, 20, function()
      -- function num : 0_3_0_0 , upvalues : _ENV, self
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_end, self)
      local playerList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
      if playerList.Count > 0 then
        for i = playerList.Count - 1, 0, -1 do
          local role = playerList[i]
          if role ~= nil and role.hp > 0 then
            local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
            LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[2]})
            skillResult:EndResult()
          end
        end
      end
    end
, nil, nil, 1)
            end
          end
        end
      end
    end
  end
, nil, -1, 10)
end

bs_210904.OnBreakSkill = function(self, role)
  -- function num : 0_4 , upvalues : base
  (base.OnBreakSkill)(self, role)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).onskill = false
  if self.effect_atk ~= nil then
    (self.effect_atk):Die()
    self.effect_atk = nil
  end
end

bs_210904.OnCasterDie = function(self)
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

bs_210904.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.effect_atk = nil
  ;
  (base.LuaDispose)(self)
end

return bs_210904

