-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAdjEditor = class("UIAdjEditor", UIBaseWindow)
local base = UIBaseWindow
local UINSiftCondition = require("Game.Hero.NewUI.SortList.UINSiftCondition")
local UINAdjEditorOperation = require("Game.AdjCustom.AdjEdit.UINAdjEditorOperation")
local UINAdjEditorSetBg = require("Game.AdjCustom.AdjEdit.UINAdjEditorSetBg")
local UINAdjEditorSetHero = require("Game.AdjCustom.AdjEdit.UINAdjEditorSetHero")
local UINAdjEditorSetSkin = require("Game.AdjCustom.AdjEdit.UINAdjEditorSetSkin")
local HeroL2dInterationController = require("Game.Hero.Live2D.HeroL2dInterationController")
local CS_ResLoader = CS.ResLoader
local CS_LeanTouch = ((CS.Lean).Touch).LeanTouch
local CS_RenderManager = CS.RenderManager
;
(xlua.private_accessible)((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController)
local CS_MessageCommon = CS.MessageCommon
UIAdjEditor.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINAdjEditorOperation, UINAdjEditorSetBg, UINAdjEditorSetHero, UINAdjEditorSetSkin
  (UIUtil.SetTopStatus)(self, self.CancleAdjEdit)
  ;
  (UIUtil.AddClickHomeCheckFunc)(BindCallback(self, self.__CheckClickTopHome))
  self._adjOperation = (UINAdjEditorOperation.New)()
  ;
  (self._adjOperation):Init((self.ui).uINAdjSetEditor)
  ;
  (self._adjOperation):InitUINAdjEditorOperation(self)
  ;
  (self._adjOperation):Hide()
  self._adjSetBg = (UINAdjEditorSetBg.New)()
  ;
  (self._adjSetBg):Init((self.ui).uINAdjSelectBg)
  ;
  (self._adjSetBg):InitUINAdjEditorSetBg(self)
  ;
  (self._adjSetBg):Hide()
  self._adjSetHero = (UINAdjEditorSetHero.New)()
  ;
  (self._adjSetHero):Init((self.ui).uINAdjSetHero)
  ;
  (self._adjSetHero):InitUINAdjEditorSetHero(self)
  ;
  (self._adjSetHero):Hide()
  self._adjSetSkin = (UINAdjEditorSetSkin.New)()
  ;
  (self._adjSetSkin):Init((self.ui).uINAdjSetSkin)
  ;
  (self._adjSetSkin):InitUINAdjEditorSetSkin(self)
  ;
  (self._adjSetSkin):Hide()
  self.subType = {Operation = 1, SetBg = 2, SetHero = 3, SetSkin = 4}
  self._UIStateUpdateFuncDic = {
[(self.subType).Operation] = {node = self._adjOperation, updateFunc = (self._adjOperation).UpdateUINAdjEditorOperation}
, 
[(self.subType).SetBg] = {node = self._adjSetBg, updateFunc = (self._adjSetBg).UpdateUINAdjEditorSetBg}
, 
[(self.subType).SetHero] = {node = self._adjSetHero, updateFunc = (self._adjSetHero).UpdateUINAdjEditorSetHero}
, 
[(self.subType).SetSkin] = {node = self._adjSetSkin, updateFunc = (self._adjSetSkin).UpdateUINAdjEditorSetSkin}
}
  self._adjIndexDic = nil
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    self.newlive2DNode = homeUI:GetHomeMainL2dParent()
    self.newPicNode = homeUI:GetHomeMainPicParent()
    homeUI:OpenOtherWinWithMainCamera()
  end
end

UIAdjEditor.InitUIAdjEditor = function(self, adjTeamId, modifyIndex, closeFunc)
  -- function num : 0_1 , upvalues : _ENV
  self._adjTeamId = adjTeamId
  self._closeFunc = closeFunc
  self._modifyIndex = modifyIndex
  self._limitCount = ConfigData:GetAdjPresetHeroCount(adjTeamId)
  self._bgId = (ConfigData.game_config).defaultBackgroundMain
  self._isL2dOpen = true
  self._teamName = nil
  self._resLoadDic = nil
  self._adjInfoDic = {}
  local adjData = (PlayerDataCenter.allAdjCustomData):GetAdjCustomPresetData(adjTeamId)
  self._adjIndexDic = {}
  local hideL2dDic = (PlayerDataCenter.skinData):GetHideL2dDic()
  for skinId,value in pairs(hideL2dDic) do
    self:SetHideLive2dBg(skinId, value)
  end
  if adjData == nil then
    self:__ApplyMainBg()
    self:AdjEditJumpSubNode((self.subType).SetHero)
    return 
  end
  self._bgId = adjData:GetAdjPresetBgId()
  self._isL2dOpen = adjData:GetAdjPresetUseL2d()
  self._teamName = adjData:GetAdjPresetName()
  for index,heroId in ipairs(adjData:GetAdjPresetHeroList()) do
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R11 in 'UnsetPending'

    (self._adjIndexDic)[index] = heroId
    local heroAdjInfo = adjData:GetAdjPresetElemData(heroId)
    -- DECOMPILER ERROR at PC73: Confused about usage of register: R12 in 'UnsetPending'

    ;
    (self._adjInfoDic)[heroId] = {dataId = heroId, skinId = heroAdjInfo.skinId, size = heroAdjInfo.size}
    -- DECOMPILER ERROR at PC85: Confused about usage of register: R12 in 'UnsetPending'

    if heroAdjInfo.pos ~= nil then
      ((self._adjInfoDic)[heroId]).pos = {(heroAdjInfo.pos)[1], (heroAdjInfo.pos)[2]}
    end
    self:__LoadResource(heroId)
  end
  self:__CheckL2dFirbid()
  if (self._adjIndexDic)[self._modifyIndex] ~= nil then
    self:AdjEditJumpSubNode((self.subType).Operation)
  else
    self:AdjEditJumpSubNode((self.subType).SetHero)
  end
  self:__ApplyMainBg()
end

UIAdjEditor.SetAdjEditBg = function(self, bgId)
  -- function num : 0_2
  if self._bgId == bgId then
    return 
  end
  self._bgId = bgId
  if (self._adjOperation).active then
    (self._adjOperation):RefreshAdjOperaBgSelect()
  end
  self:__ApplyMainBg()
end

UIAdjEditor.__ApplyMainBg = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeCtrl == nil then
    return 
  end
  if self._bgId == nil then
    homeCtrl:ResetHomeMainBg()
    return 
  end
  local bgCfg = (ConfigData.background)[self._bgId]
  if bgCfg == nil then
    homeCtrl:ResetHomeMainBg()
    return 
  end
  homeCtrl:SetHomeMainEditorBg(bgCfg)
end

UIAdjEditor.SetAdjEditHero = function(self, heroId, isOn)
  -- function num : 0_4 , upvalues : _ENV
  if isOn and (self._adjInfoDic)[heroId] == nil then
    local oriHeroId = (self._adjIndexDic)[self._modifyIndex]
    if oriHeroId ~= nil then
      self:__UnloadResource(oriHeroId)
      -- DECOMPILER ERROR at PC15: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (self._adjInfoDic)[oriHeroId] = nil
    end
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._adjIndexDic)[self._modifyIndex] = heroId
    local heroData = (PlayerDataCenter.heroDic)[heroId]
    local defaultSkinId = heroData ~= nil and heroData.skinId or 0
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (self._adjInfoDic)[heroId] = {dataId = heroId, skinId = defaultSkinId}
    if self:GetAdjMainHeroId() == heroId then
      self:__CheckL2dFirbid()
      if not self._forbidL2d then
        self._isL2dOpen = true
      end
    end
    self:__LoadResource(heroId)
  else
    do
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R3 in 'UnsetPending'

      if not isOn and (self._adjInfoDic)[heroId] ~= nil then
        (self._adjIndexDic)[self._modifyIndex] = nil
        -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

        ;
        (self._adjInfoDic)[heroId] = nil
        self:__UnloadResource(heroId)
      end
    end
  end
end

UIAdjEditor.SetAdjEditHeroPosition = function(self, heroId, vec)
  -- function num : 0_5
  local data = (self._adjInfoDic)[heroId]
  if data == nil then
    return 
  end
  if vec == nil then
    data.pos = nil
  else
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R4 in 'UnsetPending'

    if data.pos ~= nil then
      (data.pos)[1] = vec.x
      -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

      ;
      (data.pos)[2] = vec.y
    else
      data.pos = {vec.x, vec.y}
    end
  end
  self:__AdjustResourceShow(heroId)
end

UIAdjEditor.ResetAdjEditHeroPostion = function(self, heroId)
  -- function num : 0_6
  local resInfo = (self._resLoadDic)[heroId]
  if resInfo == nil then
    return 
  end
  local adjInfo = (self._adjInfoDic)[heroId]
  adjInfo.pos = nil
  adjInfo.size = nil
  self:__AdjustResourceShow(heroId)
end

UIAdjEditor.SetAdjEditHeroScale = function(self, heroId, size)
  -- function num : 0_7 , upvalues : _ENV
  local data = (self._adjInfoDic)[heroId]
  if data == nil then
    return 
  end
  data.size = size
  if data.size == 1 then
    data.size = nil
  end
  self:__AdjustResourceShow(heroId)
  local limitX, limitY = self:__GetLimitPos(heroId)
  if limitX == nil then
    return 
  end
  local obj = ((self._resLoadDic)[heroId]).obj
  local pos = (obj.transform).localPosition
  pos.x = (math.clamp)(pos.x, limitX[1], limitX[2])
  pos.y = (math.clamp)(pos.y, limitY[1], limitY[2])
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R8 in 'UnsetPending'

  if pos ~= (obj.transform).localPosition then
    (obj.transform).localPosition = pos
    self:__RecordResourceShow(heroId)
  end
end

UIAdjEditor.SetAdjEditHeroSkin = function(self, heroId, skinId)
  -- function num : 0_8
  local data = (self._adjInfoDic)[heroId]
  if data == nil then
    return 
  end
  if self:__GetHeroDefaultSkinId(heroId) == skinId then
    skinId = 0
  end
  if skinId == data.skinId then
    return 
  end
  data.skinId = skinId
  if self:GetAdjMainHeroId() == heroId then
    self:__CheckL2dFirbid()
    if not self._forbidL2d then
      self._isL2dOpen = true
    end
  end
  data.pos = nil
  data.size = nil
  self:__LoadResource(heroId)
end

UIAdjEditor.SetAdjEditL2dTog = function(self, flag)
  -- function num : 0_9 , upvalues : _ENV
  if self:IsAdjForbidL2d() then
    return 
  end
  if self._isL2dOpen == flag then
    return 
  end
  self._isL2dOpen = flag
  local heroId = self:GetAdjMainHeroId()
  if heroId ~= nil then
    if self.usingType == (self.subType).Operation or self.usingType == (self.subType).SetSkin then
      local data = (self._adjInfoDic)[heroId]
      data.pos = nil
      local resInfo = (self._resLoadDic)[heroId]
      if not IsNull(resInfo.obj) then
        data.screenPos = (UIManager:GetMainCamera()):WorldToScreenPoint(((resInfo.obj).transform).position)
      end
    end
    do
      self:__LoadResource(heroId)
    end
  end
end

UIAdjEditor.SetHideL2dBgTog = function(self, heroId, skinId, isHide)
  -- function num : 0_10
  if self:IsAdjForbidL2d() then
    return 
  end
  if self:IsHideLive2dBg(skinId) == isHide then
    return 
  end
  self:SetHideLive2dBg(skinId, isHide)
  self:__RealActiveL2dBg(heroId, isHide)
end

UIAdjEditor.ChangeAdjMainHero = function(self)
  -- function num : 0_11 , upvalues : _ENV
  if self:GetAdjCurCount() < 2 then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._adjIndexDic)[1] = (self._adjIndexDic)[2]
  self._modifyIndex = self._modifyIndex == 1 and 2 or 1
  if self._isL2dOpen then
    local heroId = (self._adjIndexDic)[2]
    local resInfo = (self._resLoadDic)[heroId]
    local adjInfo = (self._adjInfoDic)[heroId]
    adjInfo.pos = nil
    if not IsNull(resInfo.obj) then
      adjInfo.screenPos = (UIManager:GetMainCamera()):WorldToScreenPoint(((resInfo.obj).transform).position)
    end
    self:__LoadResource(heroId)
  end
  do
    self:__AdjustResourceSortOrder()
    self:__CheckL2dFirbid()
    if not self._forbidL2d then
      self._isL2dOpen = true
      local heroId = (self._adjIndexDic)[1]
      local resInfo = (self._resLoadDic)[heroId]
      local adjInfo = (self._adjInfoDic)[heroId]
      adjInfo.pos = nil
      if not IsNull(resInfo.obj) then
        adjInfo.screenPos = (UIManager:GetMainCamera()):WorldToScreenPoint(((resInfo.obj).transform).position)
      end
      self:__LoadResource(heroId)
    end
    do
      if (self._adjOperation).active then
        (self._adjOperation):RefreshAdjL2DTogGroup()
        ;
        (self._adjOperation):RefreshAdjOperationHeroMain()
      end
    end
  end
end

UIAdjEditor.ChangeAdjModifyIndex = function(self, index)
  -- function num : 0_12
  if index ~= self._modifyIndex and index > 0 and index <= self._limitCount then
    self._modifyIndex = index
    if self._adjOperation ~= nil then
      (self._adjOperation):RefreshAdjOperationHeroMain()
    end
  end
end

UIAdjEditor.AdjEditJumpSubNode = function(self, subType)
  -- function num : 0_13 , upvalues : _ENV
  if self.usingType == (self.subType).Operation then
    self:__RecordCache()
  end
  if (self._adjOperation).active then
    self:__RegisterLeanTouch(false)
  end
  for uiType,data in pairs(self._UIStateUpdateFuncDic) do
    if uiType == subType then
      (data.node):Show()
      ;
      (data.updateFunc)(data.node, self._modifyIndex)
    else
      ;
      (data.node):Hide()
    end
  end
  if (self._adjOperation).active then
    self:__RegisterLeanTouch(true)
  end
  if subType == (self.subType).SetSkin then
    ((self.ui).tex_Title):SetIndex(1)
    ;
    (self._adjSetSkin):SetUINAdjLastSubType(self.usingType)
  else
    if subType == (self.subType).SetBg then
      ((self.ui).tex_Title):SetIndex(2)
    else
      ;
      ((self.ui).tex_Title):SetIndex(0)
    end
  end
  self.usingType = subType
  if self.usingType == (self.subType).Operation then
    self:__ClearCache()
  end
end

UIAdjEditor.__UnloadResource = function(self, heroId)
  -- function num : 0_14 , upvalues : _ENV
  if self._resLoadDic == nil or (self._resLoadDic)[heroId] == nil then
    return 
  end
  local resInfo = (self._resLoadDic)[heroId]
  if not IsNull(resInfo.obj) then
    DestroyUnityObject(resInfo.obj)
  end
  ;
  (resInfo.resloader):Put2Pool()
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._resLoadDic)[heroId] = nil
end

UIAdjEditor.__LoadResource = function(self, heroId)
  -- function num : 0_15 , upvalues : CS_ResLoader, _ENV
  self:__UnloadResource(heroId)
  if self._resLoadDic == nil then
    self._resLoadDic = {}
  end
  local resInfo = {dataId = heroId, resloader = (CS_ResLoader.Create)()}
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._resLoadDic)[heroId] = resInfo
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  local resModel = skinCtr:GetResModel(heroId, ((self._adjInfoDic)[heroId]).skinId)
  local Local_TrySetShowStateFunc = function(go)
    -- function num : 0_15_0 , upvalues : self, heroId, _ENV
    local resInfo = (self._resLoadDic)[heroId]
    resInfo.oriSize = ((go.transform).localScale).x
    resInfo.oriPosition = (go.transform).localPosition
    self:__AdjustResourceShow(heroId)
    if (self._adjOperation).active then
      (self._adjOperation):RefreshAdjOperaHeroSize(heroId)
    end
    self:__AdjustResourceSortOrder()
    local adjInfo = (self._adjInfoDic)[heroId]
    if adjInfo ~= nil and adjInfo.screenPos ~= nil then
      local localPos = TransitionScreenPoint(UIManager:GetMainCamera(), go, adjInfo.screenPos)
      local limitX, limitY = self:__GetLimitPos(heroId)
      if limitX ~= nil then
        localPos.x = (math.clamp)(localPos.x, limitX[1], limitX[2])
        localPos.y = (math.clamp)(localPos.y, limitY[1], limitY[2])
      end
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (go.transform).localPosition = localPos
      self:__RecordResourceShow(heroId)
      adjInfo.screenPos = nil
    end
  end

  if self._isL2dOpen and heroId == self:GetAdjMainHeroId() then
    local isHideBg = self:IsHideLive2dBg(((self._adjInfoDic)[heroId]).skinId)
    self:__LoadLive2D(resModel, resInfo, Local_TrySetShowStateFunc, isHideBg)
  else
    do
      self:__LoadPic(resModel, resInfo, Local_TrySetShowStateFunc)
    end
  end
end

UIAdjEditor.__LoadLive2D = function(self, resModel, resInfo, callback, isHideBg)
  -- function num : 0_16 , upvalues : _ENV, HeroL2dInterationController
  local path = PathConsts:GetCharacterLive2DPath(resModel.src_id_pic)
  ;
  (resInfo.resloader):LoadABAssetAsync(path, function(l2dModelAsset)
    -- function num : 0_16_0 , upvalues : _ENV, self, resInfo, HeroL2dInterationController, isHideBg, callback
    if IsNull(self.transform) then
      return 
    end
    resInfo.obj = l2dModelAsset:Instantiate((self.newlive2DNode).transform)
    ;
    ((resInfo.obj).transform):SetLayer(LayerMask.UI3D)
    local cs_mouth = (resInfo.obj):GetComponent(typeof(((((CS.Live2D).Cubism).Framework).MouthMovement).CubismMouthController))
    if cs_mouth ~= nil then
      cs_mouth.enabled = false
    end
    resInfo.l2dBinding = {}
    ;
    (UIUtil.LuaUIBindingTable)(resInfo.obj, resInfo.l2dBinding)
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

    if self.newlive2DUIGroup ~= nil then
      ((resInfo.l2dBinding).renderController).uiCanvasGroup = self.newlive2DUIGroup
      -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((resInfo.l2dBinding).renderController).SortingLayer = "UI3D"
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((resInfo.l2dBinding).renderController).SortingOrder = -900
      -- DECOMPILER ERROR at PC53: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((resInfo.l2dBinding).renderController).InfluencedByUICanvas = true
      ;
      (HeroL2dInterationController.ActiveLive2dBg)((resInfo.l2dBinding).renderController, not isHideBg)
    end
    ;
    ((resInfo.l2dBinding).commonPerpectiveHandle):SetRenderCamera(self.newlive2DNode)
    ;
    ((resInfo.l2dBinding).commonPerpectiveHandle):SetL2DPosType("Home", false)
    resInfo.cs_cubismCom = (resInfo.obj):GetComponent(typeof((((((CS.Live2D).Cubism).Samples).OriginalWorkflow).Demo).CubismInterationController))
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R2 in 'UnsetPending'

    if resInfo.cs_cubismCom ~= nil then
      (resInfo.cs_cubismCom).enabled = true
    end
    callback(resInfo.obj)
  end
)
end

UIAdjEditor.__LoadPic = function(self, resModel, resInfo, callback)
  -- function num : 0_17 , upvalues : _ENV
  local path = PathConsts:GetCharacterBigImgPrefabPath(resModel.src_id_pic)
  ;
  (resInfo.resloader):LoadABAssetAsync(path, function(prefab)
    -- function num : 0_17_0 , upvalues : _ENV, self, resInfo, callback
    if IsNull(self.transform) then
      return 
    end
    resInfo.obj = prefab:Instantiate((self.newPicNode).transform)
    resInfo.commonPicCom = (resInfo.obj):FindComponent(eUnityComponentID.CommonPicController)
    ;
    (resInfo.commonPicCom):SetPosType("Home")
    callback(resInfo.obj)
  end
)
end

UIAdjEditor.__AdjustResourceShow = function(self, heroId)
  -- function num : 0_18 , upvalues : _ENV
  if (self._resLoadDic)[heroId] == nil then
    return 
  end
  local resInfo = (self._resLoadDic)[heroId]
  local obj = resInfo.obj
  if IsNull(obj) then
    return 
  end
  local adjInfo = (self._adjInfoDic)[heroId]
  if adjInfo == nil then
    return 
  end
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R5 in 'UnsetPending'

  if adjInfo.pos ~= nil then
    (obj.transform).localPosition = (Vector3.New)((adjInfo.pos)[1], (adjInfo.pos)[2], ((obj.transform).localPosition).z)
  else
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (obj.transform).localPosition = resInfo.oriPosition
  end
  if adjInfo.size ~= nil then
    local size = adjInfo.size * resInfo.oriSize
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (obj.transform).localScale = (Vector3.New)(size, size, size)
  else
    do
      -- DECOMPILER ERROR at PC60: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (obj.transform).localScale = (Vector3.New)(resInfo.oriSize, resInfo.oriSize, resInfo.oriSize)
      if (self._adjOperation).active then
        (self._adjOperation):RefreshAdjOperaHeroSize(heroId)
      end
    end
  end
end

UIAdjEditor.__RealActiveL2dBg = function(self, heroId, isHide)
  -- function num : 0_19 , upvalues : _ENV, HeroL2dInterationController
  local resInfo = (self._resLoadDic)[heroId]
  if resInfo == nil then
    return 
  end
  if resInfo.l2dBinding == nil then
    return 
  end
  local renderController = (resInfo.l2dBinding).renderController
  if IsNull(renderController) then
    return 
  end
  ;
  (HeroL2dInterationController.ActiveLive2dBg)(renderController, not isHide)
end

UIAdjEditor.__RecordResourceShow = function(self, heroId)
  -- function num : 0_20 , upvalues : _ENV
  local resInfo = (self._resLoadDic)[heroId]
  if resInfo == nil then
    return 
  end
  local go = resInfo.obj
  if IsNull(go) then
    return 
  end
  local adjInfo = (self._adjInfoDic)[heroId]
  if adjInfo == nil then
    return 
  end
  local vec = (go.transform).localPosition
  if adjInfo.pos == nil then
    adjInfo.pos = {vec.x, vec.y}
  else
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (adjInfo.pos)[1] = vec.x
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R6 in 'UnsetPending'

    ;
    (adjInfo.pos)[2] = vec.y
  end
  if (self._adjOperation).active then
    (self._adjOperation):RefreshAdjOperaHeroSize(heroId)
  end
end

UIAdjEditor.__AdjustResourceSortOrder = function(self)
  -- function num : 0_21
  local heroId = self:GetAdjMainHeroId()
  local resInfo = (self._resLoadDic)[heroId]
  if resInfo ~= nil and resInfo.obj ~= nil then
    ((resInfo.obj).transform):SetAsLastSibling()
  end
end

UIAdjEditor.__GetHeroDefaultSkinId = function(self, heroId)
  -- function num : 0_22 , upvalues : _ENV
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg ~= nil then
    return heroCfg.default_skin
  end
end

UIAdjEditor.__CheckL2dFirbid = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local mainAdjId = self:GetAdjMainHeroId()
  if mainAdjId == nil then
    self._forbidL2d = true
    self._isL2dOpen = false
    self._l2dLevel = nil
    return 
  end
  local heroModifyData = (self._adjInfoDic)[mainAdjId]
  if heroModifyData == nil or heroModifyData.skinId == nil then
    self._forbidL2d = true
    self._isL2dOpen = false
    self._l2dLevel = nil
    return 
  end
  local skinId = heroModifyData.skinId
  if skinId == 0 then
    skinId = self:__GetHeroDefaultSkinId(mainAdjId)
  end
  local skinCfg = (ConfigData.skin)[skinId]
  if skinCfg == nil or skinCfg.live2d_level == 0 then
    self._forbidL2d = true
    self._isL2dOpen = false
    self._l2dLevel = nil
  else
    self._forbidL2d = false
    self._l2dLevel = skinCfg.live2d_level
  end
end

UIAdjEditor.__RegisterLeanTouch = function(self, flag)
  -- function num : 0_24 , upvalues : _ENV, CS_LeanTouch
  if flag then
    if self.__OnFingerDownCallback == nil then
      self.__OnFingerDownCallback = BindCallback(self, self.__OnFingerDown)
      self.__OnFingerUpCallback = BindCallback(self, self.__OnFingerUp)
      self.__OnGestureCallback = BindCallback(self, self.__OnGesture)
    end
    ;
    (CS_LeanTouch.OnFingerDown)("+", self.__OnFingerDownCallback)
    ;
    (CS_LeanTouch.OnFingerUp)("+", self.__OnFingerUpCallback)
    ;
    (CS_LeanTouch.OnGesture)("+", self.__OnGestureCallback)
  else
    if self.__OnFingerDownCallback ~= nil then
      (CS_LeanTouch.OnFingerDown)("-", self.__OnFingerDownCallback)
      ;
      (CS_LeanTouch.OnFingerUp)("-", self.__OnFingerUpCallback)
      ;
      (CS_LeanTouch.OnGesture)("-", self.__OnGestureCallback)
    end
  end
end

UIAdjEditor.__OnFingerDown = function(self, finger)
  -- function num : 0_25 , upvalues : CS_LeanTouch, _ENV
  if finger.IsOverGui then
    local screenPos = finger.ScreenPosition
    local rayResList = (CS_LeanTouch.RaycastGui)(screenPos)
    for i = 0, rayResList.Count - 1 do
      if ((rayResList[i]).gameObject).layer == (self.gameObject).layer then
        return 
      end
    end
  end
  do
    self._touchSelect = nil
    local heroId = (self._adjIndexDic)[self._modifyIndex]
    if heroId == nil then
      return 
    end
    self._dragLimitX = self:__GetLimitPos(heroId)
    if self._dragLimitX == nil then
      return 
    end
    self._touchIndex = finger.Index
    self._touchSelect = (self._resLoadDic)[heroId]
    self._lastTouchPoint = TransitionScreenPoint(UIManager:GetMainCamera(), (self._touchSelect).obj, finger.ScreenPosition)
  end
end

UIAdjEditor.__OnFingerUp = function(self, finger)
  -- function num : 0_26
  if self._touchIndex ~= finger.Index then
    return 
  end
  self._touchIndex = nil
  self._touchSelect = nil
  self._lastTouchPoint = nil
  self._dragLimitX = nil
  self._dragLimitY = nil
end

UIAdjEditor.__OnGesture = function(self, fingerList)
  -- function num : 0_27 , upvalues : _ENV
  local finger = nil
  for i = 0, fingerList.Count - 1 do
    local item = fingerList[i]
    if item.Index == self._touchIndex then
      finger = item
      break
    end
  end
  do
    if finger == nil or self._touchSelect == nil then
      return 
    end
    local dragObj = (self._touchSelect).obj
    local pos = TransitionScreenPoint(UIManager:GetMainCamera(), dragObj, finger.ScreenPosition)
    local diffPos = pos - self._lastTouchPoint
    diffPos.z = 0
    local finalPos = (dragObj.transform).localPosition + diffPos
    finalPos.x = (math.clamp)(finalPos.x, (self._dragLimitX)[1], (self._dragLimitX)[2])
    finalPos.y = (math.clamp)(finalPos.y, (self._dragLimitY)[1], (self._dragLimitY)[2])
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (dragObj.transform).localPosition = finalPos
    self:__RecordResourceShow((self._touchSelect).dataId)
    self._lastTouchPoint = pos
  end
end

UIAdjEditor.__GetLimitPos = function(self, heroId)
  -- function num : 0_28 , upvalues : _ENV
  local extra = ((self._adjInfoDic)[heroId]).size or 1
  extra = extra - 1
  if extra < 0 then
    extra = 0
  end
  local resInfo = (self._resLoadDic)[heroId]
  local obj = resInfo.obj
  if IsNull(obj) then
    return nil, nil
  end
  local backgroundStretchSize = (Vector2.New)(((CS.UnityEngine).Screen).width, ((CS.UnityEngine).Screen).height)
  local minPoint = TransitionScreenPoint(UIManager:GetMainCamera(), obj, (Vector2.New)(0, 0))
  local maxPoint = TransitionScreenPoint(UIManager:GetMainCamera(), obj, backgroundStretchSize)
  local dragLimitX = {minPoint.x, maxPoint.x}
  ;
  (table.sort)(dragLimitX)
  local dragLimitY = {minPoint.y, maxPoint.y}
  ;
  (table.sort)(dragLimitY)
  local extraLimitY = (dragLimitY[2] - dragLimitY[1]) * extra / 2
  dragLimitY[2] = dragLimitY[2] + (resInfo.oriPosition).y + extraLimitY
  dragLimitY[1] = dragLimitY[1] + (resInfo.oriPosition).y - extraLimitY
  return dragLimitX, dragLimitY
end

UIAdjEditor.__RecordCache = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self._cacheTable ~= nil then
    (table.removeall)(self._cacheTable)
  else
    self._cacheTable = {}
  end
  for index,heroId in ipairs(self._adjIndexDic) do
    local heroAdjInfo = (self._adjInfoDic)[heroId]
    ;
    (table.insert)(self._cacheTable, {dataId = heroId, skinId = heroAdjInfo.skinId, pos = heroAdjInfo.pos, size = heroAdjInfo.size, isL2d = (index == 1 and self._isL2dOpen), isHideBg = self:IsHideLive2dBg(heroAdjInfo.skinId)})
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIAdjEditor.ResetAdjCache = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local cacheData = self._cacheTable ~= nil and (self._cacheTable)[self._modifyIndex] or nil
  local heroid = (self._adjIndexDic)[self._modifyIndex]
  local nowHeroData = heroid ~= nil and (self._adjInfoDic)[heroid] or nil
  if cacheData == nil then
    if nowHeroData ~= nil then
      self:SetAdjEditHero(nowHeroData.dataId, false)
    end
    return 
  end
  if nowHeroData == nil then
    self:SetAdjEditHero(cacheData.dataId, true)
    self:SetAdjEditHeroSkin(cacheData.dataId, cacheData.skinId)
    if self._modifyIndex == 1 then
      self:SetAdjEditL2dTog(cacheData.isL2d)
      self:SetHideL2dBgTog(cacheData.dataId, cacheData.skinId, cacheData.isHideBg)
    end
    if cacheData.size ~= nil then
      self:SetAdjEditHeroScale(cacheData.size)
    end
    if cacheData.pos ~= nil then
      self:SetAdjEditHeroPosition((Vector2.New)((cacheData.pos)[1], (cacheData.pos)[2]))
    end
    return 
  end
  if nowHeroData.dataId ~= cacheData.dataId then
    self:SetAdjEditHero(cacheData.dataId, true)
    self:SetAdjEditHeroSkin(cacheData.dataId, cacheData.skinId)
  else
    if nowHeroData.skinId ~= cacheData.skinId then
      self:SetAdjEditHeroSkin(cacheData.dataId, cacheData.skinId)
    end
  end
  if self._modifyIndex == 1 then
    self:SetAdjEditL2dTog(cacheData.isL2d)
    self:SetHideL2dBgTog(cacheData.dataId, cacheData.skinId, cacheData.isHideBg)
  end
  self:SetAdjEditHeroScale(cacheData.dataId, cacheData.size)
  if cacheData.pos ~= nil then
    self:SetAdjEditHeroPosition(cacheData.dataId, (Vector2.New)((cacheData.pos)[1], (cacheData.pos)[2]))
  else
    self:SetAdjEditHeroPosition(cacheData.dataId, nil)
  end
end

UIAdjEditor.__ClearCache = function(self)
  -- function num : 0_31 , upvalues : _ENV
  if self._cacheTable ~= nil then
    (table.removeall)(self._cacheTable)
  end
end

UIAdjEditor.GetAdjEditBgId = function(self)
  -- function num : 0_32
  return self._bgId
end

UIAdjEditor.GetAdjEditAdjIndexDic = function(self)
  -- function num : 0_33
  return self._adjIndexDic
end

UIAdjEditor.GetAdjEditorAdjInfo = function(self, heroId)
  -- function num : 0_34
  return (self._adjInfoDic)[heroId]
end

UIAdjEditor.GetAdjMainHeroId = function(self)
  -- function num : 0_35
  return (self._adjIndexDic)[1]
end

UIAdjEditor.GetAdjMainSkinId = function(self)
  -- function num : 0_36
  local heroId = self:GetAdjMainHeroId()
  return ((self._adjInfoDic)[heroId]).skinId
end

UIAdjEditor.GetAdjCurCount = function(self)
  -- function num : 0_37 , upvalues : _ENV
  return (table.count)(self._adjInfoDic)
end

UIAdjEditor.IsAdjForbidL2d = function(self)
  -- function num : 0_38
  return self._forbidL2d
end

UIAdjEditor.GetAdjL2DOpen = function(self)
  -- function num : 0_39
  return self._isL2dOpen
end

UIAdjEditor.IsHideLive2dBg = function(self, skinId)
  -- function num : 0_40
  if self._hideLive2dBgTable == nil then
    return false
  end
  return (self._hideLive2dBgTable)[skinId]
end

UIAdjEditor.SetHideLive2dBg = function(self, skinId, isHide)
  -- function num : 0_41
  if self._hideLive2dBgTable == nil then
    self._hideLive2dBgTable = {}
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._hideLive2dBgTable)[skinId] = isHide
end

UIAdjEditor.GetAdjL2dLevel = function(self)
  -- function num : 0_42
  return self._l2dLevel
end

UIAdjEditor.GetAdjModifyIndex = function(self)
  -- function num : 0_43
  return self._modifyIndex
end

UIAdjEditor.IsAdjHeroIdInPreset = function(self, heroId)
  -- function num : 0_44
  do return (self._adjInfoDic)[heroId], (self._adjIndexDic)[self._modifyIndex] == heroId end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIAdjEditor.IsAdjCacheInModify = function(self)
  -- function num : 0_45
  do return self._cacheTable ~= nil and (self._cacheTable)[self._modifyIndex] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIAdjEditor.SaveAdjEdit = function(self)
  -- function num : 0_46 , upvalues : _ENV
  if (self._adjIndexDic)[1] == nil then
    return 
  end
  local data = {}
  data.id = self._adjTeamId
  data.name = self._teamName
  data.useL2D = self._isL2dOpen
  data.bgId = self._bgId
  for index = 1, self._limitCount do
    local heroId = (self._adjIndexDic)[index]
    if heroId ~= nil then
      local elem = {}
      local adjInfo = (self._adjInfoDic)[heroId]
      elem.heroId = heroId
      elem.skinId = adjInfo.skinId
      elem.posX = adjInfo.pos ~= nil and (math.floor)((adjInfo.pos)[1] * 1000) or 0
      elem.posY = adjInfo.pos ~= nil and (math.floor)((adjInfo.pos)[2] * 1000) or 0
      elem.heroSize = adjInfo.size ~= nil and (math.floor)(adjInfo.size * 1000) or 0
      local heroCfg = (ConfigData.hero_data)[heroId]
      if heroCfg ~= nil and elem.skinId == heroCfg.default_skin then
        elem.skinId = 0
      end
      if index == 1 then
        data.mainHero = elem
      else
        data.minorHero = elem
      end
    end
  end
  self:SaveLive2dHideBgValue()
  local network = NetworkManager:GetNetwork(NetworkTypeID.AdjCustom)
  network:CS_MainInterface_PresetUpdate(data, function()
    -- function num : 0_46_0 , upvalues : _ENV, self
    (UIUtil.PopFromBackStack)()
    self:__QuickUI()
  end
)
end

UIAdjEditor.SaveLive2dHideBgValue = function(self)
  -- function num : 0_47 , upvalues : _ENV
  if self._hideLive2dBgTable == nil then
    return 
  end
  for skinId,isHide in pairs(self._hideLive2dBgTable) do
    if (PlayerDataCenter.skinData):IsHideL2dBg(skinId) ~= isHide then
      local heroId = (PlayerDataCenter.skinData):GetHeroIdBySkinId(skinId)
      ;
      (PlayerDataCenter.skinData):UpdateHideL2dBg(heroId, skinId, isHide)
      local network = NetworkManager:GetNetwork(NetworkTypeID.Hero)
      network:CS_HERO_Skin_L2D_Hide(heroId, skinId, isHide, function()
    -- function num : 0_47_0
  end
)
    end
  end
end

UIAdjEditor.CancleAdjEdit = function(self, isToHome)
  -- function num : 0_48 , upvalues : CS_MessageCommon, _ENV
  if isToHome then
    self:__QuickUI()
    return 
  end
  ;
  (CS_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(406), function()
    -- function num : 0_48_0 , upvalues : self
    self:__QuickUI()
  end
, function()
    -- function num : 0_48_1 , upvalues : _ENV, self
    (UIUtil.SetTopStatus)(self, self.CancleAdjEdit)
    ;
    (UIUtil.AddClickHomeCheckFunc)(BindCallback(self, self.__CheckClickTopHome))
  end
)
end

UIAdjEditor.__CheckClickTopHome = function(self, returnCallback)
  -- function num : 0_49 , upvalues : CS_MessageCommon, _ENV
  (CS_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(406), function()
    -- function num : 0_49_0 , upvalues : returnCallback
    returnCallback()
  end
, nil)
end

UIAdjEditor.__QuickUI = function(self)
  -- function num : 0_50 , upvalues : _ENV
  self:Delete()
  local homeUI = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeUI ~= nil then
    homeUI:BackFromOtherWinWithMainCamera()
  end
  local homeCtrl = ControllerManager:GetController(ControllerTypeId.HomeController)
  if homeCtrl ~= nil then
    homeCtrl:ClearRecordMainBg()
  end
  if self._closeFunc ~= nil then
    (self._closeFunc)()
  end
end

UIAdjEditor.OnDelete = function(self)
  -- function num : 0_51 , upvalues : base, _ENV
  if (self._adjOperation).active then
    self:__RegisterLeanTouch(false)
  end
  ;
  (base.OnDelete)(self)
  for k,data in pairs(self._UIStateUpdateFuncDic) do
    (data.node):Delete()
  end
  if self._resLoadDic ~= nil then
    for _,resInfo in pairs(self._resLoadDic) do
      if not IsNull(resInfo.obj) then
        DestroyUnityObject(resInfo.obj)
      end
      ;
      (resInfo.resloader):Put2Pool()
      resInfo.l2dBinding = nil
      resInfo.cs_CubismInterationController = nil
      resInfo.commonPicCom = nil
    end
    self._resLoadDic = nil
  end
end

return UIAdjEditor

