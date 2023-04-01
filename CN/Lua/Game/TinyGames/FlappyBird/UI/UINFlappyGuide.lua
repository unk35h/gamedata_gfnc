-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyGuide = class("UINFlappyGuide", UIBaseNode)
local base = UIBaseNode
local FlappyBirdAudioConfig = require("Game.TinyGames.FlappyBird.Config.FlappyBirdAudioConfig")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINFlappyGuide.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.HideAndBack)
end

UINFlappyGuide.InjectBackAction = function(self, backToStartAction)
  -- function num : 0_1
  self.__backToStartAction = backToStartAction
end

UINFlappyGuide.HideAndBack = function(self)
  -- function num : 0_2 , upvalues : _ENV, FlappyBirdAudioConfig
  AudioManager:PlayAudioById(FlappyBirdAudioConfig.OnClickButton)
  self:Hide()
  if self.__backToStartAction ~= nil then
    (self.__backToStartAction)()
  end
end

UINFlappyGuide.OnShow = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnShow)(self)
  self:__InitFlappyGuideTween()
end

UINFlappyGuide.__InitFlappyGuideTween = function(self)
  -- function num : 0_4 , upvalues : cs_DoTween
  if self.guideSeq ~= nil then
    (self.guideSeq):Restart()
    return 
  end
  local seq = (cs_DoTween.Sequence)()
  seq:Append((((self.ui).rect_tubes):DOLocalMoveX(-1920, 0.6)):From())
  seq:Join((((self.ui).rect_birdRoot):DOLocalMoveX(0, 0.6)):From())
  seq:Join((((self.ui).rect_title):DOAnchorPosY(0, 0.6)):From())
  seq:Append((((self.ui).fade):DOFade(0, 0.6)):From())
  seq:SetAutoKill(false)
  self.guideSeq = seq
end

UINFlappyGuide.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  if self.guideSeq ~= nil then
    (self.guideSeq):Kill()
    self.guideSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINFlappyGuide

