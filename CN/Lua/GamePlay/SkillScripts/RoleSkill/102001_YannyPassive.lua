-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_102001 = class("bs_102001", LuaSkillBase)
local base = LuaSkillBase
bs_102001.config = {buffId = 102001, healBuffId = 102002}
bs_102001.ctor = function(self)
  -- function num : 0_0
end

bs_102001.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_102001_1", 1, self.OnAfterBattleStart)
  self:AddSetHealTrigger("bs_102001_2", 99, self.OnSetHeal, nil, self.caster)
end

bs_102001.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
end

bs_102001.OnSetHeal = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.target == self.caster and context.isTriggerSet ~= true then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).healBuffId, 1, (self.arglist)[3])
  end
end

bs_102001.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_102001

