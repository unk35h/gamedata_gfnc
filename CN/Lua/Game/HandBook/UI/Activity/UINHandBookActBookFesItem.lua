-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookActBookFesItem = class("UINHandBookActBookFesItem", UIBaseNode)
local base = UIBaseNode
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local HandBookActReviewFunc = require("Game.HandBook.UI.Activity.HandBookActReviewFunc")
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local HandBookActReviewOpenFunc = require("Game.HandBook.UI.Activity.HandBookActReviewOpenFunc")
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINHandBookActBookFesItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickEnterActFes)
  ;
  (UIUtil.AddButtonListener)((self.ui).rewardBg, self, self.OnClickRewardActFes)
end

UINHandBookActBookFesItem.InitActBookFesItem = function(self, enterType, actFramId, honorWallFunc, resloader)
  -- function num : 0_1 , upvalues : _ENV, HandBookActReviewOpenFunc, HandBookActReviewFunc
  self._actFrameId = actFramId
  self._honorWallFunc = honorWallFunc
  self._cfg = (((ConfigData.handbook_activity)[enterType]).content)[actFramId]
  local activityCfg = (ConfigData.activity)[actFramId]
  do
    if activityCfg ~= nil then
      local activityNameCfg = (ConfigData.activity_name)[activityCfg.name_id]
      -- DECOMPILER ERROR at PC23: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).tex_ActName).text = (LanguageUtil.GetLocaleText)(activityNameCfg.name)
    end
    ;
    (((self.ui).img_ActBg).gameObject):SetActive(false)
    if #(self._cfg).object_pic == 0 then
      error("res is NIL")
    else
      resloader:LoadABAssetAsync(PathConsts:GetHandbookItemPic((self._cfg).object_pic), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) or IsNull(self.transform) or texture.name ~= (self._cfg).object_pic then
      return 
    end
    ;
    (((self.ui).img_ActBg).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_ActBg).texture = texture
  end
)
    end
    self._totalRewardCount = #(self._cfg).reward_list
    ;
    (((self.ui).rewardBg).gameObject):SetActive(self._totalRewardCount > 0)
    local activityCfg = (ConfigData.activity)[actFramId]
    local processFunc = (HandBookActReviewOpenFunc.ReviewProcessFunc)[activityCfg.type]
    if processFunc ~= nil then
      processFunc(activityCfg.activity_id, function(unlockCount, totalCount)
    -- function num : 0_1_1 , upvalues : _ENV, self, activityCfg
    if IsNull(self.transform) or (self._cfg).id ~= activityCfg.id then
      return 
    end
    ;
    ((self.ui).tex_avg_Progress):SetIndex(0, tostring(unlockCount), tostring(totalCount))
  end
)
    else
      self._CPRData = (HandBookActReviewFunc[activityCfg.type])(activityCfg.activity_id)
      if (self._cfg).repeat_remaster_act_id and #(self._cfg).repeat_remaster_act_id > 0 then
        for i,v in pairs((self._cfg).repeat_remaster_act_id) do
          local remasterActivityCfg = (ConfigData.activity)[v]
          local remasterCPRData = (HandBookActReviewFunc[activityCfg.type])(remasterActivityCfg.activity_id)
          if (self._CPRData).totalUnlockedNum4Show < remasterCPRData.totalUnlockedNum4Show then
            self._CPRData = remasterCPRData
          end
        end
      end
      local totalCount, unlockCount = (self._CPRData):GetCPRAvgGroupUnlockNum()
      ;
      ((self.ui).tex_avg_Progress):SetIndex(0, tostring(unlockCount), tostring(totalCount))
    end
    self:__Refresh()
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINHandBookActBookFesItem.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._totalRewardCount > 0 then
    local hasRewardCount = 0
    for i,rewardId in ipairs((self._cfg).reward_list) do
      local itemCfg = (ConfigData.item)[rewardId]
      if itemCfg.type == eItemType.DormFurniture and (PlayerDataCenter.dormBriefData):ExistDormFntItem(rewardId) then
        hasRewardCount = hasRewardCount + 1
      end
      -- DECOMPILER ERROR at PC38: Unhandled construct in 'MakeBoolean' P1

      if itemCfg.type == eItemType.HeroCard and (PlayerDataCenter.heroDic)[(itemCfg.arg)[1]] ~= nil then
        hasRewardCount = hasRewardCount + 1
      end
      if itemCfg.type == eItemType.Skin and (PlayerDataCenter.skinData):IsHaveSkin((itemCfg.arg)[1]) then
        hasRewardCount = hasRewardCount + 1
      end
      if PlayerDataCenter:GetItemCount(rewardId) > 0 then
        hasRewardCount = hasRewardCount + 1
      end
    end
    -- DECOMPILER ERROR at PC74: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_reward_Progress).text = tostring(hasRewardCount) .. "/" .. tostring(self._totalRewardCount)
  end
end

UINHandBookActBookFesItem.PlayBookFesAni = function(self, delayTime)
  -- function num : 0_3 , upvalues : CS_DOTween
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 0
  self._tween = (CS_DOTween.Sequence)()
  ;
  (self._tween):AppendInterval(delayTime)
  ;
  (self._tween):AppendCallback(function()
    -- function num : 0_3_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).canvasGroup).alpha = 1
    ;
    ((self.ui).ani_item):Play()
  end
)
end

UINHandBookActBookFesItem.OnClickEnterActFes = function(self)
  -- function num : 0_4 , upvalues : _ENV, HandBookActReviewOpenFunc
  local activityCfg = (ConfigData.activity)[(self._cfg).id]
  if (HandBookActReviewOpenFunc.ReviewOpenFunc)[activityCfg.type] ~= nil then
    ((HandBookActReviewOpenFunc.ReviewOpenFunc)[activityCfg.type])(activityCfg.activity_id)
  else
    UIManager:HideWindow(UIWindowTypeID.HandBookActBookFes)
    HandBookActReviewOpenFunc:OpenHandbookActReview(self._CPRData, function()
    -- function num : 0_4_0 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.HandBookActBookFes)
  end
)
  end
end

UINHandBookActBookFesItem.OnClickRewardActFes = function(self)
  -- function num : 0_5
  if self._honorWallFunc ~= nil then
    (self._honorWallFunc)(self._actFrameId, (((self.ui).rewardBg).transform).position)
  end
end

UINHandBookActBookFesItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINHandBookActBookFesItem

