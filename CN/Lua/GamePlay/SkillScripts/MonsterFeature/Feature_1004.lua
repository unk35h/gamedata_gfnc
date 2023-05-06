-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1004 = class("bs_1004", LuaSkillBase)
local base = LuaSkillBase
bs_1004.config = {buffId_def = 502}
bs_1004.ctor = function(self)
  -- function num : 0_0
end

bs_1004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1000_1", 1, self.OnAfterBattleStart)
end

bs_1004.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, nil, true)
end

bs_1004.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1004

