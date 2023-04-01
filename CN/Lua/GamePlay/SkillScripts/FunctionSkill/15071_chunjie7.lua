-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15071 = class("bs_15071", LuaSkillBase)
local base = LuaSkillBase
bs_15071.config = {configId = 26, effectIdAttack = 10254}
bs_15071.ctor = function(self)
  -- function num : 0_0
end

bs_15071.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_104701_1", 1, self.OnSetHurt, nil, self.caster)
  self.pow_Num = 0
end

bs_15071.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.isMiss then
    local damage = (self.caster).maxHp
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, context.sender, (self.config).aoe_config)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).configId, {damage}, true)
    skillResult:EndResult()
  end
end

bs_15071.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15071

