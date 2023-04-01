-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActLbQuickEntrance = class("UINActLbQuickEntrance", base)
local UINLbQuickEntranceItem = require("Game.ActivityLobby.UI.Main.QuickEntrance.UINLbQuickEntranceItem")
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
local UINActivityTimer = require("Game.ActivityFrame.UI.UINActivityTimer")
local animNameIn = "UI_ActivityLobbyMainQuickEntranceList"
local animNameOut = "UI_ActivityLobbyMainQuickEntranceListOut"
UINActLbQuickEntrance.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActivityTimer, UINLbQuickEntranceItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CloseBg, self, self._OnClickClose)
  self._actTimerNode = (UINActivityTimer.New)()
  ;
  (self._actTimerNode):Init((self.ui).time)
  ;
  (self._actTimerNode):Hide()
  self._entranceItemPool = (UIItemPool.New)(UINLbQuickEntranceItem, (self.ui).item, false)
end

UINActLbQuickEntrance.InitLbQuickEntrance = function(self, actionList)
  -- function num : 0_1 , upvalues : _ENV, ActLbEnum, animNameIn
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl then
    actLbCtrl:SetActLbState((ActLbEnum.eActLbState).ShowQuickEntrance)
  end
  TimerManager:StopTimer(self._HideTimer)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).blocksRaycasts = true
  ;
  ((self.ui).anim_root):Play(animNameIn)
  self:Show()
  self._entranceItemDic = {}
  ;
  (self._entranceItemPool):HideAll()
  for k,actionData in ipairs(actionList) do
    local item = (self._entranceItemPool):GetOne()
    item:InitLbQuickEntranceItem(actionData)
    local actionId = actionData:GetLbIntrctActionId()
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self._entranceItemDic)[actionId] = item
  end
end

UINActLbQuickEntrance.UpdActLbQuickEntranceItemState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for k,item in ipairs((self._entranceItemPool).listItem) do
    item:UpdLbQuickEntranceItemLock()
    item:UpdLbQuickEntranceItemBlueDot()
  end
end

UINActLbQuickEntrance.UpdActLbQuickEntranceItemUnlockById = function(self, actionId)
  -- function num : 0_3
  if self._entranceItemDic == nil then
    return 
  end
  local entranceItem = (self._entranceItemDic)[actionId]
  if entranceItem then
    entranceItem:UpdLbQuickEntranceItemLock()
  end
end

UINActLbQuickEntrance.UpdActLbQuickEntranceItemBludotById = function(self, actionId)
  -- function num : 0_4
  if self._entranceItemDic == nil then
    return 
  end
  local entranceItem = (self._entranceItemDic)[actionId]
  if entranceItem then
    entranceItem:UpdLbQuickEntranceItemBlueDot()
  end
end

UINActLbQuickEntrance.UpdActLbQuickEntranceActTimer = function(self, tile, timer, days)
  -- function num : 0_5
  (self._actTimerNode):Show()
  ;
  (self._actTimerNode):UpdActTimer(tile, timer, days)
end

UINActLbQuickEntrance._OnClickClose = function(self)
  -- function num : 0_6 , upvalues : _ENV, ActLbEnum, animNameOut
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl then
    actLbCtrl:SetActLbState((ActLbEnum.eActLbState).Normal)
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_root).blocksRaycasts = false
  local animState = ((self.ui).anim_root):get_Item(animNameOut)
  ;
  ((self.ui).anim_root):Play(animNameOut)
  self._HideTimer = TimerManager:StartTimer(animState.length, self.Hide, self)
end

UINActLbQuickEntrance.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  TimerManager:StopTimer(self._HideTimer)
  ;
  (base.OnDelete)(self)
end

return UINActLbQuickEntrance

