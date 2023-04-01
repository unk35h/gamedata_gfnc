-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104903 = class("bs_104903", LuaSkillBase)
local base = LuaSkillBase
bs_104903.config = {buffId_passive = 104901, attackTime = 4, effectId_attack = 104914, effectId_hit = 104920, hurtConfigId = 2, actionId_end = 1006, audioIdStart = 104911, audioIdMovie = 104912, audioId_hit = 104914, audioId_bigHit = 104916}
bs_104903.ctor = function(self)
  -- function num : 0_0
end

bs_104903.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104903.PlaySkill = function(self, data, selectTargetCoord, selectRoles)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  if selectRoles == nil or selectRoles.Count <= 0 then
    return 
  end
  local role = selectRoles[0]
  if role ~= nil and role.belongNum ~= (self.caster).belongNum then
    local numTime = 4
    do
      local Times = 0
      self.up = 1
      do
        if (self.caster):GetBuffTier((self.config).buffId_passive) > 0 then
          local tier = (self.caster):GetBuffTier((self.config).buffId_passive)
          self.up = self.up + tier
        end
        local waitTime = 4 * numTime + 20
        self:CallCasterWait(waitTime)
        ;
        (self.caster):LookAtTarget(role)
        LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_end)
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_passive, 0)
        local effect = LuaSkillCtrl:CallEffect(role, (self.config).effectId_attack, self)
        LuaSkillCtrl:StartTimer(nil, (self.config).attackTime * numTime + 3, function()
    -- function num : 0_2_0 , upvalues : effect
    if effect ~= nil then
      effect:Die()
      effect = nil
    end
  end
)
        LuaSkillCtrl:StartTimer(nil, (self.config).attackTime, function()
    -- function num : 0_2_1 , upvalues : role, self, Times, _ENV, effect
    if role ~= nil and role.hp > 0 and self.caster ~= nil and (self.caster).hp > 0 then
      Times = Times + 1
      if Times == 5 then
        LuaSkillCtrl:StartTimer(nil, 5, function()
      -- function num : 0_2_1_0 , upvalues : role, self, _ENV
      if role ~= nil and role.hp > 0 and self.caster ~= nil and (self.caster).hp > 0 then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_hit, self, nil, role)
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[1] * self.up})
        skillResult:EndResult()
        LuaSkillCtrl:PlayAuSource(role, (self.config).audioId_hit)
      end
    end
)
      else
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_hit, self, nil, role)
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {(self.arglist)[1]})
        skillResult:EndResult()
        LuaSkillCtrl:PlayAuSource(role, (self.config).audioId_bigHit)
      end
    else
      do
        if self.caster ~= nil and (self.caster).hp > 0 then
          LuaSkillCtrl:CallBreakAllSkill(self.caster)
        end
        if effect ~= nil then
          effect:Die()
          effect = nil
        end
      end
    end
  end
, self, numTime, (self.config).attackTime - 1)
      end
    end
  end
end

bs_104903.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if target == nil or (target.targetRole).hp <= 0 or eventId == eBattleEffectEvent.Trigger then
  end
end

bs_104903.PlayUltEffect = function(self)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_104903.OnUltRoleAction = function(self)
  -- function num : 0_5 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005)
end

bs_104903.OnSkipUltView = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_104903.OnMovieFadeOut = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_104903.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104903

