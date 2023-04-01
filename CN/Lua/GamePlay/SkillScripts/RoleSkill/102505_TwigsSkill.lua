-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102504 = require("GamePlay.SkillScripts.RoleSkill.102504_TwigsSkill")
local bs_102505 = class("bs_102505", bs_102504)
local base = bs_102504
bs_102505.config = {weaponLv = 2}
bs_102505.config = setmetatable(bs_102505.config, {__index = base.config})
bs_102505.ctor = function(self)
  -- function num : 0_0
end

bs_102505.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_102505.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102505

