-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessConditionCheck = {}
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
WarChessConditionCheck.checkFunc = {[(eWarChessEnum.eConditionCat).checkUnitValue] = function(wcCtrl, unit, args)
  -- function num : 0_0 , upvalues : _ENV
  if #args < 3 then
    error("checkUnitValue arg length not legal")
  end
  local opNum = args[1]
  local pms = unit.pms
  local value = pms[args[2] + 1]
  local targetValue = args[3]
  if targetValue > value then
    do return opNum ~= 1 end
    if value >= targetValue then
      do return opNum ~= 2 end
      if value ~= targetValue then
        do return opNum ~= 3 end
        error("not support operate num")
        do return false end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end
, [(eWarChessEnum.eConditionCat).checkTurnNum] = function(wcCtrl, unit, args)
  -- function num : 0_1 , upvalues : _ENV
  if #args < 2 then
    error("checkUnitValue arg length not legal")
  end
  local opNum = args[1]
  local turnNum = (wcCtrl.turnCtrl):GetWCTurnNum()
  local targetTurnNum = args[2]
  if targetTurnNum > turnNum then
    do return opNum ~= 1 end
    if turnNum >= targetTurnNum then
      do return opNum ~= 2 end
      if turnNum ~= targetTurnNum then
        do return opNum ~= 3 end
        error("not support operate num")
        do return false end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end
, [(eWarChessEnum.eConditionCat).checkPressLevel] = function(wcCtrl, unit, args)
  -- function num : 0_2 , upvalues : _ENV
  if #args < 2 then
    error("checkUnitValue arg length not legal")
  end
  local opNum = args[1]
  local pressLevel = (wcCtrl.turnCtrl):GetWCStressLevelAndPoint()
  local targetTurnNum = args[2]
  if targetTurnNum > pressLevel then
    do return opNum ~= 1 end
    if pressLevel >= targetTurnNum then
      do return opNum ~= 2 end
      if pressLevel ~= targetTurnNum then
        do return opNum ~= 3 end
        error("not support operate num")
        do return false end
        -- DECOMPILER ERROR: 7 unprocessed JMP targets
      end
    end
  end
end
, [(eWarChessEnum.eConditionCat).checkItemNumAbove] = function(wcCtrl, unit, args)
  -- function num : 0_3 , upvalues : _ENV
  if #args < 2 then
    error("checkUnitValue arg length not legal")
  end
  local itemId = args[1]
  local itemNum = (wcCtrl.backPackCtrl):GetWCItemNum(itemId)
  local targetItemNum = args[2]
  do return targetItemNum <= itemNum end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end
, [(eWarChessEnum.eConditionCat).checkIsNotHaveEntityOnGrid] = function(wcCtrl, unit, args)
  -- function num : 0_4 , upvalues : WarChessConditionCheck, eWarChessEnum
  return not ((WarChessConditionCheck.checkFunc)[(eWarChessEnum.eConditionCat).checkIsHaveEntityOnGrid])(wcCtrl, unit, args)
end
, [(eWarChessEnum.eConditionCat).checkIsHaveEntityOnGrid] = function(wcCtrl, unit, args)
  -- function num : 0_5 , upvalues : WarChessHelper, _ENV
  local x, y = (WarChessHelper.Coordination2Pos)(unit.pos)
  local gridData = (wcCtrl.mapCtrl):GetGridDataByLogicXY(nil, x, y)
  if gridData == nil then
    error("want to check some thing which not on grid is on grid unit:" .. tostring(unit))
    return false
  end
  local entityData = (wcCtrl.mapCtrl):GetEntityDataByLogicPosXY(nil, x, y)
  if entityData ~= nil then
    return false
  end
  local teamData = (wcCtrl.teamCtrl):GetTeamDataByLogicPos((Vector2.Temp)(x, y))
  if teamData ~= nil then
    return false
  end
  return true
end
}
WarChessConditionCheck.CheckWCCondition = function(wcCtrl, unit, conditionId, args)
  -- function num : 0_6 , upvalues : WarChessConditionCheck, _ENV
  local checkFuck = (WarChessConditionCheck.checkFunc)[conditionId]
  if checkFuck ~= nil then
    return checkFuck(wcCtrl, unit, args)
  else
    warn("warchess condition check not exist id:" .. tostring(conditionId) .. "\ndefault return true")
    return true
  end
end

WarChessConditionCheck.CheckGridConditionTree = function(unit, interactCfg)
  -- function num : 0_7 , upvalues : _ENV, WarChessConditionCheck
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local rootNode = interactCfg.cond
  local check = nil
  check = function(node)
    -- function num : 0_7_0 , upvalues : WarChessConditionCheck, wcCtrl, unit, _ENV, check
    if node.e ~= nil then
      local data = node.e
      return (WarChessConditionCheck.CheckWCCondition)(wcCtrl, unit, data.cat, data.pms)
    else
      do
        if node.o ~= nil then
          for _,subNode in ipairs((node.o).data) do
            if check(subNode) then
              return true
            end
          end
          return false
        else
          if node.a ~= nil then
            for _,subNode in ipairs((node.a).data) do
              if not check(subNode) then
                return false
              end
            end
            return true
          else
            return true
          end
        end
      end
    end
  end

  if rootNode == nil then
    return true
  end
  return check(rootNode)
end

return WarChessConditionCheck

