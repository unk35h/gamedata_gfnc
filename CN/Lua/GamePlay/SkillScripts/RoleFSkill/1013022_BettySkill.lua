-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1013022 = class("bs_1013022", LuaSkillBase)
local base = LuaSkillBase
bs_1013022.config = {buffId_Wild = 10130101, buffId_170 = 170}
bs_1013022.ctor = function(self)
  -- function num : 0_0
end

bs_1013022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1013022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Wild, 1, (self.arglist)[1], true)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, (self.arglist)[1], true)
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[1])
end

bs_1013022.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1013022

