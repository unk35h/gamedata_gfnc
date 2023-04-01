-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoMonsterDrop = class("UINWarChessInfoMonsterDrop", base)
local UINBaseItem = require("Game.CommonUI.Item.UINBaseItem")
UINWarChessInfoMonsterDrop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__iconList = {}
  self.__iconRecycleList = {}
  self.itemPool = (UIItemPool.New)(UINBaseItem, (self.ui).uINBaseItem)
  ;
  ((self.ui).uINBaseItem):SetActive(false)
end

UINWarChessInfoMonsterDrop.RefreshWCMonsterDropIcons = function(self, monsterDropIconList)
  -- function num : 0_1 , upvalues : _ENV
  (self.itemPool):HideAll()
  for index,itemId in ipairs(monsterDropIconList) do
    local itemCfg = (ConfigData.item)[itemId]
    local baseItem = (self.itemPool):GetOne()
    if itemCfg == nil then
      error("monster drop itme not exist, item id:" .. tostring(itemId))
      return 
    end
    baseItem:InitBaseItem(itemCfg)
  end
end

UINWarChessInfoMonsterDrop.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessInfoMonsterDrop

