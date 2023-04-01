-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessStrategyReward = class("UIWarChessStrategyReward", base)
local UINWarChessStrategySelectItem = require("Game.WarChess.UI.Strategy.UINWarChessStrategySelectItem")
UIWarChessStrategyReward.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessStrategySelectItem
  self.__selectedItem = nil
  self.strategyItemPool = (UIItemPool.New)(UINWarChessStrategySelectItem, (self.ui).obj_StrategyItem)
  ;
  ((self.ui).obj_StrategyItem):SetActive(false)
  self.__onSelectItem = BindCallback(self, self.__OnSelectItem)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_confirm, self, self.__OnClickConfitem)
end

UIWarChessStrategyReward.InitWCStrategyReward = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local strategyRewardCtrl = wcCtrl.strategyRewardCtrl
  local rewardList = strategyRewardCtrl:GetWCStrategySelectRewards()
  ;
  (self.strategyItemPool):HideAll()
  for index,srData in ipairs(rewardList) do
    local sItem = (self.strategyItemPool):GetOne()
    sItem:InitAsWCStrategySelectItem(srData, self.__onSelectItem)
  end
end

UIWarChessStrategyReward.__OnSelectItem = function(self, isRward, sItem)
  -- function num : 0_2
  self.__selectedItem = sItem
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ChoiceDes).text = sItem.des
end

UIWarChessStrategyReward.__OnClickConfitem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.__selectedItem == nil then
    return 
  end
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local strategyRewardCtrl = wcCtrl.strategyRewardCtrl
  if (self.__selectedItem).srData ~= nil then
    local srData = (self.__selectedItem).srData
    do
      local rewardType = (srData.srElem).rewardType
      if rewardType == 3 then
        local indexStrategyKey = srData.index
        do
          do
            local rewardMapKey = nil
            for key,_ in pairs((srData.srElem).rewards) do
              rewardMapKey = key
              do break end
            end
            do
              strategyRewardCtrl:WCStrategySelectReward(indexStrategyKey, rewardMapKey)
            end
            if rewardType == 4 then
              local indexStrategyKey = srData.index
              strategyRewardCtrl:WCStrategySelectReward(indexStrategyKey, nil, nil)
            else
              do
                ;
                (self.strategyItemPool):HideAll()
                do
                  do
                    if srData.chipDataList ~= nil then
                      local teamDataDic = (wcCtrl.teamCtrl):GetWCTeams()
                      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSelectChip, function(wcChipWindow)
    -- function num : 0_3_0 , upvalues : srData, teamDataDic, _ENV, strategyRewardCtrl
    wcChipWindow:InitWCSelectChip(srData.chipDataList, teamDataDic, function(index, teamData)
      -- function num : 0_3_0_0 , upvalues : srData, _ENV, strategyRewardCtrl
      local tid = teamData:GetWCTeamId()
      local selectedChipData = (srData.chipDataList)[index]
      local indexStrategyKey = srData.index
      local rewardMapKey = (ExplorationManager.ChipConvert2ServerId)(selectedChipData.dataId, selectedChipData:GetCount())
      strategyRewardCtrl:WCStrategySelectReward(indexStrategyKey, rewardMapKey, tid, function()
        -- function num : 0_3_0_0_0 , upvalues : _ENV
        UIManager:DeleteWindow(UIWindowTypeID.WarChessSelectChip)
      end
)
    end
)
  end
)
                    end
                    if srData.buffDataList ~= nil then
                      for _,buffData in ipairs(srData.buffDataList) do
                        local sItem = (self.strategyItemPool):GetOne()
                        sItem:InitAsWCStrategySubSelectItem(buffData, 2, self.__onSelectItem, srData.index)
                      end
                    end
                    do
                      return 
                    end
                    if (self.__selectedItem).srSubItemId ~= nil then
                      local indexStrategyKey = (self.__selectedItem).index
                      local rewardMapKey = (self.__selectedItem).srSubItemId
                      strategyRewardCtrl:WCStrategySelectReward(indexStrategyKey, rewardMapKey)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

UIWarChessStrategyReward.OnDelete = function(self)
  -- function num : 0_4
end

return UIWarChessStrategyReward

