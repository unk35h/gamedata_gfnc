-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_93002 = class("bs_93002", LuaSkillBase)
local base = LuaSkillBase
bs_93002.config = {}
bs_93002.ctor = function(self)
  -- function num : 0_0
end

bs_93002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterBattleStart, "bs_93002_1", 1, self.OnAfterBattleStart)
end

bs_93002.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.timer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[2], arriveCallBack, nil, -1, (self.arglist)[2])
end

bs_93002.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.timer ~= nil and (self.timer):IsOver() then
    self.timer = nil
  end
  local sheildValue = (self.caster).maxHp * (self.arglist)[1] // 1000
  LuaSkillCtrl:AddRoleShield(self.caster, eShieldType.Normal, sheildValue)
end

bs_93002.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
  if self.timer ~= nil then
    (self.timer):Stop()
    self.timer = nil
  end
end

return bs_93002

