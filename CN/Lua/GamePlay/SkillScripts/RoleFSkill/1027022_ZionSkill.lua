-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1027022 = class("bs_1027022", LuaSkillBase)
local base = LuaSkillBase
bs_1027022.config = {effectId1 = 10383, speed = 1, actionId = 1002, action_speed = 1, skill_time = 15, start_time = 16, audioId1 = 264, audio_loop = 265}
bs_1027022.ctor = function(self)
  -- function num : 0_0
end

bs_1027022.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_1027022.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBreakAllSkill(self.caster)
  self:CallCasterWait((self.config).skill_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  LuaSkillCtrl:StartTimer(self, 6, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self, nil, nil, (self.config).speed, true)
  end
)
end

bs_1027022.OnAttackTrigger = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local base = (self.caster).skill_intensity * (self.arglist)[1] // 1000
  local num = ((self.caster).maxHp - (self.caster).hp) * 1000 // (self.caster).maxHp * (self.arglist)[3] // (self.arglist)[2]
  local shieldValue = base * (1000 + num) // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue)
end

bs_1027022.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1027022

