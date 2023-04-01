-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23StoryBaseItem = class("UINSpring23StoryBaseItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local Data_UIAvgDetail = require("Game.Sector.AvgDetail.Data_UIAvgDetail")
UINSpring23StoryBaseItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickAvgDetail)
  self._item = (UINBaseItemWithReceived.New)()
  ;
  (self._item):Init((self.ui).uINBaseItemWithReceived)
end

UINSpring23StoryBaseItem.InitSpring23StoryItem = function(self, springStoryData, interactCfg, resloader, detailCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._springStoryData = springStoryData
  self._interactCfg = interactCfg
  self._detailCallback = detailCallback
  self._interactInfoCfg = (ConfigData.activity_spring_interact_info)[interactCfg.story]
  self._resloader = resloader
  self:__InitUI()
  self:RefreshSpring23StoryState()
end

UINSpring23StoryBaseItem.InitSpring23StoryItemJustAvg = function(self, avgId, resloader, detailCallback)
  -- function num : 0_2 , upvalues : _ENV
  self._springStoryData = nil
  self._interactCfg = nil
  self._detailCallback = detailCallback
  self._interactInfoCfg = (ConfigData.activity_spring_interact_info)[avgId]
  self._resloader = resloader
  self:__InitUI()
  self:RefreshSpring23StoryState()
end

UINSpring23StoryBaseItem.InitSpring23StoryItemReview = function(self, interactCfg, resloader, detailCallback)
  -- function num : 0_3
  self._hideReward = true
  self._forceLooked = false
  self:InitSpring23StoryItem(nil, interactCfg, resloader, detailCallback)
end

UINSpring23StoryBaseItem.InitSpring23StoryItemJustAvgReview = function(self, avgId, resloader, detailCallback)
  -- function num : 0_4
  self._hideReward = true
  self._forceLooked = true
  self:InitSpring23StoryItemJustAvg(avgId, resloader, detailCallback)
end

UINSpring23StoryBaseItem.ResetSpring23StoryItemAniState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).ani_root):Stop()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).detail).anchoredPosition = Vector2.zero
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).alpha = 0
end

UINSpring23StoryBaseItem.SetSpring23StoryItemTween = function(self, delayTime, sequeceTween)
  -- function num : 0_6
  sequeceTween:InsertCallback(delayTime, function()
    -- function num : 0_6_0 , upvalues : self
    ((self.ui).ani_root):Play()
  end
)
  sequeceTween:Insert(delayTime, ((((self.ui).detail):DOLocalMoveY(-20, 0.5)):From()):SetAutoKill(false))
end

UINSpring23StoryBaseItem.__InitUI = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._interactCfg ~= nil and not self._hideReward then
    local itemId = ((self._interactCfg).important_reward_ids)[1]
    local itemCount = ((self._interactCfg).important_reward_nums)[1]
    if itemId ~= nil then
      ((self._item).gameObject):SetActive(true)
      local itemCfg = (ConfigData.item)[itemId]
      ;
      (self._item):InitItemWithCount(itemCfg, itemCount)
    else
      do
        do
          ;
          ((self._item).gameObject):SetActive(false)
          ;
          ((self._item).gameObject):SetActive(false)
          local avgCfg = (ConfigData.story_avg)[(self._interactInfoCfg).id]
          -- DECOMPILER ERROR at PC50: Confused about usage of register: R2 in 'UnsetPending'

          ;
          ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(avgCfg.name)
        end
      end
    end
  end
end

UINSpring23StoryBaseItem.RefreshSpring23StoryState = function(self)
  -- function num : 0_8 , upvalues : _ENV
  self._played = false
  if self._interactCfg ~= nil and self._springStoryData ~= nil then
    self._played = (self._springStoryData):GetThisTalkStateById((self._interactCfg).id)
  else
    if self._forceLooked then
      self._played = true
    else
      local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
      self._played = avgPlayCtrl:IsAvgPlayed((self._interactInfoCfg).id)
    end
  end
  do
    ;
    (self._item):SetPickedUIActive(self._played)
    ;
    ((self.ui).obj_Checked):SetActive(self._played)
    ;
    ((self.ui).obj_Check):SetActive(not self._played)
  end
end

UINSpring23StoryBaseItem.__SetExtraCondition = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self._interactCfg == nil then
    return 
  end
  local heroCfg = (ConfigData.hero_data)[(self._interactCfg).interact_character]
  local heroName = (LanguageUtil.GetLocaleText)(heroCfg.name)
  local itemNum = tostring((self._interactCfg).need_exp)
  local giftTip = ConfigData:GetTipContent(9107, heroName, itemNum)
  ;
  (self._avgDetailData):SetAvgDetailExtraCondition(self._played, giftTip)
end

UINSpring23StoryBaseItem.__CraetAvgDetailData = function(self)
  -- function num : 0_10 , upvalues : Data_UIAvgDetail, _ENV
  self._avgDetailData = (Data_UIAvgDetail.New)()
  ;
  (self._avgDetailData):SetAvgDetailAvgId((self._interactInfoCfg).id)
  ;
  (self._avgDetailData):SetAvgDetailBannerTexPath((self._interactInfoCfg).bg)
  ;
  (self._avgDetailData):SetAvgDetailExTitle((self._interactInfoCfg).index)
  ;
  (self._avgDetailData):SetAvgDetailExtraPlayedState(self._played)
  if self._hideReward then
    (self._avgDetailData):SetAvgDetailRewardShowState(false)
  end
  do
    if self._interactCfg ~= nil then
      local rewardDic = {}
      for i,itemid in ipairs((self._interactCfg).reward_ids) do
        rewardDic[itemid] = ((self._interactCfg).reward_nums)[i]
      end
      ;
      (self._avgDetailData):SetAvgDetailExtraReward(rewardDic)
    end
    self:__SetExtraCondition()
  end
end

UINSpring23StoryBaseItem.OnClickAvgDetail = function(self)
  -- function num : 0_11
  if self._avgDetailData == nil then
    self:__CraetAvgDetailData()
  end
  if self._detailCallback ~= nil then
    (self._detailCallback)(self._avgDetailData, self)
  end
end

return UINSpring23StoryBaseItem

