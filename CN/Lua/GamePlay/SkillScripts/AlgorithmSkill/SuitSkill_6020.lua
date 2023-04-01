-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6020 = class("bs_6020", LuaSkillBase)
local base = LuaSkillBase
bs_6020.config = {buffId_1 = 602001, buffId_2 = 602002}
bs_6020.ctor = function(self)
  -- function num : 0_0
end

bs_6020.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_6020_1", 0, self.OnAfterBattleStart)
end

bs_6020.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local num = (self.caster).cd_reduce * 500 // 1000
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, num, nil, true)
  local num_2 = num // (self.arglist)[2]
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_2, num_2, nil, true)
end

bs_6020.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6020

