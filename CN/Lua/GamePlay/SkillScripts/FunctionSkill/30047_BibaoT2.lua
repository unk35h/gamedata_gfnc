-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_30047 = class("bs_30047", LuaSkillBase)
local base = LuaSkillBase
bs_30047.config = {buffId_shixue = 257, buffId_baoji = 1220}
bs_30047.ctor = function(self)
  -- function num : 0_0
end

bs_30047.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_30047_12", 1, self.OnAfterPlaySkill)
end

bs_30047.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and not skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_shixue, (self.arglist)[1])
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_baoji, 1)
  end
end

bs_30047.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_30047

