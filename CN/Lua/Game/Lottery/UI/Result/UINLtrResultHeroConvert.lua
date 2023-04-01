-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLtrResultHeroConvert = class("UINLtrResultHeroConvert", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINLtrResultHeroConvert.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).rewardItem):SetActive(false)
  self.itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem)
end

UINLtrResultHeroConvert.HideAllChild = function(self)
  -- function num : 0_1
  (self.itemPool):HideAll()
end

UINLtrResultHeroConvert.GetOneChlid = function(self, itemCfg, num, resLoader)
  -- function num : 0_2
  local item = (self.itemPool):GetOne()
  item:InitItemWithCount(itemCfg, num)
  self.resLoader = resLoader
end

UINLtrResultHeroConvert.ShowHeroConvertFx = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for _,item in ipairs((self.itemPool).listItem) do
    local isGreatItem = ((ConfigData.game_config).itemWithGreatFxDic)[(item.itemCfg).id]
    if isGreatItem then
      item:LoadGetGreatRewardFx(self.resLoader)
    end
  end
end

UINLtrResultHeroConvert.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.itemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINLtrResultHeroConvert

