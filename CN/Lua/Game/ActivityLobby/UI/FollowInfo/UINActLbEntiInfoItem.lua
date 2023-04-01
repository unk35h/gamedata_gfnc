-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActLbEntiInfoItem = class("UINActLbEntiInfoItem", base)
UINActLbEntiInfoItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
  ;
  ((self.ui).time):SetActive(false)
end

UINActLbEntiInfoItem.InitActLbEntiInfoItem = function(self, intrctEntity)
  -- function num : 0_1 , upvalues : _ENV
  if self._actTimerNode then
    (self._actTimerNode):Hide()
  end
  self._intrctEntity = intrctEntity
  local intrctData = intrctEntity:GetLbIntrctEntData()
  local actionList = intrctData:GetLbIntrctObjActions()
  local actionData = actionList[1]
  if actionData == nil then
    error("actionData == nil")
    return 
  end
  self._actionData = actionData
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = actionData:GetLbIntrctActionName()
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = actionData:GetLbIntrctActionSubName()
  self:UpdActLbEntiInfoItemLock()
  self:UpdActLbEntiInfoItemBlueDot()
end

UINActLbEntiInfoItem.UpdActLbEntiInfoItemLock = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isUnlock = (self._actionData):IsLbIntrctEntiUnlock()
  ;
  ((self.ui).obj_Lock):SetActive(not isUnlock)
  if not isUnlock then
    ((self.ui).tex_Lock):SetIndex((self._actionData):GetLbIntrctActionLockStateDes())
  end
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  if not isUnlock or not Color.white then
    ((self.ui).img_Bg).color = (self.ui).color_LockBg
    if not isUnlock or not Color.white then
      local textColor = (self.ui).color_LockTex
    end
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = textColor
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).color = textColor
  end
end

UINActLbEntiInfoItem.UpdActLbEntiInfoItemBlueDot = function(self)
  -- function num : 0_3
  ((self.ui).blueDot):SetActive((self._actionData):IsShowLbIntrctActionBluedot())
end

UINActLbEntiInfoItem.UpdActLbEntiInfoItemActTimer = function(self, tile, timer, days)
  -- function num : 0_4 , upvalues : _ENV
  do
    if self._actTimerNode == nil then
      local UINActivityTimer = require("Game.ActivityFrame.UI.UINActivityTimer")
      self._actTimerNode = (UINActivityTimer.New)()
      ;
      (self._actTimerNode):Init((self.ui).time)
    end
    ;
    (self._actTimerNode):Show()
    ;
    (self._actTimerNode):UpdActTimer(tile, timer, days)
  end
end

UINActLbEntiInfoItem._OnClickRoot = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  ;
  (actLbCtrl.actLbCmderCtrl):LbCmdMove2Entt(self._intrctEntity)
end

UINActLbEntiInfoItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINActLbEntiInfoItem

