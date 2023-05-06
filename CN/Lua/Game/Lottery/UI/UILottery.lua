-- params : ...
-- function num : 0 , upvalues : _ENV
local UILottery = class("UILottery", UIBaseWindow)
local base = UIBaseWindow
local LotteryEnum = require("Game.Lottery.LotteryEnum")
local UINLtrPoolItem = require("Game.Lottery.UI.UINLtrPoolItem")
local UINLtrHeroItem = require("Game.Lottery.UI.UINLtrHeroItem")
local UILotteryPoolDetail = require("Game.Lottery.UI.PoolDetail.UILotteryPoolDetail")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local HeroInfoData = require("Game.Lottery.Data.HeroInfoData")
local LotteryRtUtil = require("Game.Lottery.UI.LotteryRtUtil")
local JumpManager = require("Game.Jump.JumpManager")
local cs_ResLoader = CS.ResLoader
local cs_MovieManager_ins = (CS.MovieManager).Instance
local cs_EventTriggerListener = CS.EventTriggerListener
local cs_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
UILottery.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINLtrPoolItem, UINLtrHeroItem, cs_EventTriggerListener
  self.__onSelectLtrPoolItem = BindCallback(self, self.SelectLtrPoolItem)
  self.__UpdPoolReddotFunc = BindCallback(self, self._UpdPoolReddot)
  self.__UpdBtnTenRedDot = BindCallback(self, self._UpdBtnTenRedDot)
  self:_ShowBtnTenRedDot(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Once, self, self.__OnClickDrawOne)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Ten, self, self.__OnClickDrawTen)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self.__OnClickFreeSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SpecialOne, self, self.__OnClickDrawSpecialOne)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PtExchange, self, self.__OnClickPtExchange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PoolDetail, self, self.__OnClickPoolDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bg, self, self.__OnClickBg)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_LeftArrow, self, self.__OnClickLeftArrow)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_RightArrow, self, self.__OnClickRightArrow)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UpAddIntro, self, self.__OnClickUpIntro)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UpNormalIntro, self, self.__OnClickUpIntro)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChangeMode, self, self.__OnClickSwitchGroup)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AVGCharDun, self, self.OnClickCharDun)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QuickGift, self, self._OnClickQuickGift)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroInfo, self, self.__OnClickHeroInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ShowCharacter, self, self.__OnClickShowCharacter)
  ;
  (UIUtil.SetTopStatus)(self, self.__OnClickClose, {}, nil, nil)
  self.resLoader = (cs_ResLoader.Create)()
  ;
  ((self.ui).infoItem):SetActive(false)
  self.ltrPoolItemPool = (UIItemPool.New)(UINLtrPoolItem, (self.ui).infoItem)
  self.poolItemWidth = ((((self.ui).infoItem).transform).sizeDelta).x + ((self.ui).scrollLayoutGroup).spacing
  self.heroL = (UINLtrHeroItem.New)()
  ;
  (self.heroL):Init((self.ui).subHeroItem)
  self.heroR = (UINLtrHeroItem.New)()
  ;
  (self.heroR):Init((self.ui).mainHeroItem)
  self.__OnPageChangeDragBegin = BindCallback(self, self.OnPageChangeDragBegin)
  self.__OnPageChangeDragEnd = BindCallback(self, self.OnPageChangeDragEnd)
  local pageChangeEventTrigger = (cs_EventTriggerListener.Get)((self.ui).dragPageChange)
  pageChangeEventTrigger:onBeginDrag("+", self.__OnPageChangeDragBegin)
  pageChangeEventTrigger:onEndDrag("+", self.__OnPageChangeDragEnd)
  self._onItemChangeFunc = BindCallback(self, self._OnItemChange)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self._onItemChangeFunc)
end

UILottery.InitUILottery = function(self, ltrCtrl, poolGroupDataList, poolIndex, inGroupLtrData)
  -- function num : 0_1 , upvalues : _ENV, cs_LayoutRebuilder
  self.ltrCtrl = ltrCtrl
  self:_SetPoolDataList(poolGroupDataList)
  self.poolItemDic = {}
  local reddotNode = (PlayerDataCenter.allLtrData):GetLtrRedDotNode()
  local avgIdDic = {}
  ;
  (self.ltrPoolItemPool):HideAll()
  for k,poolGroupData in ipairs(self.poolGroupDataList) do
    local poolData = poolGroupData.ltrPoolData
    local poolItem = (self.ltrPoolItemPool):GetOne()
    poolItem:InitLtrPoolItem(k, poolData, self.resLoader, self.__onSelectLtrPoolItem)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R14 in 'UnsetPending'

    ;
    (self.poolItemDic)[poolData.poolId] = poolItem
    local poolNode = reddotNode:GetChild(poolData.poolId)
    if poolNode:GetRedDotCount() <= 0 then
      poolItem:ShowLtrPoolItemReddot(poolNode == nil)
      do
        local avgId = poolData:TryGetLtrIntoAvgNotPlayed()
        if avgId ~= nil and avgIdDic[avgId] == nil and not GuideManager.inGuide then
          avgIdDic[avgId] = true
          ;
          (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId)
        end
        -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  ;
  ((self.ui).img_Select):SetAsLastSibling()
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).scrollLayoutGroup).transform)
  self:SelectLtrUIPool(poolIndex, inGroupLtrData)
  RedDotController:AddListener(RedDotDynPath.LotteryPrPoolPath, self.__UpdPoolReddotFunc)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UILottery._SetPoolDataList = function(self, poolGroupDataList)
  -- function num : 0_2
  self.poolGroupDataList = poolGroupDataList
end

UILottery.RefreshLtrPoolUI = function(self, poolGroupDataList)
  -- function num : 0_3 , upvalues : _ENV, cs_LayoutRebuilder
  local poolIndex = self.poolIndex
  if #poolGroupDataList < poolIndex then
    poolIndex = 1
  end
  self:_SetPoolDataList(poolGroupDataList)
  local curIdDic = {}
  for k,poolGroupData in ipairs(poolGroupDataList) do
    local poolId = (poolGroupData.ltrPoolData).poolId
    curIdDic[poolId] = true
    local poolItem = (self.poolItemDic)[poolId]
    if poolItem == nil then
      poolItem = (self.ltrPoolItemPool):GetOne()
      poolItem:InitLtrPoolItem(k, poolGroupData.ltrPoolData, self.resLoader, self.__onSelectLtrPoolItem)
      -- DECOMPILER ERROR at PC31: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self.poolItemDic)[poolId] = poolItem
    end
    ;
    (poolItem.transform):SetAsLastSibling()
    poolItem:SetLtrPoolItemIndex(k)
  end
  local toBeRemoveIdDic = {}
  for poolId,poolItem in pairs(self.poolItemDic) do
    if curIdDic[poolId] == nil then
      toBeRemoveIdDic[poolId] = true
      ;
      (self.ltrPoolItemPool):HideOne(poolItem)
    end
  end
  for poolId,v in pairs(toBeRemoveIdDic) do
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R10 in 'UnsetPending'

    (self.poolItemDic)[poolId] = nil
  end
  ;
  ((self.ui).img_Select):SetAsLastSibling()
  ;
  (cs_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).scrollLayoutGroup).transform)
  self:SelectLtrUIPool(poolIndex)
end

UILottery.__refreshModel = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_ResLoader
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  local modelPath = PathConsts:GetCharacterModelPathEx(((self.UpHeroData).heroData):GetResModelName())
  if self.modelPath == modelPath then
    return 
  end
  if not IsNull(self.heroGo) then
    (self.heroGo):SetActive(false)
  end
  self.resLoader = (cs_ResLoader.Create)()
  ;
  (self.resLoader):LoadABAssetAsync(modelPath, function(prefab)
    -- function num : 0_4_0 , upvalues : _ENV, self, modelPath
    DestroyUnityObject(self.heroGo)
    self.modelPath = modelPath
    self.heroGo = prefab:Instantiate(((self.ui).modelHoder).transform)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.heroGo).transform).localEulerAngles = (Vector3.New)(0, 180, 0)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.heroGo).transform).localPosition = (Vector3.New)(0, -0.5, 0)
  end
)
end

UILottery.SelectLotteryPoolById = function(self, poolId)
  -- function num : 0_5
  local poolIndex, inGroupLtrData = (self.ltrCtrl):GenSelectLtrPool(poolId)
  self:SelectLtrUIPool(poolIndex, inGroupLtrData, false)
end

UILottery.SelectLtrUIPool = function(self, poolIndex, inGroupLtrData, withAudio)
  -- function num : 0_6
  local poolId = (((self.poolGroupDataList)[poolIndex]).ltrPoolData).poolId
  local poolItem = (self.poolItemDic)[poolId]
  self:SelectLtrPoolItem(poolItem, inGroupLtrData, withAudio)
end

UILottery.SelectLtrPoolItem = function(self, poolItem, inGroupLtrData, withAudio)
  -- function num : 0_7 , upvalues : _ENV
  if withAudio == nil then
    withAudio = true
  end
  if withAudio then
    AudioManager:PlayAudioById(1041)
  end
  self:_ClearSelectMoveTween()
  self._selectMoveTween = ((self.ui).img_Select):DOLocalMoveX(((poolItem.transform).anchoredPosition).x, 0.2)
  if self.poolItem ~= poolItem then
    ((self.ui).ani_Pic):DORestart()
    self.poolItem = poolItem
  end
  self.poolIndex = poolItem.index
  local poolGrouData = (self.poolGroupDataList)[self.poolIndex]
  local ltrPoolData = nil
  local lastPoolData = poolGrouData:TryGetLastLtrPoolData()
  ltrPoolData = lastPoolData == nil and inGroupLtrData or lastPoolData
  local showSelectPool = false
  if not ltrPoolData and poolGrouData:HasLtrMoreGroup() then
    showSelectPool = true
    ltrPoolData = (poolGrouData:GetLtrInGroupDataList())[1]
  else
    ltrPoolData = poolItem.ltrPoolData
  end
  self:SelectLtrPoolByData(ltrPoolData)
  self:_LocateItemTween()
  if showSelectPool then
    UIManager:ShowWindowAsync(UIWindowTypeID.LotterySelectPool, function(win)
    -- function num : 0_7_0 , upvalues : poolGrouData, self
    if win == nil then
      return 
    end
    win:InitLtrSelectPool(poolGrouData, 0, function(ltrData)
      -- function num : 0_7_0_0 , upvalues : self
      self:SelectLtrPoolByData(ltrData)
      ;
      (self.ltrCtrl):SelectGroupPoolSuccess(ltrData.poolId)
    end
)
  end
)
  end
end

UILottery.SelectLtrPoolByData = function(self, ltrPoolData)
  -- function num : 0_8
  local changedPool = self.curPoolData ~= ltrPoolData
  self.curPoolData = ltrPoolData
  self.curPoolCfg = ltrPoolData:GetLtrPoolDataCfg()
  local poolId = (self.curPoolCfg).lottery_id
  ;
  (self.ltrCtrl):SelectLtrPool(poolId)
  self:__RefreshGuaranteeState()
  self:RefreshCurLtrUI(changedPool)
  self:RefreshCharDunBtn()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UILottery.RefreshCurLtrUI = function(self, changedPool)
  -- function num : 0_9 , upvalues : LotteryEnum, _ENV, cs_ResLoader, cs_MovieManager_ins
  local curPoolData = self.curPoolData
  local curPoolCfg = self.curPoolCfg
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).btn_LeftArrow).interactable = self.poolIndex ~= 1
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).btn_RightArrow).interactable = self.poolIndex ~= #self.poolGroupDataList
  self:__RefreshTopRes()
  local hasOnece = curPoolData:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).Once)
  local hasTen = curPoolData:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).Ten)
  local hasSpecialOnce = curPoolData:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).SpecialOnce)
  local hasFreeChoice = curPoolData:IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).FreeChoice)
  local IsGuaranteeOpen = curPoolData:IsGuaranteeOpen()
  local IsHeroInfoBtnOpenParam = curPoolData:IsHeroInfoBtnOpen()
  if hasFreeChoice then
    (((self.ui).model_camera).gameObject):SetActive(false)
    ;
    (((self.ui).rect_uiModel).gameObject):SetActive(false)
    local window = UIManager:GetWindow(UIWindowTypeID.LotterySelectHero)
    if window ~= nil then
      if not (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).FreeChoice) then
        window:Hide()
        return 
      end
      window:Show()
      window:InitLotterySelectHero(self.curPoolData)
      -- DECOMPILER ERROR at PC81: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (window.transform).localScale = Vector3.one
      ;
      ((self.ui).dragPageChange):SetActive(false)
    else
      UIManager:ShowWindowAsync(UIWindowTypeID.LotterySelectHero, function(window)
    -- function num : 0_9_0 , upvalues : self, LotteryEnum, _ENV
    if window == nil then
      return 
    end
    ;
    (window.transform):SetParent((self.ui).selectHeroHolder)
    window:InitPageChangeDrag(self.__OnPageChangeDragBegin, self.__OnPageChangeDragEnd)
    if not (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).FreeChoice) then
      window:Hide()
      return 
    end
    window:InitLotterySelectHero(self.curPoolData)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (window.transform).localScale = Vector3.one
    ;
    ((self.ui).dragPageChange):SetActive(false)
  end
)
    end
  else
    local selectHeroWindow = UIManager:GetWindow(UIWindowTypeID.LotterySelectHero)
    if selectHeroWindow ~= nil and selectHeroWindow.active then
      selectHeroWindow:Hide()
      selectHeroWindow:ClearLotterySelect()
    end
    ;
    ((self.ui).dragPageChange):SetActive(true)
  end
  ;
  (((self.ui).sprcialSlogan).gameObject):SetActive(IsGuaranteeOpen)
  ;
  ((self.ui).adapter):SetActive(not hasFreeChoice)
  ;
  (((self.ui).btn_PoolDetail).gameObject):SetActive(not hasFreeChoice)
  self:__RefreshFreeChoiceTips()
  local isUpLottery = IsHeroInfoBtnOpenParam[1]
  ;
  (((self.ui).btn_HeroInfo).gameObject):SetActive(isUpLottery)
  ;
  (((self.ui).btn_ShowCharacter).gameObject):SetActive(isUpLottery)
  self.UpHeroId = IsHeroInfoBtnOpenParam[2]
  if isUpLottery and self.UpHeroId then
    local lottery_preview = (ConfigData.lottery_preview)[self.UpHeroId]
    if lottery_preview ~= nil then
      local fullPath = PathConsts:GetImagePath(lottery_preview.previewPic)
      local image = (self.resLoader):LoadABAsset(fullPath)
      -- DECOMPILER ERROR at PC171: Confused about usage of register: R14 in 'UnsetPending'

      if image ~= nil then
        ((self.ui).img_PreviewCharacter).texture = image
      end
    end
  end
  ;
  (((self.ui).btn_Once).gameObject):SetActive(hasOnece)
  ;
  (((self.ui).btn_Ten).gameObject):SetActive(hasTen)
  ;
  (((self.ui).btn_Select).gameObject):SetActive(hasFreeChoice)
  ;
  (((self.ui).btn_SpecialOne).gameObject):SetActive(hasSpecialOnce)
  -- DECOMPILER ERROR at PC204: Confused about usage of register: R11 in 'UnsetPending'

  if hasOnece then
    ((self.ui).tex_PayOnce).text = tostring((self.curPoolCfg).costNum1)
    -- DECOMPILER ERROR at PC216: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).img_PayIcon_Once).sprite = CRH:GetSprite(((ConfigData.item)[(self.curPoolCfg).costId1]).small_icon)
  end
  do
    if hasSpecialOnce then
      local itemCfg = (ConfigData.item)[(self.curPoolCfg).costId3]
      -- DECOMPILER ERROR at PC230: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).tex_PaySepecialOne).text = tostring((self.curPoolCfg).costNum3)
      -- DECOMPILER ERROR at PC237: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_PayIcon_SpecialOnce).sprite = CRH:GetSprite(itemCfg.small_icon)
      ;
      ((self.ui).tex_SpecialOnceItemName):SetIndex(0, (LanguageUtil.GetLocaleText)(itemCfg.name))
    end
    -- DECOMPILER ERROR at PC255: Confused about usage of register: R11 in 'UnsetPending'

    if hasFreeChoice then
      ((self.ui).tex_Pay_Select).text = tostring((self.curPoolCfg).costNum4)
      -- DECOMPILER ERROR at PC267: Confused about usage of register: R11 in 'UnsetPending'

      ;
      ((self.ui).img_PayIcon_Select).sprite = CRH:GetSprite(((ConfigData.item)[(self.curPoolCfg).costId4]).small_icon)
    end
    self:RefreshCurLtrChangedUI()
    -- DECOMPILER ERROR at PC276: Confused about usage of register: R11 in 'UnsetPending'

    if (self.curPoolCfg).intro_des == nil then
      ((self.ui).tex_Desc).text = nil
    else
      -- DECOMPILER ERROR at PC285: Confused about usage of register: R11 in 'UnsetPending'

      ((self.ui).tex_Desc).text = (LanguageUtil.GetLocaleText)((self.curPoolCfg).intro_des)
    end
    local lastTempResLoader = nil
    if changedPool and self.tempResLoader ~= nil then
      lastTempResLoader = self.tempResLoader
      self.tempResLoader = nil
    end
    if self.tempResLoader == nil then
      self.tempResLoader = (cs_ResLoader.Create)()
    end
    -- DECOMPILER ERROR at PC302: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).img_Pic).enabled = false
    if (self.curPoolCfg).bg_type == 1 then
      if self.moviePlayer ~= nil then
        (self.moviePlayer):StopVideo()
        cs_MovieManager_ins:ReturnMoviePlayer(self.moviePlayer)
        self.moviePlayer = nil
      end
      local path = PathConsts:GetLotteryPicPath("MainPicture/" .. (self.curPoolCfg).bg_path)
      ;
      (self.tempResLoader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_9_1 , upvalues : self
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Pic).texture = texture
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Pic).enabled = true
  end
)
    elseif (self.curPoolCfg).bg_type == 2 then
      if self.moviePlayer == nil then
        self.moviePlayer = cs_MovieManager_ins:GetMoviePlayer()
      end
      ;
      (self.moviePlayer):SetVideoRender((self.ui).img_Video)
      local path = "Lottery/" .. (self.curPoolCfg).bg_path
      ;
      (self.moviePlayer):PlayVideo(path, nil, 1, true)
    else
      error("lottery_para.bg_type error : " .. tostring((self.curPoolCfg).bg_type))
    end
    -- DECOMPILER ERROR at PC369: Confused about usage of register: R12 in 'UnsetPending'

    ;
    ((self.ui).img_SubImage).enabled = false
    do
      if not (string.IsNullOrEmpty)((self.curPoolCfg).bg1_path) then
        local path = PathConsts:GetLotteryPicPath("SubPicture/" .. (self.curPoolCfg).bg1_path)
        ;
        (self.tempResLoader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_9_2 , upvalues : self
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SubImage).texture = texture
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SubImage).enabled = true
  end
)
      end
      -- DECOMPILER ERROR at PC391: Confused about usage of register: R12 in 'UnsetPending'

      ;
      ((self.ui).img_Tile).enabled = false
      do
        if not (string.IsNullOrEmpty)((self.curPoolCfg).intro_path) then
          local introPath = PathConsts:GetLotteryPicPath("Tile/" .. (self.curPoolCfg).intro_path)
          ;
          (self.tempResLoader):LoadABAssetAsync(introPath, function(texture)
    -- function num : 0_9_3 , upvalues : self
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Tile).texture = texture
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Tile).enabled = true
  end
)
        end
        if (self.curPoolCfg).up_reward1 == 0 then
          (self.heroL):Hide()
        else
          (self.heroL):Show()
          ;
          (self.heroL):InitLtrHeroItem((self.curPoolCfg).up_reward1, self.tempResLoader, (self.curPoolCfg).up_hero1_para)
        end
        if (self.curPoolCfg).up_reward2 == 0 then
          (self.heroR):Hide()
        else
          (self.heroR):Show()
          ;
          (self.heroR):InitLtrHeroItem((self.curPoolCfg).up_reward2, self.tempResLoader, (self.curPoolCfg).up_hero2_para)
        end
        local startTime, endTime = curPoolData:GetStartAndEndTime()
        if self._countdownTimerId ~= nil then
          TimerManager:StopTimer(self._countdownTimerId)
          self._countdownTimerId = nil
        end
        if endTime == -1 then
          (((self.ui).tex_EndTime).gameObject):SetActive(false)
        else
          (((self.ui).tex_EndTime).gameObject):SetActive(true)
          self._countdownTimerId = TimerManager:StartTimer(1, self.__CountDownEndTime, self)
          self:__CountDownEndTime()
        end
        self:_TryUpdJpQZ()
        self:_RefreshLtrGroup()
        self:_RefreshNewRuleReddot()
        self:_UpdQuickGiftBtn()
        if lastTempResLoader ~= nil then
          lastTempResLoader:Put2Pool()
          lastTempResLoader = nil
        end
        -- DECOMPILER ERROR: 30 unprocessed JMP targets
      end
    end
  end
end

UILottery._RefreshLtrGroup = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local ltrGroupData = (self.poolGroupDataList)[self.poolIndex]
  local hasMoreGroup = ltrGroupData:HasLtrMoreGroup()
  ;
  (((self.ui).btn_ChangeMode).gameObject):SetActive(hasMoreGroup)
  if not hasMoreGroup then
    return 
  end
  local ruleId = (self.curPoolCfg).repeat_type
  ;
  ((self.ui).tex_ChangeMode):SetIndex(ruleId)
  local userData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  local showRed = userData:GetLtrNewConvertSwitchRed()
  ;
  ((self.ui).obj_ChangeModeRedDot):SetActive(showRed)
end

UILottery._RefreshNewRuleReddot = function(self)
  -- function num : 0_11
  local showLtrNewRuleRed = (self.curPoolData):IsShowLtrNewRuleReddot()
  ;
  ((self.ui).obj_PoolDetailRedDot):SetActive(showLtrNewRuleRed)
end

UILottery.RefreshCurLtrChangedUI = function(self)
  -- function num : 0_12 , upvalues : LotteryEnum, _ENV
  self:__RefreshSpecialOnceBtnState()
  self:__RefreshPtBtn()
  self:__RefreshTenBtn()
  self:_RefreshSpecialUp()
  if (self.curPoolCfg).count_limit ~= 0 and not (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).FreeChoice) then
    ((self.ui).obj_RemianNum):SetActive(true)
    local limitNum = (self.curPoolData):GetLtrPoolLimitNum()
    local remainNum = (self.curPoolData):GetLtrPoolRemainNum()
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_RemianNum).text = tostring(remainNum) .. "/" .. tostring(limitNum)
  else
    do
      ;
      ((self.ui).obj_RemianNum):SetActive(false)
    end
  end
end

UILottery._TryUpdJpQZ = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if ((Consts.GameChannelType).IsJp)() and (self.curPoolCfg).costId2 ~= nil and (ConstGlobalItem.IsQZ)((self.curPoolCfg).costId2) then
    ((self.ui).tex_FreeQZ):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidItem)))
    ;
    ((self.ui).tex_PayQZ):SetIndex(0, tostring(PlayerDataCenter:GetItemCoutNoMerge(ConstGlobalItem.PaidQZ)))
    ;
    ((self.ui).obj_JpQZ):SetActive(true)
    return 
  end
  ;
  ((self.ui).obj_JpQZ):SetActive(false)
end

UILottery._RefreshSpecialUp = function(self)
  -- function num : 0_14 , upvalues : _ENV
  if not (self.curPoolData):ShowLtrUpIntro() then
    ((self.ui).obj_UpAdd):SetActive(false)
    ;
    ((self.ui).obj_UpNormal):SetActive(false)
    return 
  end
  local isSpecialUp = (self.curPoolData):IsLtrSpecialUp()
  ;
  ((self.ui).obj_UpAdd):SetActive(isSpecialUp)
  ;
  ((self.ui).obj_UpNormal):SetActive(not isSpecialUp)
  if isSpecialUp then
    local noUpNum = (self.curPoolData):GetLtrNoUpNum()
    local mustUpNum = (self.curPoolData):GetLtrSpecialUpNum()
    ;
    ((self.ui).tex_SpUpNum):SetIndex(0, tostring(noUpNum), tostring(mustUpNum))
  end
end

UILottery.__RefreshTopRes = function(self)
  -- function num : 0_15 , upvalues : _ENV, LotteryEnum
  local topResDic = {}
  for k,execType in pairs(LotteryEnum.eLtrExecType) do
    if (self.curPoolData):IsLtrExecTypeOpen(execType) then
      local costIdStr = "costId" .. tostring(execType)
      if (self.curPoolCfg)[costIdStr] ~= nil then
        topResDic[(self.curPoolCfg)[costIdStr]] = true
      end
    end
  end
  if (self.curPoolData):IsLtrHasTenPrior() then
    topResDic[(self.curPoolCfg).costIdTenPrior] = true
  end
  if (self.curPoolCfg).pool_client_type == (LotteryEnum.eLotteryPoolType).Paid then
    topResDic[ConstGlobalItem.PaidItem] = true
    topResDic[ConstGlobalItem.PaidSubItem] = true
  end
  local topResIdList = {}
  for itemId,_ in pairs(topResDic) do
    (table.insert)(topResIdList, itemId)
  end
  ;
  (table.sort)(topResIdList)
  ;
  (UIUtil.RefreshTopResId)(topResIdList)
end

UILottery.__RefreshPtBtn = function(self)
  -- function num : 0_16 , upvalues : _ENV
  local hasPt = (self.curPoolData):HasLtrPt()
  ;
  (((self.ui).btn_PtExchange).gameObject):SetActive(hasPt)
  ;
  ((self.ui).obj_MaskOnlyPt):SetActive(false)
  ;
  ((self.ui).obj_onlyPtTips):SetActive(false)
  if not hasPt then
    return 
  end
  local ptNum = (self.curPoolData):GetLtrPtNum()
  local maxPtNum = 0
  for k,num in ipairs((self.curPoolCfg).pt_rewardCostNumList) do
    maxPtNum = (math.max)(maxPtNum, num)
  end
  ;
  ((self.ui).tex_PtNum):SetIndex(0, tostring(ptNum), tostring(maxPtNum))
  if maxPtNum <= ptNum then
    ((self.ui).obj_MaskOnlyPt):SetActive(true)
    ;
    ((self.ui).obj_onlyPtTips):SetActive(true)
    ;
    ((self.ui).tex_PtTips):SetIndex(0, tostring(maxPtNum))
  end
end

UILottery.__RefreshTenBtn = function(self)
  -- function num : 0_17 , upvalues : LotteryEnum, _ENV
  if not (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).Ten) then
    return 
  end
  self:_RemoveBtnTenReddotListener()
  local ok, btnTenNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.LotteryPr, (self.curPoolData).poolId, RedDotStaticTypeId.LotteryTen)
  if ok then
    RedDotController:AddListener(btnTenNode.nodePath, self.__UpdBtnTenRedDot)
    self._lastBtnTenReddotPath = btnTenNode.nodePath
  end
  self:_ShowBtnTenRedDot(not ok or btnTenNode:GetRedDotCount() > 0)
  local limitNum = (self.curPoolCfg).count_limit
  local disableTen = limitNum ~= 0 and (self.curPoolData):GetLtrPoolRemainNum() < 10
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).btn_Ten).enabled = not disableTen
  ;
  ((self.ui).obj_TenNumLimit):SetActive(disableTen)
  self._hasCustomDrawNum = nil
  local drawNum = 10
  local drawCostId = (self.curPoolCfg).costId2
  local drawCostNum = (self.curPoolCfg).costNum2
  if (self.curPoolData):LtrCurTenIsPrior() then
    drawCostNum = (self.curPoolCfg).costNumTenPrior
    drawCostId = (self.curPoolCfg).costIdTenPrior
  else
    local ok, residueNum = (self.curPoolData):TryGetLtrCustomDrawNum()
    if ok and residueNum > 1 and residueNum < 10 then
      drawNum = residueNum
      drawCostNum = (self.curPoolCfg).costNum1 * residueNum
      self._hasCustomDrawNum = residueNum
    end
  end
  -- DECOMPILER ERROR at PC97: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_PayIcon_Ten).sprite = CRH:GetSprite(((ConfigData.item)[drawCostId]).small_icon)
  ;
  ((self.ui).tex_BtnTen):SetIndex(0, tostring(drawNum))
  -- DECOMPILER ERROR at PC111: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_PayTen).text = tostring(drawCostNum)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UILottery.__RefreshGuaranteeState = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local IsGuaranteeOpen = (self.curPoolData):IsGuaranteeOpen()
  if not IsGuaranteeOpen then
    return 
  end
  local usedGuarantee = ((PlayerDataCenter.allLtrData).ltrSpecial)[((self.curPoolData).ltrCfg).guaranteeType]
  local allGuarantee = ((self.curPoolData).ltrCfg).guaranteeNums
  if usedGuarantee == nil then
    usedGuarantee = 0
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_SprcialSlogan).text = (string.format)("%s/%s", usedGuarantee, allGuarantee)
end

UILottery.__RefreshFreeChoiceTips = function(self)
  -- function num : 0_19 , upvalues : LotteryEnum, _ENV
  local isFreeChoice = (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).FreeChoice)
  ;
  ((self.ui).obj_FreeChoiceTips):SetActive(false)
  if not isFreeChoice then
    return 
  end
  local lastEndTime, lastPoolData = nil, nil
  for k,poolGroupData in ipairs(self.poolGroupDataList) do
    local poolData = poolGroupData.ltrPoolData
    local startTime, endTime = poolData:GetStartAndEndTime()
    if poolData:IsLtrFreeChoicePrompt() then
      if endTime == -1 then
        lastPoolData = poolData
        break
      end
      if lastEndTime == nil or lastEndTime < endTime then
        lastEndTime = endTime
        lastPoolData = poolData
      end
    end
  end
  do
    if lastPoolData == nil then
      return 
    end
    ;
    ((self.ui).obj_FreeChoiceTips):SetActive(true)
    local poolName = (LanguageUtil.GetLocaleText)((lastPoolData.ltrCfg).name)
    ;
    ((self.ui).tex_FreeChoiceTips):SetIndex(0, poolName)
  end
end

UILottery.__RefreshSpecialOnceBtnState = function(self)
  -- function num : 0_20 , upvalues : LotteryEnum, _ENV
  if not (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).SpecialOnce) then
    self:__ClearSpecialOnceBtnTimer()
    return 
  end
  if (self.curPoolData):IsLtrExecSpecialOneceTimeOk() then
    ((self.ui).obj_MaskSpecialOne):SetActive(false)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).btn_SpecialOne).enabled = true
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_SpecialOneceTime).text = (LanguageUtil.GetLocaleText)((self.curPoolCfg).sp_time_show)
  else
    ;
    ((self.ui).obj_MaskSpecialOne):SetActive(true)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).btn_SpecialOne).enabled = false
    self:__ClearSpecialOnceBtnTimer()
    self._specialOnceBtnTimerId = TimerManager:StartTimer(1, self.__UpdSpecialOnceBtnTime, self, false, false, true)
    self:__UpdSpecialOnceBtnTime()
  end
end

UILottery.__UpdSpecialOnceBtnTime = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local remainingTs = (self.curPoolData):GetLtrExecSpecialOneceRemainingTs()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if remainingTs >= 0 then
    ((self.ui).tex_SpecialOneceTime).text = TimeUtil:TimestampToTime(remainingTs)
    return 
  end
  self:__ClearSpecialOnceBtnTimer()
  self:__RefreshSpecialOnceBtnState()
end

UILottery.__ClearSpecialOnceBtnTimer = function(self)
  -- function num : 0_22 , upvalues : _ENV
  if self._specialOnceBtnTimerId ~= nil then
    TimerManager:StopTimer(self._specialOnceBtnTimerId)
    self._specialOnceBtnTimerId = nil
  end
end

UILottery.__CountDownEndTime = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local startTime, endTime = (self.curPoolData):GetStartAndEndTime()
  local diff = endTime - PlayerDataCenter.timestamp
  if diff > 0 then
    local d, h, m, s = TimeUtil:TimestampToTimeInter(diff, false, true)
    if d > 0 then
      ((self.ui).tex_EndTime):SetIndex(0, (string.format)("%02d", d), (string.format)("%02d", h))
    else
      ;
      ((self.ui).tex_EndTime):SetIndex(1, (string.format)("%02d", h), (string.format)("%02d", m))
    end
  else
    do
      ;
      ((self.ui).tex_EndTime):SetIndex(1, "00", "00")
      if self._countdownTimerId ~= nil then
        TimerManager:StopTimer(self._countdownTimerId)
        self._countdownTimerId = nil
      end
    end
  end
end

UILottery.__ClearScrollTween = function(self)
  -- function num : 0_24
  if self.__scrollTween ~= nil then
    (self.__scrollTween):Kill()
    self.__scrollTween = nil
  end
end

UILottery.__OnClickDrawOne = function(self)
  -- function num : 0_25
  (self.ltrCtrl):LtrDrawOne()
end

UILottery.__OnClickDrawTen = function(self)
  -- function num : 0_26
  if self._hasCustomDrawNum ~= nil then
    (self.ltrCtrl):LtrCustomDraw(self._hasCustomDrawNum)
  else
    ;
    (self.ltrCtrl):LtrDrawTen()
  end
end

UILottery.__OnClickDrawSpecialOne = function(self)
  -- function num : 0_27
  (self.ltrCtrl):LtrDrawSpecialOne()
end

UILottery.__OnClickFreeSelect = function(self)
  -- function num : 0_28
  (self.ltrCtrl):LtrFreeSelectJudge((self.curPoolData).ltrCfg)
end

UILottery.__OnClickPtExchange = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if (self.ltrCtrl):CheckLtrPoolExpired() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.LotteryExchange, function(window)
    -- function num : 0_29_0 , upvalues : self
    if window ~= nil then
      window:ShowLtrPtNode(self.curPoolData, self.ltrCtrl)
    end
  end
)
end

UILottery.__OnClickPoolDetail = function(self, showWinFunc)
  -- function num : 0_30 , upvalues : LotteryEnum, _ENV
  if (self.ltrCtrl):CheckLtrPoolExpired() then
    return 
  end
  ;
  (self.ltrCtrl):ChangeLotteryState((LotteryEnum.eLotteryState).PoolDetail)
  UIManager:ShowWindowAsync(UIWindowTypeID.LotteryPoolDetail, function(win)
    -- function num : 0_30_0 , upvalues : self, LotteryEnum, showWinFunc
    if win == nil then
      return 
    end
    local poolGrouData = (self.poolGroupDataList)[self.poolIndex]
    win:InitLtrPoolDetail(self.curPoolData, poolGrouData, function()
      -- function num : 0_30_0_0 , upvalues : self, LotteryEnum
      (self.ltrCtrl):ChangeLotteryState((LotteryEnum.eLotteryState).Normal)
    end
)
    if showWinFunc ~= nil then
      showWinFunc(win)
    end
  end
)
end

UILottery.__OnClickBg = function(self)
  -- function num : 0_31
  (self.ltrCtrl):CheckLtrPoolExpired()
end

UILottery.__OnClickLeftArrow = function(self)
  -- function num : 0_32
  self:__ChangePoolIndex(false)
end

UILottery.__OnClickRightArrow = function(self)
  -- function num : 0_33
  self:__ChangePoolIndex(true)
end

UILottery.__OnClickUpIntro = function(self)
  -- function num : 0_34
  self:__OnClickPoolDetail(function(win)
    -- function num : 0_34_0
    win:ShowLtrDetailUpRule()
  end
)
end

UILottery.__OnClickSwitchGroup = function(self)
  -- function num : 0_35 , upvalues : _ENV
  local ltrGroupData = (self.poolGroupDataList)[self.poolIndex]
  UIManager:ShowWindowAsync(UIWindowTypeID.LotterySelectPool, function(win)
    -- function num : 0_35_0 , upvalues : ltrGroupData, self, _ENV
    if win == nil then
      return 
    end
    win:InitLtrSelectPool(ltrGroupData, (self.curPoolData).poolId, function(ltrData)
      -- function num : 0_35_0_0 , upvalues : self
      self:SelectLtrPoolByData(ltrData)
      ;
      (self.ltrCtrl):SelectGroupPoolSuccess(ltrData.poolId)
    end
)
    if ((self.ui).obj_ChangeModeRedDot).activeInHierarchy then
      (PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)):SetLtrNewConvertSwitchRed()
      PersistentManager:SaveModelData((PersistentConfig.ePackage).UserData)
      ;
      ((self.ui).obj_ChangeModeRedDot):SetActive(false)
    end
  end
)
end

UILottery.__OnClickHeroInfo = function(self)
  -- function num : 0_36 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroInfoState, function(win)
    -- function num : 0_36_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitHeroInfoState(self.UpHeroId)
  end
)
end

UILottery.__OnClickShowCharacter = function(self)
  -- function num : 0_37 , upvalues : _ENV
  local currentPoolId = 0
  local lottrryCtrl = ControllerManager:GetController(ControllerTypeId.Lottery, true)
  if lottrryCtrl ~= nil then
    currentPoolId = lottrryCtrl.curPoolId
  end
  self:CloseLottery(true)
  ;
  (ControllerManager:GetController(ControllerTypeId.ShowCharacter, true)):EnterShowCharacterScene(self.UpHeroId, currentPoolId)
end

UILottery.__ChangePoolIndex = function(self, isAdd)
  -- function num : 0_38 , upvalues : _ENV
  local index = self.poolIndex
  if isAdd then
    index = index + 1
  else
    index = index - 1
  end
  index = (math.clamp)(index, 1, #self.poolGroupDataList)
  if index == self.poolIndex then
    return 
  end
  self:SelectLtrUIPool(index)
  self:_LocateItemTween()
end

UILottery._LocateItemTween = function(self)
  -- function num : 0_39
  ((self.ui).infoScroll):StopMovement()
  local tarPos = nil
  local leftPos = -((((self.ui).scrollLayoutGroup).padding).left + (self.poolIndex - 1) * self.poolItemWidth)
  local rightPos = leftPos - self.poolItemWidth
  local curPosX = ((((self.ui).infoScroll).content).localPosition).x
  if curPosX - leftPos < 0 then
    tarPos = leftPos + (((self.ui).scrollLayoutGroup).padding).left
    if self.poolIndex ~= 1 then
      tarPos = tarPos + self.poolItemWidth * 0.5
    end
  else
    if ((((self.ui).infoScroll).transform).rect).width < curPosX - rightPos then
      tarPos = rightPos + ((((self.ui).infoScroll).transform).rect).width
      if self.poolIndex ~= #self.poolGroupDataList then
        tarPos = tarPos - self.poolItemWidth * 0.5
      end
    else
      return 
    end
  end
  self:__ClearScrollTween()
  self.__scrollTween = (((self.ui).infoScroll).content):DOLocalMoveX(tarPos, 0.2)
end

UILottery.__OnClickClose = function(self)
  -- function num : 0_40 , upvalues : _ENV
  do
    if self.fromType == eBaseWinFromWhere.home then
      local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
      self:CloseLottery(homeWin ~= nil)
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UILottery.CloseLottery = function(self, needRemoveAllVoice)
  -- function num : 0_41 , upvalues : _ENV
  self:OnCloseWin()
  if needRemoveAllVoice then
    AudioManager:RemoveAllVoice()
  end
  ControllerManager:DeleteController(ControllerTypeId.Lottery)
  self:Delete()
end

UILottery.ScrollLotteryPoolEnd = function(self)
  -- function num : 0_42
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).infoScroll).horizontalNormalizedPosition = 1
end

UILottery.OnPageChangeDragBegin = function(self, go, eventData)
  -- function num : 0_43 , upvalues : _ENV
  if GuideManager.inGuide then
    return 
  end
  self.pageChangeTouchPointX = (eventData.position).x
end

UILottery.OnPageChangeDragEnd = function(self, go, eventData)
  -- function num : 0_44
  if self.pageChangeTouchPointX == nil then
    return 
  end
  local curPointX = (eventData.position).x
  local startPointX = self.pageChangeTouchPointX
  self.pageChangeTouchPointX = nil
  local diff = curPointX - startPointX
  if (self.ui).dragPageChangeDiff < diff then
    self:__ChangePoolIndex(false)
  else
    if diff < -(self.ui).dragPageChangeDiff then
      self:__ChangePoolIndex(true)
    end
  end
end

UILottery._OnItemChange = function(self, itemUpdateDic)
  -- function num : 0_45 , upvalues : LotteryEnum, _ENV
  if (self.curPoolData ~= nil and (self.curPoolData):IsLtrExecTypeOpen((LotteryEnum.eLtrExecType).Once) and self.curPoolCfg ~= nil and itemUpdateDic[(self.curPoolCfg).costId1] ~= nil) or self.curPoolData ~= nil and (self.curPoolData):IsLtrHasTenPrior() and self.curPoolCfg ~= nil and itemUpdateDic[(self.curPoolCfg).costIdTenPrior] ~= nil then
    self:__RefreshTenBtn()
  end
  if itemUpdateDic[ConstGlobalItem.PaidItem] ~= nil or itemUpdateDic[ConstGlobalItem.PaidQZ] ~= nil then
    self:_TryUpdJpQZ()
  end
end

UILottery._UpdPoolReddot = function(self, reddotNode)
  -- function num : 0_46
  local ltrId = reddotNode.nodeId
  local poolItem = (self.poolItemDic)[ltrId]
  if reddotNode:GetRedDotCount() <= 0 then
    poolItem:ShowLtrPoolItemReddot(poolItem == nil)
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UILottery._UpdBtnTenRedDot = function(self, node)
  -- function num : 0_47
  self:_ShowBtnTenRedDot(node:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UILottery._RemoveBtnTenReddotListener = function(self)
  -- function num : 0_48 , upvalues : _ENV
  if self._lastBtnTenReddotPath ~= nil then
    RedDotController:RemoveListener(self._lastBtnTenReddotPath, self.__UpdBtnTenRedDot)
    self._lastBtnTenReddotPath = nil
  end
end

UILottery._ShowBtnTenRedDot = function(self, isShow)
  -- function num : 0_49
  ((self.ui).redDot_BtnTen):SetActive(isShow)
end

UILottery._ClearSelectMoveTween = function(self)
  -- function num : 0_50
  if self._selectMoveTween ~= nil then
    (self._selectMoveTween):Kill()
    self._selectMoveTween = nil
  end
end

UILottery.HideLtrDetailNewRuleRedPoint = function(self)
  -- function num : 0_51
  ((self.ui).obj_PoolDetailRedDot):SetActive(false)
end

UILottery.EnableLtrVideo = function(self, enable)
  -- function num : 0_52
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_Video).enabled = enable
end

UILottery.RefreshCharDunBtn = function(self)
  -- function num : 0_53 , upvalues : JumpManager, _ENV
  if (self.curPoolCfg).jump_id ~= (JumpManager.eJumpTarget).DynSectorLevel then
    (((self.ui).btn_AVGCharDun).gameObject):SetActive(false)
  else
    local flag = (PlayerDataCenter.sectorEntranceHandler):CheckSectorValid((self.curPoolCfg).jump_arg)
    ;
    (((self.ui).btn_AVGCharDun).gameObject):SetActive(flag)
  end
end

UILottery.OnClickCharDun = function(self)
  -- function num : 0_54 , upvalues : JumpManager
  if (self.curPoolCfg).jump_id or 0 > 0 then
    JumpManager:Jump((self.curPoolCfg).jump_id, nil, nil, (self.curPoolCfg).jump_arg)
  end
end

UILottery._UpdQuickGiftBtn = function(self)
  -- function num : 0_55
  local ok, giftIdList = (self.curPoolData):GetBuyableGiftIdList()
  ;
  (((self.ui).btn_QuickGift).gameObject):SetActive(ok)
end

UILottery._OnClickQuickGift = function(self)
  -- function num : 0_56 , upvalues : _ENV
  local ok, giftIdList = (self.curPoolData):GetBuyableGiftIdList()
  if not ok then
    self:_UpdQuickGiftBtn()
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonThemedPacks, function(win)
    -- function num : 0_56_0 , upvalues : giftIdList, self
    if win == nil then
      return 
    end
    win:InitLotteryQuickGift(giftIdList, function()
      -- function num : 0_56_0_0 , upvalues : self
      self:_UpdQuickGiftBtn()
    end
)
  end
)
end

UILottery.OnDelete = function(self)
  -- function num : 0_57 , upvalues : _ENV, cs_MovieManager_ins, LotteryRtUtil, base
  RedDotController:RemoveListener(RedDotDynPath.LotteryPrPoolPath, self.__UpdPoolReddotFunc)
  self:_RemoveBtnTenReddotListener()
  ;
  ((self.ui).ani_Pic):DOKill()
  ;
  (self.ltrPoolItemPool):DeleteAll()
  if self._countdownTimerId ~= nil then
    TimerManager:StopTimer(self._countdownTimerId)
    self._countdownTimerId = nil
  end
  UIManager:DeleteWindow(UIWindowTypeID.LotterySelectHero)
  UIManager:DeleteWindow(UIWindowTypeID.LotteryExchange)
  self:_ClearSelectMoveTween()
  if self.tempResLoader ~= nil then
    (self.tempResLoader):Put2Pool()
    self.tempResLoader = nil
  end
  if self.moviePlayer ~= nil then
    cs_MovieManager_ins:ReturnMoviePlayer(self.moviePlayer)
    self.moviePlayer = nil
  end
  self:__ClearScrollTween()
  self:__ClearSpecialOnceBtnTimer()
  ;
  (self.resLoader):Put2Pool()
  self.resLoader = nil
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R1 in 'UnsetPending'

  if self.texture ~= nil then
    ((self.ui).model_camera).targetTexture = nil
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).model_Image).texture = nil
    ;
    (LotteryRtUtil.ReleaseTemporaryAndDestory)(self.texture)
    self.texture = nil
    ;
    (((self.ui).model_camera).gameObject):SetActive(false)
    ;
    (((self.ui).rect_uiModel).gameObject):SetActive(false)
  end
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self._onItemChangeFunc)
  ;
  (base.OnDelete)(self)
end

return UILottery

