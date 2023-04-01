-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSignInMiniGameAfterItem = class("UINSignInMiniGameDayItem", UIBaseNode)
local base = UIBaseNode
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINSignInMiniGameAfterItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
end

UINSignInMiniGameAfterItem.InitItem = function(self, ctrl, signData, resLoader, index, isNeedAnim)
  -- function num : 0_1 , upvalues : _ENV, cs_DoTween
  local userInfoData = PlayerDataCenter.inforData
  local leftDay = ctrl:GetLeftDayWithCurTime(signData.signTime)
  local range = ctrl:GetSignDataRange(index, signData)
  local totalDay = ctrl:GetTotalSignDay()
  self.minigameCtrl = ctrl
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_playerName).text = userInfoData:GetUserName()
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_UID).text = "UID:" .. userInfoData:GetUserUID()
  ;
  (self.userHeadNode):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), resLoader)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R10 in 'UnsetPending'

  if leftDay < 1 then
    ((self.ui).tex_date).text = (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[13]).content)
  else
    -- DECOMPILER ERROR at PC56: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_date).text = leftDay .. (LanguageUtil.GetLocaleText)(((ConfigData.sign_minigame_text)[14]).content)
  end
  local emojiCfg = (ConfigData.sign_minigame_emoji)[signData.emojiId]
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R11 in 'UnsetPending'

  if emojiCfg ~= nil then
    ((self.ui).img_emoji).sprite = (AtlasUtil.GetSpriteFromAtlas)("UI_SignInMiniGameBq", emojiCfg.name, resLoader)
  end
  local textCfg = (ConfigData.sign_minigame_text)[signData.textId]
  -- DECOMPILER ERROR at PC89: Confused about usage of register: R12 in 'UnsetPending'

  if textCfg ~= nil then
    ((self.ui).tex_text).text = (string.format)((LanguageUtil.GetLocaleText)(textCfg.content), index, totalDay)
  end
  if isNeedAnim then
    if self.animTween == nil then
      self.animTween = (cs_DoTween.Sequence)()
      ;
      (((((((self.animTween):AppendCallback(function()
    -- function num : 0_1_0 , upvalues : self, range, _ENV
    ((self.ui).tween_Hot):DORestartById("hot")
    ;
    ((self.ui).tex_tag):SetIndex(range - 1)
    ;
    ((self.ui).img_tag):SetIndex(range - 1)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (((self.ui).img_tag).image).color = (Color.New)(1, 1, 1, 0)
    AudioManager:PlayAudioById(1251)
  end
)):Join(((self.ui).tex_likeNum):DOCounter(0, signData.hot, 1.5))):AppendCallback(function()
    -- function num : 0_1_1 , upvalues : self
    ((self.ui).tween_Tag):DORestartById("Anim")
  end
)):AppendInterval(1)):AppendCallback(function()
    -- function num : 0_1_2 , upvalues : self
    (self.minigameCtrl):ShowAward()
  end
)):SetAutoKill(false)):Pause()
    end
    ;
    (self.animTween):Restart()
  else
    -- DECOMPILER ERROR at PC132: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).tex_likeNum).text = signData.hot
    ;
    ((self.ui).tex_tag):SetIndex(range - 1)
    ;
    ((self.ui).img_tag):SetIndex(range - 1)
  end
end

UINSignInMiniGameAfterItem.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
  ;
  (self.userHeadNode):Delete()
  if self.animTween ~= nil then
    (self.animTween):Kill()
    self.animTween = nil
  end
end

return UINSignInMiniGameAfterItem

