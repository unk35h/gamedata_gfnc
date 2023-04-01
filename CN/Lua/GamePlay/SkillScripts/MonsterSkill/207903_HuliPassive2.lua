-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207903 = class("bs_207903", LuaSkillBase)
local base = LuaSkillBase
bs_207903.config = {buffId_csbuff = 207901, effectId_trail = 207904, time_heal = 4}
bs_207903.ctor = function(self)
  -- function num : 0_0
end

bs_207903.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_207903_10", 1, self.OnRoleDie)
end

bs_207903.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if role.belongNum == (self.caster).belongNum then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_trail, self, nil, role)
  end
  LuaSkillCtrl:StartTimer(nil, (self.config).time_heal, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_csbuff, 1)
  end
)
end

bs_207903.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207903

