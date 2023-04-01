-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.101302_BettySkill")
local bs_300303 = class("bs_300303", base)
bs_300303.config = {buffId_Wild = 10130102}
bs_300303.config = setmetatable(bs_300303.config, {__index = base.config})
bs_300303.ctor = function(self)
  -- function num : 0_0
end

bs_300303.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300303.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300303

