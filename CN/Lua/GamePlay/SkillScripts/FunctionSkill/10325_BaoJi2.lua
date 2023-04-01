-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10325 = class("bs_10325", LuaSkillBase)
local base = LuaSkillBase
bs_10325.config = {Attack1BuffId = 1262}
bs_10325.ctor = function(self)
  -- function num : 0_0
end

bs_10325.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_10325_1", 1, self.OnAfterBattleStart)
end

bs_10325.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local buffTier1 = (self.caster).crit * (self.arglist)[1] // 1000
  if buffTier1 < (self.arglist)[2] // 10 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).Attack1BuffId, buffTier1, nil, true)
  else
    buffTier1 = (self.arglist)[2] // 10
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).Attack1BuffId, buffTier1, nil, true)
  end
end

bs_10325.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10325

