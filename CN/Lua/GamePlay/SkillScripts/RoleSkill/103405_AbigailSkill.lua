-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103402 = require("GamePlay.SkillScripts.RoleSkill.103402_AbigailSkill")
local bs_103405 = class("bs_103405", bs_103402)
local base = bs_103402
bs_103405.config = {weaponLv = 2}
bs_103405.config = setmetatable(bs_103405.config, {__index = base.config})
bs_103405.ctor = function(self)
  -- function num : 0_0
end

bs_103405.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Crit = (self.arglist)[4]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).CritHurt = (self.arglist)[5]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Time = (self.arglist)[6]
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).CritMax = (self.arglist)[7]
end

bs_103405.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103405

