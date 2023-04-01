-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_25053 = class("bs_25053", LuaSkillBase)
local base = LuaSkillBase
bs_25053.config = {buffId = 110077}
bs_25053.ctor = function(self)
  -- function num : 0_0
end

bs_25053.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_25053_1", 1, self.OnAfterBattleStart)
end

bs_25053.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).belongNum == eBattleRoleBelong.enemy and (self.caster).intensity >= 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_25053.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_25053

