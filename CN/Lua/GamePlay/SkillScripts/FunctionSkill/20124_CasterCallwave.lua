-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20124 = class("bs_20124", LuaSkillBase)
local base = LuaSkillBase
bs_20124.config = {waveGrid = 1106, waveLeftEffect = 12013, waveRightEffect = 12012, beatBackDurationTimePerGrid = 2, waveInterval = 90, waveEffectStartTimer = 65, waveEffect = 12010}
local WaveDir = {left = 1, right = -1}
bs_20124.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_20124_1", 1, self.OnStartBattle)
end

bs_20124.OnStartBattle = function(self)
  -- function num : 0_1 , upvalues : WaveDir, _ENV
  self:MakeUpBorderData()
  self.waveDir = WaveDir.left
  LuaSkillCtrl:StartTimer(nil, (self.config).waveInterval, (BindCallback(self, self.CallWave)), nil, -1, 60)
  LuaSkillCtrl:StartTimer(nil, (self.config).waveInterval, (BindCallback(self, self.CallWaveEffect)), nil, -1, (self.config).waveEffectStartTimer)
  if not LuaSkillCtrl.IsInVerify then
    LuaSkillCtrl:StartTimer(nil, (self.config).waveInterval, (BindCallback(self, self.CallNextWaveCountDown)), nil, -1, (self.config).waveInterval)
  end
end

bs_20124.CallNextWaveCountDown = function(self)
  -- function num : 0_2 , upvalues : _ENV
  MsgCenter:Broadcast(eMsgEventId.WaveComing, eWaveType.normalWave)
end

bs_20124.MakeUpBorderData = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local border = LuaSkillCtrl:GetMapBorder()
  self.borderPosX = border.x - 1
  self.borderPosY = border.y - 1
end

bs_20124.CallWaveEffect = function(self)
  -- function num : 0_4 , upvalues : _ENV, WaveDir
  local gridTarget = LuaSkillCtrl:GetTargetWithGrid(0, 0)
  if self.waveDir == WaveDir.right then
    gridTarget = LuaSkillCtrl:GetTargetWithGrid(self.borderPosX - (self.borderPosY & 1), self.borderPosY)
    LuaSkillCtrl:CallEffect(gridTarget, (self.config).waveRightEffect, self)
  else
    LuaSkillCtrl:CallEffect(gridTarget, (self.config).waveLeftEffect, self)
  end
end

bs_20124.CallWave = function(self)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.CallWave, self.waveDir, (self.config).waveEffect)
  self.waveDir = self.waveDir * -1
end

bs_20124.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.waveDir = nil
  ;
  (base.LuaDispose)(self)
end

return bs_20124

