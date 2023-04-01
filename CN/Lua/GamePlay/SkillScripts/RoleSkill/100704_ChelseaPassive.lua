-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_100701 = require("GamePlay.SkillScripts.RoleSkill.100701_ChelseaPassive")
local bs_100704 = class("bs_100704", bs_100701)
local base = bs_100701
bs_100704.config = {weaponLv = 1}
bs_100704.config = setmetatable(bs_100704.config, {__index = base.config})
bs_100704.ctor = function(self)
  -- function num : 0_0
end

bs_100704.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  LuaSkillCtrl:AddChipChipConsumeSkill(100703, 1)
end

bs_100704.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_100704

