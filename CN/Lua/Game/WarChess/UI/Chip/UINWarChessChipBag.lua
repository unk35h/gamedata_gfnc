-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessChipBag = class("UINWarChessChipBag", base)
local UINWarChessChipBagItem = require("Game.WarChess.UI.Chip.UINWarChessChipBagItem")
local UINWCChipDetailCombat = require("Game.WarChess.UI.Common.UINWCChipDetailCombat")
UINWarChessChipBag.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessChipBagItem, UINWCChipDetailCombat
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnBtnClick)
  ;
  ((self.ui).wCChipItem):SetActive(false)
  self._chipItemPool = (UIItemPool.New)(UINWarChessChipBagItem, (self.ui).wCChipItem)
  self._chipDetailItem = (UINWCChipDetailCombat.New)()
  ;
  (self._chipDetailItem):Init((self.ui).wcChipDetailCombat)
  self._chipItemClickEvent = BindCallback(self, self._OnChipItemClicked)
end

UINWarChessChipBag.InitWCTeamChipBag = function(self, teamData)
  -- function num : 0_1
  self._teamData = teamData
  ;
  ((self.ui).tex_Team):SetIndex(0, teamData:GetWCTeamName())
  self:_RefreshTeamChipPanel()
end

UINWarChessChipBag._RefreshTeamChipPanel = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local wcDynPlayer = (self._teamData):GetTeamDynPlayer()
  local chipList = wcDynPlayer.chipList
  local num = (wcDynPlayer.chipLimitInfo).count
  local limit = (wcDynPlayer.chipLimitInfo).limit
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ChipLimit).text = tostring(num) .. "/" .. tostring(limit)
  ;
  (self._chipItemPool):HideAll()
  for index,chipData in ipairs(chipList) do
    local chipItem = (self._chipItemPool):GetOne()
    chipItem:InitWCChipBagItem(chipData, self._chipItemClickEvent)
  end
  if #chipList <= 0 then
    return 
  end
  self._selectChipItem = nil
  local chipData = chipList[1]
  local chipItem = ((self._chipItemPool).listItem)[1]
  self:_OnChipItemClicked(chipItem, chipData)
end

UINWarChessChipBag._OnChipItemClicked = function(self, chipBagItem, chipData)
  -- function num : 0_3 , upvalues : _ENV
  if self._selectChipItem == chipBagItem then
    return 
  end
  self._selectChipItem = chipBagItem
  ;
  ((self.ui).img_Selected):SetParent(chipBagItem.transform)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Selected).anchoredPosition = (Vector2.Temp)(0, 0)
  local dynPlayer = (self._teamData):GetTeamDynPlayer()
  ;
  (self._chipDetailItem):InitWCChipDetailCombat(chipData, dynPlayer, nil, true)
end

UINWarChessChipBag.SetWCCBCloseCallback = function(self, callback)
  -- function num : 0_4
  self.callback = callback
end

UINWarChessChipBag._OnBtnClick = function(self)
  -- function num : 0_5
  if self.callback ~= nil then
    (self.callback)()
    self.callback = nil
  end
  self:Hide()
end

UINWarChessChipBag.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessChipBag

