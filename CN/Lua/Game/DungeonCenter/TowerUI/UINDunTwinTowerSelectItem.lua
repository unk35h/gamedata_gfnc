-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunTwinTowerSelectItem = class("UINDunTwinTowerSelectItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINDunTwinTowerSelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_State, self, self.OnTwinTowerItemClick)
  self.rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItem)
  ;
  ((self.ui).uINBaseItem):SetActive(false)
end

UINDunTwinTowerSelectItem.InitTwinTowerSelectItem = function(self, towerTypeData, selectId, myRank, clickEvent)
  -- function num : 0_1 , upvalues : _ENV
  self.__towerTypeData = towerTypeData
  self.__clickEvent = clickEvent
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_TowerName).text = (self.__towerTypeData):GetDungeonTowerName()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Details).text = (self.__towerTypeData):GetDungeonTowerDesc()
  local totalLevel = (self.__towerTypeData):GetTowerTotalLevel()
  local towerId = (self.__towerTypeData):GetDungeonTowerTypeId()
  local completeLevel = (PlayerDataCenter.dungeonTowerSData):GetTowerCompleteLevel((self.__towerTypeData):GetDungeonTowerTypeId())
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(completeLevel), tostring(totalLevel))
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).sl_Progress).value = completeLevel / totalLevel
  if selectId ~= towerId then
    do
      local isSelected = selectId <= 0
      ;
      ((self.ui).obj_challenge):SetActive(isSelected)
      ;
      (((self.ui).btn_State).gameObject):SetActive(not isSelected)
      ;
      ((self.ui).tex_State):SetIndex(0)
      ;
      (((self.ui).btn_State).gameObject):SetActive(true)
      ;
      ((self.ui).tex_State):SetIndex(1)
      local allComplete = totalLevel <= completeLevel
      ;
      ((self.ui).obj_received):SetActive(allComplete)
      ;
      ((self.ui).obj_reward):SetActive(not allComplete)
      if not allComplete then
        (self.rewardPool):HideAll()
        local reward_ids, reward_nums = (self.__towerTypeData):GetTowerRewardInfo()
        for index,itemId in pairs(reward_ids) do
          local itemCount = reward_nums[index]
          local itmeCfg = (ConfigData.item)[itemId]
          local item = (self.rewardPool):GetOne()
          item:InitItemWithCount(itmeCfg, nil)
        end
      end
      self:_InitRankSelfInfo(myRank)
      -- DECOMPILER ERROR: 6 unprocessed JMP targets
    end
  end
end

UINDunTwinTowerSelectItem._InitRankSelfInfo = function(self, myRank)
  -- function num : 0_2 , upvalues : _ENV
  local isComplete, totalFrame = (PlayerDataCenter.dungeonTowerSData):GetTowerTotalRacingFrame((self.__towerTypeData):GetDungeonTowerTypeId())
  ;
  ((self.ui).obj_time):SetActive(isComplete)
  if isComplete then
    ((self.ui).tex_TotalTime):SetIndex(0, (BattleUtil.FrameToTimeString)(totalFrame, true))
  end
  if BattleUtil.CheatFrame <= totalFrame then
    ((self.ui).obj_RankPer):SetActive(false)
    return 
  end
  local rankCfg = (ConfigData.common_ranklist)[(self.__towerTypeData):GetTowerRankId()]
  if myRank == nil or rankCfg == nil then
    ((self.ui).obj_RankPer):SetActive(false)
    return 
  end
  if myRank.inRank then
    ((self.ui).obj_RankPer):SetActive(true)
    ;
    ((self.ui).tex_RankPer):SetIndex(1, tostring(myRank.rankParam))
  else
    if myRank.rankParam <= rankCfg.percent_show then
      ((self.ui).obj_RankPer):SetActive(true)
      ;
      ((self.ui).tex_RankPer):SetIndex(0, GetPreciseDecimalStr(myRank.rankParam / 100, 1))
    else
      ;
      ((self.ui).obj_RankPer):SetActive(false)
    end
  end
end

UINDunTwinTowerSelectItem.__PlayThemeTween = function(self, time)
  -- function num : 0_3
  ((((self.ui).cg_ThemeAlpha):DOFade(0, 0.3)):From()):SetDelay(time * 0.15)
end

UINDunTwinTowerSelectItem.SetTwinTowerItemReddot = function(self, active)
  -- function num : 0_4
  ((self.ui).redDot_Twin):SetActive(active)
end

UINDunTwinTowerSelectItem.SetTwinTowerItemBluedot = function(self, active)
  -- function num : 0_5
  ((self.ui).blueDot_Twin):SetActive(active)
end

UINDunTwinTowerSelectItem.OnTwinTowerItemClick = function(self)
  -- function num : 0_6
  if self.__clickEvent ~= nil then
    (self.__clickEvent)(self.__towerTypeData)
  end
end

UINDunTwinTowerSelectItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  ((self.ui).cg_ThemeAlpha):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINDunTwinTowerSelectItem

