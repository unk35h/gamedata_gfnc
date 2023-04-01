-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDailyDungeonQuickBattleItem = class("UINDailyDungeonQuickBattleItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINDailyDungeonQuickBattleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
end

UINDailyDungeonQuickBattleItem.InitDailyQuickBattleItem = function(self, dungeonStageCfg, index, isDouble, rewardDic)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  ((self.ui).tex_CNName).text = (LanguageUtil.GetLocaleText)(dungeonStageCfg.name)
  ;
  ((self.ui).tex_ENName):SetIndex(0, tostring(index))
  ;
  ((self.ui).obj_DoubleDrop):SetActive(isDouble)
  ;
  (self._itemPool):HideAll()
  if rewardDic ~= nil then
    for itemId,itemCount in pairs(rewardDic) do
      local itemCfg = (ConfigData.item)[itemId]
      local item = (self._itemPool):GetOne()
      item:InitItemWithCount(itemCfg, R15_PC38)
    end
  end
end

UINDailyDungeonQuickBattleItem.ShowDailyQuickBattleItem = function(self, flag)
  -- function num : 0_2
  ((self.ui).root):SetActive(flag)
end

return UINDailyDungeonQuickBattleItem

