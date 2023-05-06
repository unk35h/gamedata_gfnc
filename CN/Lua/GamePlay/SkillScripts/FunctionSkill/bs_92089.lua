-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92089 = class("bs_92089", LuaSkillBase)
local base = LuaSkillBase
bs_92089.config = {}
bs_92089.ctor = function(self)
  -- function num : 0_0
end

bs_92089.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_92089_1", 1, self.OnAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
  self:AddSetHurtTrigger("bs_92089_2", 20, self.OnSetHurt, self.caster)
  self.PowerHit = 0
end

bs_92089.OnAfterMove = function(self)
  -- function num : 0_2
  if self.PowerHit < 1 then
    self.PowerHit = (self.arglist)[1]
  end
end

bs_92089.OnRoleSplash = function(self, role, grid)
  -- function num : 0_3
  if role == self.caster and self.PowerHit < 1 then
    self.PowerHit = (self.arglist)[1]
  end
end

bs_92089.OnSetHurt = function(self, context)
  -- function num : 0_4
  if self.PowerHit >= 1 then
    context.hurt = context.hurt + context.hurt * (self.arglist)[2] // 1000
    self.PowerHit = self.PowerHit - 1
  end
end

bs_92089.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92089

