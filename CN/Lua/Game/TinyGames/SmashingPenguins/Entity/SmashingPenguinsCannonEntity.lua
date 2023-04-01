-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.SmashingPenguins.Entity.SmashingPenguinsEntityBase")
local SmashingPenguinsCannonEntity = class("SmashingPenguinsCannonEntity", base)
local SmashingPenguinsEnum = require("Game.TinyGames.SmashingPenguins.Enum.SmashingPenguinsEnum")
local SmashingPenguinsGameState = SmashingPenguinsEnum.eGameState
local SmashingPenguinsAnimState = SmashingPenguinsEnum.eCharacterAnimState
local cs_Object = (CS.UnityEngine).Object
local cs_Image = ((CS.UnityEngine).UI).Image
SmashingPenguinsCannonEntity.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, cs_Image, cs_Object
  (base.OnInit)(self)
  local listener = ((CS.ColliderEventListener).Get)(self.transform)
  listener:TriggerEnter2DEvent("+", BindCallback(self, self._OnTriggerEnter))
  local upLineImg = ((self.ui).obj_upLine):GetComponent(typeof(cs_Image))
  self.upLineMat = (cs_Object.Instantiate)(upLineImg.material)
  upLineImg.material = self.upLineMat
  local downLineImg = ((self.ui).obj_downLine):GetComponent(typeof(cs_Image))
  self.downLineMat = (cs_Object.Instantiate)(downLineImg.material)
  downLineImg.material = self.downLineMat
end

SmashingPenguinsCannonEntity.InitEntityData = function(self, characterEntity, controller)
  -- function num : 0_1 , upvalues : base
  self.isUsed = false
  self:UpdateCannonLine((self.transform).position)
  ;
  ((self.ui).obj_upLineHolder):SetActive(true)
  ;
  ((self.ui).obj_downLineHolder):SetActive(true)
  ;
  (base.InitEntityData)(self, characterEntity, controller)
end

SmashingPenguinsCannonEntity._OnTriggerEnter = function(self, collider)
  -- function num : 0_2 , upvalues : _ENV, SmashingPenguinsGameState
  if self.isUsed then
    return 
  end
  if collider.gameObject == (self.characterEntity).gameObject then
    (self.characterEntity):SetSmashingPenguinsUseGravity(false)
    ;
    (self.characterEntity):SetSmashingPenguinsColliderEnabled(false)
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.characterEntity).rigidbody).velocity = Vector3.zero
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.mainController).isMovingToCannon = true
    ;
    (self.mainController):SetSmashingPenguinsCannon(self)
    self:MoveCharacterHere(function()
    -- function num : 0_2_0 , upvalues : self, SmashingPenguinsGameState
    (self.mainController):SetSmashingPenguinsGameState(SmashingPenguinsGameState.PrepareToFly)
    -- DECOMPILER ERROR at PC5: Confused about usage of register: R0 in 'UnsetPending'

    ;
    (self.mainController).isMovingToCannon = false
  end
)
  end
end

SmashingPenguinsCannonEntity.MoveCharacterHere = function(self, callback)
  -- function num : 0_3
  ((self.characterEntity).transform):DOKill(false)
  ;
  ((((self.characterEntity).transform):DOLocalMove((self.transform).localPosition, 0.2)):SetLink(self.gameObject)):OnComplete(function()
    -- function num : 0_3_0 , upvalues : self, callback
    -- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

    ((self.characterEntity).transform).position = (self.transform).position
    callback()
  end
)
end

SmashingPenguinsCannonEntity.SetConnonIsUsed = function(self)
  -- function num : 0_4
  self.isUsed = true
  ;
  ((self.ui).obj_upLineHolder):SetActive(false)
  ;
  ((self.ui).obj_downLineHolder):SetActive(false)
end

SmashingPenguinsCannonEntity.UpdateCannonLine = function(self, worldPos)
  -- function num : 0_5 , upvalues : _ENV
  if self.isUsed then
    return 
  end
  local characterUpLocalPos = (((self.ui).obj_upLineHolder).transform):InverseTransformPoint(worldPos)
  local characterDownLocalPos = (((self.ui).obj_downLineHolder).transform):InverseTransformPoint(worldPos)
  local upDir = worldPos - (((self.ui).obj_upCannon).transform).position
  self:LineLookAtDir(upDir, (self.ui).obj_upLine)
  local downDir = worldPos - (((self.ui).obj_downCannon).transform).position
  self:LineLookAtDir(downDir, (self.ui).obj_downLine)
  local newUpWidth = (Mathf.Sqrt)((Mathf.Pow)(((self.transform).rect).height * 0.5, 2) + (Mathf.Pow)(characterUpLocalPos.x, 2))
  local newDownWidth = (Mathf.Sqrt)((Mathf.Pow)(((self.transform).rect).height * 0.5, 2) + (Mathf.Pow)(characterDownLocalPos.x, 2))
  local upLineTransform = ((self.ui).obj_upLine).transform
  local currentUpRect = upLineTransform.rect
  upLineTransform.sizeDelta = (Vector2.New)(newUpWidth, currentUpRect.height)
  ;
  (self.upLineMat):SetTextureScale("_MainTex", (Vector2.New)((Mathf.Floor)(newUpWidth / currentUpRect.height), 1))
  local downLineTransform = ((self.ui).obj_downLine).transform
  local currentDownRect = downLineTransform.rect
  downLineTransform.sizeDelta = (Vector2.New)(newDownWidth, currentDownRect.height)
  ;
  (self.downLineMat):SetTextureScale("_MainTex", (Vector2.New)((Mathf.Floor)(newDownWidth / currentDownRect.height), 1))
end

SmashingPenguinsCannonEntity.LineLookAtDir = function(self, dir, lineImgGo)
  -- function num : 0_6 , upvalues : _ENV
  local forward = (Vector3.New)(-dir.y, dir.x, 0)
  local rotation = (Quaternion.LookRotation)(Vector3.forward, forward)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (lineImgGo.transform).rotation = rotation
end

return SmashingPenguinsCannonEntity

