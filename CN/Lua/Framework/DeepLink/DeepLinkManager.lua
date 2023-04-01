-- params : ...
-- function num : 0 , upvalues : _ENV
DeepLinkManager = {}
local JumpManager = require("Game.Jump.JumpManager")
local HomeEnum = require("Game.Home.HomeEnum")
local deepLinkFunc = {
jump = {DeepLinkAction = function(arg, continueAction)
  -- function num : 0_0 , upvalues : _ENV, JumpManager
  local argList = (CommonUtil.SplitStrToNumber)(arg, "_")
  if #argList <= 0 then
    return false
  end
  local jumpId = argList[1]
  local jumpArgs = nil
  if #argList > 1 then
    (table.remove)(argList, 1)
    jumpArgs = argList
  end
  if JumpManager:ValidateJump(jumpId, jumpArgs) then
    JumpManager:Jump(jumpId, nil, nil, jumpArgs)
    return true
  end
  return false
end
}
, 
gamenotice = {DeepLinkAction = function(arg, continueAction)
  -- function num : 0_1 , upvalues : _ENV
  local isUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Notice)
  if not isUnlock then
    return false
  end
  if UIManager:GetWindow(UIWindowTypeID.GameNotice) ~= nil or UIManager:IsWindowInLoading(UIWindowTypeID.GameNotice) then
    return false
  end
  UIManager:CreateWindowAsync(UIWindowTypeID.GameNotice, function(win)
    -- function num : 0_1_0 , upvalues : _ENV, continueAction
    if win == nil then
      return 
    end
    local homeSide = UIManager:GetWindow(UIWindowTypeID.HomeSide)
    if homeSide ~= nil then
      homeSide:CloseSide()
    end
    win:SetCloseCallback(continueAction)
    win:InitUIGameNotice(false)
  end
)
  return true
end
}
}
-- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

DeepLinkManager._Init = function(self)
  -- function num : 0_2 , upvalues : _ENV, deepLinkFunc
  if ((Consts.GameChannelType).IsInland)() and not isEditorMode then
    return 
  end
  local cs_MonoDriver_Instance = (CS.MonoDriver).Instance
  cs_MonoDriver_Instance:onDeepLinkActive("+", BindCallback(self, self._OnDeepLinkActive))
  local ok, funcName, arg = cs_MonoDriver_Instance:TryGetLastDeepLink()
  if not ok then
    return 
  end
  if deepLinkFunc[funcName] == nil then
    return 
  end
  self._linkFunc = funcName
  self._linkArg = arg
end

-- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

DeepLinkManager._OnDeepLinkActive = function(self, funcName, arg)
  -- function num : 0_3 , upvalues : deepLinkFunc, _ENV, HomeEnum
  if deepLinkFunc[funcName] == nil then
    return 
  end
  local loginWindow = UIManager:GetWindow(UIWindowTypeID.Login)
  if loginWindow ~= nil then
    self._linkFunc = funcName
    self._linkArg = arg
    return 
  end
  local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeController ~= nil and not homeController.isRunningAutoShow and homeController.homeState == (HomeEnum.eHomeState).Normal then
    self._linkFunc = funcName
    self._linkArg = arg
    self:StartDeepLink()
  end
end

-- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

DeepLinkManager.StartDeepLink = function(self, continueAction)
  -- function num : 0_4 , upvalues : _ENV, deepLinkFunc
  if (string.IsNullOrEmpty)(self._linkFunc) then
    return false
  end
  if GuideManager.inGuide then
    DeepLinkManager:ClearLink()
    return false
  end
  local dpData = deepLinkFunc[self._linkFunc]
  if dpData == nil then
    DeepLinkManager:ClearLink()
    return false
  end
  local interrupt = (dpData.DeepLinkAction)(self._linkArg, continueAction)
  DeepLinkManager:ClearLink()
  return interrupt
end

-- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

DeepLinkManager.ClearLink = function(self)
  -- function num : 0_5
  self._linkFunc = nil
  self._linkArg = nil
end

DeepLinkManager:_Init()

