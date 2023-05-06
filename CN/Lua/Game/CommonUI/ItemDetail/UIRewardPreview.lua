-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIRewardPreview = class("UIRewardPreview", base)
local UINPreviewItem = require("Game.CommonUI.ItemDetail.UIRewardPreviewItem")
UIRewardPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINPreviewItem
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self._OnClickClose)
  self.__OnItemClcik = BindCallback(self, self.OnItemClick)
  self.rewardPool = (UIItemPool.New)(UINPreviewItem, (self.ui).rewardItem, false)
end

UIRewardPreview.InitRewardPreview = function(self, itemId, rewardIdList, rewardNumList)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("item cfg is null,id:" .. tostring(itemId))
    return 
  end
  ;
  (self.rewardPool):HideAll()
  for i = 1, (table.count)(rewardIdList) do
    local itemCfg = (ConfigData.item)[rewardIdList[i]]
    if itemCfg ~= nil then
      local rewardItem = (self.rewardPool):GetOne()
      local num = rewardNumList[i]
      if num <= 0 then
        rewardItem:InitItemWithCount(itemCfg, nil, self.__OnItemClcik)
      else
        rewardItem:InitItemWithCount(itemCfg, num, self.__OnItemClcik)
      end
    end
  end
end

UIRewardPreview.OnItemClick = function(self, itemCfg)
  -- function num : 0_2 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(window)
    -- function num : 0_2_0 , upvalues : itemCfg
    window:SetNotNeedAnyJump(true)
    window:InitCommonItemDetail(itemCfg)
    window:HideUseGiftBtn()
  end
)
end

UIRewardPreview._OnClickClose = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIRewardPreview.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
  if self.rewardPool ~= nil then
    (self.rewardPool):DeleteAll()
    self.rewardPool = nil
  end
end

return UIRewardPreview

