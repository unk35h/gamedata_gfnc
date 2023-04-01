-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessCannonCtrl = class("WarChessCannonCtrl", base)
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eGridToward = eWarChessEnum.eGridToward
local util = require("XLua.Common.xlua_util")
local DEFAULT_Height = 0.254
WarChessCannonCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__raySystemData = nil
  self.__identify = nil
  self.__fxList = {}
end

WarChessCannonCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).cannon
end

WarChessCannonCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV, util
  if systemState == nil then
    error("not have data")
    return 
  end
  if systemState.raySystemData == nil then
    warn("delay init system")
  end
  self.__identify = identify
  if (systemState.raySystemData).casted then
    warn("上次开炮没有正常退出")
    ;
    ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_RayCastSystem_Quit(self.__identify)
    return 
  end
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_RayCastSystem_Start(identify, function(argList)
    -- function num : 0_2_0 , upvalues : _ENV, self, util
    if argList.Count < 1 then
      error("argList.Count error:" .. tostring(argList.Count))
      return 
    end
    local isSucess = argList[0]
    if isSucess then
      local raySystemData = argList[1]
      self.__playRayCo = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self.WCDrawCannonRay, raySystemData)))
    end
  end
)
end

WarChessCannonCtrl.WCDrawCannonRay = function(self, raySystemData)
  -- function num : 0_3 , upvalues : _ENV, WarChessHelper, eGridToward, DEFAULT_Height
  self.__raySystemData = raySystemData
  ;
  (coroutine.yield)()
  for index,line in ipairs((self.__raySystemData).lines) do
    local start_x, start_y = (WarChessHelper.Coordination2Pos)(line.startPos)
    local end_x, end_y = (WarChessHelper.Coordination2Pos)(line.endPos)
    local dir = 0
    if start_x ~= end_x and start_y ~= end_y then
      error("not support oblique ray, pls check it")
    end
    if start_x == end_x and start_y == end_y then
      error("start and end point in the same pos, pls check it")
    end
    if start_x < end_x then
      dir = eGridToward.right
    else
      if end_x < start_x then
        dir = eGridToward.left
      else
        if start_y < end_y then
          dir = eGridToward.up
        else
          if end_y < start_y then
            dir = eGridToward.down
          end
        end
      end
    end
    local lineFxGo = ((self.wcCtrl).animaCtrl):ShowWCEffect("FXP_007_Arena_001_I_Cannon_linerender", Vector3.zero)
    ;
    (table.insert)(self.__fxList, lineFxGo)
    local startBindPoint = (Vector3.New)(start_x, DEFAULT_Height, start_y)
    local endBindPoint = (Vector3.New)(end_x, DEFAULT_Height, end_y)
    local startEntityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPosXY(nil, start_x, start_y)
    if startEntityData ~= nil then
      local rotate = startEntityData:GetWCEntityRotate(true)
      if rotate ~= nil then
        rotate = (dir + 4 - rotate) % 4
        local transform = startEntityData:GetWCEntityBindPoint(tostring(rotate))
        if transform ~= nil then
          startBindPoint = transform.position
        end
      end
    else
      do
        local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, start_x, start_y)
        if gridData ~= nil then
          local startGridGo = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, start_x, start_y, false)
          local rotate = gridData:GetWCGridRotate(true)
          if not IsNull(startGridGo) and rotate ~= nil then
            rotate = (dir + 4 - rotate) % 4
            local startTransform = ((startGridGo.transform):GetChild(0)):FindComponent(tostring(rotate), eUnityComponentID.Transform)
            if startTransform ~= nil then
              startBindPoint = startTransform.position
            end
          end
        end
        do
          local endEntityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPosXY(nil, end_x, end_y)
          local inDir = (dir + 2) % 4
          if endEntityData ~= nil then
            local rotate = endEntityData:GetWCEntityRotate(true)
            if rotate ~= nil then
              rotate = (inDir + 4 - rotate) % 4
              local transform = endEntityData:GetWCEntityBindPoint(tostring(rotate))
              if transform ~= nil then
                endBindPoint = transform.position
              end
            end
          else
            do
              local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, end_x, end_y)
              if gridData ~= nil then
                local gridGo = ((self.wcCtrl).mapCtrl):GetAreaObjectByXY(nil, nil, end_x, end_y, false)
                local rotate = gridData:GetWCGridRotate(true)
                if not IsNull(gridGo) and rotate ~= nil then
                  rotate = (inDir + 4 - rotate) % 4
                  local transform = gridGo:FindComponent(tostring(rotate), eUnityComponentID.Transform)
                  if transform ~= nil then
                    endBindPoint = transform.position
                  end
                end
              end
              do
                local effectUnit = lineFxGo:GetComponent(typeof(CS.EffectUnit))
                effectUnit:SetLineEffect(startBindPoint, endBindPoint)
                local endTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByLogicPos((Vector2.Temp)(end_x, end_y))
                do
                  if endTeamData ~= nil then
                    local teamEnityt = ((self.wcCtrl).teamCtrl):GetWCHeroEntity((endTeamData:GetWCTeamIndex()), nil)
                    if teamEnityt ~= nil then
                      teamEnityt:WCAnimatorSetTrigger("WarChess_Stun")
                    end
                  end
                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC240: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
    end
  end
  ;
  (coroutine.yield)(((CS.UnityEngine).WaitForSeconds)(0.75))
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_RayCastSystem_Quit(self.__identify)
  self.__playRayCo = nil
end

WarChessCannonCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_4 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  -- DECOMPILER ERROR at PC10: Unhandled construct in 'MakeBoolean' P1

  if not isSwitchClose or self.__playRayCo ~= nil then
    (GR.StopCoroutine)(self.__playRayCo)
    self.__playRayCo = nil
  end
  for _,lineFxGo in pairs(self.__fxList) do
    ((self.wcCtrl).animaCtrl):RecycleWCEffect("FXP_007_Arena_001_I_Cannon_linerender", lineFxGo)
  end
  self.__raySystemData = nil
  self.__identify = nil
  self.__fxList = {}
end

WarChessCannonCtrl.Delete = function(self)
  -- function num : 0_5
end

return WarChessCannonCtrl

