-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessStoreCtrl = class("WarChessStoreCtrl", base)
local ChipData = require("Game.PlayerData.Item.ChipData")
local BuffData = require("Game.WarChess.Data.WarChessBuffData")
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
WarChessStoreCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__storeSystemData = nil
  self.__identify = nil
  self.__storeDataList = nil
  self.wcCtrl = wcCtrl
end

WarChessStoreCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).shop
end

WarChessStoreCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV
  if systemState == nil or systemState.storeSystemData == nil then
    error("not have data")
    return 
  end
  self.__storeSystemData = systemState.storeSystemData
  self.__identify = identify
  self.__curTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid(identify.tid)
  self:__DealStoreData()
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessStore, function(win)
    -- function num : 0_2_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitWCChipStore(self)
  end
)
end

WarChessStoreCtrl.__DealStoreData = function(self)
  -- function num : 0_3 , upvalues : _ENV, ChipEnum, ChipData, BuffData
  self.__storeChipDataList = {}
  for index,elem in ipairs((self.__storeSystemData).storeElem) do
    local storeData = {}
    storeData.idx = index - 1
    storeData.id = elem.algId
    storeData.discount = 100
    storeData.saled = elem.purchased
    local alg = elem.alg
    local itemId, level = (ExplorationManager.ChipServerIdConvert)(alg)
    local chipCfg = (ConfigData.chip)[itemId]
    if chipCfg == nil then
      error("Can\'t find chip cfg, id = " .. tostring(itemId))
    else
      if chipCfg.type == (ChipEnum.eChipType).Buff then
        error("storeElem not support buff yet")
      else
        local chipData = (ChipData.NewChipForLocal)(itemId, level)
        if (self.__storeSystemData).buffRate ~= nil then
          chipData.wcChipServerBuyRate = 1 + (self.__storeSystemData).buffRate / 10000
        end
        chipData.wcBuffServerBuyPriceAdd = (self.__storeSystemData).buffPrice or 0
        storeData.chipData = chipData
      end
      do
        do
          ;
          (table.insert)(self.__storeChipDataList, storeData)
          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  if (self.__storeSystemData).buffElem ~= nil then
    self.__storeBuffDataList = {}
    for index,elem in ipairs((self.__storeSystemData).buffElem) do
      local storeData = {}
      storeData.idx = index
      storeData.id = elem.buffId
      storeData.discount = 100
      storeData.saled = elem.purchased
      local alg = elem.buffId
      local chipCfg = (ConfigData.chip)[alg]
      if chipCfg == nil then
        error("Can\'t find chip cfg, id = " .. tostring(alg))
      else
        if chipCfg.type == (ChipEnum.eChipType).WarChessBuff then
          local buffData = (BuffData.CrearteBuffById)(alg)
          storeData.epBuffData = buffData
        else
          do
            do
              error("buffElem not support chip yet")
              ;
              (table.insert)(self.__storeBuffDataList, storeData)
              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC119: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
end

WarChessStoreCtrl.GetWCChipDataList = function(self)
  -- function num : 0_4
  return self.__storeChipDataList
end

WarChessStoreCtrl.GetWCBuffDataList = function(self)
  -- function num : 0_5
  return self.__storeBuffDataList
end

WarChessStoreCtrl.GetWCCoinItemIconId = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local cfg = (ConfigData.item)[ConstGlobalItem.WCMoney]
  return cfg ~= nil and cfg.icon or nil
end

WarChessStoreCtrl.GetWCCoinItemNum = function(self)
  -- function num : 0_7
  return ((self.wcCtrl).backPackCtrl):GetWCCoinNum()
end

WarChessStoreCtrl.GetWCRareItemIconId = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local cfg = (ConfigData.item)[ConstGlobalItem.WCDeployPoint]
  return cfg ~= nil and cfg.icon or nil
end

WarChessStoreCtrl.GetWCRareItemNum = function(self)
  -- function num : 0_9
  return ((self.wcCtrl).backPackCtrl):GetWCDeployPointNum()
end

WarChessStoreCtrl.GetRefreshTime = function(self)
  -- function num : 0_10
  if self.__storeSystemData ~= nil then
    return (self.__storeSystemData).refreshTime
  end
end

WarChessStoreCtrl.GetCoinExchangeIsUse = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local leftNumDic = (self.__storeSystemData).buyItemNum
  local rare2coin = ConstGlobalItem.WCDeployPoint << 32 | ConstGlobalItem.WCMoney
  local isRunOut = leftNumDic[rare2coin] or 0 <= 0
  do return isRunOut end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessStoreCtrl.GetRareExchangeIsUse = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local leftNumDic = (self.__storeSystemData).buyItemNum
  local coin2rare = ConstGlobalItem.WCMoney << 32 | ConstGlobalItem.WCDeployPoint
  local isRunOut = leftNumDic[coin2rare] or 0 <= 0
  do return isRunOut end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessStoreCtrl.GetExChangeItemID = function(self, itemId)
  -- function num : 0_13 , upvalues : _ENV
  local costItemID = -1
  if itemId == ConstGlobalItem.WCMoney then
    costItemID = ConstGlobalItem.WCDeployPoint
  else
    if itemId == ConstGlobalItem.WCDeployPoint then
      costItemID = ConstGlobalItem.WCMoney
    end
  end
  return costItemID
end

WarChessStoreCtrl.GetWarChessStoreRefreshPrice = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local shopId = WarChessManager:GetWCLevelShopId()
  local refreshTimes = self:GetRefreshTime()
  local refreshCostBaseNum = ((ConfigData.warchess_shop_coin)[shopId]).init_fresh_price
  local refreshIncreaseNum = ((ConfigData.warchess_shop_coin)[shopId]).increase_fresh_price
  local result = refreshCostBaseNum + refreshIncreaseNum * refreshTimes
  return result
end

WarChessStoreCtrl.WCBuyChip = function(self, storeData, teamUid, callback)
  -- function num : 0_15
  local idx = storeData.idx
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_SelectAlg(self.__identify, idx, teamUid, function()
    -- function num : 0_15_0 , upvalues : storeData, callback
    storeData.saled = true
    if callback ~= nil then
      callback()
    end
  end
)
end

WarChessStoreCtrl.WCSaleChip = function(self, chipId, teamUid, callback)
  -- function num : 0_16
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_SaleAlg(self.__identify, chipId, teamUid, function()
    -- function num : 0_16_0 , upvalues : callback
    if callback ~= nil then
      callback()
    end
  end
)
end

WarChessStoreCtrl.WCRefresh = function(self, callback)
  -- function num : 0_17
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_Refresh(self.__identify, function(argList)
    -- function num : 0_17_0 , upvalues : self, callback
    do
      if argList ~= nil and argList.Count > 0 then
        local storeSystemData = argList[0]
        self.__storeSystemData = storeSystemData
        self:__DealStoreData()
      end
      if callback ~= nil then
        callback()
      end
    end
  end
)
end

WarChessStoreCtrl.WCExchangeItem = function(self, itemId, callback)
  -- function num : 0_18 , upvalues : _ENV
  local costItemID = self:GetExChangeItemID(itemId)
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_ExchangeItem(self.__identify, costItemID, function(argList)
    -- function num : 0_18_0 , upvalues : self, _ENV, callback
    if argList ~= nil and argList.Count > 0 then
      local costItemID = argList[0]
      local leftNumDic = (self.__storeSystemData).buyItemNum
      if costItemID == ConstGlobalItem.WCMoney then
        local coin2rare = ConstGlobalItem.WCMoney << 32 | ConstGlobalItem.WCDeployPoint
        leftNumDic[coin2rare] = (leftNumDic[coin2rare] or 0) - 1
      else
        do
          do
            if costItemID == ConstGlobalItem.WCDeployPoint then
              local rare2coin = ConstGlobalItem.WCDeployPoint << 32 | ConstGlobalItem.WCMoney
              leftNumDic[rare2coin] = (leftNumDic[rare2coin] or 0) - 1
            end
            if callback ~= nil then
              callback()
            end
          end
        end
      end
    end
  end
)
end

WarChessStoreCtrl.WCBuyBuff = function(self, storeData, callback)
  -- function num : 0_19
  local idx = storeData.idx - 1
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_SelectBuff(self.__identify, idx, function()
    -- function num : 0_19_0 , upvalues : storeData, callback
    storeData.saled = true
    if callback ~= nil then
      callback()
    end
  end
)
end

WarChessStoreCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_20 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  UIManager:DeleteWindow(UIWindowTypeID.WarChessStore)
  self.__storeSystemData = nil
  self.__identify = nil
  self.__storeChipDataList = nil
  self.__storeBuffDataList = nil
end

WarChessStoreCtrl.ExitWCStore = function(self, callback)
  -- function num : 0_21
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_StoreSystem_Quit(self.__identify, function()
    -- function num : 0_21_0 , upvalues : callback
    if callback ~= nil then
      callback()
    end
  end
)
  self.__storeSystemData = nil
  self.__identify = nil
  self.__storeChipDataList = nil
  self.__storeBuffDataList = nil
end

WarChessStoreCtrl.Delete = function(self)
  -- function num : 0_22
end

return WarChessStoreCtrl

