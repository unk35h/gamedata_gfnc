-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010401 = class("bs_4010401", LuaSkillBase)
local base = LuaSkillBase
bs_4010401.config = {buffId = 110067}
bs_4010401.ctor = function(self)
  -- function num : 0_0
end

bs_4010401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_4010401_1", 1, self.OnAfterBattleStart)
end

bs_4010401.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).belongNum == eBattleRoleBelong.player and self.caster ~= nil then
    local buffTier = (self.caster).maxHp // (self.arglist)[1]
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier, nil)
  end
end

bs_4010401.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010401

