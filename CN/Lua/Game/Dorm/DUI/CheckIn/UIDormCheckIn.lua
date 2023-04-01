-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDormCheckIn = class("UIDormCheckIn", UIBaseWindow)
local base = UIBaseWindow
local UINDmCkeckInRoomItem = require("Game.Dorm.DUI.CheckIn.UINDmCkeckInRoomItem")
local UINDmCheckInDetail = require("Game.Dorm.DUI.CheckIn.Detail.UINDmCheckInDetail")
UIDormCheckIn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDmCkeckInRoomItem, UINDmCheckInDetail
  (UIUtil.AddButtonListener)((self.ui).Btn_Close, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self._OnClickInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_InfoBgClose, self, self._OnClickInfoClose)
  ;
  ((self.ui).RoomItem):SetActive(false)
  self.roomItemPool = (UIItemPool.New)(UINDmCkeckInRoomItem, (self.ui).RoomItem)
  self._ShowBindHeroNodeFunc = BindCallback(self, self._ShowBindHeroNode)
  self.dmCheckInDetailNode = (UINDmCheckInDetail.New)()
  ;
  (self.dmCheckInDetailNode):Init((self.ui).obj_detail)
  ;
  (self.dmCheckInDetailNode):Hide()
end

UIDormCheckIn.InitDormCheckIn = function(self, dmHouseData, checkInRoomDataList, fromRoomSpos, exitFunc, dmCheckInCtrl)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).Text_Title):SetIndex(0)
  self.dmHouseData = dmHouseData
  self.checkInRoomDataList = checkInRoomDataList
  self.exitFunc = exitFunc
  self.fromRoomSpos = fromRoomSpos
  self.dmCheckInCtrl = dmCheckInCtrl
  local checkInRoomDataDic = {}
  for index,roomData in ipairs(checkInRoomDataList) do
    checkInRoomDataDic[roomData] = index
  end
  self.checkInRoomDataDic = checkInRoomDataDic
  self:UpdDmCheckInOverView()
end

UIDormCheckIn.UpdDmCheckInInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local checkincount = (self.dmHouseData):GetDmHouseBindNum()
  local maxcheckincount = (self.dmHouseData):GetHouseCanBindFntCount()
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).Text_CheckInTotalCount).text = tostring(checkincount) .. "/" .. tostring(maxcheckincount)
end

UIDormCheckIn.UpdDmCheckInOverView = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:UpdDmCheckInInfo()
  ;
  (self.roomItemPool):HideAll()
  for k,roomData in ipairs(self.checkInRoomDataList) do
    local selected = roomData.spos == self.fromRoomSpos
    local roomItem = (self.roomItemPool):GetOne()
    roomItem:InitDmCkeckInRoomItem(roomData, selected, self._ShowBindHeroNodeFunc)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIDormCheckIn._ShowBindHeroNode = function(self, roomData)
  -- function num : 0_4
  ((self.ui).obj_overView):SetActive(false)
  ;
  ((self.ui).obj_intro):SetActive(false)
  ;
  (self.dmCheckInDetailNode):Show()
  local index = (self.checkInRoomDataDic)[roomData]
  ;
  (self.dmCheckInDetailNode):InitDmCheckInDetail(roomData, index, self.dmHouseData, self.checkInRoomDataList, self.dmCheckInCtrl)
end

UIDormCheckIn.HideDmCheckInDetailNode = function(self)
  -- function num : 0_5
  ((self.ui).obj_overView):SetActive(true)
  ;
  (self.dmCheckInDetailNode):Hide()
end

UIDormCheckIn._OnClickInfo = function(self)
  -- function num : 0_6
  ((self.ui).Text_Title):SetIndex(1)
  ;
  ((self.ui).obj_intro):SetActive(true)
  ;
  ((self.ui).obj_overView):SetActive(false)
end

UIDormCheckIn._OnClickInfoClose = function(self)
  -- function num : 0_7
  ((self.ui).Text_Title):SetIndex(0)
  ;
  ((self.ui).obj_intro):SetActive(false)
  ;
  ((self.ui).obj_overView):SetActive(true)
end

UIDormCheckIn._OnClickClose = function(self)
  -- function num : 0_8
  if (self.dmCheckInDetailNode).active then
    self:HideDmCheckInDetailNode()
    return 
  end
  if self.exitFunc ~= nil then
    (self.exitFunc)()
  end
  ;
  (self.dmCheckInCtrl):CheckDmRoomEnableUnbind()
  self:Delete()
end

UIDormCheckIn.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self.roomItemPool):DeleteAll()
  ;
  (self.dmCheckInDetailNode):Delete()
  ;
  (base.OnDelete)(self)
end

return UIDormCheckIn

