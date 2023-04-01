-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106500 = class("bs_106500", bs_1)
local base = bs_1
bs_106500.config = {effectId_1 = nil, effectId_2 = nil, effectId_3 = 106501, effectId_hit_ex = 106502, buffId_2 = 106503, action3 = 1020, hurtConfigId = 10, buffId_fly = 106509, radius = 100, arcAngleRange = 60, audioId1 = 106501, time1 = 0, audioId2 = 106502, time2 = 0, audioId_pa = 106504}
bs_106500.config = setmetatable(bs_106500.config, {__index = base.config})
bs_106500.ctor = function(self)
  -- function num : 0_0
end

bs_106500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106500.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : base, _ENV
  if (self.caster):GetBuffTier((self.config).buffId_2) == 0 then
    (base.RealPlaySkill)(self, target, data)
    return 
  end
  self:CallSelectEffect()
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = 1
  local atkActionId = data.action3
  local atkTriggerFrame = 0
  if data.audioId3 ~= nil then
    LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1_ex)
  end
)
  end
  atkSpeedRatio = self:CalcAtkActionSpeed2(atkSpeed, 3)
  atkActionId = data.action3
  atkTriggerFrame = self:GetAtkTriggerFrame2(3, atkSpeed) * (self.config).baseActionSpd
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.caster).recordTable).lastAttackRole = target
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

  if LuaSkillCtrl.IsInTDBattle and (self.caster).belongNum == 2 then
    ((self.caster).recordTable).lastAttackRole = nil
  end
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
  if waitTime > 0 then
    self:CallCasterWait(waitTime + 2)
  end
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger)
  -- DECOMPILER ERROR at PC113: Confused about usage of register: R9 in 'UnsetPending'

  if (self.caster).attackRange == 1 and data.effectId_4 ~= nil and atkActionId == data.action3 then
    ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_4, self, nil, nil, atkSpeedRatio, true)
  end
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_pa)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_2, 1)
end

bs_106500.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_3 , upvalues : _ENV
  if atkActionId == data.action1 or atkActionId == data.action2 then
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local hurt = 1000
      do
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {hurt})
        skillResult:EndResult()
        local onCtrl = LuaSkillCtrl:RoleContainsCtrlBuff(target)
        if onCtrl == true then
          LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnLindHurt, 0, target)
        end
        -- DECOMPILER ERROR at PC54: Confused about usage of register: R9 in 'UnsetPending'

        if ((self.caster).recordTable).completeFirstComatk == nil then
          do
            ((self.caster).recordTable).completeFirstComatk = true
            -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC55: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    else
      self:BreakSkill()
    end
  else
    if LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange, true) then
      local selectTarget = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
      local targetPos = (target.lsObject).localPosition
      local forwardDir = (((CS.TrueSync).TSVector3).Subtract)(targetPos, ((self.caster).lsObject).localPosition)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit_ex, self)
      local ColliderEnter = BindCallback(self, self.OnColliderEnter, forwardDir, targetPos)
      local fireCollider = LuaSkillCtrl:CallGetCircleSkillCollider(self, (self.config).radius, eColliderInfluenceType.Enemy, ColliderEnter)
      fireCollider.lsObject = (CS.LSUnityObject)()
      fireCollider:SetColiderObjPosForce(targetPos)
      LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : _ENV, fireCollider
    LuaSkillCtrl:ClearColliderOrEmission(fireCollider)
  end
)
      -- DECOMPILER ERROR at PC127: Confused about usage of register: R11 in 'UnsetPending'

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

bs_106500.OnColliderEnter = function(self, forwardDir, selectTargetPos, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  local angle = 0
  if not ((entity.lsObject).localPosition):Equals(selectTargetPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, selectTargetPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local forwardDir2D = tsVec2(forwardDir.x, forwardDir.z)
    angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, forwardDir2D)
  end
  do
    if angle > 180 then
      angle = 360 - angle
    end
    if (self.config).arcAngleRange < angle then
      return 
    end
    if self.caster == nil or (self.caster).hp <= 0 then
      return 
    end
    if entity.intensity > 0 and entity.belongNum == eBattleRoleBelong.enemy then
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_fly, 1, 10)
    end
    local onCtrl = LuaSkillCtrl:RoleContainsCtrlBuff(entity)
    if onCtrl == true then
      LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnLindHurt, 1, entity)
    end
  end
end

bs_106500.CalcAtkActionSpeed2 = function(self, atkInterval, atkId)
  -- function num : 0_5
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  if atkInterval < atkTotalFrames then
    return atkTotalFrames / atkInterval
  else
    return 1
  end
end

bs_106500.GetTotalAtkActionFrames2 = function(self, atkId)
  -- function num : 0_6
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  if atkId == 3 then
    return 30
  else
    return 0
  end
end

bs_106500.GetAtkTriggerFrame2 = function(self, atkId, atkInterval)
  -- function num : 0_7
  local srcId = (self.caster).resSrcId
  if srcId == 0 then
    return 0
  end
  local atkTotalFrames = self:GetTotalAtkActionFrames2(atkId)
  local triggerFrameCfg = 0
  if atkId == 3 then
    triggerFrameCfg = 9
  end
  if atkInterval < atkTotalFrames then
    return triggerFrameCfg * atkInterval // atkTotalFrames
  else
    return triggerFrameCfg
  end
end

bs_106500.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106500

