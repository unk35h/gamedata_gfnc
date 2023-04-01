-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93030 = class("bs_93030", LuaSkillBase)
local base = LuaSkillBase
bs_93030.config = {effectId = 10978, buffId = 2062, checkBuffId = 2061}
bs_93030.ctor = function(self)
  -- function num : 0_0
end

bs_93030.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_93030_1", 1, self.OnAfterBattleStart)
end

bs_93030.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
end

bs_93030.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local targetlist = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetlist.Count < 1 then
    return 
  end
  for i = 0, targetlist.Count - 1 do
    local target = (targetlist[i]).targetRole
    local buffTier = target:GetBuffTier((self.config).checkBuffId)
    local targetlist1 = LuaSkillCtrl:CallTargetSelect(self, 51, 10)
    if targetlist1.Count < 0 then
      return 
    end
    local targetRole = (targetlist1[0]).targetRole
    local skill_intensity = targetRole.skill_intensity
    if target ~= nil and buffTier ~= 0 then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:CallEffect(target, (self.config).effectId, self, self.SkillEventFunc)
      LuaSkillCtrl:HealResultWithConfig(self, skillResult, 6, {buffTier * (self.arglist)[2] * skill_intensity // 1000}, true, true)
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1, buffTier * (self.arglist)[3])
      skillResult:EndResult()
    end
  end
end

bs_93030.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_93030

