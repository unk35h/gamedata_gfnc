-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001405 = class("bs_4001405", LuaSkillBase)
local base = LuaSkillBase
bs_4001405.config = {}
bs_4001405.ctor = function(self)
  -- function num : 0_0
end

bs_4001405.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4001405_1", 1, self.OnAfterBattleStart)
end

bs_4001405.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster ~= nil and (self.caster).maxHp > 0 then
    local value = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, value)
  end
end

bs_4001405.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001405

