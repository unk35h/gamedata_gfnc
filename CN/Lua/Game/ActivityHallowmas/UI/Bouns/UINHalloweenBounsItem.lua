-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenBounsItem = class("UINHalloweenBounsItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local cs_MessageCommon = CS.MessageCommon
UINHalloweenBounsItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._rewardPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINHalloweenBounsItem.InitBounsItem = function(self, hallowmasData, level, rewardFunc)
  -- function num : 0_1
  self._data = hallowmasData
  self._level = level
  self._rewardFunc = rewardFunc
  self:__IntiFixed()
  self:RefreshBounsItem()
end

UINHalloweenBounsItem.__IntiFixed = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._avgId = nil
  local expCfg = ((self._data):GetHallowmasExpCfg())[self._level]
  if expCfg == nil then
    error("level is miss " .. tostring(self._level))
    return 
  end
  self._avgId = expCfg.unlock_story
  ;
  (((self.ui).obj_Unlock).gameObject):SetActive(self._avgId > 0)
  do
    if self._avgId > 0 then
      local storyCfg = (ConfigData.story_avg)[self._avgId]
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Number).text = "#" .. tostring(storyCfg.number)
      if not IsNull((self.ui).tex_Title) then
        ((self.ui).tex_Title):SetIndex(2)
      end
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_CharName).text = (LanguageUtil.GetLocaleText)(storyCfg.name)
    end
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Level).text = tostring(self._level)
    ;
    ((self.ui).obj_Exp):SetActive(self._level < (self._data):GetHallowmasLvLimit())
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

UINHalloweenBounsItem.RefreshBounsItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local curLevel = (self._data):GetHallowmasLv()
  ;
  ((self.ui).img_LevelBg):SetIndex(curLevel < self._level and 1 or 0)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup).alpha = curLevel < self._level and 0.9 or 1
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  if curLevel >= self._level or not (self.ui).color_unTargetLv then
    ((self.ui).tex_Level).color = Color.black
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R2 in 'UnsetPending'

    if curLevel < self._level then
      ((self.ui).img_ExpProgress).fillAmount = 0
      ;
      (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
    else
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R2 in 'UnsetPending'

      if self._level < curLevel then
        ((self.ui).img_ExpProgress).fillAmount = 1
        ;
        (((self.ui).tex_ExpProgress).gameObject):SetActive(false)
      else
        ;
        (((self.ui).tex_ExpProgress).gameObject):SetActive(true)
        local curExp = (self._data):GetHallowmasCurExp()
        local maxExp = (self._data):GetHallowmasCurExpLimit()
        -- DECOMPILER ERROR at PC77: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).img_ExpProgress).fillAmount = curExp / maxExp
        ;
        ((self.ui).tex_ExpProgress):SetIndex(0, tostring(curExp), tostring(maxExp))
      end
    end
    do
      local isPicked = (self._data):IsHallowmasLevelReceived(self._level)
      for k,v in pairs((self._rewardPool).listItem) do
        v:SetPickedUIActive(isPicked)
      end
    end
  end
end

UINHalloweenBounsItem.GetHallowExpLevel = function(self)
  -- function num : 0_4
  return self._level
end

UINHalloweenBounsItem.OnClickGet = function(self)
  -- function num : 0_5
  if self._rewardFunc ~= nil then
    (self._rewardFunc)(self._level, self)
  end
end

return UINHalloweenBounsItem

