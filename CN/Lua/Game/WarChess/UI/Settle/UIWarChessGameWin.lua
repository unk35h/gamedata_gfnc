-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessGameWin = class("UIWarChessGameWin", base)
UIWarChessGameWin.OnInit = function(self)
  -- function num : 0_0
end

UIWarChessGameWin.SetPlayOverCallback = function(self, callback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(1235)
  TimerManager:StartTimer(2, callback, self, true)
end

UIWarChessGameWin.OnDelete = function(self)
  -- function num : 0_2
end

return UIWarChessGameWin

