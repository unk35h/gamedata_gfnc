-- params : ...
-- function num : 0 , upvalues : _ENV
local UIManager = class("UIManager")
local cs_UIManager = (CS.UIManager).Instance
local cs_ResLoader = CS.ResLoader
local cs_InputUtility = CS.InputUtility
local cs_MicaSDKManager = (CS.MicaSDKManager).Instance
local cs_BattleManager = CS.BattleManager
local CS_ClientConsts = CS.ClientConsts
local OnUpdate = function(self)
  -- function num : 0_0
end

UIManager.PlayFov = function(self, fov, endValue, duration, delay)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R5 in 'UnsetPending'

  (self.UICamera).fieldOfView = fov
  ;
  (((self.UICamera):DOFieldOfView(endValue, duration)):SetDelay(delay)):SetEase((((CS.DG).Tweening).Ease).OutCubic)
end

UIManager.PlayDoFade = function(self, canvasGroup, alpha, endValue, duraction, func)
  -- function num : 0_2
  canvasGroup.alpha = alpha
  local tween = (canvasGroup:DOFade(endValue, duraction)):SetLink(canvasGroup.gameObject)
  if func ~= nil then
    tween.onComplete = func
  end
  return tween
end

UIManager.ctor = function(self)
  -- function num : 0_3 , upvalues : cs_UIManager, _ENV, OnUpdate
  local UICanvas = cs_UIManager.UICanvas
  local UICamera = cs_UIManager.UICamera
  local UICanvasRoot = UICanvas.transform
  self.UICanvas = UICanvas
  self.UICamera = UICamera
  self.csUIManager = cs_UIManager
  self:OnScreenSizeChanged()
  self.windows = {}
  self.resloaders = {}
  self.async_loaders = {}
  self.layers = {}
  for i = 0, UICanvasRoot.childCount - 1 do
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R8 in 'UnsetPending'

    (self.layers)[i] = UICanvasRoot:GetChild(i)
  end
  local referenceResolution = (cs_UIManager.UICanvasScaler).referenceResolution
  self.Resolution = (Vector2.New)(referenceResolution.x, referenceResolution.y)
  self.__update_handle = BindCallback(self, OnUpdate)
  UpdateManager:AddUpdate(self.__update_handle)
  self.sortingLayerList = {"UIBottom", "UINormal", "UIMiddle", "UIHigh", "UIOverHigh", "UILowTop", "UITop", "UIMsg", "UIMax"}
  self.__OnScreenSizeChanged = BindCallback(self, self.OnScreenSizeChanged)
  MsgCenter:AddListener(eMsgEventId.OnScreenSizeChanged, self.__OnScreenSizeChanged)
end

UIManager.OnScreenSizeChanged = function(self)
  -- function num : 0_4 , upvalues : cs_UIManager
  self.BackgroundCullSize = cs_UIManager.BackgroundCullSize
  self.BackgroundStretchSize = cs_UIManager.BackgroundStretchSize
  self.MatchWidthOrHeight = cs_UIManager.MatchWidthOrHeight
end

UIManager.GetMainCamera = function(self)
  -- function num : 0_5 , upvalues : cs_UIManager
  return cs_UIManager.MainCam
end

UIManager.IsMainCameraEnable = function(self)
  -- function num : 0_6 , upvalues : cs_UIManager
  return cs_UIManager.IsMainCamEnable
end

UIManager.GetUICamera = function(self)
  -- function num : 0_7 , upvalues : cs_UIManager
  return cs_UIManager.UICamera
end

UIManager.GetUIRootCanvasGroup = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if IsNull(self._uiRootCanvasGroup) then
    self._uiRootCanvasGroup = ((self.UICanvas).gameObject):AddComponent(typeof((CS.UnityEngine).CanvasGroup))
  end
  return self._uiRootCanvasGroup
end

UIManager.World2UIPosition = function(self, position, rectTransform, uiCam, mainCam)
  -- function num : 0_9 , upvalues : cs_UIManager
  return cs_UIManager:World2UIPosition(position, rectTransform, uiCam, mainCam)
end

UIManager.World2UIPositionOut = function(self, transform, rectTransform, uiCam, mainCam)
  -- function num : 0_10 , upvalues : cs_UIManager
  return cs_UIManager:World2UIPositionOut(transform, rectTransform, uiCam, mainCam)
end

UIManager.Screen2UIPosition = function(self, screenPoint, rectTransform, camera)
  -- function num : 0_11 , upvalues : cs_UIManager
  return cs_UIManager:Screen2UIPosition(screenPoint, rectTransform, camera)
end

UIManager.Screen2WorldPosition = function(self, screenPoint, rectTransform, camera)
  -- function num : 0_12 , upvalues : cs_UIManager
  return cs_UIManager:Screen2WorldPosition(screenPoint, rectTransform, camera)
end

UIManager.HideClickEffect = function(self, hide)
  -- function num : 0_13 , upvalues : cs_UIManager
  cs_UIManager:HideClickEffect(hide)
end

local InitWindowInternal = function(self, typeID, uiconfig, prefab, fromWhichUI)
  -- function num : 0_14 , upvalues : _ENV
  if IsNull(prefab) then
    ((self.resloaders)[typeID]):Put2Pool()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.resloaders)[typeID] = nil
    error("Can\'t find window\'s prefab, window type is " .. uiconfig.PrefabName)
    return nil
  end
  local obj = prefab:Instantiate((self.layers)[uiconfig.LayoutLevel])
  obj.name = uiconfig.PrefabName
  local rectTransform = obj.transform
  rectTransform.localScale = (Vector3.New)(1, 1, 1)
  rectTransform:SetAsLastSibling()
  rectTransform.localPosition = (Vector3.New)(0, 0, 0)
  rectTransform.offsetMax = (Vector2.New)(0, 0)
  rectTransform.offsetMin = (Vector2.New)(0, 0)
  LocalizeManager:SetUILocalizeConfig(rectTransform)
  local window = ((uiconfig.WindowClass).New)()
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R8 in 'UnsetPending'

  ;
  (self.windows)[typeID] = window
  ;
  (UIUtil.LuaUIBindingTable)(obj, window.ui)
  window.__typeID = typeID
  window.__layerID = uiconfig.LayoutLevel
  window.__winAnima = uiconfig.AnimaType
  window.fromType = fromWhichUI
  window:Init(rectTransform)
  return window
end

local __CheckCreateWindow = function(self, typeID)
  -- function num : 0_15 , upvalues : _ENV
  if self._inDeleteAllWindow then
    error("Cant create window while in deleting all window， typeID = " .. tostring(typeID))
    return false
  end
  return true
end

local CreateWindowInternal = function(self, typeID, isAsync, replaceTypeId, fromWhichUI)
  -- function num : 0_16 , upvalues : __CheckCreateWindow, cs_ResLoader, _ENV, InitWindowInternal, cs_UIManager
  if __CheckCreateWindow(self, typeID) == false then
    return 
  end
  local resloader = (self.resloaders)[typeID]
  if not resloader then
    resloader = (cs_ResLoader.Create)()
  end
  local uiconfig = UIWindowGlobalConfig[typeID]
  if replaceTypeId ~= nil then
    uiconfig = UIWindowGlobalConfig[replaceTypeId]
  end
  assert(uiconfig)
  assert(not (string.IsNullOrEmpty)(uiconfig.PrefabName))
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (self.resloaders)[typeID] = resloader
  if isAsync then
    local tmpId = typeID
    do
      resloader:LoadABAssetAsync(PathConsts:GetUIPrefabPath(uiconfig.PrefabName), function(prefab)
    -- function num : 0_16_0 , upvalues : InitWindowInternal, self, typeID, uiconfig, fromWhichUI, _ENV, tmpId, cs_UIManager
    local window = InitWindowInternal(self, typeID, uiconfig, prefab, fromWhichUI)
    for k,cb in ipairs((self.async_loaders)[tmpId]) do
      cb(window)
    end
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.async_loaders)[tmpId] = nil
    if (table.count)(self.async_loaders) == 0 then
      cs_UIManager.MaxMaskActive = false
    end
  end
)
    end
  else
    do
      local prefab = resloader:LoadABAsset(PathConsts:GetUIPrefabPath(uiconfig.PrefabName))
      do return InitWindowInternal(self, typeID, uiconfig, prefab) end
    end
  end
end

UIManager.GetWindow = function(self, typeID)
  -- function num : 0_17
  local target = (self.windows)[typeID]
  return target
end

UIManager.CreateWindow = function(self, typeID, replaceType)
  -- function num : 0_18 , upvalues : CreateWindowInternal
  local target = self:GetWindow(typeID)
  if target then
    return target
  end
  if (self.resloaders)[typeID] ~= nil then
    return nil
  end
  return CreateWindowInternal(self, typeID, false, replaceType)
end

UIManager.ShowWindow = function(self, typeID, replaceType, fromWhichUI)
  -- function num : 0_19 , upvalues : CreateWindowInternal
  local target = self:GetWindow(typeID)
  if target then
    target:Show()
    return target
  end
  if (self.resloaders)[typeID] ~= nil then
    return nil
  end
  local window = CreateWindowInternal(self, typeID, false, replaceType, fromWhichUI)
  window:Show()
  return window
end

UIManager.ShowWindowOnly = function(self, typeID, withoutSound)
  -- function num : 0_20
  local target = self:GetWindow(typeID)
  if target then
    if withoutSound then
      target:WinNextWithoutSound()
    end
    target:Show()
    return target
  end
  return nil
end

UIManager.CreateWindowAsync = function(self, typeID, openCallback, replaceType, fromWhichUI)
  -- function num : 0_21 , upvalues : __CheckCreateWindow, _ENV, cs_UIManager, CreateWindowInternal
  local target = self:GetWindow(typeID)
  if target ~= nil then
    openCallback(target)
    return 
  end
  if __CheckCreateWindow(self, typeID) == false then
    return 
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R6 in 'UnsetPending'

  if (self.async_loaders)[typeID] == nil then
    (self.async_loaders)[typeID] = {}
  end
  ;
  (table.insert)((self.async_loaders)[typeID], openCallback)
  cs_UIManager.MaxMaskActive = true
  CreateWindowInternal(self, typeID, true, replaceType, fromWhichUI)
end

UIManager.ShowWindowAsync = function(self, typeID, openCallback, replaceType, fromWhichUI)
  -- function num : 0_22 , upvalues : _ENV
  local target = self:GetWindow(typeID)
  if target then
    target:Show()
    if openCallback ~= nil then
      openCallback(target)
    end
    return target
  end
  if (self.resloaders)[typeID] ~= nil then
    (table.insert)((self.async_loaders)[typeID], function(win)
    -- function num : 0_22_0 , upvalues : openCallback
    if win ~= nil then
      win:Show()
    end
    if openCallback ~= nil then
      openCallback(win)
    end
  end
)
    return nil
  end
  self:CreateWindowAsync(typeID, function(window)
    -- function num : 0_22_1 , upvalues : openCallback
    if window ~= nil then
      window:Show()
    end
    if openCallback ~= nil then
      openCallback(window)
    end
  end
, replaceType, fromWhichUI)
end

UIManager.HideWindow = function(self, typeID)
  -- function num : 0_23
  local target = self:GetWindow(typeID)
  if target then
    target:Hide()
  end
end

UIManager.DeleteWindow = function(self, typeID, isImmeDelete)
  -- function num : 0_24
  local resloader, target = self:DeleteWindowData(typeID)
  if target == nil then
    return 
  end
  if target.active then
    target:OnHide()
  end
  target:OnDelete()
  if target.winTween == nil or isImmeDelete then
    if target.winTween ~= nil then
      (target.winTween):Kill()
      target.winTween = nil
    end
    target:OnCloseTween()
    self:RecycleWindowEntity(resloader, target)
  else
    target.isColsingWin = true
    target:CloseTween(resloader)
  end
end

UIManager.DeleteWindowData = function(self, typeID)
  -- function num : 0_25
  local target = self:GetWindow(typeID)
  if target == nil then
    return 
  end
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.windows)[typeID] = nil
  local resloader = (self.resloaders)[typeID]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  if resloader ~= nil then
    (self.resloaders)[typeID] = nil
  end
  return resloader, target
end

UIManager.RecycleWindowEntity = function(self, resloader, target)
  -- function num : 0_26
  if target ~= nil then
    target:OnDeleteEntity()
  end
  if resloader ~= nil then
    resloader:Put2Pool()
  end
end

UIManager.DeleteAllWindow = function(self)
  -- function num : 0_27 , upvalues : _ENV
  self._inDeleteAllWindow = true
  self:ClearAllAsyncLoad()
  for k,window in pairs(self.windows) do
    if not window.__permanent then
      self:DeleteWindow(k, true)
    end
  end
  self._inDeleteAllWindow = false
end

UIManager.InDeleteAllWindow = function(self)
  -- function num : 0_28
  return self._inDeleteAllWindow
end

UIManager.ClearAllAsyncLoad = function(self)
  -- function num : 0_29 , upvalues : _ENV, cs_UIManager
  for typeID,v in pairs(self.async_loaders) do
    local resloader = (self.resloaders)[typeID]
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

    if resloader ~= nil then
      (self.resloaders)[typeID] = nil
      resloader:Put2Pool()
    end
  end
  self.async_loaders = {}
  cs_UIManager.MaxMaskActive = false
end

UIManager.IsWindowInLoading = function(self, typeID)
  -- function num : 0_30
  do return (self.async_loaders)[typeID] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIManager.GetUILayer = function(self, layerId)
  -- function num : 0_31
  return (self.layers)[layerId]
end

UIManager.CopyUI3DModifier = function(self, srcObj, destObj, useSimpleRotation)
  -- function num : 0_32 , upvalues : _ENV
  if not useSimpleRotation then
    useSimpleRotation = false
  end
  ;
  ((CS.UIManager).CopyUI3DModifier)(srcObj, destObj, useSimpleRotation)
end

UIManager.GetSortingLayerName = function(self, layerId)
  -- function num : 0_33
  return (self.sortingLayerList)[layerId]
end

UIManager.CreateThreeDCanvas = function(self, typeId, Callback, name)
  -- function num : 0_34 , upvalues : _ENV
  local path = PathConsts:GetTreeDCanvasPath("UI3DCanvas")
  ;
  ((self.resloaders)[typeId]):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_34_0 , upvalues : name, Callback
    local canvas = prefab:Instantiate()
    -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (canvas.gameObject).name = name .. "3DCanvas"
    Callback(canvas)
  end
)
end

UIManager.HideAllWindow = function(self, exceptDic)
  -- function num : 0_35 , upvalues : _ENV
  if not exceptDic then
    exceptDic = {}
  end
  exceptDic[UIWindowTypeID.Home] = true
  exceptDic[UIWindowTypeID.ClickContinue] = true
  local hideWinList = {}
  for typeID,win in pairs(self.windows) do
    if not win.__permanent and win.active and not win.isColsingWin and exceptDic[typeID] == nil then
      win:Hide()
      local winData = {}
      winData.win = win
      winData.returnCallback = win:GenCoverJumpReturnCallback()
      ;
      (table.insert)(hideWinList, winData)
    end
  end
  return hideWinList
end

UIManager.OnClickNavBack = function(self)
  -- function num : 0_36 , upvalues : _ENV, cs_UIManager, CS_ClientConsts, cs_MicaSDKManager
  if UIWindowTypeID == nil then
    return 
  end
  local clickToContinueWin = self:GetWindow(UIWindowTypeID.ClickContinue)
  if cs_UIManager.MaxMaskActive or clickToContinueWin ~= nil and clickToContinueWin.active then
    return 
  end
  local avgSkipWin = self:GetWindow(UIWindowTypeID.AvgSkip)
  if avgSkipWin ~= nil then
    avgSkipWin:OnClickClose()
    return 
  end
  local avgWin = self:GetWindow(UIWindowTypeID.Avg)
  if avgWin ~= nil then
    avgWin:OnClickSkip()
    return 
  end
  local guidePictureWin = self:GetWindow(UIWindowTypeID.GuidePicture_0623New)
  if guidePictureWin ~= nil then
    (UIUtil.OnClickBack)()
    return 
  end
  local messageBoxWin = self:GetWindow(UIWindowTypeID.MessageBox)
  if messageBoxWin ~= nil and messageBoxWin.active then
    messageBoxWin:OnClickNo()
    messageBoxWin:OnClickClose()
    return 
  end
  local messageCommonWin = self:GetWindow(UIWindowTypeID.MessageCommon)
  if messageCommonWin ~= nil and messageCommonWin.active then
    messageCommonWin:OnClickNo()
    messageCommonWin:OnClickClose()
    return 
  end
  if GuideManager.inGuide and CS_ClientConsts.IsAudit then
    cs_MicaSDKManager:ExitGame()
  end
  do return  end
  local getHeroWin = self:GetWindow(UIWindowTypeID.GetHero)
  if getHeroWin ~= nil then
    getHeroWin:OnClickClose()
    getHeroWin:OnClickSkip()
    return 
  end
  local commonRewardWin = self:GetWindow(UIWindowTypeID.CommonReward)
  if commonRewardWin ~= nil then
    commonRewardWin:OnClickClose()
    return 
  end
  local battleWin = self:GetWindow(UIWindowTypeID.Battle)
  if battleWin ~= nil and battleWin:TryClickBattlePause() then
    return 
  end
  if (UIUtil.PeekBackStack)() ~= nil then
    (UIUtil.OnClickBack)()
    return 
  end
  local explorationWin = self:GetWindow(UIWindowTypeID.Exploration)
  if explorationWin ~= nil and explorationWin.active then
    explorationWin:OnBtnRetreatClicked()
    return 
  end
  cs_MicaSDKManager:ExitGame()
end

UIManager.CreateNewUINode = function(self, nodeGameObject, luaPathString)
  -- function num : 0_37 , upvalues : _ENV
  local nodeClass = require(luaPathString)
  local node = (nodeClass.New)()
  node:Init(nodeGameObject)
  return node
end

return UIManager

