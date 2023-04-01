-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_105301 = class("bs_105301", LuaSkillBase)
local base = LuaSkillBase
bs_105301.config = {effect_trail1 = 105302, effect_trail2 = 105304, effect_trail3 = 105306, effectId_phase1 = 105308, effectId_phase2 = 105309, effectId_phase3 = 105310, effectId_getenergy = 105311, effectId_change = 105318, HurtConfigID1 = 3, HurtConfigID2 = 13}
bs_105301.ctor = function(self)
  -- function num : 0_0
end

bs_105301.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddLuaTrigger(eSkillLuaTrigger.OnCrypterAttack, self.OnCrypterAttack)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_105301_2", 1, self.OnAfterPlaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_105301_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_105301_3", 1, self.BeforeEndBattle)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).she2 = false
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).she3 = false
  local bind = self:GetSelfBindingObj()
  if bind ~= nil and ((self.caster).recordTable).she == nil then
    local sheArray = {}
    for i = 1, 3 do
      (table.insert)(sheArray, (bind.specialObj)[i])
    end
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.caster).recordTable).she = sheArray
  end
end

bs_105301.OnAfterBattleStart = function(self)
  -- function num : 0_2
  self.atk_num = 0
  self.energy_max = (self.arglist)[5]
  self.energy_num_max = (self.arglist)[4]
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).energy_num = 0
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).energy_P1 = (self.arglist)[4] / 2
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.caster).recordTable).energy_P2 = (self.arglist)[4]
end

bs_105301.SetDaShe = function(self, num)
  -- function num : 0_3 , upvalues : _ENV
  local sheArray = ((self.caster).recordTable).she
  if sheArray == nil then
    return 
  end
  if num ~= 1 and sheArray[1] ~= nil and (sheArray[1]).activeSelf ~= false then
    (sheArray[1]):SetActive(false)
  end
  if num ~= 2 and sheArray[2] ~= nil and (sheArray[2]).activeSelf ~= false then
    (sheArray[2]):SetActive(false)
  end
  if num ~= 3 and sheArray[3] ~= nil and (sheArray[3]).activeSelf ~= false then
    (sheArray[3]):SetActive(false)
  end
  if sheArray[num] ~= nil then
    if (sheArray[num]).activeSelf ~= true then
      (sheArray[num]):SetActive(true)
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_change, self)
  end
end

bs_105301.HideDaShe = function(self)
  -- function num : 0_4
  local sheArray = ((self.caster).recordTable).she
  if sheArray == nil then
    return 
  end
  if sheArray[1] ~= nil and (sheArray[1]).activeSelf ~= true then
    (sheArray[1]):SetActive(true)
  end
  if sheArray[2] ~= nil and (sheArray[2]).activeSelf ~= false then
    (sheArray[2]):SetActive(false)
  end
  if sheArray[3] ~= nil and (sheArray[3]).activeSelf ~= false then
    (sheArray[3]):SetActive(false)
  end
end

bs_105301.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  if role == self.caster and skill.isUltSkill then
    ((self.caster).recordTable).energy_num = ((self.caster).recordTable).energy_num + ((self.caster).recordTable).energy_Ult
    self.energy_num_max = ((self.caster).recordTable).energy_Ult + self.energy_num_max
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    if self.energy_max <= ((self.caster).recordTable).energy_num then
      ((self.caster).recordTable).energy_num = self.energy_max
    end
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_getenergy, self)
    self:ShowAttackCounting(((self.caster).recordTable).energy_num)
  end
  if role == self.caster and skill.isCommonAttack then
    self.atk_num = self.atk_num + 1
    if self.atk_num == (self.arglist)[1] then
      self.atk_num = 0
      -- DECOMPILER ERROR at PC71: Confused about usage of register: R3 in 'UnsetPending'

      if ((self.caster).recordTable).energy_num < self.energy_num_max then
        ((self.caster).recordTable).energy_num = ((self.caster).recordTable).energy_num + 1
        -- DECOMPILER ERROR at PC81: Confused about usage of register: R3 in 'UnsetPending'

        if self.energy_max <= ((self.caster).recordTable).energy_num then
          ((self.caster).recordTable).energy_num = self.energy_max
        end
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_getenergy, self)
        self:ShowAttackCounting(((self.caster).recordTable).energy_num)
      end
    end
  end
  if ((self.caster).recordTable).energy_P1 <= ((self.caster).recordTable).energy_num and ((self.caster).recordTable).energy_num < ((self.caster).recordTable).energy_P2 and ((self.caster).recordTable).she2 == false and ((self.caster).recordTable).she3 == false then
    self:SetDaShe(2)
    -- DECOMPILER ERROR at PC125: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).she2 = true
  end
  if ((self.caster).recordTable).energy_P2 <= ((self.caster).recordTable).energy_num and ((self.caster).recordTable).she3 == false then
    self:SetDaShe(3)
    -- DECOMPILER ERROR at PC144: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).she3 = true
    -- DECOMPILER ERROR at PC147: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).she2 = false
  end
end

bs_105301.OnCrypterAttack = function(self, target, sender, skill)
  -- function num : 0_6 , upvalues : _ENV
  if sender.hp <= 0 then
    return 
  end
  if ((self.caster).recordTable).energy_num < ((self.caster).recordTable).energy_P1 then
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effect_trail1, self, nil, false, self.Dodamage1)
  end
  if ((self.caster).recordTable).energy_P1 <= ((self.caster).recordTable).energy_num and ((self.caster).recordTable).energy_num < ((self.caster).recordTable).energy_P2 then
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effect_trail2, self, nil, false, self.Dodamage2)
  end
  if ((self.caster).recordTable).energy_P2 <= ((self.caster).recordTable).energy_num then
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effect_trail3, self, nil, false, self.Dodamage3)
  end
end

bs_105301.Dodamage1 = function(self, effect, eventId, target)
  -- function num : 0_7 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID2, {(self.arglist)[2] + ((self.caster).recordTable).energy_num * (self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_105301.Dodamage2 = function(self, effect, eventId, target)
  -- function num : 0_8 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID2, {(self.arglist)[2] + ((self.caster).recordTable).energy_num * (self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_105301.Dodamage3 = function(self, effect, eventId, target)
  -- function num : 0_9 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID2, {(self.arglist)[2] + ((self.caster).recordTable).energy_num * (self.arglist)[3]})
    skillResult:EndResult()
  end
end

bs_105301.ShowAttackCounting = function(self, nowCount)
  -- function num : 0_10 , upvalues : _ENV
  if nowCount == 0 then
    LuaSkillCtrl:HideCounting(self.caster)
    return 
  end
  if nowCount < ((self.caster).recordTable).energy_P2 then
    LuaSkillCtrl:ShowCounting(self.caster, nowCount, ((self.caster).recordTable).energy_P2)
    LuaSkillCtrl:SetCountingColor(self.caster, 255, 255, 255, 255)
  end
  if nowCount == ((self.caster).recordTable).energy_P2 then
    LuaSkillCtrl:ShowCounting(self.caster, nowCount, ((self.caster).recordTable).energy_P2)
    LuaSkillCtrl:SetCountingColor(self.caster, 0, 203, 250, 255)
  end
  do
    if ((self.caster).recordTable).energy_P2 < nowCount and nowCount < self.energy_max then
      local Count = nowCount % ((self.caster).recordTable).energy_P2
      LuaSkillCtrl:ShowCounting(self.caster, Count, ((self.caster).recordTable).energy_P2)
      LuaSkillCtrl:SetCountingColor(self.caster, 224, 64, 255, 255)
    end
    if nowCount == self.energy_max then
      LuaSkillCtrl:ShowCounting(self.caster, ((self.caster).recordTable).energy_P2, ((self.caster).recordTable).energy_P2)
      LuaSkillCtrl:SetCountingColor(self.caster, 224, 64, 255, 255)
    end
  end
end

bs_105301.BeforeEndBattle = function(self)
  -- function num : 0_11
  self:HideDaShe()
  self:ShowAttackCounting(0)
end

bs_105301.OnCasterDie = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnCasterDie)(self)
  self:HideDaShe()
  self:ShowAttackCounting(0)
end

return bs_105301

