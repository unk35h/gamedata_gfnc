-- params : ...
-- function num : 0 , upvalues : _ENV
local UIMoviePlayer = class("UIMoviePlayer")
local cs_MovieManager = (CS.MovieManager).Instance
UIMoviePlayer.ctor = function(self)
  -- function num : 0_0
  self.ui = {}
  return self
end

UIMoviePlayer.Init = function(self, movieGO)
  -- function num : 0_1 , upvalues : _ENV, cs_MovieManager
  self.gameObject = movieGO
  ;
  (UIUtil.LuaUIBindingTable)(movieGO.transform, self.ui)
  self.moviePlayer = cs_MovieManager:GetMoviePlayer()
end

UIMoviePlayer.PlayMovie = function(self, moviePath, vedioEndCallback, speed, loop, closeCallback)
  -- function num : 0_2
  self._moviePath = moviePath
  self._speed = speed
  self._loop = loop
  self._closeCallback = closeCallback
  if self.moviePlayer == nil then
    return 
  end
  ;
  (self.moviePlayer):SetVideoRender((self.ui).img_Vedio)
  ;
  (self.moviePlayer):PlayVideo(moviePath, vedioEndCallback, speed, loop)
end

UIMoviePlayer.SetMovieFade = function(self, startTime, keepTime)
  -- function num : 0_3
  if startTime == nil or keepTime == nil then
    return 
  end
  ;
  ((self.ui).img_BG):DOKill(false)
  ;
  (((((self.ui).img_BG):DOFade(0, keepTime)):SetLink(self.gameObject)):SetDelay(startTime)):OnComplete(function()
    -- function num : 0_3_0 , upvalues : self
    self:CloseMoviePlayer()
  end
)
end

UIMoviePlayer.CloseMoviePlayer = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_MovieManager
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
  if not IsNull(self.moviePlayer) then
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  ;
  ((self.ui).img_BG):DOKill(false)
  DestroyUnityObject(self.gameObject)
end

return UIMoviePlayer

