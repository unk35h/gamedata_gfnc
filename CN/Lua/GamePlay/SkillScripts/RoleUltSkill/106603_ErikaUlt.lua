-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106603 = class("bs_106603", LuaSkillBase)
local base = LuaSkillBase
bs_106603.config = {effectId_shan = 106612, effectId_hit = 106613, radius = 300, arcAngleRange = 30, HurtConfigId2 = 2, buffId_Back = 3007, buffId_ding = 106603, actionId_end = 1006, actionId_loop = 1010, audioIdStart = 106609, audioIdMovie = 106610, audioIdEnd = 106611, audioId_hit = 106612}
bs_106603.ctor = function(self)
  -- function num : 0_0
end

bs_106603.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106603.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
  ;
  (self.caster):LookAtTarget(inputTarget)
  self:CallCasterWait((self.arglist)[1])
  LuaSkillCtrl:CallRoleAction(self.caster, 1010)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, (self.arglist)[1], true)
  if self.loopAttack ~= nil then
    (self.loopAttack):Die()
  end
  self.loopAttack = LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_shan, self, nil, nil, nil, true)
  LuaSkillCtrl:StartTimer(self, 5, BindCallback(self, self.CallEffectAndEmissions, inputTarget), self, -1, 4)
  LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBreakAllSkill(self.caster)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
  end
)
end

bs_106603.CallEffectAndEmissions = function(self, inputTarget)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId_hit)
  local curGrid = LuaSkillCtrl:GetGridWithRole(self.caster)
  local ColliderEnter = BindCallback(self, self.OnColliderEnter)
  local fireCollider = LuaSkillCtrl:CallGetSectorSkillCollider(self, curGrid, (self.config).radius, (self.config).arcAngleRange, inputTarget, eColliderInfluenceType.Enemy, false, ColliderEnter)
  fireCollider.bindRole = self.caster
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_3_0 , upvalues : _ENV, fireCollider
    LuaSkillCtrl:ClearColliderOrEmission(fireCollider)
  end
)
end

bs_106603.OnColliderEnter = function(self, collider, index, entity)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  if LuaSkillCtrl:IsFixedObstacle(entity) ~= true then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, entity)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId2, {(self.arglist)[3]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(entity, (self.config).effectId_hit, self)
    if entity.intensity > 0 and entity.belongNum == eBattleRoleBelong.enemy and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[4] then
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_Back, 1, 3)
      LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_ding, 1, 20)
    end
  end
end

bs_106603.PlayUltEffect = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, (self.arglist)[1], true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_106603.OnUltRoleAction = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 15, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_106603.OnBreakSkill = function(self, role)
  -- function num : 0_7 , upvalues : _ENV, base
  if role == self.caster then
    self:CancleCasterWait()
    LuaSkillCtrl:CallRoleAction(self.caster, 100)
    LuaSkillCtrl:DispelBuff(self.caster, 196, 0, true)
  end
  ;
  (base.OnBreakSkill)(self, role)
end

bs_106603.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
  if self.loopAttack ~= nil then
    (self.loopAttack):Die()
    self.loopAttack = nil
  end
end

bs_106603.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.loopAttack = nil
end

return bs_106603

