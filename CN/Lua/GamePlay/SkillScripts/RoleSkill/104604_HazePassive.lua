-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104601 = require("GamePlay.SkillScripts.RoleSkill.104601_HazePassive")
local bs_104604 = class("bs_104604", bs_104601)
local base = bs_104601
bs_104604.config = {weaponLv = 1}
bs_104604.config = setmetatable(bs_104604.config, {__index = base.config})
bs_104604.ctor = function(self)
  -- function num : 0_0
end

bs_104604.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104604.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104604

