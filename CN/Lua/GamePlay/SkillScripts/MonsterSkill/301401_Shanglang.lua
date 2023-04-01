-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_301401 = class("bs_301401", LuaSkillBase)
local base = LuaSkillBase
bs_301401.config = {waveRadium = 30, waveTotalEffect = 10924, waveTotalEffectfan = 10925, waveEffect = 0, waveEffectBoom = 0, phaseMoveBuffId = 63, flyBuff = 110002, stunBuff = 1000, beatBackDurationTimePerGrid = 2, buffId_198 = 198, waringDelay = 30}
local WaveDir = {left = 1, right = -1}
bs_301401.ctor = function(self)
  -- function num : 0_0
end

bs_301401.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_301401_1", 1, self.OnStartBattle)
end

bs_301401.OnStartBattle = function(self)
  -- function num : 0_2 , upvalues : WaveDir, _ENV
  self.waveDir = WaveDir.left
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId_198, 1, nil, true)
end

bs_301401.CallNextWaveCountDown = function(self)
  -- function num : 0_3 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.WaveComing, eWaveType.entropyWave)
end

bs_301401.PlaySkill = function(self, data)
  -- function num : 0_4 , upvalues : _ENV
  local arriveCallBack = BindCallback(self, self.OnArriveAction)
  LuaSkillCtrl:StartTimer(nil, (self.config).waringDelay, arriveCallBack)
  self:CallNextWaveCountDown()
end

bs_301401.OnArriveAction = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local target = LuaSkillCtrl:GetTargetWithGrid(3, 2)
  if self.waveDir > 0 then
    LuaSkillCtrl:CallEffect(target, (self.config).waveTotalEffect, self)
  else
    LuaSkillCtrl:CallEffect(target, (self.config).waveTotalEffectfan, self)
  end
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.CallWave, self.waveDir, (self.config).effectId, true, true)
  self.waveDir = self.waveDir * -1
end

bs_301401.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_301401

