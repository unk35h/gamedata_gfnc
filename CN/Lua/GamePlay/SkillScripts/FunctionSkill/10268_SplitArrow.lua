-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10268 = class("bs_10268", LuaSkillBase)
local base = LuaSkillBase
bs_10268.config = {splitShootBuff = 1180}
bs_10268.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10268_start", 1, self.OnAfterBattleStart)
end

bs_10268.OnAfterBattleStart = function(self)
  -- function num : 0_1 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).splitShootBuff, 1, nil, true)
end

bs_10268.OnCasterDie = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10268

