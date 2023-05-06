-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1014 = class("bs_1014", LuaSkillBase)
local base = LuaSkillBase
bs_1014.config = {buffId_def = 505}
bs_1014.ctor = function(self)
  -- function num : 0_0
end

bs_1014.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1014", 1, self.OnAfterBattleStart)
end

bs_1014.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_def, 1, nil, true)
end

bs_1014.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1014

