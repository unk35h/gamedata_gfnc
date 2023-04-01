-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_106501 = class("bs_106501", LuaSkillBase)
local base = LuaSkillBase
bs_106501.config = {buffId_1 = 106501, buffId_1_ex = 106502, buffId_2 = 106503, buffId_3 = 106504, nanaka_buffId = 102603, buffId_live = 3009, buffId_4 = 106505, buffId_5 = 106506, hurtConfigId = 2, audioId1 = 106506}
bs_106501.ctor = function(self)
  -- function num : 0_0
end

bs_106501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSetDeadHurtTrigger("bs_106501_1", 900, self.OnSetDeadHurt, nil, self.caster)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_106501_2", 1, self.OnAfterBattleStart)
  self:AddLuaTrigger(eSkillLuaTrigger.OnLindHurt, self.OnLindHurt, self)
  self.time = 0
end

bs_106501.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 1, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, (self.arglist)[13], nil)
  end
)
end

bs_106501.OnLindHurt = function(self, id, target)
  -- function num : 0_3 , upvalues : _ENV
  if id < 3 then
    if (self.caster):GetBuffTier((self.config).buffId_1) < (self.arglist)[1] then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, 1, nil)
    else
      LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[2])
    end
    self.time = self.time + 1
    if (self.arglist)[3] <= self.time then
      self.time = self.time - (self.arglist)[3]
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_2, 1, nil)
    end
    if id == 1 and target ~= nil and target.hp > 0 then
      LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_3, 1, (self.arglist)[6])
    end
  end
  if id == 1 then
    local hurt = (self.arglist)[4]
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).hurtConfigId, {hurt})
    skillResult:EndResult()
  end
  do
    do
      if id == 3 then
        local num = (self.caster):GetBuffTier((self.config).buffId_1)
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1_ex, num)
      end
      if id == 4 then
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_1_ex, 0)
      end
      if id == 5 then
      end
    end
  end
end

bs_106501.OnSetDeadHurt = function(self, context)
  -- function num : 0_4 , upvalues : _ENV
  local NoDeath = LuaSkillCtrl:RoleContainsBuffFeature(context.target, eBuffFeatureType.NoDeath)
  if context.target == self.caster and (context.target):GetBuffTier((self.config).buffId_1) > 0 and (context.target):GetBuffTier((self.config).nanaka_buffId) <= 0 and (context.target):GetBuffTier((self.config).buffId_4) <= 0 and NoDeath == false then
    local powerNum = (self.caster):GetBuffTier((self.config).buffId_1)
    local liveTime = (self.arglist)[7] * (powerNum * (self.arglist)[8] + 1000) // 1000
    LuaSkillCtrl:PlayAuSource(self.caster, (self.config).audioId1)
    LuaSkillCtrl:CallBuff(self, context.target, (self.config).buffId_5, 1, liveTime, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_4, 1, (self.arglist)[9])
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_1, 0)
  end
end

bs_106501.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106501

