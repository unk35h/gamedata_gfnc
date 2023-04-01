-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104101 = require("GamePlay.SkillScripts.RoleSkill.104101_DeLaceyPassive")
local bs_104104 = class("bs_104104", bs_104101)
local base = bs_104101
bs_104104.config = {weaponLv = 1}
bs_104104.config = setmetatable(bs_104104.config, {__index = base.config})
bs_104104.ctor = function(self)
  -- function num : 0_0
end

bs_104104.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104104.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104104

