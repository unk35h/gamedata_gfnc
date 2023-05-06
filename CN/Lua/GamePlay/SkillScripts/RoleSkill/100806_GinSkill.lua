-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100802 = require("GamePlay.SkillScripts.RoleSkill.100802_GinSkill")
local bs_100806 = class("bs_100806", bs_100802)
local base = bs_100802
bs_100806.config = {weaponLv = 3}
bs_100806.config = setmetatable(bs_100806.config, {__index = base.config})
bs_100806.ctor = function(self)
  -- function num : 0_0
end

bs_100806.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_100806.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100806

