-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104201 = class("bs_104201", LuaSkillBase)
local base = LuaSkillBase
bs_104201.config = {selectId = 10002, MoveBuffId = 104201, start_time = 10, end_time = 18, actionId_speed = 1.5, actionId = 1008, actionId_end = 1009, effectId_start = 104203, effectId_move = 104204, effectId_end = 104205, effectId_hit1 = 104207, effectId_buffDie = 104215, effectId_start_passive = 104218, buffId_fit = 130, buffId_god = 3009, buffId_yinshen = 3016, buffId_CD = 170, buffId_attackCD = 104205, buffId_tag = 104204, nanaka_buffId = 102603, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, 
HurtConfig_aoe = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, returndamage_formula = 0}
, 
heal_config = {baseheal_formula = 3022}
, audioId_hit = 104206, audioId_loop = 104204}
bs_104201.ctor = function(self)
  -- function num : 0_0
end

bs_104201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  self.passive = false
  self.passive_effect = false
  ;
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_104201_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.SetDeadHurt, "bs_104201_3", 1, self.OnSetDeadHurt)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_104201_11", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_104201_4", 1, self.BeforeEndBattle)
end

bs_104201.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) ~= true then
    self:RealMove()
  end
end

bs_104201.OnSetDeadHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target == self.caster and self.passive == false and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 then
    self.passive = true
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_god, 1, 2)
    LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[3]})
    skillResult:EndResult()
  end
)
    if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) ~= true then
      self.passive_effect = true
      self:RealMove()
    end
  end
end

bs_104201.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_4 , upvalues : _ENV
  if role:GetBuffTier((self.config).buffId_tag) > 0 then
    LuaSkillCtrl:DispelBuff(role, (self.config).buffId_tag, 1)
    if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) ~= true then
      LuaSkillCtrl:CallEffect(role, (self.config).effectId_buffDie, self)
      self:RealMove()
    end
  end
end

bs_104201.RealMove = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, 10))
  local targetList_old = nil
  local target_one = nil
  if targetList_old.Count > 0 then
    target_one = (targetList_old[0]).targetRole
  end
  self:CallCasterWait((self.config).start_time + 150)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).start_time + 3, true)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, target_one)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId, (self.config).action_speed)
  LuaSkillCtrl:StartTimer(nil, (self.config).start_time, attackTrigger)
  local startEfcTarget = LuaSkillCtrl:GetTargetWithGrid((self.caster).x, (self.caster).y)
  if self.passive_effect == true then
    LuaSkillCtrl:CallEffect(startEfcTarget, (self.config).effectId_start_passive, self)
    self.passive_effect = false
  else
    LuaSkillCtrl:CallEffect(startEfcTarget, (self.config).effectId_start, self)
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_yinshen, 1, 15)
end

bs_104201.OnAttackTrigger = function(self, target_one)
  -- function num : 0_6 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) then
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
    return 
  end
  if target_one ~= nil and target_one.hp > 0 then
    local grid = LuaSkillCtrl:FindEmptyGridWithinRange(target_one, 1)
    if grid ~= nil then
      local MoveTime = LuaSkillCtrl:GetGridsDistance(grid.x, grid.y, (self.caster).x, (self.caster).y)
      do
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).end_time + MoveTime, true)
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
        LuaSkillCtrl:CallPhaseMove(self, self.caster, grid.x, grid.y, MoveTime, (self.config).MoveBuffId)
        local move_effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_move, self)
        self.move_audio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_loop)
        LuaSkillCtrl:StartTimer(nil, MoveTime * 3, function()
    -- function num : 0_6_0 , upvalues : move_effect
    if move_effect ~= nil then
      move_effect:Die()
      move_effect = nil
    end
  end
)
        LuaSkillCtrl:StartTimer(nil, MoveTime, function()
    -- function num : 0_6_1 , upvalues : self, _ENV
    self:GoUp()
    if self.move_audio ~= nil then
      LuaSkillCtrl:StopAudioByBack(self.move_audio)
      self.move_audio = nil
    end
  end
)
        return 
      end
    end
  end
  do
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).selectId, 10)
    do
      if targetList.Count > 0 then
        local target_move = (targetList[0]).targetRole
        local grid = LuaSkillCtrl:FindEmptyGridWithinRange(target_move, 1)
        if grid == nil then
          if targetList.Count > 1 then
            for i = 0, targetList.Count - 1 do
              local role = (targetList[i]).targetRole
              grid = LuaSkillCtrl:FindEmptyGridWithinRange(role, 1)
              if grid ~= nil then
                target_move = (targetList[i]).targetRole
                break
              end
            end
          end
          do
            if targetList.Count == 1 then
              if LuaSkillCtrl:IsRoleAdjacent(self.caster, target_move) ~= true then
                local grid_list = LuaSkillCtrl:FindEmptyGridsWithinRange(target_move.x, target_move.y, 5)
                if grid_list ~= nil and grid_list.Count > 0 then
                  grid = grid_list[0]
                end
              else
                do
                  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).end_time, true)
                  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
                  self:GoUp()
                  if grid == nil then
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).end_time, true)
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
                    self:GoUp()
                  end
                  if grid ~= nil then
                    local MoveTime = LuaSkillCtrl:GetGridsDistance(grid.x, grid.y, (self.caster).x, (self.caster).y)
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).end_time + MoveTime, true)
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
                    LuaSkillCtrl:CallPhaseMove(self, self.caster, grid.x, grid.y, MoveTime, (self.config).MoveBuffId)
                    local move_effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_move, self)
                    self.move_audio = LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_loop)
                    LuaSkillCtrl:StartTimer(nil, MoveTime * 3, function()
    -- function num : 0_6_2 , upvalues : move_effect
    if move_effect ~= nil then
      move_effect:Die()
      move_effect = nil
    end
  end
)
                    LuaSkillCtrl:StartTimer(nil, MoveTime, function()
    -- function num : 0_6_3 , upvalues : self, _ENV
    self:GoUp()
    if self.move_audio ~= nil then
      LuaSkillCtrl:StopAudioByBack(self.move_audio)
      self.move_audio = nil
    end
  end
)
                  end
                  do
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_CD, 1, (self.config).end_time, true)
                    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_attackCD, 1, (self.config).end_time, true)
                    self:GoUp()
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

bs_104201.GoUp = function(self)
  -- function num : 0_7 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, (self.config).end_time + 2, function()
    -- function num : 0_7_0 , upvalues : self
    self:CancleCasterWait()
  end
)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end, 1)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_end, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).Aoe)
  for i = 0, (skillResult.roleList).Count - 1 do
    local role = (skillResult.roleList)[i]
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_fit, 1, (self.arglist)[1])
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit1, self)
  end
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig_aoe, {(self.arglist)[2]})
  skillResult:EndResult()
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
end

bs_104201.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if self.move_audio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.move_audio)
    self.move_audio = nil
  end
end

bs_104201.BeforeEndBattle = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.move_audio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.move_audio)
    self.move_audio = nil
  end
end

bs_104201.OnBreakSkill = function(self, role)
  -- function num : 0_10 , upvalues : base
  if role == self.caster then
    self:CancleCasterWait()
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_104201.LuaDispose = function(self)
  -- function num : 0_11 , upvalues : base
  (base.LuaDispose)(self)
  self.move_audio = nil
end

return bs_104201

