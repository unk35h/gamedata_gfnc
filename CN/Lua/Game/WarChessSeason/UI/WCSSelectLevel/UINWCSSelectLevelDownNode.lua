-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWCSSelectLevelDownNode = class("UINWCSSelectLevelDownNode", base)
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
local UINWCSSelectNubIconItem = require("Game.WarChessSeason.UI.WCSSelectLevel.UINWCSSelectNubIconItem")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local eWarChessUIEnum = require("Game.WarChess.UI.eWarChessUIEnum")
local MID_ITEM_INDEX = 5
local MAX_ITEM_NUM = 9
UINWCSSelectLevelDownNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCSSelectNubIconItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.NubIconPool = (UIItemPool.New)(UINWCSSelectNubIconItem, (self.ui).obj_NubIcon)
  ;
  ((self.ui).obj_NubIcon):SetActive(false)
  self.__dwonWidth = 1391
  self.__waitPopIconShowLsitIdx = {}
  self.__showList = {}
  self.__curLevelFloor = 0
  self.__curShowListFloor = 0
  local addtionData = WarChessSeasonManager:GetSeasonAddtionData()
  self.__completeFloor = addtionData:GetSeasonCompleteFloor()
end

UINWCSSelectLevelDownNode.RefreshWCSLLevelBar = function(self)
  -- function num : 0_1 , upvalues : _ENV, MID_ITEM_INDEX, MAX_ITEM_NUM, eWarChessUIEnum
  self.__curIcon = nil
  local towerId = WarChessSeasonManager:GetWCSSeasonTowerID()
  local floorCfg = (ConfigData.warchess_season_floor)[towerId]
  if floorCfg == nil then
    error("can\'t read floorCfg by seasonGroupId:" .. tostring(towerId))
    return 
  end
  local curFloor = (WarChessSeasonManager:GetWCSCtrl()):WCSGetFloor()
  local isInLobby = WarChessSeasonManager:GetIsInWCSeasonIsInLobby()
  local isPassCompleteFloor = self.__completeFloor < curFloor
  self.__curLevelFloor = curFloor
  self._curBarItem = nil
  self._nextBarItem = nil
  local curShowFloor = curFloor
  local showList = {}
  for foorIndex,floorCfg in pairs(floorCfg) do
    if floorCfg.hall_level_id > 0 then
      (table.insert)(showList, {cfgIdx = foorIndex, isInLobby = true})
    end
    if foorIndex == curFloor and isInLobby then
      curShowFloor = #showList
    elseif foorIndex == curFloor and not isInLobby then
      curShowFloor = #showList + 1
    end
    ;
    (table.insert)(showList, {cfgIdx = foorIndex, isInLobby = false})
  end
  self.__curShowListFloor = curShowFloor
  self.__showList = showList
  local totalLevelNum = #showList
  ;
  (self.NubIconPool):HideAll()
  local startShowIconIdx = 1
  if MID_ITEM_INDEX < curShowFloor then
    startShowIconIdx = curShowFloor - (MID_ITEM_INDEX - 1)
  end
  self.__waitPopIconShowLsitIdx = {}
  local showIndex = startShowIconIdx
  while showIndex < startShowIconIdx + MAX_ITEM_NUM and showIndex <= totalLevelNum do
    local showOneData = showList[showIndex]
    local foorIndex = showOneData.cfgIdx
    local nubIcon = (self.NubIconPool):GetOne()
    local showCfg = showOneData
    local barItemType = (eWarChessUIEnum.WCSBarItemType).Number
    local isBossFloor = false
    if showCfg.isInLobby then
      barItemType = (eWarChessUIEnum.WCSBarItemType).Lobby
    elseif (floorCfg[showCfg.cfgIdx]).level_show_type == 1 then
      barItemType = (eWarChessUIEnum.WCSBarItemType).Boss
      isBossFloor = true
    end
    local hasFlg = (self.__completeFloor < curFloor and foorIndex == self.__completeFloor and not showOneData.isInLobby)
    nubIcon:InitWCSNubState(barItemType, foorIndex, hasFlg)
    if curShowFloor <= showIndex then
      nubIcon:WCSNubIconGrey()
    end
    if curShowFloor == showIndex then
      self._curBarItem = nubIcon
    elseif showIndex == curShowFloor + 1 then
      self._nextBarItem = nubIcon
    end
    if not isPassCompleteFloor and self.__completeFloor < foorIndex then
      nubIcon:Hide()
      ;
      (table.insert)(self.__waitPopIconShowLsitIdx, nubIcon)
    end
    showIndex = showIndex + 1
  end
  self.__showIndex = showIndex
  self.__startShowIconIdx = startShowIconIdx
  local amount = 0.125 * (curShowFloor - (startShowIconIdx))
  -- DECOMPILER ERROR at PC168: Confused about usage of register: R12 in 'UnsetPending'

  if amount >= 0 or not 0 then
    ((self.ui).img_Line).fillAmount = amount
    local curShowNum = showIndex - (startShowIconIdx) - #self.__waitPopIconShowLsitIdx
    local length = self.__dwonWidth / (MAX_ITEM_NUM - 1) * (curShowNum - 1)
    -- DECOMPILER ERROR at PC186: Confused about usage of register: R14 in 'UnsetPending'

    ;
    ((self.ui).rect_dottedLine).sizeDelta = (Vector2.New)(length, 7)
    -- DECOMPILER ERROR: 17 unprocessed JMP targets
  end
end

UINWCSSelectLevelDownNode.StartWCSSLDownBarCurZoomTween = function(self, seq)
  -- function num : 0_2 , upvalues : cs_DoTween
  if seq == nil then
    seq = (cs_DoTween.Sequence)()
  end
  seq:AppendInterval(1)
  if self._curBarItem ~= nil then
    (self._curBarItem):WCSAppendIconComplete(seq)
  end
  return seq
end

UINWCSSelectLevelDownNode.StartWCSSDownBarLineTween = function(self, seq)
  -- function num : 0_3 , upvalues : MAX_ITEM_NUM, cs_DoTween
  local amount = 1 / (MAX_ITEM_NUM - 1) * (self.__curShowListFloor + 1 - self.__startShowIconIdx)
  if seq == nil then
    seq = (cs_DoTween.Sequence)()
  end
  seq:Append(((self.ui).img_Line):DOFillAmount(amount, 0.5))
  if self._curBarItem ~= nil then
    (self._curBarItem):WCSNubIconLight()
  end
  return seq
end

UINWCSSelectLevelDownNode.StartWCSSLDownNodePlayPopHideLevelTween = function(self, seq)
  -- function num : 0_4 , upvalues : cs_DoTween, MAX_ITEM_NUM, _ENV
  if self.__curLevelFloor ~= self.__completeFloor then
    return seq
  end
  if seq == nil then
    seq = (cs_DoTween.Sequence)()
  end
  ;
  (self._curBarItem):AddWCSBarItemCompleteOutlineExpand(seq)
  ;
  (self._curBarItem):WCSAppendIconFlag(seq)
  local curShowNum = self.__showIndex - self.__startShowIconIdx
  local length = self.__dwonWidth / (MAX_ITEM_NUM - 1) * (curShowNum - 1)
  seq:Join(((self.ui).rect_dottedLine):DOSizeDelta((Vector2.New)(length, 7), 0.2 * #self.__waitPopIconShowLsitIdx))
  for index,nubIcon in ipairs(self.__waitPopIconShowLsitIdx) do
    nubIcon:AddWCSBarItemExpand(seq, (index - 1) * 0.2)
    if nubIcon == self._nextBarItem then
      (self._nextBarItem):WCSPlayNextTips()
    end
  end
  seq:AppendInterval(0.2)
  return seq
end

UINWCSSelectLevelDownNode.ShowNextTip = function(self)
  -- function num : 0_5
  if self._nextBarItem then
    (self._nextBarItem):WCSPlayNextTips()
  end
end

UINWCSSelectLevelDownNode.GetCurLevelFloor = function(self)
  -- function num : 0_6
  return self.__curLevelFloor
end

UINWCSSelectLevelDownNode.OnHide = function(self)
  -- function num : 0_7
end

UINWCSSelectLevelDownNode.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (self.NubIconPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINWCSSelectLevelDownNode

