-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmCkeckInRoomItem = class("UINDmCkeckInRoomItem", UIBaseNode)
local base = UIBaseNode
local DormUtil = require("Game.Dorm.DormUtil")
local UINDmCheckInRoomSlotItem = require("Game.Dorm.DUI.CheckIn.UINDmCheckInRoomSlotItem")
local cs_MessageCommon = CS.MessageCommon
UINDmCkeckInRoomItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDmCheckInRoomSlotItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CheckOut, self, self._OnClickCheckOut)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_canVisit, self, self._OnTogCanVisitChanged)
  ;
  ((self.ui).obj_RoomHeroItem):SetActive(false)
  self.slotItemPool = (UIItemPool.New)(UINDmCheckInRoomSlotItem, (self.ui).obj_RoomHeroItem)
end

UINDmCkeckInRoomItem.InitDmCkeckInRoomItem = function(self, roomData, selected, clickSlotFunc)
  -- function num : 0_1 , upvalues : _ENV, DormUtil
  self.roomData = roomData
  self.clickSlotFunc = clickSlotFunc
  local roomIdx = roomData:GetDmRoomIndex()
  local roomName = roomData:GetName()
  ;
  ((self.ui).text_RoomName):SetIndex(0, (string.format)("%02d", roomIdx), roomName)
  ;
  ((self.ui).tex_RoomName):SetIndex(roomIdx)
  ;
  (((self.ui).tran_OnSelect).gameObject):SetActive(selected)
  local uipos = (DormUtil.ToRectTransformPos)(roomData.x, roomData.y)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (((self.ui).img_bluepos).transform).localPosition = uipos
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tog_canVisit).isOn = roomData:GetEnableUnbind()
  self:_UpdAllBindSlot()
end

UINDmCkeckInRoomItem._UpdAllBindSlot = function(self)
  -- function num : 0_2 , upvalues : _ENV, DormUtil
  local curNum = (self.roomData):GetRoomBindCount()
  local allNum = (self.roomData):GetRoomCanBindFntCount()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CheckInCount).text = tostring(curNum) .. "/" .. tostring(allNum)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R3 in 'UnsetPending'

  if curNum ~= 0 or not Color.gray then
    ((self.ui).img_checkout).color = Color.white
    local canBindFntList = (self.roomData):GetRoomCanBindList()
    ;
    (self.slotItemPool):HideAll()
    for i = 1, DormUtil:GetBedCount() do
      local fntData = canBindFntList[i]
      local slotItem = (self.slotItemPool):GetOne()
      slotItem:InitDmCheckInRoomSlotItem(self.clickSlotFunc, self.roomData, fntData)
    end
  end
end

UINDmCkeckInRoomItem._OnClickCheckOut = function(self)
  -- function num : 0_3 , upvalues : cs_MessageCommon, _ENV
  if (self.roomData):GetRoomBindCount() == 0 then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2024))
    return 
  end
  local msgWin = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
  msgWin:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(2026), function()
    -- function num : 0_3_0 , upvalues : self, _ENV
    local msgList = {}
    local fntDataList = (self.roomData):GetRoomCanBindList()
    for k,fntData in ipairs(fntDataList) do
      local param = fntData:GetFntParam()
      if param > 0 then
        local msg = {heroId = param, houseId = (self.roomData).belongtohouseid, roomPos = (self.roomData).spos, elemIdx = (self.roomData):GetFntDataIndex(fntData), bindHero = false}
        ;
        (table.insert)(msgList, msg)
      end
    end
    self._OnCheckOutFunc = BindCallback(self, self._OnCheckOut)
    ;
    (NetworkManager:GetNetwork(NetworkTypeID.Dorm)):CS_DORM_OneKeyBindUnbindHero(msgList, self._OnCheckOutFunc)
  end
)
end

UINDmCkeckInRoomItem._OnCheckOut = function(self)
  -- function num : 0_4 , upvalues : _ENV
  (self.roomData):UnbindAllRoomFntData()
  self:_UpdAllBindSlot()
  local checkinWindow = UIManager:GetWindow(UIWindowTypeID.DormCheckIn)
  if checkinWindow ~= nil then
    checkinWindow:UpdDmCheckInInfo()
  end
  MsgCenter:Broadcast(eMsgEventId.DormBindRoleChanged)
end

UINDmCkeckInRoomItem._OnTogCanVisitChanged = function(self, isOn)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tog_canVisit).isOn = isOn
  ;
  (self.roomData):SetEnableUnbind(isOn)
end

UINDmCkeckInRoomItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (self.slotItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINDmCkeckInRoomItem

