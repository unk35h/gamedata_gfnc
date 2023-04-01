-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10305 = class("bs_10305", LuaSkillBase)
local base = LuaSkillBase
bs_10305.config = {buffId = 1121}
bs_10305.ctor = function(self)
  -- function num : 0_0
end

bs_10305.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10305_1", 1, self.OnAfterBattleStart)
end

bs_10305.OnAfterBattleStart = function(self, isMidway)
  -- function num : 0_2 , upvalues : _ENV
  if isMidway and self.caster ~= nil then
    self:PlayChipEffect()
    LuaSkillCtrl:AddPlayerTowerMp((self.arglist)[1])
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
  end
end

bs_10305.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10305

