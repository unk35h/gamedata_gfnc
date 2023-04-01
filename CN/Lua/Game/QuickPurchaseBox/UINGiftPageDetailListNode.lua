-- params : ...
-- function num : 0 , upvalues : _ENV
local UINGiftPageDetailListNode = class("UINGiftPageDetailListNode", UIBaseNode)
local base = UIBaseNode
local cs_ResLoader = CS.ResLoader
local UINGiftPageDetailListNodeGroup = require("Game.QuickPurchaseBox.UINGiftPageDetailListNodeGroup")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINGiftPageDetailListNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINGiftPageDetailListNodeGroup, UINBaseItemWithCount, cs_ResLoader
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.giftPageGroupPool = (UIItemPool.New)(UINGiftPageDetailListNodeGroup, (self.ui).obj_groupItem, false)
  self.mustGetItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).obj_mustGetItem, false)
  self.resloader = (cs_ResLoader.Create)()
end

UINGiftPageDetailListNode.InitGiftPageDetailListNode = function(self, payGiftInfo)
  -- function num : 0_1 , upvalues : _ENV
  self.payGiftInfo = payGiftInfo
  local flag, giftCfg, allDay = payGiftInfo:TryGetGiftSubscriptionCfg()
  local isRandom, rGiftCfg = payGiftInfo:TryGetGiftRaffleCfg()
  if not flag and not isRandom then
    error("这个礼包不存在订阅项 id is " .. tostring((payGiftInfo.groupCfg).id) .. ".并且这个礼包不是随机礼包")
    return 
  end
  if flag then
    self:RefreshNextGiftInfo(giftCfg, allDay)
  else
    self:RefreshRaffleGiftInfo(rGiftCfg)
  end
end

UINGiftPageDetailListNode.RefreshNextGiftInfo = function(self, giftCfg, allDay)
  -- function num : 0_2 , upvalues : _ENV
  local otherPayGiftInfo = ((ControllerManager:GetController(ControllerTypeId.PayGift)).dataDic)[giftCfg.particulars]
  if (self.payGiftInfo):IsCheckNextGift() then
    ((self.ui).tex_Tips):SetIndex(1, (LanguageUtil.GetLocaleText)(((self.payGiftInfo).groupCfg).name), (LanguageUtil.GetLocaleText)((otherPayGiftInfo.groupCfg).name))
  else
    ;
    ((self.ui).tex_Tips):SetIndex(0, tostring(allDay))
  end
  local textureName = (otherPayGiftInfo.groupCfg).icon
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(texture) then
      ((self.ui).img_giftIcon).texture = texture
    end
  end
)
  ;
  ((self.ui).tex_Des):SetIndex(0)
  ;
  ((self.ui).obj_raffleGiftList):SetActive(false)
  ;
  (self.giftPageGroupPool):HideAll()
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_giftName).text = (LanguageUtil.GetLocaleText)((otherPayGiftInfo.groupCfg).name)
  local awardIds = ((otherPayGiftInfo.giftCfgList)[1]).awardIds
  local awardCounts = ((otherPayGiftInfo.giftCfgList)[1]).awardCounts
  for i,itemId in ipairs(awardIds) do
    local itemCfg = (ConfigData.item)[itemId]
    local item = (self.giftPageGroupPool):GetOne(true)
    item:InitGiftPageDetailListNodeGroup(itemCfg, awardCounts[i])
  end
end

UINGiftPageDetailListNode.RefreshRaffleGiftInfo = function(self, giftCfg)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tex_Tips):SetIndex(2)
  local textureName = ((self.payGiftInfo).groupCfg).icon
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetShopGiftBgPath(textureName), function(texture)
    -- function num : 0_3_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(texture) then
      ((self.ui).img_giftIcon).texture = texture
    end
  end
)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_giftName).text = (LanguageUtil.GetLocaleText)(((self.payGiftInfo).groupCfg).name)
  ;
  ((self.ui).obj_raffleGiftList):SetActive(true)
  ;
  ((self.ui).tex_mustGetTip):SetIndex(0)
  ;
  (self.mustGetItemPool):HideAll()
  ;
  (self.giftPageGroupPool):HideAll()
  local awardIds = (((self.payGiftInfo).giftCfgList)[1]).awardIds
  local awardCounts = (((self.payGiftInfo).giftCfgList)[1]).awardCounts
  for i,itemId in ipairs(awardIds) do
    local itemCfg = (ConfigData.item)[itemId]
    local item = (self.mustGetItemPool):GetOne(true)
    item:InitItemWithCount(itemCfg, awardCounts[i])
    if itemCfg.type == eItemType.RaffleBox then
      self.raffleItem = itemCfg
    end
  end
  if self.raffleItem then
    ((self.ui).tex_Des):SetIndex(1, (LanguageUtil.GetLocaleText)((self.raffleItem).name))
    local raffleItemList = ((ConfigData.item).raffleBoxDic)[(self.raffleItem).id]
    for _,raffleCfg in pairs(raffleItemList) do
      local item = (self.giftPageGroupPool):GetOne(true)
      item:InitGiftPageDetailListNodeGroup((ConfigData.item)[raffleCfg.rewardId], raffleCfg.rewardCount)
      item:SetRaffleItemWeight(raffleCfg.weight)
    end
  end
end

UINGiftPageDetailListNode.OnDelete = function(self)
  -- function num : 0_4
  (self.mustGetItemPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return UINGiftPageDetailListNode

