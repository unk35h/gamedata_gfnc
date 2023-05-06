-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroSkin = class("UIHeroSkin", UIBaseWindow)
local base = UIBaseWindow
local UINHeroSkin = require("Game.Skin.UI.UINHeroSkin")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local JumpManager = require("Game.Jump.JumpManager")
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local ShopEnum = require("Game.Shop.ShopEnum")
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local eMoveDir = {Left = 1, Right = 2}
local waitRecorverNUM = 0
local heroDragScaleLimit = {max = 1.7, min = 0.7}
UIHeroSkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroSkin
  AudioManager:PlayAudioById(1111)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnClickBuy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Equip, self, self.OnClickUse)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Goto, self, self.OnClickGoto)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowCharacter, self, self.OnClickPreview3DSkin)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchLeft, self, self.OnClickLeftSwitch)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchRight, self, self.OnClickRightSwitch)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReturnNormal, self, self.OnClickViewReturn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ViewHero, self, self.OnClickViewHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AVGCharDun, self, self.OnClickAVGCharDun)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AudioList, self, self.OnClickOpenSkinVoice)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BpSkinGift, self, self.OnClickBpSKinGift)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Live2D, self, self.OnChangeLive2dValue)
  self.skinPool = (UIItemPool.New)(UINHeroSkin, (self.ui).skinPreviewItem)
  ;
  ((self.ui).skinPreviewItem):SetActive(false)
  self.__OnClickSkinItem = BindCallback(self, self.OnClickSkinItem)
  self.__OnGesture = BindCallback(self, self.OnGesture)
  self.__RefreshState = BindCallback(self, self.RefreshState)
  self.itemLength = ((((self.ui).skinPreviewItem).transform).sizeDelta).x
  self.oriHeroNodePos = (((self.ui).heroNode).transform).localPosition
  self.oriPicHolderPos = (((self.ui).picHolder).transform).localPosition
  self.oriHeroFadePos = (((self.ui).heroFade).transform).localPosition
  self.__OnUpdateHero = BindCallback(self, self.__UpdateHero)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__OnUpdateHero)
  self.__OnUpdateHeroSkin = BindCallback(self, self.__UpdateHeroSkin)
  MsgCenter:AddListener(eMsgEventId.UpdateHeroSkin, self.__OnUpdateHeroSkin)
  self.__OnPayGiftCondition = BindCallback(self, self.OnPayGiftCondition)
  MsgCenter:AddListener(eMsgEventId.PayGiftItemPreConfition, self.__OnPayGiftCondition)
end

UIHeroSkin.__UpdateHero = function(self, heroUpdate, hasNew)
  -- function num : 0_1
  if hasNew then
    self:RefreshState()
  end
end

UIHeroSkin.__UpdateHeroSkin = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:Refresh()
  for i,skinItem in ipairs((self.skinPool).listItem) do
    skinItem:TryReloadCtify(self.resLoader)
  end
end

UIHeroSkin.OnShow = function(self)
  -- function num : 0_3 , upvalues : _ENV, base
  do
    if self.l2dBinding ~= nil and not IsNull((self.l2dBinding).renderController) then
      local interation = (((self.l2dBinding).renderController).transform):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
      if interation ~= nil then
        interation:RestartBodyAnimation()
      end
    end
    ;
    (base.OnShow)(self)
  end
end

UIHeroSkin.GetHeroId = function(self)
  -- function num : 0_4
  return self.heroId
end

UIHeroSkin.GetCurrentSkinId = function(self)
  -- function num : 0_5
  if self.skinIds == nil then
    return nil
  end
  local skinId = (self.skinIds)[self.curIndex]
  return skinId
end

UIHeroSkin._ResetData = function(self)
  -- function num : 0_6
  self.skinIds = nil
  self.heroId = nil
  self.curIndex = 0
  self.usingIndex = 0
  self.buyCallback = nil
  self.closeCallback = nil
  self.changeCallback = nil
  self.heroDataList = nil
  self._isInPreview = false
  self.heroSwitchIndex = nil
end

UIHeroSkin.InitSkinBySkinList = function(self, skinId, skinIds, buyCallback, closeCallback, isJumpReturn)
  -- function num : 0_7 , upvalues : _ENV
  if not isJumpReturn then
    (UIUtil.SetTopStatus)(self, self.OnReturn)
  end
  self:_ResetData()
  self.__isHeroList = false
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  self.skinIds = {}
  local selectSkinId = nil
  for i,v in ipairs(skinIds) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(v) then
      (table.insert)(self.skinIds, v)
      if v == skinId then
        selectSkinId = skinId
      end
    end
  end
  if selectSkinId == nil then
    selectSkinId = (self.skinIds)[1]
  end
  self.heroId = skinCtr:GetHeroId(selectSkinId)
  self.curIndex = 1
  self.buyCallback = buyCallback
  self.closeCallback = closeCallback
  ;
  (((self.ui).btn_SwitchLeft).gameObject):SetActive(false)
  ;
  (((self.ui).btn_SwitchRight).gameObject):SetActive(false)
  for i,v in ipairs(self.skinIds) do
    if selectSkinId == v then
      self.curIndex = i
    end
  end
  if self.winTween ~= nil then
    (self.winTween):Complete()
  end
  if not isJumpReturn then
    self:InitView()
  end
end

UIHeroSkin.InitSkin = function(self, heroId, changeCallback, heroDataList, closeCallback, isJumpReturn)
  -- function num : 0_8 , upvalues : _ENV
  if not isJumpReturn then
    (UIUtil.SetTopStatus)(self, self.OnReturn)
  end
  self:_ResetData()
  self.__isHeroList = true
  self.heroId = heroId
  self.curIndex = 1
  self.changeCallback = changeCallback
  self.heroDataList = heroDataList
  self.closeCallback = closeCallback
  local usingSkinId = 0
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData ~= nil then
    usingSkinId = heroData.skinId
  end
  local heroCfg = (ConfigData.hero_data)[self.heroId]
  self.skinIds = {heroCfg.default_skin}
  for i,v in ipairs(heroCfg.skin) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(v) then
      (table.insert)(self.skinIds, v)
      if v == usingSkinId then
        self.curIndex = #self.skinIds
      end
    end
  end
  self.usingIndex = self.curIndex
  local hasSwitch = self.heroDataList ~= nil and #self.heroDataList > 1
  if hasSwitch then
    self.heroSwitchIndex = nil
    for i,v in ipairs(self.heroDataList) do
      if v.dataId == self.heroId then
        self.heroSwitchIndex = i
        break
      end
    end
    hasSwitch = self.heroSwitchIndex ~= nil
  end
  ;
  (((self.ui).btn_SwitchLeft).gameObject):SetActive(hasSwitch)
  ;
  (((self.ui).btn_SwitchRight).gameObject):SetActive(hasSwitch)
  if not isJumpReturn then
    self:InitView()
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UIHeroSkin.OnClickLeftSwitch = function(self)
  -- function num : 0_9
  if self._isInPreview then
    return 
  end
  if self.heroSwitchIndex == 1 then
    self.heroSwitchIndex = #self.heroDataList
  else
    self.heroSwitchIndex = self.heroSwitchIndex - 1
  end
  self:RefreShByHeroSwitchIndex()
  if self.changeCallback ~= nil then
    (self.changeCallback)(-1)
  end
end

UIHeroSkin.OnClickRightSwitch = function(self)
  -- function num : 0_10
  if self._isInPreview then
    return 
  end
  if self.heroSwitchIndex == #self.heroDataList then
    self.heroSwitchIndex = 1
  else
    self.heroSwitchIndex = self.heroSwitchIndex + 1
  end
  self:RefreShByHeroSwitchIndex()
  if self.changeCallback ~= nil then
    (self.changeCallback)(1)
  end
end

UIHeroSkin.RefreShByHeroSwitchIndex = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self.heroSwitchIndex == nil then
    return 
  end
  local heroData = (self.heroDataList)[self.heroSwitchIndex]
  local usingSkinId = heroData.skinId
  self.heroId = heroData.dataId
  self.curIndex = 1
  local heroCfg = (ConfigData.hero_data)[self.heroId]
  self.skinIds = {heroCfg.default_skin}
  for i,v in ipairs(heroCfg.skin) do
    if (PlayerDataCenter.skinData):IsSkinUnlocked(v) then
      (table.insert)(self.skinIds, v)
      if v == usingSkinId then
        self.curIndex = #self.skinIds
      end
    end
  end
  self.usingIndex = self.curIndex
  self:InitView()
end

UIHeroSkin.InitView = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
    self._lastThemId = nil
  end
  self.resLoader = ((CS.ResLoader).Create)()
  ;
  (((self.ui).btn_BpSkinGift).gameObject):SetActive(false)
  ;
  (self.skinPool):HideAll()
  ;
  (ControllerManager:GetController(ControllerTypeId.Skin, true))
  local skinCtr = nil
  local item = nil
  for _,skinId in ipairs(self.skinIds) do
    item = (self.skinPool):GetOne(true)
    ;
    (item.gameObject):SetActive(true)
    local skinCfg = (ConfigData.skin)[skinId]
    local heroId = self.heroId
    if skinCfg ~= nil and not skinCtr:GetHeroId(skinId) then
      heroId = self.heroId
    end
    item:InitSkinItem(heroId, skinCfg, self.resLoader, self.__OnClickSkinItem, self.__RefreshState)
    ;
    (item.transform):SetParent(((self.ui).rect_skin).transform)
  end
  for i = 1, #(self.skinPool).listItem do
    item = ((self.skinPool).listItem)[i]
    if i == self.curIndex then
      item:SetSelectState(true)
    else
      item:SetSelectState(false)
    end
  end
  self:SetResourceDisplay()
  self:Refresh()
  self:RefreshHaveCount()
  self:LocationHighLightSkinItem()
end

UIHeroSkin.Refresh = function(self, moveDir)
  -- function num : 0_13 , upvalues : _ENV
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  local resModel = item.resModelCfg
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  self.heroId = (item.heroCfg).id
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R6 in 'UnsetPending'

  if skinCfg ~= nil then
    ((self.ui).tex_Intro).text = (LanguageUtil.GetLocaleText)(skinCfg.describe)
  else
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Intro).text = ""
  end
  if self._lastHeroId ~= self.heroId then
    self._lastHeroId = self.heroId
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((item.heroCfg).name)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_NameEN).text = (LanguageUtil.GetLocaleText)((item.heroCfg).name_en)
  end
  if skinCfg == nil or not skinCfg.theme then
    local themId = (ConfigData.game_config).defaultSkinThemId
  end
  if self._lastThemId ~= themId then
    self._lastThemId = themId
    local skinThemCfg = (ConfigData.skinTheme)[themId]
    if skinThemCfg ~= nil then
      (((self.ui).img_Head).gameObject):SetActive(false)
      ;
      (self.resLoader):LoadABAssetAsync(PathConsts:GetHeroSkinThemePicPath(skinThemCfg.pic), function(Texture)
    -- function num : 0_13_0 , upvalues : _ENV, self
    if Texture == nil or IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Head).texture = Texture
    ;
    (((self.ui).img_Head).gameObject):SetActive(true)
  end
)
    end
  end
  do
    self.isLive2dTogValid = false
    local live2dLevel = item:GetItemLive2dLevel()
    local isL2DRectify = item.isL2DRectify
    local isHaveL2D = (live2dLevel > 0 and not isL2DRectify)
    ;
    (((self.ui).tog_Live2D).gameObject):SetActive(isHaveL2D)
    if skinCfg == nil or not skinCfg.id then
      do
        local isOpen = (PlayerDataCenter.skinData):GetLive2dSwitchState((item.heroCfg).id, not isHaveL2D or 0)
        -- DECOMPILER ERROR at PC113: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((self.ui).tog_Live2D).isOn = isOpen
        if isOpen then
          ((self.ui).ani_Tog):DORewind()
        else
          ((self.ui).ani_Tog):DOComplete()
        end
        self.isLive2dTogValid = true
        if live2dLevel == 2 then
          ((self.ui).tex_Live2D):SetIndex(1)
        else
          ((self.ui).tex_Live2D):SetIndex(0)
        end
        self:LoadViewRes(moveDir)
        self:RefreshState()
        -- DECOMPILER ERROR: 8 unprocessed JMP targets
      end
    end
  end
end

UIHeroSkin.SetResourceDisplay = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local ids = nil
  for i,v in ipairs((self.skinPool).listItem) do
    if v.shopGoodsData ~= nil and (ids == nil or not (table.contain)(ids, (v.shopGoodsData).currencyId)) then
      if not ids then
        ids = {}
      end
      ;
      (table.insert)(ids, (v.shopGoodsData).currencyId)
      if (v.shopGoodsData).currencyId == ConstGlobalItem.PaidSubItem and not (table.contain)(ids, ConstGlobalItem.PaidItem) then
        (table.insert)(ids, ConstGlobalItem.PaidItem)
      end
    end
  end
  if ids ~= nil then
    (table.sort)(ids, function(a, b)
    -- function num : 0_14_0
    do return a < b end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
  ;
  (UIUtil.RefreshTopResId)(ids)
end

UIHeroSkin.RefreshState = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (((self.ui).btn_Buy).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Equip).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Goto).gameObject):SetActive(false)
  ;
  ((self.ui).obj_Equipped):SetActive(false)
  local couldShow3DSkin = not BattleDungeonManager:InBattleDungeon()
  ;
  (((self.ui).btn_ShowCharacter).gameObject):SetActive(couldShow3DSkin)
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  local isHave = (skinCfg == nil or not skinCfg.isdefault_skin) and (PlayerDataCenter.skinData):IsHaveSkin(skinCfg.id)
  local bpSkinGift = item:GetSkinBpGiftId()
  self:__RefreshBpSkinGift(bpSkinGift)
  ;
  (((self.ui).btn_AVGCharDun).gameObject):SetActive((not (string.IsNullOrEmpty)(skinCfg.skin_avg) and isHave))
  if skinCfg.has_voice and isHave then
    (((self.ui).btn_AudioList).gameObject):SetActive(self.__isHeroList)
    -- DECOMPILER ERROR at PC96: Unhandled construct in 'MakeBoolean' P1

    if self.__isHeroList and self.usingIndex ~= nil and self.curIndex == self.usingIndex then
      ((self.ui).obj_Equipped):SetActive(true)
      ;
      ((self.ui).tex_EquipInfo):SetIndex(0)
      return 
    end
    if isHave and skinCfg ~= nil then
      local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
      local heroId = skinCtrl:GetHeroId(skinCfg.id)
      if heroId == nil or (PlayerDataCenter.heroDic)[heroId] == nil then
        ((self.ui).obj_Equipped):SetActive(true)
        ;
        ((self.ui).tex_EquipInfo):SetIndex(1)
        return 
      end
      local heroData = (PlayerDataCenter.heroDic)[heroId]
      if heroData.skinId == skinCfg.id then
        ((self.ui).obj_Equipped):SetActive(true)
        ;
        ((self.ui).tex_EquipInfo):SetIndex(0)
        return 
      end
    end
    if isHave then
      (((self.ui).btn_Equip).gameObject):SetActive(true)
      ;
      ((self.ui).obj_Equipped):SetActive(false)
      return 
    end
    local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
    local flag, condition = skinCtr:CheckSourceValid(skinCfg.id)
    if flag then
      if item.shopGoodsData ~= nil then
        (((self.ui).btn_Buy).gameObject):SetActive(true)
        local priceItem = (ConfigData.item)[(item.shopGoodsData).currencyId]
        -- DECOMPILER ERROR at PC198: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.ui).img_Price).sprite = CRH:GetSprite(priceItem.small_icon)
        -- DECOMPILER ERROR at PC205: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.ui).tex_Price).text = tostring((item.shopGoodsData).newCurrencyNum)
      elseif condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active or skinCfg.jumpId ~= nil and skinCfg.jumpId > 0 then
        (((self.ui).btn_Goto).gameObject):SetActive(true)
        if condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active then
          local actFrameData = skinCtr:GetActFrameDataBySkinCfg(skinCfg)
          if actFrameData ~= nil then
            ((self.ui).text_goto):SetIndex(1, actFrameData.name)
          else
            ((self.ui).text_goto):SetIndex(0)
          end
        else
          ((self.ui).text_goto):SetIndex(0)
        end
      elseif condition == proto_csmsg_SystemFunctionID.SystemFunctionID_HeroRank then
        ((self.ui).obj_Equipped):SetActive(true)
        ;
        ((self.ui).tex_EquipInfo):SetIndex(3)
      elseif condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Gift then
        (((self.ui).btn_Goto).gameObject):SetActive(true)
        ;
        ((self.ui).text_goto):SetIndex(2)
      else
        ((self.ui).obj_Equipped):SetActive(true)
        ;
        ((self.ui).tex_EquipInfo):SetIndex(2)
      end
    else
      ((self.ui).obj_Equipped):SetActive(true)
      ;
      ((self.ui).tex_EquipInfo):SetIndex(2)
    end
    -- DECOMPILER ERROR: 19 unprocessed JMP targets
  end
end

UIHeroSkin.LoadViewRes = function(self, moveDir)
  -- function num : 0_16 , upvalues : _ENV, HeroCubismInteration, eMoveDir
  if self._heroNodeTween ~= nil then
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
  end
  if self.moveSeq ~= nil then
    (self.moveSeq):Kill(true)
    self.moveSeq = nil
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).heroNode).transform).localPosition = self.oriHeroNodePos
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).picHolder).transform).localPosition = self.oriPicHolderPos
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).heroFade).transform).localPosition = self.oriHeroFadePos
  self._isInPreview = false
  local item = ((self.skinPool).listItem)[self.curIndex]
  local resModel = item.resModelCfg
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
    self.l2dModelIns = nil
    self.l2dBinding = nil
  end
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  local curMoveDir = nil
  curMoveDir = moveDir == nil and eMoveDir.Right or moveDir
  local resPath = PathConsts:GetCharacterLive2DPath(resModel.src_id_pic)
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  self.l2dBinding = nil
  local live2dLevel = item:GetItemLive2dLevel()
  local isL2DRectify = item.isL2DRectify
  local isHaveL2D = (live2dLevel > 0 and not isL2DRectify)
  if isHaveL2D then
    if ((self.ui).tog_Live2D).isOn then
      self:__LoadLive2D(resPath, curMoveDir)
    else
      self:__LoadPic(PathConsts:GetCharacterBigImgPrefabPath(resModel.src_id_pic), curMoveDir)
    end
  else
    self:__LoadPic(PathConsts:GetCharacterBigImgPrefabPath(resModel.src_id_pic), curMoveDir)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UIHeroSkin.__LoadLive2D = function(self, path, curMoveDir)
  -- function num : 0_17 , upvalues : _ENV, HeroCubismInteration
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).heroFade).alpha = 0
  self.Live2DResloader = ((CS.ResLoader).Create)()
  ;
  (self.Live2DResloader):LoadABAssetAsync(path, function(l2dModelAsset)
    -- function num : 0_17_0 , upvalues : _ENV, self, HeroCubismInteration, curMoveDir
    if IsNull(self.transform) or IsNull(l2dModelAsset) then
      return 
    end
    self.l2dModelIns = l2dModelAsset:Instantiate(((self.ui).heroFade).transform)
    ;
    ((self.l2dModelIns).transform):SetLayer(LayerMask.UI)
    local cs_CubismInterationController = ((self.l2dModelIns).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    if cs_CubismInterationController ~= nil then
      self.heroCubismInteration = (HeroCubismInteration.New)()
      local heroId = self.heroId
      local skinId = (self.skinIds)[self.curIndex]
      ;
      (self.heroCubismInteration):InitHeroCubism(cs_CubismInterationController, heroId, skinId, UIManager:GetUICamera(), false)
      ;
      (self.heroCubismInteration):SetInterationOpenWait(false)
      ;
      (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
      ;
      (self.heroCubismInteration):SetRenderControllerSetting(self:GetWindowSortingLayer(), (self.ui).heroFade, 1, true)
      ;
      (self.heroCubismInteration):SetL2DPosType("HeroSkin", false)
    end
    do
      self.l2dBinding = {}
      ;
      (UIUtil.LuaUIBindingTable)(self.l2dModelIns, self.l2dBinding)
      self:_MoveHeroHolderTween((self.ui).heroFade, curMoveDir)
    end
  end
)
end

UIHeroSkin.__LoadPic = function(self, path, curMoveDir)
  -- function num : 0_18 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).picFade).alpha = 0
  self.bigImgResloader = ((CS.ResLoader).Create)()
  ;
  (self.bigImgResloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_18_0 , upvalues : _ENV, self, curMoveDir
    if IsNull(prefab) or IsNull(self.transform) then
      return 
    end
    self.bigImgGameObject = prefab:Instantiate(((self.ui).picHolder).transform)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
    self:_MoveHeroHolderTween((self.ui).picFade, curMoveDir)
  end
)
end

UIHeroSkin.RefreshHaveCount = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local countMax = #(self.skinPool).listItem
  local countHave = 0
  for _,item in pairs((self.skinPool).listItem) do
    if item.skinCfg == nil or (item.skinCfg).isdefault_skin or (PlayerDataCenter.skinData):IsHaveSkin((item.skinCfg).id) then
      countHave = countHave + 1
    end
  end
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_HasCount).text = tostring(countHave) .. "/" .. tostring(countMax)
end

UIHeroSkin.OnClickLeft = function(self)
  -- function num : 0_20 , upvalues : eMoveDir
  if self.curIndex > 1 then
    self:SetItemChange(-1)
    self:Refresh(eMoveDir.Left)
  end
end

UIHeroSkin.OnClickRight = function(self)
  -- function num : 0_21 , upvalues : eMoveDir
  if self.curIndex < #(self.skinPool).listItem then
    self:SetItemChange(1)
    self:Refresh(eMoveDir.Right)
  end
end

UIHeroSkin.OnClickSkinItem = function(self, item)
  -- function num : 0_22 , upvalues : _ENV
  if self.draging then
    return 
  end
  local index = self:_GetIndexByItem(item)
  do
    if index or self.curIndex ~= self.curIndex then
      local diff = index - self.curIndex
      self:SetItemChange(diff)
      self:Refresh(diff > 0)
      AudioManager:PlayAudioById(1111)
    end
    self:LocationHighLightSkinItem()
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIHeroSkin.LocationHighLightSkinItem = function(self)
  -- function num : 0_23 , upvalues : _ENV
  (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
  local scrollWidth = ((((self.ui).skinScroll).transform).rect).width
  local rectWidth = ((((self.ui).skinScroll).content).rect).width
  local overRectIndex = (math.floor)(scrollWidth / (rectWidth / #(self.skinPool).listItem))
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  if self.curIndex <= overRectIndex then
    ((self.ui).skinScroll).horizontalNormalizedPosition = 0
  else
    local allOverCount = #(self.skinPool).listItem - overRectIndex
    local overCount = self.curIndex - overRectIndex
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).skinScroll).horizontalNormalizedPosition = overCount / allOverCount
  end
end

UIHeroSkin.OnClickBuy = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self._isInPreview then
    return 
  end
  local item = ((self.skinPool).listItem)[self.curIndex]
  local shopGoodsData = item.shopGoodsData
  local resIds = {}
  ;
  (table.insert)(resIds, shopGoodsData.currencyId)
  if not (table.contain)(resIds, ConstGlobalItem.PaidItem) and (shopGoodsData.currencyId == ConstGlobalItem.PaidSubItem or shopGoodsData.currencyId == ConstGlobalItem.SkinTicket) then
    (table.insert)(resIds, 1, ConstGlobalItem.PaidItem)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_24_0 , upvalues : shopGoodsData, resIds, _ENV, self
    window:SlideIn()
    window:InitBuyFixedCountGood(1, shopGoodsData, true, resIds, function()
      -- function num : 0_24_0_0 , upvalues : _ENV, self, shopGoodsData
      for _,skinItem in ipairs((self.skinPool).listItem) do
        local shopId, shelfId = skinItem:TryGetShopGoodsId()
        if shopId == shopGoodsData.shopId and shelfId == shopGoodsData.shelfId then
          skinItem:Refresh()
          break
        end
      end
      do
        self:RefreshState()
        self:RefreshHaveCount()
        if self.buyCallback ~= nil then
          (self.buyCallback)()
        end
      end
    end
)
  end
)
end

UIHeroSkin.OnClickPreview3DSkin = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local showCharacterSkinCtrl = ControllerManager:GetController(ControllerTypeId.ShowCharacterSkin, true)
  local heroId = self:GetHeroId()
  local skinId = self:GetCurrentSkinId()
  showCharacterSkinCtrl:InitShowCharacterSkinCtrl(heroId, skinId, nil, nil)
end

UIHeroSkin.OnClickGoto = function(self)
  -- function num : 0_26 , upvalues : _ENV, JumpManager
  if self._isInPreview then
    return 
  end
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  if skinCfg.jumpId or 0 == 0 and (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active] ~= nil then
    local actData = skinCtrl:GetActFrameDataBySkinCfg(skinCfg)
    if actData ~= nil then
      local frameId = actData:GetActivityFrameId()
      JumpManager:Jump((JumpManager.eJumpTarget).DynActivity, nil, nil, {frameId})
    end
  else
    do
      if (skinCfg.conditionParamDic)[proto_csmsg_SystemFunctionID.SystemFunctionID_Gift] ~= nil then
        local giftInfo = skinCtrl:GetGiftBySkinCfg(skinCfg)
        if giftInfo ~= nil then
          JumpManager:Jump((JumpManager.eJumpTarget).DynShop, nil, nil, {((ConfigData.pay_gift_type)[(skinCfg.condition_para)[1]]).inShop, (skinCfg.condition_para)[1]})
        end
      else
        do
          JumpManager:Jump(skinCfg.jumpId)
        end
      end
    end
  end
end

UIHeroSkin.OnClickUse = function(self)
  -- function num : 0_27 , upvalues : _ENV
  if self._isInPreview then
    return 
  end
  if self.curIndex == self.usingIndex then
    return 
  end
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  local callback = BindCallback(self, self.ClickHeroSkinUseCallback)
  local skinCtrl = ControllerManager:GetController(ControllerTypeId.Skin, true)
  skinCtrl:HeroSkinChange(self.heroId, skinCfg, callback)
end

UIHeroSkin.ClickHeroSkinUseCallback = function(self)
  -- function num : 0_28
  self.usingIndex = self.curIndex
  self:RefreshState()
end

UIHeroSkin.OnChangeLive2dValue = function(self, flag)
  -- function num : 0_29 , upvalues : _ENV
  if self._isInPreview then
    return 
  end
  if not self.isLive2dTogValid then
    return 
  end
  local item = ((self.skinPool).listItem)[self.curIndex]
  ;
  (PlayerDataCenter.skinData):RecordLive2dSwitchState((item.heroCfg).id, item.skinCfg ~= nil and (item.skinCfg).id or 0, flag)
  self:LoadViewRes()
  if flag then
    ((self.ui).ani_Tog):DOPlayBackwards()
  else
    ;
    ((self.ui).ani_Tog):DOPlayForward()
  end
end

UIHeroSkin.OnClickViewHero = function(self)
  -- function num : 0_30 , upvalues : _ENV, CS_LeanTouch
  if self._isInPreview then
    return 
  end
  self._isInPreview = true
  ;
  ((self.ui).normalNode):SetActive(false)
  ;
  ((self.ui).viewNode):SetActive(true)
  AudioManager:PlayAudioById(1061)
  ;
  (UIUtil.HideTopStatus)()
  if self._heroNodeTween ~= nil then
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
  end
  self:CalcaluteDragLimit()
  self._heroNodeTween = (((self.ui).heroNode).transform):DOLocalMove((Vector3.New)(0, 0, 0), 0.5)
  ;
  (self._heroNodeTween):OnComplete(function()
    -- function num : 0_30_0 , upvalues : self
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
  end
)
  ;
  (CS_LeanTouch.OnGesture)("+", self.__OnGesture)
end

UIHeroSkin.OnClickViewReturn = function(self)
  -- function num : 0_31 , upvalues : _ENV, cs_DoTween, CS_LeanTouch
  ((self.ui).normalNode):SetActive(true)
  ;
  ((self.ui).viewNode):SetActive(false)
  AudioManager:PlayAudioById(1111)
  ;
  (UIUtil.ReShowTopStatus)()
  if self._heroNodeTween ~= nil then
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
  end
  self._heroNodeTween = (cs_DoTween.Sequence)()
  ;
  (self._heroNodeTween):Insert(0, (((self.ui).heroNode).transform):DOLocalMove(self.oriHeroNodePos, 0.5))
  ;
  (self._heroNodeTween):Insert(0, (((self.ui).picHolder).transform):DOLocalMove(self.oriPicHolderPos, 0.5))
  ;
  (self._heroNodeTween):Insert(0, (((self.ui).heroFade).transform):DOLocalMove(self.oriHeroFadePos, 0.5))
  ;
  (self._heroNodeTween):Insert(0, (((self.ui).picHolder).transform):DOScale((Vector3.New)(1, 1, 1), 0.5))
  ;
  (self._heroNodeTween):Insert(0, (((self.ui).heroFade).transform):DOScale((Vector3.New)(1, 1, 1), 0.5))
  ;
  (self._heroNodeTween):OnComplete(function()
    -- function num : 0_31_0 , upvalues : self
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
    self._isInPreview = false
  end
)
  ;
  (CS_LeanTouch.OnGesture)("-", self.__OnGesture)
end

UIHeroSkin.OnClickAVGCharDun = function(self)
  -- function num : 0_32 , upvalues : _ENV
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  if not (string.IsNullOrEmpty)(skinCfg.skin_avg) then
    (ControllerManager:GetController(ControllerTypeId.Avg, true)):ShowAvg(skinCfg.skin_avg, showWindowFunc)
  end
end

UIHeroSkin.OnClickOpenSkinVoice = function(self)
  -- function num : 0_33 , upvalues : _ENV
  local item = ((self.skinPool).listItem)[self.curIndex]
  local skinCfg = item.skinCfg
  if skinCfg.has_voice then
    (UIUtil.OnClickBackByUiTab)(self)
    local heroStateWindow = UIManager:GetWindow(UIWindowTypeID.HeroState)
    heroStateWindow:OpenHeroInformation(function(window)
    -- function num : 0_33_0 , upvalues : skinCfg
    if window ~= nil then
      window:SwitchTog((window.eNodeType).voice)
      local voiceNode = (window.nodeDic)[(window.eNodeType).voice]
      local skinId = skinCfg.id
      local index = voiceNode:GetSkinVoiceIndexBySkinId(skinId)
      voiceNode:SelectSkinVoice(skinId, index)
    end
  end
)
  end
end

UIHeroSkin.OnPayGiftCondition = function(self)
  -- function num : 0_34
  if self._bpGiftId == nil or self._bpGiftId == 0 then
    return 
  end
  self:__RefreshBpSkinGift(self._bpGiftId)
end

UIHeroSkin.__RefreshBpSkinGift = function(self, bpSkinGift)
  -- function num : 0_35 , upvalues : _ENV
  local showBpGift = false
  self._bpGiftId = 0
  if bpSkinGift > 0 then
    local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
    if payGiftCtrl ~= nil then
      local giftInfo = payGiftCtrl:GetPayGiftDataById(bpSkinGift)
      if giftInfo ~= nil and giftInfo:IsUnlock() then
        showBpGift = true
        self._bpGiftId = bpSkinGift
      end
    end
  end
  do
    ;
    (((self.ui).btn_BpSkinGift).gameObject):SetActive(showBpGift)
  end
end

UIHeroSkin.OnClickBpSKinGift = function(self)
  -- function num : 0_36 , upvalues : _ENV
  if self._bpGiftId == nil then
    return 
  end
  local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift)
  if payGiftCtrl == nil then
    return 
  end
  local giftInfo = payGiftCtrl:GetPayGiftDataById(self._bpGiftId)
  if giftInfo ~= nil and giftInfo:IsUnlock() then
    UIManager:ShowWindowAsync(UIWindowTypeID.QuickBuy, function(window)
    -- function num : 0_36_0 , upvalues : giftInfo
    window:SlideIn()
    window:InitBuyPayGift(giftInfo)
  end
)
  end
end

UIHeroSkin.CalcaluteDragLimit = function(self, isInDrag)
  -- function num : 0_37 , upvalues : _ENV
  if not IsNull(self.bigImgGameObject) then
    if isInDrag and self._viewScaleRecord == ((((self.ui).picHolder).transform).localScale).y then
      return 
    end
    self._viewScaleRecord = ((((self.ui).picHolder).transform).localScale).y
    do
      if not isInDrag or self._bigImgGameObjectHeight == nil then
        local rectTr = (self.bigImgGameObject).transform
        self._bigImgGameObjectHeight = (rectTr.rect).height * (rectTr.localScale).y
        self._bigImgGameObjectWidth = (rectTr.rect).width * (rectTr.localScale).x
      end
      local limitYMin = (-self._bigImgGameObjectHeight / 2 - (((self.bigImgGameObject).transform).localPosition).y) * self._viewScaleRecord
      local limitYMax = (self._bigImgGameObjectHeight / 2 - (((self.bigImgGameObject).transform).localPosition).y) * self._viewScaleRecord
      local limitXMax = (self._bigImgGameObjectWidth / 2 - (((self.bigImgGameObject).transform).localPosition).x) * self._viewScaleRecord
      do
        local limitXMin = (-self._bigImgGameObjectWidth / 2 - (((self.bigImgGameObject).transform).localPosition).x) * self._viewScaleRecord
        if self._heroDragPosLimit == nil then
          self._heroDragPosLimit = {}
        end
        -- DECOMPILER ERROR at PC85: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._heroDragPosLimit).xMin = limitXMin
        -- DECOMPILER ERROR at PC87: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._heroDragPosLimit).xMax = limitXMax
        -- DECOMPILER ERROR at PC89: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._heroDragPosLimit).yMax = limitYMax
        -- DECOMPILER ERROR at PC91: Confused about usage of register: R6 in 'UnsetPending'

        ;
        (self._heroDragPosLimit).yMin = limitYMin
        if not IsNull(self.l2dBinding) then
          if isInDrag and self._viewScaleRecord == ((((self.ui).heroFade).transform).localScale).y then
            return 
          end
          self._viewScaleRecord = ((((self.ui).heroFade).transform).localScale).y
          if not isInDrag or self._l2dModelHeight == nil then
            local leftUp, rightBottom = GetL2dBorderVec(self.l2dModelIns)
            local inverseleftUp = ((self.l2dModelIns).transform):TransformPoint(leftUp)
            inverseleftUp = (((self.ui).heroFade).transform):InverseTransformPoint(inverseleftUp)
            local inverserightBottom = ((self.l2dModelIns).transform):TransformPoint(rightBottom)
            inverserightBottom = ((((self.ui).heroFade).transform).parent):InverseTransformPoint(inverserightBottom)
            self._l2dModelHeight = inverseleftUp.y - inverserightBottom.y
            self._l2dModelWidth = inverserightBottom.x - inverseleftUp.x
            self._l2dCenterRatio = (Vector2.New)(-leftUp.x / (rightBottom.x - leftUp.x), leftUp.y / (leftUp.y - rightBottom.y))
          end
          do
            local limitYMin = (-self._l2dModelHeight * (self._l2dCenterRatio).y - (((self.l2dModelIns).transform).localPosition).y) * self._viewScaleRecord
            local limitYMax = (self._l2dModelHeight * (1 - (self._l2dCenterRatio).y) - (((self.l2dModelIns).transform).localPosition).y) * self._viewScaleRecord
            local limitXMax = (self._l2dModelWidth * (self._l2dCenterRatio).x - (((self.l2dModelIns).transform).localPosition).x) * self._viewScaleRecord
            local limitXMin = (-self._l2dModelWidth * (1 - (self._l2dCenterRatio).x) - (((self.l2dModelIns).transform).localPosition).x) * self._viewScaleRecord
            if self._heroDragPosLimit == nil then
              self._heroDragPosLimit = {}
            end
            -- DECOMPILER ERROR at PC225: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (self._heroDragPosLimit).xMin = limitXMin
            -- DECOMPILER ERROR at PC227: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (self._heroDragPosLimit).xMax = limitXMax
            -- DECOMPILER ERROR at PC229: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (self._heroDragPosLimit).yMax = limitYMax
            -- DECOMPILER ERROR at PC231: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (self._heroDragPosLimit).yMin = limitYMin
          end
        end
      end
    end
  end
end

UIHeroSkin.LimitDragPos = function(self, targetPos)
  -- function num : 0_38 , upvalues : _ENV
  targetPos.x = (math.clamp)(targetPos.x, (self._heroDragPosLimit).xMin, (self._heroDragPosLimit).xMax)
  targetPos.y = (math.clamp)(targetPos.y, (self._heroDragPosLimit).yMin, (self._heroDragPosLimit).yMax)
end

UIHeroSkin.OnReturn = function(self)
  -- function num : 0_39 , upvalues : waitRecorverNUM
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self.l2dBinding ~= nil then
    ((self.l2dBinding).renderController).uiCanvasGroup = (self.ui).canvasGroup
  end
  ;
  ((self.ui).frameAni):DOPlayBackwards()
  if waitRecorverNUM > 0 then
    self:Hide()
  else
    self:OnCloseWin()
    self:Delete()
  end
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
end

UIHeroSkin.SetItemChange = function(self, num)
  -- function num : 0_40
  (((self.skinPool).listItem)[self.curIndex]):SetSelectState(false)
  self.curIndex = self.curIndex + num
  ;
  (((self.skinPool).listItem)[self.curIndex]):SetSelectState(true)
end

UIHeroSkin._GetIndexByItem = function(self, item)
  -- function num : 0_41 , upvalues : _ENV
  local index = nil
  for i,v in ipairs((self.skinPool).listItem) do
    if v == item then
      return i
    end
  end
  return nil
end

UIHeroSkin._RefreshCol = function(self, heroId)
  -- function num : 0_42 , upvalues : _ENV
  local rare = 1
  if (PlayerDataCenter.heroDic)[heroId] ~= nil then
    rare = ((PlayerDataCenter.heroDic)[heroId]).rare
  else
    local heroCfg = (ConfigData.hero_data)[heroId]
    local rankCfg = (ConfigData.hero_rank)[heroCfg.rank]
    rare = rankCfg.rare
  end
  do
    self:_RefreshColsTween(HeroRareColor[rare])
  end
end

UIHeroSkin._RefreshColsTween = function(self, endColor)
  -- function num : 0_43 , upvalues : _ENV, cs_DoTween
  if self.endColor == nil then
    self.endColor = endColor
    for index,image in ipairs((self.ui).arr_cols) do
      image.color = endColor
    end
  else
    do
      if self.cloSeq ~= nil then
        (self.cloSeq):Kill()
        self.cloSeq = nil
      end
      local cloSeq = (cs_DoTween.Sequence)()
      for index,image in ipairs((self.ui).arr_cols) do
        cloSeq:Insert(0, image:DOColor(endColor, 0.3))
      end
      self.cloSeq = cloSeq
    end
  end
end

UIHeroSkin._MoveHeroHolderTween = function(self, canvasGroup, curMoveDir)
  -- function num : 0_44 , upvalues : cs_DoTween, eMoveDir, _ENV
  if self.moveSeq ~= nil then
    (self.moveSeq):Kill(true)
    self.moveSeq = nil
  end
  local moveSeq = (cs_DoTween.Sequence)()
  moveSeq:Append(canvasGroup:DOFade(1, 0.35))
  local transform = canvasGroup.transform
  local pos = transform.localPosition
  local moveX = 404
  if curMoveDir == eMoveDir.Left then
    transform.localPosition = (Vector3.New)(pos.x - moveX, pos.y, pos.z)
    moveSeq:Join(((canvasGroup.transform):DOLocalMoveX(moveX, 0.45)):SetRelative(true))
  else
    transform.localPosition = (Vector3.New)(pos.x + moveX, pos.y, pos.z)
    moveSeq:Join(((canvasGroup.transform):DOLocalMoveX(-moveX, 0.45)):SetRelative(true))
  end
  self.moveSeq = moveSeq
end

UIHeroSkin.OnGesture = function(self, fingerList)
  -- function num : 0_45 , upvalues : CS_LeanTouch, _ENV, heroDragScaleLimit
  if fingerList.Count == 0 then
    return 
  end
  local result = (CS_LeanTouch.RaycastGui)((fingerList[0]).ScreenPosition)
  if result.Count == 0 or not (((result[0]).gameObject).transform):IsChildOf(self.transform) then
    return 
  end
  if self._heroNodeTween ~= nil then
    return 
  end
  if fingerList.Count == 1 then
    local touch = fingerList[0]
    local lastPos = UIManager:Screen2UIPosition(touch.LastScreenPosition, ((self.transform).gameObject):GetComponent(typeof((CS.UnityEngine).RectTransform)), UIManager.UICamera)
    local curPos = UIManager:Screen2UIPosition(touch.ScreenPosition, ((self.transform).gameObject):GetComponent(typeof((CS.UnityEngine).RectTransform)), UIManager.UICamera)
    local diffPos = curPos - lastPos
    diffPos = (Vector3.New)(diffPos.x, diffPos.y, 0)
    local targetPos = (((self.ui).picHolder).transform).localPosition + diffPos
    self:LimitDragPos(targetPos)
    -- DECOMPILER ERROR at PC77: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).picHolder).transform).localPosition = targetPos
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (((self.ui).heroFade).transform).localPosition = targetPos
  else
    do
      if fingerList.Count == 2 then
        local touch1 = fingerList[0]
        local touch2 = fingerList[1]
        local lastDiffX = (touch1.LastScreenPosition).x - (touch2.LastScreenPosition).x
        local lastDiffY = (touch1.LastScreenPosition).y - (touch2.LastScreenPosition).y
        local curDiffX = (touch1.ScreenPosition).x - (touch2.ScreenPosition).x
        local curDiffY = (touch1.ScreenPosition).y - (touch2.ScreenPosition).y
        local diff = (Mathf.Sqrt)((Mathf.Pow)(curDiffX, 2) + (Mathf.Pow)(curDiffY, 2)) - (Mathf.Sqrt)((Mathf.Pow)(lastDiffX, 2) + (Mathf.Pow)(lastDiffY, 2))
        local scale = ((((self.ui).picHolder).transform).localScale).x + diff / 500 * (heroDragScaleLimit.max - heroDragScaleLimit.min)
        scale = (math.clamp)(scale, heroDragScaleLimit.min, heroDragScaleLimit.max)
        -- DECOMPILER ERROR at PC164: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (((self.ui).picHolder).transform).localScale = (Vector3.New)(scale, scale, scale)
        -- DECOMPILER ERROR at PC174: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (((self.ui).heroFade).transform).localScale = (Vector3.New)(scale, scale, scale)
        self:CalcaluteDragLimit(true)
        local targetPos = (((self.ui).picHolder).transform).localPosition
        self:LimitDragPos(targetPos)
        -- DECOMPILER ERROR at PC188: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (((self.ui).picHolder).transform).localPosition = targetPos
        -- DECOMPILER ERROR at PC192: Confused about usage of register: R12 in 'UnsetPending'

        ;
        (((self.ui).heroFade).transform).localPosition = targetPos
      end
    end
  end
end

UIHeroSkin.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_46 , upvalues : _ENV, HeroCubismInteration, waitRecorverNUM
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  self.bigImgGameObject = nil
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
  end
  self.l2dModelIns = nil
  self.l2dBinding = nil
  local dataTable = {}
  for key,value in pairs(self) do
    dataTable[key] = value
  end
  waitRecorverNUM = waitRecorverNUM + 1
  return function()
    -- function num : 0_46_0 , upvalues : self, _ENV, dataTable, waitRecorverNUM
    self:_ResetData()
    for key,value in pairs(dataTable) do
      self[key] = value
    end
    if self.__isHeroList then
      self:InitSkin(self.heroId, self.changeCallback, self.heroDataList, self.closeCallback, true)
    else
      self:InitSkinBySkinList(nil, self.skinIds, self.buyCallback, self.closeCallback, true)
    end
    self.curIndex = dataTable.curIndex
    self:Show()
    self:InitView()
    waitRecorverNUM = waitRecorverNUM - 1
  end

end

UIHeroSkin.OnDelete = function(self)
  -- function num : 0_47 , upvalues : _ENV, CS_LeanTouch, HeroCubismInteration, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__OnUpdateHero)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHeroSkin, self.__OnUpdateHeroSkin)
  MsgCenter:RemoveListener(eMsgEventId.PayGiftItemPreConfition, self.__OnPayGiftCondition)
  if self.pageSequence ~= nil then
    (self.pageSequence):Kill(true)
    self.pageSequence = nil
  end
  if self.cloSeq ~= nil then
    (self.cloSeq):Kill()
    self.cloSeq = nil
  end
  if self.moveSeq ~= nil then
    (self.moveSeq):Kill()
    self.moveSeq = nil
  end
  if self._heroNodeTween ~= nil then
    (self._heroNodeTween):Kill()
    self._heroNodeTween = nil
  end
  ;
  ((self.ui).frameAni):DOKill()
  if self._isInPreview then
    self._isInPreview = false
    ;
    (CS_LeanTouch.OnGesture)("-", self.__OnGesture)
  end
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
    self.l2dModelIns = nil
    self.l2dBinding = nil
  end
  ;
  (base.OnDelete)(self)
end

UIHeroSkin.OnDeleteEntity = function(self)
  -- function num : 0_48 , upvalues : CS_LeanTouch, base
  if self._isInPreview then
    self._isInPreview = false
    ;
    (CS_LeanTouch.OnGesture)("-", self.__OnGesture)
  end
  ;
  (self.resLoader):Put2Pool()
  self.resLoader = nil
  if self.Live2DResloader ~= nil then
    (self.Live2DResloader):Put2Pool()
    self.Live2DResloader = nil
    self.l2dBinding = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  ;
  (self.skinPool):DeleteAll()
  ;
  (base.OnDeleteEntity)(self)
end

UIHeroSkin.OnHide = function(self)
  -- function num : 0_49 , upvalues : _ENV, HeroCubismInteration, base
  if not IsNull(self.bigImgGameObject) then
    DestroyUnityObject(self.bigImgGameObject)
  end
  if not IsNull(self.l2dModelIns) then
    (HeroCubismInteration.DestroyInterationInstance)(self.l2dModelIns)
    self.l2dModelIns = nil
    self.l2dBinding = nil
  end
  ;
  (base.OnHide)(self)
end

return UIHeroSkin

