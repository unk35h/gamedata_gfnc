-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDay = class("UIWhiteDay", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local ActivityWhiteDayEnum = require("Game.ActivityWhiteDay.ActivityWhiteDayEnum")
local JumpManager = require("Game.Jump.JumpManager")
local UINWhiteDayLineSlotNode = require("Game.ActivityWhiteDay.UI.UINWhiteDayLineSlotNode")
local UINWhiteDayInfoBtnNode = require("Game.ActivityWhiteDay.UI.UINWhiteDayInfoBtnNode")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
UIWhiteDay.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, UINWhiteDayInfoBtnNode, _ENV, UINWhiteDayLineSlotNode
  self.resloader = (cs_ResLoader.Create)()
  self.lineId2ItemDic = {}
  self.lineTimerId = nil
  self.infoBtnNode = (UINWhiteDayInfoBtnNode.New)()
  ;
  (self.infoBtnNode):Init((self.ui).obj_btn_Info)
  self.slotItemPool = (UIItemPool.New)(UINWhiteDayLineSlotNode, (self.ui).obj_OrderSlot)
  ;
  ((self.ui).obj_OrderSlot):SetActive(false)
  self.__showIntroduce = BindCallback(self, self.__ShowIntroduce)
  ;
  (UIUtil.SetTopStatus)(self, self.__OnClickClose, nil, self.__showIntroduce)
  self.__onPop2Front = BindCallback(self, self.__TryPhotoGuide)
  ;
  (UIUtil.SetBack2FrontCallback)(self.__onPop2Front)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickWDFactoryInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Photo, self, self.OnClickWDPhotoAlbum)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.OnClickWDTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SectorLv, self, self.OnClickWDSectorLevel)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_miniGame, self, self.OnClickWDMiniGame)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HideUI, self, self.OnBtnHideUI)
  self.__onWDOrderChanged = BindCallback(self, self.__OnWDOrderChanged)
  MsgCenter:AddListener(eMsgEventId.WhiteDayOrderChange, self.__onWDOrderChanged)
  self.__TaskUpdateCallback = BindCallback(self, self.__TaskUpdate)
  MsgCenter:AddListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  self.__photoUpdate = BindCallback(self, self.__PhotoUpdate)
  MsgCenter:AddListener(eMsgEventId.WhiteDayPhotoChange, self.__photoUpdate)
end

UIWhiteDay.InitWhiteDayUI = function(self, AWDCtrl, AWDData)
  -- function num : 0_1 , upvalues : ActivityFrameUtil, _ENV
  self.AWDCtrl = AWDCtrl
  self.AWDData = AWDData
  self._endtime = AWDData:GetActivityEndTime()
  local title, timeStr = (ActivityFrameUtil.GetShowEndTimeStr)(AWDData)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Time).text = timeStr
  ;
  (self.infoBtnNode):InitWhiteDayInfoNode(AWDCtrl, AWDData)
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  self.lineTimerId = TimerManager:StartTimer(1, self.__OnWDTimeUpdate, self, false, nil, true)
  self:__OnWDTimeUpdate()
  self:RefreshOrderSlotNodes()
  self:__InitWDTaskReddot()
  self:__InitWDPhotoReddot()
  self:__PhotoUpdate()
end

UIWhiteDay.RefreshOrderSlotNodes = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local lineList = (self.AWDData):GetWDFactoryAllLineList()
  ;
  (self.slotItemPool):HideAll()
  for _,lineId in pairs(lineList) do
    local item = (self.slotItemPool):GetOne()
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.lineId2ItemDic)[lineId] = item
    local AWDLineData = (self.AWDData):GetWDFactoryLineData(lineId)
    item:InitWhiteDayLineSlot(self.AWDCtrl, AWDLineData, self.resloader)
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (item.transform).anchoredPosition = (self.AWDCtrl):GetWDFactoryLineUIPos(lineId)
  end
end

UIWhiteDay.__OnWDTimeUpdate = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityFrameUtil
  for lineId,slotItem in pairs(self.lineId2ItemDic) do
    slotItem:RefreshAWDOrderProcess()
  end
  local countdownStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._endtime)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Days).text = countdownStr
end

UIWhiteDay.__OnWDOrderChanged = function(self, changedLineId, isAcc)
  -- function num : 0_4 , upvalues : _ENV
  (self.infoBtnNode):RefreshWDInfoNode()
  for lineId,slotItem in pairs(self.lineId2ItemDic) do
    slotItem:RefreshAWDLineSlot()
    if lineId == changedLineId and isAcc then
      slotItem:WDSlotPlayAccEffect()
    end
  end
  self:__TryPhotoGuide()
end

UIWhiteDay.OnClickWDFactoryInfo = function(self)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayFactoryLevel, function(window)
    -- function num : 0_5_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitWDFactoryLevel(self.AWDData)
  end
)
end

UIWhiteDay.OnClickWDPhotoAlbum = function(self)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayAlbum, function(window)
    -- function num : 0_6_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitWDAlbun(self.AWDCtrl, self.AWDData)
  end
)
end

UIWhiteDay.OnClickWDTask = function(self)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayTask, function(window)
    -- function num : 0_7_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitWDTask(self.AWDCtrl, self.AWDData)
  end
)
end

UIWhiteDay.OnClickWDSectorLevel = function(self)
  -- function num : 0_8
  (self.AWDCtrl):OpenWhitrDaySector(self.AWDData)
end

UIWhiteDay.OnBtnHideUI = function(self)
  -- function num : 0_9
  ((self.AWDCtrl):GetWhiteDaySceneCtrl()):EnterWDCameraControlMode()
end

UIWhiteDay.OnClickWDMiniGame = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivityWhiteDayEnum
  local Game2048Controller = require("Game.TinyGames.2048.Game2048Controller")
  local gameCtrl = (Game2048Controller.New)()
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task)
  gameCtrl:InitGame2048(((self.AWDData).actInfo).id, (self.AWDData):GetAWDGame2048Id(), node, nil, nil, true)
  gameCtrl:Set2048CtrlDeleteCallback(function()
    -- function num : 0_10_0 , upvalues : self
    (self.AWDCtrl):SetWD2048GameCtrl(nil)
  end
)
  ;
  (self.AWDCtrl):SetWD2048GameCtrl(gameCtrl)
end

UIWhiteDay.__ShowIntroduce = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local tips = ((self.AWDData):GetWDCfg()).tips
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)(tips)
end

UIWhiteDay.__InitWDTaskReddot = function(self)
  -- function num : 0_12 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task)
  if isOk then
    if self.__refresnTaskReddot == nil then
      self.__refresnTaskReddot = function(node)
    -- function num : 0_12_0 , upvalues : self
    ((self.ui).obj_TaskRedDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnTaskReddot)
    ;
    (self.__refresnTaskReddot)(node)
  end
end

UIWhiteDay.__RemoveWDTaskReddot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).task)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnTaskReddot)
  end
  self.__refresnTaskReddot = nil
end

UIWhiteDay.__InitWDPhotoReddot = function(self)
  -- function num : 0_14 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).photoNode)
  if isOk then
    if self.__refresnPhotoReddot == nil then
      self.__refresnPhotoReddot = function(node)
    -- function num : 0_14_0 , upvalues : self
    ((self.ui).obj_PhotoBlueDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnPhotoReddot)
    ;
    (self.__refresnPhotoReddot)(node)
  end
end

UIWhiteDay.__RemoveWDPhotoReddot = function(self)
  -- function num : 0_15 , upvalues : _ENV, ActivityWhiteDayEnum
  local actFrameId = (self.AWDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActivityWhiteDayEnum.redDotType).photoNode)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnPhotoReddot)
  end
  self.__refresnPhotoReddot = nil
end

UIWhiteDay.SetWDCanvasGroupState = function(self, active)
  -- function num : 0_16
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).canvasGroup).blocksRaycasts = active
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

  if active then
    ((self.ui).canvasGroup).alpha = 1
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup).alpha = 0
  end
end

UIWhiteDay.__TaskUpdate = function(self, taskData)
  -- function num : 0_17 , upvalues : _ENV
  for k,v in pairs((self.slotItemPool).listItem) do
    v:TryRefreshWDEventTween(taskData)
  end
end

UIWhiteDay.__PhotoUpdate = function(self)
  -- function num : 0_18 , upvalues : _ENV
  local unlockedNum = (self.AWDData):GetWDUnlockedPhotoNum()
  local allNum = (self.AWDData):GetWDAllPhotoNum()
  ;
  ((self.ui).tex_PhotoNum):SetIndex(0, tostring(unlockedNum), tostring(allNum))
end

UIWhiteDay.__TryPhotoGuide = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if (self.AWDData):GetWDUnlockedPhotoNum() == 0 then
    local randomId, randomNum = (self.AWDData):GetWDRandomPhotoItemIdAndNum()
    local exchangeId, exchangeNum = (self.AWDData):GetWDExchangePhotoItemIdAndNum()
    local randomNum = PlayerDataCenter:GetItemCount(randomId) // randomNum
    local exchangeNum = PlayerDataCenter:GetItemCount(exchangeId) // exchangeNum
    if randomNum + exchangeNum > 0 then
      GuideManager:StartNewTriggerGuide(6030002)
    end
  end
end

UIWhiteDay.__OnClickClose = function(self, toHome)
  -- function num : 0_20
  self:Delete()
  ;
  (self.AWDCtrl):CloseWhiteDay()
end

UIWhiteDay.OnDelete = function(self)
  -- function num : 0_21 , upvalues : _ENV, base
  if self.lineTimerId ~= nil then
    TimerManager:StopTimer(self.lineTimerId)
    self.lineTimerId = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  self:__RemoveWDTaskReddot()
  self:__RemoveWDPhotoReddot()
  ;
  (self.slotItemPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.WhiteDayOrderChange, self.__onWDOrderChanged)
  MsgCenter:RemoveListener(eMsgEventId.TaskUpdate, self.__TaskUpdateCallback)
  MsgCenter:RemoveListener(eMsgEventId.WhiteDayPhotoChange, self.__photoUpdate)
  ;
  (base.OnDelete)(self)
end

return UIWhiteDay

