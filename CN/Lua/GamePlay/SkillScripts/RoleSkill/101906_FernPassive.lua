-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101901 = require("GamePlay.SkillScripts.RoleSkill.101901_FernPassive")
local bs_101906 = class("bs_101906", bs_101901)
local base = bs_101901
bs_101906.config = {weaponLv = 3}
bs_101906.config = setmetatable(bs_101906.config, {__index = base.config})
bs_101906.ctor = function(self)
  -- function num : 0_0
end

bs_101906.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101906.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101906

