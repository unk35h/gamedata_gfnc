-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7012 = class("bs_7012", LuaSkillBase)
local base = LuaSkillBase
bs_7012.config = {formula = 10106, effectId = 10813, buffId = 1149}
bs_7012.ctor = function(self)
  -- function num : 0_0
end

bs_7012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_7012_2", 1, self.OnSetDeadHurt, nil, self.caster)
end

bs_7012.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target == self.caster then
    LuaSkillCtrl:CallEffect(context.target, (self.config).effectId, self)
    local healNum = LuaSkillCtrl:CallFormulaNumberWithSkill((self.config).formula, nil, context.target, self)
    LuaSkillCtrl:CallHeal(healNum, self, context.target, true)
    local buffId = LuaSkillCtrl:GetSkillBindBuffId(self)
    LuaSkillCtrl:DispelBuff(self.caster, buffId, 1)
  end
end

bs_7012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_7012

