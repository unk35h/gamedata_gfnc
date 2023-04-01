-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101001 = require("GamePlay.SkillScripts.RoleSkill.101001_EvelynPassive")
local bs_101006 = class("bs_101006", bs_101001)
local base = bs_101001
bs_101006.config = {weaponLv = 3}
bs_101006.config = setmetatable(bs_101006.config, {__index = base.config})
bs_101006.ctor = function(self)
  -- function num : 0_0
end

bs_101006.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101006.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101006

