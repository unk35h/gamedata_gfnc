-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1032012 = class("bs_1032012", base)
bs_1032012.config = {}
bs_1032012.ctor = function(self)
  -- function num : 0_0
end

bs_1032012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_1032012_13", 1, self.OnAfterPlaySkill)
  self.Bj = 0
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).pass_arg = (self.arglist)[2]
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).cs_Passive = self.cskill
end

bs_1032012.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2
  if role == self.caster and skill.isCommonAttack then
    self.Bj = self.Bj + 1
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

    if self.Bj == (self.arglist)[1] - 1 then
      ((self.caster).recordTable).passive = true
      self.Bj = -1
    end
  end
end

bs_1032012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1032012

