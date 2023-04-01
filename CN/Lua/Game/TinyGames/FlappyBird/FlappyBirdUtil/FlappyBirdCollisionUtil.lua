-- params : ...
-- function num : 0 , upvalues : _ENV
local FlappyBirdCollisionUtil = {}
FlappyBirdCollisionUtil.IsRectRectOnCollission = function(entityAPos, entityAColliBox, entityBPos, entityBColliBox)
  -- function num : 0_0
  local r1Left = entityAPos.x + entityAColliBox.left
  local r1Bottom = entityAPos.y + entityAColliBox.bottom
  local r1Right = entityAPos.x + entityAColliBox.right
  local r1Top = entityAPos.y + entityAColliBox.top
  local r2Left = entityBPos.x + entityBColliBox.left
  local r2Bottom = entityBPos.y + entityBColliBox.bottom
  local r2Right = entityBPos.x + entityBColliBox.right
  local r2Top = entityBPos.y + entityBColliBox.top
  do return r1Right >= r2Left and r2Right >= r1Left and r1Top >= r2Bottom and r2Top >= r1Bottom end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return FlappyBirdCollisionUtil

