-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92055 = class("bs_92055", LuaSkillBase)
local base = LuaSkillBase
bs_92055.config = {}
bs_92055.ctor = function(self)
  -- function num : 0_0
end

bs_92055.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92055_1", 1, self.OnAfterBattleStart)
end

bs_92055.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.damTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[2], self.CallBack, self, -1, (self.arglist)[2])
end

bs_92055.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  local targetListAll = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetListAll.Count > 0 then
    for i = 0, targetListAll.Count - 1 do
      LuaSkillCtrl:CallHeal(((targetListAll[i]).targetRole).maxHp * (self.arglist)[1] // 1000, self, targetListAll[i], true)
    end
    self:PlayChipEffect()
  end
end

bs_92055.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92055

