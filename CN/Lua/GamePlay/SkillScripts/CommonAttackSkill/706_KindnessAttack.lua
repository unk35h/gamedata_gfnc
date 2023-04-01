-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_706 = class("bs_706", bs_1)
local base = bs_1
bs_706.config = {effectId_1 = 10440, effectId_2 = 10441, effectId_sign = 210201, audioId1 = 314, audioId2 = 315, audioId3 = 360}
bs_706.config = setmetatable(bs_706.config, {__index = base.config})
bs_706.ctor = function(self)
  -- function num : 0_0
end

bs_706.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_706", 1, self.OnAfterBattleStart)
end

bs_706.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_sign, self)
end

bs_706.RealPlaySkill = function(self, target, data)
  -- function num : 0_3 , upvalues : _ENV
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
    -- function num : 0_3_0 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId2)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 2) * (self.config).baseActionSpd
      atkActionId = data.action2
      -- DECOMPILER ERROR at PC40: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).attack_id = 2
      atkTriggerFrame = self:GetAtkTriggerFrame(2, atkSpeed)
      self.attackNum = 0
    else
      if data.audioId1 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_3_1 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1)
      atkActionId = data.action1
      -- DECOMPILER ERROR at PC65: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.caster).recordTable).attack_id = 1
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed) * (self.config).baseActionSpd
      self.attackNum = self.attackNum + 1
    end
  else
    do
      if data.audioId1 ~= nil then
        LuaSkillCtrl:StartTimer(self, data.time1, function()
    -- function num : 0_3_2 , upvalues : _ENV, self, data
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId1)
  end
)
      end
      atkSpeedRatio = self:CalcAtkActionSpeed(atkSpeed, 1) * (self.config).baseActionSpd
      atkTriggerFrame = self:GetAtkTriggerFrame(1, atkSpeed)
      atkActionId = data.action1
      -- DECOMPILER ERROR at PC101: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.caster).recordTable).attack_id = 1
      self.attackNum = self.attackNum + 1
      -- DECOMPILER ERROR at PC107: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.caster).recordTable).lastAttackRole = target
      -- DECOMPILER ERROR at PC118: Confused about usage of register: R7 in 'UnsetPending'

      if LuaSkillCtrl.IsInTDBattle and (self.caster).belongNum == 2 then
        ((self.caster).recordTable).lastAttackRole = nil
      end
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
      local waitTime = atkSpeed - 1 - (self.rotateWaited and 3 or 0)
      if waitTime > 0 then
        self:CallCasterWait(waitTime + 2)
      end
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, atkActionId, atkSpeedRatio, atkTriggerFrame, attackTrigger)
      -- DECOMPILER ERROR at PC172: Confused about usage of register: R9 in 'UnsetPending'

      if (self.caster).attackRange == 1 then
        if data.effectId_1 ~= nil then
          if atkActionId == data.action1 then
            ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_1, self, nil, nil, atkSpeedRatio, true)
          else
            -- DECOMPILER ERROR at PC185: Confused about usage of register: R9 in 'UnsetPending'

            ;
            ((self.caster).recordTable)["1_attack_effect"] = LuaSkillCtrl:CallEffect(target, data.effectId_2, self, nil, nil, atkSpeedRatio, true)
          end
        end
        if data.effectId_3 ~= nil then
          LuaSkillCtrl:StartTimer(self, atkTriggerFrame, function()
    -- function num : 0_3_3 , upvalues : _ENV, target, data, self, atkSpeedRatio
    LuaSkillCtrl:CallEffect(target, data.effectId_3, self, nil, nil, atkSpeedRatio)
  end
)
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
end

bs_706.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_706

