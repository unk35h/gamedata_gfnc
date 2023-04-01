-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1059 = class("bs_1059", LuaSkillBase)
local base = LuaSkillBase
bs_1059.config = {effectId_end = 100109, effectId_line = 100110, effect_speed = 0.5, buffId_Heal = 100101, buff_tier = 1, 
heal_config = {baseheal_formula = 3022}
, 
heal_config2 = {baseheal_formula = 3021}
, 
heal_config2F = {baseheal_formula = 3028}
, audioIdStart = 100104, audioIdMovie = 100105, audioIdEnd = 100106, actionId_start = 1005, movieEndRoleActionId = 1006, buffId_Super = 3003, audioIdMovie2 = 100107}
bs_1059.ctor = function(self)
  -- function num : 0_0
end

bs_1059.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1
end

bs_1059.PlaySkill = function(self, data, selectTargetCoord, selectRoles, selectRolesType)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait(20)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_end, self, nil, nil, (self.config).effect_speed)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute), selectRolesType)
  LuaSkillCtrl:CallBattleCamShake()
end

bs_1059.CallSelectExecute = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  if role ~= nil and role.belongNum == (self.caster).belongNum then
    self.target = role
    LuaSkillCtrl:CallEffect(role, (self.config).effectId_line, self)
    LuaSkillCtrl:CallBuffRepeated(self, role, (self.config).buffId_Heal, (self.config).buff_tier, (self.arglist)[2], nil, self.OnBuffExecute)
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
    LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {(self.arglist)[1]}, false, false)
    skillResult:EndResult()
  end
end

bs_1059.OnBuffExecute = function(self, buff, targetRole)
  -- function num : 0_4 , upvalues : _ENV
  if targetRole == nil or targetRole.hp <= 0 then
    return 
  end
  local skillResult = (LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole))
  local healCfg = nil
  if self:IsConsumeSkill() then
    healCfg = (self.config).heal_config2F
  else
    healCfg = (self.config).heal_config2
  end
  LuaSkillCtrl:HealResult(skillResult, healCfg, {(self.arglist)[3]})
  skillResult:EndResult()
end

bs_1059.PlayUltEffect = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_5 , upvalues : base, _ENV
  if not self:Check(selectRoles) then
    return true
  end
  ;
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Super, 1, 15, true)
  if selectRoles ~= nil and selectRoles.Count > 0 then
    self.target = selectRoles[0]
  end
  if self.target ~= nil then
    (self.caster):LookAtInstantly(self.target)
  end
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_1059.Check = function(self, selectRoles)
  -- function num : 0_6
  if selectRoles == nil or selectRoles.Count <= 0 then
    return false
  end
  return self:CheckManualSkillTakeAvailable(selectRoles[0])
end

bs_1059.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, function()
    -- function num : 0_7_0 , upvalues : _ENV, self
    MsgCenter:Broadcast(eMsgEventId.OnUltSkillVideoStart)
    if (string.IsNullOrEmpty)((LuaSkillCtrl.cUltSkillCtrl).curUltMovieFileName) then
      self:OnMovieFadeOut()
      return 
    end
    if not (CommonUtil.GetIsNeedPlayUltrSkillAnimi)((self.cskill).dataId, true) then
      self:OnMovieFadeOut()
      return 
    end
    self:RemoveSkillTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut)
    self:AddTrigger(eSkillTriggerType.OnSelfUltMovieFadeOut, "OnMovieFadeOut", 1, self.OnMovieFadeOut)
    LuaSkillCtrl:CallPlayUltMovie()
    if (self.config).audioIdMovie == nil then
      return 
    end
    local audioId = (self.config).audioIdMovie
    if LuaSkillCtrl:GetCasterSkinId(self.caster) == 300107 then
      audioId = (self.config).audioIdMovie2
    end
    self.actionAudio = LuaSkillCtrl:PlayAuSource(self.caster, audioId, function(auback)
      -- function num : 0_7_0_0 , upvalues : self
      if auback == self.actionAudio then
        self.actionAudio = nil
      end
    end
)
  end
)
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_start)
end

bs_1059.OnSkipUltView = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_1059.OnMovieFadeOut = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_1059.OnCasterDie = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1059

