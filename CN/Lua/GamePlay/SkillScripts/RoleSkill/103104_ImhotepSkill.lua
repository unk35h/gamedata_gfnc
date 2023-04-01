-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_103102 = require("GamePlay.SkillScripts.RoleSkill.103102_ImhotepSkill")
local bs_103104 = class("bs_103104", bs_103102)
local base = bs_103102
bs_103104.config = {weaponLv = 1}
bs_103104.config = setmetatable(bs_103104.config, {__index = base.config})
bs_103104.ctor = function(self)
  -- function num : 0_0
end

bs_103104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_103104.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_103104

