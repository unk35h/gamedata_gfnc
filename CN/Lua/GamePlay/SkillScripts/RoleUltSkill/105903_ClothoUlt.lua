-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105903 = class("bs_105903", LuaSkillBase)
local base = LuaSkillBase
bs_105903.config = {effectId_cast = 105911, effectId_trail = 105912, effectId_trail1 = 105913, HurtConfigID = 19, heal_resultId = 6, audioIdStart = 105913, audioIdMovie = 105914, audioIdEnd = 105915}
bs_105903.ctor = function(self)
  -- function num : 0_0
end

bs_105903.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddHurtResultEndTrigger("bs_105903", 30, self.OnHurtResultEnd, self.caster, nil, eBattleRoleBelong.player)
  self.skillState = nil
end

bs_105903.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:CallCasterWait(20)
  self.skillState = true
  local soulNum = (self.arglist)[1] + ((self.caster).recordTable).Soul_Num - 1
  LuaSkillCtrl:CallRoleAction(self.caster, 1006, 1)
  self.Remove = LuaSkillCtrl:StartTimer(nil, 3, function()
    -- function num : 0_2_0 , upvalues : self
    self:Shoot()
  end
, self, soulNum, 3)
  if self.timer == nil then
    self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function()
    -- function num : 0_2_1 , upvalues : self
    self.skillState = nil
  end
, self)
  else
    ;
    (self.timer):Stop()
    self.timer = nil
    self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function()
    -- function num : 0_2_2 , upvalues : self
    self.skillState = nil
  end
, self)
  end
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_cast, self)
end

bs_105903.Shoot = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local last_target = ((self.caster).recordTable).lastAttackRole
  local target = nil
  if last_target ~= nil and last_target.hp > 0 and last_target.belongNum ~= eBattleRoleBelong.neutral and LuaSkillCtrl:IsAbleAttackTarget(self.caster, last_target, 1) then
    target = last_target
  else
    local tempTarget = LuaSkillCtrl:CallTargetSelect(self, 19, 10)
    if tempTarget.Count > 0 then
      target = (tempTarget[0]).targetRole
    end
  end
  do
    LuaSkillCtrl:CallEffectWithArgOverride(target, (self.config).effectId_trail, self, self.caster, nil, nil, self.SoulAttack)
  end
end

bs_105903.SoulAttack = function(self, effect, eventId, target)
  -- function num : 0_4 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail and eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {(self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_105903.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_5 , upvalues : _ENV
  if skill.maker == self.caster and skill.dataId == 105903 and self.skillState == true then
    LuaSkillCtrl:CallEffectWithArgOverride(skill.maker, (self.config).effectId_trail1, self, targetRole, false, false, self.SoulHeal, hurtValue)
  end
end

bs_105903.SoulHeal = function(self, hurtValue, effect, eventId, target)
  -- function num : 0_6 , upvalues : _ENV
  if effect.dataId == (self.config).effectId_trail1 and eventId == eBattleEffectEvent.Trigger then
    do
      if hurtValue > 0 then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
        LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[4] // 1000 * hurtValue})
        skillResult:EndResult()
      end
      if self.skillState == true then
        self:Shoot()
      end
    end
  end
end

bs_105903.OnUltRoleAction = function(self)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.OnUltRoleAction)(self)
  LuaSkillCtrl:StartTimerInUlt(self, 7, self.PlayUltMovie)
  LuaSkillCtrl:CallRoleAction(self.caster, 1005, 1.5)
end

bs_105903.PlayUltEffect = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.PlayUltEffect)(self)
  LuaSkillCtrl:CallBuff(self, self.caster, 196, 1, 15, true)
  LuaSkillCtrl:CallFocusTimeLine(self.caster)
end

bs_105903.OnSkipUltView = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnSkipUltView)(self)
end

bs_105903.OnMovieFadeOut = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnMovieFadeOut)(self)
end

bs_105903.OnCasterDie = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Remove ~= nil then
    (self.Remove):Stop()
    self.Remove = nil
  end
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_105903.LuaDispose = function(self)
  -- function num : 0_12 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_105903

