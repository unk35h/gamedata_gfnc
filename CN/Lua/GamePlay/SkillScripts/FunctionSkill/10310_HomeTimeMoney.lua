-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10310 = class("bs_10310", LuaSkillBase)
local base = LuaSkillBase
bs_10310.config = {}
bs_10310.ctor = function(self)
  -- function num : 0_0
end

bs_10310.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10310_1", 1, self.OnAfterBattleStart)
  self.timer = nil
end

bs_10310.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.timer ~= nil then
    (self.timer):stop()
    self.timer = nil
  else
    self.timer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    LuaSkillCtrl:AddPlayerTowerMp((self.arglist)[2])
  end
, nil, -1, 0)
  end
end

bs_10310.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  if self.timer ~= nil then
    (self.timer):stop()
    self.timer = nil
  end
  ;
  (base.OnCasterDie)(self)
end

return bs_10310

