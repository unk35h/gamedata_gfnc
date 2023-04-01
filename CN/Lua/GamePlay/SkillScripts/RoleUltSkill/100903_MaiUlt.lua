-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100903 = class("bs_100903", LuaSkillBase)
local base = LuaSkillBase
bs_100903.config = {effectId_storm = 1009031, effectId_hit = 1009032, actionId_start = 1005, skilltime = 15, movieEndRoleAction = 1006, actionId_loop = 1010, actionId_end = 1006, end_time = 10, act_speed = 1, audioIdStart = 100906, audioIdMovie = 100907, audioIdLoop = 100909, stormRate = 6, buffId_skillmode = 1009031, buffId_blind = 3012, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_100903.ctor = function(self)
  -- function num : 0_0
end

bs_100903.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.time = 1
end

bs_100903.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(999)
  if selectTargetCoord ~= nil then
    local inputCoord = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    ;
    (self.caster):LookAtTarget(inputCoord)
    self:CallSkillExecute(inputCoord)
  end
end

bs_100903.CallSkillExecute = function(self, inputCoord)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_skillmode, 1, (self.arglist)[1], true)
  local stormData = {
roleMarks = {}
, 
arrivedRoles = {}
}
  if inputCoord ~= nil then
    local targetGrid = LuaSkillCtrl:GetTargetWithGrid(inputCoord.x, inputCoord.y)
    self.stormEffect = LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_storm, self, nil, nil, nil, false)
    local collisionEnter = BindCallback(self, self.OnCollisionEnter, stormData)
    local collisionExit = BindCallback(self, self.OnCollisionExit, stormData)
    local stormCollider = LuaSkillCtrl:CallAddCircleColliderForEffect(self.stormEffect, 100, eColliderInfluenceType.Enemy, nil, collisionEnter, collisionExit)
    local times = (self.arglist)[1] // (self.config).stormRate
    local duration = (self.config).stormRate
    local stormshock = BindCallback(self, self.StormShock, stormData, targetGrid)
    LuaSkillCtrl:StartTimer(self, duration, stormshock, nil, times - 1, duration)
    local stormEndAction = BindCallback(self, self.StormEndAction, stormCollider)
    LuaSkillCtrl:StartTimer(self, (self.arglist)[1], stormEndAction)
  end
end

bs_100903.OnCollisionEnter = function(self, stormData, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if (stormData.roleMarks)[entity] == nil then
    (table.insert)(stormData.arrivedRoles, entity)
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (stormData.roleMarks)[entity] = true
  end
end

bs_100903.OnCollisionExit = function(self, stormData, collider, entity)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  if (stormData.roleMarks)[entity] then
    (stormData.roleMarks)[entity] = nil
    ;
    (table.removebyvalue)(stormData.arrivedRoles, entity)
  end
end

bs_100903.StormShock = function(self, stormData, targetGrid)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(targetGrid, (self.config).effectId_storm, self, nil, nil, nil, false)
  for i = 1, #stormData.arrivedRoles do
    local target = (stormData.arrivedRoles)[i]
    if target ~= nil and target.hp > 0 then
      if target.intensity ~= 0 then
        LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_blind, 1, (self.config).stormRate)
      end
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[2]})
      skillResult:EndResult()
      local down = -(self.arglist)[3]
      LuaSkillCtrl:CallResetCDNumForRole(target, down)
    end
  end
end

bs_100903.StormEndAction = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self:SkillEnd()
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  self.isStormEnd = true
  self.endActionTimmer = LuaSkillCtrl:StartTimer(nil, (self.config).end_time, function()
    -- function num : 0_7_0 , upvalues : self
    self:CancleCasterWait()
    self.isStormEnd = nil
  end
)
end

bs_100903.SkillEnd = function(self)
  -- function num : 0_8 , upvalues : _ENV
  LuaSkillCtrl:StopShowSkillDurationTime(self)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_skillmode, 1, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buff_lockcd, 0, true)
  if self.stormEffect ~= nil then
    (self.stormEffect):Die()
    self.stormEffect = nil
  end
end

bs_100903.OnBreakSkill = function(self, role)
  -- function num : 0_9 , upvalues : base
  if role == self.caster then
    self:SkillEnd()
    if not self.isStormEnd then
      self:CancleCasterWait()
      self.isStormEnd = nil
    end
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_100903.OnUltRoleAction = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_100903.PlayUltEffect = function(self)
  -- function num : 0_11 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_100903.OnSkipUltView = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_100903.OnMovieFadeOut = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_100903.OnCasterDie = function(self)
  -- function num : 0_14 , upvalues : base
  self:SkillEnd()
  if self.endActionTimmer ~= nil then
    (self.endActionTimmer):Stop()
    self.endActionTimmer = nil
  end
  self:CancleCasterWait()
  ;
  (base.OnCasterDie)(self)
end

bs_100903.LuaDispose = function(self)
  -- function num : 0_15 , upvalues : base
  self.time = nil
  self.stormEffect = nil
  self.isStormEnd = nil
  ;
  (base.LuaDispose)(self)
end

return bs_100903

