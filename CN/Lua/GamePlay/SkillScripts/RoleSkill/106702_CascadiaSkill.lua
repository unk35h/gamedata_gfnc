-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106702 = class("bs_106702", LuaSkillBase)
local base = LuaSkillBase
bs_106702.config = {start_time = 7, start_time1 = 4, start_time2 = 8, start_timeE = 5, start_time3 = 9, start_time4 = 8, start_time5 = 6, end_time = 14, actionId1_start = 1008, actionId1_loop = 1007, actionId1_end = 1009, action_speed = 1, effectId_loop = 106707, effectId_hit = 106708, HurtConfigId = 30, buffId_196 = 196, buffId_tr = 106702, buffId_lx = 106701}
bs_106702.ctor = function(self)
  -- function num : 0_0
end

bs_106702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106702.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local target = ((self.caster).recordTable).lastAttackRole
  do
    if target == nil or target.hp <= 0 or target.belongNum == eBattleRoleBelong.neutral then
      local tempTarget = self:GetMoveSelectTarget()
      if tempTarget == nil then
        return 
      end
      target = tempTarget.targetRole
    end
    if target ~= nil then
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
      ;
      (self.caster):LookAtTarget(target)
      local skill_time = (self.config).start_time + (self.config).start_time1 + (self.config).start_time2 + (self.config).start_time3 + (self.config).start_time4 + (self.config).start_time5 + (self.config).end_time
      self:CallCasterWait(skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId1_start, (self.config).action_speed, (self.config).start_time, attackTrigger)
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_196, 1, skill_time)
    end
  end
end

bs_106702.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_loop, self)
  self.timeskill = LuaSkillCtrl:StartTimer(self, (self.config).start_time1, function()
    -- function num : 0_3_0 , upvalues : _ENV, target, self
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
    local num = target:GetBuffTier((self.config).buffId_lx)
    local hurt = (self.arglist)[2]
    if num > 0 then
      hurt = hurt + num * (self.arglist)[3]
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {((self.caster).recordTable)["106701_break"], hurt})
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tr, (self.arglist)[4], 1)
    LuaSkillCtrl:StartTimer(self, (self.config).start_time2, function()
      -- function num : 0_3_0_0 , upvalues : _ENV, target, self
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
      local num2 = target:GetBuffTier((self.config).buffId_lx)
      local hurt2 = (self.arglist)[2]
      if num2 > 0 then
        hurt2 = hurt2 + num2 * (self.arglist)[3]
      end
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {((self.caster).recordTable)["106701_break"], hurt2})
      skillResult:EndResult()
      LuaSkillCtrl:StartTimer(self, (self.config).start_time3, function()
        -- function num : 0_3_0_0_0 , upvalues : _ENV, target, self
        LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
        local num3 = target:GetBuffTier((self.config).buffId_lx)
        local hurt3 = (self.arglist)[2]
        if num3 > 0 then
          hurt3 = hurt3 + num3 * (self.arglist)[3]
        end
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {((self.caster).recordTable)["106701_break"], hurt3})
        skillResult:EndResult()
        LuaSkillCtrl:StartTimer(self, (self.config).start_time4, function()
          -- function num : 0_3_0_0_0_0 , upvalues : _ENV, target, self
          LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
          local num4 = target:GetBuffTier((self.config).buffId_lx)
          local hurt4 = (self.arglist)[2]
          if num4 > 0 then
            hurt4 = hurt4 + num4 * (self.arglist)[3]
          end
          local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
          LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {((self.caster).recordTable)["106701_break"], hurt4})
          skillResult:EndResult()
          self:OnSkillDamageEnd()
          LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_tr, (self.arglist)[4], 1)
          LuaSkillCtrl:StartTimer(self, (self.config).start_time5, function()
            -- function num : 0_3_0_0_0_0_0 , upvalues : _ENV, self
            LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId1_end)
            LuaSkillCtrl:StartTimer(nil, (self.config).end_time, function()
              -- function num : 0_3_0_0_0_0_0_0 , upvalues : self
              self:CancleCasterWait()
            end
)
          end
)
        end
)
      end
)
    end
)
  end
)
end

bs_106702.OnBreakSkill = function(self, role)
  -- function num : 0_4 , upvalues : _ENV, base
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_196, 0)
  self:CancleCasterWait()
  ;
  (base.OnBreakSkill)(self, role)
end

bs_106702.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106702

