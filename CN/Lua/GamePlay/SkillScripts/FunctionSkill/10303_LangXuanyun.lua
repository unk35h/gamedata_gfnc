-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10303 = class("bs_10303", LuaSkillBase)
local base = LuaSkillBase
bs_10303.config = {buffId = 66}
bs_10303.ctor = function(self)
  -- function num : 0_0
end

bs_10303.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_10303_1", 1, self.OnAfterBattleStart)
end

bs_10303.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  self.caoTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], arriveCallBack, nil, -1, (self.arglist)[1])
end

bs_10303.OnArriveAction = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local GridId = LuaSkillCtrl:GetRoleEfcGrid(self.caster)
  if GridId == 1106 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[2])
  end
end

bs_10303.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_10303

