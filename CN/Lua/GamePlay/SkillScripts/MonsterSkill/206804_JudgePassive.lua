-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_206804 = class("bs_206804", LuaSkillBase)
local base = LuaSkillBase
bs_206804.config = {buffId_crime = 206804, buffId_punish = 206805, buffId_stun = 206803, buffId_bati = 206800, effectId_mask = 2068013, timeDuration = 15}
bs_206804.ctor = function(self)
  -- function num : 0_0
end

bs_206804.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_206804_1", 1, self.OnAfterBattleStart)
  self:AddSelfTrigger(eSkillTriggerType.OnBreakShield, "bs_206804_2", 1, self.OnBreakShield)
  self:AddSelfTrigger(eSkillTriggerType.BuffDie, "bs_206804_3", 1, self.OnBuffDie)
  self.Mask = nil
  self.MaskEffect = nil
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_bati, 1)
  ;
  (self.caster):AddRoleProperty(eHeroAttr.cd_reduce, 1000, eHeroAttrType.Extra)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).shieldValue = (self.caster).maxHp * (self.arglist)[1] // 1000
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_206804.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CountDown)), nil, 119, 15)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).mask = 1
  self.Mask = LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_crime, 1, nil, true)
  self.MaskEffect = ((self.Mask).listBattleEffect)[1]
  local MaskEffectNum = 0
  LuaSkillCtrl:EffectSetCountActive(self.MaskEffect, MaskEffectNum, true)
  local shieldValue = ((self.caster).recordTable).shieldValue
  local Shield = LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, shieldValue, 206801)
end

bs_206804.OnBreakShield = function(self, shieldType, sender, target)
  -- function num : 0_3 , upvalues : _ENV
  if shieldType == 3 and target == self.caster then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_stun, 1, (self.arglist)[2], false)
    if ((self.caster).recordTable).mask == 1 then
      local maskEffectDie = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_mask, self)
      local MaskEffectNum = 2
      LuaSkillCtrl:EffectSetCountActive(maskEffectDie, MaskEffectNum, true)
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_crime, 1)
    end
    do
      if ((self.caster).recordTable).mask == 2 then
        local maskEffectDie = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_mask, self)
        local MaskEffectNum = 3
        LuaSkillCtrl:EffectSetCountActive(maskEffectDie, MaskEffectNum, true)
        LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_punish, 1)
      end
    end
  end
end

bs_206804.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if buff.dataId ~= (self.config).buffId_stun then
    return 
  end
  if ((self.caster).recordTable).mask == 1 then
    self.Mask = LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_punish, 1, nil, true)
    self.MaskEffect = ((self.Mask).listBattleEffect)[1]
    local MaskEffectNum = 1
    LuaSkillCtrl:EffectSetCountActive(self.MaskEffect, MaskEffectNum, true)
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.caster).recordTable).mask = 2
    local shieldValue = ((self.caster).recordTable).shieldValue
    LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, shieldValue, 206801)
    return 
  end
  do
    if ((self.caster).recordTable).mask == 2 then
      self.Mask = LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_crime, 1, nil, true)
      self.MaskEffect = ((self.Mask).listBattleEffect)[1]
      local MaskEffectNum = 0
      LuaSkillCtrl:EffectSetCountActive(self.MaskEffect, MaskEffectNum, true)
      -- DECOMPILER ERROR at PC77: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.caster).recordTable).mask = 1
      local shieldValue = ((self.caster).recordTable).shieldValue
      LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Beelneith, shieldValue, 206801)
      return 
    end
  end
end

bs_206804.CountDown = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.timeValue <= 0 then
    LuaSkillCtrl:ForceEndBattle(false)
  end
end

bs_206804.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  (base.LuaDispose)(self)
  self.Mask = nil
  self.MaskEffect = nil
end

return bs_206804

