-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206704 = class("bs_206704", LuaSkillBase)
local base = LuaSkillBase
bs_206704.config = {actionId_start = 1020, action_speed = 1, skill_time = 40, start_time = 23, effectId_sheild = 2067041, effectId_sheildBreak = 2067042, effectId_heal = 2067043, buffId_sheild = 2067041, buffId_sheildBreak = 2067042, buffId_lockCd = 2067043}
bs_206704.ctor = function(self)
  -- function num : 0_0
end

bs_206704.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.OnBreakShield, "bs_206704_1", 1, self.OnBreakShield)
  self:AddBuffDieTrigger("bs_206704_2", 1, self.OnBuffDie, nil, nil)
end

bs_206704.PlaySkill = function(self, data)
  -- function num : 0_2 , upvalues : _ENV
  self:AbandonSkillCdAutoReset(true)
  self:CallCasterWait((self.config).skill_time + (self.arglist)[2])
  local getSheild = BindCallback(self, self.GetSheild)
  LuaSkillCtrl:PlayAuSource(self.caster, 461)
  LuaSkillCtrl:CallRoleActionWithTrigger(self, self.caster, (self.config).actionId_start, 1, (self.config).start_time, getSheild)
  local callnextskill = BindCallback(self, self.EndSkillAndCallNext)
  LuaSkillCtrl:StartTimer(self, (self.arglist)[2] + (self.config).start_time, callnextskill)
end

bs_206704.EndSkillAndCallNext = function(self)
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

bs_206704.GetSheild = function(self)
  -- function num : 0_4 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_sheild, 1, (self.arglist)[2])
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_lockCd, 1, (self.arglist)[2])
  LuaSkillCtrl:StartShowSkillDurationTime(self, (self.arglist)[2])
  local sheild = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, sheild)
end

bs_206704.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_5 , upvalues : _ENV
  if shieldType ~= 3 or target ~= self.caster then
    return 
  end
  local isInSkill = (self.caster):GetBuffTier((self.config).buffId_sheild)
  if isInSkill <= 0 then
    return 
  end
  LuaSkillCtrl:PlayAuSource(self.caster, 463)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_sheild, 0)
end

bs_206704.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_6 , upvalues : _ENV
  do
    if buff.dataId == (self.config).buffId_sheild and removeType == eBuffRemoveType.Timeout and target == self.caster then
      local SelfShieldValue = LuaSkillCtrl:GetShield(self.caster, 3)
      LuaSkillCtrl:ClearShield(self.caster, 3)
      if SelfShieldValue > 0 then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_heal, self)
        LuaSkillCtrl:PlayAuSource(self.caster, 464)
        LuaSkillCtrl:CallHeal(SelfShieldValue, self, self.caster)
        self:CancleCasterWait()
        return 
      end
    end
    if buff.dataId == (self.config).buffId_sheild and removeType == eBuffRemoveType.Dispel and target == self.caster then
      self:CancleCasterWait()
      local bufftime = buff.curDurationTime
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_sheildBreak, 1, bufftime)
      return 
    end
  end
end

bs_206704.OnCasterDie = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_206704.LuaDispose = function(self)
  -- function num : 0_8 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_206704

