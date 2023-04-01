-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15058 = class("bs_15058", LuaSkillBase)
local base = LuaSkillBase
bs_15058.config = {buffId = 1247}
bs_15058.ctor = function(self)
  -- function num : 0_0
end

bs_15058.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_15058_13", 1, self.OnAfterPlaySkill)
end

bs_15058.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if not skill.isCommonAttack and role == self.caster then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1], true)
  end
end

bs_15058.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15058

