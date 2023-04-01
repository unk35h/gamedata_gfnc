-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessStrategyRewardCtrl = class("WarChessStrategyRewardCtrl", base)
local ChipData = require("Game.PlayerData.Item.ChipData")
local BuffData = require("Game.WarChess.Data.WarChessBuffData")
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
WarChessStrategyRewardCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__strategySystemData = nil
  self.__identify = nil
end

WarChessStrategyRewardCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).strategyReward
end

WarChessStrategyRewardCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV
  if systemState == nil or systemState.strategySystemData == nil then
    error("not have data")
    return 
  end
  self.__strategySystemData = systemState.strategySystemData
  self.__identify = identify
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessStrategyReward, function(win)
    -- function num : 0_2_0
    if win == nil then
      return 
    end
    win:InitWCStrategyReward()
  end
)
end

WarChessStrategyRewardCtrl.GetWCStrategyFixedReward = function(self)
  -- function num : 0_3
  return (self.__strategySystemData).fixedReward
end

WarChessStrategyRewardCtrl.GetWCStrategySelectRewards = function(self)
  -- function num : 0_4 , upvalues : _ENV, ChipData, BuffData
  local srIdList = (self.__strategySystemData).strategyRewardIds
  local rewardList = (self.__strategySystemData).strategyReward
  local selectRewardList = {}
  for index,srId in ipairs(srIdList) do
    local srElem = rewardList[index]
    local chipDataList, buffDataList = nil, nil
    if srElem.rewardType == 1 then
      chipDataList = {}
      for alg,_ in pairs(srElem.rewards) do
        local itemId, level = (ExplorationManager.ChipServerIdConvert)(alg)
        local chipData = (ChipData.NewChipForLocal)(itemId, level)
        ;
        (table.insert)(chipDataList, chipData)
      end
    else
      do
        if srElem.rewardType == 2 then
          buffDataList = {}
          for itemId,num in pairs(srElem.rewards) do
            local buffData = (BuffData.CrearteBuffById)(itemId)
            ;
            (table.insert)(buffDataList, buffData)
          end
        end
        do
          do
            selectRewardList[index] = {index = index - 1, srElem = srElem, srId = srId, chipDataList = chipDataList, buffDataList = buffDataList}
            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  return selectRewardList
end

WarChessStrategyRewardCtrl.WCStrategySelectChipReward = function(self, index, teamData)
  -- function num : 0_5
end

WarChessStrategyRewardCtrl.WCStrategySelectReward = function(self, indexStrategyKey, rewardMapKey, tid)
  -- function num : 0_6
  if not tid then
    tid = (self.__identify).tid
  end
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Event_StrategySelect(self.__identify, indexStrategyKey, rewardMapKey, tid, function()
    -- function num : 0_6_0
  end
)
end

WarChessStrategyRewardCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  UIManager:DeleteWindow(UIWindowTypeID.WarChessStrategyReward)
end

WarChessStrategyRewardCtrl.Delete = function(self)
  -- function num : 0_8
end

return WarChessStrategyRewardCtrl

