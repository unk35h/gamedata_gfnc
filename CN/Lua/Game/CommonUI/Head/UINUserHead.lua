-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseHead = require("Game.CommonUI.Head.UINBaseHead")
local UINUserHead = class("UINUseHead", UINBaseHead)
local base = UINBaseHead
UINUserHead.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UserHead, self, self.OnUserHeadClicked)
end

UINUserHead.InitUserHeadUI = function(self, headId, frameId, resloader)
  -- function num : 0_1
  self.__resloader = resloader
  self:InitBaseHeadFull(headId, frameId, resloader)
end

UINUserHead.RefreshUserHeadOnly = function(self, headId)
  -- function num : 0_2
  self:__InitBaseHead(headId, self.__resloader)
end

UINUserHead.RefreshUserHeadFrameOnly = function(self, frameId)
  -- function num : 0_3
  self:__InitBaseHeadFrame(frameId, self.__resloader)
end

UINUserHead.BindUserHeadEvent = function(self, clickEvent)
  -- function num : 0_4
  self.__clickEvent = clickEvent
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).drawraycast).raycastTarget = true
end

UINUserHead.OnUserHeadClicked = function(self)
  -- function num : 0_5
  if self.__clickEvent ~= nil then
    (self.__clickEvent)()
  end
end

UINUserHead.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINUserHead

