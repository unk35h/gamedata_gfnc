-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessAreaData = class("WarChessAreaData")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WCAreaEntity = require("Game.WarChess.Entity.WCAreaEntity")
WarChessAreaData.ctor = function(self, areaPos, areaData)
  -- function num : 0_0 , upvalues : WarChessHelper, _ENV
  local areaUID = areaData.id
  local rotation = areaData.rotation
  local x, y = (WarChessHelper.Coordination2Pos)(areaPos)
  self.areaUID = areaUID
  self.logicCoordination = areaPos
  self.sizeX = areaData.sizeX
  self.sizeY = areaData.sizeY
  self.logicPos = (Vector2.New)(x, y)
  self.towards = rotation
  self.areaEntity = nil
end

WarChessAreaData.GetWCAreaId = function(self)
  -- function num : 0_1
  return self.areaUID
end

WarChessAreaData.LoadWCArea = function(self, isReuse)
  -- function num : 0_2 , upvalues : WCAreaEntity
  self.areaEntity = (WCAreaEntity.New)(self)
  return (self.areaEntity):WCAreaEntityPreLoad(isReuse)
end

WarChessAreaData.GetWCAreaLogicToward = function(self)
  -- function num : 0_3
  return self.towards
end

WarChessAreaData.GetWCAreaLogicPosXY = function(self)
  -- function num : 0_4
  return (self.logicPos).x, (self.logicPos).y
end

WarChessAreaData.GetWCAreaSizeXY = function(self)
  -- function num : 0_5
  return self.sizeX, self.sizeY
end

WarChessAreaData.GetWCAreaId = function(self)
  -- function num : 0_6
  return self.areaUID
end

WarChessAreaData.GetWCAreaResName = function(self)
  -- function num : 0_7 , upvalues : _ENV
  return tostring(self.areaUID)
end

WarChessAreaData.GenWcAreaGridPosDic = function(self, destDic)
  -- function num : 0_8 , upvalues : WarChessHelper
  for x = (self.logicPos).x, (self.logicPos).x + self.sizeX do
    for y = (self.logicPos).y, (self.logicPos).y + self.sizeY do
      local gridPos = (WarChessHelper.PosXy2Coordination)(x, y)
      destDic[gridPos] = self.logicCoordination
    end
  end
end

WarChessAreaData.GetWCAreaGo = function(self, x, y)
  -- function num : 0_9
  return (self.areaEntity):WCAreaEnityGetGoByXY(x, y)
end

WarChessAreaData.GetWCAreaGroundGo = function(self, x, y)
  -- function num : 0_10
  return (self.areaEntity):WCAreaEnityGetGroundGoByXY(x, y)
end

return WarChessAreaData

