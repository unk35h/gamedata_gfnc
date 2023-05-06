-- params : ...
-- function num : 0 , upvalues : _ENV
UIUtil = {}
local cst_LuaBinding = typeof(((CS.XLua).Binding).LuaBinding)
;
(require("Framework.Lib.Stack"))
local Stack = nil
local _cacheResIds = nil
local _cacheIsSetNoBackData = false
local TopStatusData = require("Game.TopStatus.TopStatusData")
local TopStatusDataPool = (CommonPool.New)(function(uiTab)
  -- function num : 0_0 , upvalues : TopStatusData
  return (TopStatusData.New)(uiTab)
end
, function(p)
  -- function num : 0_1
  p:ResetTopStatusData()
  return true
end
)
local TempStackPool = (CommonPool.New)(function()
  -- function num : 0_2 , upvalues : Stack
  return (Stack.New)()
end
, function(stack)
  -- function num : 0_3
  stack:Clear()
  return true
end
)
-- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.AddButtonListener = function(btn, tbl, callback)
  -- function num : 0_4 , upvalues : _ENV
  if tbl == nil then
    (btn.onClick):AddListener(callback)
    return 
  end
  local onClick = BindCallback(tbl, callback)
  ;
  (btn.onClick):AddListener(onClick)
end

-- DECOMPILER ERROR at PC31: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.RemoveButtonListener = function(btn)
  -- function num : 0_5
  (btn.onClick):RemoveAllListeners()
end

-- DECOMPILER ERROR at PC34: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.AddButtonListenerWithArg = function(btn, tbl, callback, ...)
  -- function num : 0_6 , upvalues : _ENV
  local onClick = BindCallback(tbl, callback, ...)
  ;
  (btn.onClick):AddListener(onClick)
end

-- DECOMPILER ERROR at PC37: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.AddValueChangedListener = function(obj, tbl, callback, ...)
  -- function num : 0_7 , upvalues : _ENV
  local valueChange = BindCallback(tbl, callback, ...)
  ;
  (obj.onValueChanged):AddListener(valueChange)
end

-- DECOMPILER ERROR at PC40: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.LuaUIBindingTable = function(obj, tab)
  -- function num : 0_8 , upvalues : cst_LuaBinding, _ENV
  if tab == nil then
    return 
  end
  local uibinding = obj:GetComponent(cst_LuaBinding)
  if IsNull(uibinding) then
    return 
  end
  local vars = (uibinding.variables).Variables
  for i = 0, vars.Count - 1 do
    local value = (vars[i]):GetValue()
    if (vars[i]).VariableTypeInt == 11 then
      local valueTab = {}
      tab[(vars[i]).Name] = valueTab
      for i = 0, value.Length - 1 do
        (table.insert)(valueTab, (value[i]):GetValue())
      end
    else
      do
        do
          tab[(vars[i]).Name] = value
          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

-- DECOMPILER ERROR at PC43: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.BindFunc = function(...)
  -- function num : 0_9 , upvalues : _ENV
  return BindCallback(...)
end

-- DECOMPILER ERROR at PC47: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.backStack = (Stack.New)()
-- DECOMPILER ERROR at PC50: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.CreateNewTopStatusData = function(uiTab)
  -- function num : 0_10 , upvalues : TopStatusDataPool
  local data = TopStatusDataPool:PoolGet()
  data:InitTopStatusData(uiTab)
  return data
end

-- DECOMPILER ERROR at PC53: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetTopStatusBtnShow = function(showHome, showNav)
  -- function num : 0_11 , upvalues : _ENV
  local topStatusWindow = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  do
    if topStatusWindow ~= nil then
      local topData = (UIUtil.backStack):Peek()
      if topData ~= nil and not topData.settedGoHomeAndNaviBtn then
        topData.settedGoHomeAndNaviBtn = true
        topData.prefShowGoHomeBtn = (topStatusWindow.topGroup):GetShowTopBtnGroupGoHomeBtn() == true
        topData.prefShowNaviBtn = (topStatusWindow.topGroup):GetShowNaviBtn() == true
      end
      ;
      (topStatusWindow.topGroup):ShowTopBtnGroupGoHomeBtn(showHome)
      ;
      (topStatusWindow.topGroup):RefreshouldShowNaviBtn(showNav)
    end
    -- DECOMPILER ERROR: 4 unprocessed JMP targets
  end
end

-- DECOMPILER ERROR at PC56: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetTopStatus = function(tab, backFunc, resIds, infoFunc, resAddCallbackDic, hideTopStatus, onWinShowFunc)
  -- function num : 0_12 , upvalues : _ENV
  local data = (((((((UIUtil.CreateNewTopStatusData)(tab)):SetTopStatusBackAction(backFunc)):SetTopStatusResData(resIds, resAddCallbackDic)):SetTopStatusInfoFunc(infoFunc)):SetTopStatusVisible(not hideTopStatus)):SetTopStatusOnWinShowFunc(onWinShowFunc)):PushTopStatusDataToBackStack()
  return data
end

-- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.AddClickHomeCheckFunc = function(preCheckFunc)
  -- function num : 0_13 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data ~= nil then
    data.preCheckFunc = preCheckFunc
  end
end

-- DECOMPILER ERROR at PC62: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetTopStateInfoBuledot = function(flag)
  -- function num : 0_14 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data == nil then
    return 
  end
  data.infoActionBuledot = flag
  local topStatusWindow = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if topStatusWindow ~= nil then
    (topStatusWindow.topGroup):SetInfoBtnBluedot(flag)
  end
end

-- DECOMPILER ERROR at PC65: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetTopStateInfoFunc = function(tab, infoFunc)
  -- function num : 0_15 , upvalues : _ENV
  if infoFunc == nil then
    return 
  end
  local data = (UIUtil.backStack):Peek()
  if data == nil then
    return 
  end
  if data.winTypeID ~= tab:GetUIWindowTypeId() then
    return 
  end
  data.infoAction = (UIUtil.BindFunc)(tab, infoFunc)
  local topStatusWindow = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if topStatusWindow ~= nil then
    (topStatusWindow.topGroup):SetInfoClickAction(data.infoAction)
    ;
    (topStatusWindow.topGroup):SetInfoBtnActive(true)
  end
end

-- DECOMPILER ERROR at PC68: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.TryClickReturnHome = function(returnCallback)
  -- function num : 0_16 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data ~= nil and data.preCheckFunc ~= nil then
    return (data.preCheckFunc)(returnCallback)
  end
  returnCallback()
end

-- DECOMPILER ERROR at PC71: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.RefreshTopResId = function(resIds, resAddCallbackDic, isSetNoBackData)
  -- function num : 0_17 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if isSetNoBackData and data == nil then
    data = ((((UIUtil.CreateNewTopStatusData)()):SetTopStatusResData(resIds)):SetTopStatusVisible(true)):PushTopStatusDataToBackStack()
  end
  if data ~= nil then
    data:SetTopStatusResData(resIds, resAddCallbackDic)
    data:SetTopStatusVisible(true)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.TopStatus, function(win)
    -- function num : 0_17_0 , upvalues : data
    if data == nil or not data.resIds then
      win:SetTopStatusResIds(win == nil or nil)
      win:SetTopStatusResAddFuncs(data.resIds, data.resAddCallbackDic)
    end
  end
)
end

-- DECOMPILER ERROR at PC74: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetCurButtonGroupActive = function(active)
  -- function num : 0_18 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data == nil then
    return 
  end
  if not active then
    active = false
  end
  data.hideTopButton = not active
  local window = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if window ~= nil then
    window:SetTopButtonGroup(active)
  end
end

-- DECOMPILER ERROR at PC77: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetTopOnlyShowReturn = function(onlyShowReturn)
  -- function num : 0_19 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data == nil then
    return 
  end
  if not onlyShowReturn then
    onlyShowReturn = false
  end
  data.topBtnOnlyReturn = onlyShowReturn
  local window = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if window ~= nil then
    (window.topGroup):SetUITopStatusBtnShow(not onlyShowReturn, not onlyShowReturn)
  end
end

-- DECOMPILER ERROR at PC80: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.SetBack2FrontCallback = function(back2FrontCallback)
  -- function num : 0_20 , upvalues : _ENV
  local data = (UIUtil.backStack):Peek()
  if data == nil then
    return 
  end
  data.back2FrontCallback = back2FrontCallback
end

-- DECOMPILER ERROR at PC83: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.HideTopStatus = function()
  -- function num : 0_21 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.TopStatus)
end

-- DECOMPILER ERROR at PC86: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ReShowTopStatus = function()
  -- function num : 0_22 , upvalues : _ENV
  local window = UIManager:GetWindow(UIWindowTypeID.TopStatus)
  if window ~= nil and not window.active then
    window:Show()
  end
end

-- DECOMPILER ERROR at PC89: Confused about usage of register: R7 in 'UnsetPending'

UIUtil._HandleBackStackData = function(data, isToHome)
  -- function num : 0_23 , upvalues : _ENV
  if not isToHome then
    isToHome = false
  end
  if data == nil or data:GetIsEmptyTab() then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  if not (data.uiTab).isHandledTopStatus then
    (data.uiTab).isHandledTopStatus = true
    local cb = data.backAction
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

    if cb ~= nil and cb(isToHome) == false then
      (data.uiTab).isHandledTopStatus = false
      return 
    end
  end
  do
    ;
    (UIUtil._ForcePopBackStackData)(data, true)
  end
end

-- DECOMPILER ERROR at PC92: Confused about usage of register: R7 in 'UnsetPending'

UIUtil._RefreshTopStatus = function()
  -- function num : 0_24 , upvalues : _ENV
  local lastData = (UIUtil.backStack):Peek()
  if lastData ~= nil then
    if lastData.back2FrontCallback ~= nil then
      (lastData.back2FrontCallback)()
    end
    local topStatus = UIManager:GetWindow(UIWindowTypeID.TopStatus)
    if topStatus ~= nil then
      topStatus:RefreshTopStatusUI(lastData)
      if lastData.hideTopStatus then
        topStatus:Hide()
      else
        topStatus:Show()
      end
    end
  end
  do
    if (UIUtil.backStack):Empty() then
      UIManager:HideWindow(UIWindowTypeID.TopStatus)
    end
  end
end

-- DECOMPILER ERROR at PC95: Confused about usage of register: R7 in 'UnsetPending'

UIUtil._CheckBackStatusTopChanged = function(oldTopData)
  -- function num : 0_25 , upvalues : _ENV
  local newCurrentTopData = (UIUtil.backStack):Peek()
  if newCurrentTopData ~= nil and newCurrentTopData ~= oldTopData and newCurrentTopData.OnTopNodeChange ~= nil then
    newCurrentTopData:OnTopNodeChange(newCurrentTopData.uiTab)
  end
end

-- DECOMPILER ERROR at PC98: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.TryReplaceDataByAsyncWindowId = function(asyncWindowId, newTopData)
  -- function num : 0_26 , upvalues : _ENV, TempStackPool, TopStatusDataPool
  if (UIUtil.backStack):Empty() or asyncWindowId == nil or newTopData == nil then
    return nil
  end
  local oldTopData = (UIUtil.backStack):Peek()
  local tempTopStatusStack = (TempStackPool:PoolGet())
  -- DECOMPILER ERROR at PC19: Overwrote pending register: R4 in 'AssignReg'

  local targetData, currentData = .end, nil
  local loopCount = 0
  while 1 do
    while 1 do
      if not (UIUtil.backStack):Empty() then
        loopCount = loopCount + 1
        if loopCount > 100 then
          error("返回栈溢出")
          return 
        end
        currentData = (UIUtil.backStack):Pop()
        if currentData:GetAsyncWindowId() == asyncWindowId then
          targetData = currentData
          tempTopStatusStack:Push(newTopData)
          TopStatusDataPool:PoolPut(currentData)
          -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    tempTopStatusStack:Push(currentData)
  end
  while not tempTopStatusStack:Empty() do
    (UIUtil.backStack):Push(tempTopStatusStack:Pop())
  end
  TempStackPool:PoolPut(tempTopStatusStack)
  return targetData
end

-- DECOMPILER ERROR at PC101: Confused about usage of register: R7 in 'UnsetPending'

UIUtil._GetBackStackData = function(judgeFunc)
  -- function num : 0_27 , upvalues : _ENV, TempStackPool
  if (UIUtil.backStack):Empty() then
    return 
  end
  local oldTopData = (UIUtil.backStack):Peek()
  ;
  (TempStackPool:PoolGet())
  local tempTopStatusStack = nil
  local targetData, currentData = nil, nil
  local loopCount = 0
  while not (UIUtil.backStack):Empty() do
    loopCount = loopCount + 1
    if loopCount > 100 then
      error("返回栈溢出")
      return 
    end
    currentData = (UIUtil.backStack):Pop()
    tempTopStatusStack:Push(currentData)
    if judgeFunc(currentData) then
      targetData = currentData
      break
    end
  end
  while not tempTopStatusStack:Empty() do
    (UIUtil.backStack):Push(tempTopStatusStack:Pop())
  end
  TempStackPool:PoolPut(tempTopStatusStack)
  return targetData
end

-- DECOMPILER ERROR at PC104: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ForceOnClickBack = function()
  -- function num : 0_28 , upvalues : _ENV
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_28_0
    return true
  end
)
  if targetData ~= nil or isGameDev then
    (UIUtil._HandleBackStackData)(targetData)
  end
end

-- DECOMPILER ERROR at PC107: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.OnClickBackByWinId = function(winTypeID)
  -- function num : 0_29 , upvalues : _ENV
  if winTypeID == nil then
    return 
  end
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_29_0 , upvalues : winTypeID
    do return data.winTypeID == winTypeID end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  if targetData ~= nil or isGameDev then
    (UIUtil._HandleBackStackData)(targetData)
  end
end

-- DECOMPILER ERROR at PC110: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.OnClickBackByUiTab = function(uiTab)
  -- function num : 0_30 , upvalues : _ENV
  if uiTab == nil then
    return 
  end
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_30_0 , upvalues : uiTab
    do return data.uiTab == uiTab end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  if targetData ~= nil or isGameDev then
    (UIUtil._HandleBackStackData)(targetData)
  end
end

-- DECOMPILER ERROR at PC113: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ReturnHome = function()
  -- function num : 0_31 , upvalues : _ENV
  local loopCount = 0
  while not (UIUtil.backStack):Empty() do
    if loopCount > 100 then
      error("返回栈溢出")
      return 
    end
    loopCount = loopCount + 1
    local data = (UIUtil.backStack):Peek()
    ;
    (UIUtil._HandleBackStackData)(data, true)
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

    if UIUtil.isRunningJump then
      UIUtil.isRunningJump = nil
      break
    end
  end
  do
    if (UIUtil.backStack):Empty() then
      UIManager:HideWindow(UIWindowTypeID.TopStatus)
    end
  end
end

-- DECOMPILER ERROR at PC116: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.CheckTopNodeByTab = function(uiTab)
  -- function num : 0_32 , upvalues : _ENV
  if uiTab == nil then
    return false
  end
  local data = (UIUtil.PeekBackStack)()
  if data == nil or data.uiTab ~= uiTab then
    return false
  end
  return true
end

-- DECOMPILER ERROR at PC119: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.CheckTopIsWindow = function(winTypeID)
  -- function num : 0_33 , upvalues : _ENV
  if winTypeID == nil then
    return false
  end
  local data = (UIUtil.PeekBackStack)()
  if data == nil then
    return false
  end
  do return data.winTypeID == winTypeID end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

-- DECOMPILER ERROR at PC122: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.CheckTopWindowAndClear = function(winTypeID)
  -- function num : 0_34 , upvalues : _ENV
  if winTypeID == nil then
    return false
  end
  local data = (UIUtil.PeekBackStack)()
  if data == nil then
    return false
  end
  if data.winTypeID == winTypeID then
    (UIUtil._ForcePopBackStackData)(data, true)
    return true
  end
  return false
end

-- DECOMPILER ERROR at PC125: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.CheckIsHaveSpecialMarker = function(winTypeID)
  -- function num : 0_35 , upvalues : _ENV
  if winTypeID == nil then
    return false
  end
  for deepIndex = (UIUtil.backStack):Count(), (UIUtil.backStack).bottom, -1 do
    if (((UIUtil.backStack).data)[deepIndex]).winTypeID == winTypeID then
      return true, deepIndex
    end
  end
  return false
end

-- DECOMPILER ERROR at PC128: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ReturnUntil2Marker = function(winTypeID, isInclude)
  -- function num : 0_36 , upvalues : _ENV
  local haveMarker = (UIUtil.CheckIsHaveSpecialMarker)(winTypeID)
  if not haveMarker then
    return 
  end
  local loopCount = 0
  local pickNext = false
  while not (UIUtil.backStack):Empty() do
    if loopCount > 100 then
      error("返回栈溢出")
      return 
    end
    loopCount = loopCount + 1
    local data = (UIUtil.backStack):Peek()
    if data.winTypeID == winTypeID then
      if isInclude then
        pickNext = true
      else
        return 
      end
    else
      if pickNext then
        return 
      end
    end
    ;
    (UIUtil._HandleBackStackData)(data)
  end
end

-- DECOMPILER ERROR at PC131: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.Push2BackStack = function(...)
  -- function num : 0_37 , upvalues : _ENV
  local tab = select(1, ...)
  local data = (((UIUtil.CreateNewTopStatusData)(tab)):SetTopStatusBackAction(select(2, ...))):SetTopStatusVisible(true)
  local frontData = (UIUtil.backStack):Peek()
  if frontData ~= nil then
    data:SetTopStatusResData(frontData.resIds, frontData.resAddCallbackDic)
  end
  data:PushTopStatusDataToBackStack()
  return data
end

-- DECOMPILER ERROR at PC134: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ForcePopFromBackStack = function()
  -- function num : 0_38 , upvalues : _ENV
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_38_0
    return true
  end
)
  ;
  (UIUtil._ForcePopBackStackData)(targetData, true)
end

-- DECOMPILER ERROR at PC137: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.PopFromBackStackByWinId = function(winTypeID)
  -- function num : 0_39 , upvalues : _ENV
  if winTypeID == nil then
    return 
  end
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_39_0 , upvalues : winTypeID
    do return data:GetWinTypeID() == winTypeID end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (UIUtil._ForcePopBackStackData)(targetData, true)
end

-- DECOMPILER ERROR at PC140: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.PopFromBackStackByUiTab = function(uiTab)
  -- function num : 0_40 , upvalues : _ENV
  if uiTab == nil then
    return 
  end
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_40_0 , upvalues : uiTab
    do return data:GetUiTab() == uiTab end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (UIUtil._ForcePopBackStackData)(targetData, true)
end

-- DECOMPILER ERROR at PC143: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.PopFromBackStackByAsyncWindowId = function(asyncWindowId)
  -- function num : 0_41 , upvalues : _ENV
  if asyncWindowId == nil then
    return 
  end
  local targetData = (UIUtil._GetBackStackData)(function(data)
    -- function num : 0_41_0 , upvalues : asyncWindowId
    do return data:GetAsyncWindowId() == asyncWindowId end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  ;
  (UIUtil._ForcePopBackStackData)(targetData, false)
end

-- DECOMPILER ERROR at PC146: Confused about usage of register: R7 in 'UnsetPending'

UIUtil._ForcePopBackStackData = function(topStatusData, isClearEmptyTab)
  -- function num : 0_42 , upvalues : _ENV, TempStackPool, TopStatusDataPool
  if topStatusData == nil then
    return 
  end
  if (UIUtil.backStack):Empty() then
    return 
  end
  local oldTopData = (UIUtil.backStack):Peek()
  local tempTopStatusStack = (TempStackPool:PoolGet())
  local currentData = nil
  local loopCount = 0
  while 1 do
    while 1 do
      while 1 do
        if not (UIUtil.backStack):Empty() then
          loopCount = loopCount + 1
          if loopCount > 100 then
            error("返回栈溢出")
            return 
          end
          currentData = (UIUtil.backStack):Pop()
          if not isClearEmptyTab or not currentData:GetIsEmptyTab() or currentData:GetAsyncWindowId() ~= nil then
            if currentData ~= topStatusData then
              tempTopStatusStack:Push(currentData)
              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC52: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
      -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (currentData.uiTab).isHandledTopStatus = nil
      -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (currentData.uiTab).settedTopStatus = nil
      do
        if currentData.settedGoHomeAndNaviBtn then
          local topStatusWindow = UIManager:GetWindow(UIWindowTypeID.TopStatus)
          if topStatusWindow ~= nil then
            (topStatusWindow.topGroup):ShowTopBtnGroupGoHomeBtn(currentData.prefShowGoHomeBtn)
            ;
            (topStatusWindow.topGroup):RefreshouldShowNaviBtn(currentData.prefShowNaviBtn)
          end
        end
        TopStatusDataPool:PoolPut(currentData)
        -- DECOMPILER ERROR at PC80: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
    -- DECOMPILER ERROR at PC82: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (currentData.uiTab).isHandledTopStatus = nil
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (currentData.uiTab).settedTopStatus = nil
    TopStatusDataPool:PoolPut(currentData)
  end
  while not tempTopStatusStack:Empty() do
    (UIUtil.backStack):Push(tempTopStatusStack:Pop())
  end
  ;
  (UIUtil._CheckBackStatusTopChanged)(oldTopData)
  TempStackPool:PoolPut(tempTopStatusStack)
  ;
  (UIUtil._RefreshTopStatus)()
end

-- DECOMPILER ERROR at PC149: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.PeekBackStack = function()
  -- function num : 0_43 , upvalues : _ENV
  return (UIUtil.backStack):Peek()
end

-- DECOMPILER ERROR at PC152: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.ClearTopHome = function()
  -- function num : 0_44 , upvalues : _ENV
  (UIUtil.backStack):Clear()
end

-- DECOMPILER ERROR at PC155: Confused about usage of register: R7 in 'UnsetPending'

UIUtil.__coverDic = {}
local _ShowCover = function(coverData)
  -- function num : 0_45 , upvalues : _ENV
  (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(SafeUnpack(coverData.argTable))
end

-- DECOMPILER ERROR at PC159: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.AddOneCover = function(fromWhere, argTable)
  -- function num : 0_46 , upvalues : _ENV, _ShowCover
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if UIUtil.__coverDic == nil then
    UIUtil.__coverDic = {}
  end
  if argTable == nil then
    argTable = SafePack(nil, nil, nil, Color.clear, false)
  end
  local coverData = {fromWhere = fromWhere, argTable = argTable}
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (UIUtil.__coverDic)[fromWhere] = coverData
  _ShowCover(coverData)
end

-- DECOMPILER ERROR at PC162: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.CloseOneCover = function(fromWhere)
  -- function num : 0_47 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if UIUtil.__coverDic ~= nil and (UIUtil.__coverDic)[fromWhere] ~= nil then
    (UIUtil.__coverDic)[fromWhere] = nil
  end
  if UIUtil.__coverDic == nil or (table.count)(UIUtil.__coverDic) <= 0 then
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  end
end

-- DECOMPILER ERROR at PC165: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.CloseAllCover = function()
  -- function num : 0_48 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

  UIUtil.__coverDic = {}
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
end

-- DECOMPILER ERROR at PC168: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.LoadABAssetAsyncAndSetTexture = function(resLoader, path, rawImageGo)
  -- function num : 0_49 , upvalues : _ENV
  rawImageGo.enabled = false
  resLoader:LoadABAssetAsync(path, function(texture)
    -- function num : 0_49_0 , upvalues : _ENV, rawImageGo
    if IsNull(rawImageGo.transform) then
      return 
    end
    rawImageGo.texture = texture
    rawImageGo.enabled = true
  end
)
end

-- DECOMPILER ERROR at PC171: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.ScrollRectLocation = function(scroll, item, isForceUpdateCanvases, donotRollWhenCouldSee)
  -- function num : 0_50 , upvalues : _ENV
  if IsNull(scroll) == nil or IsNull(item) == nil then
    error("scroll is NULL or item is NULL")
    return 
  end
  if not (item.transform):IsChildOf(scroll.transform) then
    error("Item not Child Of scroll")
    return 
  end
  if isForceUpdateCanvases then
    (((CS.UnityEngine).Canvas).ForceUpdateCanvases)()
  end
  if scroll.horizontal then
    local targetWidth = ((item.transform).localPosition).x + ((item.transform).rect).width * (1 - ((item.transform).pivot).x)
    local scrollWidth = ((scroll.transform).rect).width
    local rectWidth = (((scroll.content).transform).rect).width
    if targetWidth <= scrollWidth or rectWidth <= scrollWidth then
      scroll.horizontalNormalizedPosition = 0
    else
      local diffX = targetWidth - scrollWidth
      local ratio = diffX / (rectWidth - scrollWidth)
      scroll.horizontalNormalizedPosition = ratio
    end
  end
  do
    if scroll.vertical then
      local targetHeight = ((item.transform).localPosition).y - ((item.transform).rect).height * ((item.transform).pivot).y
      if (item.transform).parent ~= scroll.content then
        local tepVec = (Vector3.Temp)(0, targetHeight, 0)
        tepVec = ((item.transform).parent):TransformPoint(tepVec)
        tepVec = (scroll.content):InverseTransformPoint(tepVec)
        targetHeight = -tepVec.y
      else
        do
          targetHeight = -targetHeight
          local scrollHeight = ((scroll.transform).rect).height
          local rectHeight = (((scroll.content).transform).rect).height
          if targetHeight <= scrollHeight or rectHeight <= scrollHeight then
            scroll.verticalNormalizedPosition = 1
          else
            do
              if donotRollWhenCouldSee then
                local curCoulShowRange = (1 - scroll.verticalNormalizedPosition) * (rectHeight - scrollHeight)
                if curCoulShowRange < targetHeight and targetHeight < curCoulShowRange + scrollHeight then
                  return 
                end
              end
              local diffY = targetHeight - scrollHeight
              local ratio = 1 - diffY / (rectHeight - scrollHeight)
              scroll.verticalNormalizedPosition = ratio
            end
          end
        end
      end
    end
  end
end

-- DECOMPILER ERROR at PC174: Confused about usage of register: R8 in 'UnsetPending'

UIUtil.ShowCommonReward = function(rewards, crItemTransDic)
  -- function num : 0_51 , upvalues : _ENV
  if rewards == nil then
    return 
  end
  local rewardIds = {}
  local rewardNums = {}
  do
    for itemId,itemCount in pairs(rewards) do
      (table.insert)(rewardIds, itemId)
      ;
      (table.insert)(rewardNums, itemCount)
    end
  end
  if #rewardIds > 0 then
    local heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_51_0 , upvalues : _ENV, rewardIds, rewardNums, heroIdSnapShoot, crItemTransDic
    if window == nil then
      return 
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = (((((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(heroIdSnapShoot, false)):SetCRNotHandledGreat(true)):SetCRItemTransDic(crItemTransDic)):SetCRShowOverFunc(function()
      -- function num : 0_51_0_0 , upvalues : _ENV
      local achievementSystemWin = UIManager:GetWindow(UIWindowTypeID.AchievementSystem)
      if achievementSystemWin ~= nil then
        ((achievementSystemWin.achievementLevelNode).__NeedRefreshPlayerLevel)()
      end
    end
)
    window:AddAndTryShowReward(CRData)
  end
)
  end
end


