-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100201 = require("GamePlay.SkillScripts.RoleSkill.100201_AnnaPassive")
local bs_100204 = class("bs_100204", bs_100201)
local base = bs_100201
bs_100204.config = {weaponLv = 1, buffId_cockhourse2 = 100203}
bs_100204.config = setmetatable(bs_100204.config, {__index = base.config})
bs_100204.ctor = function(self)
  -- function num : 0_0
end

bs_100204.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_100204.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100204

