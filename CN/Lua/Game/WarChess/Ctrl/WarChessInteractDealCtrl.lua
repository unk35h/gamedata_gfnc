-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.Base.WarChessCtrlBase")
local WarChessInteractDealCtrl = class("WarChessInteractDealCtrl", base)
local WCInteractClassDic = require("Game.WarChess.Interact.Base.WCInteractClassDic")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local WarChessConditionCheck = require("Game.WarChess.ConditionCheck.WarChessConditionCheck")
WarChessInteractDealCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__interactOverCallback = nil
  self.__curInteractCfg = nil
  self.__curInteractIndex = nil
  self.__curAct = nil
  self.__curTeam = nil
  self.__isGrid = true
  self.__targetGridData = nil
  self.__targetEntityData = nil
  self.__isNotReturnYet = false
  self.__hasColoseInteract = true
  self.__isSucess = nil
end

WarChessInteractDealCtrl.WCDealGridInteract = function(self, gridData, teamData, interactCfg, interactOverCallback)
  -- function num : 0_1 , upvalues : WarChessConditionCheck, WCInteractClassDic
  self.__interactOverCallback = interactOverCallback
  local interactCfg = interactCfg
  if interactCfg == nil then
    self:OnInteractOver(false)
    return false
  end
  if not (WarChessConditionCheck.CheckGridConditionTree)(gridData:GetGridUnit(), interactCfg) then
    self:OnInteractOver(false)
    return false
  end
  local actClass = WCInteractClassDic[interactCfg.cat]
  if actClass == nil then
    self:OnInteractOver(false)
    return false
  end
  self.__isGrid = true
  self.__targetGridData = gridData
  self.__curTeam = teamData
  self.__curInteractCfg = interactCfg
  self.__curInteractIndex = interactCfg.id
  self.__curAct = (actClass.New)(self.wcCtrl, self)
  return (self.__curAct):IsWCActCouldRun()
end

WarChessInteractDealCtrl.WCDealEntityInteract = function(self, entityData, teamData, interactCfg, interactOverCallback)
  -- function num : 0_2 , upvalues : WarChessConditionCheck, WCInteractClassDic
  self.__interactOverCallback = interactOverCallback
  local interactCfg = interactCfg
  if interactCfg == nil then
    self:OnInteractOver(false)
    return false
  end
  if not (WarChessConditionCheck.CheckGridConditionTree)(entityData:GetEntityUnit(), interactCfg) then
    self:OnInteractOver(false)
    return false
  end
  local actClass = WCInteractClassDic[interactCfg.cat]
  if actClass == nil then
    self:OnInteractOver(false)
    return false
  end
  self.__isGrid = false
  self.__targetEntityData = entityData
  self.__curTeam = teamData
  self.__curInteractCfg = interactCfg
  self.__curInteractIndex = interactCfg.id
  self.__curAct = (actClass.New)(self.wcCtrl, self)
  self.__isNotReturnYet = true
  self.__hasColoseInteract = false
  self.__isSucess = nil
  local isOK = (self.__curAct):IsWCActCouldRun()
  self.__isNotReturnYet = false
  if self.__hasColoseInteract then
    return self.__isSucess
  end
  return isOK
end

WarChessInteractDealCtrl.OnInteractOver = function(self, isSucess)
  -- function num : 0_3
  local interactOverCallback = self.__interactOverCallback
  self.__interactOverCallback = nil
  self.__curInteractCfg = nil
  self.__curAct = nil
  self.__curTeam = nil
  if self.__isNotReturnYet then
    self.__isSucess = isSucess
    self.__hasColoseInteract = true
  end
  if interactOverCallback ~= nil then
    interactOverCallback(isSucess)
  end
end

WarChessInteractDealCtrl.GetCurInteractId = function(self)
  -- function num : 0_4
  return self.__curInteractIndex
end

WarChessInteractDealCtrl.GetCurInteractCfg = function(self)
  -- function num : 0_5
  return self.__curInteractCfg
end

WarChessInteractDealCtrl.GetCurTeam = function(self)
  -- function num : 0_6
  return self.__curTeam
end

WarChessInteractDealCtrl.GetTeamPos = function(self)
  -- function num : 0_7
  return (self:GetCurTeam()):GetWCTeamLogicPos()
end

WarChessInteractDealCtrl.GetInteractPos = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.__isGrid then
    return (self.__targetGridData):GetGridLogicPos()
  else
    return (self.__targetEntityData):GetEntityLogicPos()
  end
  error("can\'t get Interact point Pos")
end

WarChessInteractDealCtrl.GetInteractBFId = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.__isGrid then
    return (self.__targetGridData):GetWCGridBFId()
  else
    return (self.__targetEntityData):GetWCEntityBFId()
  end
  error("can\'t get Interact BFId")
end

WarChessInteractDealCtrl.GetWCPos = function(self)
  -- function num : 0_10 , upvalues : WarChessHelper
  local BFId = self:GetInteractBFId()
  local pointPos = self:GetInteractPos()
  return {gid = BFId, pos = (WarChessHelper.Pos2Coordination)(pointPos)}
end

WarChessInteractDealCtrl.GetWCEntityCat = function(self)
  -- function num : 0_11
  if not ((self.__targetGridData):GetGridUnit()).entityCat then
    do return not self.__isGrid or 1 end
    do return ((self.__targetEntityData):GetEntityUnit()).entityCat or 2 end
  end
end

WarChessInteractDealCtrl.GetWCIneractionAPCost = function(self, interactCfg)
  -- function num : 0_12 , upvalues : _ENV
  local costNum = 0
  for key,trigger in pairs(interactCfg.triggers) do
    if trigger.cat == 5 and (trigger.pms)[2] == 1 then
      costNum = costNum + (trigger.pms)[3]
    end
  end
  return costNum
end

WarChessInteractDealCtrl.GetCurInteractPMS = function(self)
  -- function num : 0_13
  return (self.__curInteractCfg).pms
end

WarChessInteractDealCtrl.GetCurInteractRange = function(self)
  -- function num : 0_14
  if self.__isGrid then
    return (self.__targetGridData):GetGridInteractionRange()
  else
    return (self.__targetEntityData):GetEntityInteractionRange()
  end
end

WarChessInteractDealCtrl.GetCurIsGrid = function(self)
  -- function num : 0_15
  return self.__isGrid
end

WarChessInteractDealCtrl.GetCurInteractData = function(self)
  -- function num : 0_16
  if self.__isGrid then
    return self.__targetGridData
  else
    return self.__targetEntityData
  end
end

WarChessInteractDealCtrl.GetCurInteractPos = function(self)
  -- function num : 0_17
  if self.__isGrid then
    return (self.__targetGridData):GetGridShowPos()
  else
    return (self.__targetEntityData).pos
  end
end

WarChessInteractDealCtrl.GetWcInteraSuccessAudio = function(self)
  -- function num : 0_18
  -- DECOMPILER ERROR at PC9: Unhandled construct in 'MakeBoolean' P1

  if self.__isGrid and self.__targetGridData ~= nil then
    return (self.__targetGridData):GetWcGridSuccessAudio()
  end
  if self.__targetEntityData ~= nil then
    return (self.__targetEntityData):GetWcEntitySuccessAudio()
  end
  return 0
end

WarChessInteractDealCtrl.Delete = function(self)
  -- function num : 0_19
end

return WarChessInteractDealCtrl

