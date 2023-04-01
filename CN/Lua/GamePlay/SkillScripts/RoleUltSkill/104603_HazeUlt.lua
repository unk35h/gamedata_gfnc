-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104603 = class("bs_104603", LuaSkillBase)
local base = LuaSkillBase
bs_104603.config = {effectId_start = 104609, effectId_start3 = 104615, effectId_hit = 104610, effectId_speed = 1, actionId_start = 1005, actionId_end = 1006, actionId_shoot = 1010, audioIdStart = 104608, audioIdMovie = 104609, audioIdEnd = 104610, buffId_DaiyanUlt = 1046031, buffId_inspire = 1046021, action_time = 8, attack_wait = 15, attack_times = 5, collider_go = 0, start_time = 12, end_time = 9, select_id = 9, select_range = 20, configId = 2}
bs_104603.ctor = function(self)
  -- function num : 0_0
end

bs_104603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.ultmode = 0
end

bs_104603.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  if selectTargetCoord ~= nil then
    self.ultmode = 1
    local inputdirection = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    ;
    (self.caster):LookAtTarget(inputdirection)
    self:CallSkillExecute(inputdirection)
  end
end

bs_104603.CallSkillExecute = function(self, direction)
  -- function num : 0_3 , upvalues : _ENV
  local Time = (self.arglist)[3] + (self.config).start_time + (self.config).end_time
  self:CallCasterWait(Time + 5)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_DaiyanUlt, 1, Time, true)
  local maxTimes = (self.arglist)[3] // 15 + 1
  local ShootWaveAction = BindCallback(self, self.ShootWaveAction, maxTimes, direction)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_shoot)
  LuaSkillCtrl:StartTimer(self, (self.config).start_time, ShootWaveAction)
end

bs_104603.ShootWaveAction = function(self, maxTimes, grid)
  -- function num : 0_4 , upvalues : _ENV
  local ShootWave = BindCallback(self, self.ShootWave, grid)
  LuaSkillCtrl:StartTimer(self, (self.config).attack_wait, ShootWave, nil, maxTimes - 1, (self.config).attack_wait)
  local Over = BindCallback(self, self.OnOver)
  LuaSkillCtrl:StartTimer(nil, (self.arglist)[3], Over)
end

bs_104603.ShootWave = function(self, grid)
  -- function num : 0_5 , upvalues : _ENV
  if grid == nil then
    return 
  end
  LuaSkillCtrl:CallEffect(grid, (self.config).effectId_start, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_inspire, 1, (self.arglist)[2])
  local gridPos = grid:GetLogicPos()
  local shootDir = ((((CS.TrueSync).TSVector3).Subtract)(gridPos, ((self.caster).lsObject).localPosition)).normalized
  local shootDir2D = ((CS.TrueSync).TSVector2)(shootDir.x, shootDir.z)
  local OnCollition = BindCallback(self, self.OnCollision, shootDir2D)
  LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, grid, 70, 7, 14, OnCollition, nil, nil, nil, true, true)
end

bs_104603.OnOver = function(self)
  -- function num : 0_6 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_DaiyanUlt, 1, true, true)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
end

bs_104603.OnCollision = function(self, shootDir2d, collider, index, entity)
  -- function num : 0_7 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 or entity == nil or entity.hp <= 0 then
    return 
  end
  if LuaSkillCtrl:IsFixedObstacle(entity) then
    return 
  end
  local bornPos = ((self.caster).lsObject).localPosition
  if not ((entity.lsObject).localPosition):Equals(bornPos) then
    local tsVec2 = (CS.TrueSync).TSVector2
    local curDir = (((CS.TrueSync).TSVector3).Subtract)((entity.lsObject).localPosition, bornPos)
    local curDir2d = (tsVec2(curDir.x, curDir.z)).normalized
    local angle = LuaSkillCtrl:CallTSVec2Angle(curDir2d, shootDir2d)
    if angle > 100 or angle < -100 then
      return 
    end
  end
  do
    if entity.belongNum == (self.caster).belongNum then
      self:inspireFriend(entity)
    end
    if entity.belongNum ~= (self.caster).belongNum and not LuaSkillCtrl:IsFixedObstacle(entity) then
      self:HurtEnermy(entity)
    end
  end
end

bs_104603.inspireFriend = function(self, target)
  -- function num : 0_8 , upvalues : _ENV
  if target.hp <= 0 or target == nil or target.roleType ~= eBattleRoleType.character then
    return 
  end
  LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_inspire, 1, (self.arglist)[2])
end

bs_104603.HurtEnermy = function(self, target)
  -- function num : 0_9 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {(self.arglist)[1]})
  skillResult:EndResult()
end

bs_104603.OnBreakSkill = function(self, role)
  -- function num : 0_10 , upvalues : _ENV, base
  if role == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_DaiyanUlt, 1, true, true)
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_104603.OnUltRoleAction = function(self)
  -- function num : 0_11 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1.5)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start3, self)
end

bs_104603.PlayUltEffect = function(self)
  -- function num : 0_12 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104603.OnSkipUltView = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104603.OnMovieFadeOut = function(self)
  -- function num : 0_14 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104603.OnCasterDie = function(self)
  -- function num : 0_15 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104603

