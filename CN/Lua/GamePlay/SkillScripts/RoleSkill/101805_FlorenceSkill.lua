-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_101802 = require("GamePlay.SkillScripts.RoleSkill.101802_FlorenceSkill")
local bs_101805 = class("bs_101805", bs_101802)
local base = bs_101802
bs_101805.config = {weaponLv = 2}
bs_101805.config = setmetatable(bs_101805.config, {__index = base.config})
bs_101805.ctor = function(self)
  -- function num : 0_0
end

bs_101805.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_101805.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_101805

