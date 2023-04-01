-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91026 = class("bs_91026", LuaSkillBase)
local base = LuaSkillBase
bs_91026.config = {buffId = 2048, buffTier = 1}
bs_91026.ctor = function(self)
  -- function num : 0_0
end

bs_91026.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_91026_1", 1, self.OnAfterBattleStart)
end

bs_91026.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.damTimer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_91026.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.damTimer ~= nil and (self.damTimer):IsOver() then
    self.damTimer = nil
  end
  local targetListAll = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
  if targetListAll.Count > 0 then
    for i = 0, targetListAll.Count - 1 do
      LuaSkillCtrl:CallBuff(self, (targetListAll[i]).targetRole, (self.config).buffId, (self.config).buffTier, nil)
    end
    self:PlayChipEffect()
  end
end

bs_91026.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91026

