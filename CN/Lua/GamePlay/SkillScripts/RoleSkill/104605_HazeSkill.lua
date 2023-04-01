-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104602 = require("GamePlay.SkillScripts.RoleSkill.104602_HazeSkill")
local bs_104605 = class("bs_104605", bs_104602)
local base = bs_104602
bs_104605.config = {weaponLv = 2}
bs_104605.config = setmetatable(bs_104605.config, {__index = base.config})
bs_104605.ctor = function(self)
  -- function num : 0_0
end

bs_104605.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104605.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104605

