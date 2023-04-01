-- params : ...
-- function num : 0 , upvalues : _ENV
local UISignInMiniGame = class("UISignInMiniGame", UIBaseWindow)
local base = UIBaseWindow
local UINSignInMiniGameBeforeNode = require("Game.ActivitySignInMiniGame.UI.UINSignInMiniGameBeforeNode")
local UINSignInMiniGameAfterNode = require("Game.ActivitySignInMiniGame.UI.UINSignInMiniGameAfterNode")
UISignInMiniGame.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSignInMiniGameBeforeNode, UINSignInMiniGameAfterNode
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBtnClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_notice, self, self.OnClickBtnNotice)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_square, self, self.OnClickBtnSquare)
  self.resloader = ((CS.ResLoader).Create)()
  self.beforeNode = (UINSignInMiniGameBeforeNode.New)(self)
  ;
  (self.beforeNode):Init((self.ui).obj_before)
  self.afterNode = (UINSignInMiniGameAfterNode.New)(self)
  ;
  (self.afterNode):Init((self.ui).obj_after)
end

UISignInMiniGame.InitSignInMiniGame = function(self, actId, isShowCloseBtn)
  -- function num : 0_1 , upvalues : _ENV
  self.signInMiniGameCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySignInMiniGame, true)
  if actId ~= (self.signInMiniGameCtrl):GetActId() then
    return 
  end
  ;
  ((self.ui).obj_bg):SetActive(isShowCloseBtn or false)
  ;
  (((self.ui).btn_Close).gameObject):SetActive(isShowCloseBtn or false)
  ;
  (self.beforeNode):InitNode(self.signInMiniGameCtrl, self.resloader)
  ;
  (self.afterNode):InitNode(self.signInMiniGameCtrl, self.resloader)
  self:RefreshIsCanSign()
  self:OnClickBtnNotice()
end

UISignInMiniGame.RefreshIsCanSign = function(self)
  -- function num : 0_2
  self.isCanSign = (self.signInMiniGameCtrl):IsCanSignToDay()
  ;
  ((self.ui).obj_Icon):SetActive(self.isCanSign)
end

UISignInMiniGame.OnSwitchTogChanged = function(self, index, value)
  -- function num : 0_3
  ;
  (((self.ui).img_togs)[index]):SetIndex(value and 0 or 1)
  if value == true then
    if index == 1 then
      (self.beforeNode):Show()
      ;
      (self.afterNode):Hide()
    else
      if index == 2 then
        (self.beforeNode):Hide()
        ;
        (self.afterNode):Show()
        ;
        ((self.ui).obj_Icon):SetActive(false)
      end
    end
  end
end

UISignInMiniGame.RefreshBtnImg = function(self)
  -- function num : 0_4
  ;
  ((self.ui).img_notice):SetIndex(self.curNode == 1 and 0 or 1)
  ;
  ((self.ui).img_square):SetIndex(self.curNode == 2 and 0 or 1)
end

UISignInMiniGame.OnClickBtnNotice = function(self)
  -- function num : 0_5
  self.curNode = 1
  ;
  (self.beforeNode):Show()
  ;
  (self.afterNode):Hide()
  self:RefreshBtnImg()
end

UISignInMiniGame.OnClickBtnSquare = function(self)
  -- function num : 0_6 , upvalues : _ENV
  do
    if self.isCanSign then
      local cfg = (ConfigData.sign_minigame_text)[15]
      if cfg ~= nil then
        ((CS.MessageCommon).ShowMessageTips)((LanguageUtil.GetLocaleText)(cfg.content))
      end
      return 
    end
    self.curNode = 2
    ;
    (self.beforeNode):Hide()
    ;
    (self.afterNode):Show()
    ;
    ((self.ui).obj_Icon):SetActive(false)
    self:RefreshBtnImg()
  end
end

UISignInMiniGame.OnEmojiWindowClose = function(self)
  -- function num : 0_7
  local index, signData = (self.signInMiniGameCtrl):GetNewSignInDay()
  ;
  (self.beforeNode):RefreshNode()
  ;
  (self.afterNode):AddNewItem(index, signData)
  self:RefreshIsCanSign()
  self:OnClickBtnSquare()
  ;
  (self.afterNode):PlayTweenAnim()
end

UISignInMiniGame.SetCloseCallback = function(self, callback)
  -- function num : 0_8
  self.__closeCallback = callback
end

UISignInMiniGame.OnClickBtnClose = function(self)
  -- function num : 0_9
  self:Delete()
  if self.__closeCallback ~= nil then
    local action = self.__closeCallback
    self.__closeCallback = nil
    action()
  end
end

UISignInMiniGame.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (self.resloader):Put2Pool()
  self.resloader = nil
  ;
  (self.beforeNode):Delete()
  ;
  (self.afterNode):Delete()
  ;
  (base.OnDelete)(self)
end

return UISignInMiniGame

