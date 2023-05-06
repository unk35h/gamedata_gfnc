-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop = class("UINWarChessMainTop", UIBaseNode)
local UINResourceGroup = require("Game.CommonUI.ResourceGroup.UINResourceGroup")
local UINWCBuffList = require("Game.WarChess.UI.Main.BuffList.UINWCBuffList")
local UINWarChessMainTop_PressBar = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_PressBar")
local UINWarChessMainTop_PressPanel = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_PressPanel")
local UINWarChessMainTop_Goal = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_Goal")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local cs_MessageCommon = CS.MessageCommon
local cs_DoTween = ((CS.DG).Tweening).DOTween
UINWarChessMainTop.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINResourceGroup, UINWCBuffList, UINWarChessMainTop_PressBar, UINWarChessMainTop_PressPanel, UINWarChessMainTop_Goal
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_pressureBar, self, self.ShowWCPressFrameNode)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Menu, self, self.OnClickMenu)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickBtnInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rewind, self, self.OnClickWCTimeRewind)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectDungeon, self, self.OnClickWCSSelectLevel)
  self.resloader = ((CS.ResLoader).Create)()
  self.resourceGroup = (UINResourceGroup.New)()
  ;
  (self.resourceGroup):Init((self.ui).obj_gameResourceGroup)
  ;
  (self.resourceGroup):Hide()
  self.buffList = (UINWCBuffList.New)()
  ;
  (self.buffList):Init((self.ui).obj_buffList)
  ;
  (self.buffList):Hide()
  self.pressBarNode = (UINWarChessMainTop_PressBar.New)()
  ;
  (self.pressBarNode):Init((self.ui).obj_pressureBar)
  ;
  (self.pressBarNode):Hide()
  self.pressNode = (UINWarChessMainTop_PressPanel.New)()
  ;
  (self.pressNode):Init((self.ui).obj_pressureFrame)
  ;
  (self.pressNode):Hide()
  self.GoalNode = (UINWarChessMainTop_Goal.New)()
  ;
  (self.GoalNode):Init((self.ui).obj_goalNode)
  ;
  (self.GoalNode):Hide()
  ;
  (self.pressBarNode):BindPressResloader(self.resloader)
  ;
  (self.pressNode):BindPressResloader(self.resloader)
  self.__onTrunNumChange = BindCallback(self, self.OnTrunNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_TurnStart, self.__onTrunNumChange)
  self.__onCoinNumChange = BindCallback(self, self.OnCoinNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
  self.__refreshBuffList = BindCallback(self, self.RefreshBuffList)
  MsgCenter:AddListener(eMsgEventId.WC_BuffChange, self.__refreshBuffList)
  self.__onWCPressChange = BindCallback(self, self.OnWCPressChange)
  MsgCenter:AddListener(eMsgEventId.WC_StressPointChange, self.__onWCPressChange)
  self.__onTimeRewind = BindCallback(self, self.OnTimeRewind)
  MsgCenter:AddListener(eMsgEventId.WC_TimeRewind, self.__onTimeRewind)
end

UINWarChessMainTop.ShowWCDeployInfo = function(self)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).obj_ResList):SetActive(false)
  ;
  (self.resourceGroup):Hide()
  self.wcCtrl = WarChessManager:GetWarChessCtrl()
  ;
  (self.resourceGroup):SetResourceIds({ConstGlobalItem.SKey})
  ;
  (self.GoalNode):Show()
  self:RefreshWCGameGoal()
  self:RefreshLobbyCouldShowUI(false)
end

UINWarChessMainTop.ShowWCPlayInfo = function(self, wcCtrl)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_ResList):SetActive(true)
  ;
  (self.resourceGroup):Hide()
  ;
  (self.buffList):Show()
  ;
  (self.pressBarNode):Show()
  self.wcCtrl = wcCtrl
  self:OnTrunNumChange(((self.wcCtrl).turnCtrl):GetWCTurnNum())
  self:OnCoinNumChange(ConstGlobalItem.WCMoney, ((self.wcCtrl).backPackCtrl):GetWCCoinNum())
  self:OnCoinNumChange(ConstGlobalItem.WCDeployPoint, ((self.wcCtrl).backPackCtrl):GetWCDeployPointNum())
  self:RefreshBuffList()
  ;
  (self.GoalNode):Show()
  self:RefreshWCGameGoal()
  self:OnWCPressChange()
  self:__RefreshWCTimeRewindBtnCouldShow()
  self:RefreshLobbyCouldShowUI(true)
end

UINWarChessMainTop.RefreshLobbyCouldShowUI = function(self, isPlay)
  -- function num : 0_3 , upvalues : _ENV
  if not WarChessSeasonManager:GetIsInWCSeason() then
    return 
  end
  local wcsCtrl = WarChessSeasonManager:GetWCSCtrl()
  if WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
    (self.GoalNode):Hide()
    ;
    (self.pressBarNode):Hide()
    ;
    ((self.ui).obj_turn):SetActive(false)
    ;
    ((self.ui).obj_seasonTitle):SetActive(true)
    local towerID = WarChessSeasonManager:GetWCSSeasonTowerID()
    local floorIndex = (WarChessSeasonManager:GetWCSCtrl()):WCSGetFloor()
    local floorCfg = ((ConfigData.warchess_season_floor)[towerID])[floorIndex]
    -- DECOMPILER ERROR at PC48: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(floorCfg.hall_level_name)
    ;
    (((self.ui).btn_SelectDungeon).gameObject):SetActive(isPlay)
  end
  do
    if not WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
      local roomData = wcsCtrl:WCSGetSurWCSRoomData()
      if roomData == nil then
        error("roomData not exist")
        return 
      end
      local roomId = roomData.RoomId
      local seasonLevelCfg = (ConfigData.warchess_season_level)[roomId]
      if seasonLevelCfg == nil then
        error("seasonLevelCfg not exist id:" .. tostring(roomId))
        return 
      end
      ;
      (((self.ui).tex_WCSLevelName).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC94: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self.ui).tex_WCSLevelName).text = (LanguageUtil.GetLocaleText)(seasonLevelCfg.level_explain)
    else
      do
        ;
        (((self.ui).tex_WCSLevelName).gameObject):SetActive(false)
      end
    end
  end
end

UINWarChessMainTop.RefreshWCGameGoal = function(self)
  -- function num : 0_4
  (self.GoalNode):RefreshWCGoal()
end

UINWarChessMainTop.OnTrunNumChange = function(self, num)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_turnNum).text = tostring(num)
end

UINWarChessMainTop.OnCoinNumChange = function(self, itemId, num)
  -- function num : 0_6 , upvalues : _ENV
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  if itemId == ConstGlobalItem.WCMoney then
    ((self.ui).tex_CoinNum2).text = tostring(num)
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_CoinNum1).text = tostring(num)
  end
end

UINWarChessMainTop.OnTimeRewind = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self:OnTrunNumChange(((self.wcCtrl).turnCtrl):GetWCTurnNum())
  self:OnCoinNumChange(ConstGlobalItem.WCMoney, ((self.wcCtrl).backPackCtrl):GetWCCoinNum())
  self:OnCoinNumChange(ConstGlobalItem.WCDeployPoint, ((self.wcCtrl).backPackCtrl):GetWCDeployPointNum())
  self:RefreshBuffList()
  ;
  (self.GoalNode):Show()
  self:RefreshWCGameGoal()
  ;
  (self.pressBarNode):RefreshWCPress(true)
  self:__RefreshWCTimeRewindBtnCouldShow()
end

UINWarChessMainTop.OnWCPressChange = function(self)
  -- function num : 0_8
  (self.pressBarNode):RefreshWCPress()
end

UINWarChessMainTop.RefreshBuffList = function(self)
  -- function num : 0_9
  local buffDic = ((self.wcCtrl).backPackCtrl):GetWCBuffDic()
  ;
  (self.buffList):RefreshWCBuffList(buffDic)
end

UINWarChessMainTop.ShowWCPressFrameNode = function(self)
  -- function num : 0_10 , upvalues : eWarChessEnum
  (self.pressNode):RefreshWCPressFrame()
  ;
  (self.pressNode):Show()
  if (self.wcCtrl).state == (eWarChessEnum.eWarChessState).play then
    ((self.wcCtrl).curState):WCHideInteract()
  end
end

UINWarChessMainTop.OnClickMenu = function(self)
  -- function num : 0_11 , upvalues : _ENV, cs_MessageCommon
  if self.wcCtrl ~= nil and ((self.wcCtrl):IsWCInSubSystem() or not ((self.wcCtrl).curState):IsCanOpenMenu()) then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.BattlePause, function(win)
    -- function num : 0_11_0 , upvalues : cs_MessageCommon, _ENV
    if win == nil then
      return 
    end
    win:InitBattlePause(function()
      -- function num : 0_11_0_0 , upvalues : cs_MessageCommon, _ENV
      (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(8517), function()
        -- function num : 0_11_0_0_0 , upvalues : _ENV
        WarChessManager:GiveUpWarchess()
      end
, nil)
    end
)
    win:SetAboutBattleUIActive(false)
    win:SetBtPauseReturn2HomeFunc(function()
      -- function num : 0_11_0_1 , upvalues : _ENV
      WarChessManager:ExitWarChess((Consts.SceneName).Main)
    end
)
  end
)
end

UINWarChessMainTop.OnClickBtnInfo = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local introId = (ConfigData.game_config).guideTipWarChess
  if WarChessSeasonManager:GetIsInWCSeason() then
    introId = (ConfigData.game_config).guideTipWarChessSeason
  end
  self:__OpenWarChessGuidePicture(introId)
end

UINWarChessMainTop.__RefreshWCTimeRewindBtnCouldShow = function(self)
  -- function num : 0_13
  local rewindTotalTime, rewindLeftTime = ((self.wcCtrl).turnCtrl):GetWCRewindTimes()
  ;
  (((self.ui).btn_Rewind).gameObject):SetActive(rewindTotalTime > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINWarChessMainTop.OnClickWCTimeRewind = function(self)
  -- function num : 0_14 , upvalues : eWarChessEnum, cs_MessageCommon, _ENV
  if self.wcCtrl == nil or (self.wcCtrl):IsWCInSubSystem() or (self.wcCtrl).state ~= (eWarChessEnum.eWarChessState).play then
    return 
  end
  local rewindTotalTime, rewindLeftTime = ((self.wcCtrl).turnCtrl):GetWCRewindTimes()
  if rewindLeftTime <= 0 then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(8528))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessTimeRewind, function(win)
    -- function num : 0_14_0
    if win ~= nil then
      win:InitWCTimeRewind()
    end
  end
)
end

UINWarChessMainTop.OnClickWCSSelectLevel = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if (self.wcCtrl):IsWCInSubSystem() then
    return 
  end
  if WarChessSeasonManager:GetIsInWCSeasonIsInLobby() then
    local datas = (WarChessSeasonManager:GetWCSCtrl()):WCSGetLobbyNextRoomDataMsg()
    do
      UIManager:ShowWindowAsync(UIWindowTypeID.WarChessSeasonSelectLevel, function(win)
    -- function num : 0_15_0 , upvalues : datas
    if win == nil then
      return 
    end
    win:InitWCSLevelInfo(datas)
    win:WCSPlayAniSelectLevel(false, nil, 1.25)
  end
)
    end
  end
end

UINWarChessMainTop.__OpenWarChessGuidePicture = function(self, introId)
  -- function num : 0_16 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)(introId, nil)
end

UINWarChessMainTop.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.WC_TurnStart, self.__onTrunNumChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_CoinNumChange, self.__onCoinNumChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_BuffChange, self.__refreshBuffList)
  MsgCenter:RemoveListener(eMsgEventId.WC_StressPointChange, self.__onWCPressChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_TimeRewind, self.__onTimeRewind)
  ;
  (self.resourceGroup):Delete()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.pressBarNode):Delete()
end

return UINWarChessMainTop

