-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1033012 = class("bs_1033012", LuaSkillBase)
local base = LuaSkillBase
bs_1033012.config = {buffId_att = 10330401, buffId_int = 10330501}
bs_1033012.ctor = function(self)
  -- function num : 0_0
end

bs_1033012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_1033012_10", 1, self.OnRoleDie)
  self.record = {}
end

bs_1033012.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and role.intensity ~= 0 and killer.belongNum == (self.caster).belongNum then
    local pow_tier = role.pow * (self.arglist)[1] // 1000
    local int_tier = role.skill_intensity * (self.arglist)[1] // 1000
    if killer:GetBuffTier((self.config).buffId_att) > 0 or killer:GetBuffTier((self.config).buffId_int) > 0 then
      LuaSkillCtrl:DispelBuff(killer, (self.config).buffId_att, 0, true)
      LuaSkillCtrl:DispelBuff(killer, (self.config).buffId_int, 0, true)
    end
    if pow_tier > 0 then
      LuaSkillCtrl:CallBuff(self, killer, (self.config).buffId_att, pow_tier, nil, true)
    end
    if int_tier > 0 then
      LuaSkillCtrl:CallBuff(self, killer, (self.config).buffId_int, int_tier, nil, true)
    end
  end
end

bs_1033012.LuaDispose = function(self)
  -- function num : 0_3 , upvalues : base
  (base.LuaDispose)(self)
end

bs_1033012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1033012

