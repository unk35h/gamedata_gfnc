-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15072 = class("bs_15072", LuaSkillBase)
local base = LuaSkillBase
bs_15072.config = {buffId = 1258, effectId = 10967, configId1 = 26}
bs_15072.ctor = function(self)
  -- function num : 0_0
end

bs_15072.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15072_1", 1, self.OnAfterBattleStart)
  self.hp_value = 0
  self.total = 0
  self.hurt = 0
end

bs_15072.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      self.hp_value = ((targetList[i]).targetRole).maxHp * (self.arglist)[2] // 1000
      self.total = self.total + self.hp_value
      LuaSkillCtrl:RemoveLife(self.hp_value, self, (targetList[i]).targetRole, true, nil, false, true, eHurtType.RealDmg, true)
    end
    local targetlist2 = LuaSkillCtrl:CallTargetSelect(self, 7, 10)
    if targetlist2.Count > 0 then
      local target = (targetlist2[0]).targetRole
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId1, {self.total}, true)
      skillResult:EndResult()
    end
  end
end

bs_15072.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15072

