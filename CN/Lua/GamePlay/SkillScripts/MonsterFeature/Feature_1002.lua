-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1002 = class("bs_1002", LuaSkillBase)
local base = LuaSkillBase
bs_1002.config = {buffId_atk = 501}
bs_1002.ctor = function(self)
  -- function num : 0_0
end

bs_1002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1002", 9, self.OnAfterHurt, nil, self.caster, nil, nil, nil, nil, nil, nil, false)
end

bs_1002.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isTriggerSet ~= true and hurt > 0 and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[1] then
    LuaSkillCtrl:CallBuff(self, sender, (self.config).buffId_atk, 1, (self.arglist)[2])
  end
end

bs_1002.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1002

