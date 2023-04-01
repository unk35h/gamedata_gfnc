-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7010 = class("bs_7010", LuaSkillBase)
local base = LuaSkillBase
bs_7010.config = {
HurtConfig = {hit_formula = 0, basehurt_formula = 10183, minhurt_formula = 0, crit_formula = 0, correct_formula = 0, lifesteal_formula = 0, spell_lifesteal_formula = 0, returndamage_formula = 0}
, buffId = 1227}
bs_7010.ctor = function(self)
  -- function num : 0_0
end

bs_7010.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, self, -1)
end

bs_7010.OnArriveAction = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local highAttRole = LuaSkillCtrl:CallTargetSelect(self, 54, 20)
  if highAttRole ~= nil and highAttRole.Count > 0 and highAttRole[0] ~= nil then
    local skill_intensity = ((highAttRole[0]).targetRole).skill_intensity
    local buffTier = (self.caster):GetBuffTier((self.config).buffId)
    local damageArg = skill_intensity * buffTier
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {damageArg}, true, true)
    skillResult:EndResult()
  end
end

bs_7010.OnSkillRemove = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnSkillRemove)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

bs_7010.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_7010

