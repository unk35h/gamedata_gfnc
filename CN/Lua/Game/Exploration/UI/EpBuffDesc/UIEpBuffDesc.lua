-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpBuffDesc = class("UIEpBuffDesc", UIBaseWindow)
local base = UIBaseWindow
local UINBuffDescItem = require("Game.Exploration.UI.EpBuffDesc.UINBuffDescItem")
local UINBuffTogs = require("Game.Exploration.UI.EpBuffDesc.UINBuffTogs")
local eEpBuffDescEnum = require("Game.Exploration.UI.EpBuffDesc.eEpBuffDescEnum")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eTogsType = eEpBuffDescEnum.TogsType
local cs_DoTween = ((CS.DG).Tweening).DOTween
UIEpBuffDesc.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBuffDescItem, UINBuffTogs
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  ((self.ui).epBuffDescItem):SetActive(false)
  ;
  ((self.ui).descPageBuffItem):SetActive(false)
  ;
  (((self.ui).ani_textContinue).gameObject):SetActive(false)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).Img_Bg).raycastTarget = false
  ;
  (((self.ui).tex_EmptyTip).gameObject):SetActive(false)
  self._emptyTipActive = false
  ;
  ((self.ui).tex_Title):SetIndex(0)
  self.buffDescItemPool = (UIItemPool.New)(UINBuffDescItem, (self.ui).epBuffDescItem)
  self.descPageItemPool = (UIItemPool.New)(UINBuffDescItem, (self.ui).descPageBuffItem)
  ;
  (UIUtil.AddButtonListener)((self.ui).Btn_Bg, self, self._OnBackgroundClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Check, self, self._OnClickBtnCheck)
  self._refershDunBuffDesc = BindCallback(self, self.RefershDunBuffDesc)
  self.buffTogs = (UINBuffTogs.New)()
  ;
  ((self.ui).obj_Togs):SetActive(false)
  ;
  (self.buffTogs):Init((self.ui).obj_Togs)
  self._openFlyAniTimeScale = 1
  self.__cacheScrollRectScrollbar = ((self.ui).scrollRect_list).horizontalScrollbar
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect_list).horizontalScrollbar = nil
  ;
  ((self.__cacheScrollRectScrollbar).gameObject):SetActive(false)
end

UIEpBuffDesc.OnHide = function(self)
  -- function num : 0_1
  (self.buffTogs):Hide()
end

UIEpBuffDesc.InitTimer = function(self, SetTime)
  -- function num : 0_2 , upvalues : _ENV
  self._timerID = TimerManager:StartTimer(SetTime, self._OnTimeOver, self, true, false, true)
end

UIEpBuffDesc.InitEpBuffDesc = function(self, buffList, closeCallback, RefershFunc)
  -- function num : 0_3
  self:InitTimer((self.ui).flo_canClickTime or 1)
  self.closeCallback = closeCallback
  if not RefershFunc then
    self:RefershEpBuffDesc(buffList)
  else
    RefershFunc(buffList)
  end
end

UIEpBuffDesc.InitWCBuffDesc = function(self, buffList, closeCallback, index, aniTimeScale)
  -- function num : 0_4
  ;
  ((self.ui).tex_Title):SetIndex(index or 0)
  self:InitEpBuffDesc(buffList, closeCallback, function()
    -- function num : 0_4_0 , upvalues : self, buffList, aniTimeScale
    self:RefershEpBuffDesc(buffList, aniTimeScale)
  end
)
end

UIEpBuffDesc.OpenBuffCloseFlyAni = function(self, aniTimeScale)
  -- function num : 0_5
  self._openFlyAni = true
  if not aniTimeScale then
    aniTimeScale = 1
  end
  self._openFlyAniTimeScale = aniTimeScale
end

UIEpBuffDesc.InitEpBuffSelect = function(self, epBuffList, unlockBuffIdDic)
  -- function num : 0_6 , upvalues : _ENV
  (((self.ui).btn_Check).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).btn_Check).interactable = false
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).Btn_Bg).enabled = false
  ;
  ((self.ui).tex_Title):SetIndex(1)
  if not self._OnClickBuffItemFunc then
    self._OnClickBuffItemFunc = BindCallback(self, self._OnClickBuffItem)
    for index,epBuff in ipairs(epBuffList) do
      local item = (self.buffDescItemPool):GetOne(true)
      local lock = not unlockBuffIdDic[epBuff.dataId]
      item:InitBuffDescItemSelect(epBuff, lock, self._OnClickBuffItemFunc)
    end
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

    if #epBuffList > 4 then
      (((self.ui).contentSize).transform).pivot = (Vector2.Temp)(0, 0.5)
    else
      -- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (((self.ui).contentSize).transform).pivot = (Vector2.Temp)(0.5, 0.5)
    end
    -- DECOMPILER ERROR at PC70: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).contentSize).transform).anchoredPosition = Vector2.zero
  end
end

UIEpBuffDesc.InitEpFloorBuffShow = function(self, epBuff, closeCallback)
  -- function num : 0_7
  local epBuffList = {epBuff}
  ;
  ((self.ui).tex_Title):SetIndex(2)
  self:InitEpBuffDesc(epBuffList, closeCallback)
end

UIEpBuffDesc.InitGetEpBuffShow = function(self, epBuffList, closeCallback)
  -- function num : 0_8
  ((self.ui).tex_Title):SetIndex(3)
  self:InitEpBuffDesc(epBuffList, closeCallback)
end

UIEpBuffDesc.InitDescriptPageEpBuffShow = function(self, buffList, closeCallback)
  -- function num : 0_9
  ((self.ui).tex_Title):SetIndex(4)
  self:InitEpBuffDesc(buffList, closeCallback, function(buffList)
    -- function num : 0_9_0 , upvalues : self
    self:IniDescriptPageEpBuff(buffList)
    ;
    (self.buffTogs):Show()
  end
)
end

UIEpBuffDesc.IniDescriptPageEpBuff = function(self, buffList)
  -- function num : 0_10 , upvalues : _ENV, eWarChessEnum, eTogsType
  local positiveBuffList = {}
  local neutralBuffList = {}
  local negativeBuffList = {}
  local customBuffList = {}
  ;
  (self.descPageItemPool):HideAll()
  for index,buff in ipairs(buffList) do
    if buff.epBuffCfg and (buff.epBuffCfg).is_listshow then
      local item = (self.descPageItemPool):GetOne(true)
      item:InitBuffDescItem(buff)
      if (buff.epBuffCfg).buff_type == 0 then
        (table.insert)(neutralBuffList, item)
      else
        if (buff.epBuffCfg).buff_type == 1 then
          (table.insert)(positiveBuffList, item)
        else
          if (buff.epBuffCfg).buff_type == 2 then
            (table.insert)(negativeBuffList, item)
          end
        end
      end
      if (buff.epBuffCfg).end_layer == 1 then
        (table.insert)(customBuffList, item)
      end
    else
      do
        if buff.wcBuffCfg and (buff.wcBuffCfg).is_show then
          local item = (self.descPageItemPool):GetOne(true)
          item:InitBuffDescItem(buff)
          if (buff.wcBuffCfg).color_type == 2 then
            (table.insert)(neutralBuffList, item)
          else
            if (buff.wcBuffCfg).color_type == 1 then
              (table.insert)(positiveBuffList, item)
            else
              if (buff.wcBuffCfg).color_type == 3 then
                (table.insert)(negativeBuffList, item)
              end
            end
          end
          if (buff.wcBuffCfg).show_type == (eWarChessEnum.eWarChessBuffShowType).floor then
            (table.insert)(customBuffList, item)
          end
        else
          do
            do
              if buff.dunBuffCfg and not (buff.dunBuffCfg).is_hide then
                local item = (self.descPageItemPool):GetOne(true)
                item:InitBuffDescItem(buff)
                if (buff.dunBuffCfg).buff_type == 1 then
                  (table.insert)(positiveBuffList, item)
                else
                  if (buff.dunBuffCfg).buff_type == 2 then
                    (table.insert)(negativeBuffList, item)
                  end
                end
              end
              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC152: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  self.__pageList = {[eTogsType.All] = (self.descPageItemPool).listItem, [eTogsType.Positive] = positiveBuffList, [eTogsType.Neutral] = neutralBuffList, [eTogsType.Negative] = negativeBuffList}
  -- DECOMPILER ERROR at PC171: Confused about usage of register: R6 in 'UnsetPending'

  if #customBuffList > 0 then
    (self.__pageList)[eTogsType.Custom] = customBuffList
    ;
    (self.buffTogs):AddTog(eTogsType.Custom)
  end
end

UIEpBuffDesc.RefershDescriptPageEpBuff = function(self, TogType, aniTimeScale)
  -- function num : 0_11 , upvalues : _ENV
  if self.__curTogType then
    local hideItemList = (self.__pageList)[self.__curTogType]
    for _,item in ipairs(hideItemList) do
      item:Hide()
    end
  end
  do
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).scrollRect_list).horizontalScrollbar = self.__cacheScrollRectScrollbar
    local showItemList = (self.__pageList)[TogType]
    for _,item in ipairs(showItemList) do
      item:Show()
    end
    self.__curTogType = TogType
    if not self.__posDescPageContent then
      self.__posDescPageContent = (((self.ui).descPage_hLayout).transform).localPosition
    end
    self:_PlayBuffShowAni(showItemList, aniTimeScale, function()
    -- function num : 0_11_0 , upvalues : self
    if not self.__originContent then
      self.__originContent = ((self.ui).scrollRect_list).content
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (((self.ui).descPage_hLayout).transform).localPosition = self.__posDescPageContent
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).scrollRect_list).content = ((self.ui).descPage_hLayout).transform
  end
)
  end
end

UIEpBuffDesc.RefershEpBuffDesc = function(self, buffList, aniTimeScale)
  -- function num : 0_12 , upvalues : _ENV
  (self.buffDescItemPool):HideAll()
  for index,epBuff in ipairs(buffList) do
    if index <= 4 then
      do
        local item = (self.buffDescItemPool):GetOne(true)
        item:InitBuffDescItem(epBuff)
        -- DECOMPILER ERROR at PC16: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC16: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  self:_PlayBuffShowAni((self.buffDescItemPool).listItem, aniTimeScale, function()
    -- function num : 0_12_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).hLayout).enabled = false
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).contentSize).enabled = false
  end
, function()
    -- function num : 0_12_1 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R0 in 'UnsetPending'

    if not IsNull(self.gameobject) then
      ((self.ui).hLayout).enabled = true
      -- DECOMPILER ERROR at PC10: Confused about usage of register: R0 in 'UnsetPending'

      ;
      ((self.ui).contentSize).enabled = true
    end
  end
)
end

UIEpBuffDesc._PlayBuffShowAni = function(self, showLsit, timeScale, onStartCallback, onCompleteCallback)
  -- function num : 0_13 , upvalues : _ENV, cs_DoTween
  (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
  if self._showSeq ~= nil then
    (self._showSeq):Complete()
    ;
    (self._showSeq):Kill()
    self._showSeq = nil
    if self.__onCompleteCallback then
      (self.__onCompleteCallback)()
    end
  end
  if onStartCallback then
    onStartCallback()
  end
  self.__onCompleteCallback = onCompleteCallback
  local count = #showLsit
  if count > 0 then
    local intervalSec = 0.15
    if count > 4 then
      intervalSec = 0.6 / count
    end
    local sequence = (cs_DoTween.Sequence)()
    for index,item in ipairs(showLsit) do
      if index <= 5 then
        do
          local delay = (index - 1) * (intervalSec)
          sequence:Insert(0, ((((item.transform):DOAnchorPosY(((item.transform).anchoredPosition).y - 100, 0.5)):From()):SetDelay(delay)):SetLink(item.gameObject))
          sequence:Insert(0, (((((item.ui).fade):DOFade(0, 0.5)):From()):SetDelay(delay)):SetLink(item.gameObject))
          -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC78: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    sequence:PrependInterval(0.05)
    sequence:OnComplete(function()
    -- function num : 0_13_0 , upvalues : self
    if self.__onCompleteCallback then
      (self.__onCompleteCallback)()
    end
  end
)
    sequence:SetUpdate(true)
    if not timeScale then
      timeScale = 1
    end
    sequence.timeScale = timeScale
    self._showSeq = sequence
    if self._emptyTipActive then
      (((self.ui).tex_EmptyTip).gameObject):SetActive(false)
      self._emptyTipActive = false
    end
  else
    do
      if not self._emptyTipActive then
        (((self.ui).tex_EmptyTip).gameObject):SetActive(true)
        self._emptyTipActive = true
      end
    end
  end
end

UIEpBuffDesc.InitDunBuffDesc = function(self, buffCfgList, closeCallback)
  -- function num : 0_14
  self:InitEpBuffDesc(buffCfgList, closeCallback, self._refershDunBuffDesc)
end

UIEpBuffDesc.RefershDunBuffDesc = function(self, buffCfgList)
  -- function num : 0_15 , upvalues : _ENV
  (self.buffDescItemPool):HideAll()
  for index,buffCfg in ipairs(buffCfgList) do
    if index <= 4 then
      do
        local item = (self.buffDescItemPool):GetOne(true)
        item:InitBuffDescItemByCfg(buffCfg)
        -- DECOMPILER ERROR at PC16: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC16: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  self:_PlayBuffShowAni((self.buffDescItemPool).listItem, nil, function()
    -- function num : 0_15_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).hLayout).enabled = false
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).contentSize).enabled = false
  end
, function()
    -- function num : 0_15_1 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).hLayout).enabled = true
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    ;
    ((self.ui).contentSize).enabled = true
  end
)
end

UIEpBuffDesc._OnTimeOver = function(self)
  -- function num : 0_16 , upvalues : _ENV
  if IsNull(self.transform) then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).Img_Bg).raycastTarget = true
  if not self.__originContent then
    (((self.ui).ani_textContinue).gameObject):SetActive(true)
  end
end

UIEpBuffDesc.BackAction = function(self)
  -- function num : 0_17 , upvalues : _ENV, cs_DoTween
  if not self._openFlyAni then
    self:Delete()
    if self.closeCallback ~= nil then
      (self.closeCallback)()
    end
    return 
  end
  ;
  (UIUtil.AddOneCover)("UIEpBuffDesc")
  local seq = (cs_DoTween.Sequence)()
  local posList = {}
  for i,item in pairs((self.buffDescItemPool).listItem) do
    (table.insert)(posList, (item.transform).localPosition)
  end
  local destPos = ((self.ui).defaultPos).position
  local chessMainWindow = UIManager:GetWindow(UIWindowTypeID.WarChessMain)
  do
    if chessMainWindow ~= nil then
      local pos = chessMainWindow:GetWCMTopBuffPos()
      if pos ~= nil then
        destPos = pos
      end
    end
    for index,item in ipairs((self.buffDescItemPool).listItem) do
      item:StartBuffDescFlySeq(seq, destPos, posList[index])
    end
    seq.timeScale = self._openFlyAniTimeScale
    seq:SetLink(self.gameObject)
    seq:OnComplete(function()
    -- function num : 0_17_0 , upvalues : self
    self:Delete()
    if self.closeCallback ~= nil then
      (self.closeCallback)()
    end
  end
)
    seq:SetUpdate(true)
  end
end

UIEpBuffDesc._OnBackgroundClick = function(self)
  -- function num : 0_18 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIEpBuffDesc._OnClickBuffItem = function(self, buffItem, epBuff)
  -- function num : 0_19
  if self._lastSelectBuffItem ~= nil then
    (self._lastSelectBuffItem):SetBuffDescItemSelect(false)
  end
  buffItem:SetBuffDescItemSelect(true)
  self._lastSelectBuffItem = buffItem
  self._selectedBuffId = epBuff.dataId
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).btn_Check).interactable = true
end

UIEpBuffDesc._OnClickBtnCheck = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local net = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  net:CS_EXPLORATION_OpeninBuffSelect(self._selectedBuffId, function()
    -- function num : 0_20_0 , upvalues : _ENV
    (UIUtil.OnClickBack)()
  end
)
end

UIEpBuffDesc.OnHide = function(self)
  -- function num : 0_21
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self.__originContent then
    (((self.ui).descPage_hLayout).transform).localPosition = self.__posDescPageContent
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).scrollRect_list).content = self.__originContent
    self.__originContent = nil
  end
end

UIEpBuffDesc.OnDelete = function(self)
  -- function num : 0_22 , upvalues : _ENV, base
  (UIUtil.CloseOneCover)("UIEpBuffDesc")
  if self._timeID ~= nil then
    TimerManager:StopTimer(self._timerID)
    self._timerID = nil
  end
  ;
  ((self.ui).ani_textContinue):DOKill()
  if self._showSeq ~= nil then
    (self._showSeq):Kill()
    self._showSeq = nil
  end
  self.__posDescPageContent = nil
  self.__pageList = nil
  ;
  (self.buffDescItemPool):DeleteAll()
  ;
  (self.descPageItemPool):DeleteAll()
  ;
  (self.buffTogs):Delete()
  ;
  (base.OnDelete)(self)
end

return UIEpBuffDesc

