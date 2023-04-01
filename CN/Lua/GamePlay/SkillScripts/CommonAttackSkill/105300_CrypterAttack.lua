-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_105300 = class("bs_105300", bs_1)
local base = bs_1
bs_105300.config = {effectId_trail = 105300}
bs_105300.config = setmetatable(bs_105300.config, {__index = base.config})
bs_105300.ctor = function(self)
  -- function num : 0_0
end

bs_105300.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_105300.ExecuteEffectAttack = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.ExecuteEffectAttack)(self, data, atkActionId, target, effectId1, effectId2)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnCrypterAttack, target, self.caster, self.cskill)
end

bs_105300.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_105300

