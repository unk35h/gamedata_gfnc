-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91013 = class("bs_91013", LuaSkillBase)
local base = LuaSkillBase
bs_91013.config = {buffId = 2011}
bs_91013.ctor = function(self)
  -- function num : 0_0
end

bs_91013.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_91013_11", 1, self.OnRoleDie)
end

bs_91013.OnRoleDie = function(self, killer, role, killSkill)
  -- function num : 0_2 , upvalues : _ENV
  if killer == self.caster and role.belongNum == 2 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
  end
end

bs_91013.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_91013

