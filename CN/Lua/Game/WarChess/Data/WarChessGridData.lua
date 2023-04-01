-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessGridData = class("WarChessGridData")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eWCInteractType = require("Game.WarChess.Interact.Base.eWCInteractType")
local WarChessConditionCheck = require("Game.WarChess.ConditionCheck.WarChessConditionCheck")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
WarChessGridData.ctor = function(self, BFId, worldLogicPos, gridCfg, areaCoordination)
  -- function num : 0_0 , upvalues : _ENV
  self.gridCfg = gridCfg
  self.BFId = BFId
  self.worldLogicPos = worldLogicPos
  self.pos = (Vector3.New)(worldLogicPos.x, 0, worldLogicPos.y)
  self.areaCoordination = areaCoordination
  self.isInFog = true
  self.isBornPoint = false
  self.__isStandTeam = false
  self.__FXDataDic = {}
  self.searchValue = nil
  self.parentGrid = nil
  self.isHaveDTeamData = nil
  self:GenIsBornPoint()
  local gridResCfg = (ConfigData.warchess_grid_res)[gridCfg.resId]
  if gridResCfg == nil then
    error((string.format)("Cant get warchess_grid_res, id = %s", gridCfg.resId))
    return 
  end
  self._gridResCfg = gridResCfg
end

WarChessGridData.GetWCGridBFId = function(self)
  -- function num : 0_1
  return self.BFId
end

WarChessGridData.GetIsBornPoint = function(self)
  -- function num : 0_2
  return self.isBornPoint
end

WarChessGridData.GetGridLogicPos = function(self)
  -- function num : 0_3
  return self.worldLogicPos
end

WarChessGridData.GetGridShowPos = function(self)
  -- function num : 0_4
  return self.pos
end

WarChessGridData.SetWCGridUnitCfg = function(self, unit)
  -- function num : 0_5
  self.gridCfg = unit
  self:GenIsBornPoint()
end

WarChessGridData.SetWCGridIsInFog = function(self, bool)
  -- function num : 0_6
  self.isInFog = bool
end

WarChessGridData.SetWCGridIsStandTeam = function(self, bool)
  -- function num : 0_7
  self.__isStandTeam = bool
end

WarChessGridData.GetWCGridIsInFog = function(self)
  -- function num : 0_8
  return self.isInFog
end

WarChessGridData.IsWCUnitMonster = function(self)
  -- function num : 0_9
  return false
end

WarChessGridData.GetCouldStand = function(self)
  -- function num : 0_10
  do return ((self.gridCfg).moveFlag == 0 and not self.__isStandTeam and not self:GetWCGridIsInFog()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

WarChessGridData.GetCouldPass = function(self, isMonster)
  -- function num : 0_11
  do return isMonster and (((self.gridCfg).moveFlag == 0 and not self.__isStandTeam and not self:GetWCGridIsInFog())) end
  do return ((self.gridCfg).moveFlag == 0 and not self:GetWCGridIsInFog()) end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

WarChessGridData.GetCouldPatrol = function(self)
  -- function num : 0_12
  do return ((self.gridCfg).moveFlag == 0 and not self:GetWCGridIsInFog()) end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

WarChessGridData.GetGridUnit = function(self)
  -- function num : 0_13
  return self.gridCfg
end

WarChessGridData.GetGridInteractions = function(self)
  -- function num : 0_14
  return (self.gridCfg).interactions
end

WarChessGridData.GetGridInteractionRange = function(self)
  -- function num : 0_15
  return (self.gridCfg).opRange
end

WarChessGridData.SaveGridAnimArg = function(self, nameHash, animaId)
  -- function num : 0_16
  self.__saveAnimData = {nameHash = nameHash, animaId = animaId}
end

WarChessGridData.GetGridAnimArg = function(self)
  -- function num : 0_17
  return self.__saveAnimData
end

WarChessGridData.GetFirstGridInertactWithCat = function(self, specificCat)
  -- function num : 0_18 , upvalues : _ENV
  for _,interactCfg in pairs((self.gridCfg).interactions) do
    if interactCfg.cat == specificCat then
      return interactCfg
    end
  end
  return nil
end

WarChessGridData.GetGridCouldInteract = function(self)
  -- function num : 0_19 , upvalues : _ENV, WarChessConditionCheck
  if #self:GetGridInteractions() < 1 then
    return false
  end
  local isHaveCouldUseOne = false
  for _,interaction in pairs(self:GetGridInteractions()) do
    if (WarChessConditionCheck.CheckGridConditionTree)(self:GetGridUnit(), interaction) then
      isHaveCouldUseOne = true
      break
    end
  end
  do
    return isHaveCouldUseOne
  end
end

WarChessGridData.GetCouldInteract = function(self, specificCat)
  -- function num : 0_20 , upvalues : WarChessConditionCheck
  local interactCfg = self:GetFirstGridInertactWithCat(specificCat)
  if interactCfg == nil then
    return false
  end
  return (WarChessConditionCheck.CheckGridConditionTree)(self:GetGridUnit(), interactCfg)
end

WarChessGridData.GetGridUseItemConsume = function(self, specificCat, itemId)
  -- function num : 0_21 , upvalues : _ENV
  local interactCfg = self:GetFirstGridInertactWithCat(specificCat)
  local costNum = 0
  for key,trigger in pairs(interactCfg.triggers) do
    if trigger.cat == 16 and (trigger.pms)[1] == 1 and (trigger.pms)[2] == itemId then
      costNum = costNum + (trigger.pms)[3]
    end
  end
  return costNum
end

WarChessGridData.GetWcGridAreaCoordination = function(self)
  -- function num : 0_22
  return self.areaCoordination
end

WarChessGridData.GetCouldShowBornFX = function(self)
  -- function num : 0_23
  if self:GetIsBornPoint() then
    return not self.isHaveDTeamData
  end
end

WarChessGridData.GenIsBornPoint = function(self)
  -- function num : 0_24 , upvalues : _ENV, eWCInteractType
  local isBornPoint = false
  for index,interactCfg in pairs((self.gridCfg).interactions) do
    isBornPoint = (self.gridCfg).pms ~= nil and (not ((self.gridCfg).pms)[1] and interactCfg.cat ~= eWCInteractType.born or 0 > 0)
  end
  self.isBornPoint = isBornPoint
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

WarChessGridData.GetInteractShowOffset = function(self)
  -- function num : 0_25
  return (self._gridResCfg).height
end

WarChessGridData.GetFxDataDic = function(self)
  -- function num : 0_26
  return self.__FXDataDic
end

WarChessGridData.GetWCUnitInterActIcon = function(self)
  -- function num : 0_27 , upvalues : _ENV
  local iconId = (self._gridResCfg).icon
  local iconCfg = (ConfigData.warchess_Interact_icon)[iconId]
  if iconCfg == nil then
    return nil
  end
  return iconCfg.icon_name
end

WarChessGridData.GetWcGridSuccessAudio = function(self)
  -- function num : 0_28
  return (self._gridResCfg).successAudio
end

WarChessGridData.GetWcGridAniAudioDic = function(self)
  -- function num : 0_29
  return (self._gridResCfg).aniAudioDic
end

WarChessGridData.GetWCGridRotate = function(self, isNum)
  -- function num : 0_30 , upvalues : _ENV, WarChessHelper
  if self.gridCfg == nil then
    return 
  end
  local gridCatCfg = (ConfigData.warchess_grid_cat)[(self.gridCfg).cat]
  if gridCatCfg ~= nil and gridCatCfg.rotate then
    local p = ((self.gridCfg).pms)[gridCatCfg.rotate_index + 1]
    if p == nil then
      return 
    end
    if isNum then
      return p
    end
    local rotate = (WarChessHelper.rotateValue)[p]
    return rotate
  end
end

WarChessGridData.GetFxCount = function(self)
  -- function num : 0_31
  return nil
end

return WarChessGridData

