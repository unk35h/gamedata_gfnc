-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharDunShopVer2Item = class("UINCharDunShopVer2Item", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINCharDunShopVer2Item.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickReward)
end

UINCharDunShopVer2Item.InitCharDunShopVer2Item = function(self, heroGrowData, lv, callback)
  -- function num : 0_1
  self._heroGrowData = heroGrowData
  self._lv = lv
  self._callback = callback
  self:__InitUI()
  self:RefreshCharDunShopVer2Item()
end

UINCharDunShopVer2Item.__InitUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local allBpCfg = (ConfigData.activity_hero_token_reward)[(self._heroGrowData):GetActId()]
  local bpCfg = allBpCfg[self._lv]
  self._point = bpCfg.need_token
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Lvl).text = tostring(self._lv)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenNum).text = tostring(self._point)
  local ids = bpCfg.level_reward_ids
  local nums = bpCfg.level_reward_nums
  ;
  (self._rewardPool):HideAll()
  for i,itemId in ipairs(ids) do
    local itemCfg = (ConfigData.item)[itemId]
    local itemCount = nums[i]
    local item = (self._rewardPool):GetOne()
    item:InitItemWithCount(itemCfg, itemCount, nil, false)
  end
  if #ids < 2 then
    ((self.ui).img_Empty):SetActive(true)
    ;
    (((self.ui).img_Empty).transform):SetAsLastSibling()
  else
    ;
    ((self.ui).img_Empty):SetActive(false)
  end
end

UINCharDunShopVer2Item.RefreshCharDunShopVer2Item = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local isUnlock = self._point <= PlayerDataCenter:GetItemCount((self._heroGrowData):GetHeroGrowCostId())
  if isUnlock then
    local isCanReceive = not (self._heroGrowData):IsHeroGrowLvReceived(self._lv)
  end
  if isUnlock then
    local isGet = not isCanReceive
  end
  ;
  ((self.ui).img_Icon):SetIndex(isUnlock and 1 or 0)
  ;
  ((self.ui).img_Bottom):SetIndex(isCanReceive and 1 or 0)
  ;
  ((self.ui).img_Get):SetActive(isGet)
  for i,v in ipairs((self._rewardPool).listItem) do
    v:SetPickedUIActive(isGet)
  end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UINCharDunShopVer2Item.GetCharDunShopVer2Lv = function(self)
  -- function num : 0_4
  return self._lv
end

UINCharDunShopVer2Item.GetCharDunShopVer2ItemCenterPoint = function(self, vec)
  -- function num : 0_5
  local pos = (((self.ui).img_Icon).transform).localPosition
  vec.x = pos.x
  vec.y = pos.y
end

UINCharDunShopVer2Item.OnClickReward = function(self)
  -- function num : 0_6
  if self._callback then
    (self._callback)(self._lv, self)
  end
end

UINCharDunShopVer2Item.SetChildHeroVer2HorizePointLine = function(self, lineItem, startOffset)
  -- function num : 0_7 , upvalues : _ENV
  local vec = (Vector2.Temp)(0, 0)
  self:GetCharDunShopVer2ItemCenterPoint(vec)
  vec.x = vec.x + startOffset
  ;
  (lineItem.transform):SetParent(self.transform)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (lineItem.transform).anchoredPosition = vec
  ;
  (lineItem.transform):SetAsFirstSibling()
end

UINCharDunShopVer2Item.SetChildHeroVer2NewLinePointLine = function(self, lineItems, startOffset)
  -- function num : 0_8 , upvalues : _ENV
  local tempVec = (Vector2.Temp)(0, 0)
  self:GetCharDunShopVer2ItemCenterPoint(tempVec)
  tempVec.x = tempVec.x + startOffset
  for i,lineItem in ipairs(lineItems) do
    (lineItem.transform):SetParent(self.transform)
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (lineItem.transform).anchoredPosition = tempVec
    if i == 1 then
      tempVec.x = tempVec.x + ((lineItem.transform).localScale).x * ((lineItem.transform).sizeDelta).x
    else
      if i == 2 then
        tempVec.y = tempVec.y - ((lineItem.transform).localScale).y * ((lineItem.transform).sizeDelta).y
      end
    end
    ;
    (lineItem.transform):SetAsFirstSibling()
  end
end

return UINCharDunShopVer2Item

