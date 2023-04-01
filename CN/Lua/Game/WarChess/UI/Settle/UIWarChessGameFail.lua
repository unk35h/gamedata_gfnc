-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessGameFail = class("UIWarChessGameFail", base)
UIWarChessGameFail.OnInit = function(self)
  -- function num : 0_0
end

UIWarChessGameFail.SetPlayOverCallback = function(self, callback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(1236)
  TimerManager:StartTimer(2, callback, self, true)
end

UIWarChessGameFail.OnDelete = function(self)
  -- function num : 0_2
end

return UIWarChessGameFail

