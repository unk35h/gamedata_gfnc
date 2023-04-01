-- params : ...
-- function num : 0 , upvalues : _ENV
local WCI_Base = class("WCI_Base")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WCI_Base.ctor = function(self, wcCtrl, interactCtrl)
  -- function num : 0_0
  self.wcCtrl = wcCtrl
  self.interactCtrl = interactCtrl
  local InteractCfg = interactCtrl:GetCurInteractCfg()
  self.InteractCfg = InteractCfg
  self.interactCat = InteractCfg.cat
  self.pms = InteractCfg.pms
  self.needWalk = nil
  self.needWalk2Grid = nil
  self.isWalk2NearBy = false
  self.isNotAutoWalk = false
  self.preparePmsCallback = nil
  self.onCSSuccessCallback = nil
end

WCI_Base.IsWCActCouldRun = function(self)
  -- function num : 0_1 , upvalues : WarChessHelper, _ENV
  if self.needWalk then
    local teamData = (self.interactCtrl):GetCurTeam()
    local teamPos = (self.interactCtrl):GetTeamPos()
    local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamPos)
    local pointPos = ((self.interactCtrl):GetInteractPos())
    local endGird = nil
    local isOK, passGridList = false, nil
    self.needWalk2Grid = nil
    if not self.isWalk2NearBy then
      endGird = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, pointPos)
      if endGird ~= nil then
        isOK = (WarChessHelper.AStrarPathFind)((self.wcCtrl).mapCtrl, startGrid, endGird, false, teamData)
      end
      if isOK then
        self.needWalk2Grid = endGird
      else
        ;
        (self.interactCtrl):OnInteractOver(false)
        return 
      end
    else
      local costNum = math.maxinteger
      for _,way in pairs(WarChessHelper.AStarSearchOrder) do
        local gridPos = pointPos + way
        endGird = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, gridPos)
        if teamPos == gridPos then
          costNum = 0
          self.needWalk2Grid = endGird
          break
        end
        -- DECOMPILER ERROR at PC92: Overwrote pending register: R7 in 'AssignReg'

        if endGird ~= nil and endGird:GetCouldStand() and self:__IsThisGridCouldStandInInterAct(endGird) then
          isOK = (WarChessHelper.AStrarPathFind)((self.wcCtrl).mapCtrl, startGrid, endGird, false, teamData)
        end
        if isOK and #passGridList < costNum then
          costNum = #passGridList
          self.needWalk2Grid = endGird
        end
      end
      do
        do
          do
            if self.needWalk2Grid ~= nil then
              isOK = true
            else
              ;
              (self.interactCtrl):OnInteractOver(false)
              return 
            end
            if isOK then
              self:WCActConfirm()
              return true
            end
            self:WCActConfirm()
            do return true end
          end
        end
      end
    end
  end
end

WCI_Base.__IsThisGridCouldStandInInterAct = function(self, gridData)
  -- function num : 0_2
  return true
end

WCI_Base.WCActConfirm = function(self)
  -- function num : 0_3
  self:WCActWalkTo()
end

WCI_Base.WCActWalkTo = function(self)
  -- function num : 0_4
  local ReachPointOver = function()
    -- function num : 0_4_0 , upvalues : self
    if (self.wcCtrl):IsWCInSubSystem() then
      self:WCActOver(false)
      return 
    end
    self:WCActPlay()
  end

  if self.needWalk and self.needWalk2Grid ~= nil then
    if (self.needWalk2Grid):GetGridLogicPos() == (self.interactCtrl):GetTeamPos() and self.isWalk2NearBy then
      local pointPos = (self.interactCtrl):GetInteractPos()
      local targetGird = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, pointPos)
      ;
      ((self.wcCtrl).curState):Turn2Grid(targetGird, ReachPointOver)
      return 
    end
    do
      ;
      ((self.wcCtrl).curState):Walk2Grid(self.needWalk2Grid, ReachPointOver)
      do return  end
      ReachPointOver()
    end
  end
end

WCI_Base.WCActPlay = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local teamData = (self.interactCtrl):GetCurTeam()
  local wid, tid = ((self.wcCtrl).teamCtrl):GetWCTeamIdentify(teamData)
  local wcPos = (self.interactCtrl):GetWCPos()
  local entityCat = (self.interactCtrl):GetWCEntityCat()
  local id = (self.interactCtrl):GetCurInteractId()
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Interact(wid, tid, wcPos, entityCat, id, function(argList)
    -- function num : 0_5_0 , upvalues : _ENV, self
    if argList.Count ~= 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    self:WCActOver(isSucess)
  end
)
end

WCI_Base.PlayWCActOverAudio = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local successAudio = (self.interactCtrl):GetWcInteraSuccessAudio()
  if successAudio > 0 then
    AudioManager:PlayAudioById(successAudio)
    return 
  end
  AudioManager:PlayAudioById(1234)
end

WCI_Base.WCActOver = function(self, isSucess)
  -- function num : 0_7
  (self.interactCtrl):OnInteractOver(isSucess)
  if isSucess then
    self:PlayWCActOverAudio()
  end
end

WCI_Base.WCIsTeamOnPoint = function(self)
  -- function num : 0_8
  local teamPos = (self.interactCtrl):GetTeamPos()
  local pointPos = (self.interactCtrl):GetInteractPos()
  do return teamPos == pointPos end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WCI_Base.WCIsTeamNearPoint = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local teamPos = (self.interactCtrl):GetTeamPos()
  local pointPos = (self.interactCtrl):GetInteractPos()
  local dis = (Vector2.Distance)(teamPos, pointPos)
  do return dis <= 1.1 and dis > 0.1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return WCI_Base

