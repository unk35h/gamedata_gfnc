-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroInfoVoiceNodeItem = class("UINHeroInfoVoiceNodeItem", UIBaseNode)
local base = UIBaseNode
local eHeroInfoenum = require("Game.Hero.NewUI.HeroInfo.eHeroInfoenum")
local CS_MessageCommon = CS.MessageCommon
UINHeroInfoVoiceNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__setPlayRate = BindCallback(self, self.__SetPlayRate)
  self.__onPlayOver = BindCallback(self, self.__OnPlayOver)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_friendShipItem, self, self.OnClickPlayVoice)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_Rate).fillAmount = 0
end

UINHeroInfoVoiceNodeItem.InitHeroInfoNodeItem = function(self, voiceData, playVoiceCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.voiceData = voiceData
  self.playVoiceCallback = playVoiceCallback
  local isUnlock = self:IsUnlock()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((voiceData.cfg).describe)
  ;
  ((self.ui).obj_lock):SetActive(not isUnlock)
  if isUnlock then
    ((self.ui).obj_img_isNew):SetActive(voiceData.isNewVoice)
    if voiceData.hasVoice then
      ((self.ui).img_buttom):SetIndex(0)
    else
      ;
      ((self.ui).img_buttom):SetIndex(1)
    end
  end
end

UINHeroInfoVoiceNodeItem.IsUnlock = function(self)
  -- function num : 0_2
  if self.voiceData == nil then
    return false
  end
  return (self.voiceData).isUnlock
end

UINHeroInfoVoiceNodeItem.GetUnLockTipStr = function(self)
  -- function num : 0_3
  if self.voiceData == nil then
    return nil
  end
  return (self.voiceData).unlockInfo
end

UINHeroInfoVoiceNodeItem.OnClickPlayVoice = function(self)
  -- function num : 0_4 , upvalues : CS_MessageCommon, _ENV, eHeroInfoenum
  local isUnlock = self:IsUnlock()
  do
    if not isUnlock then
      local unlockStr = self:GetUnLockTipStr()
      if unlockStr ~= nil then
        (CS_MessageCommon.ShowMessageTips)(unlockStr)
      end
      return 
    end
    if self.playVoiceCallback ~= nil then
      (self.playVoiceCallback)((self.voiceData).heroId, (self.voiceData).skinId, ((self.voiceData).cfg).id, self.__setPlayRate, self.__onPlayOver)
    end
    if (self.voiceData).isNewVoice then
      (NetworkManager:GetNetwork(NetworkTypeID.Hero)):CS_HERO_Record((self.voiceData).heroId, (eHeroInfoenum.recordType).audio, ((self.voiceData).cfg).is_show, function()
    -- function num : 0_4_0 , upvalues : self
    ((self.voiceData).heroData):SetAudioListed(((self.voiceData).cfg).is_show)
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.voiceData).isNewVoice = false
    ;
    ((self.ui).obj_img_isNew):SetActive(false)
  end
)
    end
  end
end

UINHeroInfoVoiceNodeItem.__SetPlayRate = function(self, rate)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if self.ui ~= nil and not IsNull((self.ui).img_Rate) then
    ((self.ui).img_Rate).fillAmount = rate
  end
end

UINHeroInfoVoiceNodeItem.__OnPlayOver = function(self)
  -- function num : 0_6
end

UINHeroInfoVoiceNodeItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINHeroInfoVoiceNodeItem

