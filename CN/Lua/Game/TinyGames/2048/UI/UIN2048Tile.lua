-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN2048Tile = class("UIN2048Tile", UIBaseNode)
local base = UIBaseNode
UIN2048Tile.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__onTileMoveEnd = BindCallback(self, self._OnTileMoveEnd)
end

UIN2048Tile.Init2048Tile = function(self, value, x, y, tilePool, sprite)
  -- function num : 0_1 , upvalues : _ENV
  self.level = value
  self.x = x
  self.y = y
  self._needDelete = false
  self:PrepareTile()
  self._tilePool = tilePool
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).text = tostring(value)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = sprite
end

UIN2048Tile.PrepareTile = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.merged = false
  self.needMove = false
  self.lastx = self.x
  self.lasty = self.y
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.transform).localScale = Vector3.one
  ;
  (self.transform):DOComplete(true)
end

UIN2048Tile.SetTileAsMerged = function(self, from1, from2)
  -- function num : 0_3
  self.fromTile1 = from1
  self.fromTile2 = from2
  self.merged = true
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.fromTile1)._needDelete = true
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.fromTile2)._needDelete = true
end

UIN2048Tile.UpdateTilePosData = function(self, x, y)
  -- function num : 0_4
  self.x = x
  self.y = y
  self.needMove = true
end

UIN2048Tile.PlayTileCreateAnimation = function(self)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (self.transform).localScale = Vector3.zero
  ;
  (self.transform):DOScale(Vector3.one, 0.15)
end

UIN2048Tile.Play2048TileAnimation = function(self, gameCtrl)
  -- function num : 0_6 , upvalues : _ENV
  if self.merged then
    (self.fromTile1):Play2048TileAnimation(gameCtrl)
    ;
    (self.fromTile2):Play2048TileAnimation(gameCtrl)
    ;
    ((self.transform):DOPunchScale((Vector3.New)(0.25, 0.25, 0.25), 0.15, 3)):SetDelay(0.1)
  else
    if self.needMove then
      local destPos = gameCtrl:GetTilePosition(self.x, self.y)
      ;
      ((self.transform):DOLocalMove(destPos, 0.1)):OnComplete(self.__onTileMoveEnd)
    else
      do
        self:_OnTileMoveEnd()
      end
    end
  end
end

UIN2048Tile._OnTileMoveEnd = function(self)
  -- function num : 0_7
  if self._needDelete then
    (self._tilePool):HideOne(self)
  end
end

UIN2048Tile.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (base.OnDelete)(self)
end

return UIN2048Tile

