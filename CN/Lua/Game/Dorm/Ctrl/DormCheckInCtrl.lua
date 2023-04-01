-- params : ...
-- function num : 0 , upvalues : _ENV
local DormCtrlBase = require("Game.Dorm.Ctrl.DormCtrlBase")
local DormCheckInCtrl = class("DormCheckInCtrl", DormCtrlBase)
DormCheckInCtrl.InitDmCheckInCtrl = function(self, fromRoomSpos, enterFunc, exitFunc)
  -- function num : 0_0 , upvalues : _ENV
  local checkInRoomDataList = {}
  local dmHouseData = ((self.dormCtrl).houseCtrl).curHouse
  local roomList = dmHouseData:GetDmHouseRoomList()
  local roomEnableUnbindList = {}
  for k,v in ipairs(roomList) do
    (table.insert)(checkInRoomDataList, v)
    roomEnableUnbindList[k] = v:GetEnableUnbind()
  end
  ;
  (table.sort)(checkInRoomDataList, function(a, b)
    -- function num : 0_0_0 , upvalues : fromRoomSpos
    local isFromA = a.spos == fromRoomSpos
    local isFromB = b.spos == fromRoomSpos
    local indexA = a:GetDmRoomIndex()
    local indexB = b:GetDmRoomIndex()
    if isFromA ~= isFromB then
      return isFromA
    end
    do return indexA < indexB end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
)
  self.dmHouseData = dmHouseData
  self.roomEnableUnbindList = roomEnableUnbindList
  self.checkInRoomDataList = checkInRoomDataList
  UIManager:ShowWindowAsync(UIWindowTypeID.DormCheckIn, function(window)
    -- function num : 0_0_1 , upvalues : enterFunc, dmHouseData, checkInRoomDataList, fromRoomSpos, exitFunc, self
    if window == nil then
      return 
    end
    if enterFunc ~= nil then
      enterFunc()
    end
    window:InitDormCheckIn(dmHouseData, checkInRoomDataList, fromRoomSpos, exitFunc, self)
  end
)
end

DormCheckInCtrl.CheckDmRoomEnableUnbind = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local opDic = {}
  local num = 0
  local roomList = (self.dmHouseData):GetDmHouseRoomList()
  for k,oldEnableUnbind in ipairs(self.roomEnableUnbindList) do
    local roomData = roomList[k]
    local curEnableUnbind = roomData:GetEnableUnbind()
    if curEnableUnbind ~= oldEnableUnbind then
      opDic[roomData.spos] = curEnableUnbind
      num = num + 1
    end
  end
  if num == 0 then
    return 
  end
  ;
  ((self.dormCtrl).dormNetwork):CS_DORM_HouseRoomBindUnbind((self.dmHouseData).id, opDic)
  MsgCenter:Broadcast(eMsgEventId.DormUnbindSwitchChanged, opDic)
end

DormCheckInCtrl.ChangeDmBindInfo = function(self, bindInfoDic)
  -- function num : 0_2 , upvalues : _ENV
  local sendList = {}
  local sendDic = {}
  for fntData,bindInfo in pairs(bindInfoDic) do
    local oldHeroId = fntData:GetFntParam()
    -- DECOMPILER ERROR at PC18: Unhandled construct in 'MakeBoolean' P1

    if bindInfo.bindHero and bindInfo.heroId ~= oldHeroId then
      (table.insert)(sendList, bindInfo)
      sendDic[fntData] = bindInfo
    end
    if bindInfo.heroId == oldHeroId then
      (table.insert)(sendList, bindInfo)
    end
    sendDic[fntData] = bindInfo
  end
  do
    if #sendList == 0 then
      local win = UIManager:GetWindow(UIWindowTypeID.DormCheckIn)
      if win ~= nil then
        win:HideDmCheckInDetailNode()
      end
    end
    self._sendBindDic = sendDic
    if not self._OnChangeDmBindInfoFunc then
      self._OnChangeDmBindInfoFunc = BindCallback(self, self._OnChangeDmBindInfo)
      ;
      (NetworkManager:GetNetwork(NetworkTypeID.Dorm)):CS_DORM_OneKeyBindUnbindHero(sendList, self._OnChangeDmBindInfoFunc)
    end
  end
end

DormCheckInCtrl._OnChangeDmBindInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for fntData,bindInfo in pairs(self._sendBindDic) do
    if bindInfo.bindHero then
      fntData:SetFntParam(bindInfo.heroId, true)
    else
      fntData:SetFntParam(0, true)
    end
  end
  ;
  (self.dormCtrl):SetAllBindFntDataDirty()
  MsgCenter:Broadcast(eMsgEventId.DormBindRoleChanged)
  local win = UIManager:GetWindow(UIWindowTypeID.DormCheckIn)
  if win ~= nil then
    win:UpdDmCheckInOverView()
    win:HideDmCheckInDetailNode()
  end
end

DormCheckInCtrl.OnDelete = function(self)
  -- function num : 0_4
end

return DormCheckInCtrl

