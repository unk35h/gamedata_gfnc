-- params : ...
-- function num : 0 , upvalues : _ENV
local UILotteryShow = class("UILotteryShow", UIBaseWindow)
local base = UIBaseWindow
UILotteryShow.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Skip, self, self.SkipLotteryShow)
end

UILotteryShow.InitLotteryShow = function(self, showCtrl)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  UIManager:HideWindow(UIWindowTypeID.TopStatus)
  self.__showCtrl = showCtrl
end

UILotteryShow.BackAction = function(self)
  -- function num : 0_2
  if self.__showCtrl ~= nil then
    (self.__showCtrl):SkipShow()
  end
end

UILotteryShow.SkipLotteryShow = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

return UILotteryShow

