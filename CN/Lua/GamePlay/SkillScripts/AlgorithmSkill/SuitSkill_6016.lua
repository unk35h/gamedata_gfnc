-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6016 = class("bs_6016", LuaSkillBase)
local base = LuaSkillBase
bs_6016.config = {}
bs_6016.ctor = function(self)
  -- function num : 0_0
end

bs_6016.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_6016_3", 1, self.OnSetHurt, self.caster)
end

bs_6016.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.hurt <= 0 then
    return 
  end
  if (context.sender).maxHp < (context.target).maxHp and context.sender == self.caster and not context.isTriggerSet and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.target)
    local hurt = LuaSkillCtrl:CallFormulaNumber("ceil((#maxHp/@maxHp*3/100+6/100)*$1)-1", self.caster, context.target, context.hurt)
    local hurt2 = LuaSkillCtrl:CallFormulaNumber("ceil(20*$1/100)-1", self.caster, context.target, context.hurt)
    if hurt2 < hurt then
      hurt = hurt2
    end
    if context.hurt_type == eHurtType.PhysicsDmg then
      LuaSkillCtrl:RemoveLife(hurt, self, context.target, true, nil, true, nil, 0)
    end
    if context.hurt_type == eHurtType.MagicDmg then
      LuaSkillCtrl:RemoveLife(hurt, self, context.target, true, nil, true, nil, 1)
    end
  end
end

bs_6016.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6016

