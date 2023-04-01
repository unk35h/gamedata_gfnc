-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWin21DungeonLevel = class("UIWin21DungeonLevel", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
local cs_MessageCommon = CS.MessageCommon
local UINAWDunLevelItem = require("Game.ActivitySectorII.Dungeon.UI.UINAWDunLevelItem")
local UINAWDunLine = require("Game.ActivitySectorII.Dungeon.UI.UINAWDunLine")
local UINAWDunChallenge = require("Game.ActivitySectorII.Dungeon.UI.Challenge.UINAWDunChallenge")
UIWin21DungeonLevel.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINAWDunLevelItem, UINAWDunLine, UINAWDunChallenge
  self.resloader = (cs_ResLoader.Create)()
  self.__dunDataDic = nil
  self.__dunOrderList = nil
  self.levelItemDic = {}
  self.__selectDunData = nil
  self.__OnClickWADunItem = BindCallback(self, self.OnClickWADunItem)
  self.__showIntroduce = BindCallback(self, self.__ShowIntroduce)
  ;
  (UIUtil.SetTopStatus)(self, self.__OnReturnClick, nil, self.__showIntroduce)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickBackGround)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_IsDouble, self, self.__OnClickChangeMultEffic)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PointUp, self, self.__OnClickPointUp)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_res, self, self.__OnClickTicketRes)
  self.levelItemPool = (UIItemPool.New)(UINAWDunLevelItem, (self.ui).obj_levelItem)
  ;
  ((self.ui).obj_levelItem):SetActive(false)
  self.levelLinePool = (UIItemPool.New)(UINAWDunLine, (self.ui).obj_lineItem)
  ;
  ((self.ui).obj_lineItem):SetActive(false)
  self._challengeNode = (UINAWDunChallenge.New)()
  ;
  (self._challengeNode):Init((self.ui).challengeItem)
  self.__onActTechChange = BindCallback(self, self.__OnActTechChange)
  MsgCenter:AddListener(eMsgEventId.ActivityTechChange, self.__onActTechChange)
  self.__updateTopCurrencys = BindCallback(self, self.RefreshTicketCount)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  self:__SetDungeonSelectUI(false)
end

UIWin21DungeonLevel.InitWADungeon = function(self, actId, barWin, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.actId = actId
  self.barWin = barWin
  self.closeCallback = closeCallback
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local SectorIIData = sectorIICtrl:GetSectorIIDataByActId(actId)
  self.__SectorIIData = SectorIIData
  self.__dunDataDic = SectorIIData:GetSectorIIDungeonDataDic()
  self:RefreshWADunItem()
  self:RefreshWADunLine()
  if not self._OnClickChallengeFunc then
    self._OnClickChallengeFunc = BindCallback(self, self._OnClickChallenge)
    ;
    (self._challengeNode):InitAWDunChallenge(SectorIIData, self._OnClickChallengeFunc)
    self.techID = SectorIIData:GetTechId()
    self.tickId = SectorIIData:GetSectorIIDunTicketId()
    self:__InitTicketUI()
    self:RefreshPointMultRate()
    self:RefreshMultEffi()
    self:__ShowWADunItemTween()
  end
end

UIWin21DungeonLevel.__InitTicketUI = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local cfg = (ConfigData.item)[self.tickId]
  if cfg == nil then
    error("Can`t find item cfg. id:" .. self.tickId)
    return 
  end
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Res).sprite = CRH:GetSprite(cfg.small_icon)
  self:RefreshTicketCount()
end

UIWin21DungeonLevel.__OnActTechChange = function(self)
  -- function num : 0_3
  self:RefreshPointMultRate()
  self:RefreshMultEffi()
end

UIWin21DungeonLevel.RefreshWADunItem = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.levelItemPool):HideAll()
  for _,dunStageId in ipairs(self.__dunOrderList) do
    local SIIDunData = (self.__dunDataDic)[dunStageId]
    local dunItem = (self.levelItemPool):GetOne()
    dunItem:RefreshWADunLevelItem(SIIDunData, self.__OnClickWADunItem)
  end
end

UIWin21DungeonLevel.RefreshWADunLine = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (self.levelLinePool):HideAll()
  local lastLevelPos, cueLevelPos = nil, nil
  for index,dunStageId in ipairs(self.__dunOrderList) do
    local nextDunData = (self.__dunDataDic)[dunStageId]
    cueLevelPos = nextDunData:GetAWDungeonPos()
    do
      do
        if index > 1 then
          local lineItem = (self.levelLinePool):GetOne()
          lineItem:RefreshAWDunLine(lastLevelPos, cueLevelPos, nextDunData)
        end
        lastLevelPos = cueLevelPos
        -- DECOMPILER ERROR at PC24: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

UIWin21DungeonLevel.RefreshMultEffi = function(self)
  -- function num : 0_6
  local isCouldUsingMultEffi = (self.__SectorIIData):GetSectorII_EffiMultRate() > 0
  ;
  (((self.ui).btn_IsDouble).gameObject):SetActive(isCouldUsingMultEffi)
  do
    if isCouldUsingMultEffi then
      local isUsingMultEffi = (self.__SectorIIData):GetSectorII_IsTurnOnMultEffi()
      ;
      ((self.ui).obj_image_marker):SetActive(isUsingMultEffi)
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIWin21DungeonLevel.RefreshPointMultRate = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local pointMultRateDic = (self.__SectorIIData):GetSectorII_PointMultRat()
  local poitId = (self.__SectorIIData):GetSectorIIDunPointId()
  local multRata = pointMultRateDic[poitId] or 0
  local isHaveMultRate = multRata > 0
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).btn_PointUp).interactable = not isHaveMultRate
  if isHaveMultRate then
    ((self.ui).tex_PointMultNum):SetIndex(0, GetPreciseDecimalStr(multRata / 10, 0))
  else
    ((self.ui).tex_PointMultNum):SetIndex(1)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWin21DungeonLevel.RefreshTicketCount = function(self)
  -- function num : 0_8 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Res).text = PlayerDataCenter:GetItemCount(self.tickId)
end

UIWin21DungeonLevel.OnClickWADunItem = function(self, dunItem)
  -- function num : 0_9 , upvalues : _ENV
  local SIIDunData = dunItem.SIIDunData
  if self.__selectDunData == SIIDunData then
    return 
  end
  ;
  (self.barWin):Hide()
  self.__selectDunData = SIIDunData
  self.__selectItemPos = dunItem:GetAWDunLevelAnchoredPos()
  local parent = dunItem:GetStageHolderRect()
  local sizeDelta = (Vector2.New)(141, 145)
  self:__SetDungeonSelectParent(parent, sizeDelta)
  self:__SetDungeonSelectUI(true)
  local isLocked = not SIIDunData:GetIsLevelUnlock()
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(window)
    -- function num : 0_9_0 , upvalues : _ENV, self, SIIDunData, isLocked
    if window == nil then
      return 
    end
    window:SetDunLevelDetaiHideStartEvent(function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self
      if IsNull(self.gameObject) then
        error("UIWin21DungeonLevel gameobject is nil")
        return 
      end
      self:__CancelSelect()
      self:__PlayMoveLeftTween(false)
    end
)
    window:SetDunLevelDetaiHideEndEvent(nil)
    local width, duration = window:GetDLevelDetailWidthAndDuration()
    self:__PlayMoveLeftTween(true, width, duration)
    window:InitDungeonLevelDetail(SIIDunData, isLocked)
  end
)
end

UIWin21DungeonLevel._OnClickChallenge = function(self, challengeNode, challengeDgData)
  -- function num : 0_10 , upvalues : _ENV
  if self.__selectDunData == challengeDgData then
    return 
  end
  ;
  (self.barWin):Hide()
  self.__selectDunData = challengeDgData
  self.__selectItemPos = (challengeNode.transform).anchoredPosition
  local parent = challengeNode.transform
  local sizeDelta = (Vector2.New)(570, 190)
  self:__SetDungeonSelectParent(parent, sizeDelta)
  self:__SetDungeonSelectUI(true)
  local isLocked = not challengeDgData:GetIsLevelUnlock()
  UIManager:ShowWindowAsync(UIWindowTypeID.DungeonLevelDetail, function(window)
    -- function num : 0_10_0 , upvalues : self, challengeDgData, isLocked
    if window == nil then
      return 
    end
    window:SetDunLevelDetaiHideStartEvent(function()
      -- function num : 0_10_0_0 , upvalues : self
      self:__CancelSelect()
      self:__PlayMoveLeftTween(false)
    end
)
    window:SetDunLevelDetaiHideEndEvent(nil)
    local width, duration = window:GetDLevelDetailWidthAndDuration()
    self:__PlayMoveLeftTween(true, width, duration)
    window:InitDungeonLevelDetail(challengeDgData, isLocked)
  end
)
end

UIWin21DungeonLevel.__CancelSelect = function(self)
  -- function num : 0_11
  if self.__selectDunData == nil then
    return 
  end
  ;
  (self.barWin):Show()
  self:__SetDungeonSelectUI(false)
  self.__selectDunData = nil
end

UIWin21DungeonLevel.__OnClickBackGround = function(self)
  -- function num : 0_12 , upvalues : _ENV
  if self.__selectDunData ~= nil then
    (UIUtil.OnClickBack)()
  end
  self.__selectDunData = nil
end

UIWin21DungeonLevel.__OnClickChangeMultEffic = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local bool = not (self.__SectorIIData):GetSectorII_IsTurnOnMultEffi()
  ;
  (self.__SectorIIData):SetSectorII_IsTurnOnMultEffi(bool)
  self:RefreshMultEffi()
  local dunLevelDetailWin = UIManager:GetWindow(UIWindowTypeID.DungeonLevelDetail)
  if dunLevelDetailWin ~= nil then
    dunLevelDetailWin:RefreshDunLevelDetaiEnterCost()
  end
end

UIWin21DungeonLevel.__OnClickPointUp = function(self)
  -- function num : 0_14 , upvalues : _ENV, cs_MessageCommon
  local msg = ""
  local techID = self.techID or 0
  local techData = (self.__SectorIIData):GetTechById(techID)
  if techData == nil then
    return 
  end
  local str = (LanguageUtil.GetLocaleText)((techData.techCfg).name)
  msg = (string.format)(ConfigData:GetTipContent(7103), str)
  ;
  (cs_MessageCommon.ShowMessageTipsWithErrorSound)(msg)
end

UIWin21DungeonLevel.__OnClickTicketRes = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[self.tickId]
  local window = UIManager:ShowWindow(UIWindowTypeID.GlobalItemDetail)
  window:InitCommonItemDetail(itemCfg)
end

UIWin21DungeonLevel.__OnReturnClick = function(self)
  -- function num : 0_16
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self:Delete()
end

UIWin21DungeonLevel.__SetDungeonSelectUI = function(self, enabled)
  -- function num : 0_17
  ((self.ui).obj_DunSel):SetActive(enabled)
end

UIWin21DungeonLevel.__SetDungeonSelectParent = function(self, parent, sizeDelta)
  -- function num : 0_18 , upvalues : _ENV
  (((self.ui).obj_DunSel).transform):SetParent(parent)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_DunSel).transform).localPosition = Vector3.zero
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).obj_DunSel).transform).sizeDelta = sizeDelta
end

UIWin21DungeonLevel.__ShowWADunItemTween = function(self)
  -- function num : 0_19 , upvalues : cs_DoTween, _ENV, cs_Ease
  if self.__showSeq ~= nil then
    (self.__showSeq):Restart()
  end
  local showSeq = (cs_DoTween.Sequence)()
  showSeq:SetAutoKill(false)
  local limitCount = #(self.levelItemPool).listItem
  for k,item in ipairs((self.levelItemPool).listItem) do
    local point = item:GetPointUI()
    local title = item:GetTitleUI()
    local pk = (k - 1) * 0.15
    local tk = (limitCount - 1) * 0.15 + pk
    showSeq:Insert(pk, ((point:DOScale((Vector3.New)(0, 0, 1), 0.4)):SetEase(cs_Ease.OutBack)):From())
    showSeq:Insert(tk, (title:DOSizeDelta((Vector2.New)(-330.3623, 86), 0.45)):From())
  end
  for k,line in ipairs((self.levelLinePool).listItem) do
    local lk = k * 0.15
    local tran = line.transform
    showSeq:Insert(lk, (tran:DOSizeDelta((Vector3.New)(0, 4, 1), 0.4)):From())
  end
  showSeq:OnComplete(function()
    -- function num : 0_19_0 , upvalues : _ENV, self
    for k,item in ipairs((self.levelItemPool).listItem) do
      item:SetTexTileBestFit(true)
    end
  end
)
  self.__showSeq = showSeq
end

local BgX = (UIManager.BackgroundStretchSize).x
local n = BgX * (((CS.UIManager).Instance).CurNotchValue / 100)
UIWin21DungeonLevel.__PlayMoveLeftTween = function(self, isLeft, offset, duration)
  -- function num : 0_20 , upvalues : BgX, n, _ENV
  ((self.ui).rect_map):DOKill()
  local map = (self.ui).rect_map
  if not isLeft then
    map:DOLocalMoveX(0, self.duration)
    self.duration = 0
    return 
  end
  local mid = (BgX - offset) / 2
  local move = mid - (self.__selectItemPos).x - n
  move = (math.clamp)(move, -offset, 0)
  map:DOLocalMoveX(move, duration)
  self.duration = duration
end

UIWin21DungeonLevel.__ShowIntroduce = function(self)
  -- function num : 0_21 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((ConfigData.game_config).win21GuideNum, nil)
end

UIWin21DungeonLevel.OnDelete = function(self)
  -- function num : 0_22 , upvalues : _ENV, base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.__showSeq ~= nil then
    (self.__showSeq):Kill()
    self.__showSeq = nil
  end
  ;
  ((self.ui).rect_map):DOKill()
  ;
  (self._challengeNode):Delete()
  MsgCenter:RemoveListener(eMsgEventId.ActivityTechChange, self.__onActTechChange)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__updateTopCurrencys)
  ;
  (base.OnDelete)(self)
end

return UIWin21DungeonLevel

