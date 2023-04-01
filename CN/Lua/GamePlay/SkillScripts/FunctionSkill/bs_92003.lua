-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92003 = class("bs_92003", LuaSkillBase)
local base = LuaSkillBase
bs_92003.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10077, crit_formula = 0}
, effectId = 10628, effectId2 = 10630, effectId3 = 10626}
bs_92003.ctor = function(self)
  -- function num : 0_0
end

bs_92003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_92003_12", 1, self.OnAfterPlaySkill)
end

bs_92003.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if not skill.isCommonAttack then
    local loopJiange = (self.arglist)[1] // (self.arglist)[3]
    if self.damTimer == nil then
      self.damTimer = LuaSkillCtrl:StartTimer(nil, loopJiange, self.CallBack, self, -1, 0)
    else
      if self.damTimer ~= nil then
        (self.damTimer):Stop()
        self.damTimer = nil
        self.damTimer = LuaSkillCtrl:StartTimer(nil, loopJiange, self.CallBack, self, -1, 0)
      end
    end
    if self.damTimer2 == nil then
      self.damTimer2 = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1] + 1, self.CallBack2, self, 1, 0)
    else
      if self.damTimer2 ~= nil then
        (self.damTimer2):Stop()
        self.damTimer2 = nil
        self.damTimer2 = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1] + 1, self.CallBack2, self, 1, 0)
      end
    end
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId3, self)
  end
end

bs_92003.CallBack2 = function(self)
  -- function num : 0_3
  if self.damTimer2 ~= nil and (self.damTimer2):IsOver() then
    self.damTimer2 = nil
  end
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

bs_92003.CallBack = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.caster == nil then
    if self.damTimer then
      (self.damTimer):Stop()
      self.damTimer = nil
    end
    return 
  end
  if (self.caster).hp == 0 and self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
  if targetlist.Count < 1 then
    return 
  end
  LuaSkillCtrl:CallEffect((targetlist[0]).targetRole, (self.config).effectId, self, self.SkillEventFunc)
  if self.caster == nil or (self.caster).hp <= 0 then
    return 
  end
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId2, self)
end

bs_92003.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target, (self.config).aoe_config)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, nil, true)
    skillResult:EndResult()
  end
end

bs_92003.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  if self.damTimer2 then
    (self.damTimer2):Stop()
    self.damTimer2 = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

return bs_92003

