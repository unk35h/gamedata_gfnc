-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91016 = class("bs_91016", LuaSkillBase)
local base = LuaSkillBase
bs_91016.config = {buffId = 2026, buffTier = 1}
bs_91016.ctor = function(self)
  -- function num : 0_0
end

bs_91016.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_91016_1", 1, self.OnAfterPlaySkill)
end

bs_91016.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and not skill.isCommonAttack then
    local targetlist = LuaSkillCtrl:CallTargetSelect(self, 14, 10)
    local Num = (self.arglist)[2] // (self.arglist)[1]
    if targetlist.Count ~= 0 then
      local layer = ((targetlist[0]).targetRole):GetBuffTier((self.config).buffId)
      if layer < Num then
        LuaSkillCtrl:CallBuff(self, (targetlist[0]).targetRole, (self.config).buffId, (self.config).buffTier, nil, true)
      else
        LuaSkillCtrl:DispelBuff((targetlist[0]).targetRole, (self.config).buffId, 0)
        LuaSkillCtrl:CallBuff(self, (targetlist[0]).targetRole, (self.config).buffId, Num, nil, true)
      end
      self:PlayChipEffect()
    end
  end
end

bs_91016.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91016

