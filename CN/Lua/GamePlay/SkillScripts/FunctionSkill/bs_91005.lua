-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91005 = class("bs_91005", LuaSkillBase)
local base = LuaSkillBase
bs_91005.config = {buffId = 2005, buffTier = 1}
bs_91005.ctor = function(self)
  -- function num : 0_0
end

bs_91005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_91005_1", 1, self.OnAfterPlaySkill)
end

bs_91005.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  end
end

bs_91005.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91005

