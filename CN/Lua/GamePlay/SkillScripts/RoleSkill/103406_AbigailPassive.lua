-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103401 = require("GamePlay.SkillScripts.RoleSkill.103401_AbigailPassive")
local bs_103406 = class("bs_103406", bs_103401)
local base = bs_103401
bs_103406.config = {weaponLv = 3}
bs_103406.config = setmetatable(bs_103406.config, {__index = base.config})
bs_103406.ctor = function(self)
  -- function num : 0_0
end

bs_103406.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).self_int = (self.arglist)[2]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).sender_int = (self.arglist)[3]
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).skillTime = (self.arglist)[4]
end

bs_103406.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103406

