-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessSelectTeam = class("UINWarChessSelectTeam", UIBaseNode)
local base = UIBaseNode
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
local UINChipDetailSuitItem = require("Game.CommonUI.Chip.UINChipDetailSuitItem")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
UINWarChessSelectTeam.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Equip, self, self._OnClickWCTeamEquip)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self._OnClickWCTeamBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Chip, self, self._OnClickChipBag)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
  self.heroHeadPool = (UIItemPool.New)(UINHeroHeadItem, (self.ui).heroHeadItem)
end

UINWarChessSelectTeam.InitWCSelectTeamGetChip = function(self, teamData, chipData, resloader)
  -- function num : 0_1 , upvalues : _ENV, WarChessHelper
  self._resloader = resloader
  self:_InitWCTeamUIBase(teamData)
  local dynPlayer = teamData:GetTeamDynPlayer()
  self:_InitTeamHeroList(chipData, dynPlayer)
  self:_InitTeamFightPower(chipData, dynPlayer)
  local isHasChip = (dynPlayer.chipDic)[chipData.dataId] ~= nil
  self._hasThisChip = isHasChip
  ;
  ((self.ui).tex_Equip):SetIndex(isHasChip and 1 or 0)
  local _, count, limit = dynPlayer:IsChipOverLimitNum()
  if not isHasChip and limit <= count then
    ((self.ui).tex_ChipCount):SetIndex(1, tostring(count), tostring(limit))
  else
    ((self.ui).tex_ChipCount):SetIndex(0, tostring(count), tostring(limit))
  end
  local chipReturnMoney = (WarChessHelper.GetChipReturnMoney)(dynPlayer, chipData.dataId, chipData:GetCount())
  if chipReturnMoney > 0 then
    ((self.ui).ccReturn):SetActive(true)
    -- DECOMPILER ERROR at PC79: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_Return).text = tostring(chipReturnMoney)
  else
    ((self.ui).ccReturn):SetActive(false)
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINWarChessSelectTeam.InitWCSelectTeamBuyChip = function(self, teamData, chipData, resloader, price)
  -- function num : 0_2 , upvalues : _ENV
  self:InitWCSelectTeamGetChip(teamData, chipData, resloader)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).text_price).text = tostring(price)
  ;
  (((self.ui).btn_Buy).gameObject):SetActive(true)
  ;
  (((self.ui).btn_Equip).gameObject):SetActive(false)
  ;
  ((self.ui).tex_Buy):SetIndex(self._hasThisChip and 1 or 0)
end

UINWarChessSelectTeam.BindWCSelectTeamEvent = function(self, equipEvent, buyEvent)
  -- function num : 0_3
  self._equipEvent = equipEvent
  self._buyEvent = buyEvent
end

UINWarChessSelectTeam._InitTeamHeroList = function(self, chipData, dynPlayer)
  -- function num : 0_4 , upvalues : _ENV
  local isToPlayer = chipData:IsValidDynPlayer()
  ;
  ((self.ui).obj_TacticNode):SetActive(isToPlayer)
  ;
  ((self.ui).obj_heroList):SetActive(not isToPlayer)
  if not chipData:IsConsumeSkillChip() or not 1 then
    self:_SetTacticNodeActive(not isToPlayer or 0)
    do return  end
    local heroList = {}
    for index,dynHeroData in ipairs(dynPlayer.heroList) do
      if not dynHeroData:IsBench() then
        (table.insert)(heroList, dynHeroData)
      end
    end
    local validCharacters = chipData:GetValidRoleList(heroList, eBattleRoleBelong.player, dynPlayer:GetSpecEffectMgr())
    ;
    (self.heroHeadPool):HideAll()
    for _,dynHero in pairs(validCharacters) do
      local heroHeadItem = (self.heroHeadPool):GetOne()
      heroHeadItem:InitHeroHeadItem(dynHero.heroData, self._resloader)
      heroHeadItem:Show()
    end
  end
end

UINWarChessSelectTeam._InitTeamFightPower = function(self, chipData, dynPlayer, powerType, isOwnData)
  -- function num : 0_5 , upvalues : _ENV
  if dynPlayer == nil then
    ((self.ui).tex_Power):SetIndex(0, "0")
    return 
  end
  self.fightPower = 0
  if powerType == eChipDetailPowerType.Add or powerType == nil then
    self.fightPower = dynPlayer:GetChipCombatEffect(chipData, isOwnData)
    ;
    ((self.ui).tex_Power):SetIndex(0, GetPreciseDecimalStr(self.fightPower, 1))
  else
    if powerType == eChipDetailPowerType.Subtract then
      self.fightPower = dynPlayer:GetChipDiscardFightPower(chipData)
      ;
      ((self.ui).tex_Power):SetIndex(1, GetPreciseDecimalStr(self.fightPower, 1))
    end
  end
end

UINWarChessSelectTeam._SetTacticNodeActive = function(self, index)
  -- function num : 0_6
  ;
  ((self.ui).text_TacticNode):SetIndex(index or 0)
  ;
  ((self.ui).textEn_TacticNode):SetIndex(index or 0)
end

UINWarChessSelectTeam._InitWCTeamUIBase = function(self, teamData)
  -- function num : 0_7
  self._teamData = teamData
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TeamName).text = teamData:GetWCTeamName()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.gameObject).name = teamData:GetWCTeamIndex()
end

UINWarChessSelectTeam.GetWCSelectTeamData = function(self)
  -- function num : 0_8
  return self._teamData
end

UINWarChessSelectTeam._OnClickWCTeamEquip = function(self)
  -- function num : 0_9
  if self._equipEvent ~= nil then
    (self._equipEvent)(self, self._teamData)
  end
end

UINWarChessSelectTeam._OnClickWCTeamBuy = function(self)
  -- function num : 0_10
  if self._buyEvent ~= nil then
    (self._buyEvent)(self, self._teamData)
  end
end

UINWarChessSelectTeam._OnClickChipBag = function(self)
  -- function num : 0_11 , upvalues : WarChessHelper, _ENV
  local successOpenChipBag = (WarChessHelper.OpenWCChipBag)(self._teamData, function()
    -- function num : 0_11_0 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.WarChessSelectChip)
    UIManager:ShowWindowOnly(UIWindowTypeID.WarChessBuyChip)
  end
)
  if successOpenChipBag then
    UIManager:HideWindow(UIWindowTypeID.WarChessSelectChip)
    UIManager:HideWindow(UIWindowTypeID.WarChessBuyChip)
  end
end

return UINWarChessSelectTeam

