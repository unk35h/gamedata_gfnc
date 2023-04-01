-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_81003 = class("bs_81003", LuaSkillBase)
local base = LuaSkillBase
bs_81003.config = {}
bs_81003.ctor = function(self)
  -- function num : 0_0
end

bs_81003.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_81003_4", 1, self.OnAfterBattleStart)
end

bs_81003.OnAfterBattleStart = function(self)
  -- function num : 0_2
end

bs_81003.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_81003

