-- params : ...
-- function num : 0 , upvalues : _ENV
local ActLbInteractCtrl = {}
local base = require("Game.ActivityLobby.Ctrl.ActLobbyCtrlBase")
local ActLbInteractCtrl = class("ActLbInteractCtrl", base)
local LbInteractData = require("Game.ActivityLobby.Data.LbInteractData")
local LbIntrctActionData = require("Game.ActivityLobby.Data.LbIntrctActionData")
local ActivityMap = require("Game.ActivityLobby.Activity.ActivityMap")
local ActLbEnum = require("Game.ActivityLobby.ActLbEnum")
local LbIntrctEntitys = {[(ActLbEnum.eActLbEntityType).Normal] = require("Game.ActivityLobby.Entity.Interact.LbIntrctNormalEntity"), [(ActLbEnum.eActLbEntityType).Hero] = require("Game.ActivityLobby.Entity.Interact.LbIntrctHeroEntity")}
ActLbInteractCtrl.ctor = function(self, actLbCtrl)
  -- function num : 0_0
end

ActLbInteractCtrl.OnActLbSceneEnter = function(self, bind)
  -- function num : 0_1 , upvalues : base, _ENV, LbInteractData
  (base.OnActLbSceneEnter)(self, bind)
  self:_LoadCfg()
  self._interactDataDic = {}
  self._interactEntityDic = {}
  self._normalEntityDic = {}
  self._heroEntityDic = {}
  self._intrctEntGoDic = {}
  self._intrctRangeGoDic = {}
  self._curIntrctEntDic = {}
  self._curActionList = {}
  self._quickEntranceActionList = {}
  local actId = (self.actLbCtrl):GetActLbActId()
  local interactObjCfgs = (ConfigData.activity_lobby_interact_obj)[actId]
  if interactObjCfgs == nil then
    error("Cant get activity_lobby_interact_obj, actId:" .. tostring(actId))
    return 
  end
  for objId,intrctObjCfg in pairs(interactObjCfgs) do
    local intrctData = (LbInteractData.New)(intrctObjCfg, self._eActIntrct)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (self._interactDataDic)[objId] = intrctData
    self:_NewIntrctEntity(intrctData)
  end
  ;
  (table.sort)(self._quickEntranceActionList, function(a, b)
    -- function num : 0_1_0
    do return a:GetLbIntrctActionId() < b:GetLbIntrctActionId() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  UIManager:ShowWindowAsync(UIWindowTypeID.ActLbFollowInfo, function(win)
    -- function num : 0_1_1 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    local actLbCfg = (self.actLbCtrl):GetActLbCfg()
    local enttDic = {}
    for interactData,entt in pairs(self._interactEntityDic) do
      if not interactData:IsLbActIntrctObjHideHeadUI() and #interactData:GetLbIntrctObjActions() > 0 then
        enttDic[interactData:GetLbIntrctObjId()] = entt
      end
    end
    win:InitActLbFollowInfo(actLbCfg.obj_ui, enttDic)
    if (self._eActIntrct).OnActLbSceneLoadedFunc ~= nil then
      ((self._eActIntrct).OnActLbSceneLoadedFunc)(self.actLbCtrl)
    end
  end
)
end

ActLbInteractCtrl._NewIntrctEntity = function(self, intrctData)
  -- function num : 0_2 , upvalues : LbIntrctEntitys, _ENV, LbIntrctActionData, ActLbEnum
  local objType = intrctData:GetLbIntrctObjType()
  local entityClass = LbIntrctEntitys[objType]
  if entityClass == nil then
    error("Cant get LbIntrctEntitys, objType:" .. tostring(objType))
    return 
  end
  local entity = (entityClass.New)(intrctData)
  local actId = (self.actLbCtrl):GetActLbActId()
  local actionIdList = intrctData:GetLbIntrctObjActionIdList()
  local actionList = {}
  local showQuickEntrance = intrctData:IsLbIntrctObjShowQuickEntrance()
  for k,actionId in ipairs(actionIdList) do
    local actionCfg = ((ConfigData.activity_lobby_interact_action)[actId])[actionId]
    local actionData = (LbIntrctActionData.New)()
    local actionFunc = self:GetActLbIntrctActionFunc(actionId)
    actionData:InitLbIntrctAction(actionCfg, entity, actionFunc, self._eActIntrct)
    ;
    (table.insert)(actionList, actionData)
    if showQuickEntrance then
      (table.insert)(self._quickEntranceActionList, actionData)
    end
  end
  intrctData:SetLbIntrctObjActions(actionList)
  entity:InitLbInteractEntityGo()
  -- DECOMPILER ERROR at PC63: Confused about usage of register: R9 in 'UnsetPending'

  ;
  (self._interactEntityDic)[intrctData] = entity
  if IsNull(entity.gameObject) then
    return 
  end
  -- DECOMPILER ERROR at PC72: Confused about usage of register: R9 in 'UnsetPending'

  ;
  (self._intrctEntGoDic)[entity.gameObject] = entity
  local intrctRangeGo = entity:GetLbIntrctEntRangeGo()
  -- DECOMPILER ERROR at PC81: Confused about usage of register: R10 in 'UnsetPending'

  if not IsNull(intrctRangeGo) then
    (self._intrctRangeGoDic)[intrctRangeGo] = entity
    ;
    ((self.actLbCtrl).actLbCamCtrl):AddLbCamHideableEntt(intrctRangeGo, entity)
  end
  -- DECOMPILER ERROR at PC95: Confused about usage of register: R10 in 'UnsetPending'

  if objType == (ActLbEnum.eActLbEntityType).Normal then
    (self._normalEntityDic)[intrctData:GetLbIntrctObjId()] = entity
  else
    -- DECOMPILER ERROR at PC104: Confused about usage of register: R10 in 'UnsetPending'

    if objType == (ActLbEnum.eActLbEntityType).Hero then
      (self._heroEntityDic)[intrctData:GetLbIntrctObjHeroId()] = entity
    end
  end
end

ActLbInteractCtrl.OnLbInteractChange = function(self, interactRangeGo, isEnter)
  -- function num : 0_3 , upvalues : _ENV
  local intrctEnt = (self._intrctRangeGoDic)[interactRangeGo]
  if IsNull(intrctEnt) then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  if isEnter then
    (self._curIntrctEntDic)[intrctEnt] = true
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._curIntrctEntDic)[intrctEnt] = nil
  end
  self:UpdLbCurInteractAction()
end

ActLbInteractCtrl.UpdLbCurInteractAction = function(self)
  -- function num : 0_4 , upvalues : _ENV
  self._curActionList = {}
  for entity,_ in pairs(self._curIntrctEntDic) do
    local intrctData = entity:GetLbIntrctEntData()
    local actionList = intrctData:GetLbIntrctObjActions()
    for k,actionData in ipairs(actionList) do
      if actionData:IsLbIntrctEntiUnlock() then
        (table.insert)(self._curActionList, actionData)
      end
    end
  end
  self:UpdLbCurInteractList()
end

ActLbInteractCtrl.UpdLbCurInteractList = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  if win then
    (win.actLbIntrctNode):UpdateLbInteractList(self._curActionList)
  end
end

ActLbInteractCtrl.GetActLbIntrctActionFunc = function(self, actionId)
  -- function num : 0_6 , upvalues : _ENV
  local func = ((self._eActIntrct).eIntrctFuncs)[actionId]
  if func == nil then
    error((string.format)("Cant get InteractAction, actId:%s, actionId:%s", (self.actLbCtrl):GetActLbActId(), actionId))
  end
  return func
end

ActLbInteractCtrl.InvokeActLbEntity = function(self, objectId)
  -- function num : 0_7
  local LbInteractData = (self._interactDataDic)[objectId]
  if LbInteractData == nil then
    return 
  end
  local entity = (self._interactEntityDic)[LbInteractData]
  if entity == nil then
    return 
  end
  local actionId = (LbInteractData:GetLbIntrctObjActionIdList())[1]
  if actionId == nil then
    return 
  end
  local func = self:GetActLbIntrctActionFunc(actionId)
  func(entity)
end

ActLbInteractCtrl.InvokeActLbInteractEnterFunc = function(self, isEnter)
  -- function num : 0_8
  if (self._eActIntrct).OnActLbInteractEnterFunc ~= nil then
    ((self._eActIntrct).OnActLbInteractEnterFunc)(isEnter)
  end
end

ActLbInteractCtrl.InvokeActLbCamChange = function(self)
  -- function num : 0_9
  if (self._eActIntrct).OnActCamChangeFunc ~= nil then
    ((self._eActIntrct).OnActCamChangeFunc)()
  end
end

ActLbInteractCtrl.InvokeLbActivityRunningTimeoutFunc = function(self)
  -- function num : 0_10
  if (self._eActIntrct).OnLbActivityRunningTimeoutFunc ~= nil then
    ((self._eActIntrct).OnLbActivityRunningTimeoutFunc)(self.actLbCtrl)
  end
end

ActLbInteractCtrl.InvokeLbActivityFinishedFunc = function(self)
  -- function num : 0_11
  if (self._eActIntrct).OnLbActivityFinishedFunc ~= nil then
    ((self._eActIntrct).OnLbActivityFinishedFunc)(self.actLbCtrl)
  end
end

ActLbInteractCtrl.InvokeActLbStartShowEndCoFunc = function(self)
  -- function num : 0_12
  if (self._eActIntrct).OnActLbStartShowEndCoFunc ~= nil then
    ((self._eActIntrct).OnActLbStartShowEndCoFunc)(self.actLbCtrl)
  end
end

ActLbInteractCtrl._LoadCfg = function(self)
  -- function num : 0_13 , upvalues : ActivityMap, _ENV
  local actId = (self.actLbCtrl):GetActLbActId()
  local actPathName = ActivityMap[actId]
  if actPathName == nil then
    error("Cant get actPathName, actId : " .. tostring(actId))
    return 
  end
  self._eActIntrctPath = "Game.ActivityLobby.Activity." .. actPathName .. ".eActInteract"
  self._eActIntrct = require(self._eActIntrctPath)
end

ActLbInteractCtrl._UnloadCfg = function(self)
  -- function num : 0_14 , upvalues : _ENV
  self._eActIntrct = nil
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self._eActIntrctPath ~= nil then
    (package.loaded)[self._eActIntrctPath] = nil
    self._eActIntrctPath = nil
  end
end

ActLbInteractCtrl.TryGetActLbIntrctEnttByGo = function(self, go)
  -- function num : 0_15
  return (self._intrctEntGoDic)[go]
end

ActLbInteractCtrl.TryGetAcgLbHeroEntity = function(self, heroId)
  -- function num : 0_16
  return (self._heroEntityDic)[heroId]
end

ActLbInteractCtrl.GetAllHeroEntity = function(self)
  -- function num : 0_17
  return self._heroEntityDic
end

ActLbInteractCtrl.GetActLbQuickEntranceActionList = function(self)
  -- function num : 0_18
  return self._quickEntranceActionList
end

ActLbInteractCtrl.GetActLbIntractDataById = function(self, enttId)
  -- function num : 0_19
  return (self._interactDataDic)[enttId]
end

ActLbInteractCtrl.GetLbIntrctEntFxUnlockById = function(self, enttId)
  -- function num : 0_20
  local intrctData = (self._interactDataDic)[enttId]
  if intrctData == nil then
    return 
  end
  local entt = (self._interactEntityDic)[intrctData]
  if entt then
    return entt
  end
end

ActLbInteractCtrl.UpdAllLbIntrctEntFxUnlock = function(self)
  -- function num : 0_21 , upvalues : _ENV
  for k,entt in pairs(self._interactEntityDic) do
    entt:UpdLbIntrctEntFxUnlock()
  end
end

ActLbInteractCtrl.UpdLbIntrctEntFxUnlockById = function(self, objId)
  -- function num : 0_22
  local intrctData = (self._interactDataDic)[objId]
  local entt = (self._interactEntityDic)[intrctData]
  if entt then
    entt:UpdLbIntrctEntFxUnlock()
  end
end

ActLbInteractCtrl.Delete = function(self)
  -- function num : 0_23 , upvalues : _ENV
  if (self._eActIntrct).OnActLbExitFunc ~= nil then
    ((self._eActIntrct).OnActLbExitFunc)(self.actLbCtrl)
  end
  self:_UnloadCfg()
  if self._interactEntityDic then
    for k,v in pairs(self._interactEntityDic) do
      v:OnDelete()
    end
  end
end

return ActLbInteractCtrl

