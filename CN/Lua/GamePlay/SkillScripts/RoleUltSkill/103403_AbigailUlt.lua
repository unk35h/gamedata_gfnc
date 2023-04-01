-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103403 = class("bs_103403", LuaSkillBase)
local base = LuaSkillBase
bs_103403.config = {effectId_throwBone = 1034031, effectId_target = 1034033, effetcId_criticalhit = 1034034, effectId_speed = 1, actionId_start = 1005, act_speed = 1, movieEndRoleAction = 1021, action_time = 7, skill_time = 30, audioIdStart = 1034031, audioIdMovie = 1034032, audioIdEnd = 1034033, audioIdTarget = 1034034, audioIdHit = 1034035, buffId_bone = 1034031, buffignoretype = 15, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3010, crit_formula = 0, returndamage_formula = 0}
}
bs_103403.ctor = function(self)
  -- function num : 0_0
end

bs_103403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_103403_3", 1, self.OnAfterHurt, nil, nil)
end

bs_103403.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait((self.config).skill_time)
  local inputCoord = LuaSkillCtrl:GetTargetWithGrid(selectTargetCoord.x, selectTargetCoord.y)
  ;
  (self.caster):LookAtTarget(inputCoord)
  LuaSkillCtrl:CallBattleCamShake()
  local target = nil
  if (selectRoles[0]).hp > 0 then
    target = selectRoles[0]
  end
  local CallSkillExecute = BindCallback(self, self.CallSelectExecute, target)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).movieEndRoleAction, (self.config).act_speed, (self.config).action_time, CallSkillExecute)
end

bs_103403.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= nil and role.belongNum ~= (self.caster).belongNum then
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_throwBone, self, self.SetBones, nil)
  end
end

bs_103403.SetBones = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioIdTarget)
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_bone, 1, (self.arglist)[1])
  end
end

bs_103403.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_5
  local boneTarget = target:GetBuffTier((self.config).buffId_bone)
  if target ~= sender and boneTarget > 0 and isCrit == true and skill ~= self.cskill and not isTriggerSet then
    self:DogAttack(target, sender)
  end
end

bs_103403.DogAttack = function(self, target, sender)
  -- function num : 0_6 , upvalues : _ENV
  if target == nil or target.hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallEffect(target, (self.config).effetcId_criticalhit, self, nil, sender)
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  local hurtRatio = (self.arglist)[2]
  LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurtRatio})
  skillResult:EndResult()
end

bs_103403.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1)
end

bs_103403.PlayUltEffect = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_103403.OnSkipUltView = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_103403.OnMovieFadeOut = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_103403.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103403

