-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91004 = class("bs_91004", LuaSkillBase)
local base = LuaSkillBase
bs_91004.config = {buffId = 2004, buffTier = 1}
bs_91004.ctor = function(self)
  -- function num : 0_0
end

bs_91004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_91004_1", 1, self.OnAfterPlaySkill)
end

bs_91004.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if not skill.isCommonAttack then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.config).buffTier, nil, true)
  end
end

bs_91004.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91004

