-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_208009 = class("bs_208009", LuaSkillBase)
local base = LuaSkillBase
bs_208009.config = {buffId_passive = 208001}
bs_208009.ctor = function(self)
  -- function num : 0_0
end

bs_208009.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_208009_1", 1, self.OnAfterHurt, nil, self.caster)
  self:AddTrigger(eSkillTriggerType.OnAfterShieldHurt, "bs_208009_13", 1, self.OnAfterShieldHurt)
end

bs_208009.OnAfterShieldHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.target ~= nil and (context.target).hp > 0 and context.target == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_passive, 1)
  end
end

bs_208009.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target ~= nil and target.hp > 0 and target == self.caster and hurt > 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_passive, 1)
  end
end

bs_208009.PlaySkill = function(self, data)
  -- function num : 0_4
end

bs_208009.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208009

