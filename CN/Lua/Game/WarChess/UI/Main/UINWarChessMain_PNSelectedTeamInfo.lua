-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_PNSelectedTeamInfo = class("UINWarChessMain_PNSelectedTeamInfo", base)
local UINWCMain_HeroHeadItem = require("Game.WarChess.UI.Main.UINWCMain_HeroHeadItem")
local UINChipSmallItem = require("Game.CommonUI.Chip.UINChipSmallItem")
UINWarChessMain_PNSelectedTeamInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCMain_HeroHeadItem, UINChipSmallItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChipList, self, self._WCChipBagClick)
  ;
  ((self.ui).obj_heroHeadItem):SetActive(false)
  self._wcHeroHeadPool = (UIItemPool.New)(UINWCMain_HeroHeadItem, (self.ui).obj_heroHeadItem)
  self._smallChipPool = (UIItemPool.New)(UINChipSmallItem, (self.ui).chipSmallItem, false)
end

UINWarChessMain_PNSelectedTeamInfo.BindSelectTeamEvent = function(self, openChipBagEvent)
  -- function num : 0_1
  self._openChipBagEvent = openChipBagEvent
end

UINWarChessMain_PNSelectedTeamInfo.RefreshWCTeamInfo = function(self, teamData)
  -- function num : 0_2
  self._teamData = teamData
  self:RefreshWCTeamInfoChip(true)
  self:RefreshWCTeamHeroList()
  self:RefreshWCTeamInfoHeroHp()
end

UINWarChessMain_PNSelectedTeamInfo.RefreshWCTeamHeroList = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self._wcHeroHeadPool):HideAll()
  local dynPlayer = (self._teamData):GetTeamDynPlayer()
  for index,dynHero in pairs(dynPlayer.heroList) do
    local heroHeadItem = (self._wcHeroHeadPool):GetOne()
    heroHeadItem:InitWCHeroHeadItem(dynHero, index == 1)
    heroHeadItem:Show()
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINWarChessMain_PNSelectedTeamInfo.RefreshWCTeamInfoHeroHp = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for _,heroItem in pairs((self._wcHeroHeadPool).listItem) do
    heroItem:RefreshWCHeroHp()
  end
end

UINWarChessMain_PNSelectedTeamInfo.RefreshWCTeamInfoChip = function(self, refreshList)
  -- function num : 0_5 , upvalues : _ENV
  if self._teamData == nil then
    return 
  end
  local wcDynPlayer = (self._teamData):GetTeamDynPlayer()
  local num = (wcDynPlayer.chipLimitInfo).count
  local limit = (wcDynPlayer.chipLimitInfo).limit
  ;
  ((self.ui).tex_ChipInfo):SetIndex(0, tostring(num), tostring(limit))
  if refreshList then
    (self._smallChipPool):HideAll()
    local chipList = wcDynPlayer.chipList
    for index,chipData in ipairs(chipList) do
      local chipItem = (self._smallChipPool):GetOne()
      chipItem:InitChipSmallItem(R14_PC37)
    end
  end
end

UINWarChessMain_PNSelectedTeamInfo.GetWCSelectTeamData = function(self)
  -- function num : 0_6
  return self._teamData
end

UINWarChessMain_PNSelectedTeamInfo._WCChipBagClick = function(self)
  -- function num : 0_7
  if self._openChipBagEvent ~= nil then
    (self._openChipBagEvent)(self._teamData)
  end
end

UINWarChessMain_PNSelectedTeamInfo.OnDelete = function(self)
  -- function num : 0_8
end

return UINWarChessMain_PNSelectedTeamInfo

