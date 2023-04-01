-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_501 = class("bs_501", bs_1)
local base = bs_1
bs_501.config = {effectId_1 = 10081, effectId_2 = 10082, audioId1 = 22, audioId2 = 200102, Imp = true}
bs_501.config = setmetatable(bs_501.config, {__index = base.config})
bs_501.ctor = function(self)
  -- function num : 0_0
end

bs_501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  LuaSkillCtrl:CallStartLocalScale(self.caster, (Vector3.New)(1.5, 1.5, 1.5))
end

bs_501.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_501

