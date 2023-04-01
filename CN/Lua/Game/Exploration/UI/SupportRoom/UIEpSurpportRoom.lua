-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpSurpportRoom = class("UIEpSurpportRoom", UIBaseWindow)
local base = UIBaseWindow
local UINEpSptRoomHeroItem = require("Game.Exploration.UI.SupportRoom.UINEpSptRoomHeroItem")
local UINEpSptRoomHeroDetail = require("Game.Exploration.UI.SupportRoom.UINEpSptRoomHeroDetail")
local DynHero = require("Game.Exploration.Data.DynHero")
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
UIEpSurpportRoom.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEpSptRoomHeroItem, UINEpSptRoomHeroDetail, cs_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self._OnClickCancel)
  self._confirmBtnColor = ((self.ui).img_Confirm).color
  self._supportHeroMaxNum = (ConfigData.game_config).supportHeroMaxNum
  ;
  ((self.ui).heroItem):SetActive(false)
  self.heroItemPool = (UIItemPool.New)(UINEpSptRoomHeroItem, (self.ui).heroItem)
  self.heroDetailNode = (UINEpSptRoomHeroDetail.New)()
  ;
  (self.heroDetailNode):Init((self.ui).heroDetail)
  ;
  (self.heroDetailNode):Hide()
  self.resLoader = (cs_ResLoader.Create)()
  self._clickHeroFunc = BindCallback(self, self._OnClickHeroItem)
end

UIEpSurpportRoom.GetSupportRoomData = function(self)
  -- function num : 0_1
  return self.inFormationDic, self.maxHeroCount, self._supHeroItemList
end

UIEpSurpportRoom._InitBase = function(self, dynPlayer, epSptCtrl)
  -- function num : 0_2 , upvalues : _ENV
  self.epSptCtrl = epSptCtrl
  MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, false)
  self.inFormationDic = {}
  self.currentHeroList = dynPlayer.heroList
  self.selectedSptHeroDic = {}
  self.currentHeroDic = {}
  self.maxHeroCount = dynPlayer:GetFmtMaxHeroNum()
  local repeatHeroItemDic = {}
  local tempHeroItemDic = {}
  local tryAddRepeatHeroItem = function(heroId, heroItem)
    -- function num : 0_2_0 , upvalues : tempHeroItemDic, repeatHeroItemDic, _ENV
    if tempHeroItemDic[heroId] ~= nil then
      local heroItemList = repeatHeroItemDic[heroId]
      if heroItemList == nil then
        heroItemList = {tempHeroItemDic[heroId]}
        repeatHeroItemDic[heroId] = heroItemList
      end
      ;
      (table.insert)(heroItemList, heroItem)
      return true
    else
      do
        tempHeroItemDic[heroId] = heroItem
        do return false end
      end
    end
  end

  self.repeatHeroItemDic = repeatHeroItemDic
  for k,dynHero in ipairs(dynPlayer.heroList) do
    local heroItem = (self.heroItemPool):GetOne()
    heroItem:InitEpSptRoomHeroItem(dynHero, self.resLoader, self._clickHeroFunc)
    heroItem:SetEpSptRoomHeroItemSelect(true)
    ;
    (heroItem.transform):SetParent((self.ui).currentList)
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (heroItem.gameObject).name = tostring(k)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.inFormationDic)[dynHero.dataId] = true
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.currentHeroDic)[dynHero] = true
    tryAddRepeatHeroItem(dynHero.dataId, heroItem)
  end
  self:_UpdateHeroNum()
  return tryAddRepeatHeroItem
end

UIEpSurpportRoom.InitEpSurpportRoomEx = function(self, dynPlayer, supportHeroExList, epSptCtrl)
  -- function num : 0_3 , upvalues : _ENV
  self:_InitBase(dynPlayer, epSptCtrl)
  self._supHeroItemList = {}
  for k,heroData in ipairs(supportHeroExList) do
    local heroItem = (self.heroItemPool):GetOne()
    heroItem:InitEpSptRoomHeroExItem(heroData, self.resLoader, self._clickHeroFunc)
    ;
    (heroItem.transform):SetParent((self.ui).supportList)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (heroItem.gameObject).name = tostring(k)
    ;
    (table.insert)(self._supHeroItemList, heroItem)
  end
  self.__cancleFunc = function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    (self.epSptCtrl):ReqChangeSupportExHero(table.emptytable, table.emptytable)
  end

  self.__confirmFunc = function(curHeroNum)
    -- function num : 0_3_1 , upvalues : _ENV, supportHeroExList, self
    local addNum, removeNum = 0, 0
    local quitHeroUidDic, enterIdDic = {}, {}
    for k,heroData in ipairs(supportHeroExList) do
      if (self.inFormationDic)[heroData.dataId] == false then
        enterIdDic[heroData.dataId] = true
        addNum = addNum + 1
      end
    end
    for k,dynHero in pairs(self.currentHeroList) do
      if (self.inFormationDic)[dynHero.dataId] ~= true then
        quitHeroUidDic[dynHero.uid] = true
        if (self.inFormationDic)[dynHero.dataId] ~= false then
          removeNum = removeNum + 1
        end
      end
    end
    local confirmFunc = function()
      -- function num : 0_3_1_0 , upvalues : self, quitHeroUidDic, enterIdDic
      (self.epSptCtrl):ReqChangeSupportExHero(quitHeroUidDic, enterIdDic)
    end

    if self:_TryShowConfimWin(addNum, removeNum, curHeroNum, confirmFunc) then
      return 
    end
    confirmFunc()
  end

end

UIEpSurpportRoom.InitEpSurpportRoom = function(self, dynPlayer, supportHeroList, epSptCtrl)
  -- function num : 0_4 , upvalues : _ENV
  local tryAddRepeatHeroItemFunc = self:_InitBase(dynPlayer, epSptCtrl)
  self._supHeroItemList = {}
  for k,dynHero in ipairs(supportHeroList) do
    local heroItem = (self.heroItemPool):GetOne()
    heroItem:InitEpSptRoomHeroItem(dynHero, self.resLoader, self._clickHeroFunc)
    ;
    (heroItem.transform):SetParent((self.ui).supportList)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (heroItem.gameObject).name = tostring(k)
    if tryAddRepeatHeroItemFunc(dynHero.dataId, heroItem) then
      heroItem:SetEpSptRoomHeroItemHas(true)
    else
      ;
      (table.insert)(self._supHeroItemList, heroItem)
    end
  end
  self.__cancleFunc = function()
    -- function num : 0_4_0 , upvalues : self, _ENV
    (self.epSptCtrl):ReqChangeSupportHero(table.emptytable, table.emptytable)
  end

  self.__confirmFunc = function(curHeroNum)
    -- function num : 0_4_1 , upvalues : _ENV, supportHeroList, self
    local addNum, removeNum = 0, 0
    local quitHeroUidList = {}
    local enterIdList = {}
    for k,dynHero in ipairs(supportHeroList) do
      if (self.inFormationDic)[dynHero.dataId] == false then
        (table.insert)(enterIdList, k - 1)
        addNum = addNum + 1
      end
    end
    for k,dynHero in pairs(self.currentHeroList) do
      if (self.inFormationDic)[dynHero.dataId] ~= true then
        (table.insert)(quitHeroUidList, dynHero.uid)
        if (self.inFormationDic)[dynHero.dataId] ~= false then
          removeNum = removeNum + 1
        end
      end
    end
    local confirmFunc = function()
      -- function num : 0_4_1_0 , upvalues : self, quitHeroUidList, enterIdList
      (self.epSptCtrl):ReqChangeSupportHero(quitHeroUidList, enterIdList)
    end

    if self:_TryShowConfimWin(addNum, removeNum, curHeroNum, confirmFunc) then
      return 
    end
    confirmFunc()
  end

end

UIEpSurpportRoom.InitEpSurpportRoomForWC = function(self, dynPlayer, supportHeroMixedList, cancleFunc, confirmFunc)
  -- function num : 0_5 , upvalues : _ENV, DynHero
  self:_InitBase(dynPlayer)
  self._supHeroItemList = {}
  self._supportHeroMaxNum = dynPlayer:GetFmtMaxHeroNum()
  for heroId,mixedHeroData in pairs(supportHeroMixedList) do
    local heroItem = (self.heroItemPool):GetOne()
    if IsInstanceOfClass(mixedHeroData, DynHero) then
      heroItem:InitEpSptRoomHeroItem(mixedHeroData, self.resLoader, self._clickHeroFunc)
    else
      heroItem:InitEpSptRoomHeroExItem(mixedHeroData, self.resLoader, self._clickHeroFunc)
    end
    ;
    (heroItem.transform):SetParent((self.ui).supportList)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (heroItem.gameObject).name = tostring(heroId)
    ;
    (table.insert)(self._supHeroItemList, heroItem)
  end
  self.__cancleFunc = cancleFunc
  self.__confirmFunc = function(curHeroNum)
    -- function num : 0_5_0 , upvalues : _ENV, supportHeroMixedList, self, confirmFunc
    local addNum, removeNum = 0, 0
    local quitHeroUidList = {}
    local quitHeroIdList = {}
    local enterIdList = {}
    for _,mixedHeroData in pairs(supportHeroMixedList) do
      if (self.inFormationDic)[mixedHeroData.dataId] == false then
        (table.insert)(enterIdList, mixedHeroData.dataId)
        addNum = addNum + 1
      end
    end
    for _,dynHero in pairs(self.currentHeroList) do
      if (self.inFormationDic)[dynHero.dataId] ~= true then
        (table.insert)(quitHeroUidList, dynHero.uid)
        ;
        (table.insert)(quitHeroIdList, dynHero.dataId)
        if (self.inFormationDic)[dynHero.dataId] ~= false then
          removeNum = removeNum + 1
        end
      end
    end
    local myConfirmFunc = BindCallback(confirmFunc, enterIdList, quitHeroIdList)
    if self:_TryShowConfimWin(addNum, removeNum, curHeroNum, myConfirmFunc) then
      return 
    end
    myConfirmFunc()
  end

end

UIEpSurpportRoom._UpdateHeroNum = function(self)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Limit).text = tostring((table.count)(self.inFormationDic)) .. "/" .. tostring(self.maxHeroCount)
end

UIEpSurpportRoom._SetRepeatHeroHas = function(self, heroId, heroItem, has)
  -- function num : 0_7 , upvalues : _ENV
  local repeatHeroItemList = (self.repeatHeroItemDic)[heroId]
  if repeatHeroItemList ~= nil then
    for k,item in ipairs(repeatHeroItemList) do
      if item ~= heroItem then
        item:SetEpSptRoomHeroItemHas(has)
      end
    end
  end
end

UIEpSurpportRoom._OnClickHeroItem = function(self, heroItem, dynHeroData, fightPower, isHeroData)
  -- function num : 0_8 , upvalues : _ENV, cs_MessageCommon
  if (self.inFormationDic)[dynHeroData.dataId] == nil then
    if self.maxHeroCount <= (table.count)(self.inFormationDic) then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Formation_MaxHeroCount))
      return 
    end
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

    if (self.currentHeroDic)[dynHeroData] ~= nil then
      (self.inFormationDic)[dynHeroData.dataId] = true
    else
      local limitNum = self._supportHeroMaxNum
      if limitNum <= (table.count)(self.selectedSptHeroDic) then
        (cs_MessageCommon.ShowMessageTipsWithErrorSound)((string.format)(ConfigData:GetTipContent(168), limitNum))
        return 
      end
      -- DECOMPILER ERROR at PC48: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.inFormationDic)[dynHeroData.dataId] = false
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.selectedSptHeroDic)[dynHeroData] = true
    end
    do
      heroItem:SetEpSptRoomHeroItemSelect(true)
      self:_SetRepeatHeroHas(dynHeroData.dataId, heroItem, true)
      ;
      (self.heroDetailNode):Show()
      if isHeroData then
        (self.heroDetailNode):InitEpSptExRoomHeroDetail(dynHeroData, self.resLoader, fightPower)
      else
        ;
        (self.heroDetailNode):InitEpSptRoomHeroDetail(dynHeroData, self.resLoader, fightPower)
      end
      AudioManager:PlayAudioById(1059)
      heroItem:SetEpSptRoomHeroItemSelect(false)
      -- DECOMPILER ERROR at PC87: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.inFormationDic)[dynHeroData.dataId] = nil
      -- DECOMPILER ERROR at PC89: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (self.selectedSptHeroDic)[dynHeroData] = nil
      self:_SetRepeatHeroHas(dynHeroData.dataId, heroItem, false)
      ;
      (self.heroDetailNode):Hide()
      local canConfirm = #self.currentHeroList <= (table.count)(self.inFormationDic)
      -- DECOMPILER ERROR at PC117: Confused about usage of register: R6 in 'UnsetPending'

      if not canConfirm or not self._confirmBtnColor then
        ((self.ui).img_Confirm).color = Color.gray
        self:_UpdateHeroNum()
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
  end
end

UIEpSurpportRoom.EpSupportConfirm = function(self)
  -- function num : 0_9
  self:_OnClickConfirm()
end

UIEpSurpportRoom._OnClickConfirm = function(self)
  -- function num : 0_10 , upvalues : _ENV, cs_MessageCommon
  local curHeroNum = (table.count)(self.inFormationDic)
  if curHeroNum < #self.currentHeroList then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(169))
    return 
  end
  if self.__confirmFunc ~= nil then
    (self.__confirmFunc)(curHeroNum)
  end
end

UIEpSurpportRoom._TryShowConfimWin = function(self, addNum, removeNum, curHeroNum, confirmFunc)
  -- function num : 0_11 , upvalues : _ENV
  if curHeroNum < self.maxHeroCount and (addNum < self._supportHeroMaxNum or removeNum > 0) then
    UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_11_0 , upvalues : _ENV, confirmFunc
    if win == nil then
      return 
    end
    win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(765), confirmFunc)
  end
)
    return true
  end
  return false
end

UIEpSurpportRoom.EpSupportCancel = function(self)
  -- function num : 0_12
  self:_OnClickCancel()
end

UIEpSurpportRoom._OnClickCancel = function(self)
  -- function num : 0_13
  if self.__cancleFunc ~= nil then
    (self.__cancleFunc)()
  end
end

UIEpSurpportRoom.OnDelete = function(self)
  -- function num : 0_14 , upvalues : _ENV, base
  (self.heroItemPool):DeleteAll()
  ;
  (self.heroDetailNode):Delete()
  ;
  (self.resLoader):Put2Pool()
  self.resLoader = nil
  MsgCenter:Broadcast(eMsgEventId.DungeonHeroListActiveSet, true)
  ;
  (base.OnDelete)(self)
end

return UIEpSurpportRoom

