-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207801 = class("bs_207801", LuaSkillBase)
local base = LuaSkillBase
bs_207801.config = {skill_time = 25, start_time = 25, start_time2 = 4, dd_time = 3, hdRate = 30, actionId_attack3 = 1025, actionId_start = 1008, actionId_loop = 1007, actionId_end = 1009, action_speed = 1, buffId_1 = 207801, buffIdHD = 207802, effectId_skill = 10779, effectId_bnfffire = 100307, effectId_trail2 = 207803, effectId_bd = 207805, buffId_170 = 3008, audioId = 207803}
bs_207801.ctor = function(self)
  -- function num : 0_0
end

bs_207801.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_207801_3", 1, self.OnAfterHurt, self.caster)
  self:AddAfterBuffRemoveTrigger("bs_207801_4", 1, self.AfterBuffRemove, self.caster, nil, (self.config).buffId_1, nil)
end

bs_207801.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local buff_time = (self.config).skill_time + (self.arglist)[1] + 28
  local noAttack_time = buff_time + 30
  self:CallCasterWait(noAttack_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, 1, buff_time, true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, buff_time, true)
end

bs_207801.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local buff_time1 = (self.arglist)[1] + 28
  local arg1 = ((self.caster).recordTable).skill_intensity_up
  local arg2 = ((self.caster).recordTable).maxHp
  LuaSkillCtrl:StartShowSkillDurationTime(self, buff_time1)
  local value1 = (self.caster).skill_intensity * arg1 // 1000
  local value2 = (self.caster).maxHp * arg2 // 1000
  local value3 = value1 + value2
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
  local times = (self.arglist)[1] // (self.config).hdRate
  LuaSkillCtrl:StartTimer(self, (self.config).hdRate, function()
    -- function num : 0_3_0 , upvalues : _ENV, self, value3
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_attack3)
    LuaSkillCtrl:StartTimer(self, (self.config).start_time2, function()
      -- function num : 0_3_0_0 , upvalues : value3, _ENV, self
      if value3 > 0 then
        LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.normal, value3)
        local buff = LuaSkillCtrl:GetRoleBuffById(self.caster, (self.config).buffIdHD)
        if buff == nil then
          LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdHD, 1, nil, true)
        end
      end
      do
        local targetListAll = LuaSkillCtrl:CallTargetSelect(self, 2, 10)
        if targetListAll.Count >= 3 then
          (self.caster):LookAtTarget((targetListAll[0]).targetRole)
          LuaSkillCtrl:StartTimer(self, 6, function()
        -- function num : 0_3_0_0_0 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        LuaSkillCtrl:CallEffect((targetListAll[0]).targetRole, (self.config).effectId_trail2, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_0_0 , upvalues : value3, _ENV, targetListAll, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[0]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[0]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[0]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
      end
)
          LuaSkillCtrl:StartTimer(self, 8, function()
        -- function num : 0_3_0_0_1 , upvalues : self, targetListAll
        (self.caster):LookAtTarget((targetListAll[1]).targetRole)
      end
)
          LuaSkillCtrl:StartTimer(self, 11, function()
        -- function num : 0_3_0_0_2 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        LuaSkillCtrl:CallEffect((targetListAll[1]).targetRole, (self.config).effectId_trail2, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_2_0 , upvalues : value3, _ENV, targetListAll, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[1]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[1]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[1]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
      end
)
          LuaSkillCtrl:StartTimer(self, 16, function()
        -- function num : 0_3_0_0_3 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        for i = 2, targetListAll.Count - 1 do
          do
            LuaSkillCtrl:CallEffect((targetListAll[i]).targetRole, (self.config).effectId_trail2, self)
            LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_3_0 , upvalues : value3, _ENV, targetListAll, i, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[i]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[i]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[i]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
          end
        end
      end
)
        end
        if targetListAll.Count == 2 then
          (self.caster):LookAtTarget((targetListAll[0]).targetRole)
          LuaSkillCtrl:StartTimer(self, 6, function()
        -- function num : 0_3_0_0_4 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        LuaSkillCtrl:CallEffect((targetListAll[0]).targetRole, (self.config).effectId_trail2, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_4_0 , upvalues : value3, _ENV, targetListAll, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[0]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[0]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[0]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
      end
)
          LuaSkillCtrl:StartTimer(self, 8, function()
        -- function num : 0_3_0_0_5 , upvalues : self, targetListAll
        (self.caster):LookAtTarget((targetListAll[1]).targetRole)
      end
)
          LuaSkillCtrl:StartTimer(self, 11, function()
        -- function num : 0_3_0_0_6 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        LuaSkillCtrl:CallEffect((targetListAll[1]).targetRole, (self.config).effectId_trail2, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_6_0 , upvalues : value3, _ENV, targetListAll, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[1]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[1]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[1]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
      end
)
          LuaSkillCtrl:StartTimer(self, 13, function()
        -- function num : 0_3_0_0_7 , upvalues : _ENV, self
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
      end
)
        end
        if targetListAll.Count == 1 then
          (self.caster):LookAtTarget((targetListAll[0]).targetRole)
          LuaSkillCtrl:StartTimer(self, 6, function()
        -- function num : 0_3_0_0_8 , upvalues : _ENV, self, targetListAll, value3
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_bd, self)
        LuaSkillCtrl:CallEffect((targetListAll[0]).targetRole, (self.config).effectId_trail2, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).dd_time, function()
          -- function num : 0_3_0_0_8_0 , upvalues : value3, _ENV, targetListAll, self
          if value3 > 0 then
            LuaSkillCtrl:AddRoleShield((targetListAll[0]).targetRole, eShieldType.normal, value3)
            local buff = LuaSkillCtrl:GetRoleBuffById((targetListAll[0]).targetRole, (self.config).buffIdHD)
            if buff == nil then
              LuaSkillCtrl:CallBuff(self, (targetListAll[0]).targetRole, (self.config).buffIdHD, 1, nil, true)
            end
          end
        end
)
      end
)
          LuaSkillCtrl:StartTimer(self, 8, function()
        -- function num : 0_3_0_0_9 , upvalues : _ENV, self
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
      end
)
        end
        if targetListAll.Count == 0 then
          LuaSkillCtrl:StartTimer(self, 3, function()
        -- function num : 0_3_0_0_10 , upvalues : _ENV, self
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_loop)
      end
)
        end
      end
    end
)
  end
, nil, times - 1, (self.config).hdRate)
end

bs_207801.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  LuaSkillCtrl:StartTimer(self, 28, function()
    -- function num : 0_4_0 , upvalues : self
    self:CancleCasterWait()
  end
)
end

bs_207801.Onover = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  self:CancleCasterWait()
  LuaSkillCtrl:CallRoleAction(self.caster, 100)
end

bs_207801.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207801

