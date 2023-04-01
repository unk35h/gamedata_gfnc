-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessSellList = class("UINWarChessSellList", UIBaseNode)
local base = UIBaseNode
local UINWarChessTeamNodeItem = require("Game.Warchess.UI.Store.UINWarChessTeamNodeItem")
UINWarChessSellList.ctor = function(self, storeRoomRoot)
  -- function num : 0_0
  self.storeRoomRoot = storeRoomRoot
end

UINWarChessSellList.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINWarChessTeamNodeItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._OnClickChipItemFunc = BindCallback(self, self._OnClickChipItem)
  ;
  ((self.ui).teamNodeItem):SetActive(false)
  self.teamNodeItemPool = (UIItemPool.New)(UINWarChessTeamNodeItem, (self.ui).teamNodeItem)
  self.teamNodeItemDic = {}
  self:SetSellListEmptyUI(false)
  self.__onWCChipChanged = BindCallback(self, self.OnDynPlayChipUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
end

UINWarChessSellList.InitWarChessStoreRoomSell = function(self, teamDic)
  -- function num : 0_2 , upvalues : _ENV
  local curChipItem, curTeamData = nil, nil
  ;
  (self.teamNodeItemPool):HideAll()
  self.teamNum = 0
  local buyPrice = nil
  for k,teamData in pairs(teamDic) do
    if teamData ~= nil then
      local teamIdx = teamData:GetWCTeamIndex()
      local chipList = teamData:GetWCTeamChipList()
      if #chipList > 0 then
        local teamNodeItem = (self.teamNodeItemPool):GetOne()
        teamNodeItem:InitTeamNodeItem(chipList, teamData, (self.storeRoomRoot).CoinIconId, self._OnClickChipItemFunc)
        local dynPlayer = teamData:GetTeamDynPlayer()
        -- DECOMPILER ERROR at PC32: Confused about usage of register: R14 in 'UnsetPending'

        ;
        (self.teamNodeItemDic)[dynPlayer] = teamNodeItem
        if curChipItem == nil then
          curChipItem = teamNodeItem:GetChipItemByIndex(1)
          curTeamData = teamData
        end
        self.teamNum = self.teamNum + 1
      end
    end
  end
  if self.teamNum <= 0 then
    self:SetSellListEmptyUI(true)
  else
    self:SetSellListEmptyUI(false)
    self.curChipItem = curChipItem
    self.curTeamData = curTeamData
    if curChipItem ~= nil then
      (self.storeRoomRoot):RefreshSelectItemDetailSoldOut(curChipItem.chipData)
    end
  end
end

UINWarChessSellList.OnDynPlayChipUpdate = function(self, chipList, dynPlayer)
  -- function num : 0_3
  local teamNodeItem = (self.teamNodeItemDic)[dynPlayer]
  if teamNodeItem == nil then
    return 
  end
  if #chipList > 0 then
    local teamData = teamNodeItem:GetTeamData()
    teamNodeItem:InitTeamNodeItem(chipList, teamData, (self.storeRoomRoot).CoinIconId, self._OnClickChipItemFunc)
  else
    do
      teamNodeItem:Hide()
      self.teamNum = self.teamNum - 1
      if self.teamNum <= 0 then
        self:SetSellListEmptyUI(true)
      end
    end
  end
end

UINWarChessSellList.GetCurChipItem = function(self)
  -- function num : 0_4
  return self.curChipItem
end

UINWarChessSellList.GetCurTeamData = function(self)
  -- function num : 0_5
  return self.curTeamData
end

UINWarChessSellList._OnClickChipItem = function(self, chipItem, teamData)
  -- function num : 0_6
  self.curChipItem = chipItem
  self.curTeamData = teamData
  local chipData = chipItem.chipData
  ;
  (self.storeRoomRoot):RefreshSelectItemDetailSoldOut(teamData, chipData)
end

UINWarChessSellList.SetSellListEmptyUI = function(self, active)
  -- function num : 0_7 , upvalues : _ENV
  for k,v in ipairs((self.ui).emptys) do
    v:SetActive(active)
  end
end

UINWarChessSellList.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnDelete)(self)
  ;
  (self.teamNodeItemPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.WC_ChipChange, self.__onWCChipChanged)
end

return UINWarChessSellList

