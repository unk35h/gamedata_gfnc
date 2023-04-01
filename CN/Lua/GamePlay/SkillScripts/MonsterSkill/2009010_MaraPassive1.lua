-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_200001 = require("GamePlay.SkillScripts.MonsterSkill.200001_Boss_mianyi")
local bs_2009010 = class("bs_2009010", bs_200001)
local base = bs_200001
bs_2009010.config = {timeDuration = 15}
bs_2009010.config = setmetatable(bs_2009010.config, {__index = base.config})
bs_2009010.ctor = function(self)
  -- function num : 0_0
end

bs_2009010.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).Roll = (self.arglist)[1]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).arg = (self.arglist)[2]
  self.totalTime = 1800
  self.timeValue = self.totalTime
  LuaSkillCtrl:SetGameScoreAcitve(2, true)
  LuaSkillCtrl:SetGameScoreValue(2, self.timeValue // 15)
  LuaSkillCtrl:RecordLimitTime(self.totalTime)
end

bs_2009010.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  (base.OnAfterBattleStart)(self)
  LuaSkillCtrl:StartTimer(nil, 15, (BindCallback(self, self.CountDown)), nil, 119, 15)
end

bs_2009010.CountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self.timeValue = self.timeValue - (self.config).timeDuration
  local showTime = self.timeValue // 15
  LuaSkillCtrl:SetGameScoreValue(2, showTime)
  if self.timeValue <= 0 then
    LuaSkillCtrl:ForceEndBattle(false)
  end
end

bs_2009010.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_2009010

