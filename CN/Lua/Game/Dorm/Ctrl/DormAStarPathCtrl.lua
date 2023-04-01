-- params : ...
-- function num : 0 , upvalues : _ENV
local DormCtrlBase = require("Game.Dorm.Ctrl.DormCtrlBase")
local DormAStarPathCtrl = class("DormAStarPathCtrl", DormCtrlBase)
local BoundSpaceSize = 0.4
DormAStarPathCtrl.ctor = function(self, dormCtrl)
  -- function num : 0_0
end

DormAStarPathCtrl.OnEnterDormRoomEnd = function(self, roomEntity)
  -- function num : 0_1 , upvalues : _ENV, BoundSpaceSize
  local roomData = roomEntity.roomData
  local gridLength = roomData:GetRoomGridLengthCount()
  local gridHeight = roomData:GetRoomGridHeightCount()
  local sizeLen = gridLength * (ConfigData.game_config).HouseGridWidth - BoundSpaceSize
  local sizeHeight = gridHeight * (ConfigData.game_config).HouseGridWidth - BoundSpaceSize
  local pos = (roomEntity.transform).position
  pos.y = pos.y + sizeHeight / 2
  local graph = (((CS.AstarPath).active).data).recastGraph
  graph.forcedBoundsCenter = pos
  graph.forcedBoundsSize = (Vector3.New)(sizeLen, sizeHeight, sizeLen)
  graph:Scan()
end

DormAStarPathCtrl.OnExitDormRoomStart = function(self, roomEntity)
  -- function num : 0_2
end

DormAStarPathCtrl.OnEnterDormRoomEditMode = function(self, roomEntity)
  -- function num : 0_3
end

DormAStarPathCtrl.OnExitDormRoomEditMode = function(self, roomEntity, success)
  -- function num : 0_4 , upvalues : _ENV
  if not success then
    return 
  end
  ;
  ((CS.AstarPath).active):Scan()
end

return DormAStarPathCtrl

