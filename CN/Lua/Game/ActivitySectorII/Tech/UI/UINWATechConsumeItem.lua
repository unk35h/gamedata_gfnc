-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWATechConsumeItem = class("UINWATechConsumeItem", UIBaseNode)
local base = UIBaseNode
UINWATechConsumeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Icon, self, self._OnClickIcon)
end

UINWATechConsumeItem.InitStOConsumeItem = function(self, itemId, costNum)
  -- function num : 0_1 , upvalues : _ENV
  (((self.ui).img_SmallIcon).gameObject):SetActive(true)
  ;
  (((self.ui).tex_Consume).gameObject):SetActive(true)
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("Cant get itemCfg, itemId = " .. tostring(itemId))
    return 
  end
  self.itemCfg = itemCfg
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_SmallIcon).sprite = CRH:GetSprite(itemCfg.small_icon)
  local containNum = PlayerDataCenter:GetItemCount(itemId)
  local enough = costNum <= containNum
  ;
  ((self.ui).tex_Consume):SetIndex(enough and 0 or 1, tostring(containNum), tostring(costNum))
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINWATechConsumeItem.TempSetOtherConditon = function(self, text)
  -- function num : 0_2
  (((self.ui).img_SmallIcon).gameObject):SetActive(false)
  ;
  (((self.ui).tex_Consume).gameObject):SetActive(false)
  ;
  (((self.ui).text_unlockConditon).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).text_unlockConditon).text = text
end

UINWATechConsumeItem._OnClickIcon = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(window)
    -- function num : 0_3_0 , upvalues : self
    window:InitCommonItemDetail(self.itemCfg)
  end
)
end

UINWATechConsumeItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWATechConsumeItem

