-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_200404 = class("bs_200404", LuaSkillBase)
local base = LuaSkillBase
bs_200404.config = {buffId_1005 = 1005, timeDuration = 15}
bs_200404.ctor = function(self)
  -- function num : 0_0
end

bs_200404.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_200404_10", 1, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_200404_1", 1, self.OnAfterBattleStart)
end

bs_200404.OnRoleDie = function(self, killer, role)
  -- function num : 0_2 , upvalues : _ENV
  if killer == self.caster and role.belongNum == 1 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_1005, (self.arglist)[1], nil, true)
  end
end

bs_200404.OnAfterBattleStart = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timeValue = 450
  self.totalTime = 450
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).timeDuration, arriveCallBack, self, -1)
  local timeCallBack = BindCallback(self, self.TimeUp)
  LuaSkillCtrl:StartTimer(nil, self.totalTime, timeCallBack)
end

bs_200404.OnArriveAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
end

bs_200404.TimeUp = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:ForceEndBattle(true)
end

bs_200404.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:ForceEndBattle(true)
end

return bs_200404

