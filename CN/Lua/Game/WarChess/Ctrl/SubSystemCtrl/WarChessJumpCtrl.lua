-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessJumpCtrl = class("WarChessJumpCtrl", base)
local CS_Resloader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local UIWarChessJumpSystem = require("Game.WarChess.UI3D.JumpSystem.UIWarChessJumpSystem")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
WarChessJumpCtrl.eJumpType = {fourWayJump = 1, chess = 2}
WarChessJumpCtrl.jumpDiffTable = {
[(WarChessJumpCtrl.eJumpType).fourWayJump] = {enterFunc = function(jumpCtrl)
  -- function num : 0_0 , upvalues : _ENV, UIWarChessJumpSystem
  local parent = ((jumpCtrl.wcCtrl).bind).trans_3DUIRoot
  ;
  (jumpCtrl.resloader):LoadABAssetAsync(PathConsts:GetUIPrefabPath("UI_WarChessJumpSystem"), function(prefab)
    -- function num : 0_0_0 , upvalues : parent, jumpCtrl, UIWarChessJumpSystem
    local obj = prefab:Instantiate(parent)
    obj.name = "UI_WarChessJumpSystem"
    jumpCtrl.__jump3DUINode = (UIWarChessJumpSystem.New)()
    ;
    (jumpCtrl.__jump3DUINode):Init(obj)
    ;
    (jumpCtrl.__jump3DUINode):InitWCJumpSystem(jumpCtrl)
  end
)
end
, jumpInFx = "FXP_blink-in", jumpOutFx = "FXP_blink-go", groundFx = "FXP_blinkloop"}
, 
[(WarChessJumpCtrl.eJumpType).chess] = {enterFunc = function(jumpCtrl)
  -- function num : 0_1
  ((jumpCtrl.wcCtrl).curState):SetWCCustomInput(true, jumpCtrl.__jumpSystemCustomClick)
end
, jumpInFx = "FXP_zq_blink", jumpOutFx = nil, groundFx = "FXP_blinkloop", battleInstaKillFx = "FXP_bisha_GroundEffcte-monster", 
headIconIds = {[proto_object_BuffChessType.BuffChessPawn] = 1, [proto_object_BuffChessType.BuffChessKnight] = 2, [proto_object_BuffChessType.BuffChessBishop] = 3, [proto_object_BuffChessType.BuffChessRook] = 4, [proto_object_BuffChessType.BuffChessQueen] = 5}
}
}
WarChessJumpCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_2 , upvalues : CS_Resloader, _ENV
  self.resloader = (CS_Resloader.Create)()
  self.__jumpSystemData = nil
  self.__identify = nil
  self.__curTeamData = nil
  self.__jumpType = nil
  self.__isWaitingMove = false
  self.__isWaitingMoveOverCallback = nil
  self.__jumpTable = nil
  self.__isEarlyJump = false
  self.__jump3DUINode = nil
  self.__fxList = nil
  self.__jumpSystemCustomClick = BindCallback(self, self.__JumpSystemCustomClick)
end

WarChessJumpCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).jump
end

WarChessJumpCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_4 , upvalues : _ENV, WarChessJumpCtrl
  if systemState == nil or systemState.jumpSystemData == nil then
    error("not have data")
    return 
  end
  self.__jumpSystemData = systemState.jumpSystemData
  self.__identify = identify
  self.__curTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid(identify.tid)
  if (self.__jumpSystemData).jumpSystemState == proto_object_JumpSystemStateType.JumpSystemBattleMoving then
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_JumpSystemData_Move(self.__identify, self.__isWaitingMoveOverCallback)
    self.__isWaitingMove = false
    self.__isWaitingMoveOverCallback = nil
    self.__isEarlyJump = false
    return 
  end
  if (self.__curTeamData):GetTeamNumeric(proto_object_WarChessNumeric.WarChessBuffCatAddChessMovePoint) ~= nil then
    self.__jumpType = (WarChessJumpCtrl.eJumpType).chess
  else
    self.__jumpType = (WarChessJumpCtrl.eJumpType).fourWayJump
  end
  local jumpTable = (WarChessJumpCtrl.jumpDiffTable)[self.__jumpType]
  if jumpTable == nil then
    error("jump type not exist:" .. tostring(self.__jumpType))
    return 
  end
  self.__jumpTable = jumpTable
  local jumpStartFunc = (self.__jumpTable).enterFunc
  if jumpStartFunc ~= nil then
    jumpStartFunc(self)
  end
  ;
  ((self.wcCtrl).curState):WCHideInteract()
  self:__ShowJumpTargetFx()
end

WarChessJumpCtrl.__ShowJumpTargetFx = function(self)
  -- function num : 0_5 , upvalues : _ENV, WarChessHelper
  ((self.wcCtrl).curState):WCPlayDeselectTeam()
  self.__fxList = {}
  local showedPos = {}
  for _,jumpElem in pairs((self.__jumpSystemData).jumpPos) do
    local dir = jumpElem.dir
    for _,WCPos in pairs(jumpElem.pos) do
      if showedPos[WCPos.pos] == nil then
        showedPos[WCPos.pos] = true
        local x, y = (WarChessHelper.Coordination2Pos)(WCPos.pos)
        local showPos = (Vector3.Temp)(x, 0, y)
        local moveableFX = ((self.wcCtrl).animaCtrl):ShowWCEffect((self.__jumpTable).groundFx or "FXP_blinkloop", showPos)
        ;
        (table.insert)(self.__fxList, moveableFX)
      end
    end
  end
end

WarChessJumpCtrl.__HideJumpTargetFx = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for _,moveableFX in pairs(self.__fxList) do
    ;
    ((self.wcCtrl).animaCtrl):RecycleWCEffect((self.__jumpTable).groundFx or "FXP_blinkloop", moveableFX)
  end
  ;
  ((self.wcCtrl).curState):WCPlayStateSelectTeam(self.__curTeamData, true, true)
end

WarChessJumpCtrl.WCJumpGetTeamData = function(self)
  -- function num : 0_7
  return self.__curTeamData
end

WarChessJumpCtrl.WCJumpSubSysCancle = function(self)
  -- function num : 0_8
  if self.__isWaitingMove then
    return 
  end
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_JumpSystemData_Quit(self.__identify, function()
    -- function num : 0_8_0 , upvalues : self
    self:__HideJumpTargetFx()
  end
)
end

WarChessJumpCtrl.WCJumpSubSysJump = function(self, dir, movePos)
  -- function num : 0_9 , upvalues : _ENV, WarChessHelper
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_JumpSystemData_Start(self.__identify, dir, movePos, function(argList)
    -- function num : 0_9_0 , upvalues : _ENV, self, WarChessHelper
    if argList.Count < 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    local msg = argList[1]
    if isSucess then
      local jumpInFx = (self.__jumpTable).jumpInFx
      do
        local jumpOutFx = (self.__jumpTable).jumpOutFx
        local sx, sy = (WarChessHelper.Coordination2Pos)((msg.wcStartPos).pos)
        local ex, ey = (WarChessHelper.Coordination2Pos)((msg.wcEndPos).pos)
        local startPos = (Vector3.New)(sx, 0, sy)
        local endPos = (Vector3.New)(ex, 0, ey)
        local endLoigicPos = (Vector2.New)(ex, ey)
        local ShowJumpFx = function()
      -- function num : 0_9_0_0 , upvalues : jumpOutFx, self, startPos, jumpInFx, endPos, _ENV
      local s_fxgo, e_fxgo = nil, nil
      if jumpOutFx ~= nil then
        s_fxgo = ((self.wcCtrl).animaCtrl):ShowWCEffect(jumpOutFx, startPos)
      end
      if jumpInFx ~= nil then
        e_fxgo = ((self.wcCtrl).animaCtrl):ShowWCEffect(jumpInFx, endPos)
      end
      TimerManager:StartTimer(5, function()
        -- function num : 0_9_0_0_0 , upvalues : self, jumpOutFx, s_fxgo, jumpInFx, e_fxgo
        if self.wcCtrl == nil or not (self.wcCtrl):GetIsInWarChessScene() or (self.wcCtrl).animaCtrl == nil then
          return 
        end
        if jumpOutFx ~= nil then
          ((self.wcCtrl).animaCtrl):RecycleWCEffect(jumpOutFx, s_fxgo)
        end
        if jumpInFx ~= nil then
          ((self.wcCtrl).animaCtrl):RecycleWCEffect(jumpInFx, e_fxgo)
        end
      end
, self, true)
    end

        self:__HideJumpTargetFx()
        local systemType = msg.systemType
        self.__isWaitingMove = true
        if systemType == proto_object_JumpSystemStateType.JumpSystemMoving then
          ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_JumpSystemData_Move(self.__identify, ShowJumpFx)
          self.__isWaitingMove = false
        else
          if systemType == proto_object_JumpSystemStateType.JumpSystemBattle then
            ((self.wcCtrl).battleCtrl):SetInstaKillName((self.__jumpTable).battleInstaKillFx)
            ShowJumpFx()
            local teamData = self:WCJumpGetTeamData()
            do
              local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamData:GetWCTeamLogicPos())
              local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, ex, ey)
              if startGrid ~= nil then
                startGrid:SetWCGridIsStandTeam(false)
              end
              if gridData ~= nil then
                gridData:SetWCGridIsStandTeam(true)
              end
              teamData:SetWCTeamLogicPos(endLoigicPos)
              local heroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity((teamData:GetWCTeamIndex()), nil, nil)
              heroEntity:WCHeroEntitySetPos(endPos)
              ;
              ((self.wcCtrl).teamCtrl):CalTeamCouldMoveGridDic(teamData)
              MsgCenter:Broadcast(eMsgEventId.WC_TeamInfoUpdate, teamData)
              teamData:SetEarlySettedPos((msg.wcEndPos).pos)
              self.__isWaitingMoveOverCallback = function()
      -- function num : 0_9_0_1 , upvalues : self, teamData, ex, ey
      local startGrid = ((self.wcCtrl).mapCtrl):GetGridDataByLogicPos(nil, teamData:GetWCTeamLogicPos())
      local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, ex, ey)
      if startGrid ~= nil then
        startGrid:SetWCGridIsStandTeam(false)
      end
      if gridData ~= nil then
        gridData:SetWCGridIsStandTeam(true)
      end
      ;
      ((self.wcCtrl).teamCtrl):CalTeamCouldMoveGridDic(teamData)
    end

            end
          end
        end
        do
          ;
          ((self.wcCtrl).curState):SetWCCustomInput(false)
          ;
          ((self.wcCtrl).animaCtrl):UpdateWCSelectedFX(true, endLoigicPos)
        end
      end
    end
  end
)
end

WarChessJumpCtrl.__JumpSystemCustomClick = function(self, pos)
  -- function num : 0_10 , upvalues : _ENV, WarChessHelper, cs_MessageCommon
  if pos == nil then
    return 
  end
  local x = (math.floor)(pos.x + 0.5)
  local y = (math.floor)(pos.z + 0.5)
  local clickLogicPos = (Vector2.New)(x, y)
  if not ((self.wcCtrl).curState):IsCorrectGuideClick(clickLogicPos) then
    return 
  end
  ;
  ((self.wcCtrl).curState):CheckWCGuideClick()
  for _,jumpElem in pairs((self.__jumpSystemData).jumpPos) do
    for _,WCPos in pairs(jumpElem.pos) do
      local x, y = (WarChessHelper.Coordination2Pos)(WCPos.pos)
      if (Vector2.Temp)(x, y) == clickLogicPos then
        local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPos(nil, clickLogicPos)
        if entityData ~= nil and entityData:IsBossMonster() then
          (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7135))
          return 
        end
        self:WCJumpSubSysJump(nil, WCPos)
        return 
      end
    end
  end
  self:WCJumpSubSysCancle()
end

WarChessJumpCtrl.GetIsEarlyJump = function(self, teamData)
  -- function num : 0_11
end

WarChessJumpCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_12 , upvalues : base, WarChessJumpCtrl
  (base.CloseWCSubSystem)()
  -- DECOMPILER ERROR at PC12: Unhandled construct in 'MakeBoolean' P1

  if self.__jumpType == (WarChessJumpCtrl.eJumpType).fourWayJump and self.__jump3DUINode ~= nil then
    (self.__jump3DUINode):Delete()
  end
  if self.__jumpType == (WarChessJumpCtrl.eJumpType).chess then
    ((self.wcCtrl).curState):SetWCCustomInput(false)
  end
  do
    if not self.__isWaitingMove then
      local teamData = self:WCJumpGetTeamData()
      teamData:SetEarlySettedPos(nil)
    end
    self.__jumpSystemData = nil
    self.__identify = nil
    self.__curTeamData = nil
  end
end

WarChessJumpCtrl.Delete = function(self)
  -- function num : 0_13
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return WarChessJumpCtrl

