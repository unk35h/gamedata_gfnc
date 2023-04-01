-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206403 = require("GamePlay.SkillScripts.MonsterSkill.206403_SSummonzhong")
local bs_206402 = class("bs_206402", bs_206403)
local base = bs_206403
bs_206402.config = {
middleMonsterId = {20, 21, 22}
, maxHpPer = 180, powPer = 700}
bs_206402.config = setmetatable(bs_206402.config, {__index = base.config})
bs_206402.ctor = function(self)
  -- function num : 0_0
end

bs_206402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206402.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_206402

