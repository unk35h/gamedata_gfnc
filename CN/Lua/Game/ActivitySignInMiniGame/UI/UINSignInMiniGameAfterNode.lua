-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSignInMiniGameAfterNode = class("UINSignInMiniGameAfterNode", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local UINAfterItem = require("Game.ActivitySignInMiniGame.UI.UINSignInMiniGameAfterItem")
UINSignInMiniGameAfterNode.ctor = function(self, storeRoomRoot)
  -- function num : 0_0
  self.storeRoomRoot = storeRoomRoot
end

UINSignInMiniGameAfterNode.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINUserHead, UINAfterItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
  ;
  ((self.ui).obj_afterItem):SetActive(false)
  self.afterItemPool = (UIItemPool.New)(UINAfterItem, (self.ui).obj_afterItem)
end

UINSignInMiniGameAfterNode.InitNode = function(self, ctrl, resLoader)
  -- function num : 0_2 , upvalues : _ENV
  self.siginInMiniCtrl = ctrl
  local userInfoData = PlayerDataCenter.inforData
  self.resLoader = resLoader
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = userInfoData:GetUserName()
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_UID).text = "UID:" .. userInfoData:GetUserUID()
  ;
  (self.userHeadNode):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), resLoader)
  local signatureText = tostring(userInfoData:GetAvatarSignature())
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

  if (string.IsNullOrEmpty)(signatureText) then
    ((self.ui).tex_Signature).text = ConfigData:GetTipContent(6030)
  else
    -- DECOMPILER ERROR at PC47: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Signature).text = tostring(signatureText)
  end
  ;
  (self.afterItemPool):HideAll()
  local allSignDay = (self.siginInMiniCtrl):GetTotalSignDay()
  local allSignData = ctrl:GetAllSignData()
  if allSignData ~= nil then
    for k,v in ipairs(allSignData) do
      local item = (self.afterItemPool):GetOne()
      ;
      (item.transform):SetParent(((self.ui).groupIten_After).transform)
      ;
      (item.transform):SetAsFirstSibling()
      local leftDay = ctrl:GetLeftDayWithCurTime(v.signTime)
      local range = ctrl:GetSignDataRange(k, v)
      item:InitItem(ctrl, v, resLoader, k)
    end
  end
  do
    ;
    ((self.ui).tween_root):DOComplete()
  end
end

UINSignInMiniGameAfterNode.AddNewItem = function(self, signIndex, signData)
  -- function num : 0_3
  local item = (self.afterItemPool):GetOne()
  ;
  (item.transform):SetParent(((self.ui).groupIten_After).transform)
  ;
  (item.transform):SetAsFirstSibling()
  local leftDay = (self.siginInMiniCtrl):GetLeftDayWithCurTime(signData.signTime)
  local range = (self.siginInMiniCtrl):GetSignDataRange(signIndex, signData)
  local allSignDay = (self.siginInMiniCtrl):GetTotalSignDay()
  item:InitItem(self.siginInMiniCtrl, signData, self.resLoader, signIndex, true)
end

UINSignInMiniGameAfterNode.PlayTweenAnim = function(self)
  -- function num : 0_4
  ((self.ui).tween_root):DORestartById("root")
end

UINSignInMiniGameAfterNode.OnShow = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnShow)(self)
end

UINSignInMiniGameAfterNode.OnHide = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnHide)()
end

UINSignInMiniGameAfterNode.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
  ;
  (self.userHeadNode):Delete()
  ;
  (self.afterItemPool):DeleteAll()
end

return UINSignInMiniGameAfterNode

