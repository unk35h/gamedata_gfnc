-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSwitchHouse = class("UINSwitchHouse", UIBaseNode)
local base = UIBaseNode
local UINSwitchHouseBtn = require("Game.Dorm.DUI.UINSwitchHouseBtn")
UINSwitchHouse.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSwitchHouseBtn
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_closeSwitchHouse, self, self.OnHideHouseListClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Left, self, self.OnBtnSwitchLeftClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Right, self, self.OnBtnSwitchRightClicked)
  self.btnSwtichHouse = (UINSwitchHouseBtn.New)()
  ;
  (self.btnSwtichHouse):Init((self.ui).btn_SwitchHouse)
  self._houseItemPool = (UIItemPool.New)(UINSwitchHouseBtn, (self.ui).btn_House, false)
  self._switchHouseClicked = BindCallback(self, self.OnSwitchHouseClicked)
  self._originSize = ((self.ui).tans_count).sizeDelta
  local ok, newHouseNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormNewHouse)
  if ok then
    self._newHouseListener = BindCallback(self, self.__RefreshSwitchHouseReddot)
    RedDotController:AddListener(newHouseNode.nodePath, self._newHouseListener)
  end
  self:__RefreshSwitchHouseReddot()
end

UINSwitchHouse.InitSwitchNode = function(self, dormCtrl, curHouse)
  -- function num : 0_1 , upvalues : _ENV
  self.dormCtrl = dormCtrl
  local iconIdx = curHouse:GetDmHouseIconIdx()
  ;
  (self.btnSwtichHouse):InitSwitchHouse(curHouse.id, curHouse:GetName(), iconIdx, BindCallback(self, self.OnShowHouseListClicked))
  self:UpdDmSwitchUI(curHouse)
end

UINSwitchHouse.UpdDmSwitchUI = function(self, curHouse)
  -- function num : 0_2 , upvalues : _ENV
  local allDormData = (self.dormCtrl).allDormData
  local count = #allDormData.houseIdList
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tans_count).sizeDelta = (Vector2.New)((self._originSize).x * count, (self._originSize).y)
  local index = nil
  for i,houseId in pairs(allDormData.houseIdList) do
    if houseId == curHouse.id then
      index = i
    end
  end
  self._houseIndex = index
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).obj_CurrNum).anchoredPosition = (Vector2.New)((index - 1) * (self._originSize).x, 0)
end

UINSwitchHouse.OnShowHouseListClicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self.btnSwtichHouse):SetSwitchHouseReddot(false)
  ;
  (self.btnSwtichHouse):ShowSwitchHouseBlueDot(false)
  ;
  ((self.ui).switchBtnList):SetActive(true)
  ;
  (self._houseItemPool):HideAll()
  local curHouse = (self.dormCtrl):GetCurHouse()
  local allDormData = (self.dormCtrl).allDormData
  for _,houseId in pairs(allDormData.houseIdList) do
    if houseId ~= curHouse.id then
      local houseData = (allDormData.houseDic)[houseId]
      local switchHouseItem = (self._houseItemPool):GetOne()
      local iconIdx = houseData:GetDmHouseIconIdx()
      switchHouseItem:InitSwitchHouse(houseId, houseData:GetName(), iconIdx, self._switchHouseClicked)
      switchHouseItem:SetSwitchHouseBtnLock(houseData:IsDmHouseLock())
      local isReddot = (PlayerDataCenter.dormBriefData):GetDormHouseIsNew(houseId)
      switchHouseItem:SetSwitchHouseReddot(isReddot)
      local showBlueDot = false
      if not isReddot then
        showBlueDot = not houseData:IsDmHouseUnlockableReaded()
      end
      switchHouseItem:ShowSwitchHouseBlueDot(showBlueDot)
    end
  end
end

UINSwitchHouse.__RefreshSwitchHouseReddot = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local showReddot = false
  local ok, newHouseNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormNewHouse)
  if newHouseNode:GetRedDotCount() <= 0 then
    showReddot = not ok
    ;
    (self.btnSwtichHouse):SetSwitchHouseReddot(showReddot)
    self._showReddot = showReddot
    self:_UpdBluedot()
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UINSwitchHouse._UpdBluedot = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local showBlueDot = false
  do
    if not self._showReddot then
      local dromCtrl = ControllerManager:GetController(ControllerTypeId.Dorm)
      showBlueDot = (dromCtrl.allDormData):IsAnyDmHouseUnlockableUnread()
    end
    ;
    (self.btnSwtichHouse):ShowSwitchHouseBlueDot(showBlueDot)
  end
end

UINSwitchHouse.OnHideHouseListClicked = function(self)
  -- function num : 0_6
  ((self.ui).switchBtnList):SetActive(false)
  self:__RefreshSwitchHouseReddot()
end

UINSwitchHouse.OnSwitchHouseClicked = function(self, houseId, tryBuyNewHouse)
  -- function num : 0_7
  ((self.ui).switchBtnList):SetActive(false)
  ;
  (self.dormCtrl):ChangedDormHouse(houseId, function()
    -- function num : 0_7_0 , upvalues : tryBuyNewHouse, self, houseId
    if tryBuyNewHouse then
      (self.dormCtrl):TryBuyNewHouse(houseId)
    end
  end
)
  self:__RefreshSwitchHouseReddot()
end

UINSwitchHouse.OnBtnSwitchLeftClicked = function(self)
  -- function num : 0_8
  local allDormData = (self.dormCtrl).allDormData
  self._houseIndex = self._houseIndex - 1
  if self._houseIndex < 1 then
    self._houseIndex = #allDormData.houseIdList
  end
  local houseId = (allDormData.houseIdList)[self._houseIndex]
  self:OnSwitchHouseClicked(houseId)
end

UINSwitchHouse.OnBtnSwitchRightClicked = function(self)
  -- function num : 0_9
  local allDormData = (self.dormCtrl).allDormData
  self._houseIndex = self._houseIndex + 1
  if #allDormData.houseIdList < self._houseIndex then
    self._houseIndex = 1
  end
  local houseId = (allDormData.houseIdList)[self._houseIndex]
  self:OnSwitchHouseClicked(houseId)
end

UINSwitchHouse.OnDelete = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  local ok, newHouseNode = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Dorm, RedDotStaticTypeId.DormNewHouse)
  if ok then
    RedDotController:RemoveListener(newHouseNode.nodePath, self._newHouseListener)
  end
  ;
  (base.OnDelete)(self)
end

return UINSwitchHouse

