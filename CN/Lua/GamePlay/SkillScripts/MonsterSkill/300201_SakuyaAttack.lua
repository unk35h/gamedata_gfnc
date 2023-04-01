-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.CommonAttackSkill.103800_SakuyaAttack")
local bs_300201 = class("bs_300201", base)
bs_300201.config = {action1 = 1021}
bs_300201.config = setmetatable(bs_300201.config, {__index = base.config})
bs_300201.ctor = function(self)
  -- function num : 0_0
end

bs_300201.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_300201.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_300201

