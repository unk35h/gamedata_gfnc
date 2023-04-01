-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCBuffList = class("UINWCBuffList", UIBaseNode)
local UINWCBuffListBuffItem = require("Game.WarChess.UI.Main.BuffList.UINWCBuffListBuffItem")
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
UINWCBuffList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCBuffListBuffItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.buffItemPool = (UIItemPool.New)(UINWCBuffListBuffItem, (self.ui).obj_buffItem)
  ;
  ((self.ui).obj_buffItem):SetActive(false)
  self.__btnBufDescActive = (((self.ui).btn_BuffDescriptionPage).gameObject).activeSelf
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuffDescriptionPage, self, self._OnBuffDescriptionClick)
end

UINWCBuffList.RefreshWCBuffList = function(self, buffDic)
  -- function num : 0_1 , upvalues : _ENV
  (self.buffItemPool):HideAll()
  local buffCount = 0
  self.buffList = {}
  for buffUID,buffData in pairs(buffDic) do
    if buffData:GetWCBuffIsNeedShow() then
      local buffItem = (self.buffItemPool):GetOne()
      buffItem:RefreshWCBuffItem(buffData)
      ;
      (table.insert)(self.buffList, buffData)
      buffCount = buffCount + 1
    end
  end
  if buffCount > 0 and not self.__btnBufDescActive then
    (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(true)
    self.__btnBufDescActive = true
  else
    if buffCount == 0 and self.__btnBufDescActive then
      (((self.ui).btn_BuffDescriptionPage).gameObject):SetActive(false)
      self.__btnBufDescActive = false
    end
  end
end

UINWCBuffList._OnBuffDescriptionClick = function(self)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EpBuffDesc, function(buffDescWin)
    -- function num : 0_2_0 , upvalues : self
    buffDescWin:InitDescriptPageEpBuffShow(self.buffList, function()
      -- function num : 0_2_0_0 , upvalues : buffDescWin
      buffDescWin:Hide()
    end
)
  end
)
end

UINWCBuffList.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  self.buffList = nil
  ;
  (base.OnDelete)(self)
end

return UINWCBuffList

