-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAprilFoolMain = class("UIAprilFoolMain", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local JumpManager = require("Game.Jump.JumpManager")
local TaskEnum = require("Game.Task.TaskEnum")
local ActRefreshDunEnum = require("Game.ActivityRefreshDun.ActRefreshDunEnum")
local UINAprilFoolDunItem = require("Game.ActivityRefreshDun.UI.UINAprilFoolDunItem")
local cs_MessageCommon = CS.MessageCommon
UIAprilFoolMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINAprilFoolDunItem
  self.resloader = (cs_ResLoader.Create)()
  ;
  (UIUtil.SetTopStatus)(self, self.__OnClickClose, nil, BindCallback(self, self.__OnClickInfo))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Shop, self, self.__OnClickShop)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Task, self, self.__OnClickTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_MiniGame, self, self.__OnClickMiniGame)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_PlotReview, self, self.__OnClickPhotoReview)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reset, self, self.__OnClickReset)
  self.dunItemPool = (UIItemPool.New)(UINAprilFoolDunItem, (self.ui).obj_dungeonItem)
  ;
  ((self.ui).obj_dungeonItem):SetActive(false)
end

UIAprilFoolMain.InitAprilFoolMain = function(self, ARDctrl, ARDData)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3321)
  self.ARDctrl = ARDctrl
  self.ARDData = ARDData
  self:RefreshAprilFoolMain()
  self:__InitARDTaskReddot()
  self:__InitARDAvgReddot()
end

UIAprilFoolMain.RefreshAprilFoolMain = function(self)
  -- function num : 0_2
  self:__RefreshAllDunUI()
  self:__RefreshResetUI()
  self:__RefreshActCloseTime()
end

UIAprilFoolMain.__RefreshAllDunUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self.dunItemPool):HideAll()
  if not (self.ARDData):IsActivityRunning() then
    ((self.ui).obj_times):SetActive(false)
    ;
    (((self.ui).btn_MiniGame).gameObject):SetActive(false)
    return 
  end
  local dunList = (self.ARDData):GetARDDataList()
  for index,dunId in ipairs(dunList) do
    local ARDDunData = (self.ARDData):GetARDDataByDunId(dunId)
    local dunItem = (self.dunItemPool):GetOne()
    local parent = ((self.ui).pos_array)[index]
    dunItem:InitAprilFoolDunItem(index, self.ARDctrl, ARDDunData, self.resloader)
    ;
    (dunItem.transform):SetParent(parent, false)
  end
end

UIAprilFoolMain.__RefreshResetUI = function(self, isTimeUpdate)
  -- function num : 0_4 , upvalues : _ENV
  local expireTime = (self.ARDData):GetARDExpiredTm()
  local timeData = TimeUtil:TimestampToDate(expireTime, false, true)
  ;
  ((self.ui).tex_TimeBeforeReset):SetIndex(0, tostring(timeData.hour))
  if (self.ARDData):IsARDResetRunOut() then
    ((self.ui).img_btn_Reset):SetIndex(1)
    ;
    ((self.ui).couldReset):SetActive(false)
    ;
    ((self.ui).couldNotReset):SetActive(true)
  else
    ;
    ((self.ui).img_btn_Reset):SetIndex(0)
    ;
    ((self.ui).couldReset):SetActive(true)
    ;
    ((self.ui).couldNotReset):SetActive(false)
    local reSetCostNum = (self.ARDData):GetARDResetCost()
    -- DECOMPILER ERROR at PC61: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_ResetItemCount).text = tostring(reSetCostNum)
  end
end

UIAprilFoolMain.__RefreshActCloseTime = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local actEndTime = (self.ARDData):GetActivityEndTime()
  local date = TimeUtil:TimestampToDate(actEndTime)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ActLeftTime).text = (string.format)("%02d/%02d/%02d %02d:%02d", date.year, date.month, date.day, date.hour, date.min)
end

UIAprilFoolMain.__OnClickReset = function(self)
  -- function num : 0_6 , upvalues : cs_MessageCommon, _ENV
  if (self.ARDData):IsARDResetRunOut() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7307))
    return 
  end
  local resetCostNum = (self.ARDData):GetARDResetCost()
  local RealReset = function()
    -- function num : 0_6_0 , upvalues : self, _ENV
    local actId = (self.ARDData):GetActId()
    ;
    (self.ARDctrl):ARDBuyReset(actId, function()
      -- function num : 0_6_0_0 , upvalues : _ENV, self
      AudioManager:PlayAudioById(1212)
      self:__RefreshAllDunUI()
      self:__RefreshResetUI()
    end
)
  end

  local TryBySand = function()
    -- function num : 0_6_1 , upvalues : self, _ENV, resetCostNum, RealReset
    local resetCostItem = (self.ARDData):GetARDResetCostItemId()
    local backpackNum = PlayerDataCenter:GetItemCount(resetCostItem)
    if backpackNum < resetCostNum then
      local needItemNum = resetCostNum - backpackNum
      local assignMsg = (string.format)(ConfigData:GetTipContent(10008), needItemNum, needItemNum)
      if ((Consts.GameChannelType).IsJp)() then
        assignMsg = assignMsg .. ConfigData:GetTipContent(334)
      end
      if resetCostItem == ConstGlobalItem.PaidSubItem then
        local payCtrl = ControllerManager:GetController(ControllerTypeId.Pay, true)
        return payCtrl:PaidCurrencyExecute(ConstGlobalItem.PaidSubItem, needItemNum, resetCostItem, needItemNum, RealReset, assignMsg)
      else
        do
          do
            do return  end
            RealReset()
          end
        end
      end
    end
  end

  local totalNum, unplayedNum = (self.ARDData):GetARDLevelNum()
  if unplayedNum > 0 then
    local message = (string.format)(ConfigData:GetTipContent(7301), tostring(resetCostNum), tostring(unplayedNum))
    ;
    (cs_MessageCommon.ShowMessageBox)(message, TryBySand, nil)
  else
    do
      local message = (string.format)(ConfigData:GetTipContent(7306), tostring(resetCostNum))
      ;
      (cs_MessageCommon.ShowMessageBox)(message, TryBySand, nil)
    end
  end
end

UIAprilFoolMain.__OnClickShop = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local ARDDCfg = (self.ARDData):GetARDDCfg()
  UIManager:ShowWindowAsync(UIWindowTypeID.CharacterDungeonShop, function(window)
    -- function num : 0_7_0 , upvalues : ARDDCfg, self, _ENV
    window:ExtraInitCharacterDungeonShop({currencyId = ARDDCfg.token, shop_list = ARDDCfg.shop_list, destoryTime = (self.ARDData):GetActivityDestroyTime(), bornTime = (self.ARDData):GetActivityBornTime(), color_shop = ARDDCfg.color_shop, color_shoplist = ARDDCfg.color_shoplist, shop_name = ARDDCfg.shop_name, shop_bgfullPath = PathConsts:GetImagePath(ARDDCfg.shop_bg), actFrameId = (self.ARDData):GetActFrameId()})
  end
)
end

UIAprilFoolMain.__OnClickTask = function(self)
  -- function num : 0_8 , upvalues : JumpManager, TaskEnum
  JumpManager:Jump((JumpManager.eJumpTarget).DynTask, nil, nil, {(TaskEnum.eTaskType).LargeActivityTask}, true)
end

UIAprilFoolMain.__OnClickMiniGame = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local actId = (self.ARDData):GetActFrameId()
  local miniGameId = (self.ARDData):GetARDMiniGameId()
  local maxScore = (self.ARDData):GetARDMiniGameMaxScore()
  ;
  (UIUtil.HideTopStatus)()
  UIManager:ShowWindowAsync(UIWindowTypeID.AprilGameDamie, function(window)
    -- function num : 0_9_0 , upvalues : actId, miniGameId, maxScore, _ENV
    window:InitDamieWithData(actId, miniGameId, maxScore)
    window:InjectExitAction(function()
      -- function num : 0_9_0_0 , upvalues : _ENV
      (UIUtil.ReShowTopStatus)()
    end
)
  end
)
end

UIAprilFoolMain.__OnClickPhotoReview = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroPlotReview, function(window)
    -- function num : 0_10_0 , upvalues : self
    if window == nil then
      return 
    end
    local CPRData = (self.ARDData):GetARDPlotReviewData()
    window:InitCommonPlotReview(CPRData)
  end
)
end

UIAprilFoolMain.__OnClickInfo = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)((ConfigData.game_config).aprilFoolGameGuideID, nil)
end

UIAprilFoolMain.__InitARDTaskReddot = function(self)
  -- function num : 0_12 , upvalues : _ENV, ActRefreshDunEnum
  local actFrameId = (self.ARDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActRefreshDunEnum.redDotType).task)
  if isOk then
    if self.__refresnTaskReddot == nil then
      self.__refresnTaskReddot = function(node)
    -- function num : 0_12_0 , upvalues : self
    ((self.ui).obj_taks_RedDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnTaskReddot)
    ;
    (self.__refresnTaskReddot)(node)
  end
end

UIAprilFoolMain.__RemoveARDTaskReddot = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActRefreshDunEnum
  local actFrameId = (self.ARDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActRefreshDunEnum.redDotType).task)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnTaskReddot)
  end
  self.__refresnTaskReddot = nil
end

UIAprilFoolMain.__InitARDAvgReddot = function(self)
  -- function num : 0_14 , upvalues : _ENV, ActRefreshDunEnum
  local actFrameId = (self.ARDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActRefreshDunEnum.redDotType).avg)
  if isOk then
    if self.__refresnAvgReddot == nil then
      self.__refresnAvgReddot = function(node)
    -- function num : 0_14_0 , upvalues : self
    ((self.ui).obj_plotReview_RedDot):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

    end
    RedDotController:AddListener(node.nodePath, self.__refresnAvgReddot)
    ;
    (self.__refresnAvgReddot)(node)
  end
end

UIAprilFoolMain.__RemoveARDAvgReddot = function(self)
  -- function num : 0_15 , upvalues : _ENV, ActRefreshDunEnum
  local actFrameId = (self.ARDData):GetActFrameId()
  local isOk, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivitySingle, actFrameId, (ActRefreshDunEnum.redDotType).avg)
  if isOk then
    RedDotController:RemoveListener(node.nodePath, self.__refresnAvgReddot)
  end
  self.__refresnAvgReddot = nil
end

UIAprilFoolMain.__OnClickClose = function(self, toHome)
  -- function num : 0_16 , upvalues : _ENV
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:ResetToNormalState(toHome)
    sectorCtrl:PlaySectorBgm()
  end
  self:Delete()
end

UIAprilFoolMain.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  self:__RemoveARDTaskReddot()
  self:__RemoveARDAvgReddot()
  ;
  (self.dunItemPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIAprilFoolMain

