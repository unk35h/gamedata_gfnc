-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessBackPackCtrl = class("WarChessBackPackCtrl", base)
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
WarChessBackPackCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__backpackDic = {}
  self.__backpackLimitAddNumDic = {}
  self.__BuffDataDic = {}
  self.__numericDic = {}
  self.__isHaveRewardBag = false
  self.__pickableItemList = {}
end

WarChessBackPackCtrl.SetWCBakcPack = function(self, warChessUser, seasonItemNum, isHaveRewardBag, strengthWinReward)
  -- function num : 0_1 , upvalues : _ENV, WarChessBuffData
  self.__backpackDic = {}
  self.__BuffDataDic = {}
  for itemId,itemNum in pairs(warChessUser.items) do
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self.__backpackDic)[itemId] = itemNum + ((self.__backpackDic)[itemId] or 0)
  end
  for _,buffMsg in pairs(warChessUser.warChessBuffs) do
    local buffUID = buffMsg.uid
    local buffData = (WarChessBuffData.CrearteBuffByMsg)(buffMsg)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self.__BuffDataDic)[buffUID] = buffData
  end
  self.__backpackLimitAddNumDic = seasonItemNum
  self.__numericDic = warChessUser.numeric
  for itemId,itemMaxNum in pairs(warChessUser.triggerItemLimit) do
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R10 in 'UnsetPending'

    (self.__backpackLimitAddNumDic)[itemId] = itemMaxNum
  end
  self.__isHaveRewardBag = isHaveRewardBag
  self.__isNeedUpdateList = true
  self.__pickableItemList = {}
  self:__DealRewardBagRewardList(strengthWinReward)
end

WarChessBackPackCtrl.UpdateBackPack = function(self, roleItemDiff)
  -- function num : 0_2 , upvalues : _ENV, WarChessBuffData
  for itemId,num in pairs(roleItemDiff.update) do
    do
      local addNum = 0
      -- DECOMPILER ERROR at PC8: Confused about usage of register: R8 in 'UnsetPending'

      if num == 0 then
        (self.__backpackDic)[itemId] = nil
      else
        addNum = num - ((self.__backpackDic)[itemId] or 0)
        -- DECOMPILER ERROR at PC17: Confused about usage of register: R8 in 'UnsetPending'

        ;
        (self.__backpackDic)[itemId] = num
      end
      MsgCenter:Broadcast(eMsgEventId.WC_ItemNumChange, itemId, num, addNum)
      if ConstWCShowCoin[itemId] ~= nil then
        MsgCenter:Broadcast(eMsgEventId.WC_CoinNumChange, itemId, num, addNum)
        if addNum > 0 and itemId == ConstGlobalItem.WCDeployPoint then
          UIManager:ShowWindowAsync(UIWindowTypeID.WarChessNotice, function(window)
    -- function num : 0_2_0 , upvalues : itemId, addNum
    if window ~= nil then
      window:OnWCGetDeployPoint(itemId, addNum)
    end
  end
)
        end
      end
    end
  end
  for itemId,limitNum in pairs(roleItemDiff.updateLimit) do
    local limitNum = nil
    limitNum = self.__backpackLimitAddNumDic
    limitNum[l_0_2_10] = itemId
    limitNum = MsgCenter
    limitNum(limitNum, eMsgEventId.WC_ItemLimitNumChange, l_0_2_10, itemId)
  end
  local isBuffUpdated = nil
  for key,buffMsg in isBuffUpdated do
    local buffMsg = nil
    local buffUID = nil
    -- DECOMPILER ERROR at PC76: Overwrote pending register: R9 in 'AssignReg'

    local buffData = nil
    if buffUID == nil then
      local buffData = nil
    else
      do
        do
          -- DECOMPILER ERROR at PC85: Overwrote pending register: R11 in 'AssignReg'

          -- DECOMPILER ERROR at PC85: Overwrote pending register: R10 in 'AssignReg'

          buffData(buffData, key)
          -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC89: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  -- DECOMPILER ERROR at PC91: Overwrote pending register: R3 in 'AssignReg'

  for uid,_ in isBuffUpdated(roleItemDiff.buffDelete) do
    local _ = buffMsg
    local buffUID = buffUID
    -- DECOMPILER ERROR at PC97: Overwrote pending register: R9 in 'AssignReg'

    local buffData = buffData
  end
  if buffUID == nil or true then
    MsgCenter:Broadcast(eMsgEventId.WC_BuffChange)
  end
  for type,value in pairs(roleItemDiff.numericUpdate) do
    local value = _
    if type == 0 then
      value = self.__numericDic
      value[l_0_2_31] = nil
    else
      value = self.__numericDic
      value[l_0_2_31] = type
    end
    value = proto_object_WarChessNumeric
    value = value.WarChessNumericModifyBehaviorPointLimit
    if l_0_2_31 == value then
      value = MsgCenter
      -- DECOMPILER ERROR at PC128: Overwrote pending register: R9 in 'AssignReg'

      value = value:Broadcast
      -- DECOMPILER ERROR at PC129: Overwrote pending register: R10 in 'AssignReg'

      value(buffUID, buffData.WC_APLimitChange)
    end
  end
  self:__DealRewardBagRewardList(roleItemDiff.updateStrength)
  ;
  ((self.wcCtrl).palySquCtrl):WhenBackPackUpdate()
end

WarChessBackPackCtrl.__DealRewardBagRewardList = function(self, list)
  -- function num : 0_3 , upvalues : _ENV
  if list == nil then
    return 
  end
  if (table.count)(list) > 0 then
    ((self.wcCtrl).palySquCtrl):SetIsHaveNewRewradBagReward(true)
    for _,StmGoodElem in pairs(list) do
      (table.insert)(self.__pickableItemList, StmGoodElem)
    end
  end
end

WarChessBackPackCtrl.GetWCCoinNum = function(self)
  -- function num : 0_4 , upvalues : _ENV
  return self:GetWCItemNum(ConstGlobalItem.WCMoney)
end

WarChessBackPackCtrl.SetCacheMoneyCount = function(self, goldCount)
  -- function num : 0_5
  self.cacheMoney = goldCount
end

WarChessBackPackCtrl.GetCacheMoneyCount = function(self)
  -- function num : 0_6
  return self.cacheMoney or 0
end

WarChessBackPackCtrl.GetWCItemNum = function(self, itemId)
  -- function num : 0_7
  return (self.__backpackDic)[itemId] or 0
end

WarChessBackPackCtrl.GetWCItemCapacity = function(self, itemId)
  -- function num : 0_8
  return (self.__backpackLimitAddNumDic)[itemId] or 0
end

WarChessBackPackCtrl.GetWCDeployPointNum = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return self:GetWCItemNum(ConstGlobalItem.WCDeployPoint)
end

WarChessBackPackCtrl.GetWCBuffDic = function(self)
  -- function num : 0_10
  return self.__BuffDataDic
end

WarChessBackPackCtrl.GetWCUserNumericNum = function(self, type)
  -- function num : 0_11
  return (self.__numericDic)[type] or 0
end

WarChessBackPackCtrl.GetIsWCHaveRewardBag = function(self)
  -- function num : 0_12
  return self.__isHaveRewardBag
end

WarChessBackPackCtrl.GetIsWCRewardBagItemList = function(self)
  -- function num : 0_13
  return self.__pickableItemList
end

WarChessBackPackCtrl.Delete = function(self)
  -- function num : 0_14
end

return WarChessBackPackCtrl

