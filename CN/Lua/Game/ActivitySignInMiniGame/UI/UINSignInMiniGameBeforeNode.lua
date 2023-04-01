-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSignInMininGameBeforeNode = class("UINSignInMininGameBeforeNode", UIBaseNode)
local base = UIBaseNode
local UINAwardItem = require("Game.ActivitySignInMiniGame.UI.UINSignInMiniGameAwardItem")
local UINDayItem = require("Game.ActivitySignInMiniGame.UI.UINSignInMiniGameDayItem")
UINSignInMininGameBeforeNode.ctor = function(self, storeRoomRoot)
  -- function num : 0_0
  self.storeRoomRoot = storeRoomRoot
end

UINSignInMininGameBeforeNode.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINAwardItem, UINDayItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).obj_awardItem):SetActive(false)
  self.awardItemPool = (UIItemPool.New)(UINAwardItem, (self.ui).obj_awardItem)
  ;
  ((self.ui).obj_vaildDayItem):SetActive(false)
  self.vaildDayItemPool = (UIItemPool.New)(UINDayItem, (self.ui).obj_vaildDayItem)
  ;
  ((self.ui).obj_emptyDayItem):SetActive(false)
  self.emptyDayItemPool = (UIItemPool.New)(UINDayItem, (self.ui).obj_emptyDayItem)
  self.vaildDayItemList = {}
  self._infoWindowAniTimer = nil
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self.OnClickBtnJump)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_stop, self, self.OnClickBtnStop)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bg, self, self.OnClickBtnBg)
end

UINSignInMininGameBeforeNode.InitNode = function(self, ctrl, resloader)
  -- function num : 0_2 , upvalues : _ENV
  self.siginInMiniCtrl = ctrl
  local actId = (self.siginInMiniCtrl):GetActId()
  local cfg = (ConfigData.sign_minigame_sign)[actId]
  if cfg == nil then
    return 
  end
  local curLeftDay = (self.siginInMiniCtrl):GetLeftDayWithOpenTime(PlayerDataCenter.timestamp)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  if curLeftDay < 1 then
    ((self.ui).tex_Date).text = (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[13]).content)
  else
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Date).text = curLeftDay .. (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[14]).content)
  end
  local allSignDay = (self.siginInMiniCtrl):GetAllSignInDay()
  local hasSignDayCount = (self.siginInMiniCtrl):GetHasSignDayCount()
  local isSignToDay = not (self.siginInMiniCtrl):IsCanSignToDay()
  local totalSignCount = (self.siginInMiniCtrl):GetTotalSignDay(actId)
  self.resloader = resloader
  ;
  ((self.ui).obj_SignedBg):SetActive(isSignToDay)
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R10 in 'UnsetPending'

  if not isSignToDay then
    if hasSignDayCount < 1 then
      ((self.ui).tex_Message).text = (string.format)((LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[11]).content), hasSignDayCount + 1, totalSignCount)
    else
      -- DECOMPILER ERROR at PC94: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).tex_Message).text = (string.format)((LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[12]).content), hasSignDayCount + 1, totalSignCount)
    end
    ;
    (((self.ui).tex_Message).gameObject):SetActive(false)
    TimerManager:StartTimer(1, function(obj_tex)
    -- function num : 0_2_0 , upvalues : _ENV
    if IsNull(obj_tex) then
      return 
    end
    ;
    (obj_tex.gameObject):SetActive(true)
  end
, (self.ui).tex_Message, true, true)
  end
  ;
  ((self.ui).obj_infoWindow):SetActive(not isSignToDay)
  do
    if not isSignToDay then
      local callback = function()
    -- function num : 0_2_1 , upvalues : _ENV
    AudioManager:PlayAudioById(1250)
  end

      TimerManager:StopTimer(self._infoWindowAniTimer)
      self._infoWindowAniTimer = TimerManager:StartTimer(1, callback, self, true)
    end
    -- DECOMPILER ERROR at PC144: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_Text).text = (string.format)((LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[10]).content), hasSignDayCount, totalSignCount)
    -- DECOMPILER ERROR at PC153: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_SigninTimes).text = tostring(hasSignDayCount) .. "/" .. totalSignCount
    ;
    (self.awardItemPool):HideAll()
    local num = #cfg.award_num_max
    for i = num, 1, -1 do
      local item = (self.awardItemPool):GetOne()
      ;
      (item.transform):SetParent(((self.ui).groupItem_Award).transform)
      ;
      (item.transform):SetAsLastSibling()
      item:InitItem(i, (cfg.award_num_min)[i], (cfg.award_num_max)[i])
    end
    ;
    (self.emptyDayItemPool):HideAll()
    for i = 1, 4 do
      local item = (self.emptyDayItemPool):GetOne()
      ;
      (item.transform):SetParent(((self.ui).groupItem_Day).transform)
      ;
      (item.transform):SetAsLastSibling()
    end
    self.vaildDayItemList = {}
    ;
    (self.vaildDayItemPool):HideAll()
    for i = 1, 15 do
      local item = (self.vaildDayItemPool):GetOne()
      ;
      (item.transform):SetParent(((self.ui).groupItem_Day).transform)
      ;
      (item.transform):SetAsLastSibling()
      local day = 22 + i
      if day > 30 then
        day = day - 30
      end
      item:InitVaildItem(day)
      local signFlag = 3
      if i <= curLeftDay then
        signFlag = 2
      end
      if allSignDay[i - 1] == true then
        signFlag = 1
      end
      item:ChangeSignFlag(signFlag)
      ;
      (table.insert)(self.vaildDayItemList, item)
    end
  end
end

UINSignInMininGameBeforeNode.RefreshNode = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local actId = (self.siginInMiniCtrl):GetActId()
  local curLeftDay = (self.siginInMiniCtrl):GetLeftDayWithOpenTime(PlayerDataCenter.timestamp)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  if curLeftDay < 1 then
    ((self.ui).tex_Date).text = (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[13]).content)
  else
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Date).text = curLeftDay .. (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[14]).content)
  end
  local allSignDay = (self.siginInMiniCtrl):GetAllSignInDay()
  local hasSignDayCount = (self.siginInMiniCtrl):GetHasSignDayCount()
  local totalSignCount = (self.siginInMiniCtrl):GetTotalSignDay(actId)
  local isSignToDay = not (self.siginInMiniCtrl):IsCanSignToDay()
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_SigninTimes).text = tostring(hasSignDayCount) .. "/" .. tostring(totalSignCount)
  ;
  ((self.ui).obj_SignedBg):SetActive(isSignToDay)
  for i = 1, 15 do
    local item = (self.vaildDayItemList)[i]
    local signFlag = 3
    if i <= curLeftDay then
      signFlag = 2
    end
    if allSignDay[i - 1] == true then
      signFlag = 1
    end
    item:ChangeSignFlag(signFlag)
  end
end

UINSignInMininGameBeforeNode.OnClickBtnJump = function(self)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).obj_emojiWindow):SetActive(true)
  self.emojiId = 0
  self.totalEmojiCount = #ConfigData.sign_minigame_emoji
  ;
  (((self.ui).btn_stop).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_bg).enabled = false
  self.jumpTimer = TimerManager:StartTimer(1, (BindCallback(self, self.ChangeEmoji)), nil, false, true)
  self._changeEmojiSound = AudioManager:PlayAudioById(1252, function(back)
    -- function num : 0_4_0 , upvalues : self
    self._changeEmojiSound = nil
  end
)
end

UINSignInMininGameBeforeNode.ChangeEmoji = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.emojiId = self.emojiId + 1
  if self.totalEmojiCount < self.emojiId then
    self.emojiId = self.emojiId - self.totalEmojiCount
  end
  local emojiSprite = ((ConfigData.sign_minigame_emoji)[self.emojiId]).name
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_emoji).sprite = (AtlasUtil.GetSpriteFromAtlas)("UI_SignInMiniGameBq", emojiSprite, self.resloader)
end

UINSignInMininGameBeforeNode.OnClickBtnStop = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self.jumpTimer ~= nil then
    TimerManager:StopTimer(self.jumpTimer)
    self.jumpTimer = nil
  end
  if self._changeEmojiSound ~= nil then
    AudioManager:StopAudioByBack(self._changeEmojiSound)
  end
  AudioManager:PlayAudioById(1253)
  ;
  (((self.ui).btn_stop).gameObject):SetActive(false)
  ;
  (self.siginInMiniCtrl):CS_ACTIVITY_SignMiniGame_Sign(self.emojiId, function()
    -- function num : 0_6_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).btn_bg).enabled = true
  end
)
end

UINSignInMininGameBeforeNode.OnClickBtnBg = function(self)
  -- function num : 0_7
  ((self.ui).obj_emojiWindow):SetActive(false)
  ;
  ((self.ui).obj_infoWindow):SetActive(false)
  ;
  (self.storeRoomRoot):OnEmojiWindowClose()
end

UINSignInMininGameBeforeNode.OnShow = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnShow)(self)
end

UINSignInMininGameBeforeNode.OnHide = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnHide)()
end

UINSignInMininGameBeforeNode.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (base.OnDelete)(self)
  ;
  (self.vaildDayItemPool):DeleteAll()
  ;
  (self.emptyDayItemPool):DeleteAll()
  ;
  (self.awardItemPool):DeleteAll()
  if self.jumpTimer ~= nil then
    TimerManager:StopTimer(self.jumpTimer)
    self.jumpTimer = nil
  end
  if self._changeEmojiSound ~= nil then
    AudioManager:StopAudioByBack(self._changeEmojiSound)
  end
  TimerManager:StopTimer(self._infoWindowAniTimer)
end

return UINSignInMininGameBeforeNode

