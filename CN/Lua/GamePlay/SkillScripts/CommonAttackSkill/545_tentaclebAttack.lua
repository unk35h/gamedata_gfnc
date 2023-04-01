-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_545 = class("bs_545", bs_1)
local base = bs_1
bs_545.config = {effectId_1 = 204811, effectId_2 = 204812, audioId3 = 436}
bs_545.config = setmetatable(bs_545.config, {__index = base.config})
bs_545.ctor = function(self)
  -- function num : 0_0
end

bs_545.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_545.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV
  self:CallSelectEffect()
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = 1
  local atkActionId = data.action1
  local atkTriggerFrame = 0
  if self.attackNum > 1 then
    local prob = LuaSkillCtrl:CallRange(1, 2)
    if prob == 1 then
      if data.audioId2 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time2, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId2)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 2) * (self.config).baseActionSpd
      atkActionId = data.action2
      atkTriggerFrame = self:GetAtkTriggerFrame(2, atkSpeed)
      self.attackNum = 0
    else
      if data.audioId1 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_2_1 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1)
      atkActionId = data.action1
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed) * (self.config).baseActionSpd
      self.attackNum = self.attackNum + 1
    end
  else
    do
      if data.audioId1 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_2_2 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1) * (self.config).baseActionSpd
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed)
      atkActionId = data.action1
      self.attackNum = self.attackNum + 1
      -- DECOMPILER ERROR at PC102: Confused about usage of register: R7 in 'UnsetPending'

      if not LuaSkillCtrl.IsInTDBattle then
        ((self.caster).recordTable).lastAttackRole = target
      end
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
      local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
      if waitTime > 0 then
        self:CallCasterWait(waitTime + 2)
      end
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger)
      if (self.caster).attackRange == 1 then
        if data.effectId_1 ~= nil then
          if atkActionId == data.action1 then
            local effectGrid = LuaSkillCtrl:GetGridWithRole(target)
            local effectGrid = LuaSkillCtrl:GetTargetWithGrid(effectGrid.x, effectGrid.y)
            -- DECOMPILER ERROR at PC165: Confused about usage of register: R11 in 'UnsetPending'

            ;
            ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(effectGrid, data.effectId_1, self, nil, nil, atkSpeedRatio, true)
          else
            do
              -- DECOMPILER ERROR at PC178: Confused about usage of register: R9 in 'UnsetPending'

              ;
              ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_2, self, nil, nil, atkSpeedRatio, true)
              if data.effectId_3 ~= nil then
                LuaSkillCtrl:StartTimer(self, atkTriggerFrame, function()
    -- function num : 0_2_3 , upvalues : _ENV, target, data, self, atkSpeedRatio
    LuaSkillCtrl:CallEffect(target, data.effectId_3, self, nil, nil, atkSpeedRatio)
  end
)
              end
              if data.effectId_start1 ~= nil then
                if atkActionId == data.action1 then
                  LuaSkillCtrl:CallEffect(target, data.effectId_start1, self, nil, nil, atkSpeedRatio, true)
                else
                  LuaSkillCtrl:CallEffect(target, data.effectId_start2, self, nil, nil, atkSpeedRatio, true)
                end
              end
            end
          end
        end
      end
    end
  end
end

bs_545.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_3 , upvalues : _ENV
  if (self.caster).attackRange == 1 then
    if data.audioId3 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3)
    end
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      if data.Imp == true then
        LuaSkillCtrl:PlayAuHit(self, target)
      end
      LuaSkillCtrl:HurtResult(self, skillResult)
      skillResult:EndResult()
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R7 in 'UnsetPending'

      if ((self.caster).recordTable).completeFirstComatk == nil then
        ((self.caster).recordTable).completeFirstComatk = true
      end
    else
      do
        self:BreakSkill()
        if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
          if data.effectId_action_1 ~= nil then
            if atkActionId == data.action1 then
              LuaSkillCtrl:CallEffect(self.caster, data.effectId_action_1, self)
            else
              LuaSkillCtrl:CallEffect(self.caster, data.effectId_action_2, self)
            end
          end
          if data.effectId_start3 ~= nil then
            if atkActionId == data.action1 then
              LuaSkillCtrl:CallEffect(target, data.effectId_start3, self, nil, nil, atkSpeedRatio)
            else
              LuaSkillCtrl:CallEffect(target, data.effectId_start4, self, nil, nil, atkSpeedRatio)
            end
          end
          local extraTarget = self:CheckAndGetExtraEffectTarget(target)
          self:ExecuteEffectAttack(data, atkActionId, target)
          if extraTarget ~= nil then
            self:ExecuteEffectAttack(data, atkActionId, extraTarget)
          end
          -- DECOMPILER ERROR at PC128: Confused about usage of register: R7 in 'UnsetPending'

          if ((self.caster).recordTable).completeFirstComatk == nil then
            ((self.caster).recordTable).completeFirstComatk = true
          end
        else
          do
            self:BreakSkill()
            if self.isDoubleAttack then
              local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
              self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
            else
              do
                self:CancleCasterWait()
              end
            end
          end
        end
      end
    end
  end
end

bs_545.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_545

