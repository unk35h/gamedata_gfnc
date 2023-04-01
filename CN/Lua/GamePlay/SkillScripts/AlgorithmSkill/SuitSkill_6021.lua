-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6021 = class("bs_6021", LuaSkillBase)
local base = LuaSkillBase
bs_6021.config = {buffId_1 = 602101, buffId_2 = 602102, buffId_3 = 602103}
bs_6021.ctor = function(self)
  -- function num : 0_0
end

bs_6021.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_6021_1", 1, self.OnAfterBattleStart)
  self:AddAfterPlaySkillTrigger("bs_6021_13", 1, self.OnAfterPlaySkill, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.normalSkill)
end

bs_6021.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1, 1, nil, true)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function()
    -- function num : 0_2_0 , upvalues : self
    self:AddBuff()
  end
, self, -1)
end

bs_6021.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_3 , upvalues : _ENV
  local num = (self.caster):GetBuffTier((self.config).buffId_2)
  if num > 0 then
    LuaSkillCtrl:StartTimer(nil, (self.arglist)[5], function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId_2, 0, true)
    if self.timer ~= nil then
      (self.timer):Stop()
      self.timer = nil
      self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], function()
      -- function num : 0_3_0_0 , upvalues : self
      self:AddBuff()
    end
, self, -1)
    end
  end
)
  end
end

bs_6021.AddBuff = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (self.caster):GetBuffTier((self.config).buffId_2) < (self.arglist)[4] then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_2, 1, nil, true)
  end
end

bs_6021.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_6021

