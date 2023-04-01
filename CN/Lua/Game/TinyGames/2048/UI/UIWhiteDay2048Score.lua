-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDay2048Score = class("UIWhiteDay2048Score", UIBaseWindow)
local base = UIBaseWindow
UIWhiteDay2048Score.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self._OnClickReturn, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Again, self, self.OnBtnGameAgain)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnBtnBGClick)
end

UIWhiteDay2048Score.InitGame2048Score = function(self, gameCtrl, score, newRecord, gameWindow)
  -- function num : 0_1 , upvalues : _ENV
  self._gameCtrl = gameCtrl
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Score).text = tostring(score)
  self._gameWindow = gameWindow
  ;
  ((self.ui).img_NewScore):SetActive(newRecord)
end

UIWhiteDay2048Score.OnBtnGameAgain = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.OnClickBack)()
  if self._gameCtrl ~= nil then
    (self._gameCtrl):StartNew2048Game()
  end
end

UIWhiteDay2048Score._OnClickReturn = function(self)
  -- function num : 0_3
  (self._gameWindow):Reset2048UIState(false)
  self:Delete()
end

UIWhiteDay2048Score.OnBtnBGClick = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIWhiteDay2048Score.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UIWhiteDay2048Score

