-- params : ...
-- function num : 0 , upvalues : _ENV
local SnakeBase = require("Game.TinyGames.Snake.Entity.SnakeBase")
local SnakeBody = class("SnakeBody", SnakeBase)
local cs_MaterialPropertyBlock = (CS.UnityEngine).MaterialPropertyBlock
local ScaleAndOffsetNameID = (((CS.UnityEngine).Shader).PropertyToID)("_ScaleAndOffset")
local cs_SkinnedMeshRenderer = (CS.UnityEngine).SkinnedMeshRenderer
SnakeBody.ctor = function(self, go, x, z)
  -- function num : 0_0
end

SnakeBody.ResetSnakeAnimator = function(self)
  -- function num : 0_1 , upvalues : SnakeBase
  (self.animator):ResetTrigger("Jump")
  ;
  (SnakeBase.ResetSnakeAnimator)(self)
end

SnakeBody.PlaySnakeMoveAni = function(self, tween)
  -- function num : 0_2
  (self.animator):ResetTrigger("Jump")
  ;
  (self.animator):SetTrigger("Jump")
end

SnakeBody.SetSnakeSkin = function(self, heroId)
  -- function num : 0_3
  local offsetX, offsetY = self:__GetLittleManTextureOffset(heroId)
  self:SetLittleManSkin(offsetX, offsetY)
end

SnakeBody.__GetLittleManTextureOffset = function(self, heroId)
  -- function num : 0_4 , upvalues : _ENV
  local offset = heroId - 1000 - 1
  local offsetX = (math.fmod)(offset, 16) * 0.0625
  local offsetY = (math.modf)(offset / 16) * 0.0625
  return offsetX, offsetY
end

SnakeBody.SetLittleManSkin = function(self, OffsetX, OffsetY)
  -- function num : 0_5 , upvalues : _ENV, cs_SkinnedMeshRenderer, cs_MaterialPropertyBlock, ScaleAndOffsetNameID
  if IsNull(self.meshRenderer) and not IsNull(self.gameObject) then
    self.meshRenderer = (self.gameObject):GetComponentInChildren(typeof(cs_SkinnedMeshRenderer))
  end
  if not IsNull(self.meshRenderer) then
    local propertyBlock = cs_MaterialPropertyBlock()
    propertyBlock:SetVector(ScaleAndOffsetNameID, (Vector4.New)(0.0625, 0.0625, OffsetX, OffsetY))
    ;
    (self.meshRenderer):SetPropertyBlock(propertyBlock)
  end
end

return SnakeBody

