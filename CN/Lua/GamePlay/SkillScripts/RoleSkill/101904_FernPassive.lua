-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101901 = require("GamePlay.SkillScripts.RoleSkill.101901_FernPassive")
local bs_101904 = class("bs_101904", bs_101901)
local base = bs_101901
bs_101904.config = {weaponLv = 1}
bs_101904.config = setmetatable(bs_101904.config, {__index = base.config})
bs_101904.ctor = function(self)
  -- function num : 0_0
end

bs_101904.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101904.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101904

