-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206702 = class("bs_206702", LuaSkillBase)
local base = LuaSkillBase
bs_206702.config = {actionId_start = 1002, start_time = 5, skill_time = 20, effectId_start = 2067021, buffId_critical = 2067021}
bs_206702.ctor = function(self)
  -- function num : 0_0
end

bs_206702.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_206702.PlaySkill = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:AbandonSkillCdAutoReset(true)
  self:CallCasterWait((self.config).skill_time)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger)
  LuaSkillCtrl:PlayAuSource(self.caster, 459)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, 1, (self.config).start_time, attackTrigger)
  LuaSkillCtrl:StartTimer(nil, (self.config).skill_time, function()
    -- function num : 0_2_0 , upvalues : self
    self:EndSkillAndCallNext()
  end
)
end

bs_206702.EndSkillAndCallNext = function(self)
  -- function num : 0_3
  if self.caster == nil then
    return 
  end
  self:CancleCasterWait()
  local skillMgr = (self.caster):GetSkillComponent()
  if skillMgr == nil then
    return 
  end
  skillMgr.lastSkill = self.cskill
  self:CallNextBossSkill()
end

bs_206702.OnAttackTrigger = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_start, self)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critical, 1, (self.arglist)[1])
end

bs_206702.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_206702.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_206702

