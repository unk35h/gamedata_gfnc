-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106203 = class("bs_106203", LuaSkillBase)
local base = LuaSkillBase
bs_106203.config = {start_time = 5, end_time = 35, effectId_loop = 106212, effectId_end = 106213, effectId_hit = 106204, configId_trail = 3, buffId1 = 106201, buffId2 = 106202, buffId3 = 106203, hurtConfig = 25, summerId = 62, audioIdStart = 106209, audioIdMovie = 106210, audioIdEnd = 106211}
bs_106203.ctor = function(self)
  -- function num : 0_0
end

bs_106203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106203.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  local skill_time = 80
  self:TryResetMoveState(self.caster)
  local grid = LuaSkillCtrl:GetGridWithRole(self.caster)
  ;
  ((self.caster).lsObject):SetPositionForce(grid.fixLogicPosition)
  self:CallCasterWait(skill_time)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, skill_time, true)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.caster).recordTable).IsInSkill1 = true
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1010)
    local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
    if targetlist.Count > 0 and (targetlist[0]).targetRole ~= nil then
      (self.caster):LookAtTarget((targetlist[0]).targetRole)
    end
  end
)
  local targetGrid = LuaSkillCtrl:GetGridWithPos(selectTargetCoord.x, selectTargetCoord.y)
  if targetGrid ~= nil then
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    self:TryResetMoveState(self.caster)
    LuaSkillCtrl:SetRolePos(targetGrid, self.caster)
  end
  local starttime = (self.arglist)[1] - 1
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 6, 10)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= nil and ((targetlist[i]).targetRole).roleDataId == (self.config).summerId then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId2, 1)
      end
    end
  end
  do
    self.skillLoop = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_loop, self, nil, nil, nil, true)
    LuaSkillCtrl:StartTimer(self, 25, function()
    -- function num : 0_2_1 , upvalues : _ENV, self
    LuaSkillCtrl:CallRoleAction(self.caster, 1006)
  end
)
    self.beginTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1] + 1, function()
    -- function num : 0_2_2 , upvalues : self
    self:beginAttack()
  end
, self, -1, starttime)
    self.time = LuaSkillCtrl:StartTimer(self, (self.arglist)[3], function()
    -- function num : 0_2_3 , upvalues : self
    if self.beginTimer ~= nil then
      (self.beginTimer):Stop()
      self.beginTimer = nil
    end
    self:endAttack()
  end
)
  end
end

bs_106203.beginAttack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetlist = LuaSkillCtrl:CallTargetSelectWithRange(self, 9, 1)
  if targetlist.Count > 0 then
    for i = 0, targetlist.Count - 1 do
      if (targetlist[i]).targetRole ~= nil then
        LuaSkillCtrl:CallBuff(self, (targetlist[i]).targetRole, (self.config).buffId3, 1)
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetlist[i]).targetRole)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[2]})
        skillResult:EndResult()
        LuaSkillCtrl:CallEffect((targetlist[i]).targetRole, (self.config).effectId_hit, self)
      end
    end
  end
end

bs_106203.endAttack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).IsInSkill1 = false
  LuaSkillCtrl:StartTimer(self, 20, function()
    -- function num : 0_4_0 , upvalues : self
    self:CancleCasterWait()
  end
)
end

bs_106203.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1.5)
end

bs_106203.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_106203.OnSkipUltView = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_106203.OnMovieFadeOut = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_106203.OnCasterDie = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnCasterDie)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  if self.skillend ~= nil then
    (self.skillend):Die()
    self.skillend = nil
  end
end

bs_106203.LuaDispose = function(self)
  -- function num : 0_10 , upvalues : base
  (base.LuaDispose)(self)
  if self.skillLoop ~= nil then
    (self.skillLoop):Die()
    self.skillLoop = nil
  end
  if self.beginTimer ~= nil then
    (self.beginTimer):Stop()
    self.beginTimer = nil
  end
  if self.time ~= nil then
    (self.time):Stop()
    self.time = nil
  end
  if self.skillend ~= nil then
    (self.skillend):Die()
    self.skillend = nil
  end
end

return bs_106203

