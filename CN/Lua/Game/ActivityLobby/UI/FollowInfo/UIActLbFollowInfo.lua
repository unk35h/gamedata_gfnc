-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIActLbFollowInfo = class("UIActLbFollowInfo", base)
local UINActLbEntiInfoItem = require("Game.ActivityLobby.UI.FollowInfo.UINActLbEntiInfoItem")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
UIActLbFollowInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self._resLoader = ((CS.ResLoader).Create)()
end

UIActLbFollowInfo.InitActLbFollowInfo = function(self, prefabName, entityDic)
  -- function num : 0_1 , upvalues : _ENV
  self._entityDic = entityDic
  self._enttInfoDic = {}
  local prefabPath = PathConsts:GetActivityLobbyUIPrefab(prefabName)
  ;
  (self._resLoader):LoadABAssetAsync(prefabPath, BindCallback(self, self._OnLoadedEntityPrefab))
end

UIActLbFollowInfo._OnLoadedEntityPrefab = function(self, prefabGo)
  -- function num : 0_2 , upvalues : _ENV, UINActLbEntiInfoItem
  if IsNull(prefabGo) then
    return 
  end
  local go = prefabGo:Instantiate((self.ui).interactEntityInfo)
  self._entityHalfSize = (go.transform).sizeDelta / 2
  self._enttInfoItemPool = (UIItemPool.New)(UINActLbEntiInfoItem, go, false)
  self:UpdActLbFollowInfo()
end

UIActLbFollowInfo.UpdActLbFollowInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActLbUtil
  if self._enttInfoItemPool == nil then
    return 
  end
  local halfScreenX = (UIManager.BackgroundStretchSize).x / 2
  local halfScreenY = (UIManager.BackgroundStretchSize).y / 2
  local camPos = ((UIManager:GetMainCamera()).transform).position
  local uiScaleMin, uiScaleMax, camDisMin, camDisMax = (ActLbUtil.GetActLbFlowUIScaleParam)()
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  for objId,entity in pairs(self._entityDic) do
    local targetTransform = entity:GetLbIntrctEntiUIPintTransform()
    local posX, posY, inCamBack = UIManager:World2UIPositionOut(targetTransform)
    local enttId = entity:GetLbInteractEntityId()
    local infoItem = (self._enttInfoDic)[enttId]
    -- DECOMPILER ERROR at PC71: Unhandled construct in 'MakeBoolean' P1

    if (inCamBack or posX + (self._entityHalfSize).x * uiScaleMax < -halfScreenX or halfScreenX < posX - (self._entityHalfSize).x * uiScaleMax or posY + (self._entityHalfSize).y * uiScaleMax < -halfScreenY or halfScreenY < posY - (self._entityHalfSize).y * uiScaleMax) and infoItem ~= nil then
      (self._enttInfoItemPool):HideOne(infoItem)
      -- DECOMPILER ERROR at PC73: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self._enttInfoDic)[enttId] = nil
    end
    if infoItem == nil then
      infoItem = (self._enttInfoItemPool):GetOne()
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (self._enttInfoDic)[enttId] = infoItem
      infoItem:InitActLbEntiInfoItem(entity)
      -- DECOMPILER ERROR at PC90: Confused about usage of register: R20 in 'UnsetPending'

      ;
      (infoItem.gameObject).name = tostring(objId)
    end
    local distance = (Vector3.Distance)(camPos, targetTransform.position)
    local size = (Mathf.Lerp)(uiScaleMax, uiScaleMin, (distance - camDisMin) / (camDisMax - camDisMin))
    posY = posY + (actLbCtrl.actLbCamCtrl):GetAcbLbFollowUIPosOffset()
    -- DECOMPILER ERROR at PC114: Confused about usage of register: R22 in 'UnsetPending'

    ;
    (infoItem.transform).anchoredPosition = (Vector2.Temp)(posX, posY)
    -- DECOMPILER ERROR at PC119: Confused about usage of register: R22 in 'UnsetPending'

    ;
    (infoItem.transform).localScale = Vector3.one * size
  end
end

UIActLbFollowInfo.UpdActLbFollowInfoItemState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  for enttId,infoItem in pairs(self._enttInfoDic) do
    infoItem:UpdActLbEntiInfoItemLock()
    infoItem:UpdActLbEntiInfoItemBlueDot()
  end
end

UIActLbFollowInfo.UpdActLbFollowInfoItemUnlockById = function(self, enttId)
  -- function num : 0_5
  local infoItem = (self._enttInfoDic)[enttId]
  if infoItem then
    infoItem:UpdActLbEntiInfoItemLock()
  end
end

UIActLbFollowInfo.UpdActLbFollowInfoItemBludotById = function(self, enttId)
  -- function num : 0_6
  local infoItem = (self._enttInfoDic)[enttId]
  if infoItem then
    infoItem:UpdActLbEntiInfoItemBlueDot()
  end
end

UIActLbFollowInfo.GetActLbFollowInfoItem = function(self, enttId)
  -- function num : 0_7
  return (self._enttInfoDic)[enttId]
end

UIActLbFollowInfo.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  (self._resLoader):Put2Pool()
  self._resLoader = nil
  ;
  (base.OnDelete)(self)
end

return UIActLbFollowInfo

