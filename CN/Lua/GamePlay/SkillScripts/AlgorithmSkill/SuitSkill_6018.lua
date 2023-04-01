-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6018 = class("bs_6018", LuaSkillBase)
local base = LuaSkillBase
bs_6018.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10078, crit_formula = 0, returndamage_formula = 0}
}
bs_6018.ctor = function(self)
  -- function num : 0_0
end

bs_6018.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.attack_num = 0
  self.ball = 0
  self:AddSetHurtTrigger("bs_6018_3", 1, self.OnSetHurt, self.caster)
end

bs_6018.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if (context.skill).isCommonAttack and self.caster == context.sender then
    self.attack_num = self.attack_num + 1
    local num = self.attack_num
    if self.attack_num % (self.arglist)[1] == 0 and self.ball < (self.arglist)[2] then
      self.ball = self.ball + 1
    end
  end
  do
    if context.sender == self.caster and (context.skill).isCommonAttack and self.ball ~= 0 then
      for i = 0, self.ball - 1 do
        local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
        local prob = (self.arglist)[3]
        LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {prob}, true)
        skillResult:EndResult()
      end
    end
  end
end

bs_6018.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_6018.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  self.ball = nil
end

return bs_6018

