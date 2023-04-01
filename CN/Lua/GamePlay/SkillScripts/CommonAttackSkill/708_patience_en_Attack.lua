-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_708 = class("bs_708", bs_1)
local base = bs_1
bs_708.config = {effectId_1 = 10589, effectId_2 = 10589, effectId_sign = 210201, audioId1 = 21, audioId2 = 21}
bs_708.config = setmetatable(bs_708.config, {__index = base.config})
bs_708.ctor = function(self)
  -- function num : 0_0
end

bs_708.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_708", 1, self.OnAfterBattleStart)
end

bs_708.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_sign, self)
end

bs_708.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_708

