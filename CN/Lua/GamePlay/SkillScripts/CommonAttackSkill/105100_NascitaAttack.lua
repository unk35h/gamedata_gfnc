-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105100 = class("bs_105100", bs_1)
local base = bs_1
bs_105100.config = {action1 = 1001, action2 = 1004, selectId = 9, selectRange = 10, BuffId_slide = 1051013, buffId_claw = 1051012, buffId_ult = 1051031, buffId_CD = 1051014, effectId_1 = 105101, effectId_2 = 105102, effectId_up = 105104, effectId_down = 105112, 
specialColor = {r = 134, g = 50, b = 191}
, audioId1 = 105101, time1 = 0, audioId2 = 105102, time2 = 0}
bs_105100.config = setmetatable(bs_105100.config, {__index = base.config})
local AtkState = {Atk = 1, Splash = 2, Stop = 3}
local RoleState = {normal = 1, special = 2}
bs_105100.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, RoleState, AtkState, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.__atkNum = 0
  self.__complateExeCount = 0
  self.__roleState = RoleState.normal
  self.state = AtkState.Stop
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  self:ShowAttackCounting(0)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_105100_1", 1, self.BeforeEndBattle)
end

bs_105100.PlaySkill = function(self, passdata)
  -- function num : 0_1 , upvalues : base
  self:CallCasterWait(450)
  ;
  (base.PlaySkill)(self, passdata)
end

bs_105100.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV, RoleState
  if data.audioId3 ~= nil then
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId3)
  end
  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
    (self.caster):LookAtTarget(target)
    if self.__roleState == RoleState.special then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 10, {((self.caster).recordTable).SplashAttackLow})
      skillResult:EndResult()
    else
      do
        do
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          if data.Imp == true then
            LuaSkillCtrl:PlayAuHit(self, target)
          end
          LuaSkillCtrl:HurtResult(self, skillResult)
          skillResult:EndResult()
          if self.__roleState == RoleState.normal then
            self.__atkNum = self.__atkNum + 1
            self:ShowAttackCounting(self.__atkNum, self.__atkNum > 1)
          else
            LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, target, self.caster, self.cskill)
          end
          if (self.caster):GetBuffTier((self.config).buffId_ult) > 0 then
            LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnNascitaAttack, target, self.caster, self.cskill)
          end
          -- DECOMPILER ERROR at PC111: Confused about usage of register: R6 in 'UnsetPending'

          if ((self.caster).recordTable).completeFirstComatk == nil then
            ((self.caster).recordTable).completeFirstComatk = true
          end
          self:BreakSkill()
          if self.isDoubleAttack then
            local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
            self:CheckAndExecuteSecondAttack(data, target, atkTriggerFrame, atkSpeedRatio, atkActionId, attackTrigger)
          else
            self:CancleCasterWait()
          end
          if self.recordDoubleAttackNum == nil or self.recordDoubleAttackNum == 0 then
            if self.__roleState == RoleState.normal then
              if self.__atkNum < ((self.caster).recordTable).MaxAttackCount then
                return 
              end
              self.__roleState = RoleState.special
              self.specialAtkCount = self:CalcSpecialAtkCount()
              self:ShowAttackCounting(self.specialAtkCount, false)
              if not LuaSkillCtrl.IsInVerify then
                LuaSkillCtrl:SetCountingColor(self.caster, ((self.config).specialColor).r, ((self.config).specialColor).g, ((self.config).specialColor).b, 255)
              end
              LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, nil, true)
              self.__atkNum = 0
            end
            if self.__roleState == RoleState.special and (self.caster):GetBuffTier((self.config).buffId_CD) <= 0 then
              LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, nil, true)
            end
            self:CheckAtkAndSplash(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
          end
          -- DECOMPILER ERROR: 14 unprocessed JMP targets
        end
      end
    end
  end
end

bs_105100.CalcSpecialAtkCount = function(self)
  -- function num : 0_3
  local normalCount = ((self.caster).recordTable).SplashAttackCount
  if ((self.caster).recordTable).ultPassive == nil then
    return normalCount
  else
    local ultCount = ((self.caster).recordTable).ultPassive + normalCount
    return (self.caster):GetBuffTier((self.config).buffId_ult) > 0 and ultCount or normalCount
  end
end

bs_105100.ShowAttackCounting = function(self, value, isUpdate)
  -- function num : 0_4 , upvalues : _ENV, RoleState
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  if value == 0 and not isUpdate then
    LuaSkillCtrl:HideCounting(self.caster)
    return 
  end
  if isUpdate then
    LuaSkillCtrl:UpdateCounting(self.caster, value)
  else
    if self.__roleState ~= RoleState.special or not self.specialAtkCount then
      local maxValue = ((self.caster).recordTable).MaxAttackCount
    end
    LuaSkillCtrl:ShowCounting(self.caster, value, maxValue)
  end
end

bs_105100.CheckAtkAndSplash = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_5 , upvalues : RoleState, AtkState
  if self.__roleState == RoleState.special and self.specialAtkCount <= self.__complateExeCount then
    self:ClearAtkState()
    return 
  end
  if self.state == AtkState.Stop then
    self:CheckAtkNumAndExecute(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    return 
  end
  if self.state == AtkState.Atk then
    self:CheckAndExecuteSplash(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    return 
  end
end

bs_105100.ClearAtkState = function(self)
  -- function num : 0_6 , upvalues : _ENV, AtkState, RoleState
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  self:ShowAttackCounting(0)
  self:CancleCasterWait()
  self.state = AtkState.Stop
  self.__roleState = RoleState.normal
  self.__atkNum = 0
  self.__complateExeCount = 0
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_CD, 0)
end

bs_105100.BeforeEndBattle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  self:ShowAttackCounting(0)
end

bs_105100.CheckAndExecuteSplash = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_8 , upvalues : AtkState
  self.state = AtkState.Splash
  self.__complateExeCount = self.__complateExeCount + 1
  self:ShowAttackCounting(self.specialAtkCount - self.__complateExeCount, true)
  self:InternalSplash(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
end

bs_105100.InternalSplash = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_9 , upvalues : _ENV, AtkState
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.BeatBack) or LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.KnockOff) or LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) or LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.AbandonMove) then
    self.state = AtkState.Stop
    return 
  end
  local targets = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, (self.config).selectRange)
  if targets.Count == 0 then
    self.state = AtkState.Stop
    return 
  end
  local minTier = 999
  local targetRole, targetGrid = nil, nil
  local onFireRole = (self.caster):TryToGetFocusFiringRole()
  if onFireRole == nil then
    for i = 0, targets.Count - 1 do
      local role = (targets[i]).targetRole
      if role.belongNum ~= eBattleRoleBelong.neutral and role:IsUnSelect(self.caster, true) ~= true then
        local grid = LuaSkillCtrl:FindEmptyGridAroundRole(role)
        if grid ~= nil then
          local tier = role:GetBuffTier((self.config).buffId_claw)
          if tier < minTier then
            minTier = tier
            targetRole = role
            targetGrid = grid
          end
        end
      end
    end
  else
    do
      do
        local grid = LuaSkillCtrl:FindEmptyGridAroundRole(onFireRole)
        if grid ~= nil then
          targetRole = onFireRole
          targetGrid = grid
        end
        if targetGrid == nil or targetRole == nil then
          local grid = LuaSkillCtrl:GetGridWithPos((self.caster).x, (self.caster).y)
          if grid ~= nil then
            local roleList = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 1, false)
            if roleList.Count > 0 then
              for i = 0, roleList.Count - 1 do
                local role = roleList[i]
                if role.belongNum == eBattleRoleBelong.enemy and role:IsUnSelect(self.caster, true) ~= true then
                  targetRole = role
                  targetGrid = grid
                end
              end
            end
          end
        end
        do
          if targetGrid == nil or targetRole == nil then
            for i = targets.Count - 1, 0, -1 do
              local role = (targets[i]).targetRole
              if role.belongNum == eBattleRoleBelong.neutral and role:IsUnSelect(self.caster, true) ~= true then
                local grid = LuaSkillCtrl:FindEmptyGridAroundRole(role)
                if grid ~= nil then
                  local tier = role:GetBuffTier((self.config).buffId_claw)
                  if tier < minTier then
                    minTier = tier
                    targetRole = role
                    targetGrid = grid
                  end
                end
              end
            end
          end
          do
            if targetGrid == nil or targetRole == nil then
              self.state = AtkState.Stop
              return 
            end
            LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_up, self)
            local effectGrid = LuaSkillCtrl:GetTargetWithGrid((self.caster).x, (self.caster).y)
            local target = LuaSkillCtrl:GetTargetWithGrid(targetGrid)
            LuaSkillCtrl:SetRolePos(targetGrid, self.caster)
            ;
            (self.caster):LookAtTarget(targetRole)
            LuaSkillCtrl:CallEffect(effectGrid, (self.config).effectId_down, self)
            self.state = AtkState.Stop
            -- DECOMPILER ERROR at PC224: Confused about usage of register: R13 in 'UnsetPending'

            ;
            ((self.caster).recordTable).lastAttackRole = targetRole
            self:CheckAtkAndSplash(targetRole, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
          end
        end
      end
    end
  end
end

bs_105100.CheckAtkNumAndExecute = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_10 , upvalues : AtkState
  self.state = AtkState.Atk
  self:PassiveAttack(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
end

bs_105100.PassiveAttack = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_11 , upvalues : _ENV, AtkState
  if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.StopCommonAttackCD) then
    LuaSkillCtrl:CallResetComAtkCDRatioForRole(self.caster, 100)
  end
  if self.state == AtkState.Atk then
    self:CheckAndExecuteSplash(target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  end
end

bs_105100.OnBreakSkill = function(self, role)
  -- function num : 0_12 , upvalues : base, AtkState, RoleState, _ENV
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.state == AtkState.Stop then
    self:CancleCasterWait()
  end
  if self.__roleState == RoleState.special then
    self.isBeBreak = true
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_CD, 0)
    self:CancleCasterWait()
  end
end

bs_105100.OnCasterDie = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  self:ShowAttackCounting(0)
  ;
  (base.OnCasterDie)(self)
end

return bs_105100

