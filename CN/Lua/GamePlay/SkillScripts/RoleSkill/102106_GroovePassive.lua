-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102101 = require("GamePlay.SkillScripts.RoleSkill.102101_GroovePassive")
local bs_102106 = class("bs_102106", bs_102101)
local base = bs_102101
bs_102106.config = {weaponLv = 3}
bs_102106.config = setmetatable(bs_102106.config, {__index = base.config})
bs_102106.ctor = function(self)
  -- function num : 0_0
end

bs_102106.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_102106.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102106

