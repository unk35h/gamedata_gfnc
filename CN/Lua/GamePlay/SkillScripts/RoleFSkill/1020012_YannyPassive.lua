-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1020012 = class("bs_1020012", base)
bs_1020012.config = {buffId = 10200101, healBuffId = 10200201}
bs_1020012.ctor = function(self)
  -- function num : 0_0
end

bs_1020012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1020012_1", 1, self.OnAfterBattleStart)
  self:AddSetHealTrigger("bs_1020012_2", 99, self.OnSetHeal, nil, self.caster)
end

bs_1020012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
end

bs_1020012.OnSetHeal = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target == self.caster and context.isTriggerSet ~= true then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).healBuffId, 1, (self.arglist)[3])
  end
end

bs_1020012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1020012

