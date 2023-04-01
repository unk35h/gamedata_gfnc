-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15101 = class("bs_15101", LuaSkillBase)
local base = LuaSkillBase
bs_15101.config = {}
bs_15101.ctor = function(self)
  -- function num : 0_0
end

bs_15101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15101_1", 1, self.OnAfterBattleStart)
end

bs_15101.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallAddPlayerHmp((ConfigData.game_config).ultMpCost * (self.arglist)[1] // 1000)
end

bs_15101.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15101

