-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityHeroGrow.UI.UINCharaDungeonBase")
local UINCharDunHaze = class("UINCharDunKuro", base)
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
local cs_ResLoader = CS.ResLoader
local cs_MovieManager = (CS.MovieManager).Instance
UINCharDunHaze.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  self._onGesture = BindCallback(self, self._OnGesture)
  self._onFingerDown = BindCallback(self, self._OnFingerDown)
  self.heroID = 1046
  self:_LoadMovie()
end

UINCharDunHaze.OnShow = function(self)
  -- function num : 0_1 , upvalues : cs_LeanTouch
  (cs_LeanTouch.OnGesture)("+", self._onGesture)
  ;
  (cs_LeanTouch.OnFingerDown)("+", self._onFingerDown)
end

UINCharDunHaze.OnHide = function(self)
  -- function num : 0_2 , upvalues : cs_LeanTouch
  (cs_LeanTouch.OnGesture)("-", self._onGesture)
  ;
  (cs_LeanTouch.OnFingerDown)("-", self._onFingerDown)
end

UINCharDunHaze._OnGesture = function(self, fingerList)
  -- function num : 0_3
  if not self._isValidTouch then
    return 
  end
  if fingerList.Count == 1 then
    local touch = fingerList[0]
    self:_CalculateMove(touch)
  end
end

local cd = 0
local photo = 8
UINCharDunHaze._CalculateMove = function(self, touch)
  -- function num : 0_4 , upvalues : cd, _ENV, photo
  local diffPos = touch.ScreenPosition - touch.LastScreenPosition
  cd = cd - diffPos.x * 0.03
  cd = (math.clamp)(cd, -21, 0)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_CD).localRotation = (Quaternion.Euler)(0, 0, cd)
  photo = photo - diffPos.x * 0.006
  photo = (math.clamp)(photo, 4, 8)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_Photo).localRotation = (Quaternion.Euler)(0, 0, photo)
end

UINCharDunHaze._OnFingerDown = function(self, finger)
  -- function num : 0_5
  self._isValidTouch = self:_CheckIsValidTouch(finger)
end

UINCharDunHaze._CheckIsValidTouch = function(self, finger)
  -- function num : 0_6 , upvalues : cs_LeanTouch
  local result = (cs_LeanTouch.RaycastGui)(finger.ScreenPosition)
  if result.Count == 0 then
    return false
  end
  local res = result[0]
  if res.gameObject ~= (self.ui).animaNode then
    return false
  end
  return true
end

UINCharDunHaze._LoadMovie = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_MovieManager
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_Movie).enabled = false
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_PhotoPic).enabled = true
  local fullPath = PathConsts:GetCharDunVideoFullPath(self.heroID)
  local hasMovie = ((CS.ResManager).Instance):ContainsAsset(fullPath)
  if not hasMovie then
    return 
  end
  if self.moviePlayer == nil then
    self.moviePlayer = cs_MovieManager:GetMoviePlayer()
  end
  ;
  (self.moviePlayer):SetVideoRender((self.ui).img_Movie)
  local path = PathConsts:GetCharDunVideoPath(self.heroID)
  ;
  (self.moviePlayer):PlayVideo(path, nil, 1, true)
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Movie).enabled = true
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_PhotoPic).enabled = false
end

UINCharDunHaze.OnDelete = function(self)
  -- function num : 0_8 , upvalues : cs_MovieManager, base
  if self.moviePlayer ~= nil then
    cs_MovieManager:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINCharDunHaze

