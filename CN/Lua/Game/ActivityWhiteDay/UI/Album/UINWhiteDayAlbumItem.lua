-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayAlbumItem = class("UINWhiteDayAlbumItem", UIBaseNode)
local base = UIBaseNode
UINWhiteDayAlbumItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_item, self, self.__OnClickPhotoItem)
end

UINWhiteDayAlbumItem.__Reset = function(self)
  -- function num : 0_1
  self.photoCfg = nil
  self.__isAvg = false
  self.avgId = nil
  self._skinId = nil
  ;
  ((self.ui).img_Owned):SetActive(false)
end

UINWhiteDayAlbumItem.InitWDPhotoItem = function(self, isUnlock, photoCfg, resloader, onClickCallback)
  -- function num : 0_2 , upvalues : _ENV
  self:__Reset()
  ;
  ((self.ui).obj_video):SetActive(false)
  ;
  ((self.ui).obj_photo):SetActive(true)
  self.isUnlock = isUnlock
  self.photoCfg = photoCfg
  self.onClickCallback = onClickCallback
  ;
  ((self.ui).obj_img_Empty):SetActive(not isUnlock)
  ;
  ((self.ui).obj_heroName):SetActive(isUnlock)
  ;
  (((self.ui).img_Photo).gameObject):SetActive(isUnlock)
  ;
  ((self.ui).obj_blueDot):SetActive(false)
  if not isUnlock then
    return 
  end
  self._skinId = photoCfg.skinId
  local photo_resource = photoCfg.photo_resource
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R6 in 'UnsetPending'

  if not (string.IsNullOrEmpty)(photo_resource) then
    ((self.ui).img_Photo).sprite = (AtlasUtil.GetSpriteFromAtlas)(UIAtlasConsts.Atlas_WhiteDaySmallPhoto, photo_resource, resloader)
  end
  local heroId = photoCfg.photo_hero
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg == nil then
    error("can\'t read heroCfg with id" .. tostring(heroId))
    return 
  end
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  self:RefreshDayAlbumItemSkinState()
end

UINWhiteDayAlbumItem.InitWDPhotoAvgItem = function(self, AWDData, avgId, isUnlock, resloader, isFirstHistoryAvg)
  -- function num : 0_3 , upvalues : _ENV
  self:__Reset()
  self.AWDData = AWDData
  ;
  ((self.ui).obj_video):SetActive(true)
  ;
  ((self.ui).obj_photo):SetActive(false)
  ;
  (((self.ui).img_Video).gameObject):SetActive(isUnlock)
  ;
  (((self.ui).tex_VideoName).gameObject):SetActive(isUnlock)
  ;
  ((self.ui).obj_img_Lock):SetActive(not isUnlock)
  if isUnlock then
    local avgCfg = (ConfigData.story_avg)[avgId]
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_VideoName).text = (LanguageUtil.GetLocaleText)(avgCfg.name)
    local pic = avgCfg.pic
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R8 in 'UnsetPending'

    if not (string.IsNullOrEmpty)(pic) then
      ((self.ui).img_Video).sprite = (AtlasUtil.GetSpriteFromAtlas)(UIAtlasConsts.Atlas_WhiteDaySmallPhoto, pic, resloader)
    end
    if not isFirstHistoryAvg then
      local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
      ;
      ((self.ui).obj_blueDot):SetActive((avgPlayCtrl ~= nil and not avgPlayCtrl:IsAvgPlayed(avgId)))
    else
      ((self.ui).obj_blueDot):SetActive(false)
    end
  else
    ((self.ui).obj_blueDot):SetActive(false)
    if isFirstHistoryAvg then
      ((self.ui).txt_avgLockInfo):SetIndex(1)
    else
      ((self.ui).txt_avgLockInfo):SetIndex(0)
    end
  end
  self.avgId = avgId
  self.__isAvg = true
  self.isUnlock = isUnlock
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINWhiteDayAlbumItem.SetJustLookAvg = function(self)
  -- function num : 0_4
  self._justLookAvg = true
end

UINWhiteDayAlbumItem.RefreshDayAlbumItemSkinState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._skinId or 0 == 0 then
    return 
  end
  local haveSkin = self.isUnlock
  if haveSkin then
    haveSkin = (PlayerDataCenter.skinData):IsHaveSkin(self._skinId)
  end
  ;
  ((self.ui).img_Owned):SetActive(haveSkin)
end

UINWhiteDayAlbumItem.__OnClickPhotoItem = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if not self.isUnlock then
    AudioManager:PlayAudioById(1210)
    return 
  end
  if self.__isAvg then
    local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
    if self._justLookAvg then
      local avgCfg = (ConfigData.story_avg)[self.avgId]
      avgCtrl:ShowAvg(avgCfg.script_id)
    else
      do
        do
          avgCtrl:StartAvg(nil, self.avgId, function()
    -- function num : 0_6_0 , upvalues : self
    ((self.ui).obj_blueDot):SetActive(false)
    if self.AWDData ~= nil then
      (self.AWDData):RefreshWDReddot4AlbumAvg()
    end
  end
)
          if self.onClickCallback ~= nil then
            (self.onClickCallback)(self.photoCfg)
          end
        end
      end
    end
  end
end

UINWhiteDayAlbumItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayAlbumItem

