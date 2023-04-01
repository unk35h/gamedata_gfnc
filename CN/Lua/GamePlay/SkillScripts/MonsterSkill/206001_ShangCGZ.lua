-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_200602 = require("GamePlay.SkillScripts.MonsterSkill.200602_CGZ_RefactorSY")
local bs_206001 = class("bs_206001", bs_200602)
local base = bs_200602
bs_206001.config = {}
bs_206001.config = setmetatable(bs_206001.config, {__index = base.config})
bs_206001.ctor = function(self)
  -- function num : 0_0
end

bs_206001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206001.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206001

