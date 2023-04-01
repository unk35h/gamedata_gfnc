-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_70009 = class("bs_70009", LuaSkillBase)
local base = LuaSkillBase
bs_70009.config = {timeDuration = 15, animID = 1002, animLoopTime = 30, formula1 = 10153, formula2 = 10154, formula3 = 10155, audioId1 = 389, audioId2 = 390}
bs_70009.ctor = function(self)
  -- function num : 0_0
end

bs_70009.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.totalTime = (self.arglist)[2]
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, arriveCallBack, self, -1)
  local timeCallBack = BindCallback(self, self.TimeUp)
  LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
  local arriveCallBack2 = BindCallback(self, self.OnProAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).animLoopTime, arriveCallBack2, self, -1)
  self:AddSetHealTrigger("bs_70009_5", 1, self.OnSetHeal, nil, self.caster)
  self:AddSetHurtTrigger("bs_70009_2", 30, self.OnSetHurt, nil, self.caster)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_70009.OnSetHeal = function(self, context)
  -- function num : 0_2
  if context.target == self.caster then
    context.heal = 0
  end
end

bs_70009.OnSetHurt = function(self, context)
  -- function num : 0_3
  if context.target == self.caster then
    local hurt = (self.caster).maxHp // (self.arglist)[1] + 1
    context.hurt = hurt
  end
end

bs_70009.OnProAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallRoleAction(self.caster, (self.config).animID)
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
  local playVFX = BindCallback(self, self.OnPlayVFX)
  LuaSkillCtrl:StartTimer(nil, 12, playVFX, self)
end

bs_70009.OnPlayVFX = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId2)
  LuaSkillCtrl:BattlegroundDrop((self.caster).curCoord, 3, "FXP_Common_diaoluo")
end

bs_70009.OnArriveAction = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_70009.TimeUp = function(self)
  -- function num : 0_7 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_70009.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:ForceEndBattle(false)
end

return bs_70009

