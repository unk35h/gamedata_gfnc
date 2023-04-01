-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010403 = class("bs_4010403", LuaSkillBase)
local base = LuaSkillBase
bs_4010403.config = {}
bs_4010403.ctor = function(self)
  -- function num : 0_0
end

bs_4010403.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_4010403_1", 1, self.OnAfterBattleStart)
end

bs_4010403.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.caster ~= nil then
    local value = (self.caster).maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, value)
  end
end

bs_4010403.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010403

