-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleSkill.103802_SakuyaSkill")
local bs_300203 = class("bs_300203", base)
bs_300203.config = {skill_time = 37, start_time = 17}
bs_300203.config = setmetatable(bs_300203.config, {__index = base.config})
bs_300203.ctor = function(self)
  -- function num : 0_0
end

bs_300203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300203.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : base
  (base.PlaySkill)(self, data)
end

bs_300203.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300203

