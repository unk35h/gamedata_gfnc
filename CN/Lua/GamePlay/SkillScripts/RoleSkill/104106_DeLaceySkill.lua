-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_104102 = require("GamePlay.SkillScripts.RoleSkill.104102_DeLaceySkill")
local bs_104106 = class("bs_104106", bs_104102)
local base = bs_104102
bs_104106.config = {weaponLv = 3}
bs_104106.config = setmetatable(bs_104106.config, {__index = base.config})
bs_104106.ctor = function(self)
  -- function num : 0_0
end

bs_104106.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104106.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104106

