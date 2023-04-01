-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103102 = require("GamePlay.SkillScripts.RoleSkill.103102_ImhotepSkill")
local bs_103106 = class("bs_103106", bs_103102)
local base = bs_103102
bs_103106.config = {weaponLv = 3}
bs_103106.config = setmetatable(bs_103106.config, {__index = base.config})
bs_103106.ctor = function(self)
  -- function num : 0_0
end

bs_103106.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_103106.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103106

