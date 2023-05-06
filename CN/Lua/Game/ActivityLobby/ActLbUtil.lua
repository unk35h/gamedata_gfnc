-- params : ...
-- function num : 0 , upvalues : _ENV
local ActLbUtil = {}
ActLbUtil.OnActLbInteractEnter = function(isEnter)
  -- function num : 0_0 , upvalues : _ENV
  if isEnter then
    UIManager:HideWindow(UIWindowTypeID.ActLobbyMain)
    UIManager:HideWindow(UIWindowTypeID.ActLbFollowInfo)
  else
    UIManager:ShowWindowOnly(UIWindowTypeID.ActLobbyMain)
    UIManager:ShowWindowOnly(UIWindowTypeID.ActLbFollowInfo)
  end
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl then
    (actLbCtrl.actLbIntrctCtrl):InvokeActLbInteractEnterFunc(isEnter)
  end
end

ActLbUtil.UpdLbCurInteractList = function()
  -- function num : 0_1 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl then
    (actLbCtrl.actLbIntrctCtrl):UpdLbCurInteractList()
  end
end

ActLbUtil.UpdLbEnttBluedot = function(enttId)
  -- function num : 0_2 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  local infoWin = UIManager:GetWindow(UIWindowTypeID.ActLbFollowInfo)
  if infoWin then
    infoWin:UpdActLbFollowInfoItemBludotById(enttId)
  end
  local mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  if mainWin then
    local intractData = (actLbCtrl.actLbIntrctCtrl):GetActLbIntractDataById(enttId)
    if not intractData or not intractData:GetLbIntrctObjActionIdList() then
      local actionIdList = table.emptytable
    end
    for k,actionId in pairs(actionIdList) do
      (mainWin.quickEntranceNode):UpdActLbQuickEntranceItemBludotById(actionId)
    end
  end
end

ActLbUtil.UpdLbEntranceBlueDot = function(enttidDic, FuncDic)
  -- function num : 0_3 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  local mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  if mainWin then
    local blueDotShow = false
    for k,v in pairs(enttidDic) do
      local intractData = (actLbCtrl.actLbIntrctCtrl):GetActLbIntractDataById(v)
      if not intractData or not intractData:GetLbIntrctObjActionIdList() then
        local actionIdList = table.emptytable
      end
      for k,actionId in pairs(actionIdList) do
        local actionFunc = FuncDic[actionId]
        if actionFunc then
          blueDotShow = actionFunc(intractData)
        end
      end
    end
    do
      if blueDotShow or not blueDotShow then
        mainWin:ShowQuickEntranceBlueDot(blueDotShow)
      end
    end
  end
end

ActLbUtil.GetActLbFlowUIScaleParam = function()
  -- function num : 0_4 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    error("actLbCtrl == nil")
    return 
  end
  local actLbCfg = actLbCtrl:GetActLbCfg()
  local param = actLbCfg.ui_scale
  local uiScaleMin, uiScaleMax, camDisMin, camDisMax = param[1], param[2], param[3], param[4]
  return uiScaleMin, uiScaleMax, camDisMin, camDisMax
end

ActLbUtil.UpdActLbEnttUnlockStateByObjId = function(objId)
  -- function num : 0_5 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  local mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  if mainWin then
    local intractData = (actLbCtrl.actLbIntrctCtrl):GetActLbIntractDataById(objId)
    if not intractData or not intractData:GetLbIntrctObjActionIdList() then
      local actionIdList = table.emptytable
    end
    for k,actionId in pairs(actionIdList) do
      (mainWin.quickEntranceNode):UpdActLbQuickEntranceItemUnlockById(actionId)
    end
  end
  do
    local infoWin = UIManager:GetWindow(UIWindowTypeID.ActLbFollowInfo)
    if infoWin then
      infoWin:UpdActLbFollowInfoItemUnlockById(objId)
    end
    ;
    (actLbCtrl.actLbIntrctCtrl):UpdLbIntrctEntFxUnlockById(objId)
    ;
    (actLbCtrl.actLbIntrctCtrl):UpdLbCurInteractAction()
  end
end

ActLbUtil.ActLbActivityRunningTimeout = function(actId)
  -- function num : 0_6 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil or actLbCtrl:GetActLbActId() ~= actId then
    return 
  end
  local mainWin = UIManager:GetWindow(UIWindowTypeID.ActLobbyMain)
  if mainWin then
    (mainWin.quickEntranceNode):UpdActLbQuickEntranceItemState()
  end
  local infoWin = UIManager:GetWindow(UIWindowTypeID.ActLbFollowInfo)
  if infoWin then
    infoWin:UpdActLbFollowInfoItemState()
  end
  ;
  (actLbCtrl.actLbIntrctCtrl):UpdAllLbIntrctEntFxUnlock()
  ;
  (actLbCtrl.actLbIntrctCtrl):InvokeLbActivityRunningTimeoutFunc()
  ;
  (actLbCtrl.actLbIntrctCtrl):UpdLbCurInteractAction()
end

ActLbUtil.ActLbActivityFinish = function(actId)
  -- function num : 0_7 , upvalues : _ENV, ActLbUtil
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil or actLbCtrl:GetActLbActId() ~= actId then
    return 
  end
  ;
  (actLbCtrl.actLbIntrctCtrl):InvokeLbActivityFinishedFunc()
  ;
  (ActLbUtil.ExitActivityLobby)(false)
end

ActLbUtil.ExitActivityLobby = function(toHome)
  -- function num : 0_8 , upvalues : _ENV
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  if actLbCtrl == nil then
    return 
  end
  actLbCtrl:ExitActLbCtrl(toHome)
end

return ActLbUtil

