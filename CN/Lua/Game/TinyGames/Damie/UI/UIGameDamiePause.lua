-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGameDamiePause = class("UINFlappyPause", UIBaseNode)
local base = UIBaseNode
UIGameDamiePause.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnPauseExit)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Continue, self, self.OnResume)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Restart, self, self.RestartGame)
end

UIGameDamiePause.ShowScore = function(self, score)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Score).text = tostring(score)
end

UIGameDamiePause.RestartGame = function(self)
  -- function num : 0_2
  self:HideAndBack()
  if self.__restartAction ~= nil then
    (self.__restartAction)()
  end
end

UIGameDamiePause.InjectPauseAction = function(self, resumeAction, restartAction, exitAction)
  -- function num : 0_3
  self.__resumeAction = resumeAction
  self.__restartAction = restartAction
  self.__exitAction = exitAction
end

UIGameDamiePause.OnPauseExit = function(self)
  -- function num : 0_4
  self:HideAndBack()
  if self.__exitAction ~= nil then
    (self.__exitAction)()
  end
end

UIGameDamiePause.OnResume = function(self)
  -- function num : 0_5
  self:HideAndBack()
  if self.__resumeAction ~= nil then
    (self.__resumeAction)()
  end
end

UIGameDamiePause.HideAndBack = function(self)
  -- function num : 0_6
  self:Hide()
end

UIGameDamiePause.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UIGameDamiePause

