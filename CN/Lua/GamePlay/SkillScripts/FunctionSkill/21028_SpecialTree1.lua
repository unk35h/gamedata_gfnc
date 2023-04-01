-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21028 = class("bs_21028", LuaSkillBase)
local base = LuaSkillBase
bs_21028.config = {buffId = 1059}
bs_21028.ctor = function(self)
  -- function num : 0_0
end

bs_21028.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetHurtTrigger("bs_21028_1", 2, self.OnSetHurt, self.caster)
end

bs_21028.OnSetHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster and not context.isMiss and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] and not context.isTriggerSet and (context.skill).isCommonAttack then
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId, 1, 75)
  end
end

bs_21028.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21028

