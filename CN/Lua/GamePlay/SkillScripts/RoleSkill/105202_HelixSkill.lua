-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105202 = class("bs_105202", LuaSkillBase)
local base = LuaSkillBase
bs_105202.config = {effectId_trail = 105209, effectId_grid = 105210, effectId_hit = 105211, effectId_kuosan = 105218, effectId_kuosan2 = 105219, add_time = 3, buffId_power = 105202, buffId_change = 105203, skill_time = 30, start_time = 15, actionId = 1002, skill_speed = 1, heal_resultId = 3, audioId_0 = 105208, audioId_1 = 105209, audioId_2 = 105210, audioId_3 = 105211}
bs_105202.ctor = function(self)
  -- function num : 0_0
end

bs_105202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105202.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local moveTarget = self:GetMoveSelectTarget()
  if moveTarget == nil then
    return 
  end
  if (moveTarget.targetRole).belongNum ~= (self.caster).belongNum or (moveTarget.targetRole).roleType ~= (self.caster).roleType then
    moveTarget = nil
    local targetList = LuaSkillCtrl:CallTargetSelect(self, 47, 10)
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        if ((targetList[i]).targetRole).belongNum == (self.caster).belongNum and ((targetList[i]).targetRole).roleType == (self.caster).roleType then
          moveTarget = (targetList[i]).targetRole
          break
        end
      end
    end
  end
  do
    if moveTarget == nil then
      LuaSkillCtrl:SetResetCdByReturnConfigOnce(self)
      return 
    end
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, moveTarget, data)
    ;
    (self.caster):LookAtTarget(moveTarget)
    self:CallCasterWait((self.config).skill_time)
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).skill_speed, (self.config).start_time, attackTrigger)
  end
end

bs_105202.OnAttackTrigger = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail, self, self.SkillEventFunc)
end

bs_105202.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local tier = (self.caster):GetBuffTier((self.config).buffId_power)
    do
      local gridList = LuaSkillCtrl:FindAllGridsWithinRange(target, tier, true)
      if gridList.Count > 0 then
        local time = 0
        self.boomTimer = LuaSkillCtrl:StartTimer(nil, (self.config).add_time, function()
    -- function num : 0_4_0 , upvalues : time, _ENV, target, self, tier, gridList
    if time == 0 then
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
      LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_change, 1, (self.arglist)[2])
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_power, 1)
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[1]})
      skillResult:EndResult()
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_grid, self)
      if tier == 1 then
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_kuosan, self)
      end
      if tier > 1 then
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_kuosan2, self)
      end
      LuaSkillCtrl:PlayAuSource(target, (self.config).audioId_0)
    end
    do
      if time > 0 then
        if time == 1 then
          LuaSkillCtrl:PlayAuSource(target, (self.config).audioId_1)
        end
        if time == 2 then
          LuaSkillCtrl:PlayAuSource(target, (self.config).audioId_2)
        end
        if time >= 3 then
          LuaSkillCtrl:PlayAuSource(target, (self.config).audioId_3)
        end
        for i = 0, gridList.Count - 1 do
          local grid = gridList[i]
          local num = LuaSkillCtrl:GetGridsDistance(target.x, target.y, grid.x, grid.y)
          if num == time then
            if LuaSkillCtrl:GetRoleWithPos(grid.x, grid.y) == nil then
              local effectTarget = LuaSkillCtrl:GetTargetWithGrid(grid.x, grid.y)
              LuaSkillCtrl:CallEffect(effectTarget, (self.config).effectId_grid, self)
            else
              do
                local effectTarget = LuaSkillCtrl:GetRoleWithPos(grid.x, grid.y)
                LuaSkillCtrl:CallEffect(effectTarget, (self.config).effectId_grid, self)
                if effectTarget.belongNum == (self.caster).belongNum and (effectTarget.recordTable).WillowPic ~= true then
                  LuaSkillCtrl:CallEffect(effectTarget, (self.config).effectId_hit, self)
                  LuaSkillCtrl:CallBuff(self, effectTarget, (self.config).buffId_change, 1, (self.arglist)[2])
                  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_power, 1)
                  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, effectTarget)
                  LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[1]})
                  skillResult:EndResult()
                end
                do
                  -- DECOMPILER ERROR at PC209: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC209: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC209: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC209: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC209: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
      time = time + 1
    end
  end
, self, tier, (self.config).add_time)
      end
    end
  end
end

bs_105202.addBuffEffect = function(self, target, tier, gridList, time)
  -- function num : 0_5
end

bs_105202.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  if self.boomTimer ~= nil then
    (self.boomTimer):Stop()
    self.boomTimer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_105202.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  if self.boomTimer ~= nil then
    (self.boomTimer):Stop()
    self.boomTimer = nil
  end
  ;
  (base.LuaDispose)(self)
end

return bs_105202

