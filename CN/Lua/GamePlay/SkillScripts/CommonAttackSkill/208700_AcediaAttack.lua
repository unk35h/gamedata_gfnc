-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208700 = class("bs_208700", bs_1)
local base = bs_1
bs_208700.config = {action1 = 1001, action2 = 1004, action3 = 1020, effectId_ex = 208704, effectId_1 = 208701, effectId_2 = 208702, effectId_hitp = 208703, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0}
}
bs_208700.config = setmetatable(bs_208700.config, {__index = base.config})
bs_208700.ctor = function(self)
  -- function num : 0_0
end

bs_208700.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208700.RealPlaySkill = function(self, target, data)
  -- function num : 0_2 , upvalues : _ENV
  self:CallSelectEffect()
  local atkSpeed = LuaSkillCtrl:CallFormulaNumber(9997, self.caster, self.caster)
  local atkSpeedRatio = 1
  local atkActionId = data.action1
  local atkTriggerFrame = 0
  local roll = ((self.caster).recordTable)["208701_Roll"]
  if roll == nil then
    roll = 0
  end
  local roll_attack = false
  if LuaSkillCtrl:CallRange(1, 1000) <= roll then
    roll_attack = true
    atkSpeedRatio = 1
    atkActionId = data.action3
    atkTriggerFrame = 9
  else
    local prob = LuaSkillCtrl:CallRange(1, 2)
    if prob == 1 then
      if data.audioId2 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time2, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId2)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1)
      atkActionId = data.action1
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed) * (self.config).baseActionSpd
    else
      if data.audioId1 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_2_1 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1)
      atkActionId = data.action2
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed) * (self.config).baseActionSpd
    end
  end
  do
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRole = target
    -- DECOMPILER ERROR at PC95: Confused about usage of register: R9 in 'UnsetPending'

    if LuaSkillCtrl.IsInTDBattle and (self.caster).belongNum == 2 then
      ((self.caster).recordTable).lastAttackRole = nil
    end
    local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame, roll_attack)
    local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
    if waitTime > 0 then
      self:CallCasterWait(waitTime + 2)
    end
    LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger)
    -- DECOMPILER ERROR at PC146: Confused about usage of register: R11 in 'UnsetPending'

    if (self.caster).attackRange == 1 then
      if roll_attack then
        ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_ex, self, nil, nil, atkSpeedRatio, true)
      else
        -- DECOMPILER ERROR at PC165: Confused about usage of register: R11 in 'UnsetPending'

        if data.effectId_1 ~= nil then
          if atkActionId == data.action1 then
            ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_1, self, nil, nil, atkSpeedRatio, true)
          else
            -- DECOMPILER ERROR at PC178: Confused about usage of register: R11 in 'UnsetPending'

            ;
            ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_2, self, nil, nil, atkSpeedRatio, true)
          end
        end
      end
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

bs_208700.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame, roll_attack)
  -- function num : 0_3 , upvalues : _ENV, base
  if roll_attack then
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hitp, self)
    local hurtjc = ((self.caster).recordTable)["208701_arg2"]
    do
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurtjc})
      skillResult:EndResult()
      LuaSkillCtrl:StartTimer(self, 4, function()
    -- function num : 0_3_0 , upvalues : _ENV, target, self, hurtjc
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hitp, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurtjc})
    skillResult:EndResult()
  end
)
      LuaSkillCtrl:StartTimer(self, 8, function()
    -- function num : 0_3_1 , upvalues : _ENV, target, self, hurtjc
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hitp, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurtjc})
    skillResult:EndResult()
  end
)
      LuaSkillCtrl:StartTimer(self, 16, function()
    -- function num : 0_3_2 , upvalues : _ENV, target, self, hurtjc
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hitp, self)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurtjc})
    skillResult:EndResult()
  end
)
    end
  else
    do
      ;
      (base.OnAttackTrigger)(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
    end
  end
end

bs_208700.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208700

