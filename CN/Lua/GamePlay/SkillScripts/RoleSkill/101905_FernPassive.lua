-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101901 = require("GamePlay.SkillScripts.RoleSkill.101901_FernPassive")
local bs_101905 = class("bs_101905", bs_101901)
local base = bs_101901
bs_101905.config = {weaponLv = 2}
bs_101905.config = setmetatable(bs_101905.config, {__index = base.config})
bs_101905.ctor = function(self)
  -- function num : 0_0
end

bs_101905.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101905.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101905

