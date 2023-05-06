-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIEventBattlePassRewardPreview = class("UIEventBattlePassRewardPreview", base)
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UIEventBattlePassRewardPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount, UINBaseItem
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self._OnClickClose)
  self.rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem, false)
  self.baseItem = (UINBaseItem.New)()
  ;
  (self.baseItem):Init((self.ui).baseItem)
end

UIEventBattlePassRewardPreview.InitBPRewardPreview = function(self, itemId, rewardIds, rewardNums)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("item cfg is null,id:" .. tostring(itemId))
    return 
  end
  ;
  (self.baseItem):InitBaseItem(itemCfg)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)(itemCfg.name)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemDes).text = (LanguageUtil.GetLocaleText)(itemCfg.describe)
  ;
  (self.rewardPool):HideAll()
  for index,id in pairs(rewardIds) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg ~= nil then
      local num = rewardNums[index]
      local rewardItem = (self.rewardPool):GetOne()
      rewardItem:InitItemWithCount(itemCfg, num)
    end
  end
end

UIEventBattlePassRewardPreview._OnClickClose = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIEventBattlePassRewardPreview.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UIEventBattlePassRewardPreview

