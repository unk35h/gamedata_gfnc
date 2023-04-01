-- params : ...
-- function num : 0 , upvalues : _ENV
UIBaseWindow = class("UIBaseWindow", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_Ease = ((CS.DG).Tweening).Ease
-- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

UIBaseWindow.ctor = function(self)
  -- function num : 0_0
  self.__typeID = nil
end

-- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

UIBaseWindow.GetUIWindowTypeId = function(self)
  -- function num : 0_1
  return self.__typeID
end

-- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

UIBaseWindow.Init = function(self, root)
  -- function num : 0_2 , upvalues : base
  self.__permanent = false
  ;
  (base.Init)(self, root)
end

-- DECOMPILER ERROR at PC25: Confused about usage of register: R3 in 'UnsetPending'

UIBaseWindow.Delete = function(self, isImmeDelete)
  -- function num : 0_3 , upvalues : _ENV
  if self.treeDCanvas ~= nil then
    DestroyUnityObject(self.treeDCanvas)
  end
  UIManager:DeleteWindow(self.__typeID, isImmeDelete)
end

-- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

UIBaseWindow.GetWindowSortingLayer = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local uiconfig = UIWindowGlobalConfig[self.__typeID]
  return UIManager:GetSortingLayerName(uiconfig.LayoutLevel + 1)
end

local cs_ScreenSpaceCamera = ((CS.UnityEngine).RenderMode).ScreenSpaceCamera
local cs_WorldSpace = ((CS.UnityEngine).RenderMode).WorldSpace
local cs_Canvas = (CS.UnityEngine).Canvas
local cs_UIManager = (CS.UIManager).Instance
-- DECOMPILER ERROR at PC45: Confused about usage of register: R7 in 'UnsetPending'

UIBaseWindow.AlignToFakeCamera = function(self, camera, newWorldCamera)
  -- function num : 0_5 , upvalues : _ENV, cs_Canvas, cs_ScreenSpaceCamera, cs_UIManager, cs_WorldSpace
  if self.canvas == nil then
    self.canvas = (camera.transform):GetComponentInChildren(typeof(cs_Canvas))
  end
  local canvasScale = (self.canvas):FindComponent(eUnityComponentID.CanvasScaler)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.canvas).worldCamera = camera
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.canvas).renderMode = cs_ScreenSpaceCamera
  cs_UIManager:AdaptationCanvasScaler(canvasScale, true)
  ;
  (self.transform):SetParent((self.canvas).transform, false)
  ;
  (cs_Canvas.ForceUpdateCanvases)()
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.canvas).renderMode = cs_WorldSpace
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R4 in 'UnsetPending'

  if newWorldCamera then
    (self.canvas).worldCamera = newWorldCamera
  else
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.canvas).worldCamera = ((CS.UnityEngine).Camera).main
  end
  cs_UIManager:SetNotchTransfrom(self.transform)
end

-- DECOMPILER ERROR at PC48: Confused about usage of register: R7 in 'UnsetPending'

UIBaseWindow.SetWindows2TreeDCanvas = function(self, layerID)
  -- function num : 0_6 , upvalues : _ENV, cs_UIManager, cs_ScreenSpaceCamera, cs_Canvas, cs_WorldSpace
  local coroutineFunc = function(objCanvas)
    -- function num : 0_6_0 , upvalues : self, _ENV, cs_UIManager, cs_ScreenSpaceCamera, cs_Canvas, cs_WorldSpace, layerID
    self.treeDCanvas = objCanvas
    local canvasScale = objCanvas:FindComponent(eUnityComponentID.CanvasScaler)
    local treeDCanvas = objCanvas:FindComponent(eUnityComponentID.Canvas)
    treeDCanvas.worldCamera = cs_UIManager.UICamera
    treeDCanvas.renderMode = cs_ScreenSpaceCamera
    cs_UIManager:AdaptationCanvasScaler(canvasScale, true)
    ;
    (self.transform):SetParent(treeDCanvas.transform, false)
    ;
    (cs_Canvas.ForceUpdateCanvases)()
    treeDCanvas.renderMode = cs_WorldSpace
    treeDCanvas.worldCamera = cs_UIManager.UICamera
    treeDCanvas.sortingLayerName = UIManager:GetSortingLayerName(layerID + 1)
    cs_UIManager:SetNotchTransfrom(self.transform)
  end

  UIManager:CreateThreeDCanvas(self.__typeID, coroutineFunc, (self.gameObject).name)
end

-- DECOMPILER ERROR at PC51: Confused about usage of register: R7 in 'UnsetPending'

UIBaseWindow.WinNextWithoutSound = function(self)
  -- function num : 0_7
  self._nextWithoutSound = true
end

-- DECOMPILER ERROR at PC54: Confused about usage of register: R7 in 'UnsetPending'

UIBaseWindow.OnShow = function(self)
  -- function num : 0_8 , upvalues : base, cs_Ease, _ENV
  (base.OnShow)(self)
  if self.winTween ~= nil then
    (self.winTween):SetEase(cs_Ease.OutExpo)
    ;
    (self.winTween):Restart()
  else
    self:__InitTween()
  end
  local uiconfig = UIWindowGlobalConfig[self.__typeID]
  if uiconfig.ShowWinAuId ~= nil and not self._nextWithoutSound then
    AudioManager:PlayAudioById(uiconfig.ShowWinAuId)
  end
  self._nextWithoutSound = nil
end

-- DECOMPILER ERROR at PC57: Confused about usage of register: R7 in 'UnsetPending'

UIBaseWindow.OnHide = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  do
    if not UIManager:InDeleteAllWindow() then
      local uiconfig = UIWindowGlobalConfig[self.__typeID]
      if uiconfig.HideWinAuId ~= nil and not self._nextWithoutSound then
        AudioManager:PlayAudioById(uiconfig.HideWinAuId)
      end
    end
    self._nextWithoutSound = nil
    ;
    (base.OnHide)(self)
  end
end

local GetWindowCoverId = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local coverId = "wid_" .. tostring(self.__typeID)
  return coverId
end

local WindowAnimaFuncs = {[EUIAnimaType.Fade] = function(self)
  -- function num : 0_11
  (self.winTween):Append((((self.ui).canvasGroup):DOFade(0, 0.5)):From())
end
, [EUIAnimaType.FadeScaleUp] = function(self)
  -- function num : 0_12
  (self.winTween):Append((((self.ui).canvasGroup):DOFade(0, 0.5)):From())
  ;
  (self.winTween):Join(((self.transform):DOScale(1.2, 0.5)):From())
end
, [EUIAnimaType.FadeScaleDown] = function(self)
  -- function num : 0_13 , upvalues : GetWindowCoverId, _ENV
  local coverId = GetWindowCoverId(self)
  self.__wcoverId = coverId
  ;
  (UIUtil.AddOneCover)(coverId)
  ;
  (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
  ;
  (self.winTween):Append((((self.ui).canvasGroup):DOFade(0, 0.5)):From())
  ;
  (self.winTween):Join(((self.transform):DOScale(0.4, 0.5)):From())
  ;
  (self.winTween):OnComplete(function()
    -- function num : 0_13_0 , upvalues : _ENV, coverId
    (UIUtil.CloseOneCover)(coverId)
  end
)
end
, [EUIAnimaType.ScaleUp] = function(self)
  -- function num : 0_14
  (self.winTween):Append(((self.transform):DOScale(1.2, 0.5)):From())
end
, [EUIAnimaType.FadeScaleBottomLeft] = function(self)
  -- function num : 0_15 , upvalues : GetWindowCoverId, _ENV
  local coverId = GetWindowCoverId(self)
  self.__wcoverId = coverId
  ;
  (UIUtil.AddOneCover)(coverId)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).pivot = Vector2.zero
  ;
  (self.winTween):Append((((self.ui).canvasGroup):DOFade(0, 0.5)):From())
  ;
  (self.winTween):Join(((self.transform):DOScale(0.2, 0.5)):From())
  ;
  (self.winTween):OnComplete(function()
    -- function num : 0_15_0 , upvalues : _ENV, coverId
    (UIUtil.CloseOneCover)(coverId)
  end
)
end
, [EUIAnimaType.FadeScaleTopLeft] = function(self)
  -- function num : 0_16 , upvalues : GetWindowCoverId, _ENV
  local coverId = GetWindowCoverId(self)
  self.__wcoverId = coverId
  ;
  (UIUtil.AddOneCover)(coverId)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self.transform).pivot = (Vector2.New)(0, 1)
  ;
  (self.winTween):Append((((self.ui).canvasGroup):DOFade(0, 0.5)):From())
  ;
  (self.winTween):Join(((self.transform):DOScale(0.2, 0.5)):From())
  ;
  (self.winTween):OnComplete(function()
    -- function num : 0_16_0 , upvalues : _ENV, coverId
    (UIUtil.CloseOneCover)(coverId)
  end
)
end
}
-- DECOMPILER ERROR at PC86: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.__InitTween = function(self)
  -- function num : 0_17 , upvalues : cs_DoTween, WindowAnimaFuncs, cs_Ease
  if self.__typeID == nil then
    return 
  end
  local animaType = self.__winAnima
  if animaType == nil then
    return 
  end
  self.winTween = (cs_DoTween.Sequence)()
  local animaFunc = WindowAnimaFuncs[animaType]
  animaFunc(self)
  ;
  (self.winTween):SetEase(cs_Ease.OutQuart)
  ;
  (self.winTween):SetAutoKill(false)
  ;
  (self.winTween):SetUpdate(true)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.winTween).target = self.transform
end

-- DECOMPILER ERROR at PC89: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.CloseTween = function(self, resloader)
  -- function num : 0_18 , upvalues : cs_Ease, _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if (self.ui).canvasGroup ~= nil then
    ((self.ui).canvasGroup).blocksRaycasts = false
  end
  ;
  (self.winTween):SetEase(cs_Ease.InExpo)
  ;
  (self.winTween):OnRewind(function()
    -- function num : 0_18_0 , upvalues : self, _ENV, resloader
    if self.__wcoverId ~= nil then
      (UIUtil.CloseOneCover)(self.__wcoverId)
    end
    ;
    (self.winTween):Kill()
    self.winTween = nil
    self:OnCloseTween()
    UIManager:RecycleWindowEntity(resloader, self)
  end
)
  if self.__wcoverId ~= nil then
    (UIUtil.AddOneCover)(self.__wcoverId)
  end
  ;
  (self.winTween):Complete()
  ;
  (self.winTween):PlayBackwards()
end

-- DECOMPILER ERROR at PC92: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.OnCloseTween = function(self)
  -- function num : 0_19
end

-- DECOMPILER ERROR at PC95: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.SwitchFakeCanvasScreen = function(self)
  -- function num : 0_20 , upvalues : cs_ScreenSpaceCamera
  if self.canvas == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.canvas).renderMode = cs_ScreenSpaceCamera
end

-- DECOMPILER ERROR at PC98: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.SwitchFakeCanvasWorld = function(self)
  -- function num : 0_21 , upvalues : cs_WorldSpace
  if self.canvas == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.canvas).renderMode = cs_WorldSpace
end

-- DECOMPILER ERROR at PC101: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.SetFromWhichUI = function(self, fromType)
  -- function num : 0_22
  self.fromType = fromType
end

-- DECOMPILER ERROR at PC104: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.GenCoverJumpReturnCallback = function(self)
  -- function num : 0_23
  return nil
end

-- DECOMPILER ERROR at PC107: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.OnCloseWin = function(self)
  -- function num : 0_24 , upvalues : _ENV
  if self.fromType == nil or self.fromType <= 0 then
    return 
  end
  do
    if self.fromType & eBaseWinFromWhere.home == eBaseWinFromWhere.home then
      local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
      if homeWin ~= nil then
        homeWin:BackFromOtherWin()
      end
    end
    do
      if self.fromType & eBaseWinFromWhere.homeCorver == eBaseWinFromWhere.homeCorver then
        local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
        if homeWin ~= nil then
          homeWin:BackFromOtherCoverWin()
        end
      end
      if self.fromType & eBaseWinFromWhere.jumpCorver == eBaseWinFromWhere.jumpCorver and self.jumpCorverArgs ~= nil then
        local hadledDic = {}
        local JumpManager = require("Game.Jump.JumpManager")
        for _,winTypeId in ipairs(CoverJumpReturnOrder) do
          for index,winData in pairs((self.jumpCorverArgs).hideWinList) do
            if winData.win ~= nil and (winData.win).gameObject ~= nil and (winData.win):GetUIWindowTypeId() == winTypeId then
              local notNeedShow = false
              if winData.returnCallback ~= nil then
                notNeedShow = (winData.returnCallback)()
              end
              if not notNeedShow then
                (winData.win):Show()
              end
              hadledDic[index] = true
              break
            end
          end
        end
        for index,winData in pairs((self.jumpCorverArgs).hideWinList) do
          if not hadledDic[index] and winData.win ~= nil and (winData.win).gameObject ~= nil then
            local notNeedShow = false
            if winData.returnCallback ~= nil then
              notNeedShow = (winData.returnCallback)()
            end
            if not notNeedShow then
              (winData.win):Show()
            end
          end
        end
        if (self.jumpCorverArgs).befroeJumpCouldUseItemJump ~= nil then
          JumpManager.couldUseItemJump = (self.jumpCorverArgs).befroeJumpCouldUseItemJump
        end
      end
    end
  end
end

-- DECOMPILER ERROR at PC110: Confused about usage of register: R9 in 'UnsetPending'

UIBaseWindow.AutoDeleteTopStatus = function(self)
  -- function num : 0_25 , upvalues : _ENV
  return (UIUtil.CheckTopWindowAndClear)(self.__typeID)
end

return UIBaseWindow

