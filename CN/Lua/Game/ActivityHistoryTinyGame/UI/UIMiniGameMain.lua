-- params : ...
-- function num : 0 , upvalues : _ENV
local UIMiniGameMain = class("UIMiniGameMain", UIBaseWindow)
local base = UIBaseWindow
local UINMiniGameMainBtn = require("Game.ActivityHistoryTinyGame.UI.UINMiniGameMainBtn")
local CS_ResLoader = CS.ResLoader
local ActivityHTGEnum = require("Game.ActivityHistoryTinyGame.ActivityHTGEnum")
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
local eSubUIType = {Main = 1, Task = 2, Review = 3}
local eSubUIConfig = {
[eSubUIType.Main] = {UIPerfab = "UI_MiniGameGroupList", ClassName = "Game.ActivityHistoryTinyGame.UI.UINMiniGameGroupList", InitFunc = "InitMiniGameGroup"}
, 
[eSubUIType.Task] = {UIPerfab = "UI_MiniGameGroupTask", ClassName = "Game.ActivityHistoryTinyGame.UI.Task.UINMiniGameTask", InitFunc = "InitMiniGameTask"}
, 
[eSubUIType.Review] = {UIPerfab = "UI_MiniGameGroupReview", ClassName = "Game.ActivityHistoryTinyGame.UI.Review.UINMiniGameReview", InitFunc = "InitMiniGameReview"}
}
UIMiniGameMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMiniGameMainBtn, CS_ResLoader, UINUserHead
  (UIUtil.SetTopStatus)(self, self.OnClickCloseMiniGame, nil, function()
    -- function num : 0_0_0 , upvalues : _ENV
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)(PicTipsConsts.activity_tiny_game, nil)
  end
)
  ;
  (UIUtil.SetBack2FrontCallback)(function()
    -- function num : 0_0_1 , upvalues : self, _ENV
    if self._actHTGData ~= nil then
      local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
      local avgId2 = (self._actHTGData):GetSecondAvgId()
      if avgId2 ~= nil and avgId2 > 0 then
        local played = avgPlayCtrl:IsAvgPlayed(avgId2)
        if not played and (self._actHTGData):IsActivityRunning() then
          (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgId2)
        end
      end
    end
  end
)
  self._btnPool = (UIItemPool.New)(UINMiniGameMainBtn, (self.ui).btn_Item)
  ;
  ((self.ui).btn_Item):SetActive(false)
  self.__OnOpenSubUICallback = BindCallback(self, self.OnHTGOpenSubUI)
  self.__OnOpenSubUICallbackHome = BindCallback(self, self.OnHTGOpenSubUI, 1, true)
  self._subUIDic = {}
  self.resloader = (CS_ResLoader.Create)()
  self.__ListenActiveCallback = BindCallback(self, self.__RefreshActive)
  MsgCenter:AddListener(eMsgEventId.ActivityTinyGameActive, self.__ListenActiveCallback)
  self.__isOpenOther = false
  self.__RefreshReddotCallback = BindCallback(self, self.__RefreshReddot)
  self._headNode = (UINUserHead.New)()
  ;
  (self._headNode):Init((self.ui).uINUserHead)
end

UIMiniGameMain.InitMiniGameGroupMain = function(self, actHTGData, callback)
  -- function num : 0_1 , upvalues : _ENV, eSubUIType
  self._actHTGData = actHTGData
  self._callback = callback
  local userData = PlayerDataCenter.inforData
  local headId = userData.avatarId
  local frameId = userData:GetAvatarFrameId()
  ;
  (self._headNode):InitUserHeadUI(headId, frameId, self.resloader)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_PlayerID).text = userData.name
  self:__RefreshActive()
  ;
  (self._btnPool):HideAll()
  for i = 3, 1, -1 do
    local item = (self._btnPool):GetOne()
    item:InitMiniBtn(i, self.__OnOpenSubUICallback)
  end
  self:OnHTGOpenSubUI(eSubUIType.Main, true)
  if self._reddot == nil then
    self._reddot = (self._actHTGData):GetActivityReddot()
    RedDotController:AddListener((self._reddot).nodePath, self.__RefreshReddotCallback)
    self:__RefreshReddot()
  end
end

UIMiniGameMain.OnHTGOpenSubUI = function(self, subUIType, isTopBack)
  -- function num : 0_2 , upvalues : _ENV, eSubUIType, eSubUIConfig
  if self._selectUIType == subUIType then
    return 
  end
  if subUIType == 1 then
    self.__isOpenOther = false
    if not isTopBack then
      (UIUtil.PopFromBackStackByUiTab)(self)
    end
  end
  if subUIType ~= 1 and not self.__isOpenOther then
    (UIUtil.SetTopStatus)(self, self.__OnOpenSubUICallbackHome)
    self.__isOpenOther = true
  end
  for k,v in pairs((self._btnPool).listItem) do
    v:SetMiniBtnState(subUIType)
  end
  if self._selectUIType ~= nil and (self._subUIDic)[self._selectUIType] ~= nil then
    ((self._subUIDic)[self._selectUIType]):Hide()
  end
  self._selectUIType = subUIType
  local isInMain = self._selectUIType == eSubUIType.Main
  ;
  ((self.ui).background1):SetActive(isInMain)
  ;
  ((self.ui).background2):SetActive(not isInMain)
  if (self._subUIDic)[self._selectUIType] ~= nil then
    ((self._subUIDic)[self._selectUIType]):Show()
    self:__ShowSubUIAni((self._subUIDic)[self._selectUIType])
    return 
  end
  local config = eSubUIConfig[self._selectUIType]
  if config == nil then
    error("子界面配置不存在")
    return 
  end
  local uiPath = PathConsts:GetUIPrefabPath(config.UIPerfab)
  local prefab = (self.resloader):LoadABAsset(uiPath)
  local go = prefab:Instantiate((self.ui).holder)
  local subClass = ((require(config.ClassName)).New)()
  subClass:Init(go)
  ;
  (subClass[config.InitFunc])(subClass, self._actHTGData)
  if self._selectUIType ~= eSubUIType.Main then
    self:__ShowSubUIAni(subClass)
  end
  -- DECOMPILER ERROR at PC122: Confused about usage of register: R9 in 'UnsetPending'

  ;
  (self._subUIDic)[self._selectUIType] = subClass
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UIMiniGameMain.__RefreshActive = function(self)
  -- function num : 0_3 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_CupNo).text = tostring((self._actHTGData):GetActiveLevel())
end

UIMiniGameMain.__RefreshReddot = function(self)
  -- function num : 0_4 , upvalues : ActivityHTGEnum, _ENV, eSubUIType
  local taskReddot = (self._reddot):GetChild((ActivityHTGEnum.eActivityReddot).Task)
  local activeReddot = (self._reddot):GetChild((ActivityHTGEnum.eActivityReddot).Active)
  local reviewReddot = (self._reddot):GetChild((ActivityHTGEnum.eActivityReddot).Review)
  local taskNodeActice = (taskReddot ~= nil and taskReddot:GetRedDotCount() > 0) or (activeReddot ~= nil and activeReddot:GetRedDotCount() > 0)
  local revireActive = reviewReddot ~= nil and reviewReddot:GetRedDotCount() > 0
  for i,v in ipairs((self._btnPool).listItem) do
    if v:GetMiniBtnIndex() == eSubUIType.Task then
      v:SetMiniBtnReddot(taskNodeActice, (self._actHTGData):IsHTGBlueReddotType((ActivityHTGEnum.eActivityReddot).Task))
    elseif v:GetMiniBtnIndex() == eSubUIType.Review then
      v:SetMiniBtnReddot(revireActive, (self._actHTGData):IsHTGBlueReddotType((ActivityHTGEnum.eActivityReddot).Review))
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UIMiniGameMain.__ShowSubUIAni = function(self, subUI)
  -- function num : 0_5
  if (subUI.ui).canvasGroup ~= nil then
    (((subUI.ui).canvasGroup):DOFade(0, 0.5)):From()
  end
end

UIMiniGameMain.OnClickCloseMiniGame = function(self)
  -- function num : 0_6
  self:OnCloseWin()
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIMiniGameMain.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  for k,v in pairs(self._subUIDic) do
    ((v.ui).canvasGroup):DOComplete()
    v:Delete()
  end
  ;
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.ActivityTinyGameActive, self.__ListenActiveCallback)
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self.__RefreshReddotCallback)
  end
end

return UIMiniGameMain

