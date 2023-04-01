-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayLookPhotoNode = class("UINWhiteDayLookPhotoNode", UIBaseNode)
local base = UIBaseNode
local cs_ResLoader = CS.ResLoader
UINWhiteDayLookPhotoNode.ctor = function(self, AWDCtrl, AWDData, resloader)
  -- function num : 0_0 , upvalues : _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDData = AWDData
  self.resloader = resloader
  local BackgroundStretchSize = UIManager.BackgroundStretchSize
  local shortLen = (math.min)(BackgroundStretchSize.x, BackgroundStretchSize.y)
  self.__PhotoMaxSize = (Vector3.New)(shortLen * 0.9, shortLen, 0)
end

UINWhiteDayLookPhotoNode.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickCloseLookPhoto)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Story, self, self.__OnClickStory)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self.OnClickCheck)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skin, self, self.OnClickSkin)
  self.__isInCheck = false
  self.__photoOrigSize = (((self.ui).img_Photo).transform).sizeDelta
  self.__photoOrigPos = (((self.ui).img_Photo).transform).anchoredPosition
end

UINWhiteDayLookPhotoNode.SetJustLookAvg = function(self)
  -- function num : 0_2
  self._justLookAvg = true
end

UINWhiteDayLookPhotoNode.InitWDSelectNode = function(self, photoCfg, closeCallback, openSkinCall)
  -- function num : 0_3 , upvalues : _ENV, cs_ResLoader
  self.closeCallback = closeCallback
  self.openSkinCall = openSkinCall
  self.__isInCheck = false
  ;
  ((self.ui).obj_frame):SetActive(true)
  ;
  ((self.ui).obj_BigPhotoNode):SetActive(false)
  ;
  (((self.ui).img_Photo).transform):SetParent((self.ui).obj_PhotoRoot)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_Photo).transform).sizeDelta = self.__photoOrigSize
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).img_Photo).transform).anchoredPosition = self.__photoOrigPos
  local color = ((self.ui).img_Photo).color
  color.a = 1
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Photo).color = color
  if photoCfg == self.photoCfg then
    return 
  end
  self.photoCfg = photoCfg
  local photo_resource = photoCfg.photo_resource
  if not (string.IsNullOrEmpty)(photo_resource) then
    if self.bigResLoader ~= nil then
      (self.bigResLoader):Put2Pool()
      self.bigResLoader = nil
    end
    self.bigResLoader = (cs_ResLoader.Create)()
    local path = PathConsts:GetWhiteDayPhotoPath(photo_resource)
    ;
    (UIUtil.LoadABAssetAsyncAndSetTexture)(self.bigResLoader, path, (self.ui).img_Photo)
  end
  do
    local skinUseful = ((self.photoCfg).skinId ~= nil and (PlayerDataCenter.skinData):IsSkinUnlocked((self.photoCfg).skinId))
    ;
    (((self.ui).btn_Skin).gameObject):SetActive(skinUseful)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINWhiteDayLookPhotoNode.__OnClickStory = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local storyId = (self.photoCfg).story_id
  local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
  if self._justLookAvg then
    local avgCfg = (ConfigData.story_avg)[storyId]
    avgCtrl:ShowAvg(avgCfg.script_id)
  else
    do
      avgCtrl:StartAvg(nil, storyId)
    end
  end
end

UINWhiteDayLookPhotoNode.OnClickCheck = function(self)
  -- function num : 0_5 , upvalues : _ENV
  ((self.ui).obj_frame):SetActive(false)
  ;
  ((self.ui).obj_BigPhotoNode):SetActive(true)
  ;
  (((self.ui).img_Photo).transform):SetParent((self.ui).obj_BigPhotoRoot)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).img_PhotoBg).transform).sizeDelta = self.__PhotoMaxSize
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).img_Photo).transform).anchoredPosition = Vector2.zero
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).img_Photo).transform).sizeDelta = Vector2.zero
  ;
  ((((self.ui).img_Photo):DOFade(0, 1.5)):From()):SetEase((((CS.DG).Tweening).Ease).OutQuad)
  AudioManager:PlayAudioById(1209)
  self.__isInCheck = true
end

UINWhiteDayLookPhotoNode.OnClickSkin = function(self)
  -- function num : 0_6
  if self.openSkinCall ~= nil then
    (self.openSkinCall)((self.photoCfg).skinId)
  end
end

UINWhiteDayLookPhotoNode.OnClickCloseLookPhoto = function(self)
  -- function num : 0_7
  if self.__isInCheck then
    ((self.ui).obj_frame):SetActive(true)
    ;
    ((self.ui).obj_BigPhotoNode):SetActive(false)
    ;
    (((self.ui).img_Photo).transform):SetParent((self.ui).obj_PhotoRoot)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.ui).img_Photo).transform).anchoredPosition = self.__photoOrigPos
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.ui).img_Photo).transform).sizeDelta = self.__photoOrigSize
    self.__isInCheck = false
    ;
    ((self.ui).img_Photo):DOComplete()
    return 
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  ;
  ((self.ui).img_Photo):DOKill()
  self:Hide()
end

UINWhiteDayLookPhotoNode.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  if self.bigResLoader ~= nil then
    (self.bigResLoader):Put2Pool()
    self.bigResLoader = nil
  end
  ;
  ((self.ui).img_Photo):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINWhiteDayLookPhotoNode

