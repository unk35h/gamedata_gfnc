-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106703 = class("bs_106703", LuaSkillBase)
local base = LuaSkillBase
bs_106703.config = {effectId_start = 106709, effectId_hit = 106710, buffId = 3011, audioIdStart = 106708, audioIdMovie = 106709, audioIdEnd = 106710, actionId_start = 1005, movieEndRoleActionId = 1006, HurtConfigId = 30, buffId_tr = 106702}
bs_106703.ctor = function(self)
  -- function num : 0_0
end

bs_106703.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
end

bs_106703.PlaySkill = function(self, data, selectTargetCoord, selectRoles, SelectRolesType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(23)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute), SelectRolesType)
  if selectTargetCoord ~= nil then
    local inputTarget = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
    ;
    (self.caster):LookAtTarget(inputTarget)
    LuaSkillCtrl:CallEffect(inputTarget, (self.config).effectId_start, self)
  end
end

bs_106703.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= nil and role.belongNum ~= (self.caster).belongNum then
    LuaSkillCtrl:StartTimer(self, 5, BindCallback(self, self.CallSingleHurtEffect, role))
  end
end

bs_106703.CallSingleHurtEffect = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster ~= nil and (self.caster).hp > 0 then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_hit, self, self.SkillEventFunc1, nil, 1)
  end
end

bs_106703.SkillEventFunc1 = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Create and self.caster ~= nil and (self.caster).hp > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target.targetRole)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigId, {((self.caster).recordTable)["106701_break"], (self.arglist)[1]}, false)
    skillResult:EndResult()
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_tr, (self.arglist)[2], 1)
  end
end

bs_106703.PlayUltEffect = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_106703.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start)
end

bs_106703.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_106703.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_106703.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106703

