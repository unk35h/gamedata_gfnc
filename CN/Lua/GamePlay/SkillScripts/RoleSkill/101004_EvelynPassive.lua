-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101001 = require("GamePlay.SkillScripts.RoleSkill.101001_EvelynPassive")
local bs_101004 = class("bs_101004", bs_101001)
local base = bs_101001
bs_101004.config = {weaponLv = 1}
bs_101004.config = setmetatable(bs_101004.config, {__index = base.config})
bs_101004.ctor = function(self)
  -- function num : 0_0
end

bs_101004.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101004.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101004

