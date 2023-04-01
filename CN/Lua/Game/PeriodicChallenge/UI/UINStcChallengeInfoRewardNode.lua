-- params : ...
-- function num : 0 , upvalues : _ENV
local UINStcChallengeInfoRewardNode = class("UINStcChallengeInfoRewardNode", UIBaseNode)
local base = UIBaseNode
local TaskEnum = require("Game.Task.TaskEnum")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINStcChallengeInfoRewardNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.itemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self.__refreshChallengeReward = BindCallback(self, self.RefreshChallengeReward)
  MsgCenter:AddListener(eMsgEventId.TaskSyncFinish, self.__refreshChallengeReward)
end

UINStcChallengeInfoRewardNode.RefreshChallengeReward = function(self)
  -- function num : 0_1 , upvalues : _ENV, TaskEnum
  local taskCtrl = ControllerManager:GetController(ControllerTypeId.Task)
  local peroidDatas = taskCtrl:GetDatas4Peroid((TaskEnum.eTaskPeriodType).WeeklyChallengeTask)
  local pointId = ((peroidDatas[1]).stcData).activeId
  local currActiveNum = PlayerDataCenter:GetItemCount(pointId)
  local totalActiveNum = 0
  local selectPeroidData = nil
  local isLimit = false
  local currentStage = nil
  for i,data in ipairs(peroidDatas) do
    currentStage = i
    totalActiveNum = (data.stcData).activeNum
    if currActiveNum < totalActiveNum then
      selectPeroidData = data
      break
    else
      if i == #peroidDatas then
        currentStage = i
        selectPeroidData = data
        isLimit = true
      end
    end
  end
  do
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tex_RewardStage).text = tostring(currentStage) .. "\\" .. tostring(#peroidDatas)
    ;
    ((self.ui).tex_RewardPoint):SetIndex(0, tostring((selectPeroidData.stcData).activeNum))
    ;
    ((self.ui).obj_RewardReceivedAll):SetActive(isLimit)
    ;
    (self.itemPool):HideAll()
    ;
    ((self.ui).emptyReward):SetActive(false)
    if isLimit then
      return 
    end
    for i,itemId in ipairs((selectPeroidData.stcData).rewardIds) do
      local itemCount = ((selectPeroidData.stcData).rewardNums)[i]
      local itemCfg = (ConfigData.item)[itemId]
      local item = (self.itemPool):GetOne()
      item:InitItemWithCount(itemCfg, itemCount)
      ;
      (item.baseItem):TrySetGreatRewardLoopFxScale((Vector3.New)(1, 1.4, 1))
    end
    if #(selectPeroidData.stcData).rewardIds <= 1 then
      ((self.ui).emptyReward):SetActive(true)
    end
  end
end

UINStcChallengeInfoRewardNode.OnDelete = function(self)
  -- function num : 0_2 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.TaskSyncFinish, self.__refreshChallengeReward)
  ;
  (base.OnDelete)(self)
end

return UINStcChallengeInfoRewardNode

