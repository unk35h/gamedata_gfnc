-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21054 = class("bs_21054", LuaSkillBase)
local base = LuaSkillBase
bs_21054.config = {buffUpId = 110026, buffDownId = 110027}
bs_21054.ctor = function(self)
  -- function num : 0_0
end

bs_21054.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21054_1", 1, self.OnAfterBattleStart)
end

bs_21054.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).y == 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffUpId, 1, nil)
  else
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffDownId, 1, nil)
  end
end

bs_21054.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21054

