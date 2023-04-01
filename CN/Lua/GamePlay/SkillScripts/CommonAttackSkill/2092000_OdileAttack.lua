-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_2092000 = class("bs_2092000", bs_1)
local base = bs_1
bs_2092000.config = {effectId_trail = 209201, timeDuration = 15}
bs_2092000.config = setmetatable(bs_2092000.config, {__index = base.config})
bs_2092000.ctor = function(self)
  -- function num : 0_0
end

bs_2092000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_2092000_1", 1, self.OnAfterBattleStart)
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_2092000.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CountDown)), nil, 119, 15)
end

bs_2092000.CountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.timeValue <= 0 then
    LuaSkillCtrl:ForceEndBattle(false)
  end
end

bs_2092000.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2092000

