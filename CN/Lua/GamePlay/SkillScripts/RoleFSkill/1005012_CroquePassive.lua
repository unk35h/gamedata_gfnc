-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1005012 = class("bs_1005012", base)
bs_1005012.config = {
heal_config = {baseheal_formula = 100501}
, heal_time = 15}
bs_1005012.ctor = function(self)
  -- function num : 0_0
end

bs_1005012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1005012_1", 1, self.OnAfterBattleStart)
end

bs_1005012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.passive = LuaSkillCtrl:StartTimer(nil, (self.config).heal_time, self.Callback, self, -1)
end

bs_1005012.Callback = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.passive ~= nil and (self.passive):IsOver() then
    self.passive = nil
  end
  local num = 0
  if ((self.caster).recordTable).peopleNum ~= nil and ((self.caster).recordTable).peopleNum ~= 0 then
    num = ((self.caster).recordTable).peopleNum
  end
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
  LuaSkillCtrl:HealResult(skillResult, (self.config).heal_config, {num}, true)
  skillResult:EndResult()
end

bs_1005012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
  ;
  (base.OnCasterDie)(self)
end

bs_1005012.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  if self.passive ~= nil then
    (self.passive):Stop()
    self.passive = nil
  end
end

return bs_1005012

