-- params : ...
-- function num : 0 , upvalues : _ENV
local DormCtrlBase = require("Game.Dorm.Ctrl.DormCtrlBase")
local DormCameraCtrl = class("DormCameraCtrl", DormCtrlBase)
local CS_RenderManager = CS.RenderManager
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_LeanGesture = ((CS.Lean).Touch).LeanGesture
local CS_DormCameraController = CS.DormCameraController
DormCameraCtrl.ctor = function(self, dormCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.__onGesture = BindCallback(self, self._OnGesture)
  self.__update__handle = BindCallback(self, self._OnUpdate)
end

DormCameraCtrl.OnEnterDormHouse = function(self)
  -- function num : 0_1
  local curHouse = ((self.dormCtrl).houseCtrl).curHouse
  local bind = (self.dormCtrl).bind
  if curHouse:IsBigRoomHouse() then
    ((bind.va_Dorm).gameObject):SetActive(false)
    self._vaDorm = bind.va_Dorm_big
  else
    ;
    ((bind.va_Dorm_big).gameObject):SetActive(false)
    self._vaDorm = bind.va_Dorm
  end
  ;
  ((self._vaDorm).gameObject):SetActive(true)
  ;
  (self._vaDorm):MoveToTopOfPrioritySubqueue()
end

DormCameraCtrl.OnEnterDormRoomEditMode = function(self, roomEntity)
  -- function num : 0_2
  local bind = (self.dormCtrl).bind
  if self._isThirdCamera then
    ((bind.va_ThridFollow).gameObject):SetActive(false)
    ;
    ((bind.va_Room).gameObject):SetActive(true)
  end
  self._isRoomEditCam = true
end

DormCameraCtrl.OnExitDormRoomEditMode = function(self, roomEntity, success)
  -- function num : 0_3
  local bind = (self.dormCtrl).bind
  if self._isThirdCamera then
    ((bind.va_ThridFollow).gameObject):SetActive(true)
    ;
    ((bind.va_Room).gameObject):SetActive(false)
  end
  self._isRoomEditCam = false
end

DormCameraCtrl.EnterRoomCameraState = function(self, roomEntity)
  -- function num : 0_4 , upvalues : CS_DormCameraController
  local bind = (self.dormCtrl).bind
  ;
  ((self._vaDorm).gameObject):SetActive(false)
  self._isThirdCamera = false
  if roomEntity:IsBigRoomType() then
    self._isThirdCamera = true
    ;
    ((bind.va_ThridFollow).gameObject):SetActive(true)
    ;
    (bind.va_ThridFollow):MoveToTopOfPrioritySubqueue()
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (bind.ca_ThridFollow).mPlayer = (((self.dormCtrl).cmderCtrl).cmderEntity).transform
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (bind.ca_ThridFollow).mAngleH = (bind.default_thirdFollow).x
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (bind.ca_ThridFollow).mAngleV = (bind.default_thirdFollow).y
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (bind.ca_ThridFollow).mDistance = bind.dis_thirdFollow
  else
    ;
    ((bind.va_Room).gameObject):SetActive(true)
    ;
    (bind.va_Room):MoveToTopOfPrioritySubqueue()
  end
  local distanceVct2 = (roomEntity.roomData):GetDmRoomEditCamDistace()
  ;
  (CS_DormCameraController.Instance):SetVcamRoomEditViewDistance(distanceVct2)
end

DormCameraCtrl.EnterHouseCameraState = function(self)
  -- function num : 0_5
  local bind = (self.dormCtrl).bind
  ;
  ((self._vaDorm).gameObject):SetActive(true)
  if self._isThirdCamera then
    ((bind.va_ThridFollow).gameObject):SetActive(false)
  else
    ;
    ((bind.va_Room).gameObject):SetActive(false)
  end
  ;
  (self._vaDorm):MoveToTopOfPrioritySubqueue()
end

DormCameraCtrl.OnEnterDormRoomEnd = function(self, roomEntity)
  -- function num : 0_6 , upvalues : CS_LeanTouch, _ENV
  self.roomEntity = roomEntity
  ;
  (CS_LeanTouch.OnGesture)("+", self.__onGesture)
  UpdateManager:AddUpdate(self.__update__handle)
end

DormCameraCtrl.OnExitDormRoomStart = function(self, roomEntity)
  -- function num : 0_7 , upvalues : CS_LeanTouch, _ENV
  if self.roomEntity == nil then
    return 
  end
  self.roomEntity = nil
  ;
  (CS_LeanTouch.OnGesture)("-", self.__onGesture)
  UpdateManager:RemoveUpdate(self.__update__handle)
end

DormCameraCtrl._OperateCommonCheck = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if GuideManager.inGuide then
    return false
  end
  if ((self.dormCtrl).roomCtrl):IsDormFntDrag() then
    return false
  end
  if ((self.dormCtrl).characterCtrl):IsDragCharacter() then
    return false
  end
  return true
end

DormCameraCtrl._OnGesture = function(self, fingerList)
  -- function num : 0_9 , upvalues : CS_LeanGesture, CS_RenderManager, CS_DormCameraController
  if not self:_OperateCommonCheck() then
    return 
  end
  for i = fingerList.Count - 1, 0, -1 do
    if (fingerList[i]).StartedOverGui then
      fingerList:RemoveAt(i)
    end
  end
  if fingerList.Count == 0 then
    return 
  end
  local delta = (CS_LeanGesture.GetScreenDelta)(fingerList) * (CS_RenderManager.Instance).ScreenScaleRatio
  if self._isThirdCamera and not self._isRoomEditCam then
    (((self.dormCtrl).bind).ca_ThridFollow):FollowCameraDrag(delta)
  else
    ;
    (CS_DormCameraController.Instance):DormRoomViewRotate(delta)
  end
end

DormCameraCtrl._OnUpdate = function(self)
  -- function num : 0_10 , upvalues : CS_LeanTouch, CS_LeanGesture, CS_DormCameraController
  if not self:_OperateCommonCheck() then
    return 
  end
  local fingers = (CS_LeanTouch.GetFingers)(true, false)
  local pinch = (CS_LeanGesture.GetPinchScale)(fingers, ((self.dormCtrl).bind).dormRoomWheel) - 1
  if self._isThirdCamera and not self._isRoomEditCam then
    (((self.dormCtrl).bind).ca_ThridFollow):FollowCameraPinch(pinch)
  else
    ;
    (CS_DormCameraController.Instance):DormRoomViewDistance(-pinch * 3)
  end
end

DormCameraCtrl.OnDelete = function(self)
  -- function num : 0_11
  if self.roomEntity ~= nil then
    self:OnExitDormRoomStart()
  end
end

return DormCameraCtrl

