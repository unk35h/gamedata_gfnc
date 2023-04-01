-- params : ...
-- function num : 0 , upvalues : _ENV
local Game2048Board = class("Game2048Board")
local Game2048Config = require("Game.TinyGames.2048.Config.Game2048Config")
Game2048Board.ctor = function(self)
  -- function num : 0_0 , upvalues : Game2048Config
  self.xCount = Game2048Config.sizeX
  self.yCount = Game2048Config.sizeY
end

Game2048Board.InitGame2048Board = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.cells = {}
  for i = 1, self.xCount do
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

    (self.cells)[i] = {}
  end
  self._random = (CS.FixRandom)((math.random)(100, CommonUtil.Int32Max))
end

Game2048Board.RandomAvailableCell = function(self)
  -- function num : 0_2
  local emptyCount = self:GetAvailableCellCount()
  if emptyCount == 0 then
    return false
  end
  local index = (self._random):RandUInt(0, emptyCount)
  emptyCount = 0
  for x = 1, self.xCount do
    for y = 1, self.yCount do
      local cell = ((self.cells)[x])[y]
      if cell == nil then
        if emptyCount == index then
          return true, x, y
        end
        emptyCount = emptyCount + 1
      end
    end
  end
  return false
end

Game2048Board.GetAvailableCellCount = function(self)
  -- function num : 0_3
  local emptyCount = 0
  for x = 1, self.xCount do
    for y = 1, self.yCount do
      local cell = ((self.cells)[x])[y]
      if cell == nil then
        emptyCount = emptyCount + 1
      end
    end
  end
  return emptyCount
end

Game2048Board.GetRandomNumLevel = function(self)
  -- function num : 0_4
  local value = (self._random):RandUInt(0, 10)
  if value < 9 then
    return 1
  else
    return 2
  end
end

Game2048Board.WithinBounds = function(self, x, y)
  -- function num : 0_5
  do return x >= 1 and x <= self.xCount and y >= 1 and y <= self.yCount end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

Game2048Board.CellContent = function(self, x, y)
  -- function num : 0_6
  if self:WithinBounds(x, y) then
    return ((self.cells)[x])[y]
  else
    return nil
  end
end

Game2048Board.CellContentDirect = function(self, x, y)
  -- function num : 0_7
  return ((self.cells)[x])[y]
end

Game2048Board.InsertTile = function(self, tile)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ((self.cells)[tile.x])[tile.y] = tile
end

Game2048Board.RemoveTile = function(self, tile)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ((self.cells)[tile.x])[tile.y] = nil
end

Game2048Board.CellAvailable = function(self, x, y)
  -- function num : 0_10
  return not self:CellOccupied(x, y)
end

Game2048Board.CellOccupied = function(self, x, y)
  -- function num : 0_11
  do return self:CellContent(x, y) ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return Game2048Board

