-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20228 = class("bs_20228", LuaSkillBase)
local base = LuaSkillBase
bs_20228.config = {buffId = 3002}
bs_20228.ctor = function(self)
  -- function num : 0_0
end

bs_20228.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20228_1", 1, self.OnAfterBattleStart)
end

bs_20228.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId, 1)
  end
end

bs_20228.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_20228

