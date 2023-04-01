-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21035 = class("bs_21035", LuaSkillBase)
local base = LuaSkillBase
bs_21035.config = {buffId = 110024}
bs_21035.ctor = function(self)
  -- function num : 0_0
end

bs_21035.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_21035_1", 1, self.OnAfterBattleStart)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_21035_12", 1, self.OnAfterPlaySkill)
  self.Timer = nil
end

bs_21035.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
  self.Timer = LuaSkillCtrl:StartTimer(nil, 15, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    if (self.caster):GetBuffTier((self.config).buffId) <= 45 - (self.arglist)[1] // 10 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, (self.arglist)[1] // 10)
    end
  end
, nil, -1)
end

bs_21035.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  if role == self.caster and not skill.isCommonAttack then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_21035.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

bs_21035.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  if self.Timer ~= nil then
    (self.Timer):Stop()
    self.Timer = nil
  end
end

return bs_21035

