-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21083 = class("bs_21083", LuaSkillBase)
local base = LuaSkillBase
bs_21083.config = {gridId = 1, buffId = 110035}
bs_21083.ctor = function(self)
  -- function num : 0_0
end

bs_21083.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21083_1", 1, self.OnAfterBattleStart)
  self.Num = 0
  if LuaSkillCtrl:GetRoleEfcGrid(self.caster) == (self.config).gridId then
    self.Num = 1
  end
end

bs_21083.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Num == 1 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[1] // 50, nil)
  end
end

bs_21083.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21083

