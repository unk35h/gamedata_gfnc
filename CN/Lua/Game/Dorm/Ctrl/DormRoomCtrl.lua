-- params : ...
-- function num : 0 , upvalues : _ENV
local DormCtrlBase = require("Game.Dorm.Ctrl.DormCtrlBase")
local DormRoomCtrl = class("DormRoomCtrl", DormCtrlBase)
local DormEditRoomData = require("Game.Dorm.Data.DormEditRoomData")
local DormFurnitureData = require("Game.Dorm.Data.DormFurnitureData")
local DormEnum = require("Game.Dorm.DormEnum")
local DormFntBottomEntity = require("Game.Dorm.Entity.DormFntBottomEntity")
local DormUtil = require("Game.Dorm.DormUtil")
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_Physics = CS.PhysicsUtility
local CS_MessageCommon = CS.MessageCommon
local CS_DormCameraController = CS.DormCameraController
local CS_GameObject = (CS.UnityEngine).GameObject
local CS_UnityUtility = CS.UnityUtility
DormRoomCtrl.ctor = function(self, dormCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__onFingerDown = BindCallback(self, self.OnFingerDown)
  self.__onFingerSet = BindCallback(self, self.OnFingerSet)
  self.__onFingerUp = BindCallback(self, self.OnFingerUp)
  self.__onFingerTap = BindCallback(self, self.OnFingerTap)
  self.__update__handle = BindCallback(self, self.OnUpdate)
  self.__onItemChangeEvent = BindCallback(self, self.OnItemChange)
  self.__onConfirmEditComplete = BindCallback(self, self.ConfirmDormRoomEditComplete)
  self._DmWallPaperLayerIdxChanged = BindCallback(self, self._OnWallpaperLayerIdxChanged)
  self._oldPos = {}
  self._grid = {}
end

DormRoomCtrl.OnEnterDormRoomStart = function(self, roomEntity)
  -- function num : 0_1
  self.roomEntity = roomEntity
end

DormRoomCtrl.OnEnterDormRoomEnd = function(self, roomEntity)
  -- function num : 0_2 , upvalues : CS_LeanTouch, _ENV, DormEditRoomData
  (CS_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
  ;
  (CS_LeanTouch.OnFingerSet)("+", self.__onFingerSet)
  ;
  (CS_LeanTouch.OnFingerUp)("+", self.__onFingerUp)
  ;
  (CS_LeanTouch.OnFingerTap)("+", self.__onFingerTap)
  UpdateManager:AddUpdate(self.__update__handle)
  TimerManager:AddLateCommand(function()
    -- function num : 0_2_0 , upvalues : self
    self:UpdDmRoomWallVisible()
  end
)
  self.__wallCheckTime = 0
  self.bind = (self.dormCtrl).bind
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__onItemChangeEvent)
  MsgCenter:AddListener(eMsgEventId.DmWallpaperLayerIdxChanged, self._DmWallPaperLayerIdxChanged)
  self.editRoomData = (DormEditRoomData.New)()
  ;
  ((self.dormCtrl).dormWindow):RefreshDormHeroList()
end

DormRoomCtrl.ShowDormRoomUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.DormRoom, function(window)
    -- function num : 0_3_0 , upvalues : self, _ENV
    if window == nil then
      return 
    end
    window:InitUIDormRoom(self)
    if self.__autoEnterEditMode then
      self.__autoEnterEditMode = false
      TimerManager:AddLateCommand(function()
      -- function num : 0_3_0_0 , upvalues : self
      self:EnterDormRoomEdit()
    end
)
    end
  end
)
end

DormRoomCtrl.OnExitDormRoomStart = function(self, roomEntity)
  -- function num : 0_4 , upvalues : _ENV, CS_LeanTouch
  if self.roomEntity == nil then
    return 
  end
  ;
  (self.roomEntity):ResetDormRoomWall()
  ;
  (self.roomEntity):ResetAllFntAniState()
  self.roomEntity = nil
  self.editRoomData = nil
  UIManager:HideWindow(UIWindowTypeID.DormRoom)
  ;
  (CS_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
  ;
  (CS_LeanTouch.OnFingerSet)("-", self.__onFingerSet)
  ;
  (CS_LeanTouch.OnFingerUp)("-", self.__onFingerUp)
  ;
  (CS_LeanTouch.OnFingerTap)("-", self.__onFingerTap)
  UpdateManager:RemoveUpdate(self.__update__handle)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__onItemChangeEvent)
  MsgCenter:RemoveListener(eMsgEventId.DmWallpaperLayerIdxChanged, self._DmWallPaperLayerIdxChanged)
end

DormRoomCtrl.SetAutoEnterRoomEdit = function(self)
  -- function num : 0_5
  self.__autoEnterEditMode = true
end

DormRoomCtrl.IsDormFntDrag = function(self)
  -- function num : 0_6
  return self._drag
end

DormRoomCtrl.OnFingerDown = function(self, leanFinger)
  -- function num : 0_7 , upvalues : DormEnum, CS_Physics, _ENV
  if (self.dormCtrl).state ~= (DormEnum.eDormState).RoomEdit or leanFinger.IsOverGui then
    return 
  end
  local hits = (CS_Physics.Raycast)((self.bind).camera, 1 << LayerMask.Raycast, true)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) and (hitCollider.tag == TagConsts.DormFurniture or hitCollider.tag == TagConsts.DormFurnitureCollider) then
      local fntEntity = (self.roomEntity):GetFntByGo(hitCollider.gameObject)
      self:SelectFntEntity(fntEntity)
      self._fingerId = leanFinger.Index
      -- DECOMPILER ERROR at PC52: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._oldPos).x = (fntEntity.fntData).x
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._oldPos).y = (fntEntity.fntData).y
      self._drag = true
      self._dragOffset = nil
      return 
    end
  end
end

DormRoomCtrl.OnFingerSet = function(self, leanFinger)
  -- function num : 0_8 , upvalues : CS_Physics, _ENV, DormEnum
  if not self._drag or self._selectFntEntity == nil or self._fingerId ~= leanFinger.Index or (leanFinger.ScreenDelta).x == 0 and (leanFinger.ScreenDelta).y == 0 then
    return 
  end
  local hits = (CS_Physics.Raycast)((self.bind).camera, 1 << LayerMask.Raycast)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) then
      local hitPos = nil
      local fntType = (self._selectFntEntity).type
      local oldWallIndex = nil
      if (DormEnum.IsFntWallType)(fntType) and hitCollider.tag == TagConsts.DormWall then
        local ok, wallIndex, hitWallTransform = (self.roomEntity):IsDmRoomWall(((hits[i]).collider).gameObject)
        if ok then
          local wallHolder = ((self._selectFntEntity).rootTran).parent
          if hitWallTransform ~= wallHolder and wallIndex ~= ((self._selectFntEntity).fntData):GetFntParam() then
            oldWallIndex = ((self._selectFntEntity).fntData):GetFntParam()
            ;
            (self._selectFntEntity):ChangeDmFntWall(hitWallTransform, wallIndex)
            self:ShowGrid(fntType, wallIndex)
          end
          if not self._dragOffset then
            do
              self._dragOffset = ((self._selectFntEntity).rootTran).position - (hits[i]).point
              hitPos = hitWallTransform:InverseTransformPoint((hits[i]).point + self._dragOffset)
              hitPos.z = 0
              if not (DormEnum.IsFntWallType)(fntType) and hitCollider.tag == TagConsts.DormFloor then
                if not self._dragOffset then
                  self._dragOffset = ((self._selectFntEntity).rootTran).position - (hits[i]).point
                  hitPos = (((self._selectFntEntity).rootTran).parent):InverseTransformPoint((hits[i]).point + self._dragOffset)
                  hitPos.y = 0
                  do
                    local move, oldX, oldY = (self._selectFntEntity):SetFntEntityPosFromUnity(hitPos, oldWallIndex ~= nil)
                    if move then
                      local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
                      if roomWin ~= nil then
                        (roomWin.dmRoomEditNode):DmRoomEditOperateShow(false)
                      end
                      local doorOldFloorAreaList = nil
                      if fntType == (DormEnum.eDormFntType).Door then
                        doorOldFloorAreaList = (self._selectFntEntity):GetFntDoorAreaList(oldX, oldY, oldWallIndex)
                      end
                      local oldAreaList = (self._selectFntEntity):GetFntAreaList(oldX, oldY)
                      ;
                      (self.roomEntity):UpdateFntMap(self._selectFntEntity, false, oldAreaList, oldWallIndex, doorOldFloorAreaList)
                      ;
                      (self.roomEntity):UpdateFntMap(self._selectFntEntity, true)
                      self._edited = true
                    end
                    do break end
                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC190: LeaveBlock: unexpected jumping out IF_STMT

                  end
                end
              end
            end
          end
        end
      end
    end
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

DormRoomCtrl.OnFingerUp = function(self, leanFinger)
  -- function num : 0_9 , upvalues : _ENV
  if not self._drag or self._selectFntEntity == nil or self._fingerId ~= leanFinger.Index then
    return 
  end
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    (roomWin.dmRoomEditNode):DmRoomEditSelectFntMode(true)
  end
  self._fingerId = nil
  self._drag = false
end

DormRoomCtrl.OnFingerTap = function(self, leanFinger)
  -- function num : 0_10 , upvalues : DormEnum, CS_Physics, _ENV
  if leanFinger.IsOverGui or leanFinger.StartedOverGui then
    return 
  end
  if self._selectFntEntity ~= nil and not self._drag then
    self:DeselectFntEntity()
  end
  if (self.dormCtrl).state == (DormEnum.eDormState).Room then
    local hits = (CS_Physics.Raycast)((self.bind).camera, 1 << LayerMask.Raycast, true)
    for i = 0, hits.Length - 1 do
      local hitCollider = (hits[i]).collider
      if not IsNull(hitCollider) and (hitCollider.tag == TagConsts.DormFurniture or hitCollider.tag == TagConsts.DormFurnitureCollider) then
        local fntEntity = (self.roomEntity):GetFntByGo(hitCollider.gameObject)
        fntEntity:StartFntTouch()
        break
      end
    end
  end
end

DormRoomCtrl.OnUpdate = function(self)
  -- function num : 0_11 , upvalues : _ENV
  do
    if self._selectFntEntity ~= nil then
      local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
      if roomWin ~= nil then
        ((roomWin.dmRoomEditNode).dmRoomFntOp):UpdDmRoomFntOpPos((self._selectFntEntity):GetFntEntityCenterTrasform())
      end
    end
    self:__RoomWallCheck()
  end
end

DormRoomCtrl.__RoomWallCheck = function(self)
  -- function num : 0_12 , upvalues : _ENV
  self.__wallCheckTime = self.__wallCheckTime - Time.deltaTime
  if self.__wallCheckTime <= 0 then
    self.__wallCheckTime = (ConfigData.buildinConfig).DormRoomWallCheck
    self:UpdDmRoomWallVisible()
  end
end

DormRoomCtrl.UpdDmRoomWallVisible = function(self)
  -- function num : 0_13 , upvalues : CS_UnityUtility, CS_DormCameraController
  local angle = (CS_UnityUtility.GetTargetForwardAngle)((CS_DormCameraController.Instance).transform, (self.roomEntity).transform)
  if angle >= -22.5 and angle < 22.5 then
    (self.roomEntity):Show3Hide1DormRoom(3)
  else
    if angle >= 22.5 and angle < 67.5 then
      (self.roomEntity):Show2Hide2DormRoom(1, 2, 3, 4)
    else
      if angle >= 67.5 and angle < 112.5 then
        (self.roomEntity):Show3Hide1DormRoom(4)
      else
        if angle >= 112.5 and angle < 157.5 then
          (self.roomEntity):Show2Hide2DormRoom(2, 3, 4, 1)
        else
          if angle >= 157.5 or angle < -157.5 then
            (self.roomEntity):Show3Hide1DormRoom(1)
          else
            if angle >= -157.5 and angle < -112.5 then
              (self.roomEntity):Show2Hide2DormRoom(3, 4, 1, 2)
            else
              if angle >= -112.5 and angle < -67.5 then
                (self.roomEntity):Show3Hide1DormRoom(2)
              else
                ;
                (self.roomEntity):Show2Hide2DormRoom(4, 1, 2, 3)
              end
            end
          end
        end
      end
    end
  end
end

DormRoomCtrl.SelectFntEntity = function(self, fntEntity)
  -- function num : 0_14 , upvalues : _ENV, DormUtil, DormEnum
  self._selectFntEntity = fntEntity
  local fntData = fntEntity.fntData
  self:ShowGrid(fntData:GetFntType(), fntData:GetFntParam())
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    local fntName = fntData:GetName()
    local fntType = fntData:GetFntType()
    local showRecycleBtn = fntData:IsDmFntDoor() and not (DormUtil.IsDmRoomDefaultDoorId)(fntData.id)
    local notInWall = not (DormEnum.IsFntWallType)(fntType)
    ;
    ((roomWin.dmRoomEditNode).dmRoomFntOp):InitDmRoomFntOperate(self, fntName, notInWall, showRecycleBtn)
    ;
    (roomWin.dmRoomEditNode):DmRoomEditSelectFntMode(true)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

DormRoomCtrl.DeselectFntEntity = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self._selectFntEntity == nil then
    return 
  end
  self._selectFntEntity = nil
  self:HideAllGrid()
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    (roomWin.dmRoomEditNode):DmRoomEditSelectFntMode(false)
  end
  if self.editWindow ~= nil then
    (self.editWindow):UpdateUIDormRoomEdit()
  end
end

DormRoomCtrl.OnDmRoomWallShow = function(self, wallId, isShow)
  -- function num : 0_16 , upvalues : _ENV
  if self._selectFntEntity == nil or ((self._selectFntEntity).fntData):GetFntParam() ~= wallId then
    return 
  end
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    (roomWin.dmRoomEditNode):DmRoomEditOperateShow(isShow, true)
  end
end

DormRoomCtrl.ResetFntEntity = function(self)
  -- function num : 0_17
  if self._selectFntEntity == nil then
    return 
  end
  ;
  (self.roomEntity):ResetDmRoomFntEntity(self._selectFntEntity, true)
end

DormRoomCtrl.OnItemChange = function(self, itemUpdate, resourceData)
  -- function num : 0_18 , upvalues : DormEnum
  if resourceData.backpack == nil then
    return 
  end
  if self.editRoomData ~= nil and (self.dormCtrl).state == (DormEnum.eDormState).RoomEdit then
    (self.editRoomData):OnItemChange(itemUpdate, resourceData)
  end
end

DormRoomCtrl.EnterDormRoomEdit = function(self, resetData)
  -- function num : 0_19 , upvalues : _ENV, CS_DormCameraController
  ((self.dormCtrl).characterCtrl):EndOperateCharacter()
  if resetData == nil then
    resetData = true
  end
  if resetData then
    (self.editRoomData):ResetStorateFntData(true)
  end
  self._recycledFntDic = {}
  self:TryInitGrid()
  ;
  (self.roomEntity):EnterRoomEditMode((self._grid).floor, (self._grid).wall, self)
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    roomWin:OnDRoomEidtMode(true)
  end
  ;
  (UIUtil.SetTopStatusBtnShow)(false, false)
  ;
  (CS_DormCameraController.Instance):DmRoomEditorEnterTween(true)
  ;
  (self.dormCtrl):EmitEnterDormRoomEditMode(self.roomEntity)
end

DormRoomCtrl.GetDmRoomFntConfigStr = function(self)
  -- function num : 0_20 , upvalues : _ENV
  if self.roomEntity == nil then
    error("self.roomEntity == nil")
    return ""
  end
  local roomData = (self.roomEntity).roomData
  local tab = {data = roomData:GetFntDatas(), wallId = roomData.wallId, floorId = roomData.floorId, door = (roomData.dmRoomDoorData):GetDmFntServerData()}
  local str = (table.Table2String)(tab)
  print((serpent.block)((table.String2Table)(str)))
  return str
end

DormRoomCtrl.LoadDmRoomTheme = function(self, themeData)
  -- function num : 0_21 , upvalues : _ENV
  self._isInLoadTheme = true
  self:ClearAllFnt()
  do
    if themeData.wallId > 0 then
      local fntWarehousedata = (self.editRoomData):GetDmStorageFntData(themeData.wallId)
      if fntWarehousedata ~= nil and fntWarehousedata.count > 0 then
        self:InstallFnt(fntWarehousedata)
      end
    end
    do
      if themeData.floorId > 0 then
        local fntWarehousedata = (self.editRoomData):GetDmStorageFntData(themeData.floorId)
        if fntWarehousedata ~= nil and fntWarehousedata.count > 0 then
          self:InstallFnt(fntWarehousedata)
        end
      end
      for k,v in ipairs(themeData.data) do
        local fntWarehousedata = (self.editRoomData):GetDmStorageFntData(v.id)
        if fntWarehousedata ~= nil and fntWarehousedata.count > 0 then
          self:_SetInstallFntParam(v)
          self:InstallFnt(fntWarehousedata)
        end
      end
      local doorFntWarehousedata = (self.editRoomData):GetDmStorageFntData((themeData.door).id)
      if doorFntWarehousedata ~= nil and doorFntWarehousedata.count > 0 then
        self:_SetInstallFntParam(themeData.door)
        self:InstallFnt(doorFntWarehousedata)
      end
      self._isInLoadTheme = false
    end
  end
end

DormRoomCtrl.ConfirmDormRoomEdit = function(self)
  -- function num : 0_22 , upvalues : CS_MessageCommon, _ENV
  if not self:HasDmRoomEdited() then
    self:ExitDormRoomEdit()
    return 
  end
  if (self.roomEntity):FntMapOverlap() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Dorm_FntConfirmEdit))
    return 
  end
  local roomData = (self.roomEntity).roomData
  local wallId = roomData.wallId
  local floorId = roomData.floorId
  local doorData = (roomData.dmRoomDoorData):GetDmFntServerData()
  local houseId = (((self.dormCtrl).houseCtrl).curHouse).id
  local roomPos = (self.roomEntity).spos
  self._newFntDataList = roomData:GetFntDatas(true)
  self.updateDic = self:GetAddAndRemoveDic(roomData)
  ;
  ((self.dormCtrl).dormNetwork):CS_DORM_RoomEdit(houseId, roomPos, self._newFntDataList, wallId, floorId, doorData, self.__onConfirmEditComplete)
end

DormRoomCtrl.GetAddAndRemoveDic = function(self, roomData)
  -- function num : 0_23 , upvalues : _ENV
  local newDic = self:__GenFmtDic(roomData, false)
  local oldDic = self:__GenFmtDic(roomData.oldRoomdata, true)
  local updateDic = {}
  for i,v in pairs(newDic) do
    local oldValue = oldDic[i]
    -- DECOMPILER ERROR at PC19: Unhandled construct in 'MakeBoolean' P1

    if oldValue and v ~= oldValue then
      updateDic[i] = v - oldValue
    end
    updateDic[i] = v
  end
  for i,v in pairs(oldDic) do
    local newValue = newDic[i]
    if not newValue then
      updateDic[i] = -v
    end
  end
  return updateDic
end

DormRoomCtrl.__GenFmtDic = function(self, roomData, isOld)
  -- function num : 0_24 , upvalues : _ENV
  local doorId, dataList = nil, nil
  local wallId = roomData.wallId
  local floorId = roomData.floorId
  if isOld then
    doorId = (roomData.door).id
    dataList = roomData.data
  else
    doorId = ((roomData.dmRoomDoorData):GetDmFntServerData()).id
    dataList = roomData:GetFntDatas(true)
  end
  local fmtDic = {}
  fmtDic[doorId] = 1
  fmtDic[wallId] = 1
  fmtDic[floorId] = 1
  for i,v in pairs(dataList) do
    if fmtDic[v.id] then
      fmtDic[v.id] = fmtDic[v.id] + 1
    else
      fmtDic[v.id] = 1
    end
  end
  return fmtDic
end

DormRoomCtrl.ConfirmDormRoomEditComplete = function(self, dataList)
  -- function num : 0_25 , upvalues : _ENV
  if dataList.Count == 0 then
    error("dataList.Count == 0")
    return 
  end
  local success = dataList[0]
  if success then
    ((self.roomEntity).roomData):UpdateRoomFntData(self._newFntDataList, false)
    ;
    ((self.roomEntity).roomData):SaveDmRoomData()
    self:ExitDormRoomEdit(true)
  end
  ;
  (PlayerDataCenter.dormBriefData):UpdateDormBriefFurnitureTotal(self.updateDic)
  self._newFntDataList = nil
end

DormRoomCtrl.HasDmRoomEdited = function(self)
  -- function num : 0_26
  return self._edited
end

DormRoomCtrl.ExitDormRoomEdit = function(self, editSuccess, fromTopStates)
  -- function num : 0_27 , upvalues : _ENV, CS_DormCameraController
  if not fromTopStates then
    (UIUtil.ForcePopFromBackStack)()
  end
  ;
  (UIUtil.SetTopStatusBtnShow)(true, true)
  local restore = false
  if self._edited and not editSuccess then
    self:RestoreDormRoomEdit()
    restore = true
  end
  self._edited = false
  self._selectFntEntity = nil
  self.editWindow = nil
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    roomWin:OnDRoomEidtMode(false)
    if restore then
      roomWin:RefreshDormRoomBaseInfo()
    end
  end
  for fntData,fntEntity in pairs(self._recycledFntDic) do
    fntEntity:OnDelete()
  end
  self._recycledFntDic = nil
  self:RecycleAllGrid()
  ;
  (self.roomEntity):ExitRoomEditMode(self, editSuccess)
  ;
  (self.dormCtrl):SetAllBindFntDataDirty()
  ;
  (CS_DormCameraController.Instance):DmRoomEditorEnterTween(false)
  ;
  (self.dormCtrl):EmitExitDormRoomEditMode(self.roomEntity, editSuccess)
end

DormRoomCtrl.RestoreDormRoomEdit = function(self)
  -- function num : 0_28 , upvalues : _ENV
  if not self._edited then
    return 
  end
  local fntObjDic = (self.roomEntity):GetFntObjDic()
  local recycleList = {}
  for go,fntEntity in pairs(fntObjDic) do
    if not (self.roomEntity):IsOriginDmRoomFnt(fntEntity.fntData) then
      (table.insert)(recycleList, fntEntity)
    end
  end
  for k,fntEntity in ipairs(recycleList) do
    self:RecycleFnt(fntEntity)
  end
  ;
  (self.roomEntity):ReinitAllFntEntity()
  ;
  ((self.roomEntity).roomData):DmRoomResetWallpaper()
  self:ResetDmRoomDoor(false, false)
  ;
  (self.roomEntity):InitFntMapData()
  self:ResetDmRoomFloor()
  self:ResetDmRoomWall()
  ;
  (self.editRoomData):ResetStorateFntData()
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    (roomWin.dmRoomEditNode):ReinitDmRoomtEditData()
  end
  self._recycledFntDic = {}
  self._edited = false
end

DormRoomCtrl._OnWallpaperLayerIdxChanged = function(self, changeLayerFntDic)
  -- function num : 0_29 , upvalues : _ENV
  for fntDt,_ in pairs(changeLayerFntDic) do
    local fEntity = (self.roomEntity):GetFntByData(fntDt)
    if fEntity ~= nil then
      fEntity:TryUpdDmFntWallpaperLayer()
    end
  end
end

local _installFloorFntFunc = function(self, fntId)
  -- function num : 0_30
  local fntData = self:_NewFntData(fntId)
  local roomData = (self.roomEntity).roomData
  if self._InstallFntParamTab == nil then
    fntData:SetFntPos(roomData:GetRoomGridLengthCount() // 2, roomData:GetRoomGridHeightCount() // 2)
  end
  fntData:CheckOutMap()
  self:InstallFntConfirm(fntData)
end

local _InstallFntFunc = {[(DormEnum.eDormFntType).FloorDecoration] = _installFloorFntFunc, [(DormEnum.eDormFntType).WallDecoration] = function(self, fntId)
  -- function num : 0_31
  local fntData = self:_NewFntData(fntId)
  local roomData = (self.roomEntity).roomData
  local wallId = 1
  if self._InstallFntParamTab == nil then
    fntData:SetFntPos(roomData:GetRoomGridLengthCount() // 2, roomData:GetRoomGridHeightCount() // 2)
  else
    wallId = (self._InstallFntParamTab).param
  end
  fntData:CheckOutMap()
  self:InstallFntConfirm(fntData, wallId)
end
, [(DormEnum.eDormFntType).Furniture] = _installFloorFntFunc, [(DormEnum.eDormFntType).Wall] = function(self, fntId)
  -- function num : 0_32
  local curId = ((self.roomEntity).roomData).wallId
  if curId == fntId then
    return 
  end
  if fntId == 0 then
    self:ResetDmRoomWall(true)
    return 
  end
  ;
  ((self.roomEntity).roomData):SetDmRoomWall(fntId)
  ;
  (self.roomEntity):ChangeDmRoomWall(fntId)
  ;
  (self.editRoomData):InstallFntData(fntId)
  if curId ~= 0 then
    (self.editRoomData):UninstallFntData(curId)
  end
end
, [(DormEnum.eDormFntType).Floor] = function(self, fntId)
  -- function num : 0_33
  local curId = ((self.roomEntity).roomData).floorId
  if curId == fntId then
    return 
  end
  if fntId == 0 then
    self:ResetDmRoomFloor(true)
    return 
  end
  ;
  ((self.roomEntity).roomData):SetDmRoomFloor(fntId)
  ;
  (self.roomEntity):ChangeDmRoomFloor(fntId)
  ;
  (self.editRoomData):InstallFntData(fntId)
  if curId ~= 0 then
    (self.editRoomData):UninstallFntData(curId)
  end
end
, [(DormEnum.eDormFntType).Door] = function(self, fntId)
  -- function num : 0_34 , upvalues : DormUtil, DormEnum
  local fntData = ((self.roomEntity).roomData).dmRoomDoorData
  local curId = fntData.id
  local doorEntity = (self.roomEntity):GetFntByData(fntData)
  local doorOldFloorAreaList = doorEntity:GetFntDoorAreaList(fntData.x, fntData.y)
  local oldAreaList = doorEntity:GetFntAreaList(fntData.x, fntData.y)
  local sameDoorId = not fntData:TryFntDoorDataChangeDoor(fntId)
  local oldWallIndex = nil
  if self._InstallFntParamTab ~= nil then
    oldWallIndex = fntData:GetFntParam()
    local x, y = (DormUtil.FntCoord2XY)((self._InstallFntParamTab).pos)
    local wallId = (self._InstallFntParamTab).param
    local wallHolder = (self.roomEntity):GetFntHolder((DormEnum.eDormFntType).Door, wallId)
    doorEntity:ChangeDmFntWall(wallHolder, wallId)
    doorEntity:SetFntEntityPos(x, y)
  end
  do
    doorEntity:SetFntEntityPosFromUnity(doorEntity:GetFntEntityLocalPos(), true)
    ;
    (self.roomEntity):UpdateFntMap(doorEntity, false, oldAreaList, oldWallIndex, doorOldFloorAreaList)
    ;
    (self.roomEntity):UpdateFntMap(doorEntity, true)
    if sameDoorId then
      return 
    end
    if not (DormUtil.IsDmRoomDefaultDoorId)(fntId) then
      (self.editRoomData):InstallFntData(fntId)
    end
    if curId ~= 0 then
      (self.editRoomData):UninstallFntData(curId)
    end
    ;
    (self.roomEntity):ChangeDmRoomDoorGo()
  end
end
, [(DormEnum.eDormFntType).Wallpaper] = function(self, fntId)
  -- function num : 0_35
  local roomData = (self.roomEntity).roomData
  local fntData = self:_NewFntData(fntId)
  local wallId = 1
  if self._InstallFntParamTab == nil then
    fntData:SetFntPos(roomData:GetRoomGridLengthCount() // 2, roomData:GetRoomGridHeightCount() // 2)
  else
    wallId = (self._InstallFntParamTab).param
  end
  fntData:CheckOutMap()
  ;
  ((self.roomEntity).roomData):AddDmWallpaper(fntData, wallId)
  self:InstallFntConfirm(fntData, wallId)
end
}
DormRoomCtrl._NewFntData = function(self, fntId)
  -- function num : 0_36 , upvalues : DormFurnitureData
  local fntData = (DormFurnitureData.New)()
  fntData:InitFntData(fntId, (self.roomEntity).roomData, self._InstallFntParamTab)
  return fntData
end

DormRoomCtrl._SetInstallFntParam = function(self, paramTab)
  -- function num : 0_37
  self._InstallFntParamTab = paramTab
end

DormRoomCtrl.InstallFnt = function(self, fntWarehousedata)
  -- function num : 0_38 , upvalues : DormEnum, _InstallFntFunc, _ENV
  if (self.dormCtrl).state ~= (DormEnum.eDormState).Room or (self.dormCtrl).state == (DormEnum.eDormState).RoomEdit then
    do return  end
    local fntId = fntWarehousedata.id
    local fntType = (fntWarehousedata.fntCfg).type
    local installFunc = _InstallFntFunc[fntType]
    if installFunc == nil then
      error((string.format)("unsurpported fntType, fntType:%s, fntId:%s", fntType, fntId))
      return 
    end
    installFunc(self, fntId)
    self._InstallFntParamTab = nil
    self._edited = true
  end
end

DormRoomCtrl.InstallFntConfirm = function(self, fntData, param)
  -- function num : 0_39 , upvalues : _ENV
  fntData:SetFntParam(param)
  fntData:RecordOriginalFntData()
  local fntEntity = (self.roomEntity):CreateFntEntity(fntData, true)
  local bottomItem = self:GetFntBottomItem()
  fntEntity:AddFntBottom(bottomItem)
  ;
  (self.editRoomData):InstallFntData(fntData.id)
  self._edited = true
  if not self._isInLoadTheme then
    self:SelectFntEntity(fntEntity)
    local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
    if roomWin ~= nil then
      (roomWin.dmRoomEditNode):DmRoomEditSelectFntMode(true)
    end
  end
end

DormRoomCtrl.RecycleFntSelect = function(self)
  -- function num : 0_40 , upvalues : DormEnum, _ENV
  if self._selectFntEntity == nil then
    return 
  end
  local fntData = (self._selectFntEntity).fntData
  if fntData:GetFntType() == (DormEnum.eDormFntType).Door then
    self:ResetDmRoomDoor(true, true)
    local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
    if roomWin ~= nil then
      local fntName = fntData:GetName()
      ;
      ((roomWin.dmRoomEditNode).dmRoomFntOp):InitDmRoomFntOperate(self, fntName, false, false)
    end
  else
    do
      self:RecycleFnt(self._selectFntEntity)
      self:DeselectFntEntity()
      self._edited = true
    end
  end
end

DormRoomCtrl.RecycleFnt = function(self, fntEntity, isRemoveAll)
  -- function num : 0_41 , upvalues : _ENV
  local fntData = fntEntity.fntData
  if fntData:IsDmFntDoor() then
    warn("Cant recycle fnt door")
    return 
  end
  ;
  (self.editRoomData):UninstallFntData(fntData.id)
  ;
  (self.roomEntity):RemoveFntEntity(fntEntity, isRemoveAll)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  if (self.roomEntity):IsOriginDmRoomFnt(fntEntity.fntData) then
    (self._recycledFntDic)[fntEntity.fntData] = fntEntity
    fntEntity:OnRecycleOriginFnt()
  else
    local fntBottomItem = fntEntity:RemoveFntBottom()
    if fntBottomItem ~= nil then
      self:RecycleFntBottomItem(fntBottomItem)
    end
    fntEntity:OnDelete()
  end
end

DormRoomCtrl.ClearAllFnt = function(self)
  -- function num : 0_42 , upvalues : _ENV
  local fntObjDic = (self.roomEntity):GetFntObjDic()
  local recycleList = {}
  for go,fntEntity in pairs(fntObjDic) do
    if not (fntEntity.fntData):IsDmFntDoor() then
      (table.insert)(recycleList, fntEntity)
    end
  end
  for k,fntEntity in ipairs(recycleList) do
    self:RecycleFnt(fntEntity, true)
  end
  ;
  ((self.roomEntity).roomData):DmRoomClearWallpaper()
  self:ResetDmRoomDoor(true)
  self:ResetDmRoomWall(true)
  self:ResetDmRoomFloor(true)
  local roomWin = UIManager:GetWindow(UIWindowTypeID.DormRoom)
  if roomWin ~= nil then
    (roomWin.dmRoomEditNode):DmRoomEditSelectFntMode(false)
  end
  self._selectFntEntity = nil
  self._edited = true
end

DormRoomCtrl.ResetDmRoomWall = function(self, isDefault)
  -- function num : 0_43
  local curWallId = ((self.roomEntity).roomData).wallId
  if not isDefault or not 0 then
    local tarWallId = ((self.roomEntity).roomData):GetDmRoomOldWall()
  end
  if curWallId == tarWallId then
    return 
  end
  ;
  ((self.roomEntity).roomData):SetDmRoomWall(tarWallId)
  ;
  (self.roomEntity):ChangeDmRoomWall(tarWallId)
  if curWallId ~= 0 then
    (self.editRoomData):UninstallFntData(curWallId)
  end
end

DormRoomCtrl.ResetDmRoomFloor = function(self, isDefault)
  -- function num : 0_44
  local curFloorId = ((self.roomEntity).roomData).floorId
  if not isDefault or not 0 then
    local tarFloorId = ((self.roomEntity).roomData):GetDmRoomOldFloor()
  end
  if tarFloorId == curFloorId then
    return 
  end
  ;
  ((self.roomEntity).roomData):SetDmRoomFloor(tarFloorId)
  ;
  (self.roomEntity):ChangeDmRoomFloor(tarFloorId)
  if curFloorId ~= 0 then
    (self.editRoomData):UninstallFntData(curFloorId)
  end
end

DormRoomCtrl.ResetDmRoomDoor = function(self, isDefault, onlyGameObject)
  -- function num : 0_45 , upvalues : DormUtil, _ENV, _InstallFntFunc, DormEnum
  local doorData = ((self.roomEntity).roomData).dmRoomDoorData
  local curDoorId = doorData.id
  if not isDefault or not 0 then
    local tarDoorId = ((self.roomEntity).roomData):GetDmRoomOldDoor()
  end
  if curDoorId ~= tarDoorId then
    if (DormUtil.IsDmRoomDefaultDoorId)(tarDoorId) then
      tarDoorId = (ConfigData.game_config).DmRoomDoorDefaultId
    end
    local installFunc = _InstallFntFunc[(DormEnum.eDormFntType).Door]
    installFunc(self, tarDoorId)
  end
  do
    if onlyGameObject then
      return 
    end
    local doorEntity = (self.roomEntity):GetFntByData(doorData)
    ;
    (self.roomEntity):ResetDmRoomFntEntity(doorEntity, true)
  end
end

DormRoomCtrl.RotateFnt = function(self)
  -- function num : 0_46
  if self._selectFntEntity ~= nil then
    (self.roomEntity):UpdateFntMap(self._selectFntEntity, false)
    ;
    (self._selectFntEntity):RotateFntEntity()
    ;
    (self.roomEntity):UpdateFntMap(self._selectFntEntity, true)
    self._edited = true
  end
end

DormRoomCtrl.TryInitGrid = function(self)
  -- function num : 0_47 , upvalues : _ENV, CS_GameObject
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if IsNull((self._grid).holder) then
    (self._grid).holder = (CS_GameObject("GridHolder")).transform
    ;
    (((self._grid).holder).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._grid).floor = (((self.dormCtrl).comRes).gridFloorPrefab):Instantiate()
    ;
    ((self._grid).floor):SetActive(false)
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._grid).floorQuad = (((self._grid).floor).transform):Find("Quad")
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._grid).wall = {}
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._grid).wallQuad = {}
    for i = 1, 4 do
      local go = (((self.dormCtrl).comRes).gridWallPrefab):Instantiate()
      go:SetActive(false)
      -- DECOMPILER ERROR at PC62: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._grid).wallQuad)[i] = (go.transform):Find("Quad")
      -- DECOMPILER ERROR at PC65: Confused about usage of register: R6 in 'UnsetPending'

      ;
      ((self._grid).wall)[i] = go
    end
  end
  do
    local roomLength = ((self.roomEntity).roomData):GetRoomGridLengthCount()
    local roomHeight = ((self.roomEntity).roomData):GetRoomGridHeightCount()
    local gridNum = 2
    if IsNull((self._grid).floorQuad) then
      error("Cant find Quad")
    else
      local sizeX = roomLength * (ConfigData.game_config).HouseGridWidth
      -- DECOMPILER ERROR at PC98: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self._grid).floorQuad).localScale = (Vector3.New)(sizeX, sizeX, 1)
      local mat = (((self._grid).floorQuad):FindComponent(eUnityComponentID.MeshRenderer)).material
      local matTilingX = roomLength / gridNum
      mat:SetTextureScale("_Maintex", (Vector2.New)(matTilingX, matTilingX))
    end
    do
      for k,quadTran in ipairs((self._grid).wallQuad) do
        if IsNull(quadTran) then
          error("Cant find Quad")
        else
          local sizeX = roomLength * (ConfigData.game_config).HouseGridWidth
          local sizeY = roomHeight * (ConfigData.game_config).HouseGridWidth
          quadTran.localScale = (Vector3.New)(sizeX, sizeY, 1)
          local posY = sizeY / 2
          local posZ = -(sizeX / 2 - 0.01)
          quadTran.localPosition = (Vector3.New)(0, posY, posZ)
          ;
          ((quadTran:FindComponent(eUnityComponentID.Renderer)).material):SetTextureScale("_Maintex", (Vector2.New)(roomLength / gridNum, roomHeight / gridNum))
        end
      end
    end
  end
end

DormRoomCtrl.ShowGrid = function(self, fntType, fntParam)
  -- function num : 0_48 , upvalues : _ENV, DormEnum
  if IsNull((self._grid).holder) then
    return 
  end
  self:HideAllGrid()
  self:_ShowGridInternal(fntType, fntParam)
  if fntType == (DormEnum.eDormFntType).Door then
    self:_ShowGridInternal((DormEnum.eDormFntType).Furniture)
  end
end

DormRoomCtrl._ShowGridInternal = function(self, fntType, fntParam)
  -- function num : 0_49 , upvalues : DormEnum
  local gridGo = nil
  if (DormEnum.IsFntWallType)(fntType) then
    gridGo = ((self._grid).wall)[fntParam]
  else
    gridGo = (self._grid).floor
  end
  gridGo:SetActive(true)
end

DormRoomCtrl.HideAllGrid = function(self)
  -- function num : 0_50 , upvalues : _ENV
  if IsNull((self._grid).holder) then
    return 
  end
  ;
  ((self._grid).floor):SetActive(false)
  for k,go in pairs((self._grid).wall) do
    go:SetActive(false)
  end
end

DormRoomCtrl.RecycleAllGrid = function(self)
  -- function num : 0_51 , upvalues : _ENV
  if IsNull((self._grid).holder) then
    return 
  end
  ;
  (((self._grid).floor).transform):SetParent((self._grid).holder, false)
  for k,go in pairs((self._grid).wall) do
    (go.transform):SetParent((self._grid).holder, false)
  end
end

DormRoomCtrl.GetFntBottomItem = function(self)
  -- function num : 0_52 , upvalues : CS_GameObject, _ENV, DormFntBottomEntity
  if self._fntBottom == nil then
    self._fntBottom = {}
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._fntBottom).pool = {}
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (self._fntBottom).holder = (CS_GameObject("FntBottom Holder")).transform
    ;
    (((self._fntBottom).holder).gameObject):SetActive(false)
  end
  local item = nil
  if #(self._fntBottom).pool > 0 then
    item = (table.remove)((self._fntBottom).pool, 1)
  else
    item = (DormFntBottomEntity.New)()
    local go = (((self.dormCtrl).comRes).fntBottomPrefab):Instantiate()
    item:InitFntBottomGo(go)
  end
  do
    return item
  end
end

DormRoomCtrl.RecycleFntBottomItem = function(self, item)
  -- function num : 0_53 , upvalues : _ENV
  (table.insert)((self._fntBottom).pool, item)
  ;
  (item.transform):SetParent((self._fntBottom).holder, false)
end

DormRoomCtrl.OnDelete = function(self)
  -- function num : 0_54 , upvalues : _ENV
  UpdateManager:RemoveUpdate(self.__update__handle)
  if self.roomEntity ~= nil then
    self:OnExitDormRoomStart()
  end
end

return DormRoomCtrl

