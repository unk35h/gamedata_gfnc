-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeShop = class("UINRecommeShop", UIBaseNode)
local base = UIBaseNode
local UINRecommeShopPicItem = require("Game.ShopMain.UINRecommeShopPicItem")
local UINRecommeShopLoopPicItem = require("Game.ShopMain.UINRecommeShopLoopPicItem")
local UINRecommeShopLoopPicItemMid = require("Game.ShopMain.UINRecommeShopLoopPicItemMid")
local ShopEnum = require("Game.Shop.ShopEnum")
local cs_ResLoader = CS.ResLoader
local HeroCubismInteration = require("Game.Hero.Live2D.HeroCubismInteration")
local HeroLookTargetController = require("Game.Hero.Live2D.HeroLookTargetController")
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
local rikoSheetName = "VO_riko"
local rikoModelName = "riko_avg"
UINRecommeShop.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINRecommeShopLoopPicItem, UINRecommeShopLoopPicItemMid, UINRecommeShopPicItem, ConditionListener
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.bigLoopPic = (UINRecommeShopLoopPicItem.New)()
  ;
  (self.bigLoopPic):Init((self.ui).bigBannerScroll)
  ;
  (self.bigLoopPic):RecShopLoopPicInit(self.resloader)
  self.midLoopPic = (UINRecommeShopLoopPicItemMid.New)()
  ;
  (self.midLoopPic):Init((self.ui).midBannerScroll)
  ;
  (self.midLoopPic):RecShopLoopPicInit(self.resloader)
  self.smallPicItem = (UINRecommeShopPicItem.New)()
  ;
  (self.smallPicItem):Init((self.ui).small)
  self.singlePicItem = (UINRecommeShopPicItem.New)()
  ;
  (self.singlePicItem):Init((self.ui).singleBanner)
  self.__conditionListener = (ConditionListener.New)()
  self.__addedRecommendIdDic = {}
  self.lastDialogIndex = 0
  self.__getSouldOutItem = BindCallback(self, self.__GetSouldOutItem)
  self.__recycleSouldOutItem = BindCallback(self, self.__RecycleSouldOutItem)
  self.__RefreshAllIsSouldOut = BindCallback(self, self.RefreshAllIsSouldOut)
  self.___OnRecommeBannerImageConditonChange = BindCallback(self, self._OnRecommeBannerImageConditonChange)
  self.souldOutPool = (UIItemPool.New)(UIBaseNode, (self.ui).obj_soldOut)
  ;
  ((self.ui).obj_soldOut):SetActive(false)
  MsgCenter:AddListener(eMsgEventId.PayGiftChange, self.__RefreshAllIsSouldOut)
  self.__timerId = nil
end

UINRecommeShop.OnShow = function(self)
  -- function num : 0_1 , upvalues : cs_ResLoader, _ENV, rikoModelName
  if self.resloader == nil then
    self.resloader = (cs_ResLoader.Create)()
  end
  if IsNull(self.shopkeeperPicObj) then
    (self.resloader):LoadABAssetAsync(PathConsts:GetCharacterLive2DPath(rikoModelName), function(prefab)
    -- function num : 0_1_0 , upvalues : self, _ENV
    self.shopkeeperPicObj = prefab:Instantiate(((self.ui).heroHolder).transform)
    ;
    ((self.shopkeeperPicObj).transform):SetLayer(LayerMask.UI)
    if ((self.ui).heroNode).activeInHierarchy then
      self:_L2DBingding()
      self:PlayLogin()
    end
  end
)
  else
    if ((self.ui).heroNode).activeInHierarchy and self.l2dBinding ~= nil then
      local interation = (((self.l2dBinding).renderController).transform):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
      if interation ~= nil then
        interation:RestartBodyAnimation()
      end
    end
  end
end

UINRecommeShop.ShopCommonInit = function(self, uiShop)
  -- function num : 0_2
  self.uiShop = uiShop
end

UINRecommeShop.RefreshShopNode = function(self, shopId, pageId)
  -- function num : 0_3 , upvalues : _ENV
  self:InitRecomme(pageId)
  ;
  (self.uiShop):RefreshHeadBar(nil)
  ;
  (UIUtil.RefreshTopResId)(nil)
end

UINRecommeShop.PlayLogin = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local randomIndex = (math.random)(1, #(ConfigData.recommend_dialogue).loginCvIdList)
  local cvLength = 0
  do
    if self.heroCubismInteration ~= nil then
      local animLength = (self.heroCubismInteration):PlayLoginAnimation(randomIndex)
      cvLength = animLength
    end
    self:ShowTxtAfterTime((ConfigData.recommend_dialogue).defaultCvId, cvLength)
  end
end

UINRecommeShop.AnimationCallFunction = function(self, l2dClipType, loginType, hitArea, animName, animLength)
  -- function num : 0_5 , upvalues : _ENV
  local idList = ((ConfigData.recommend_dialogue).actionMapping)[animName]
  if idList == nil then
    return 
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):SetInterationCVOver(false)
  end
  local index = (math.random)(#idList)
  local cvId = idList[index]
  local cvLength = self:ShowTxt(cvId, true)
  animLength = (math.max)(animLength, cvLength)
  self:ShowTxtAfterTime((ConfigData.recommend_dialogue).defaultCvId, animLength)
end

UINRecommeShop.ShowTxtAfterTime = function(self, idx, animLength)
  -- function num : 0_6 , upvalues : _ENV
  if animLength == nil then
    return 
  end
  if self.__timerId ~= nil then
    TimerManager:StopTimer(self.__timerId)
  end
  self.__timerId = TimerManager:StartTimer(animLength, function()
    -- function num : 0_6_0 , upvalues : self
    ((self.ui).dialogBox):SetActive(false)
    if self.heroCubismInteration ~= nil then
      (self.heroCubismInteration):SetInterationCVOver(true)
    end
  end
, nil, true)
end

UINRecommeShop.ShowTxt = function(self, idx, playCv)
  -- function num : 0_7 , upvalues : _ENV, rikoSheetName
  local cfg = (ConfigData.recommend_dialogue)[idx]
  if cfg == nil then
    return 
  end
  local dialog = (LanguageUtil.GetLocaleText)(cfg.text)
  if (string.IsNullOrEmpty)(dialog) then
    ((self.ui).dialogBox):SetActive(false)
  else
    ;
    ((self.ui).dialogBox):SetActive(true)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Dialog).text = dialog
    ;
    ((self.ui).tex_Dialog):StartScrambleTypeWriter()
  end
  if playCv then
    AudioManager:PlayAudio(cfg.audio, rikoSheetName, eAudioSourceType.Live2DSource, nil)
    return AudioManager:GetAudioLength(rikoSheetName, cfg.audio) / 1000
  end
  return 0
end

UINRecommeShop.InitRecomme = function(self, pageId)
  -- function num : 0_8 , upvalues : _ENV, ShopEnum
  self.shopPageCfg = (ConfigData.shop_page)[pageId]
  if (self.shopPageCfg).style == (ShopEnum.eRecommeStyle).SingleModel then
    self:RefreshSignleModel(pageId)
  else
    if (self.shopPageCfg).style == (ShopEnum.eRecommeStyle).MultiModel then
      self:RefreshMultiModel()
    end
  end
  self:RefreshAllIsSouldOut()
end

UINRecommeShop.GetPageCfgIndex = function(self, pageId)
  -- function num : 0_9 , upvalues : ShopEnum, _ENV
  if #(self.shopPageCfg).imgs > 1 and pageId == (ShopEnum.SingleRecommendPage).MonthCard then
    local dailySignInData = PlayerDataCenter.dailySignInData
    local isDiscount = dailySignInData:IsCardDiscount()
    if isDiscount then
      return 2
    end
  end
  do
    return 1
  end
end

UINRecommeShop.RefreshSignleModel = function(self, pageId)
  -- function num : 0_10 , upvalues : _ENV
  ((self.ui).recomNode):SetActive(false)
  ;
  (self.singlePicItem):Show()
  local recommeCfg = (ConfigData.shop_recommend)[((self.shopPageCfg).imgs)[self:GetPageCfgIndex(pageId)]]
  ;
  (self.singlePicItem):InitRecommeShopPic(recommeCfg, self.resloader)
end

UINRecommeShop.RefreshMultiModel = function(self)
  -- function num : 0_11 , upvalues : _ENV, ShopEnum
  ((self.ui).recomNode):SetActive(true)
  ;
  (self.singlePicItem):Hide()
  local bannerCfgList = {}
  local middleCfgList = {}
  local smallCfg = nil
  for i,recommendId in ipairs((self.shopPageCfg).imgs) do
    local cfg = (ConfigData.shop_recommend)[recommendId]
    do
      do
        if (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2) then
          local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
          if not payGiftCtrl:CheckPageIdIsGiftShop((cfg.jump_arg)[1]) or payGiftCtrl:CheckPageIdIsGiftShop((cfg.jump_arg)[1]) and #payGiftCtrl:GetShowPayGiftByPageId((cfg.jump_arg)[1]) > 0 then
            if cfg.type == (ShopEnum.eRecommePicType).Banner then
              (table.insert)(bannerCfgList, cfg)
            else
              if cfg.type == (ShopEnum.eRecommePicType).Middle then
                (table.insert)(middleCfgList, cfg)
              else
                if cfg.type == (ShopEnum.eRecommePicType).Small then
                  smallCfg = cfg
                end
              end
            end
          end
        end
        -- DECOMPILER ERROR at PC92: Confused about usage of register: R10 in 'UnsetPending'

        if cfg.pre_condition ~= nil and #cfg.pre_condition > 0 and not (self.__addedRecommendIdDic)[recommendId] then
          (self.__addedRecommendIdDic)[recommendId] = true
          ;
          (self.__conditionListener):AddConditionChangeListener(recommendId, self.___OnRecommeBannerImageConditonChange, cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
        end
        -- DECOMPILER ERROR at PC101: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  if smallCfg ~= nil then
    (self.smallPicItem):Show()
    ;
    (self.smallPicItem):InitRecommeShopPic(smallCfg, self.resloader)
  else
    ;
    (self.smallPicItem):Hide()
  end
  for i = #bannerCfgList, 1, -1 do
    local cfg = bannerCfgList[i]
    if self:IsRecommeSouldOut(cfg) and #bannerCfgList > 1 then
      (table.remove)(bannerCfgList, i)
    end
  end
  for i = #middleCfgList, 1, -1 do
    local cfg = middleCfgList[i]
    if self:IsRecommeSouldOut(cfg) and #middleCfgList > 1 then
      (table.remove)(middleCfgList, i)
    end
  end
  ;
  (self.bigLoopPic):RefreshRecShopLoopPicItem(bannerCfgList)
  ;
  (self.midLoopPic):RefreshRecShopLoopPicItem(middleCfgList)
end

UINRecommeShop._OnRecommeBannerImageConditonChange = function(self, recommendId, isunlock)
  -- function num : 0_12
  self:RefreshMultiModel()
end

UINRecommeShop.IsRecommeSouldOut = function(self, recommeCfg)
  -- function num : 0_13 , upvalues : _ENV
  if recommeCfg == nil or recommeCfg.jump_arg == nil then
    return false
  end
  local jumpTargetShopId = (recommeCfg.jump_arg)[1]
  local jumpTargetShelfId = (recommeCfg.jump_arg)[2]
  if jumpTargetShopId == nil or jumpTargetShelfId == nil then
    return false
  end
  local ShopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
  return ShopController:GetShelfIsSouldOut(jumpTargetShopId, jumpTargetShelfId)
end

UINRecommeShop.SetInGuideShopHeroActive = function(self, active)
  -- function num : 0_14 , upvalues : _ENV
  ((self.ui).heroNode):SetActive(active)
  if active then
    ((self.ui).tex_Dialog):StartScrambleTypeWriter(true)
    if self.l2dBinding == nil and not IsNull(self.shopkeeperPicObj) then
      self:_L2DBingding()
    end
    if self.l2dBinding ~= nil then
      local interation = (((self.l2dBinding).renderController).transform):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
      if interation ~= nil then
        interation:RestartBodyAnimation()
      end
    end
  end
end

UINRecommeShop._L2DBingding = function(self)
  -- function num : 0_15 , upvalues : _ENV, HeroCubismInteration
  local cs_CubismInterationController = ((self.shopkeeperPicObj).gameObject):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
  if cs_CubismInterationController ~= nil then
    self.heroCubismInteration = (HeroCubismInteration.New)()
    ;
    (self.heroCubismInteration):InitShopCubism(cs_CubismInterationController, UIManager:GetUICamera(), BindCallback(self, self.AnimationCallFunction))
    ;
    (self.heroCubismInteration):OpenLookTarget(UIManager:GetUICamera())
    ;
    (self.heroCubismInteration):SetRenderControllerSetting("UIHigh", (self.ui).heroHolder, nil, true)
    ;
    (self.heroCubismInteration):SetL2DPosType("RecommeShop", false)
  end
  self.l2dBinding = {}
  ;
  (UIUtil.LuaUIBindingTable)(self.shopkeeperPicObj, self.l2dBinding)
end

UINRecommeShop.RefreshAllIsSouldOut = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local couldRefreshIsouldOutList = {self.smallPicItem, self.singlePicItem}
  ;
  (table.insertto)(couldRefreshIsouldOutList, ((self.bigLoopPic).picPool).listItem)
  ;
  (table.insertto)(couldRefreshIsouldOutList, ((self.midLoopPic).picPool).listItem)
  for _,shopPicItem in pairs(couldRefreshIsouldOutList) do
    shopPicItem:UpdateSouldOut(self.__getSouldOutItem, self.__recycleSouldOutItem)
  end
end

UINRecommeShop.__GetSouldOutItem = function(self)
  -- function num : 0_17
  return (self.souldOutPool):GetOne()
end

UINRecommeShop.__RecycleSouldOutItem = function(self, souldItem)
  -- function num : 0_18
  (self.souldOutPool):HideOne(souldItem)
end

UINRecommeShop.OnDelete = function(self)
  -- function num : 0_19 , upvalues : _ENV, rikoSheetName, base
  (self.__conditionListener):Delete()
  self.__conditionListener = nil
  MsgCenter:RemoveListener(eMsgEventId.PayGiftChange, self.__RefreshAllIsSouldOut)
  AudioManager:RemoveCueSheet(rikoSheetName)
  if not IsNull(self.shopkeeperPicObj) then
    DestroyUnityObject(self.shopkeeperPicObj)
    self.shopkeeperPicObj = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.heroCubismInteration ~= nil then
    (self.heroCubismInteration):Delete()
    self.heroCubismInteration = nil
  end
  if self.__timerId ~= nil then
    TimerManager:StopTimer(self.__timerId)
  end
  ;
  (self.souldOutPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINRecommeShop

