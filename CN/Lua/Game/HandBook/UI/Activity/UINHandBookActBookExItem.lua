-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHandBookActBookExItem = class("UINHandBookActBookExItem", UIBaseNode)
local base = UIBaseNode
local SectorLevelDetailEnum = require("Game.Sector.Enum.SectorLevelDetailEnum")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local HandBookActReviewFunc = require("Game.HandBook.UI.Activity.HandBookActReviewFunc")
local CS_DOTween = ((CS.DG).Tweening).DOTween
UINHandBookActBookExItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickEnterActEx)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RewardBg, self, self.OnClickRewardActEx)
end

UINHandBookActBookExItem.InitActBookExItem = function(self, enterType, actFramId, enterFunc, honorWallFunc, resloader)
  -- function num : 0_1 , upvalues : _ENV, HandBookActReviewFunc, ActivityFrameEnum
  self._actFrameId = actFramId
  self._enterFunc = enterFunc
  self._honorWallFunc = honorWallFunc
  self._cfg = (((ConfigData.handbook_activity)[enterType]).content)[actFramId]
  local activityCfg = (ConfigData.activity)[actFramId]
  do
    if activityCfg ~= nil then
      local activityNameCfg = (ConfigData.activity_name)[activityCfg.name_id]
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

      ;
      ((self.ui).tex_ActName).text = (LanguageUtil.GetLocaleText)(activityNameCfg.name)
    end
    ;
    (((self.ui).bottom).gameObject):SetActive(false)
    if #(self._cfg).object_pic == 0 then
      error("res is NIL")
    else
      resloader:LoadABAssetAsync(PathConsts:GetHandbookItemPic((self._cfg).object_pic), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) or IsNull(self.transform) or texture.name ~= (self._cfg).object_pic then
      return 
    end
    ;
    (((self.ui).bottom).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).bottom).texture = texture
  end
)
    end
    self._totalRewardCount = #(self._cfg).reward_list
    ;
    (((self.ui).btn_RewardBg).gameObject):SetActive(self._totalRewardCount > 0)
    do
      if self._totalRewardCount > 0 then
        local hasRewardCount = 0
        for i,rewardId in ipairs((self._cfg).reward_list) do
          local itemCfg = (ConfigData.item)[rewardId]
          if itemCfg.type == eItemType.DormFurniture and (PlayerDataCenter.dormBriefData):ExistDormFntItem(rewardId) then
            hasRewardCount = hasRewardCount + 1
          end
          -- DECOMPILER ERROR at PC100: Unhandled construct in 'MakeBoolean' P1

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
        -- DECOMPILER ERROR at PC136: Confused about usage of register: R8 in 'UnsetPending'

        ;
        ((self.ui).tex_reward_Progress).text = tostring(hasRewardCount) .. "/" .. tostring(self._totalRewardCount)
      end
      local CPRData = (HandBookActReviewFunc[(ActivityFrameEnum.eActivityType).HeroGrow])(activityCfg.activity_id)
      local total, unlockCount = CPRData:GetCPRAvgGroupUnlockNum()
      -- DECOMPILER ERROR at PC154: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).tex_avg_Progress).text = tostring(unlockCount) .. "/" .. tostring(total)
      -- DECOMPILER ERROR: 6 unprocessed JMP targets
    end
  end
end

UINHandBookActBookExItem.PlayBookExAni = function(self, delayTime)
  -- function num : 0_2 , upvalues : CS_DOTween
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = 1
  ;
  ((((self.ui).canvasGroup):DOFade(0, 0.2)):From()):SetDelay(delayTime)
  self._tween = (CS_DOTween.Sequence)()
  ;
  (self._tween):AppendInterval(delayTime)
  ;
  (self._tween):AppendCallback(function()
    -- function num : 0_2_0 , upvalues : self
    ((self.ui).ani_item):Play()
  end
)
end

UINHandBookActBookExItem.OnClickEnterActEx = function(self)
  -- function num : 0_3
  if self._enterFunc ~= nil then
    (self._enterFunc)(self._actFrameId)
  end
end

UINHandBookActBookExItem.OnClickRewardActEx = function(self)
  -- function num : 0_4
  if self._honorWallFunc ~= nil then
    (self._honorWallFunc)(self._actFrameId, (((self.ui).btn_RewardBg).transform).position)
  end
end

UINHandBookActBookExItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  if self._tween ~= nil then
    (self._tween):Kill()
    self._tween = nil
  end
  ;
  ((self.ui).canvasGroup):DOComplete()
  ;
  (base.OnDelete)(self)
end

return UINHandBookActBookExItem

