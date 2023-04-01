-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106202 = class("bs_106202", LuaSkillBase)
local base = LuaSkillBase
bs_106202.config = {effectId_skill = 106211, effectId_hit = 106208, hurtConfig = 25, hurtConfig2 = 24, skill_time = 23, skill_time2 = 27, start_time = 7, start_time2 = 5, actionId = 1105, actionId2 = 1056, action_speed = 1, skill_selectId = 1001, audioId1 = 234, audioId2 = 235, buffId1 = 106201, buffId2 = 106203, buffId_170 = 170}
bs_106202.ctor = function(self)
  -- function num : 0_0
end

bs_106202.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106202.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.caster).recordTable).IsInSkill1 = true
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    target = last_target
  else
    local moveTarget = self:GetMoveSelectTarget()
    if moveTarget ~= nil then
      target = moveTarget.targetRole
    end
  end
  do
    if target ~= nil then
      local attackTrigger = BindCallback(self, self.OnAttackTrigger, target)
      ;
      (self.caster):LookAtTarget(target)
      self:CallCasterWait((self.config).skill_time)
      LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId2, (self.config).action_speed, (self.config).start_time2, attackTrigger)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId_skill, self)
      local targetGrid = LuaSkillCtrl:GetTargetWithGrid(target.x, target.y)
      LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_hit, self)
      LuaSkillCtrl:StartTimer(self, (self.config).start_time2 - 2, function()
    -- function num : 0_2_0 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId2, 1, 1)
  end
)
      LuaSkillCtrl:StartTimer(self, (self.config).start_time2 - 1, function()
    -- function num : 0_2_1 , upvalues : _ENV, self, target
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId2, 1, 1)
  end
)
      LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnJiangyuSkill, target)
    end
  end
end

bs_106202.OnAttackTrigger = function(self, target)
  -- function num : 0_3 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId1) >= 4 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[3]})
    skillResult:EndResult()
  else
    do
      do
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]})
        skillResult:EndResult()
        self:OnSkillDamageEnd()
        -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

        ;
        ((self.caster).recordTable).IsInSkill1 = false
      end
    end
  end
end

bs_106202.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106202

