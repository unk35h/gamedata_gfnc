-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAct21SumExcgRewardList = class("UINAct21SumExcgRewardList", UIBaseNode)
local base = UIBaseNode
local UINAct21SumExcgRewardGroup = require("Game.ActivitySummer.UI.ActSum21Exchange.UINAct21SumExcgRewardGroup")
local UINAct21SumExcgRewardItem = require("Game.ActivitySummer.UI.ActSum21Exchange.UINAct21SumExcgRewardItem")
UINAct21SumExcgRewardList.ctor = function(self, excgRoot)
  -- function num : 0_0
  self.excgRoot = excgRoot
end

UINAct21SumExcgRewardList.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINAct21SumExcgRewardGroup, UINAct21SumExcgRewardItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self._OnClickInfo)
  ;
  ((self.ui).groupItems):SetActive(false)
  ;
  ((self.ui).exchangeItem):SetActive(false)
  self.rewardGroupPool = (UIItemPool.New)(UINAct21SumExcgRewardGroup, (self.ui).groupItems)
  self.rewardItemPool = (UIItemPool.New)(UINAct21SumExcgRewardItem, (self.ui).exchangeItem)
end

UINAct21SumExcgRewardList.InitAct21SumExcgRewardList = function(self, poolId, poolIdx, pickedRewardPoolIdDic, curPoolId)
  -- function num : 0_2 , upvalues : _ENV
  local poolParaCfg = (ConfigData.activity_time_limit_pool_para)[poolId]
  if poolParaCfg == nil then
    error("Cant get activity_time_limit_pool_para,id = " .. tostring(poolId))
    return 
  end
  local rewardLvDic = {}
  local maxQuality = 1
  for k,poolCfg in pairs(poolParaCfg.poolContent) do
    if not rewardLvDic[poolCfg.reward_type] then
      rewardLvDic[poolCfg.reward_type] = {}
      do
        local rewardList = rewardLvDic[poolCfg.reward_type]
        ;
        (table.insert)(rewardList, poolCfg)
        maxQuality = (math.max)(maxQuality, poolCfg.reward_type)
        -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  for k,rewardList in pairs(rewardLvDic) do
    (table.sort)(rewardList, (self.excgRoot).ActSum21ExchangeRewardSortFunc)
  end
  ;
  ((self.ui).tex_ShelfIdx):SetIndex(0, tostring(poolIdx))
  ;
  (self.rewardGroupPool):HideAll()
  ;
  (self.rewardItemPool):HideAll()
  for i = 1, maxQuality do
    local rewardList = rewardLvDic[i]
    if rewardList ~= nil then
      local groupItem = (self.rewardGroupPool):GetOne()
      ;
      (groupItem.transform):SetParent((self.ui).rectHolder)
      local totalNum = 0
      local usedNum = 0
      for k,poolCfg in ipairs(rewardList) do
        local itemCfg = (ConfigData.item)[poolCfg.rewardId]
        local itemNum = poolCfg.rewardNum
        local surplusNum = nil
        if poolId < curPoolId then
          surplusNum = 0
          usedNum = usedNum + poolCfg.num
        else
          if curPoolId == poolId then
            surplusNum = poolCfg.num - pickedRewardPoolIdDic[poolCfg.id]
            usedNum = usedNum + pickedRewardPoolIdDic[poolCfg.id]
          else
            surplusNum = poolCfg.num
          end
        end
        totalNum = totalNum + poolCfg.num
        local rewardItem = (self.rewardItemPool):GetOne()
        rewardItem:InitAct21SumExcgRewardItem(itemCfg, itemNum, surplusNum)
        ;
        (rewardItem.transform):SetParent(groupItem.transform)
        ;
        (rewardItem.transform):SetAsLastSibling()
      end
      groupItem:InitAct21SumExcgRewardGroup(i, usedNum, totalNum)
    end
  end
end

UINAct21SumExcgRewardList._OnClickInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_3_0 , upvalues : _ENV
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(7006), ConfigData:GetTipContent(326))
  end
)
end

UINAct21SumExcgRewardList.ShowRefreshUITween = function(self)
  -- function num : 0_4
  ((self.ui).fade):DOKill()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = 0
  ;
  ((self.ui).fade):DOFade(1, 1)
end

UINAct21SumExcgRewardList.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.rewardGroupPool):DeleteAll()
  ;
  (self.rewardItemPool):DeleteAll()
  ;
  ((self.ui).fade):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINAct21SumExcgRewardList

