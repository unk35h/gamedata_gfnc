-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHeroGrow.UI.UINCharaDungeonBase")
local UINCharDunHelix = class("UINCharDunHelix", base)
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local cs_MovieManager = (CS.MovieManager).Instance
UINCharDunHelix.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
  self.heroID = 1052
  self:_LoadMovie()
end

UINCharDunHelix._LoadMovie = function(self)
  -- function num : 0_1 , upvalues : cs_MovieManager, _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_movie).enabled = false
  if self.moviePlayer == nil then
    self.moviePlayer = cs_MovieManager:GetMoviePlayer()
  end
  ;
  (self.moviePlayer):SetVideoRender((self.ui).img_movie)
  local path = PathConsts:GetCharDunVideoPath(self.heroID)
  ;
  (self.moviePlayer):PlayVideo(path, nil, 1, true)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_movie).enabled = true
end

UINCharDunHelix.OnDelete = function(self)
  -- function num : 0_2 , upvalues : cs_MovieManager, base
  if self.moviePlayer ~= nil then
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINCharDunHelix

