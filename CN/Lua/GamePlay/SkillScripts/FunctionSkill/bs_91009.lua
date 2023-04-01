-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_91009 = class("bs_91009", LuaSkillBase)
local base = LuaSkillBase
bs_91009.config = {}
bs_91009.ctor = function(self)
  -- function num : 0_0
end

bs_91009.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_91009_1", 1, self.OnAfterBattleStart)
end

bs_91009.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_91009.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local shieldValue = (self.caster).maxHp * (self.arglist)[2] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, shieldValue)
end

bs_91009.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_91009

