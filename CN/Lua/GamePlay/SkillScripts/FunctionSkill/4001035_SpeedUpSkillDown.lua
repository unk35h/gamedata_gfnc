-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001035 = class("bs_4001035", LuaSkillBase)
local base = LuaSkillBase
bs_4001035.config = {buffId = 2018}
bs_4001035.ctor = function(self)
  -- function num : 0_0
end

bs_4001035.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001035_1", 1, self.OnAfterBattleStart)
  self.flag = true
end

bs_4001035.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.flag == true then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[3])
    self.flag = false
  end
end

bs_4001035.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001035

