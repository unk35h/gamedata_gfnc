-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210802 = class("bs_210802", LuaSkillBase)
local base = LuaSkillBase
bs_210802.config = {buffId_lockCd = 170, buffId_power = 210801, buffId_def = 210802, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, action_speed = 1, actionId_start_time = 13, actionId_end_time = 25, heal_resultId = 3, effect_heal = 210806, effect_end = 210807}
bs_210802.ctor = function(self)
  -- function num : 0_0
end

bs_210802.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.loopTime = (self.arglist)[1]
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).buff_num = 0
  self.OnCastSkill = false
end

bs_210802.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:OnSkillTake()
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, data)
  local time = (self.config).actionId_start_time + (self.config).actionId_end_time + self.loopTime
  local time1 = (self.config).actionId_start_time + self.loopTime
  self:CallCasterWait(time)
  self.OnCastSkill = true
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
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_end, self)
    self.OnCastSkill = false
  end
, nil)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, time1, true)
end

bs_210802.OnAttackTrigger = function(self, data)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:StartShowSkillDurationTime(self, self.loopTime)
  self.effect_atk = LuaSkillCtrl:CallEffect(self.caster, (self.config).effect_heal, self)
  self.atk = LuaSkillCtrl:StartTimer(self, 15, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local targetList = LuaSkillCtrl:FindRolesAroundRole(self.caster)
    if targetList ~= nil and targetList.Count > 0 then
      for i = targetList.Count - 1, 0, -1 do
        local role = targetList[i]
        if role ~= nil and role.hp > 0 and role.belongNum == (self.caster).belongNum then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_power, 1, (self.arglist)[3])
          -- DECOMPILER ERROR at PC41: Confused about usage of register: R6 in 'UnsetPending'

          ;
          ((self.caster).recordTable).buff_num = ((self.caster).recordTable).buff_num + 1
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
          LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[2]})
          skillResult:EndResult()
        end
      end
    end
  end
, nil, -1, 10)
end

bs_210802.OnBreakSkill = function(self, role)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.OnBreakSkill)(self, role)
  if role == self.caster and self.OnCastSkill == true then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_def, 1)
    local hpRate = (self.arglist)[5]
    local damage = role._curHp * hpRate // 1000
    LuaSkillCtrl:RemoveLife(damage, self, self.caster, true, nil, true, true)
    local skills = role:GetBattleSkillList()
    if skills ~= nil then
      local skillCount = skills.Count
      if skillCount > 0 then
        for j = 0, skillCount - 1 do
          local curTotalCd = (skills[j]).totalCDTime * -1 * (self.arglist)[6] // 1000
          if not (skills[j]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[j], curTotalCd)
          end
        end
      end
    end
    do
      do
        LuaSkillCtrl:StopShowSkillDurationTime(self)
        if self.effect_atk ~= nil then
          (self.effect_atk):Die()
          self.effect_atk = nil
        end
        self:CancleCasterWait()
        self.OnCastSkill = false
      end
    end
  end
end

bs_210802.OnCasterDie = function(self)
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

bs_210802.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.effect_atk = nil
  ;
  (base.LuaDispose)(self)
end

return bs_210802

