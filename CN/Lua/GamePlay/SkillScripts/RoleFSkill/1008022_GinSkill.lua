-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1008022 = class("bs_1008022", LuaSkillBase)
local base = LuaSkillBase
bs_1008022.config = {buffId_160 = 10080101, skill_time = 15, buffId_170 = 3008}
bs_1008022.ctor = function(self)
  -- function num : 0_0
end

bs_1008022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1008022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  local buff_time = (self.config).skill_time + (self.arglist)[1]
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_160, 1, buff_time, true)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_170, 1, buff_time, true)
  LuaSkillCtrl:CallRoleAction(self.caster, 1002)
  LuaSkillCtrl:StartShowSkillDurationTime(self, buff_time)
end

bs_1008022.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1008022

