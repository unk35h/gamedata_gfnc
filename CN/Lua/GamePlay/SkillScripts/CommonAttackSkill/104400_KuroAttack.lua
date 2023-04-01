-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104400 = class("bs_104400", bs_1)
local base = bs_1
bs_104400.config = {effectId_trail = 104401, effectId_trail_pass = 104403, configId_pass = 5, action1 = 1031, action2 = 1034, end_time_1 = 11, end_time_2 = 14, actionId_1_end = 1033, actionId_2_end = 1036, effectId_action_1 = 104416, effectId_action_2 = 104416, interval = 3}
bs_104400.config = setmetatable(bs_104400.config, {__index = base.config})
bs_104400.ctor = function(self)
  -- function num : 0_0
end

bs_104400.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104400.ExecuteEffectAttack = function(self, data, atkActionId, target)
  -- function num : 0_2 , upvalues : _ENV
  if data.audioId4 ~= nil then
    LuaSkillCtrl:PlayAuSource(self.caster, data.audioId4)
  end
  if data.effectId_trail_ex ~= nil then
    if atkActionId == data.action1 then
      LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail, self, nil, false, self.SkillEventFunc, data)
    else
      LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail_ex, self, nil, false, self.SkillEventFunc, data)
    end
  else
    LuaSkillCtrl:CallEffectWithArg(target, data.effectId_trail, self, nil, false, self.SkillEventFunc, data)
  end
  self.rollNum = 0
  self:Roll(target, atkActionId)
end

bs_104400.Roll = function(self, target, atkActionId)
  -- function num : 0_3 , upvalues : _ENV
  if ((self.caster).recordTable)["self.roll"] ~= nil and LuaSkillCtrl:CallRange(1, 1000) <= ((self.caster).recordTable)["self.roll"] and target ~= nil and target.hp > 0 and self.rollNum < ((self.caster).recordTable)["self.max"] then
    self.rollNum = self.rollNum + 1
    self:CallCasterWait((self.config).interval + 1)
    if self.again ~= nil then
      (self.again):Stop()
      self.again = nil
    end
    self.again = LuaSkillCtrl:StartTimer(self, (self.config).interval, function()
    -- function num : 0_3_0 , upvalues : self, target, atkActionId
    self:Open(target, atkActionId)
  end
, self)
  else
    self:OnOver(atkActionId)
  end
end

bs_104400.Open = function(self, target, atkActionId)
  -- function num : 0_4 , upvalues : _ENV
  if target ~= nil and target.hp >= 0 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_action_1, self)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_trail_pass, self, self.SkillEventFunc_pass)
    self:Roll(target, atkActionId)
  else
    self:OnOver(atkActionId)
  end
end

bs_104400.SkillEventFunc_pass = function(self, effect, eventId, target)
  -- function num : 0_5 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId_pass, {((self.caster).recordTable)["self.number"]})
    skillResult:EndResult()
  end
end

bs_104400.OnOver = function(self, atkActionId)
  -- function num : 0_6 , upvalues : _ENV
  if atkActionId == (self.config).action1 then
    self:CallCasterWait((self.config).end_time_1)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_1_end)
  else
    self:CallCasterWait((self.config).end_time_2)
    LuaSkillCtrl:CallRoleAction(self.caster, (self.config).actionId_2_end)
  end
end

bs_104400.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104400

