-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMiniGameTaskActiveItem = class("UINMiniGameTaskActiveItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINMiniGameTaskActiveItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self.OnClickReview)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount)
  ;
  ((self.ui).uINBaseItemWithCount):SetActive(false)
end

UINMiniGameTaskActiveItem.InitMiniGameTaskOnceItem = function(self, actTinyData, pointCfg, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._actTinyData = actTinyData
  self._pointCfg = pointCfg
  self._callback = callback
  ;
  ((self.ui).tex_CupLevel):SetIndex(0, tostring((self._pointCfg).level))
  ;
  ((self.ui).tex_Requirement):SetIndex(0, tostring((self._pointCfg).need_point))
  ;
  (self._rewardPool):HideAll()
  for i,itemId in ipairs((self._pointCfg).level_reward_ids) do
    local count = ((self._pointCfg).level_reward_nums)[i]
    local itemCfg = (ConfigData.item)[itemId]
    local item = (self._rewardPool):GetOne()
    item:InitItemWithCount(itemCfg, count)
  end
  self:RefreshMiniGameTaskOnceItem()
end

UINMiniGameTaskActiveItem.RefreshMiniGameTaskOnceItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local hasPicked = (self._actTinyData):IsTinyGameActiveHasReward((self._pointCfg).level)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if hasPicked then
    ((self.ui).img_Background).color = (self.ui).color_hasReview
    ;
    (((self.ui).btn_Receive).gameObject):SetActive(false)
    ;
    ((self.ui).finished):SetActive(true)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).cupItem).alpha = 0.7
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).icon).color = Color.white
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_CupLevel).text).color = Color.white
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_Requirement).text).color = Color.white
    return 
  end
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).cupItem).alpha = 1
  local isCanReceive = (self._actTinyData):IsTinyGameActiveCanReward((self._pointCfg).level)
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Background).color = (self.ui).color_normal
  ;
  (((self.ui).btn_Receive).gameObject):SetActive(isCanReceive)
  ;
  ((self.ui).finished):SetActive(false)
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R3 in 'UnsetPending'

  if isCanReceive then
    ((self.ui).img_Background).color = Color.white
    -- DECOMPILER ERROR at PC79: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).icon).color = (self.ui).color_black_text
    -- DECOMPILER ERROR at PC85: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_CupLevel).text).color = (self.ui).color_black_text
    -- DECOMPILER ERROR at PC91: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_Requirement).text).color = (self.ui).color_black_text
  else
    -- DECOMPILER ERROR at PC97: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Background).color = (self.ui).color_hasReview
    -- DECOMPILER ERROR at PC102: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).icon).color = Color.white
    -- DECOMPILER ERROR at PC108: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_CupLevel).text).color = Color.white
    -- DECOMPILER ERROR at PC114: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_Requirement).text).color = Color.white
  end
end

UINMiniGameTaskActiveItem.OnClickReview = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)((self._pointCfg).level)
  end
end

return UINMiniGameTaskActiveItem

