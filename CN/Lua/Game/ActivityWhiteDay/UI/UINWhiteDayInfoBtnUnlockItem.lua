-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayInfoBtnUnlockItem = class("UINWhiteDayInfoBtnUnlockItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINWhiteDayInfoBtnUnlockItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__unloclLineSprite = ((self.ui).img_Icon).sprite
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_unlockItem, self, self.__OnClickUnlockItem)
end

UINWhiteDayInfoBtnUnlockItem.IntiInfoBtnUnlockItem = function(self, isLine, orderData)
  -- function num : 0_1 , upvalues : _ENV
  self.isLine = isLine
  self.orderData = orderData
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if isLine then
    ((self.ui).img_Icon).sprite = self.__unloclLineSprite
    ;
    ((self.ui).text):SetIndex(0)
  else
    local itemId = orderData:GetWDOrderItemId()
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSpriteByItemId(itemId)
    ;
    ((self.ui).text):SetIndex(1)
  end
end

UINWhiteDayInfoBtnUnlockItem.__OnClickUnlockItem = function(self)
  -- function num : 0_2 , upvalues : cs_MessageCommon, _ENV
  if self.isLine then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7203))
  else
    local itemId = (self.orderData):GetWDOrderItemId()
    do
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        return 
      end
      UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_2_0 , upvalues : itemCfg
    if win ~= nil then
      win:SetNotNeedAnyJump(true)
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
    end
  end
end

UINWhiteDayInfoBtnUnlockItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayInfoBtnUnlockItem

