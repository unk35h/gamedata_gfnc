-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25008 = class("bs_25008", LuaSkillBase)
local base = LuaSkillBase
bs_25008.config = {buffId = 210605}
bs_25008.ctor = function(self)
  -- function num : 0_0
end

bs_25008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25008_1", 1, self.OnAfterBattleStart)
end

bs_25008.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).dataId ~= 20081 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil)
  end
end

bs_25008.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25008

