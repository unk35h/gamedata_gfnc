-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100801 = require("GamePlay.SkillScripts.RoleSkill.100801_GinPassive")
local bs_100805 = class("bs_100805", bs_100801)
local base = bs_100801
bs_100805.config = {weaponLv = 2}
bs_100805.config = setmetatable(bs_100805.config, {__index = base.config})
bs_100805.ctor = function(self)
  -- function num : 0_0
end

bs_100805.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).exHeal = (self.arglist)[7]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).exHeal_rate = (self.arglist)[6]
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon = true
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon2 = true
end

bs_100805.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100805

