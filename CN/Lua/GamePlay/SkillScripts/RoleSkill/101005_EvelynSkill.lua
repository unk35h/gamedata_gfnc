-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101002 = require("GamePlay.SkillScripts.RoleSkill.101002_EvelynSkill")
local bs_101005 = class("bs_101005", bs_101002)
local base = bs_101002
bs_101005.config = {weaponLv = 2}
bs_101005.config = setmetatable(bs_101005.config, {__index = base.config})
bs_101005.ctor = function(self)
  -- function num : 0_0
end

bs_101005.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101005.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101005

