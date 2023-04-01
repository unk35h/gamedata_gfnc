-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104101 = require("GamePlay.SkillScripts.RoleSkill.104101_DeLaceyPassive")
local bs_104105 = class("bs_104105", bs_104101)
local base = bs_104101
bs_104105.config = {weaponLv = 2}
bs_104105.config = setmetatable(bs_104105.config, {__index = base.config})
bs_104105.ctor = function(self)
  -- function num : 0_0
end

bs_104105.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104105.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104105

