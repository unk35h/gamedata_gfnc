-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100801 = require("GamePlay.SkillScripts.RoleSkill.100801_GinPassive")
local bs_100804 = class("bs_100804", bs_100801)
local base = bs_100801
bs_100804.config = {weaponLv = 1}
bs_100804.config = setmetatable(bs_100804.config, {__index = base.config})
bs_100804.ctor = function(self)
  -- function num : 0_0
end

bs_100804.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).weapon = true
end

bs_100804.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100804

