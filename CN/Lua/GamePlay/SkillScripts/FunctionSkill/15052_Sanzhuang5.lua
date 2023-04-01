-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15052 = class("bs_15052", LuaSkillBase)
local base = LuaSkillBase
bs_15052.config = {buffId = 1243}
bs_15052.ctor = function(self)
  -- function num : 0_0
end

bs_15052.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15052_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_15052_2", 1, self.OnSetHurt, self.caster)
end

bs_15052.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[2], nil, true)
end

bs_15052.OnSetHurt = function(self, context)
  -- function num : 0_3 , upvalues : _ENV
  if context.sender == self.caster and context.isCrit then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  end
end

bs_15052.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15052

