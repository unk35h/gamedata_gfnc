-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityLobby.Ctrl.ActLobbyCtrlBase")
local ActLbCmderCtrl = class("ActLbCmderCtrl", base)
local ActLbCmderEntity = require("Game.ActivityLobby.Entity.ActLbCmderEntity")
local DormUtil = require("Game.Dorm.DormUtil")
ActLbCmderCtrl.ctor = function(self, actLbCtrl)
  -- function num : 0_0
end

ActLbCmderCtrl.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1 , upvalues : base, ActLbCmderEntity, _ENV
  (base.OnActLbSceneEnter)(self, bind)
  local cmderGo = (((self.actLbCtrl).lbComRes).cmderPrefab):Instantiate()
  local headFxPrefab = (((self.actLbCtrl).lbComRes).cmderHeadFxPrefab):Instantiate(cmderGo.transform)
  self.lbCmderEntity = (ActLbCmderEntity.New)()
  ;
  (self.lbCmderEntity):InitActLbCmderEntity(self, headFxPrefab, cmderGo, bind.playerRigidbodyTran)
  local actLbCfg = (self.actLbCtrl):GetActLbCfg()
  local moveSpeed = actLbCfg.move_spd
  ;
  (self.lbCmderEntity):SetActLbCmdMoveSpeed(moveSpeed)
  local bornPos = actLbCfg.born_pos
  ;
  (self.lbCmderEntity):SetActLbCmdPos((Vector3.Temp)(bornPos[1], 0, bornPos[2]))
  ;
  ((self.actLbCtrl).actLbCamCtrl):AddLbCamHideableEntt(cmderGo, self.lbCmderEntity)
  ;
  ((self.actLbCtrl).actLbCamCtrl):SetActLbCamFollowTarget(cmderGo.transform)
  UIManager:ShowWindowAsync(UIWindowTypeID.ActLobbyMain, function(win)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    win:SetActLbMainJoyStickFunc(BindCallback(self, self._OnJoystickMove), BindCallback(self, self._OnJoystickUp))
  end
)
end

ActLbCmderCtrl._OnJoystickMove = function(self, moveData)
  -- function num : 0_2
  (self.lbCmderEntity):ActLbCmderStartMove(moveData)
end

ActLbCmderCtrl._OnJoystickUp = function(self)
  -- function num : 0_3
  (self.lbCmderEntity):LbCmderEndMove()
end

ActLbCmderCtrl.HeroGreatLbCmd = function(self, heroEntity)
  -- function num : 0_4
  (self.lbCmderEntity):LbCmdStartSmoothLookAtTarget(heroEntity.transform)
  ;
  ((heroEntity.transform):DOLookAt(((self.lbCmderEntity).transform).position, 0.5)):SetLink(heroEntity.gameObject)
end

ActLbCmderCtrl.LbHeroAndCmdFace2Face = function(self, heroEntity, completeFunc)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.AddOneCover)("heroFave2Face")
  local realCompleteFunc = function()
    -- function num : 0_5_0 , upvalues : _ENV, completeFunc
    (UIUtil.CloseOneCover)("heroFave2Face")
    if completeFunc then
      completeFunc()
    end
  end

  ;
  (self.lbCmderEntity):LbCmdStartSmoothLookAtTarget(heroEntity.transform)
  ;
  (((heroEntity.transform):DOLookAt(((self.lbCmderEntity).transform).position, 0.5)):SetLink(heroEntity.gameObject)):OnComplete(realCompleteFunc)
end

ActLbCmderCtrl.LbCmdMoveDestPos = function(self, worldPos)
  -- function num : 0_6
  (self.lbCmderEntity):LbCmdEntMoveDestPos(worldPos)
  ;
  (((self._rootBind).fxSearchTarget).gameObject):SetActive(false)
  ;
  (((self._rootBind).fxSearchTarget).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self._rootBind).fxSearchTarget).position = worldPos
end

ActLbCmderCtrl.LbCmdMove2Entt = function(self, entt)
  -- function num : 0_7 , upvalues : _ENV
  local camDir = ((Quaternion.TempEuler)(0, (((UIManager:GetMainCamera()).transform).eulerAngles).y, 0)):MulVec3((Vector3.Temp)(0, 0, 0.5))
  local targetPos = (entt.transform).position - camDir
  self:LbCmdMoveDestPos(targetPos)
end

ActLbCmderCtrl.GetActLbCmderResPath = function(self)
  -- function num : 0_8 , upvalues : _ENV, DormUtil
  local lbCfg = (self.actLbCtrl):GetActLbCfg()
  if lbCfg.character ~= 0 then
    local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
    local resCfg = skinCtr:GetResModel(lbCfg.character, lbCfg.character_skin)
    if resCfg ~= nil then
      return resCfg.src_id_model
    end
  end
  do
    return (DormUtil.GetDormCmderResName)()
  end
end

ActLbCmderCtrl.Delete = function(self)
  -- function num : 0_9
  if self.lbCmderEntity then
    (self.lbCmderEntity):OnDelete()
  end
end

return ActLbCmderCtrl

