-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103101 = require("GamePlay.SkillScripts.RoleSkill.103101_ImhotepPassive")
local bs_103105 = class("bs_103105", bs_103101)
local base = bs_103101
bs_103105.config = {weaponLv = 2}
bs_103105.config = setmetatable(bs_103105.config, {__index = base.config})
bs_103105.ctor = function(self)
  -- function num : 0_0
end

bs_103105.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_103105.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103105

