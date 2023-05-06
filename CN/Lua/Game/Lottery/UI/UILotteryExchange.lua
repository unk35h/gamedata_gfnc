-- params : ...
-- function num : 0 , upvalues : _ENV
local UILotteryExchange = class("UILotteryExchange", UIBaseWindow)
local base = UIBaseWindow
local UINLtrPtNode = require("Game.Lottery.UI.PtNode.UINLtrPtNode")
local UINLtrSHNode = require("Game.Lottery.UI.SelectHero.UINLtrSHNode")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UILotteryExchange.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLtrPtNode, UINLtrSHNode
  (UIUtil.SetTopStatus)(self, self.BackAction)
  self.ltrPtNode = (UINLtrPtNode.New)()
  ;
  (self.ltrPtNode):Init((self.ui).exchangeNode)
  ;
  (self.ltrPtNode):Hide()
  self.ltrSHNode = (UINLtrSHNode.New)()
  ;
  (self.ltrSHNode):Init((self.ui).selectHeroNode)
  ;
  (self.ltrSHNode):Hide()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.Close)
end

UILotteryExchange.ShowLtrPtNode = function(self, curPoolData, ltrCtrl)
  -- function num : 0_1
  (self.ltrPtNode):InitLtrPtNode(curPoolData, ltrCtrl)
  ;
  ((self.ui).resourceItem):SetActive(true)
  ;
  (self.ltrPtNode):Show()
  ;
  (self.ltrPtNode):BindCloseFun(function()
    -- function num : 0_1_0 , upvalues : self
    self:Close()
  end
)
end

UILotteryExchange.HideLtrPtNode = function(self)
  -- function num : 0_2
  (self.ltrPtNode):Hide()
end

UILotteryExchange.ShowLtrSHNode = function(self, itemId, curHeroCfg, ltrCfg, ltrCtrl)
  -- function num : 0_3
  (self.ltrSHNode):InitLtrSHNode(itemId, curHeroCfg, ltrCfg, ltrCtrl)
  ;
  ((self.ui).resourceItem):SetActive(false)
  ;
  (self.ltrSHNode):Show()
  ;
  (self.ltrSHNode):BindCloseFun(function()
    -- function num : 0_3_0 , upvalues : self
    self:Close()
  end
)
end

UILotteryExchange.HideLtrSHNode = function(self)
  -- function num : 0_4
  (self.ltrSHNode):Hide()
end

UILotteryExchange.BackAction = function(self)
  -- function num : 0_5
  self:Delete()
end

UILotteryExchange.Close = function(self)
  -- function num : 0_6 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self.ltrPtNode)
  ;
  (UIUtil.OnClickBackByUiTab)(self.ltrSHNode)
  ;
  (UIUtil.OnClickBackByUiTab)(self)
end

UILotteryExchange.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  if self.ltrPtNode ~= nil then
    (self.ltrPtNode):Delete()
  end
  if self.ltrSHNode ~= nil then
    (self.ltrSHNode):Delete()
  end
  ;
  (base.Delete)(self)
end

return UILotteryExchange

