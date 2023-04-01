-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106401 = class("bs_106401", LuaSkillBase)
local base = LuaSkillBase
bs_106401.config = {effectId3 = 106410, hurtConfig = 2}
bs_106401.ctor = function(self)
  -- function num : 0_0
end

bs_106401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106401_Roll"] = (self.arglist)[2]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable)["106401_TIME"] = (self.arglist)[3]
  self:AddLuaTrigger(eSkillLuaTrigger.OnHorizonCauseBacklash, self.OnHorizonCauseBacklash)
end

bs_106401.OnHorizonCauseBacklash = function(self, target)
  -- function num : 0_2 , upvalues : _ENV
  if target ~= nil and target.hp > 0 then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfig, {(self.arglist)[1]})
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId3, self)
  end
end

bs_106401.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_106401.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_106401

