-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventNoviceSignII = class("UIEventNoviceSignII", UIBaseWindow)
local base = UIBaseWindow
local UINEventNoviceSignItemII = require("Game.EventNoviceSign.UI.UINEventNoviceSignItemII")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
UIEventNoviceSignII.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventNoviceSignItemII, UINBaseItemWithCount
  (UIUtil.AddButtonListener)((self.ui).btn_close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_backGround, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AwardDetail, self, self.OnClickPreLook)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sign, self, self.OnClickSign)
  self._dayItemPool = (UIItemPool.New)(UINEventNoviceSignItemII, (self.ui).obj_dayItem)
  ;
  ((self.ui).obj_dayItem):SetActive(false)
  self._awardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
  self._defaultSignClolor = ((self.ui).img_Sign).color
end

UIEventNoviceSignII.InitNoviceSign = function(self, id, isShowCloseBtn)
  -- function num : 0_1 , upvalues : _ENV
  ;
  (((self.ui).btn_close).gameObject):SetActive(isShowCloseBtn or false)
  ;
  (((self.ui).btn_backGround).gameObject):SetActive(isShowCloseBtn or false)
  self.data = ((PlayerDataCenter.eventNoviceSignData).dataDic)[id]
  ;
  (self.data):SetPoped()
  local list = {}
  for k,v in pairs((self.data).awardCfg) do
    (table.insert)(list, v)
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_1_0
    do return a.day < b.day end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local totalDays = #list
  local mainRewardDic = {}
  ;
  (self._dayItemPool):HideAll()
  for i = 1, totalDays - 1 do
    local item = (self._dayItemPool):GetOne()
    local awardCfg = list[i]
    local itemId, itemCount = self:__GetOneAndRecordAllItem(awardCfg, awardCfg.extra_sign_award, mainRewardDic, true)
    item:InitNoviceSignItemII(i, itemId, itemCount)
  end
  local finalAwardCfg = list[totalDays]
  self:__GetOneAndRecordAllItem(finalAwardCfg, nil, mainRewardDic, nil)
  ;
  (self._awardItemPool):HideAll()
  for i,itemId in ipairs(finalAwardCfg.awardIds) do
    if itemId ~= finalAwardCfg.extra_sign_award then
      local item = (self._awardItemPool):GetOne()
      local itemCfg = (ConfigData.item)[itemId]
      local itemCount = (finalAwardCfg.awardCounts)[i]
      item:InitItemWithCount(itemCfg, itemCount)
    end
  end
  ;
  ((self.ui).itemList):SetActive(false)
  ;
  ((self.ui).img_AwardDetail):SetIndex(0)
  local mainRewardIdList = {}
  for itemId,itemCount in pairs(mainRewardDic) do
    (table.insert)(mainRewardIdList, itemId)
  end
  ;
  (table.sort)(mainRewardIdList, function(a, b)
    -- function num : 0_1_1 , upvalues : _ENV
    local aItemCfg = (ConfigData.item)[a]
    local bItemCfg = (ConfigData.item)[b]
    local aIsHero = aItemCfg.type == eItemType.HeroCard
    local bIsHero = bItemCfg.type == eItemType.HeroCard
    if aIsHero ~= bIsHero then
      return aIsHero
    end
    do return a < b end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
  local mainRewardStr = ""
  local mainRewardIdListCount = #mainRewardIdList
  for i,itemId in ipairs(mainRewardIdList) do
    local itemCount = mainRewardDic[itemId]
    if itemCount > 1 then
      mainRewardStr = mainRewardStr .. ConfigData:GetItemName(itemId) .. "x" .. tostring(itemCount)
    else
      mainRewardStr = mainRewardStr .. ConfigData:GetItemName(itemId)
    end
    if i < mainRewardIdListCount then
      mainRewardStr = mainRewardStr .. "、"
    end
  end
  ;
  ((self.ui).texNoviceSign):SetIndex(0, mainRewardStr)
  self:RefreshNoviceSign()
end

UIEventNoviceSignII.RefreshNoviceSign = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local hasSignTimes = (self.data):GetEventSignTimes()
  local allowSign = (self.data):IsAllowReceive()
  local curSignDay = allowSign and hasSignTimes + 1 or hasSignTimes
  for day,dayItem in ipairs((self._dayItemPool).listItem) do
    dayItem:SetNoviceSignItemIIReviced(day <= hasSignTimes)
  end
  local awardCfg = ((self.data).awardCfg)[curSignDay]
  local extraItemId, extraItemCount = self:__GetOneAndRecordAllItem(awardCfg, awardCfg.extra_sign_award, nil, false)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).itemIcon).sprite = CRH:GetSpriteByItemId(extraItemId)
  ;
  ((self.ui).tex_ItemWithCount):SetIndex(0, ConfigData:GetItemName(extraItemId), tostring(extraItemCount))
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R7 in 'UnsetPending'

  if not allowSign or not self._defaultSignClolor then
    ((self.ui).img_Sign).color = (self.ui).color_signed
    ;
    ((self.ui).obj_Received):SetActive(not allowSign)
    ;
    ((self.ui).tex_sign):SetIndex(allowSign and 0 or 1)
    ;
    ((self.ui).effect_sign):SetActive(allowSign)
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

UIEventNoviceSignII.SetCloseCallback = function(self, callback)
  -- function num : 0_3
  self.closeCallback = callback
end

UIEventNoviceSignII.__GetOneAndRecordAllItem = function(self, awardCfg, itemId, recordDic, invertSelection)
  -- function num : 0_4 , upvalues : _ENV
  local selectId, selectCount = nil, nil
  for i,awardItemId in ipairs(awardCfg.awardIds) do
    if (invertSelection and awardItemId ~= itemId) or not invertSelection and awardItemId == itemId then
      selectId = awardItemId
      selectCount = (awardCfg.awardCounts)[i]
    end
    if recordDic ~= nil and (awardCfg.main_sign_award)[awardItemId] ~= nil then
      if not recordDic[awardItemId] then
        local count = recordDic == nil or 0
      end
      count = count + (awardCfg.awardCounts)[i]
      recordDic[awardItemId] = count
    end
  end
  do
    return selectId, selectCount
  end
end

UIEventNoviceSignII.OnClickPreLook = function(self)
  -- function num : 0_5
  local showPre = not ((self.ui).itemList).activeSelf
  ;
  ((self.ui).itemList):SetActive(showPre)
  ;
  ((self.ui).img_AwardDetail):SetIndex(showPre and 1 or 0)
end

UIEventNoviceSignII.OnClickSign = function(self)
  -- function num : 0_6 , upvalues : _ENV, CommonRewardData
  if not (self.data):IsAllowReceive() then
    return 
  end
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.EventNoviceSign)):CS_SIGNACTIVITY_Pick((self.data).id, function(objList)
    -- function num : 0_6_0 , upvalues : self, _ENV, CommonRewardData
    self:RefreshNoviceSign()
    if objList.Count == 0 then
      error("objList.Count == 0")
      return 
    end
    local rewardDic = objList[0]
    local rewardIdList = {}
    local rewardNumList = {}
    for k,v in pairs(rewardDic) do
      (table.insert)(rewardIdList, k)
      ;
      (table.insert)(rewardNumList, v)
    end
    self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_6_0_0 , upvalues : CommonRewardData, rewardIdList, rewardNumList, self
      if window ~= nil then
        local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIdList, rewardNumList)):SetCRHeroSnapshoot(self._heroIdSnapShoot)
        window:AddAndTryShowReward(CRData)
      end
    end
)
  end
)
end

UIEventNoviceSignII.OnClickClose = function(self)
  -- function num : 0_7
  self:Delete()
end

UIEventNoviceSignII.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  if self.data ~= nil then
    (self.data):SetPoped()
  end
  ;
  (self._awardItemPool):DeleteAll()
  ;
  (self._dayItemPool):DeleteAll()
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  ;
  (base.OnDelete)(self)
end

return UIEventNoviceSignII

