-- params : ...
-- function num : 0 , upvalues : _ENV
local UINUserInfoNode = class("UINUserInfoNode", UIBaseNode)
local base = UIBaseNode
local UINUserInfoBottomItem = require("Game.User.UINUserInfoBottomItem")
local UINUserInfoSupportHeroNode = require("Game.User.UINUserInfoSupportHeroNode")
local RenameHelper = require("Game.CommonUI.Rename.RenameHelper")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local UINUserTitle = require("Game.CommonUI.Title.UINNormalTitleItem")
local newBottomItemTab = {
[1] = {func = function(userInfoData)
  -- function num : 0_0 , upvalues : _ENV
  local totalCount = (ConfigData.hero_data).totalHeroCount
  return tostring(userInfoData:GetHasHeroNum()) .. "<color=#777777><size=36>/" .. tostring(totalCount) .. "</size></color>"
end
}
, 
[2] = {func = function(userInfoData)
  -- function num : 0_1 , upvalues : _ENV
  local epProgress = userInfoData:GetEpProgress()
  if epProgress.sectorId == nil or epProgress.stageIndex == nil then
    return "NO PASS"
  end
  return "STAGE " .. tostring(epProgress.sectorId) .. "-" .. tostring(epProgress.stageIndex)
end
}
, 
[3] = {func = function(userInfoData)
  -- function num : 0_2 , upvalues : _ENV
  return tostring(userInfoData:GetInfinityLevelSum()) .. "m"
end
}
, 
[4] = {func = function(userInfoData)
  -- function num : 0_3 , upvalues : _ENV
  local totalLevel = userInfoData:GetBuildingTotalLevel()
  return "Lv." .. tostring(totalLevel)
end
}
, 
[5] = {func = function(userInfoData)
  -- function num : 0_4 , upvalues : _ENV
  local levelNum = userInfoData:GetDefaultTowerProgress()
  return (string.format)("%dC", levelNum)
end
}
}
UINUserInfoNode.OnInit = function(self)
  -- function num : 0_5 , upvalues : _ENV, UINUserHead, UINUserTitle, UINUserInfoSupportHeroNode
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CopyUID, self, self._OnCopyUIDClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChangeName, self, self._OnChangeNameClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChangeTitle, self, self._OpenChangeUserTitle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_titleAdd, self, self._OpenChangeUserTitle)
  ;
  ((self.ui).obj_supportHeroItem):SetActive(false)
  self._titleBlueDotChange = BindCallback(self, self.RefreshBlueDot)
  self.userHeadNode = (UINUserHead.New)()
  ;
  (self.userHeadNode):Init((self.ui).obj_UINUserHead)
  ;
  (self.userHeadNode):BindUserHeadEvent(BindCallback(self, self._OpenChangeUserHead))
  self.userTitleNode = (UINUserTitle.New)()
  ;
  (self.userTitleNode):Init((self.ui).obj_UINUserTitle)
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_PlacerHolder).text = ConfigData:GetTipContent((ConfigData.game_config).playerDefaultSignatureId)
  self.supportPool = (UIItemPool.New)(UINUserInfoSupportHeroNode, (self.ui).obj_supportHeroItem)
  self:_InitGameVersion()
  self.__OnHeroUpdate = BindCallback(self, self._OnHeroUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__OnHeroUpdate)
  self.__OnSelfNameChange = BindCallback(self, self._OnSelfNameChange)
  MsgCenter:AddListener(eMsgEventId.UserNameChanged, self.__OnSelfNameChange)
  self._titleChangeCallback = BindCallback(self, self.TitleChangeCallback)
  self.characterLimit = ((self.ui).input_Signature).characterLimit
  ;
  ((self.ui).obj_bottomInfoListItem):SetActive(false)
end

UINUserInfoNode._InitGameVersion = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local hasHotUpdateVer = (CS.ClientConsts).GameVersionStr
  ;
  ((self.ui).tex_Version):SetIndex(0, hasHotUpdateVer)
end

UINUserInfoNode.RefershInfoNode = function(self, userInfoData, changeNameAction, resLoader, couldEditSelf)
  -- function num : 0_7
  self.userInfoData = userInfoData
  self.resLoader = resLoader
  self.couldEditSelf = couldEditSelf
  self:_RefreshDiffWithOtherUser()
  self:SetChangeNameBtnActive(changeNameAction)
  self:_RefreshUserInfo()
  self:_RefreshExperience()
  self:RefreshSupport()
end

UINUserInfoNode.UpdateInfoNode = function(self)
  -- function num : 0_8
  if self.userInfoData == nil then
    return 
  end
  self:_RefreshUserInfo()
  self:_RefreshExperience()
  self:RefreshSupport()
end

UINUserInfoNode._RefreshDiffWithOtherUser = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local isSelf = (self.userInfoData):GetIsSelfUserInfo()
  if isSelf then
    local enableEditor = self.couldEditSelf
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).input_Signature).interactable = enableEditor
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).input_Signature).characterLimit = (ConfigData.game_config).playerSignatureNumLimit
  self.characterLimit = ((self.ui).input_Signature).characterLimit
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  if enableEditor and CloseCustomBename then
    ((self.ui).input_Signature).interactable = false
    if self._clickSignatureAction == nil then
      self._clickSignatureAction = function()
    -- function num : 0_9_0 , upvalues : _ENV
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(393))
  end

      ;
      (((CS.EventTriggerListener).Get)(((self.ui).input_Signature).gameObject)):onClick("+", self._clickSignatureAction)
    end
  end
end

UINUserInfoNode._RefreshUserInfo = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local userInfoData = self.userInfoData
  self:RefreshUserName(userInfoData)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_UID).text = "UID:" .. userInfoData:GetUserUID()
  ;
  (self.userHeadNode):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), self.resLoader)
  local title = userInfoData:GetAvatarTitleId()
  self:RefreshUserTitle(title)
  self:RefreshUserSignature(userInfoData:GetAvatarSignature())
  self:RefreshDressUp(userInfoData:GetBackgroudPlateId())
  self:RefreshUserLevel(userInfoData:GetUserLevel())
  local timeDate = TimeUtil:TimestampToDate((userInfoData:GetCreateTime()), nil, true)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_CreateTime).text = timeDate.year .. "-" .. timeDate.month .. "-" .. timeDate.day
end

UINUserInfoNode.RefreshUserTitle = function(self, title)
  -- function num : 0_11 , upvalues : _ENV
  if (not (self.userInfoData):GetIsSelfUserInfo() or not self.couldEditSelf) and (not title or title.titlePrefix == 0) then
    (((self.ui).btn_titleAdd).gameObject):SetActive(false)
    ;
    ((self.ui).obj_UINUserTitle):SetActive(false)
    return 
  end
  do
    if (self.userInfoData):GetIsSelfUserInfo() and self.couldEditSelf then
      local ok, newTitleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Title)
      if not ok then
        newTitleNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Title)
        if (PlayerDataCenter.gameSettingData):GetNewTitleItemNum() > 0 then
          newTitleNode:SetRedDotCount(1)
        end
      end
      if self.titleBlueDot == nil then
        RedDotController:AddListener(newTitleNode.nodePath, self._titleBlueDotChange)
        self.titleBlueDot = true
      end
      self:RefreshBlueDot(newTitleNode)
    end
    if not title then
      local realTitle = {titlePrefix = nil, titlePostfix = nil, titleBackGround = nil}
    end
    if realTitle.titlePrefix and realTitle.titlePrefix ~= 0 then
      (((self.ui).btn_titleAdd).gameObject):SetActive(false)
      ;
      ((self.ui).obj_UINUserTitle):SetActive(true)
    else
      ;
      (((self.ui).btn_titleAdd).gameObject):SetActive(true)
      ;
      ((self.ui).obj_UINUserTitle):SetActive(false)
    end
    local atlasPath = PathConsts:GetSpriteAtlasPath("TitleIcon")
    self._titleBgAtlas = (self.resLoader):LoadABAsset(atlasPath)
    ;
    (self.userTitleNode):InitNormalTitleItem(realTitle.titlePrefix, realTitle.titlePostfix, realTitle.titleBackGround, self.resLoader, self._titleBgAtlas)
  end
end

UINUserInfoNode.RefreshBlueDot = function(self, node)
  -- function num : 0_12
  if node:GetRedDotCount() > 0 then
    ((self.ui).obj_titleBlueDot):SetActive(true)
  else
    ;
    ((self.ui).obj_titleBlueDot):SetActive(false)
  end
end

UINUserInfoNode.RefreshUserLevel = function(self, tempLv)
  -- function num : 0_13 , upvalues : _ENV
  if tempLv >= 10 or not "LV.0" .. tostring(tempLv) then
    local strLv = "LV." .. tostring(tempLv)
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).text = strLv
end

UINUserInfoNode.SaveUserSignature = function(self)
  -- function num : 0_14 , upvalues : RenameHelper, _ENV
  local inputSignature = ((self.ui).input_Signature).text
  if (self.userInfoData):GetAvatarSignature() == ((self.ui).input_Signature).text then
    return 
  end
  local inputLength = RenameHelper:GetNameLength(inputSignature)
  if self.characterLimit < inputLength then
    inputSignature = RenameHelper:ClampNameInLength(inputSignature, self.characterLimit)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).input_Signature).text = inputSignature
  end
  ;
  (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_SignatureMod(inputSignature)
end

UINUserInfoNode._RefreshExperience = function(self)
  -- function num : 0_15 , upvalues : _ENV, UINUserInfoBottomItem, newBottomItemTab
  if self.bottomInfoPool == nil then
    self.bottomInfoPool = (UIItemPool.New)(UINUserInfoBottomItem, (self.ui).obj_bottomInfoListItem)
  else
    ;
    (self.bottomInfoPool):HideAll()
  end
  for index,tab in ipairs(newBottomItemTab) do
    local item = (self.bottomInfoPool):GetOne()
    item:InitUserInfoBottomItem(index, tab.func, nil, self.userInfoData)
  end
end

UINUserInfoNode.RefreshDressUp = function(self, backgroudPlateId)
  -- function num : 0_16 , upvalues : _ENV
  local resCfg = (ConfigData.portrait_card)[backgroudPlateId]
  ;
  (((self.ui).img_DressUp).gameObject):SetActive(false)
  do
    if resCfg == nil then
      local defaultId = (ConfigData.game_config).userInfoUIBG
      resCfg = (ConfigData.portrait_card)[defaultId]
    end
    if resCfg == nil then
      return 
    end
    local resName = resCfg.icon
    if self.softMaskMat == nil then
      self.softMaskMat = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_softMask)
      ;
      (self.softMaskMat):SetFloat("_clipSoftX", 400)
      ;
      (self.softMaskMat):SetFloat("_clipSoftY", 1)
    end
    if self.dressUpResloader ~= nil then
      (self.dressUpResloader):Put2Pool()
      self.dressUpResloader = nil
    end
    self.dressUpResloader = ((CS.ResLoader).Create)()
    local path = PathConsts:GetUserDressUpPath(resName)
    ;
    (self.dressUpResloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_16_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(texture) then
      ((self.ui).img_DressUp).texture = texture
      ;
      (((self.ui).img_DressUp).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_DressUp).material = self.softMaskMat
    end
  end
)
  end
end

UINUserInfoNode.RefreshUserName = function(self, userInfoData)
  -- function num : 0_17
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  if userInfoData:GetIsFriend() and userInfoData:GetIsHaveAlias() then
    ((self.ui).tex_Name).text = userInfoData:GetUserName() .. "<size=42>(" .. userInfoData:GetAlias() .. ")</size>"
    return 
  end
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = userInfoData:GetUserName()
end

UINUserInfoNode.RefreshUserHeadOnly = function(self, headId)
  -- function num : 0_18
  (self.userHeadNode):RefreshUserHeadOnly(headId)
end

UINUserInfoNode.RefreshUserHeadFrameOnly = function(self, frameId)
  -- function num : 0_19
  (self.userHeadNode):RefreshUserHeadFrameOnly(frameId)
end

UINUserInfoNode.RefreshUserSignature = function(self, strSignature)
  -- function num : 0_20 , upvalues : _ENV
  if strSignature == nil then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).input_Signature).text = tostring(strSignature)
end

UINUserInfoNode.RefreshSupport = function(self)
  -- function num : 0_21 , upvalues : _ENV
  (self.supportPool):HideAll()
  for index,supportHeroInfo in ipairs((self.userInfoData):GetSupportHoreInfoList()) do
    local item = (self.supportPool):GetOne()
    item:InitSupportHero(index, self.userInfoData, self.resLoader, self.couldEditSelf)
  end
end

UINUserInfoNode._OnCopyUIDClick = function(self)
  -- function num : 0_22 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((CS.UnityEngine).GUIUtility).systemCopyBuffer = (self.userInfoData):GetUserUID()
  ;
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.UserInfo_CopyUIDDone))
  AudioManager:PlayAudioById(1124)
end

UINUserInfoNode._OnChangeNameClick = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if not (self.userInfoData):GetIsSelfUserInfo() or not self.couldEditSelf then
    return 
  end
  if CloseCustomBename then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(393))
    return 
  end
  if self._changeNameAction ~= nil then
    (self._changeNameAction)()
  end
end

UINUserInfoNode.SetChangeNameBtnActive = function(self, changeNameAction)
  -- function num : 0_24
  if changeNameAction == nil then
    (((self.ui).btn_ChangeName).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).btn_ChangeName).gameObject):SetActive(true)
  self._changeNameAction = changeNameAction
end

UINUserInfoNode._OpenChangeUserHead = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if not (self.userInfoData):GetIsSelfUserInfo() or not self.couldEditSelf then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.UserInfoDialog, function(window)
    -- function num : 0_25_0
    if window ~= nil then
      window:OpenChangeUserHeadDialog()
    end
  end
)
end

UINUserInfoNode._OpenChangeUserTitle = function(self)
  -- function num : 0_26 , upvalues : _ENV
  if not (self.userInfoData):GetIsSelfUserInfo() or not self.couldEditSelf then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.UserInfoDialog, function(window)
    -- function num : 0_26_0 , upvalues : self
    if window ~= nil then
      window:OpenChangeUserTitle(self._titleChangeCallback)
    end
  end
)
end

UINUserInfoNode.TitleChangeCallback = function(self, preId, postId, bgId)
  -- function num : 0_27
  if preId and preId ~= 0 then
    (((self.ui).btn_titleAdd).gameObject):SetActive(false)
    ;
    ((self.ui).obj_UINUserTitle):SetActive(true)
  else
    ;
    (((self.ui).btn_titleAdd).gameObject):SetActive(true)
    ;
    ((self.ui).obj_UINUserTitle):SetActive(false)
  end
  ;
  (self.userTitleNode):RefreshTitle(preId, postId, bgId)
end

UINUserInfoNode._OnHeroUpdate = function(self)
  -- function num : 0_28 , upvalues : _ENV
  for _,nodeItem in pairs((self.supportPool).listItem) do
    nodeItem:RefreshSupportHero()
  end
end

UINUserInfoNode._OnSelfNameChange = function(self)
  -- function num : 0_29
  if (self.userInfoData):GetIsSelfUserInfo() then
    self:RefreshUserName(self.userInfoData)
  end
end

UINUserInfoNode.OnDelete = function(self)
  -- function num : 0_30 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__OnHeroUpdate)
  MsgCenter:RemoveListener(eMsgEventId.UserNameChanged, self.__OnSelfNameChange)
  local ok, newTitleNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Title)
  if ok and self.titleBlueDot then
    RedDotController:RemoveListener(newTitleNode.nodePath, self._titleBlueDotChange)
  end
  if self.softMaskMat ~= nil then
    DestroyUnityObject(self.softMaskMat)
    self.softMaskMat = nil
  end
  if self.dressUpResloader ~= nil then
    (self.dressUpResloader):Put2Pool()
    self.dressUpResloader = nil
  end
  if self.bottomInfoPool ~= nil then
    (self.bottomInfoPool):DeleteAll()
  end
  if self.supportPool ~= nil then
    (self.supportPool):DeleteAll()
  end
  ;
  (base.OnDelete)(self)
end

return UINUserInfoNode

