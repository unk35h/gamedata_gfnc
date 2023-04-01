-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10297 = class("bs_10297", LuaSkillBase)
local base = LuaSkillBase
bs_10297.config = {buffId_shixue = 257}
bs_10297.ctor = function(self)
  -- function num : 0_0
end

bs_10297.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.BeforePlaySkill, "bs_10297_1", 1, self.OnBeforePlaySkill)
  self:AddTrigger(eSkillTriggerType.OnSelfAfterMove, "bs_10297_2", 2, self.OnSelfAfterMove)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRoleSplash, self.OnRoleSplash)
  self.moveText = 0
end

bs_10297.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2 , upvalues : _ENV
  if role == self.caster and role ~= nil and role.hp > 0 and self.moveText == 1 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_shixue, (self.arglist)[1], nil, true)
    self.moveText = 0
  end
end

bs_10297.OnSelfAfterMove = function(self)
  -- function num : 0_3
  if self.caster ~= nil and (self.caster).hp > 0 then
    self.moveText = 1
  end
end

bs_10297.OnRoleSplash = function(self, role, grid)
  -- function num : 0_4
  if self.caster ~= nil and (self.caster).hp > 0 then
    self.moveText = 1
  end
end

bs_10297.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10297

