-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21026 = class("bs_21026", LuaSkillBase)
local base = LuaSkillBase
bs_21026.config = {buffId = 110019}
bs_21026.ctor = function(self)
  -- function num : 0_0
end

bs_21026.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21026_1", 1, self.OnAfterBattleStart)
  self.Timer = nil
  if self.Timer ~= nil then
    (self.Timer):stop()
    self.Timer = nil
  end
end

bs_21026.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local buffTier = (self.arglist)[2] // 50
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, buffTier, nil)
  if self.Timer ~= nil then
    (self.Timer):stop()
    self.Timer = nil
  end
  local callback = BindCallback(self, self.FunSkill)
  self.Timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], callback, self, -1, 0)
end

bs_21026.FunSkill = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if (self.caster):GetBuffTier((self.config).buffId) > 0 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 1)
  else
    if self.Timer ~= nil then
      (self.Timer):Stop()
      self.Timer = nil
    end
  end
end

bs_21026.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

bs_21026.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21026

