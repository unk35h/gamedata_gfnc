-- params : ...
-- function num : 0 , upvalues : _ENV
local SmashingPenguinsCtrlBase = require("Game.TinyGames.SmashingPenguins.Ctrl.SmashingPenguinsCtrlBase")
local SmashingPenguinsCamCtrl = class("SmashingPenguinsCamCtrl", SmashingPenguinsCtrlBase)
local SmashingPenguinsConfig = require("Game.TinyGames.SmashingPenguins.Config.SmashingPenguinsConfig")
SmashingPenguinsCamCtrl.OnGamePrepare = function(self)
  -- function num : 0_0 , upvalues : _ENV, SmashingPenguinsConfig
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    return 
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((mainUI.mainGameItems).transform).localPosition = Vector3.zero
  self.prefTargetPosX = nil
  self.fakeCamPosX = 0
  local halfScreen = self:GetScreentWidth() * 0.5
  self.fakeCamDeadPosX = -halfScreen + SmashingPenguinsConfig.MaxXPos
end

SmashingPenguinsCamCtrl.FollowTargetPos = function(self, targetEntity)
  -- function num : 0_1 , upvalues : _ENV, SmashingPenguinsConfig
  local mainUI = UIManager:GetWindow(UIWindowTypeID.SmashingPenguins)
  if IsNull(mainUI) then
    return 
  end
  local targetWorldPos = (targetEntity.transform).position
  targetWorldPos.x = targetWorldPos.x + SmashingPenguinsConfig.DeltaCamFloowXPos
  if self.limitPos ~= nil and self.startSetLimitPos ~= nil then
    if ((self.limitPos).x - (self.startSetLimitPos).x) * ((self.limitPos).x - targetWorldPos.x) > 0 then
      return 
    else
      self.limitPos = nil
      self.startSetLimitPos = nil
    end
  end
  local targetPos = ((mainUI.mainGameItems).transform):InverseTransformPoint(targetWorldPos)
  local targetPosX = targetPos.x
  if self.prefTargetPosX ~= nil and (math.abs)(self.prefTargetPosX - targetPosX) < 0.1 then
    return 
  end
  local halfScreen = self:GetScreentWidth() * 0.5
  local deltaCamX = targetPosX - self.fakeCamPosX
  if self.fakeCamDeadPosX < self.fakeCamPosX + deltaCamX then
    deltaCamX = self.fakeCamDeadPosX - self.fakeCamPosX
  end
  self:MoveFakeCam(deltaCamX, mainUI)
  self.prefTargetPosX = targetPosX
end

SmashingPenguinsCamCtrl.SetFollowLimit = function(self, limitPos, startSetLimitPos)
  -- function num : 0_2 , upvalues : SmashingPenguinsConfig
  limitPos.x = limitPos.x + SmashingPenguinsConfig.DeltaCamFloowXPos
  self.limitPos = limitPos
  startSetLimitPos.x = startSetLimitPos.x + SmashingPenguinsConfig.DeltaCamFloowXPos
  self.startSetLimitPos = startSetLimitPos
end

SmashingPenguinsCamCtrl.MoveFakeCam = function(self, deltaCamX, mainUI)
  -- function num : 0_3
  local localItemsPosition = ((mainUI.mainGameItems).transform).localPosition
  localItemsPosition.x = localItemsPosition.x - deltaCamX
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((mainUI.mainGameItems).transform).localPosition = localItemsPosition
  self.fakeCamPosX = self.fakeCamPosX + deltaCamX
end

SmashingPenguinsCamCtrl.GetScreentWidth = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local width = ((UIManager.csUIManager).BackgroundStretchSize).x
  return width
end

return SmashingPenguinsCamCtrl

