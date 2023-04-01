-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_2004031 = class("bs_2004031", LuaSkillBase)
local base = LuaSkillBase
bs_2004031.config = {
hurt_config = {basehurt_formula = 10007, hit_formula = 0, crit_formula = 0, correct_formula = 9989}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
, effectId = 10101, hitEffectId = 10100, buffId_66 = 66, buffId_151 = 151, buffTier = 1, startAnimID = 1002, audioId1 = 53, skill_time = 50, start_time = 7, skill_speed = 1, strikeBackTime = 3, timeDuration = 15}
bs_2004031.ctor = function(self)
  -- function num : 0_0
end

bs_2004031.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, arriveCallBack, self, -1)
  local timeCallBack = BindCallback(self, self.TimeUp)
  LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_2004031.OnArriveAction = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_2004031.TimeUp = function(self)
  -- function num : 0_3 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(false)
end

bs_2004031.PlaySkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  local attackTrigger = BindCallback(self, self.OnAttackTrigger, self.caster, data)
  self:CallCasterWait((self.config).skill_time)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self, nil, nil, nil, true)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).startAnimID, (self.config).skill_speed, (self.config).start_time, attackTrigger)
end

bs_2004031.OnAttackTrigger = function(self, target, data)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target, (self.config).aoe_config)
  LuaSkillCtrl:PlayAuHit(self, target)
  if target.hp > 0 then
    skillResult:BuffResult((self.config).buffId_151, (self.config).buffTier, (self.config).strikeBackTime)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config)
  end
  if (skillResult.roleList).Count > 0 then
    for i = 0, (skillResult.roleList).Count - 1 do
      local role = (skillResult.roleList)[i]
      LuaSkillCtrl:CallEffect(role, (self.config).hitEffectId, self)
    end
  end
  do
    skillResult:EndResult()
  end
end

bs_2004031.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2004031

