-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23Interactive = class("UISpring23Interactive", UIBaseWindow)
local base = UIBaseWindow
local UINInteractiveItem = require("Game.ActivitySpring.UI.Interactive.UINSpring23InteractiveItem")
local ActivitySpringStoryEnum = require("Game.ActivitySpring.Data.ActivitySpringStoryEnum")
local ActLbUtil = require("Game.ActivityLobby.ActLbUtil")
UISpring23Interactive.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINInteractiveItem
  self.interactiveItemPool = (UIItemPool.New)(UINInteractiveItem, (self.ui).root)
  ;
  ((self.ui).root):SetActive(false)
end

UISpring23Interactive.InitSpring23Interactive = function(self, springData, entityDic)
  -- function num : 0_1
  self._springData = springData
  self._springStoryData = (self._springData):GetSpringStoryData()
  self._entityDic = entityDic
  self._enttInfoDic = {}
  self._entityHalfSize = (((self.ui).root).transform).sizeDelta / 2
  ;
  (self.interactiveItemPool):HideAll()
  self:UpdateInteractive()
end

UISpring23Interactive.UpdateInteractive = function(self)
  -- function num : 0_2 , upvalues : _ENV, ActLbUtil, ActivitySpringStoryEnum
  local halfScreenX = (UIManager.BackgroundStretchSize).x / 2
  local halfScreenY = (UIManager.BackgroundStretchSize).y / 2
  local camPos = ((UIManager:GetMainCamera()).transform).position
  local uiScaleMin, uiScaleMax, camDisMin, camDisMax = (ActLbUtil.GetActLbFlowUIScaleParam)()
  local actLbCtrl = ControllerManager:GetController(ControllerTypeId.ActivityLobbyCtrl)
  for i,entity in pairs(self._entityDic) do
    local intrctData = entity:GetLbIntrctEntData()
    local heroId = intrctData:GetLbIntrctObjHeroId()
    local targetTransform = entity:GetLbIntrctEntiUIPintTransform()
    local posX, posY, back = UIManager:World2UIPositionOut(targetTransform)
    posY = posY + (actLbCtrl.actLbCamCtrl):GetAcbLbFollowUIPosOffset() * 0.5
    local infoItem = (self._enttInfoDic)[entity]
    local interactCfg, cantTalk = (self._springStoryData):GetNowCfgByHeroId(heroId)
    local costNum = (self._springData):GetInteractCostNum()
    local xOutLeftScreen = posX + (self._entityHalfSize).x * uiScaleMin < -halfScreenX
    local xOutRightScreen = halfScreenX < posX - (self._entityHalfSize).x * uiScaleMin
    local yOutDownScreen = posY + (self._entityHalfSize).y * uiScaleMin >= -halfScreenY and back
    local yOutUpScreen = halfScreenY < posY - (self._entityHalfSize).y * uiScaleMin
    local outScreen = xOutLeftScreen or xOutRightScreen or yOutUpScreen or yOutDownScreen
    local closeAni = false
    -- DECOMPILER ERROR at PC109: Unhandled construct in 'MakeBoolean' P1

    if outScreen and (cantTalk or costNum < interactCfg.need_exp or interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).ranReward) and infoItem then
      (self.interactiveItemPool):HideOne(infoItem)
      -- DECOMPILER ERROR at PC111: Confused about usage of register: R30 in 'UnsetPending'

      ;
      (self._enttInfoDic)[entity] = nil
    end
    if infoItem then
      infoItem:CloseAllAni()
      closeAni = true
    else
      closeAni = true
    end
    if infoItem == nil then
      infoItem = (self.interactiveItemPool):GetOne()
      -- DECOMPILER ERROR at PC128: Confused about usage of register: R30 in 'UnsetPending'

      ;
      (self._enttInfoDic)[entity] = infoItem
    end
    if interactCfg == nil or interactCfg.stage_id == (ActivitySpringStoryEnum.stageEnum).ranReward or cantTalk then
      (infoItem.gameObject):SetActive(false)
    else
      if not cantTalk then
        (infoItem.gameObject):SetActive(true)
        infoItem:SetSpring23InteractiveItemEntt(entity)
        infoItem:RefreshSpring23InteractiveItem(interactCfg, costNum, closeAni)
      end
      local distance = (Vector3.Distance)(camPos, targetTransform.position)
      if not outScreen or not 1 then
        local size = (Mathf.Lerp)(uiScaleMax, uiScaleMin, (distance - camDisMin) / (camDisMax - camDisMin))
      end
      local arrowScale = 1.5
      if xOutLeftScreen then
        posX = -halfScreenX + (self._entityHalfSize).x * size * arrowScale
      elseif xOutRightScreen then
        posX = halfScreenX - (self._entityHalfSize).x * size * arrowScale
      end
      if yOutDownScreen then
        posY = -halfScreenY + (self._entityHalfSize).y * size * arrowScale
      elseif yOutUpScreen then
        posY = halfScreenY - (self._entityHalfSize).y * size * arrowScale
      end
      local arrowDir = (Vector3.Temp)(posX, posY, 0)
      if outScreen and not cantTalk and interactCfg.need_exp <= costNum then
        infoItem:SetArrowOpen(arrowDir)
      else
        infoItem:SetArrowClose()
      end
      -- DECOMPILER ERROR at PC233: Confused about usage of register: R34 in 'UnsetPending'

      ;
      (infoItem.transform).anchoredPosition = (Vector2.Temp)(posX, posY)
      -- DECOMPILER ERROR at PC238: Confused about usage of register: R34 in 'UnsetPending'

      ;
      (infoItem.transform).localScale = Vector3.one * size
    end
  end
  -- DECOMPILER ERROR: 23 unprocessed JMP targets
end

UISpring23Interactive.RefreshEntityState = function(self, entity)
  -- function num : 0_3
  local infoItem = (self._enttInfoDic)[entity]
  local intrctData = entity:GetLbIntrctEntData()
  local heroId = intrctData:GetLbIntrctObjHeroId()
  local interactCfg, cantTalk = (self._springStoryData):GetNowCfgByHeroId(heroId)
  if interactCfg == nil then
    return 
  end
  if infoItem == nil then
    infoItem = (self.interactiveItemPool):GetOne()
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

    ;
    (self._enttInfoDic)[entity] = infoItem
  end
  if not cantTalk then
    (infoItem.gameObject):SetActive(true)
    infoItem:RefreshSpring23InteractiveItem(interactCfg, (self._springData):GetInteractCostNum())
  else
    ;
    (infoItem.gameObject):SetActive(false)
  end
end

UISpring23Interactive.OnCloseSpring23Interactive = function(self)
  -- function num : 0_4
  self:Delete()
end

return UISpring23Interactive

