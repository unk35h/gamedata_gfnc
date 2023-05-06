-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivitySeasonBonusItem = class("UINActivitySeasonBonusItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local eActInteract = require("Game.ActivityLobby.Activity.Season.eActInteract")
local cs_MessageCommon = CS.MessageCommon
UINActivitySeasonBonusItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Unlock, self, self.OnClickAVG)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RewardBg, self, self.OnClickGet)
end

UINActivitySeasonBonusItem.InitBounsItem = function(self, activitySeasonData, level, rewardFunc)
  -- function num : 0_1
  self._data = activitySeasonData
  self._level = level
  self._rewardFunc = rewardFunc
  self:__IntiFixed()
  self:RefreshBounsItem()
end

UINActivitySeasonBonusItem.__IntiFixed = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._avgId = nil
  local expCfg = ((self._data):GetSeasonRewardCfg())[self._level]
  if expCfg == nil then
    error("level is miss " .. tostring(self._level))
    return 
  end
  self._avgId = expCfg.unlock_story
  ;
  (((self.ui).btn_Unlock).gameObject):SetActive(self._avgId > 0)
  do
    if self._avgId > 0 then
      local storyCfg = (ConfigData.story_avg)[self._avgId]
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Number).text = (string.format)("%02d", storyCfg.number)
      if not IsNull((self.ui).tex_Title) then
        ((self.ui).tex_Title):SetIndex(2)
      end
      ;
      ((self.ui).tex_CharName):SetIndex(0, (LanguageUtil.GetLocaleText)(storyCfg.name))
    end
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Level).text = tostring(self._level)
    ;
    ((self.ui).obj_Exp):SetActive(self._level < (self._data):GetSeasonRewardLvLimit())
    ;
    (self._rewardPool):HideAll()
    if #expCfg.level_reward_ids == 0 then
      ((self.ui).img_RewardBg):SetActive(false)
    else
      ((self.ui).img_RewardBg):SetActive(true)
      for i,itemId in ipairs(expCfg.level_reward_ids) do
        local itemCount = (expCfg.level_reward_nums)[i]
        local itemCfg = (ConfigData.item)[itemId]
        local item = (self._rewardPool):GetOne()
        item:InitItemWithCount(itemCfg, itemCount)
      end
    end
    -- DECOMPILER ERROR: 7 unprocessed JMP targets
  end
end

UINActivitySeasonBonusItem.RefreshBounsItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local curLevel = (self._data):GetSeasonRewardCurLv()
  local canPicked = (self._data):IsSeasonRewardLevelCanPick(self._level)
  local isPicked = (self._data):IsSeasonRewardLevelReceived(self._level)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_AvgBottom).color = ((self.ui).color_AvgBg)[curLevel < self._level and 2 or 1]
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).btn_RewardBg).interactable = canPicked
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_LevelBg).color = ((self.ui).color_LevelBg)[curLevel < self._level and 2 or 1]
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = curLevel < self._level and 0.9 or 1
  -- DECOMPILER ERROR at PC61: Confused about usage of register: R4 in 'UnsetPending'

  if curLevel >= self._level or not (self.ui).color_unTargetLv then
    ((self.ui).tex_Level).color = Color.white
    -- DECOMPILER ERROR at PC67: Confused about usage of register: R4 in 'UnsetPending'

    if curLevel < self._level then
      ((self.ui).img_ExpProgress).fillAmount = 0
      ;
      (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
    else
      -- DECOMPILER ERROR at PC80: Confused about usage of register: R4 in 'UnsetPending'

      if self._level < curLevel then
        ((self.ui).img_ExpProgress).fillAmount = 1
        ;
        (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
      else
        ;
        (((self.ui).tex_ExpProgress).gameObject):SetActive(true)
        local curExp = (self._data):GetSeasonRewardCurExp()
        local maxExp = (self._data):GetSeasonRewardCurExpLimit()
        -- DECOMPILER ERROR at PC103: Confused about usage of register: R6 in 'UnsetPending'

        ;
        ((self.ui).img_ExpProgress).fillAmount = curExp / maxExp
        ;
        ((self.ui).tex_ExpProgress):SetIndex(0, tostring(curExp), tostring(maxExp))
      end
    end
    do
      for k,v in pairs((self._rewardPool).listItem) do
        v:SetPickedUIActive(isPicked)
      end
      if isPicked then
        ((self.ui).img_Bottom):SetIndex(0)
      else
        if canPicked then
          ((self.ui).img_Bottom):SetIndex(1)
        else
          ;
          ((self.ui).img_Bottom):SetIndex(2)
        end
      end
    end
  end
end

UINActivitySeasonBonusItem.GetSeasonRewardExpLevel = function(self)
  -- function num : 0_4
  return self._level
end

UINActivitySeasonBonusItem.OnClickAVG = function(self)
  -- function num : 0_5 , upvalues : _ENV, eActInteract, cs_MessageCommon
  if self._avgId == nil then
    return 
  end
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  if avgPlayCtrl == nil then
    return 
  end
  if avgPlayCtrl:IsAvgUnlock(self._avgId) then
    local unlockInfo = (self._data):GetSeasonUnlockInfo()
    if unlockInfo ~= nil then
      unlockInfo:ClearActUnlockInfo()
    end
    local seasonCtrl = ControllerManager:GetController(ControllerTypeId.ActivitySeason)
    if seasonCtrl ~= nil then
      seasonCtrl:OpenSeasonObj((eActInteract.eLbIntrctEntityId).MainStory)
    end
  else
    do
      ;
      (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8718))
    end
  end
end

UINActivitySeasonBonusItem.OnClickGet = function(self)
  -- function num : 0_6
  if self._rewardFunc ~= nil then
    (self._rewardFunc)(self._level, self)
  end
end

return UINActivitySeasonBonusItem

