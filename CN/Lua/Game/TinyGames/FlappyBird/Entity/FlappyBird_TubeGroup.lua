-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_EntityBase")
local FlappyBird_TubeGroup = class("FlappyBird_TubeGroup", base)
local FlappyBird_Tube = require("Game.TinyGames.FlappyBird.Entity.FlappyBird_Tube")
FlappyBird_TubeGroup.OnInit = function(self)
  -- function num : 0_0
  self:SetMoveFollowBackGroud()
  self:SetGravityInfluenceEnable(false)
  self.__isPickedScore = false
  self.tubeEntityList = {}
end

FlappyBird_TubeGroup.SetGroupType = function(self, groupType)
  -- function num : 0_1
  self.__tubeGroupType = groupType
end

FlappyBird_TubeGroup.InitWithGroupData = function(self, groupData)
  -- function num : 0_2 , upvalues : _ENV, FlappyBird_Tube
  local childrenTubes = groupData.tubeChildren
  for _,v in ipairs(childrenTubes) do
    local tube = (FlappyBird_Tube.New)(v.tubeType)
    tube:SetOffset2Center((v.tubeOffset).x, (v.tubeOffset).y)
    tube:SetColliderSize((v.scale).halfWidth, (v.scale).halfHeight)
    ;
    (table.insert)(self.tubeEntityList, tube)
  end
  self.bonusScore = groupData.score
end

FlappyBird_TubeGroup.SetPos = function(self, x, y)
  -- function num : 0_3 , upvalues : base
  (base.SetPos)(self, x, y)
  self:__UpdateChildTubePos()
end

FlappyBird_TubeGroup.UpdatePos = function(self)
  -- function num : 0_4 , upvalues : base
  (base.UpdatePos)(self)
  self:__UpdateChildTubePos()
end

FlappyBird_TubeGroup.__UpdateChildTubePos = function(self)
  -- function num : 0_5 , upvalues : _ENV
  for _,tubeEntity in ipairs(self.tubeEntityList) do
    tubeEntity:SetTubePos((self.pos).x, (self.pos).y)
  end
end

FlappyBird_TubeGroup.IsOnCollission = function(self, otherEntity)
  -- function num : 0_6 , upvalues : _ENV
  for _,tubeEntity in ipairs(self.tubeEntityList) do
    if self:IsOnCollisionInSky(tubeEntity, otherEntity) then
      return true
    end
    if tubeEntity:IsOnTubeCollission(otherEntity) then
      return true
    end
  end
end

FlappyBird_TubeGroup.IsOnCollisionInSky = function(self, tubeEntity, otherEntity)
  -- function num : 0_7
  if (otherEntity.pos).y < (self.evnData).playGroundHeight then
    return false
  end
  local tubeHalfHeight = (tubeEntity.colliderBox).top
  local tubeHalfWidth = (tubeEntity.colliderBox).right
  local left = (tubeEntity.pos).x - tubeHalfWidth
  local right = (tubeEntity.pos).x + tubeHalfWidth
  if (tubeEntity.pos).y + tubeHalfHeight < (self.evnData).playGroundHeight then
    return false
  end
  do return left <= (otherEntity.pos).x and (otherEntity.pos).x <= right end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

FlappyBird_TubeGroup.GetTubeEntityList = function(self)
  -- function num : 0_8
  return self.tubeEntityList
end

FlappyBird_TubeGroup.GetTubeGroupType = function(self)
  -- function num : 0_9
  return self.__tubeGroupType
end

FlappyBird_TubeGroup.GetIsPickScore = function(self)
  -- function num : 0_10
  return self.__isPickedScore
end

FlappyBird_TubeGroup.SetIsPickScore = function(self, bool)
  -- function num : 0_11
  self.__isPickedScore = bool
end

return FlappyBird_TubeGroup

