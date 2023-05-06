-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4020002 = class("bs_4020002", LuaSkillBase)
local base = LuaSkillBase
bs_4020002.config = {buffId = 2090, buffId2 = 2091, effectId = 12074, HurtConfigId = 14}
bs_4020002.ctor = function(self)
  -- function num : 0_0
end

bs_4020002.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_4020002_1", 1, self.OnBattleStart)
  self.timer = nil
end

bs_4020002.OnBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.eventFunc)
  self.timer = LuaSkillCtrl:StartTimer(self, (self.arglist)[1], arriveCallBack, nil, -1)
end

bs_4020002.eventFunc = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local target = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId, 1, (self.arglist)[2], true)
    LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId2, 1, 4, true)
  end
end

bs_4020002.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_4020002.LuaDispose = function(self)
  -- function num : 0_5 , upvalues : base
  (base.LuaDispose)(self)
  self.timer = nil
end

return bs_4020002

