-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105503 = class("bs_105503", LuaSkillBase)
local base = LuaSkillBase
bs_105503.config = {buffId = 105505, buffId_mark = 105506, buffId_focus = 105501, buffId_damage = 105507, buffId_focusOnFiring = 105508, HurtConfig = 14, effectId_line = 105510, effectId_line1 = 105511, effectId_hit = 105512, effectId = 105513, audioIdStart = 105508, audioIdMovie = 105509, audioIdEnd = 105510}
bs_105503.ctor = function(self)
  -- function num : 0_0
end

bs_105503.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105503.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait(20)
  self:GetSelectTargetAndExecute(selectRoles, BindCallback(self, self.CallSelectExecute))
end

bs_105503.CallSelectExecute = function(self, role)
  -- function num : 0_3
  if role ~= nil and role.belongNum ~= (self.caster).belongNum and not role:IsUnSelect(self.caster) then
    self:realPlaySkill(role)
  end
end

bs_105503.realPlaySkill = function(self, role)
  -- function num : 0_4 , upvalues : _ENV
  if self.Remove ~= nil then
    (self.Remove):Stop()
    self.Remove = nil
  end
  self:RemoveSkillTrigger(eSkillTriggerType.OnAfterShieldHurt)
  self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
  self:AddAfterHurtTrigger("105503", 9, self.OnAfterHurt, nil, nil, nil, nil, nil, nil, nil)
  self:AddTrigger(eSkillTriggerType.OnAfterShieldHurt, "bs_105503_2", 1, self.OnAfterShieldHurt)
  self.Remove = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    self:RemoveSkillTrigger(eSkillTriggerType.AfterHurt)
    self:RemoveSkillTrigger(eSkillTriggerType.OnAfterShieldHurt)
  end
, nil)
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.player)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId_focusOnFiring, 1, (self.arglist)[1], false, role)
    end
  end
  do
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, nil)
    ;
    (self.caster):LookAtTarget(role)
    LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_damage, 1, (self.arglist)[1])
    self:OnAttackTrigger(role)
  end
end

bs_105503.OnAttackTrigger = function(self, target)
  -- function num : 0_5
  self:RealPlaySkill(nil, target)
end

bs_105503.RealPlaySkill = function(self, sender, target)
  -- function num : 0_6 , upvalues : _ENV
  if sender == nil then
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_line, self, self.caster, false, false, self.SkillEventFunc)
  else
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_line, self, sender, false, false, self.SkillEventFunc)
  end
end

bs_105503.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_line and eventId == eBattleEffectEvent.Trigger then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    if targetList.Count == 0 then
      return 
    end
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId, 1, (self.arglist)[1])
    LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffId_mark, 1, 1)
    for i = 0, targetList.Count - 1 do
      if targetList[i] ~= nil and targetList[i] ~= target.targetRole and (targetList[i]):GetBuffTier((self.config).buffId_mark) <= 0 then
        self:RealPlaySkill(target.targetRole, targetList[i])
        break
      end
    end
  end
end

bs_105503.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_8 , upvalues : _ENV
  if isTriggerSet ~= true and hurt > 0 and target == ((self.caster).recordTable).FireSuppressTarget then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    if targetList.Count == 0 then
      return 
    end
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role ~= nil and role ~= target and role.hp > 0 and role:GetBuffTier((self.config).buffId) > 0 then
          local Hurt = hurt * (self.arglist)[2] // 1000
          LuaSkillCtrl:CallEffectWithArgOverride(role, (self.config).effectId_line1, self, target, false, false, self.SkillEventFunc1, Hurt)
        end
      end
    end
  end
end

bs_105503.OnAfterShieldHurt = function(self, context)
  -- function num : 0_9 , upvalues : _ENV
  if context.target == ((self.caster).recordTable).FireSuppressTarget and (context.target).belongNum ~= (self.caster).belongNum and context.shield_cost_hurt > 0 then
    local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
    if targetList.Count == 0 then
      return 
    end
    if targetList.Count > 0 then
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role ~= nil and role ~= context.target and role.hp > 0 and role:GetBuffTier((self.config).buffId) > 0 then
          local Hurt = context.shield_cost_hurt * (self.arglist)[2] // 1000
          LuaSkillCtrl:CallEffectWithArgOverride(role, (self.config).effectId_line1, self, context.target, false, false, self.SkillEventFunc1, Hurt)
        end
      end
    end
  end
end

bs_105503.SkillEventFunc1 = function(self, Hurt, effect, eventId, target)
  -- function num : 0_10 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_line1 and eventId == eBattleEffectEvent.Die then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfig, {Hurt}, true, nil)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_hit, self, nil, nil, nil, true)
  end
end

bs_105503.OnUltRoleAction = function(self)
  -- function num : 0_11 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 0.8)
end

bs_105503.PlayUltEffect = function(self)
  -- function num : 0_12 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105503.OnSkipUltView = function(self)
  -- function num : 0_13 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105503.OnMovieFadeOut = function(self)
  -- function num : 0_14 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105503.OnCasterDie = function(self)
  -- function num : 0_15 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Remove ~= nil then
    (self.Remove):Stop()
    self.Remove = nil
  end
end

bs_105503.LuaDispose = function(self)
  -- function num : 0_16 , upvalues : base
  (base.LuaDispose)(self)
  self.Remove = nil
end

return bs_105503

