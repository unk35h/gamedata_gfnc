-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_210605 = class("bs_210605", LuaSkillBase)
local base = LuaSkillBase
bs_210605.config = {buffId_Boss = 3017, buffId_critcore = 210602, buffId_nocritcore = 210603, effectId_critcore_1 = 210609, effectId_critcore_2 = 210610, effectId_critcore_3 = 210611}
bs_210605.ctor = function(self)
  -- function num : 0_0
end

bs_210605.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_210605_2", 1, self.OnAfterHurt, nil, self.caster)
  self.crit_times = 0
  self.effect = nil
  self:AddAfterAddBuffTrigger("bs_210605_3", 1, self.OnAfterAddBuff, self.caster, self.caster, nil, nil, (self.config).buffId_critcore)
  self:AddBeforeBuffDispelTrigger("bs_210605_4", 1, self.OnBeforBuffDispel, self.caster, nil, (self.config).buffId_critcore)
  self:AddBeforeAddBuffTrigger("bs_210605_5", 1, self.OnBeforeAddBuff, nil, self.caster, nil, nil, (self.config).buffId_critcore)
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_critcore, 1, nil)
  self.Addcrit_times = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], (BindCallback(self, self.Addcrit_times)), nil, -1, 0)
end

bs_210605.Addcrit_times = function(self)
  -- function num : 0_2
  if self.crit_times > 0 then
    self.crit_times = self.crit_times - 1
    self:ShowAttackCounting(self.crit_times)
  end
end

bs_210605.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if target == self.caster and not isMiss and hurt > 0 and isCrit and (self.caster):GetBuffTier((self.config).buffId_critcore) > 0 then
    self.crit_times = self.crit_times + 1
    if self.crit_times == 10 then
      LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_critcore, 1)
      self.crit_times = 0
    end
    self:ShowAttackCounting(self.crit_times)
  end
end

bs_210605.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId_nocritcore) > 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_nocritcore, 1)
  end
  local buffnum = target:GetBuffTier((self.config).buffId_critcore)
  if buffnum == 1 then
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_critcore_1, self)
  else
    if buffnum == 2 then
      if self.effect ~= nil then
        (self.effect):Die()
        self.effect = nil
      end
      self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_critcore_2, self)
    else
      if buffnum == 3 then
        if self.effect ~= nil then
          (self.effect):Die()
          self.effect = nil
        end
        self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_critcore_3, self)
      end
    end
  end
end

bs_210605.OnBeforBuffDispel = function(self, target, context)
  -- function num : 0_5 , upvalues : _ENV
  local buffnum = target:GetBuffTier((self.config).buffId_critcore)
  if buffnum == 3 then
    if self.effect ~= nil then
      (self.effect):Die()
      self.effect = nil
    end
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_critcore_2, self)
  else
    if buffnum == 2 then
      if self.effect ~= nil then
        (self.effect):Die()
        self.effect = nil
      end
      self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_critcore_1, self)
    else
      if buffnum == 1 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_nocritcore, 1, nil)
        if self.effect ~= nil then
          (self.effect):Die()
          self.effect = nil
        end
        self.crit_times = 0
        self:ShowAttackCounting(self.crit_times)
      end
    end
  end
end

bs_210605.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_6
  local buffnum = target:GetBuffTier((self.config).buffId_critcore)
  if buffnum >= 2 then
    self.crit_times = 0
    self:ShowAttackCounting(self.crit_times)
  end
end

bs_210605.ShowAttackCounting = function(self, Count)
  -- function num : 0_7 , upvalues : _ENV
  if LuaSkillCtrl.IsInVerify then
    return 
  end
  if Count == 0 then
    LuaSkillCtrl:HideCounting(self.caster)
    return 
  end
  LuaSkillCtrl:ShowCounting(self.caster, Count, 10)
end

bs_210605.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:HideCounting(self.caster)
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
  if self.Addcrit_times ~= nil then
    (self.Addcrit_times):Stop()
    self.Addcrit_times = nil
  end
end

bs_210605.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.effect = nil
end

return bs_210605

