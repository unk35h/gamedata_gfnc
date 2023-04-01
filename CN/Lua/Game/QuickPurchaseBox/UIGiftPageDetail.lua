-- params : ...
-- function num : 0 , upvalues : _ENV
local UIGiftPageDetail = class("UIGiftPageDetail", UIBaseWindow)
local base = UIBaseWindow
local UINGiftPageDetail = require("Game.QuickPurchaseBox.UINGiftPageDetail")
local UINGiftPageDetailListNode = require("Game.QuickPurchaseBox.UINGiftPageDetailListNode")
UIGiftPageDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINGiftPageDetail
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickGiftPageClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.OnClickGiftPageClose)
  ;
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  self.giftPagePool = (UIItemPool.New)(UINGiftPageDetail, (self.ui).giftPageDetailItem)
  ;
  ((self.ui).giftPageDetailItem):SetActive(false)
end

UIGiftPageDetail.InitGiftPageDetail = function(self, payGiftInfo)
  -- function num : 0_1 , upvalues : _ENV
  local flag, giftCfg, allDay = payGiftInfo:TryGetGiftSubscriptionCfg()
  local isRandom, rGiftCfg = payGiftInfo:TryGetGiftRaffleCfg()
  if not flag and not isRandom then
    error("这个礼包不存在订阅项 id is " .. tostring((payGiftInfo.groupCfg).id) .. ".并且这个礼包不是随机礼包")
    return 
  end
  ;
  ((self.ui).obj_giftList):SetActive(false)
  ;
  ((self.ui).obj_dayRewardList):SetActive(false)
  if flag then
    if payGiftInfo:IsCheckNextGift() then
      self:InitGiftPageDetailBaseOfCheckNext(payGiftInfo)
    else
      if payGiftInfo:IsOrderOfManyTypeGift() then
        self:InitGiftPageDetailBaseOfOrderOfManyType(payGiftInfo, giftCfg, allDay)
      else
        self:InitGiftPageDetailBaseOfOrderOfType(giftCfg, allDay)
      end
    end
    ;
    ((self.ui).tex_Title):SetIndex(0)
  else
    self:InitGiftPageDetailBaseOfCheckNext(payGiftInfo)
    ;
    ((self.ui).tex_Title):SetIndex(1)
  end
end

UIGiftPageDetail.InitGiftPageDetailBaseOfOrderOfType = function(self, giftCfg, allDay)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_dayRewardList):SetActive(true)
  local timepassCtr = ControllerManager:GetController(ControllerTypeId.TimePass, true)
  local counterEl = timepassCtr:getCounterElemData(proto_object_CounterModule.CounterModuleGiftReset, giftCfg.id)
  local receivedDay = 0
  local isRuning = false
  if counterEl ~= nil and PlayerDataCenter.timestamp < counterEl.nextExpiredTm then
    isRuning = true
    receivedDay = allDay - (math.floor)((counterEl.nextExpiredTm - PlayerDataCenter.timestamp) / 86400)
  end
  ;
  ((self.ui).tex_Tips):SetIndex(0, tostring(allDay))
  ;
  ((self.ui).progress):SetActive(isRuning)
  ;
  ((self.ui).tex_progress):SetIndex(0, tostring(receivedDay), tostring(allDay))
  ;
  (self.giftPagePool):HideAll()
  local itemList = {}
  for i,itemId in ipairs(giftCfg.awardIds) do
    local itemCfg = (ConfigData.item)[itemId]
    ;
    (table.insert)(itemList, {itemCfg = itemCfg, count = (giftCfg.awardCounts)[i]})
  end
  for i = 1, allDay do
    local item = (self.giftPagePool):GetOne(true)
    item:InitGiftPageItem(i, itemList, i <= receivedDay, isRuning)
  end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIGiftPageDetail.InitGiftPageDetailBaseOfOrderOfManyType = function(self, payGiftInfo, giftCfg, allDay)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).obj_dayRewardList):SetActive(true)
  local timepassCtr = ControllerManager:GetController(ControllerTypeId.TimePass, true)
  local counterEl = timepassCtr:getCounterElemData(proto_object_CounterModule.CounterModuleGiftReset, giftCfg.id)
  local receivedDay = 0
  local isRuning = false
  if counterEl ~= nil and PlayerDataCenter.timestamp < counterEl.nextExpiredTm then
    isRuning = true
    receivedDay = allDay - (math.floor)((counterEl.nextExpiredTm - PlayerDataCenter.timestamp) / 86400)
  end
  ;
  ((self.ui).tex_Tips):SetIndex(1, tostring(allDay))
  ;
  ((self.ui).progress):SetActive(isRuning)
  ;
  ((self.ui).tex_progress):SetIndex(0, tostring(receivedDay), tostring(allDay))
  ;
  (self.giftPagePool):HideAll()
  local dailyGroup = (ConfigData.gift_daily)[(payGiftInfo.groupCfg).id]
  if dailyGroup == nil then
    return 
  end
  for k1,v1 in pairs(dailyGroup) do
    local itemList = {}
    for k2,itemId in pairs(v1.awardIds) do
      local itemCfg = (ConfigData.item)[itemId]
      ;
      (table.insert)(itemList, {itemCfg = itemCfg, count = (v1.awardCounts)[k2]})
    end
    local item = (self.giftPagePool):GetOne(true)
    item:InitGiftPageItem(k1, itemList, k1 <= receivedDay, isRuning)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIGiftPageDetail.InitGiftPageDetailBaseOfCheckNext = function(self, payGiftInfo)
  -- function num : 0_4 , upvalues : UINGiftPageDetailListNode
  ((self.ui).obj_giftList):SetActive(true)
  self.detailListNode = (UINGiftPageDetailListNode.New)()
  ;
  (self.detailListNode):Init(((self.ui).obj_giftList).transform)
  ;
  (self.detailListNode):InitGiftPageDetailListNode(payGiftInfo)
end

UIGiftPageDetail.BackAction = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self:Delete()
  ;
  (UIUtil.ReShowTopStatus)()
end

UIGiftPageDetail.OnDelete = function(self)
  -- function num : 0_6
  if self.detailListNode then
    (self.detailListNode):Delete()
  end
end

UIGiftPageDetail.OnClickGiftPageClose = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

return UIGiftPageDetail

