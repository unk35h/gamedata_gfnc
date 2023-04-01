-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessTeamNodeItem = class("UINWarChessTeamNodeItem", UIBaseNode)
local base = UIBaseNode
local UINWarChessStoreChipItem = require("Game.WarChess.UI.Store.UINWarChessStoreChipItem")
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
UINWarChessTeamNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UINWarChessStoreChipItem
  (base.OnInit)(self, self.transform, self.ui)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.chipItemPool = (UIItemPool.New)(UINWarChessStoreChipItem, (self.ui).storeChipItem)
  self._OnClickChipItemFunc = BindCallback(self, self._OnClickChipItem)
end

UINWarChessTeamNodeItem.InitTeamNodeItem = function(self, chipDataList, teamData, moneyIconId, clickedAction)
  -- function num : 0_1 , upvalues : _ENV, ChipEnum
  if #chipDataList > 20 then
    error("The num(chip + buff) greater than 20.")
    return 
  end
  if teamData == nil then
    return 
  end
  self.teamData = teamData
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_GroupTitle).text = tostring(teamData:GetWCTeamName())
  self._clickedAction = clickedAction
  self.chipitemList = {}
  ;
  (self.chipItemPool):HideAll()
  local buyPrice = nil
  for k,chipData in ipairs(chipDataList) do
    if chipData ~= nil then
      local chipItem = (self.chipItemPool):GetOne()
      ;
      (chipItem.transform):SetParent(((self.ui).groupItem_Chip).transform)
      ;
      (chipItem.transform):SetAsLastSibling()
      chipItem:InitWCStoreChipItem(chipData, moneyIconId, self._OnClickChipItemFunc, true)
      local isHadChip = false
      if not isHadChip or not (ChipEnum.eChipShowState).UpState then
        local chipShowState = (ChipEnum.eChipShowState).NewState
      end
      chipItem:SetNewTagActive(false, chipShowState)
      ;
      (table.insert)(self.chipitemList, chipItem)
    end
  end
end

UINWarChessTeamNodeItem._OnClickChipItem = function(self, chipItem)
  -- function num : 0_2
  if self._clickedAction ~= nil then
    (self._clickedAction)(chipItem, self.teamData)
  end
end

UINWarChessTeamNodeItem.GetChipItemByIndex = function(self, idx)
  -- function num : 0_3
  if self.chipitemList ~= nil and idx <= #self.chipitemList then
    return (self.chipitemList)[idx]
  end
  return 
end

UINWarChessTeamNodeItem.GetTeamData = function(self)
  -- function num : 0_4
  return self.teamData
end

UINWarChessTeamNodeItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.chipItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINWarChessTeamNodeItem

