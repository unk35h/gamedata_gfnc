-- params : ...
-- function num : 0 , upvalues : _ENV
local TopStatusData = class("TopStatusData")
TopStatusData.InitTopStatusData = function(self, uiTab)
  -- function num : 0_0 , upvalues : _ENV
  if uiTab ~= nil and not (table.IsEmptyTable)(uiTab) then
    self.uiTab = uiTab
  else
    self.uiTab = {isHandledTopStatus = false, settedTopStatus = false}
    self.isEmptyTab = true
  end
  if (self.uiTab).GetUIWindowTypeId ~= nil then
    self.winTypeID = (self.uiTab):GetUIWindowTypeId()
  end
  self.hideTopStatus = true
end

TopStatusData.ResetTopStatusData = function(self)
  -- function num : 0_1
  self.isEmptyTab = nil
  self.uiTab = nil
  self.winTypeID = nil
  self.hideTopStatus = nil
  self.hideTopButton = nil
  self.topBtnOnlyReturn = nil
  self.backAction = nil
  self.resIds = nil
  self.resAddCallbackDic = nil
  self.infoAction = nil
  self.infoActionBuledot = nil
  self.onWinShowFunc = nil
  self.OnTopNodeChange = nil
  self.back2FrontCallback = nil
  self.preCheckFunc = nil
  self.asyncWindowId = nil
  self.settedGoHomeAndNaviBtn = nil
  self.prefShowGoHomeBtn = nil
  self.prefShowNaviBtn = nil
end

TopStatusData.SetTopStatusBackAction = function(self, backFunc)
  -- function num : 0_2 , upvalues : _ENV
  if backFunc ~= nil then
    self.backAction = (UIUtil.BindFunc)(self.uiTab, backFunc)
  end
  return self
end

TopStatusData.SetTopStatusResData = function(self, resIds, resAddCallbackDic)
  -- function num : 0_3
  self.resIds = resIds
  self.resAddCallbackDic = resAddCallbackDic
  return self
end

TopStatusData.SetTopStatusInfoFunc = function(self, infoFunc)
  -- function num : 0_4 , upvalues : _ENV
  if infoFunc ~= nil then
    self.infoAction = (UIUtil.BindFunc)(self.uiTab, infoFunc)
  end
  return self
end

TopStatusData.SetTopStatusVisible = function(self, isTopStatusVisible)
  -- function num : 0_5
  self.hideTopStatus = not isTopStatusVisible
  return self
end

TopStatusData.SetTopStatusOnWinShowFunc = function(self, onWinShowFunc)
  -- function num : 0_6
  self.onWinShowFunc = onWinShowFunc
  return self
end

TopStatusData.SetTopStatusChangeFunc = function(self, onTopStatusChangeFunc)
  -- function num : 0_7 , upvalues : _ENV
  self.OnTopNodeChange = BindCallback(self.uiTab, onTopStatusChangeFunc)
  return self
end

TopStatusData.SetTopStatusAsyncWindowId = function(self, asyncWindowId)
  -- function num : 0_8
  self.asyncWindowId = asyncWindowId
  return self
end

TopStatusData.PushTopStatusDataToBackStack = function(self, checkMultiSetTop)
  -- function num : 0_9 , upvalues : _ENV
  if UIManager:GetWindow(UIWindowTypeID.TopStatus) == nil then
    return 
  end
  if checkMultiSetTop and (self.uiTab).settedTopStatus then
    return 
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.uiTab).settedTopStatus = true
  if (UIUtil.TryReplaceDataByAsyncWindowId)(self:GetWinTypeID(), self) == nil then
    (UIUtil.backStack):Push(self)
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.TopStatus, function(win)
    -- function num : 0_9_0 , upvalues : self, _ENV
    if win ~= nil then
      win:RefreshTopStatusUI(self)
      ;
      (win.transform):SetAsFirstSibling()
      if self.hideTopStatus then
        (UIUtil.HideTopStatus)()
      end
      if self.onWinShowFunc ~= nil then
        (self.onWinShowFunc)()
      end
    end
  end
)
  return self
end

TopStatusData.GetIsEmptyTab = function(self)
  -- function num : 0_10
  return self.isEmptyTab
end

TopStatusData.GetAsyncWindowId = function(self)
  -- function num : 0_11
  return self.asyncWindowId
end

TopStatusData.GetWinTypeID = function(self)
  -- function num : 0_12
  return self.winTypeID
end

TopStatusData.GetUiTab = function(self)
  -- function num : 0_13
  return self.uiTab
end

return TopStatusData

