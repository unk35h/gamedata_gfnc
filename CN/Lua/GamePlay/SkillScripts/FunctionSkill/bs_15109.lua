-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15109 = class("bs_15109", LuaSkillBase)
local base = LuaSkillBase
bs_15109.config = {effectId = 12063}
bs_15109.ctor = function(self)
  -- function num : 0_0
end

bs_15109.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15109_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_15109_10", 1, self.OnRoleDie)
  self.time = 0
  self.money = 0
end

bs_15109.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    self.time = 1
    self:RemoveSkillTrigger(eSkillTriggerType.RoleDie)
  end
, 1)
end

bs_15109.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.belongNum == eBattleRoleBelong.enemy and self.time == 0 then
    self.money = (self.arglist)[3] + self.money
    LuaSkillCtrl:SetCacheGold(self.money)
    LuaSkillCtrl:CallEffect(role, (self.config).effectId, self)
  end
end

bs_15109.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_15109

