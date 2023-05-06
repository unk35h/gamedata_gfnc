-- params : ...
-- function num : 0 , upvalues : _ENV
local WarChessHelper = {}
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local eGridToward = eWarChessEnum.eGridToward
local WarChessBattleRoom = require("Game.WarChess.Data.Battle.WarChessBattleRoom")
WarChessHelper.rotateValue = {[eGridToward.up] = Vector3.zero, [eGridToward.right] = (Vector3.New)(0, 90, 0), [eGridToward.down] = (Vector3.New)(0, 180, 0), [eGridToward.left] = (Vector3.New)(0, -90, 0)}
WarChessHelper.rotate2Move = {[eGridToward.up] = Vector2.up, [eGridToward.right] = Vector2.right, [eGridToward.down] = -Vector2.up, [eGridToward.left] = -Vector2.right}
WarChessHelper.rotateMatrix = {
[eGridToward.up] = {
{1, 0, 0}
, 
{0, 1, 0}
, 
{0, 0, 1}
}
, 
[eGridToward.right] = {
{0, 1, 0}
, 
{-1, 0, 0}
, 
{0, 0, 1}
}
, 
[eGridToward.down] = {
{-1, 0, 0}
, 
{0, -1, 0}
, 
{0, 0, 1}
}
, 
[eGridToward.left] = {
{0, -1, 0}
, 
{1, 0, 0}
, 
{0, 0, 1}
}
}
WarChessHelper.AStarSearchOrder = {[1] = Vector2.up, [2] = Vector2.right, [3] = -Vector2.up, [4] = -Vector2.right}
WarChessHelper.GridToward2RotateValue = function(eGridToward)
  -- function num : 0_0 , upvalues : WarChessHelper
  return (WarChessHelper.rotateValue)[eGridToward]
end

WarChessHelper.GridToward2RotateMatrix = function(eGridToward)
  -- function num : 0_1 , upvalues : WarChessHelper
  return (WarChessHelper.rotateMatrix)[eGridToward]
end

WarChessHelper.GridAreaRotateMatrix = function(areaData)
  -- function num : 0_2 , upvalues : _ENV, WarChessHelper, eWarChessEnum
  local eGridToward = areaData:GetWCAreaLogicToward()
  local rotateMatrix = (table.deepCopy)((WarChessHelper.rotateMatrix)[eGridToward])
  local width, height = areaData:GetWCAreaSizeXY()
  local x, y = areaData:GetWCAreaLogicPosXY()
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (rotateMatrix[1])[3] = x
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

  ;
  (rotateMatrix[2])[3] = y
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

  if eGridToward == (eWarChessEnum.eGridToward).right then
    (rotateMatrix[2])[3] = (rotateMatrix[2])[3] + width - 1
  else
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R7 in 'UnsetPending'

    if eGridToward == (eWarChessEnum.eGridToward).left then
      (rotateMatrix[1])[3] = (rotateMatrix[1])[3] + height - 1
    else
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R7 in 'UnsetPending'

      if eGridToward == (eWarChessEnum.eGridToward).down then
        (rotateMatrix[1])[3] = (rotateMatrix[1])[3] + width - 1
        -- DECOMPILER ERROR at PC52: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (rotateMatrix[2])[3] = (rotateMatrix[2])[3] + height - 1
      end
    end
  end
  return rotateMatrix
end

local sinTab = {[eGridToward.up] = 0, [eGridToward.right] = 1, [eGridToward.down] = 0, [eGridToward.left] = -1}
local cosTab = {[eGridToward.up] = 1, [eGridToward.right] = 0, [eGridToward.down] = -1, [eGridToward.left] = 0}
WarChessHelper.GenGridInAreaPos = function(gridPosX, gridPosY, areaData)
  -- function num : 0_3 , upvalues : eWarChessEnum
  local areaX, areaY = areaData:GetWCAreaLogicPosXY()
  local eGridToward = areaData:GetWCAreaLogicToward()
  local areaSizeX, areaSizeY = areaData:GetWCAreaSizeXY()
  gridPosX = gridPosX - areaX
  local x, y = nil, nil
  if eGridToward == (eWarChessEnum.eGridToward).up then
    x = gridPosX
  else
    if eGridToward == (eWarChessEnum.eGridToward).right then
      x = -(gridPosY) + (areaSizeX - 1)
      -- DECOMPILER ERROR at PC25: Overwrote pending register: R9 in 'AssignReg'

    else
      if eGridToward == (eWarChessEnum.eGridToward).down then
        x = -(gridPosX - (areaSizeX - 1))
        -- DECOMPILER ERROR at PC36: Overwrote pending register: R9 in 'AssignReg'

      else
        if eGridToward == (eWarChessEnum.eGridToward).left then
          x = gridPosY
          -- DECOMPILER ERROR at PC45: Overwrote pending register: R9 in 'AssignReg'

        end
      end
    end
  end
  return x, y
end

local GetManhattanDis = function(AGrid, BGrid)
  -- function num : 0_4 , upvalues : _ENV
  local logicPosA = AGrid:GetGridLogicPos()
  local logicPosB = BGrid:GetGridLogicPos()
  return (math.abs)(logicPosA.x - logicPosB.x) + (math.abs)(logicPosA.y - logicPosB.y)
end

local SortByGridValue = function(giridA, giridB)
  -- function num : 0_5
  do return giridA.searchValue < giridB.searchValue end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessHelper.AStrarPathFind = function(mapCtrl, startGrid, endGrid, isMonster, selfEntityData)
  -- function num : 0_6 , upvalues : _ENV, SortByGridValue, WarChessHelper, GetManhattanDis
  if startGrid == endGrid then
    return true, {endGrid}
  end
  startGrid.searchValue = 0
  local open_set = {startGrid}
  local close_set = {}
  local curGrid = nil
  while 1 do
    while 1 do
      if (table.count)(open_set) > 0 then
        (table.sort)(open_set, SortByGridValue)
        curGrid = (table.remove)(open_set, 1)
        close_set[curGrid] = true
        if curGrid == endGrid then
          local passGridList = {}
          while curGrid ~= startGrid do
            (table.insert)(passGridList, curGrid)
            curGrid = curGrid.parentGrid
          end
          if not isMonster then
            local teamData = selfEntityData
            local maxPathLength = teamData:GetCouldWalkLength()
            if maxPathLength ~= nil and maxPathLength < #passGridList then
              return false
            end
          end
          do
            do
              do return true, passGridList end
              -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
    local logicPos = curGrid:GetGridLogicPos()
    for _,dirValue in ipairs(WarChessHelper.AStarSearchOrder) do
      local nearLogicPos = logicPos + dirValue
      local gridData = mapCtrl:GetGridDataByLogicPos(nil, nearLogicPos)
      local entityData = mapCtrl:GetEntityDataByLogicPos(nil, nearLogicPos)
      if gridData ~= nil and (entityData == nil or entityData:GetWCEntityCouldPass(isMonster) or entityData == selfEntityData) and gridData:GetCouldPass(isMonster) then
        if close_set[gridData] == nil or (table.contain)(open_set, gridData) then
          local newWaySearchValue = curGrid.searchValue + GetManhattanDis(curGrid, gridData)
          if newWaySearchValue < gridData.searchValue then
            gridData.parentGrid = curGrid
            gridData.searchValue = newWaySearchValue
          end
        else
          do
            do
              gridData.parentGrid = curGrid
              gridData.searchValue = GetManhattanDis(gridData, startGrid) + GetManhattanDis(gridData, endGrid)
              ;
              (table.insert)(open_set, gridData)
              -- DECOMPILER ERROR at PC129: LeaveBlock: unexpected jumping out DO_STMT

              -- DECOMPILER ERROR at PC129: LeaveBlock: unexpected jumping out IF_ELSE_STMT

              -- DECOMPILER ERROR at PC129: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC129: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC129: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  do
    return false
  end
end

WarChessHelper.BSFAllCouldReachGrid = function(mapCtrl, startGrid, data, isMonster, isPatrol)
  -- function num : 0_7 , upvalues : _ENV, WarChessHelper
  local curGrid = nil
  local couldReachGridDic = {}
  local waitSearchQueue = {}
  local waitNextSearchQueue = {}
  local searchedDic = {}
  local maxPathLength = data:GetCouldWalkLength()
  local curPathLength = 0
  ;
  (table.insert)(waitSearchQueue, startGrid)
  local couldInetactDic = {}
  local levelNubDic = {}
  local startPos = startGrid:GetGridLogicPos()
  while 1 do
    if #waitSearchQueue > 0 or #waitNextSearchQueue > 0 then
      do
        if #waitSearchQueue == 0 then
          local emptyTable = waitSearchQueue
          waitSearchQueue = waitNextSearchQueue
          waitNextSearchQueue = emptyTable
          curPathLength = curPathLength + 1
          if maxPathLength ~= nil and maxPathLength <= curPathLength then
            return couldReachGridDic, couldInetactDic, levelNubDic
          end
        end
        curGrid = (table.remove)(waitSearchQueue, 1)
        do
          local logicPos = curGrid:GetGridLogicPos()
          for _,dirValue in ipairs(WarChessHelper.AStarSearchOrder) do
            local nearLogicPos = logicPos + dirValue
            local gridData = mapCtrl:GetGridDataByLogicPos(nil, nearLogicPos)
            local coordination = (WarChessHelper.Pos2Coordination)(nearLogicPos)
            local entityData = mapCtrl:GetEntityDataByLogicPos(nil, nearLogicPos)
            if gridData ~= nil then
              if not isPatrol then
                if (entityData == nil or entityData:GetWCEntityCouldPass(isMonster)) and gridData:GetCouldPass(isMonster) and searchedDic[gridData] == nil then
                  (table.insert)(waitNextSearchQueue, gridData)
                end
                if entityData == nil and gridData:GetCouldStand() then
                  local distance = (Mathf.Max)((Mathf.Abs)(startPos.x - nearLogicPos.x), (Mathf.Abs)(startPos.y - nearLogicPos.y))
                  if levelNubDic[distance] == nil then
                    levelNubDic[distance] = {}
                  end
                  -- DECOMPILER ERROR at PC113: Confused about usage of register: R26 in 'UnsetPending'

                  ;
                  (levelNubDic[distance])[gridData] = true
                  couldReachGridDic[gridData] = true
                end
              else
                do
                  if gridData:GetCouldPatrol() and searchedDic[gridData] == nil then
                    (table.insert)(waitNextSearchQueue, gridData)
                  end
                  do
                    do
                      if gridData:GetCouldPatrol() then
                        local distance = (Mathf.Max)((Mathf.Abs)(startPos.x - nearLogicPos.x), (Mathf.Abs)(startPos.y - nearLogicPos.y))
                        if levelNubDic[distance] == nil then
                          levelNubDic[distance] = {}
                        end
                        -- DECOMPILER ERROR at PC153: Confused about usage of register: R26 in 'UnsetPending'

                        ;
                        (levelNubDic[distance])[gridData] = true
                        couldReachGridDic[gridData] = true
                      end
                      searchedDic[gridData] = true
                      couldInetactDic[coordination] = true
                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out DO_STMT

                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out DO_STMT

                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out IF_STMT

                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out IF_THEN_STMT

                      -- DECOMPILER ERROR at PC157: LeaveBlock: unexpected jumping out IF_STMT

                    end
                  end
                end
              end
            end
          end
          -- DECOMPILER ERROR at PC159: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC159: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC159: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return couldReachGridDic, couldInetactDic, levelNubDic
end

WarChessHelper.DFSCondUnit = function(condUnit, condId)
  -- function num : 0_8 , upvalues : _ENV, WarChessHelper
  if condUnit.e and (condUnit.e).cat == condId then
    return (condUnit.e).pms
  end
  local orResult = false
  if condUnit.o then
    for i,v in pairs((condUnit.o).data) do
      orResult = (WarChessHelper.DFSCondUnit)(v, condId)
    end
  end
  do
    if not orResult then
      local andResult = false
      if condUnit.a then
        for i,v in pairs((condUnit.a).data) do
          andResult = (WarChessHelper.DFSCondUnit)(v, condId)
        end
      end
      do
        return not andResult and orResult or andResult
      end
    end
  end
end

WarChessHelper.Vector3MoveToward = function(current, target, maxDistanceDelta)
  -- function num : 0_9
  local a = target - current
  local magnitude = a:Magnitude()
  if magnitude <= maxDistanceDelta then
    return target
  end
  return current + a * (maxDistanceDelta / magnitude)
end

WarChessHelper.Coordination2Pos = function(coordination)
  -- function num : 0_10 , upvalues : _ENV
  local x = coordination & CommonUtil.UInt16Max
  local y = coordination >> 16
  return x, y
end

WarChessHelper.Pos2Coordination = function(pos)
  -- function num : 0_11 , upvalues : WarChessHelper
  return (WarChessHelper.PosXy2Coordination)(pos.x, pos.y)
end

WarChessHelper.PosXy2Coordination = function(x, y)
  -- function num : 0_12
  local coordination = y << 16 | x
  return coordination
end

WarChessHelper.IsPointInRect = function(view, x, y)
  -- function num : 0_13
  if view == nil then
    return false
  end
  if x < view.xMin or view.xMax < x or y < view.yMin or view.yMax < y then
    return false
  end
  return true
end

local __WCCoinSort = function(itemCfg1, itemCfg2)
  -- function num : 0_14 , upvalues : _ENV
  local id1 = itemCfg1.id
  local id2 = itemCfg2.id
  local s1 = ConstWCShowCoin[id1]
  local s2 = ConstWCShowCoin[id2]
  do return s1 < s2 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

WarChessHelper.WCCoinSort = function(coinRewardList)
  -- function num : 0_15 , upvalues : _ENV, __WCCoinSort
  if coinRewardList == nil then
    return 
  end
  ;
  (table.sort)(coinRewardList, __WCCoinSort)
end

WarChessHelper.OpenWCChipBag = function(teamData, closeCallback)
  -- function num : 0_16 , upvalues : _ENV
  local warchessMain = UIManager:GetWindow(UIWindowTypeID.WarChessMain)
  if warchessMain == nil then
    return false
  end
  local playNode = warchessMain:GetWCPlayNode()
  if playNode == nil then
    return false
  end
  return playNode:OpenWCTeamChipBag(teamData, closeCallback)
end

WarChessHelper.GetChipReturnMoney = function(dynPlayer, chipId, count)
  -- function num : 0_17 , upvalues : _ENV
  local haveChipData = (dynPlayer.chipDic)[chipId]
  if haveChipData ~= nil and not haveChipData:IsConsumeSkillChip() then
    local maxLevel = haveChipData:GetChipMaxLevel()
    local overflowCount = haveChipData:GetCount() + count - maxLevel
    overflowCount = (math.min)(overflowCount, maxLevel)
    if overflowCount > 0 then
      local shopId = WarChessManager:GetWCLevelShopId()
      local shopCoinCfg = (ConfigData.warchess_shop_coin)[shopId]
      if shopCoinCfg == nil then
        return 0
      end
      local moneyReturn = (shopCoinCfg.function_over_payback)[overflowCount]
      return moneyReturn or 0
    end
  end
  do
    return 0
  end
end

WarChessHelper.CheckEnemyCanMove = function(entityData)
  -- function num : 0_18 , upvalues : _ENV, eWarChessEnum
  local hasCorrectEventType = false
  if #(entityData.unitCfg).triggers > 0 then
    for index,v in pairs((entityData.unitCfg).triggers) do
      if (v.trigger).cat == (eWarChessEnum.eTriggerType).enemyPursueAtk then
        if v ~= nil and v.trigger ~= nil and v.eventType ~= nil then
          for _,vEventType in pairs(v.eventType) do
            if vEventType == (eWarChessEnum.eTriggerConditionType).turnStart or vEventType == (eWarChessEnum.eTriggerConditionType).turnEnd then
              hasCorrectEventType = true
              break
            end
          end
          do
            for _,vCustomEvent in pairs(v.customTag) do
              if vCustomEvent >= 22 and vCustomEvent <= 31 then
                hasCorrectEventType = true
                break
              end
            end
            do
              do
                if hasCorrectEventType then
                  local moveAbility = ((v.trigger).pms)[1]
                  return true, moveAbility
                end
                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
  return false, 0
end

WarChessHelper.AcquireOutSideBoxReward = function(triggers, WarChesGlobalData)
  -- function num : 0_19 , upvalues : _ENV, eWarChessEnum
  local rewardDic = nil
  for i,trigger in ipairs(triggers) do
    if trigger.cat == (eWarChessEnum.eTriggerType).OutsideItem then
      local boxId = (trigger.pms)[1]
      if not WarChesGlobalData:IsReceivedOutsideItemBox(boxId) then
        local rewardIds, rewardNums = WarChesGlobalData:GetOutSideBoxReward(boxId)
        if rewardIds ~= nil then
          if rewardDic == nil then
            rewardDic = {}
          end
          for i,itemId in ipairs(rewardIds) do
            local num = rewardDic[itemId] or 0
            rewardDic[itemId] = num + rewardNums[i]
          end
        end
        do
          do
            WarChesGlobalData:SetOutsideItemBoxReceive(boxId)
            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  if rewardDic ~= nil then
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_19_0 , upvalues : _ENV, rewardDic
    if window == nil then
      return 
    end
    local CommonRewardData = require("Game.CommonUI.CommonRewardData")
    local CRData = ((CommonRewardData.CreateCRDataUseDic)(rewardDic)):SetCRNotHandledGreat(true)
    window:AddAndTryShowReward(CRData)
  end
)
  end
end

WarChessHelper.WCJumpChessType2HeadIconId = function(numericValue)
  -- function num : 0_20 , upvalues : _ENV
  local WarChessJumpCtrl = require("Game.WarChess.Ctrl.SubSystemCtrl.WarChessJumpCtrl")
  local jumpTable = (WarChessJumpCtrl.jumpDiffTable)[(WarChessJumpCtrl.eJumpType).chess]
  return (jumpTable.headIconIds)[numericValue]
end

WarChessHelper.GetRandomRotate = function(min, max)
  -- function num : 0_21 , upvalues : _ENV
  if min == nil or max == nil then
    return nil
  end
  local angle = (math.random)(min, max)
  return (Quaternion.Euler)(0, angle + 180, 0)
end

WarChessHelper.CalWCRoomBattlePower = function(monsters, teamData)
  -- function num : 0_22 , upvalues : WarChessBattleRoom, _ENV
  local fakeBattleRoom = (WarChessBattleRoom.New)()
  fakeBattleRoom.battleMap = ((CS.BattleUtility).GenBattleMap)(7, 5, 3, 5, 100)
  fakeBattleRoom:__InitMonsterOrNeutralData(monsters)
  local fightingPower = 0
  for k,dynMonster in pairs(fakeBattleRoom.monsterList) do
    fightingPower = fightingPower + dynMonster:GetFightingPower()
  end
  print("战斗力为:" .. tostring(fightingPower))
  return fightingPower
end

return WarChessHelper

