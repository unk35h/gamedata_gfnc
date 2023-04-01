-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_104600 = class("bs_104600", bs_1)
local base = bs_1
bs_104600.config = {effectId_trail = 104601, effectId_trail_ex = 104601, effectId_split_shoot = 104616, effectId_split_shoot_ex = 104616}
bs_104600.config = setmetatable(bs_104600.config, {__index = base.config})
bs_104600.ctor = function(self)
  -- function num : 0_0
end

bs_104600.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_104600.OnAttackTrigger = function(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
  -- function num : 0_2 , upvalues : _ENV, base
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnCommonAttackTrigger, target, self.caster, self.cskill)
  ;
  (base.OnAttackTrigger)(self, target, data, atkSpeedRatio, atkActionId, atkTriggerFrame)
end

bs_104600.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_104600

