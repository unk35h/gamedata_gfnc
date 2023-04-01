-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentNodeDetailCost = class("UINHeroTalentNodeDetailCost", UIBaseNode)
local base = UIBaseNode
UINHeroTalentNodeDetailCost.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Icon, self, self.OnClickItemIcon)
end

UINHeroTalentNodeDetailCost.RefresheDetailCost = function(self, itemId, itemNum)
  -- function num : 0_1 , upvalues : _ENV
  self._itemId = itemId
  self._itemNum = itemNum
  local img = CRH:GetSpriteByItemId(itemId)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = img
  self:RefreshDetailCostState()
end

UINHeroTalentNodeDetailCost.RefreshDetailCostState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local hasNum = PlayerDataCenter:GetItemCount(self._itemId)
  local isComplete = self._itemNum <= hasNum
  ;
  ((self.ui).text_Count):SetIndex(isComplete and 1 or 0, tostring(hasNum), tostring(self._itemNum))
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINHeroTalentNodeDetailCost.OnClickItemIcon = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self._itemId]
  if itemCfg == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_3_0 , upvalues : itemCfg
    if win == nil then
      return 
    end
    win:InitCommonItemDetail(itemCfg)
    win:TryShowGiftJump(true)
  end
)
end

return UINHeroTalentNodeDetailCost

