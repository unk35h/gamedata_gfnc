-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFurnitureData = class("DormFurnitureData")
local DormUtil = require("Game.Dorm.DormUtil")
local DormEnum = require("Game.Dorm.DormEnum")
local DormInterPointData = require("Game.Dorm.Data.DormInterPointData")
DormFurnitureData.ctor = function(self)
  -- function num : 0_0
end

DormFurnitureData.InitFntData = function(self, id, roomData, fntData, isDoor)
  -- function num : 0_1 , upvalues : _ENV
  self.id = id
  self.roomData = roomData
  local fntId = id
  if isDoor and id == 0 then
    fntId = (ConfigData.game_config).DmRoomDoorDefaultId
  end
  self:_InitFntCfg(fntId)
  self:UpdateFntData(fntData)
  self._enableInteract = true
end

DormFurnitureData._InitFntCfg = function(self, fntId)
  -- function num : 0_2 , upvalues : _ENV, DormInterPointData
  local fntCfg = (ConfigData.dorm_furniture)[fntId]
  if fntCfg == nil then
    error("Can\'t find dorm_furniture cfg, id = " .. tostring(fntId))
    return 
  end
  self.fntCfg = fntCfg
  local itemCfg = (ConfigData.item)[fntId]
  if itemCfg == nil then
    error("Can\'t find item cfg, id = " .. tostring(fntId))
    return 
  end
  self.itemCfg = itemCfg
  self.interpoint = {}
  for index,interId in ipairs(fntCfg.interact_point) do
    local interCfg = (ConfigData.dorm_interpoint)[interId]
    if interCfg == nil then
      error("dorm interpoint cfg is null,id:" .. tostring(interId))
    else
      local point = (DormInterPointData.New)()
      point:InitInterPoint(interCfg, (fntCfg.interact_point_coord)[index], (fntCfg.interact_start_coord)[index], self)
      ;
      (table.insert)(self.interpoint, point)
    end
  end
end

DormFurnitureData.UpdateFntData = function(self, fntData, isReset)
  -- function num : 0_3 , upvalues : _ENV, DormUtil
  if fntData == nil then
    self.pos = 0
    self.r = proto_object_FT_R.R_0
    self.param = 0
    self.param2 = 0
  else
    self.pos = fntData.pos
    self.r = fntData.r
    self.param = fntData.param
    self.param2 = fntData.param2
  end
  self.x = (DormUtil.FntCoord2XY)(self.pos)
  if self:IsDmFntDoor() then
    local sizeX, sizeY = self:GetFntSize()
    local newY = self:GetFntDoorY(sizeY)
    if self.y ~= newY then
      self.y = newY
      self.pos = (DormUtil.XYToRoomCoord)(self.x, self.y)
    end
  end
  do
    if not isReset then
      self:RecordOriginalFntData()
    end
  end
end

DormFurnitureData.GetFntDoorY = function(self, sizeY)
  -- function num : 0_4
  local posY = (self.roomData):GetRoomGridHeightCount() - sizeY
  return posY
end

DormFurnitureData.RecordOriginalFntData = function(self)
  -- function num : 0_5
  self.oldFntData = {id = self.id, pos = self.pos, r = self.r, param = self.param, param2 = self.param2}
end

DormFurnitureData.ResetFntData = function(self)
  -- function num : 0_6
  self:UpdateFntData(self.oldFntData, true)
end

DormFurnitureData.IsFntDataParam2Change = function(self)
  -- function num : 0_7
  do return (self.oldFntData).param2 ~= self.param2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormFurnitureData.GetFntRoom = function(self)
  -- function num : 0_8
  return self.roomData
end

DormFurnitureData.GetName = function(self)
  -- function num : 0_9 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.itemCfg).name)
end

DormFurnitureData.GetFntIntro = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self.itemCfg).describe)
end

DormFurnitureData.GetFntType = function(self)
  -- function num : 0_11
  return (self.fntCfg).type
end

DormFurnitureData.GetFntSize = function(self)
  -- function num : 0_12
  return ((self.fntCfg).size)[1], ((self.fntCfg).size)[2], ((self.fntCfg).size)[3]
end

DormFurnitureData.GetFntCenterCfg = function(self)
  -- function num : 0_13
  return (self.fntCfg).fnt_center
end

DormFurnitureData.GetFntPrefab = function(self)
  -- function num : 0_14 , upvalues : DormUtil
  local roomType = (self.roomData):GetDmRoomType()
  return (DormUtil.GetDmFntPrefabPath)(roomType, self.fntCfg)
end

DormFurnitureData.GetFntIcon = function(self)
  -- function num : 0_15
  return (self.itemCfg).icon
end

DormFurnitureData.GetFntComfort = function(self)
  -- function num : 0_16
  return (self.fntCfg).comfort
end

DormFurnitureData.SetFntPos = function(self, x, y)
  -- function num : 0_17 , upvalues : DormUtil
  self.x = x
  self.y = y
  self.pos = (DormUtil.XYCoord2Fnt)(x, y)
end

DormFurnitureData.SetFntParam = function(self, param, record)
  -- function num : 0_18
  if param == nil then
    param = 0
  end
  self.param = param
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if record then
    (self.oldFntData).param = param
  end
end

DormFurnitureData.GetFntParam = function(self)
  -- function num : 0_19
  return self.param
end

DormFurnitureData.CanBindRole = function(self)
  -- function num : 0_20
  return (self.fntCfg).can_binding
end

DormFurnitureData.RotateFnt = function(self)
  -- function num : 0_21
  self.r = (self.r + 90) % 360
  return self.r
end

DormFurnitureData.CheckOutMap = function(self)
  -- function num : 0_22 , upvalues : DormUtil
  local oldX = self.x
  local oldY = self.y
  local sizeX, sizeY = self:GetFntSize()
  local outX, outY, newX, newY = (DormUtil.FntAreaOutMap)(oldX, oldY, sizeX, sizeY, self.r, self:GetFntType(), (self.roomData).roomCfg)
  if outX or outY then
    self:SetFntPos(newX, newY)
    return true
  end
  return false
end

DormFurnitureData.GetDmFntServerData = function(self)
  -- function num : 0_23
  local id = self.id
  local data = {id = id, pos = self.pos, r = self.r, param = self.param, param2 = self.param2}
  return data
end

DormFurnitureData.IsDmFntDoor = function(self)
  -- function num : 0_24 , upvalues : DormEnum
  do return self:GetFntType() == (DormEnum.eDormFntType).Door end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormFurnitureData.TryFntDoorDataChangeDoor = function(self, fntId)
  -- function num : 0_25 , upvalues : DormUtil
  local id = (DormUtil.IsDmRoomDefaultDoorId)(fntId) and 0 or fntId
  if self.id == id then
    return false
  end
  self.id = id
  self:_InitFntCfg(fntId)
  return true
end

DormFurnitureData.GetFntOldId = function(self)
  -- function num : 0_26
  return (self.oldFntData).id
end

DormFurnitureData.GetFntCategory = function(self)
  -- function num : 0_27
  return (self.fntCfg).category
end

DormFurnitureData.SetFntDataLayer = function(self, layerIdx)
  -- function num : 0_28
  self.param2 = layerIdx
end

DormFurnitureData.GetFntDataLayer = function(self)
  -- function num : 0_29
  return self.param2
end

DormFurnitureData.IsFntWallpaperOverlap = function(self)
  -- function num : 0_30
  return (self.fntCfg).cover_wallpaper
end

DormFurnitureData.IsInFntWallpaperMap = function(self)
  -- function num : 0_31 , upvalues : DormEnum
  do return self:GetFntType() ~= (DormEnum.eDormFntType).Wallpaper and self:IsFntWallpaperOverlap() end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

DormFurnitureData.HasFntAnimator = function(self)
  -- function num : 0_32 , upvalues : _ENV
  if self:IsFntEnableTouch() then
    return true
  end
  for _,point in pairs(self.interpoint) do
    if point:GetInterAnimType() > 0 then
      return true
    end
  end
  return false
end

DormFurnitureData.IsFntEnableTouch = function(self)
  -- function num : 0_33
  do return (self.fntCfg).touch_type > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DormFurnitureData.GetFntTouchActList = function(self)
  -- function num : 0_34
  return (self.fntCfg).touch_act_list
end

DormFurnitureData.GetFntInteractState = function(self)
  -- function num : 0_35
  return self._enableInteract
end

DormFurnitureData.SetFntInteractState = function(self, active)
  -- function num : 0_36
  self._enableInteract = active
end

DormFurnitureData.GetFntTouchInteractTips = function(self)
  -- function num : 0_37 , upvalues : _ENV
  return ConfigData:GetTipContent((self.fntCfg).touch_tips)
end

return DormFurnitureData

