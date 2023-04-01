-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDormMain = class("UIDormMain", UIBaseWindow)
local base = UIBaseWindow
local UIDormEditNode = require("Game.Dorm.DUI.UIDormEditNode")
local UINDormRoomState = require("Game.Dorm.DUI.RoomState.UINDormRoomState")
local UINDmRoomOutput = require("Game.Dorm.DUI.ResOutput.UINDmRoomOutput")
local UINSwitchHouse = require("Game.Dorm.DUI.UINSwitchHouse")
local DormEnum = require("Game.Dorm.DormEnum")
local JumpManager = require("Game.Jump.JumpManager")
local ShopEnum = require("Game.Shop.ShopEnum")
local ActivityWhiteDayUtil = require("Game.ActivityWhiteDay.ActivityWhiteDayUtil")
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
UIDormMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIDormEditNode, UINDormRoomState, UINDmRoomOutput, UINSwitchHouse, DormEnum
  (UIUtil.AddButtonListener)((self.ui).btn_HideUI, self, self.OnHideUIClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Editor, self, self.OnEditorClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Buy, self, self.OnDormButClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Hero, self, self.OnCheckInClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Comfort, self, self.OnDormComfortClicked)
  self.__editorNode = (UIDormEditNode.New)()
  ;
  (self.__editorNode):Init((self.ui).editorNode)
  ;
  (self.__editorNode):Hide()
  self.dmRoomStateNode = (UINDormRoomState.New)(self)
  ;
  (self.dmRoomStateNode):Init((self.ui).stateNode)
  self.dmResOutputNode = (UINDmRoomOutput.New)(self)
  ;
  (self.dmResOutputNode):Init((self.ui).resNode)
  self.swtichHouseNode = (UINSwitchHouse.New)(self)
  ;
  (self.swtichHouseNode):Init((self.ui).houseNode)
  ;
  (UIUtil.SetTopStatus)(self, self.OnDormMainReturnClicked, nil, DormEnum.ShowMainInfoFunc)
  self.__OnDormMaxComfortChanged = BindCallback(self, self.OnDormMaxComfortChanged)
  MsgCenter:AddListener(eMsgEventId.DormMaxComfortChanged, self.__OnDormMaxComfortChanged)
  self.dormCtrl = ControllerManager:GetController(ControllerTypeId.Dorm)
  self:_InitDormMainSequene()
end

UIDormMain.InitDormMainUI = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local curHouse = (self.dormCtrl):GetCurHouse()
  if curHouse == nil then
    return 
  end
  self.allDormData = (self.dormCtrl).allDormData
  self:RefreshDormUIState()
  self:ShowDormEditMode(false)
  local ok, comfortNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormComfort)
  if comfortNode:GetRedDotCount() <= 0 then
    ((self.ui).redDot_Comfort):SetActive(not ok)
    if self.__RefreshRedDotComfort == nil then
      self.__RefreshRedDotComfort = function(node)
    -- function num : 0_1_0 , upvalues : self
    ((self.ui).redDot_Comfort):SetActive(node:GetRedDotCount() > 0)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

      RedDotController:AddListener(comfortNode.nodePath, self.__RefreshRedDotComfort)
    end
    self:ShowDmStateNode(false)
    ;
    (self.swtichHouseNode):InitSwitchNode(self.dormCtrl, curHouse)
    self:_UpdCheckInBtn()
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIDormMain.RefreshDormWindow = function(self)
  -- function num : 0_2
  self:RefreshDormUIState()
  ;
  (self.swtichHouseNode):UpdDmSwitchUI((self.dormCtrl):GetCurHouse())
  self:_UpdCheckInBtn()
end

UIDormMain.RefreshDormUIState = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local curLevel = (PlayerDataCenter.dormBriefData):GetDormComfortLevel()
  ;
  ((self.ui).tex_ComfortLv):SetIndex(0, tostring(curLevel))
end

UIDormMain.RefreshDormStateNode = function(self)
  -- function num : 0_4
  (self.dmRoomStateNode):InitDormRoomState()
  ;
  (self.dmResOutputNode):InitDmRoomOutput()
end

UIDormMain.ShowDmStateNode = function(self, show)
  -- function num : 0_5
  if show then
    (self.dmRoomStateNode):Show()
    ;
    (self.dmResOutputNode):Show()
  else
    ;
    (self.dmRoomStateNode):Hide()
    ;
    (self.dmResOutputNode):Hide()
  end
end

UIDormMain.OnDormMaxComfortChanged = function(self)
  -- function num : 0_6
  self:RefreshDormUIState()
end

UIDormMain.GetDormEditUI = function(self)
  -- function num : 0_7
  return self.__editorNode
end

UIDormMain.ShowDormEditMode = function(self, edit)
  -- function num : 0_8
  (((self.ui).btn_WhiteDayAlbum).gameObject):SetActive(false)
  ;
  ((self.ui).mainNode):SetActive(not edit)
  if edit then
    (self.__editorNode):Show()
  else
    ;
    (self.__editorNode):Hide()
  end
  self:_UpdCheckInBtn()
end

UIDormMain._UpdCheckInBtn = function(self)
  -- function num : 0_9
  local curHouse = (self.dormCtrl):GetCurHouse()
  if curHouse then
    local houseLock = curHouse:IsDmHouseLock()
  end
  local inEditMode = (self.__editorNode).active
  ;
  (((self.ui).btn_Hero).gameObject):SetActive((not houseLock and not inEditMode))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIDormMain.RefreshDormHeroList = function(self)
  -- function num : 0_10
end

UIDormMain.OnDormMainReturnClicked = function(self)
  -- function num : 0_11 , upvalues : DormEnum
  if (self.dormCtrl):IsDormState((DormEnum.eDormState).House) or (self.dormCtrl):IsDormState((DormEnum.eDormState).Room2House) or (self.dormCtrl):IsDormState((DormEnum.eDormState).Room) then
    (self.dormCtrl):ExitDorm()
  else
    if (self.dormCtrl):IsDormState((DormEnum.eDormState).HouseEdit) then
      self:ShowDormEditMode(false)
      ;
      ((self.dormCtrl).houseCtrl):ExitDormEditMode()
    end
  end
end

UIDormMain.OnHideUIClicked = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.TopStatus)
  self:Hide()
end

UIDormMain.OnEditorClicked = function(self)
  -- function num : 0_13 , upvalues : _ENV, DormEnum
  (self.dormCtrl):EnterDormEditor()
  ;
  (UIUtil.SetTopStatus)(self, self.OnDormMainReturnClicked, nil, DormEnum.ShowMainInfoFunc)
end

UIDormMain.OnDormButClicked = function(self)
  -- function num : 0_14 , upvalues : JumpManager, ShopEnum
  JumpManager:DirectShowShop(nil, nil, (ShopEnum.ShopId).dormFnt)
end

UIDormMain.OnCheckInClicked = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local enterFunc = function()
    -- function num : 0_15_0 , upvalues : _ENV
    UIManager:HideWindow(UIWindowTypeID.TopStatus)
    UIManager:HideWindow(UIWindowTypeID.DormMain)
  end

  local exitFunc = function()
    -- function num : 0_15_1 , upvalues : _ENV
    UIManager:ShowWindowOnly(UIWindowTypeID.TopStatus)
    UIManager:ShowWindowOnly(UIWindowTypeID.DormMain)
  end

  ;
  ((self.dormCtrl).dmCheckInCtrl):InitDmCheckInCtrl(nil, enterFunc, exitFunc)
end

UIDormMain.OnDormComfortClicked = function(self)
  -- function num : 0_16 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.DormComfort, function(comfortWindow)
    -- function num : 0_16_0
    if comfortWindow == nil then
      return 
    end
    comfortWindow:InitDormComfortUI()
  end
)
end

UIDormMain.SetBaseNodeActive = function(self, active)
  -- function num : 0_17 , upvalues : _ENV
  if active ~= nil then
    ((self.ui).baseNode):SetActive(active)
  else
    error("条件为空")
  end
end

UIDormMain._InitDormMainSequene = function(self)
  -- function num : 0_18 , upvalues : cs_DoTween, _ENV, cs_Ease, base
  local seq = (cs_DoTween.Sequence)()
  seq:SetAutoKill(false)
  seq:SetUpdate(true)
  seq:Append(((((self.transform):DOSizeDelta((Vector2.New)(0, 500), 0.25)):From()):SetRelative(true)):SetEase(cs_Ease.Linear))
  seq:Join(((((self.ui).canvasGroup):DOFade(0, 0.25)):From()):SetEase(cs_Ease.Linear))
  seq:OnRewind(function()
    -- function num : 0_18_0 , upvalues : base, self
    (base.Hide)(self)
  end
)
  self._winSeq = seq
end

UIDormMain.Hide = function(self)
  -- function num : 0_19
  (self._winSeq):Complete()
  ;
  (self._winSeq):PlayBackwards()
end

UIDormMain.OnShow = function(self)
  -- function num : 0_20 , upvalues : base
  (base.OnShow)(self)
  ;
  (self._winSeq):PlayForward()
end

UIDormMain.OnDelete = function(self)
  -- function num : 0_21 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.DormMaxComfortChanged, self.__OnDormMaxComfortChanged)
  local ok, comfortNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormComfort)
  if ok then
    RedDotController:RemoveListener(comfortNode.nodePath, self.__RefreshRedDotComfort)
  end
  self.dormCtrl = nil
  ;
  (self.dmRoomStateNode):Delete()
  ;
  (self.dmResOutputNode):Delete()
  ;
  (self.swtichHouseNode):Delete()
  if self._winSeq ~= nil then
    (self._winSeq):Kill()
    self._winSeq = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIDormMain

