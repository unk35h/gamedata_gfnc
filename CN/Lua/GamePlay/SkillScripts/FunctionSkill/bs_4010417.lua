-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4010417 = class("bs_4010417", LuaSkillBase)
local base = LuaSkillBase
bs_4010417.config = {buffId = 2073}
bs_4010417.ctor = function(self)
  -- function num : 0_0
end

bs_4010417.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddOnRoleDieTrigger("bs_4010417_1", 10, self.OnRoleDie, self.caster)
end

bs_4010417.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.roleType ~= eBattleRoleType.character then
    return 
  end
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[1], nil, false)
end

bs_4010417.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4010417

