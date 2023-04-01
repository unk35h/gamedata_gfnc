-- params : ...
-- function num : 0 , upvalues : _ENV
local LbInteractEntityBase = class("LbInteractEntityBase")
local CS_GameObject = (CS.UnityEngine).GameObject
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
LbInteractEntityBase.ctor = function(self, lbIntrctData)
  -- function num : 0_0
  self._lbIntrctData = lbIntrctData
end

LbInteractEntityBase.InitLbInteractEntityGo = function(self)
  -- function num : 0_1 , upvalues : CS_GameObject, _ENV, ActLbEnum
  local path = (self._lbIntrctData):GetLbIntrctObjPath()
  local go = (CS_GameObject.Find)(path)
  if IsNull(go) then
    error("Cant find GameObject, path:" .. tostring(path))
    return 
  end
  self.gameObject = go
  self.transform = go.transform
  local rangePath = path .. "/" .. ActLbEnum.InteractRangeName
  local interactRangeGO = (CS_GameObject.Find)(rangePath)
  if IsNull(interactRangeGO) then
    error("Cant find GameObject, path:" .. tostring(rangePath))
  end
  self._intrctRangeGo = interactRangeGO
  self._uiPoint = (self.transform):Find("UIPoint")
  local fxPath = (self._lbIntrctData):GetLbIntrctObjFxPath()
  do
    if not (string.IsNullOrEmpty)(fxPath) then
      local fxTransform = (self.transform):Find(fxPath)
      if IsNull(fxTransform) then
        error("Cant find fx, path:" .. tostring(fxPath))
      else
        self._fxGo = fxTransform.gameObject
      end
    end
    self:UpdLbIntrctEntFxUnlock()
  end
end

LbInteractEntityBase.GetLbIntrctEntRangeGo = function(self)
  -- function num : 0_2
  return self._intrctRangeGo
end

LbInteractEntityBase.GetLbIntrctEntData = function(self)
  -- function num : 0_3
  return self._lbIntrctData
end

LbInteractEntityBase.UpdLbIntrctEntFxUnlock = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if IsNull(self._fxGo) then
    return 
  end
  local unlock = (self._lbIntrctData):IsLbIntrctUnlock()
  ;
  (self._fxGo):SetActive(unlock)
end

LbInteractEntityBase.SetLbInterctEntFunc = function(self, interactFunc)
  -- function num : 0_5
  self._interactFunc = interactFunc
end

LbInteractEntityBase.ExcuteLbInterctEntFunc = function(self)
  -- function num : 0_6
  if self._interactFunc ~= nil then
    (self._interactFunc)(self)
  end
end

LbInteractEntityBase.SetLbInteractEntCfg = function(self, interactEntCfg)
  -- function num : 0_7
  self._interactEntCfg = interactEntCfg
end

LbInteractEntityBase.GetLbIntrctEntiUIPintTransform = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if IsNull(self._uiPoint) then
    error("Cant Get UIPoint, obj:" .. tostring((self.gameObject).name))
    return self.transform
  end
  return self._uiPoint
end

LbInteractEntityBase.GetLbInteractEntityId = function(self)
  -- function num : 0_9
  return (self._lbIntrctData):GetLbIntrctObjId()
end

LbInteractEntityBase.HideLbEnttRenderer = function(self, hide)
  -- function num : 0_10
end

LbInteractEntityBase.SetLbEnityGameObjectActive = function(self, bool)
  -- function num : 0_11 , upvalues : _ENV
  if IsNull(self.gameObject) then
    return 
  end
  ;
  (self.gameObject):SetActive(bool)
end

LbInteractEntityBase.OnDelete = function(self)
  -- function num : 0_12
end

return LbInteractEntityBase

