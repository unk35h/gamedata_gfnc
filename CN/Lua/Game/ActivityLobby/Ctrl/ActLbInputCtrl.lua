-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityLobby.Ctrl.ActLobbyCtrlBase")
local ActLbInputCtrl = class("ActLbInputCtrl", base)
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_Physics = CS.PhysicsUtility
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
ActLbInputCtrl.ctor = function(self, actLbCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self._OnFingerTapFunc = BindCallback(self, self._OnFingerTap)
  self._OnGestureFunc = BindCallback(self, self._OnGesture)
end

ActLbInputCtrl.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1 , upvalues : base, _ENV, CS_LeanTouch
  (base.OnActLbSceneEnter)(self, bind)
  self._camMain = UIManager:GetMainCamera()
  ;
  (CS_LeanTouch.OnFingerTap)("+", self._OnFingerTapFunc)
  ;
  (CS_LeanTouch.OnGesture)("+", self._OnGestureFunc)
end

ActLbInputCtrl._OnGesture = function(self, fingerList)
  -- function num : 0_2 , upvalues : _ENV
  if fingerList.Count == 0 or GuideManager.inGuide or (fingerList[0]).StartedOverGui then
    return 
  end
  ;
  ((self.actLbCtrl).actLbCamCtrl):ActLbCamOnGesture(fingerList)
end

ActLbInputCtrl._OnFingerTap = function(self, leanFinger)
  -- function num : 0_3 , upvalues : ActLbEnum, CS_Physics, _ENV
  if leanFinger.StartedOverGui or leanFinger.IsOverGui then
    return 
  end
  if (self.actLbCtrl):IsActLbState((ActLbEnum.eActLbState).HideUI) then
    (self.actLbCtrl):ShowActLbUI(true)
    return 
  end
  local hits = (CS_Physics.Raycast)(self._camMain, 1 << LayerMask.Raycast, true)
  for i = 0, hits.Length - 1 do
    local hitCollider = (hits[i]).collider
    if not IsNull(hitCollider) then
      local intrctEntity = ((self.actLbCtrl).actLbIntrctCtrl):TryGetActLbIntrctEnttByGo(hitCollider.gameObject)
      if intrctEntity ~= nil then
        ((self.actLbCtrl).actLbCmderCtrl):LbCmdMove2Entt(intrctEntity)
        return 
      end
      if hitCollider.tag == TagConsts.DormFloor then
        local hitPos = (hits[i]).point
        ;
        ((self.actLbCtrl).actLbCmderCtrl):LbCmdMoveDestPos(hitPos)
        return 
      end
    end
  end
end

ActLbInputCtrl.Delete = function(self)
  -- function num : 0_4 , upvalues : CS_LeanTouch
  (CS_LeanTouch.OnFingerTap)("-", self._OnFingerTapFunc)
  ;
  (CS_LeanTouch.OnGesture)("-", self._OnGestureFunc)
end

return ActLbInputCtrl

