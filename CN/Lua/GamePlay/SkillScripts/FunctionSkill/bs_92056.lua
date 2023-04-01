-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92056 = class("bs_92056", LuaSkillBase)
local base = LuaSkillBase
bs_92056.config = {}
bs_92056.ctor = function(self)
  -- function num : 0_0
end

bs_92056.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92056_1", 1, self.OnAfterBattleStart)
end

bs_92056.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.damTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[2], self.CallBack, self, -1, (self.arglist)[2])
end

bs_92056.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local Value = (self.arglist)[1] * ((targetList[i]).targetRole).maxHp // 1000
      LuaSkillCtrl:AddRoleShield((targetList[i]).targetRole, eShieldType.Normal, Value)
    end
    self:PlayChipEffect()
  end
end

bs_92056.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_92056

