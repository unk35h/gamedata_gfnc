-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15133 = class("bs_15133", LuaSkillBase)
local base = LuaSkillBase
bs_15133.config = {heal_resultId = 4}
bs_15133.ctor = function(self)
  -- function num : 0_0
end

bs_15133.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15133_1", 1, self.OnAfterBattleStart)
end

bs_15133.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_15133.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 78, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if ((targetList[i]).targetRole).roleType == eBattleRoleType.character then
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, (targetList[i]).targetRole)
        LuaSkillCtrl:HealResultWithConfig(self, skillResult, (self.config).heal_resultId, {(self.arglist)[2]})
        skillResult:EndResult()
        break
      end
    end
  end
end

bs_15133.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_15133

