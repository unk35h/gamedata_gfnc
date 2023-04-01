-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWinterActivityMainMap = class("UIWinterActivityMainMap", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local UINWAMMMapNode = require("Game.ActivitySectorII.MainMap.UI.UINWAMMMapNode")
local JumpManager = require("Game.Jump.JumpManager")
local TaskEnum = require("Game.Task.TaskEnum")
local ActivitySectorIIEnum = require("Game.ActivitySectorII.ActivitySectorIIEnum")
UIWinterActivityMainMap.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV
  self.actId = nil
  self.actFrameId = nil
  self.resloader = (cs_ResLoader.Create)()
  self.mapNode = nil
  self.__barWin = nil
  self.__SetWAMapInfoNodeActive = BindCallback(self, self.SetWAMapInfoNodeActive)
  self.__showIntroduce = BindCallback(self, self.__ShowIntroduce)
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickClose, nil, self.__showIntroduce)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Challenge, self, self.OnClickWADungeon)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_FlappyBird, self, self.OnClickFlappyBird)
end

UIWinterActivityMainMap.PlayWinterActivityMainMapBgm = function(self)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3110)
  AudioManager:SetSourceSelectorLabel(eAudioSourceType.BgmSource, (eAuSelct.Sector).name, (eAuSelct.Sector).levelSelect)
end

UIWinterActivityMainMap.InitWAMainMap = function(self, actId, cantShowDetail)
  -- function num : 0_2 , upvalues : _ENV, UINWAMMMapNode
  self:PlayWinterActivityMainMapBgm()
  self.actId = actId
  self.__barWin = UIManager:ShowWindow(UIWindowTypeID.Win21SectorBar)
  ;
  (self.__barWin):InitSectorBar(actId)
  if self.mapNode == nil then
    self.mapNode = (UINWAMMMapNode.New)()
    ;
    (self.mapNode):Init((self.ui).obj_map)
  end
  ;
  (self.mapNode):InitWAMMMap(self.transform, self.actId, self.__SetWAMapInfoNodeActive, self.resloader, cantShowDetail)
  local sectorIICtrl = ControllerManager:GetController(ControllerTypeId.SectorII)
  local SectorIIData = sectorIICtrl:GetSectorIIDataByActId(self.actId)
  self.SectorIIData = SectorIIData
  self.actFrameId = SectorIIData:GetSectorIIActFrameId()
  ;
  (PlayerDataCenter.sectorStage):SetSelectSectorId(SectorIIData:GetSectorIISectorId())
  local activityFrameData = SectorIIData:GetActivityFrameData()
  local endTime = activityFrameData:GetActivityEndTime()
  self:RefreshActTime(endTime)
  local isFinished = not SectorIIData:IsActivityRunning()
  if isFinished then
    self:ShowActivtyFinishedUI()
  else
    self:RefreshActivityEndTime(endTime)
    self:SetIsFinishedUI(false)
    self.__timerId = TimerManager:StartTimer(1, function()
    -- function num : 0_2_0 , upvalues : self, endTime
    self:RefreshActivityEndTime(endTime)
  end
, self, false, false, false)
  end
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:OnEnterActivity()
  end
  self:__InitSectorIIDungeonReddot()
  if (self.SectorIIData):GetSectorIIActivityIsRemaster() then
    ((self.ui).obj_remasterTag):SetActive(true)
  else
    ;
    ((self.ui).obj_remasterTag):SetActive(false)
  end
  GuideManager:TryTriggerGuide(eGuideCondition.ActSectorIIMain)
end

UIWinterActivityMainMap.OnClickFlappyBird = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if not (self.SectorIIData):IsActivityRunning() then
    return 
  end
  local activityFwId = (self.SectorIIData):GetSectorIIActFrameId()
  local birdConfigId = (self.SectorIIData):GetSectorIIFlappyBirdId()
  local joinRewards = (self.SectorIIData):GetSectorIIFlappyBirdIsJoinRewards()
  local maxScore = (self.SectorIIData):GetSectorIIFlappyBirdMineMaxScore()
  local setMaxScore = BindCallback(self.SectorIIData, (self.SectorIIData).SetSectorIIFlappyBirdMineMaxScore)
  local setJoinRewards = BindCallback(self.SectorIIData, (self.SectorIIData).SetSectorIIFlappyBirdIsJoinRewards)
  ;
  (UIUtil.HideTopStatus)()
  local activityFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local playEndTime = ((self.SectorIIData):GetActivityEndTime())
  local ctrl = nil
  if (self.SectorIIData):GetSectorIIActivityIsRemaster() then
    ctrl = ((require("Game.TinyGames.FlappyBird.Ctrl.FlappyBirdController")).New)(activityFwId, birdConfigId, joinRewards, maxScore, nil, nil, true)
  else
    ctrl = ((require("Game.TinyGames.FlappyBird.Ctrl.FlappyBirdController")).New)(activityFwId, birdConfigId, joinRewards, maxScore)
  end
  ctrl:SetFlappyBirdActEndTime(playEndTime)
  ctrl:InjectExitAction(function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    (UIUtil.ReShowTopStatus)()
    self:PlayWinterActivityMainMapBgm()
  end
)
  ctrl:InjectModifyBirdMsgAction(setMaxScore, setJoinRewards)
  ctrl:ShowFlappyBirdUI()
  AudioManager:PlayAudioById(1139)
end

UIWinterActivityMainMap.OnClickWADungeon = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if not (self.SectorIIData):IsActivityRunning() then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.ActivityWinterDungeon, function(win)
    -- function num : 0_4_0 , upvalues : self
    if win ~= nil then
      if self.waDungeonCallBack then
        (self.waDungeonCallBack)()
        self.waDungeonCallBack = nil
      end
      self:Hide()
      ;
      ((self.__barWin).transform):SetAsLastSibling()
      win:InitWADungeon(self.actId, self.__barWin, function()
      -- function num : 0_4_0_0 , upvalues : self
      self:Show()
      ;
      (self.mapNode):SetDetailCantShow(false)
    end
)
    end
  end
)
end

UIWinterActivityMainMap.SetWADungeonCallBack = function(self, callBack)
  -- function num : 0_5
  self.waDungeonCallBack = callBack
end

UIWinterActivityMainMap.RefreshActivityEndTime = function(self, timestamp)
  -- function num : 0_6 , upvalues : _ENV
  if timestamp == -1 then
    ((self.ui).tex_ActLeftDay):SetIndex(3)
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_ActEndTime).text = "N/A"
    return 
  end
  if timestamp < PlayerDataCenter.timestamp then
    TimerManager:StopTimer(self.__timerId)
    return 
  end
  local remainTime = timestamp - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remainTime, false, true)
  if d > 0 then
    ((self.ui).tex_ActLeftDay):SetIndex(0, tostring(d))
  else
    if h > 0 then
      ((self.ui).tex_ActLeftDay):SetIndex(1, (string.format)("%02d", h))
    else
      if m <= 0 or not m then
        m = 1
      end
      ;
      ((self.ui).tex_ActLeftDay):SetIndex(2, (string.format)("%02d", m))
    end
  end
end

UIWinterActivityMainMap.RefreshActTime = function(self, timestamp)
  -- function num : 0_7 , upvalues : _ENV
  local date = TimeUtil:TimestampToDate(timestamp)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ActEndTime).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
end

UIWinterActivityMainMap.SetWAMapInfoNodeActive = function(self, bool)
  -- function num : 0_8
  ((self.ui).obj_infoNode):SetActive(bool)
  if bool then
    (self.__barWin):Show()
  else
    ;
    (self.__barWin):Hide()
  end
end

UIWinterActivityMainMap.ShowActivtyFinishedUI = function(self)
  -- function num : 0_9
  ((self.ui).tex_ActLeftDay):SetIndex(4)
  self:SetIsFinishedUI(true)
  ;
  (self.mapNode):RefreshSectroIIMapRedddot()
end

UIWinterActivityMainMap.SetIsFinishedUI = function(self, active)
  -- function num : 0_10 , upvalues : _ENV
  for _,obj in ipairs((self.ui).isFinished) do
    obj:SetActive(active)
  end
end

UIWinterActivityMainMap.OnClickClose = function(self, toHome)
  -- function num : 0_11 , upvalues : _ENV
  self:Delete()
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:ResetToNormalState(toHome)
    sectorCtrl:PlaySectorBgm()
  end
end

UIWinterActivityMainMap.__InitSectorIIDungeonReddot = function(self)
  -- function num : 0_12 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).dungeon)
  if isOk then
    if self.__refresnDungeonReddot == nil then
      self.__refresnDungeonReddot = function(node)
    -- function num : 0_12_0 , upvalues : self
    ((self.ui).obj_blueDot_dungeon):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnDungeonReddot)
    ;
    (self.__refresnDungeonReddot)(node)
  end
end

UIWinterActivityMainMap.__RemoveSectorIIDungeonReddot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivitySectorIIEnum
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, self.actFrameId, (ActivitySectorIIEnum.eActSectorIIRedDotTypeId).dungeon)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnDungeonReddot)
  end
  self.__refresnDungeonReddot = nil
end

UIWinterActivityMainMap.__ShowIntroduce = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((ConfigData.game_config).win21GuideNum, nil)
end

UIWinterActivityMainMap.OnDelete = function(self)
  -- function num : 0_15 , upvalues : _ENV, base
  UIManager:DeleteWindow(UIWindowTypeID.Win21SectorBar)
  self:__RemoveSectorIIDungeonReddot()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.mapNode ~= nil then
    (self.mapNode):Delete()
  end
  if self.__timerId ~= nil then
    TimerManager:StopTimer(self.__timerId)
    self.__timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWinterActivityMainMap

