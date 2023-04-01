-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_207701 = class("bs_207701", LuaSkillBase)
local base = LuaSkillBase
bs_207701.config = {buffId_Invisibility = 3004, skill_time = 19, start_time = 11, actionId = 1020, action_speed = 1, audioId = 207703}
bs_207701.ctor = function(self)
  -- function num : 0_0
end

bs_207701.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_207701_AfterHurt", 1, self.OnAfterHurt, nil, self.caster)
end

bs_207701.OnAfterBattleStart = function(self)
  -- function num : 0_2
end

bs_207701.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target == self.caster and hurt > 0 and isTriggerSet == true then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_Invisibility, 1, true)
  end
end

bs_207701.PlaySkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId, (self.config).action_speed, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:StartTimer(self, (self.config).start_time, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId)
  end
)
end

bs_207701.OnAttackTrigger = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_Invisibility, 1, (self.arglist)[1], true)
end

bs_207701.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_207701

