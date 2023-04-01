-- params : ...
-- function num : 0 , upvalues : _ENV
local DeployTeamUtil = {}
local autoDeployListPool = (CommonPool.New)(function()
  -- function num : 0_0
  return {}
end
, function(p)
  -- function num : 0_1 , upvalues : _ENV
  (table.removeall)(p)
  return true
end
)
local banchPosArray = {1, 3, 2, 0, 4}
DeployTeamUtil.banchPosArray = banchPosArray
DeployTeamUtil.FinalDeployRole = function(defendRoles, longRangeRoles, benchRoles, deployDic, mapDeployX, mapSizeY, benchX)
  -- function num : 0_2 , upvalues : _ENV, DeployTeamUtil
  if #defendRoles > 0 then
    for x = mapDeployX - 1, 0, -1 do
      for y = 0, mapSizeY - 1 do
        if #defendRoles ~= 0 then
          local coord = x << 16 | y
          if not deployDic[coord] then
            deployDic[coord] = true
            local role = (table.remove)(defendRoles)
            role:SetCoordXY(x, y, benchX)
          end
          do
            -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC29: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  do
    if #longRangeRoles > 0 then
      for x = 0, mapDeployX - 1 do
        for y = 0, mapSizeY - 1 do
          if #longRangeRoles ~= 0 then
            local coord = x << 16 | y
            if not deployDic[coord] then
              deployDic[coord] = true
              local role = (table.remove)(longRangeRoles)
              role:SetCoordXY(x, y, benchX)
            end
            do
              -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC60: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
    do
      ;
      (DeployTeamUtil._DeloyBenchHero)(benchRoles, benchX)
    end
  end
end

DeployTeamUtil._DeloyBenchHero = function(benchRoles, benchX)
  -- function num : 0_3 , upvalues : _ENV, banchPosArray
  local index = 1
  for k,role in pairs(benchRoles) do
    local benchy = banchPosArray[index]
    if benchy ~= nil then
      role:SetCoordXY(benchX, benchy, benchX)
      index = index + 1
    end
  end
end

DeployTeamUtil.DeployHeroTeam = function(heroList, size_row, size_col, deploy_rows, lastDeployDic)
  -- function num : 0_4 , upvalues : _ENV, autoDeployListPool, DeployTeamUtil
  local benchX = (ConfigData.buildinConfig).BenchX
  local longRangeRoles = autoDeployListPool:PoolGet()
  local defendRoles = autoDeployListPool:PoolGet()
  local benchRoles = autoDeployListPool:PoolGet()
  local deployDic = {}
  if not lastDeployDic then
    lastDeployDic = {}
  end
  for k,heroData in pairs(heroList) do
    if heroData.onBench then
      (table.insert)(benchRoles, heroData)
    else
      if lastDeployDic[heroData.dataId] ~= nil then
        local coord = lastDeployDic[heroData.dataId]
        local x, y = (BattleUtil.Pos2XYCoord)(coord)
        heroData:SetCoordXY(x, y, benchX)
        deployDic[coord] = true
      else
        do
          do
            if heroData.attackRange <= 1 then
              (table.insert)(defendRoles, heroData)
            else
              ;
              (table.insert)(longRangeRoles, heroData)
            end
            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC61: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  local mapDeployX = deploy_rows
  local mapSizeY = size_col
  local totalHeroCount = #heroList
  local defendRoleCount = #defendRoles
  local longRangeRoleCount = #longRangeRoles
  if defendRoleCount > 3 or longRangeRoleCount > 3 then
    (DeployTeamUtil.FinalDeployRole)(defendRoles, longRangeRoles, benchRoles, deployDic, mapDeployX, mapSizeY, benchX)
    autoDeployListPool:PoolPut(longRangeRoles)
    autoDeployListPool:PoolPut(defendRoles)
    autoDeployListPool:PoolPut(benchRoles)
    return 
  end
  if defendRoleCount > 0 then
    local curRow = mapDeployX - 1
    if totalHeroCount <= defendRoleCount then
      curRow = 0
    end
    if defendRoleCount > 2 then
      for c = mapSizeY - 1, 0, -1 do
        -- DECOMPILER ERROR at PC114: Unhandled construct in 'MakeBoolean' P1

        if c % 2 == 0 and #defendRoles ~= 0 then
          local coord = curRow << 16 | c
          if not deployDic[coord] then
            deployDic[coord] = true
            local role = (table.remove)(defendRoles)
            role:SetCoordXY(curRow, c, benchX)
          end
          do
            -- DECOMPILER ERROR at PC127: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC127: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    else
      if defendRoleCount == 2 then
        if totalHeroCount - defendRoleCount == 3 then
          local role = (table.remove)(defendRoles)
          role:SetCoordXY(1, 0, benchX)
          role = (table.remove)(defendRoles)
          role:SetCoordXY(1, 4, benchX)
        else
          do
            for c = mapSizeY - 1, 0, -1 do
              -- DECOMPILER ERROR at PC166: Unhandled construct in 'MakeBoolean' P1

              if c % 2 == 1 and #defendRoles ~= 0 then
                local coord = curRow << 16 | c
                if not deployDic[coord] then
                  deployDic[coord] = true
                  local role = (table.remove)(defendRoles)
                  role:SetCoordXY(curRow, c, benchX)
                end
                do
                  -- DECOMPILER ERROR at PC179: LeaveBlock: unexpected jumping out IF_THEN_STMT

                  -- DECOMPILER ERROR at PC179: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
            if defendRoleCount == 1 then
              local curCow = (mapSizeY - 1) // 2
              local coord = curRow << 16 | curCow
              if not deployDic[coord] then
                deployDic[coord] = true
                local role = (table.remove)(defendRoles)
                role:SetCoordXY(curRow, curCow, benchX)
              end
            end
            do
              if longRangeRoleCount > 0 then
                local curRow = 0
                if longRangeRoleCount >= 5 then
                  for c = mapSizeY - 1, 0, -1 do
                    if #longRangeRoles ~= 0 then
                      local coord = curRow << 16 | c
                      if not deployDic[coord] then
                        deployDic[coord] = true
                        local role = (table.remove)(longRangeRoles)
                        role:SetCoordXY(curRow, c, benchX)
                      end
                      do
                        -- DECOMPILER ERROR at PC227: LeaveBlock: unexpected jumping out IF_THEN_STMT

                        -- DECOMPILER ERROR at PC227: LeaveBlock: unexpected jumping out IF_STMT

                      end
                    end
                  end
                else
                  if longRangeRoleCount == 4 then
                    for c = 0, 1 do
                      if #longRangeRoles ~= 0 then
                        local coord = curRow << 16 | c
                        if not deployDic[coord] then
                          deployDic[coord] = true
                          local role = (table.remove)(longRangeRoles)
                          role:SetCoordXY(curRow, c, benchX)
                        end
                        do
                          -- DECOMPILER ERROR at PC253: LeaveBlock: unexpected jumping out IF_THEN_STMT

                          -- DECOMPILER ERROR at PC253: LeaveBlock: unexpected jumping out IF_STMT

                        end
                      end
                    end
                    for c = mapSizeY - 1, 3, -1 do
                      if #longRangeRoles ~= 0 then
                        local coord = curRow << 16 | c
                        if not deployDic[coord] then
                          deployDic[coord] = true
                          local role = (table.remove)(longRangeRoles)
                          role:SetCoordXY(curRow, c, benchX)
                        end
                        do
                          -- DECOMPILER ERROR at PC276: LeaveBlock: unexpected jumping out IF_THEN_STMT

                          -- DECOMPILER ERROR at PC276: LeaveBlock: unexpected jumping out IF_STMT

                        end
                      end
                    end
                  else
                    if longRangeRoleCount == 3 then
                      for c = mapSizeY - 1, 0, -1 do
                        -- DECOMPILER ERROR at PC292: Unhandled construct in 'MakeBoolean' P1

                        if c % 2 == 0 and #longRangeRoles ~= 0 then
                          local coord = curRow << 16 | c
                          if not deployDic[coord] then
                            deployDic[coord] = true
                            local role = (table.remove)(longRangeRoles)
                            role:SetCoordXY(curRow, c, benchX)
                          end
                          do
                            -- DECOMPILER ERROR at PC305: LeaveBlock: unexpected jumping out IF_THEN_STMT

                            -- DECOMPILER ERROR at PC305: LeaveBlock: unexpected jumping out IF_STMT

                          end
                        end
                      end
                    else
                      if longRangeRoleCount == 2 then
                        if defendRoleCount > 0 then
                          if #longRangeRoles > 0 then
                            local coord = curRow << 16 | 0
                            if not deployDic[coord] then
                              deployDic[coord] = true
                              local role = (table.remove)(longRangeRoles)
                              role:SetCoordXY(curRow, 0, benchX)
                            end
                          end
                          do
                            if #longRangeRoles > 0 then
                              local coord = curRow << 16 | mapSizeY - 1
                              if not deployDic[coord] then
                                deployDic[coord] = true
                                local role = (table.remove)(longRangeRoles)
                                role:SetCoordXY(curRow, mapSizeY - 1, benchX)
                              end
                            end
                            do
                              for c = mapSizeY - 1, 0, -1 do
                                -- DECOMPILER ERROR at PC361: Unhandled construct in 'MakeBoolean' P1

                                if c % 2 == 1 and #longRangeRoles ~= 0 then
                                  local coord = curRow << 16 | c
                                  if not deployDic[coord] then
                                    deployDic[coord] = true
                                    local role = (table.remove)(longRangeRoles)
                                    role:SetCoordXY(curRow, c, benchX)
                                  end
                                  do
                                    -- DECOMPILER ERROR at PC374: LeaveBlock: unexpected jumping out IF_THEN_STMT

                                    -- DECOMPILER ERROR at PC374: LeaveBlock: unexpected jumping out IF_STMT

                                  end
                                end
                              end
                              if longRangeRoleCount == 1 and #longRangeRoles > 0 then
                                local curCow = (mapSizeY - 1) // 2
                                local coord = curRow << 16 | curCow
                                if not deployDic[coord] then
                                  deployDic[coord] = true
                                  local role = (table.remove)(longRangeRoles)
                                  role:SetCoordXY(curRow, curCow, benchX)
                                end
                              end
                              do
                                ;
                                (DeployTeamUtil.FinalDeployRole)(defendRoles, longRangeRoles, benchRoles, deployDic, mapDeployX, mapSizeY, benchX)
                                autoDeployListPool:PoolPut(longRangeRoles)
                                autoDeployListPool:PoolPut(defendRoles)
                                autoDeployListPool:PoolPut(benchRoles)
                              end
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

DeployTeamUtil.AutoBattleDeploy = function(roomData, heroList, size_row, size_col, deploy_rows, deployStage)
  -- function num : 0_5 , upvalues : _ENV, DeployTeamUtil, autoDeployListPool, banchPosArray
  local benchX = (ConfigData.buildinConfig).BenchX
  if roomData ~= nil and roomData.roomSpecialDeployCfg ~= nil then
    if deployStage or roomData.reSpecialDeploy then
      (DeployTeamUtil.BattleSpecilDeploy)(roomData, heroList, benchX)
    end
    return 
  end
  if roomData == nil or roomData.effectGridList == nil or #roomData.effectGridList == 0 then
    return 
  end
  local benchRoles = autoDeployListPool:PoolGet()
  local stageRoles = autoDeployListPool:PoolGet()
  local roleAttrDics = {}
  local succCoordDic = {}
  for coord,v in pairs(roomData.occupyCoords) do
    succCoordDic[coord] = true
  end
  for _,dynHero in pairs(heroList) do
    if dynHero.onBench then
      (table.insert)(benchRoles, dynHero)
    else
      if deployStage then
        (table.insert)(stageRoles, dynHero)
      end
    end
    local attrDic = dynHero:GetDynBattleRoleAttrDic()
    roleAttrDics[dynHero.dataId] = attrDic
  end
  if #benchRoles == 0 and #stageRoles == 0 then
    autoDeployListPool:PoolPut(benchRoles)
    autoDeployListPool:PoolPut(stageRoles)
    return 
  end
  for _,dynGrid in pairs(roomData.effectGridList) do
    local roles = nil
    if dynGrid.x == benchX then
      roles = benchRoles
    end
    local validRoles = autoDeployListPool:PoolGet()
    local career = dynGrid:GetGridCareerPriority()
    for _,dynHero in pairs(roles) do
      if career == dynHero:GetCareer() and dynGrid:GetGridNecessaryFormulaValue(roleAttrDics[dynHero.dataId]) then
        (table.insert)(validRoles, dynHero)
      end
    end
    if #validRoles == 0 then
      autoDeployListPool:PoolPut(validRoles)
    else
      local bestRole = nil
      if #validRoles > 1 then
        if dynGrid:GetAutoIsMax() then
          local bestValue = CommonUtil.Int64Min
          for _,dynHero in pairs(validRoles) do
            local value = dynGrid:GetGridAttrFormulaValue(roleAttrDics[dynHero.dataId])
            if bestValue < value then
              bestValue = value
              bestRole = dynHero
            end
          end
        else
          do
            local bestValue = CommonUtil.Int64Max
            for _,dynHero in pairs(validRoles) do
              local value = dynGrid:GetGridAttrFormulaValue(roleAttrDics[dynHero.dataId])
              if value < bestValue then
                bestValue = value
                bestRole = dynHero
              end
            end
            do
              bestRole = validRoles[1]
              if bestRole == nil then
                error("DeployTeamUtil.AutoBattleDeploy get bestRole is null!")
                autoDeployListPool:PoolPut(validRoles)
              else
                for index,dynHero in pairs(roles) do
                  if dynHero == bestRole then
                    (table.remove)(roles, R27_PC193)
                    break
                  end
                end
                do
                  do
                    bestRole:SetCoord(dynGrid.coord, benchX)
                    succCoordDic[dynGrid.coord] = bestRole
                    autoDeployListPool:PoolPut(validRoles)
                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out DO_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_THEN_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                    -- DECOMPILER ERROR at PC207: LeaveBlock: unexpected jumping out IF_STMT

                  end
                end
              end
            end
          end
        end
      end
    end
  end
  for _,dynGrid in pairs(roomData.effectGridList) do
    local roles = nil
    if dynGrid.x == benchX then
      roles = benchRoles
    else
      if deploy_rows > dynGrid.x then
        roles = stageRoles
        if #roles ~= 0 and succCoordDic[dynGrid.coord] == nil then
          local auto_career = dynGrid:GetGridAutoCareer()
          local validRoles = autoDeployListPool:PoolGet()
          local maxCareerKey = -1
          for _,dynHero in pairs(roles) do
            if not auto_career[dynHero:GetCareer()] then
              local careerKey = auto_career[0]
            end
            if careerKey ~= nil and maxCareerKey <= careerKey and dynGrid:GetGridNecessaryFormulaValue(roleAttrDics[dynHero.dataId]) then
              if maxCareerKey < careerKey then
                maxCareerKey = careerKey
              end
              -- DECOMPILER ERROR at PC261: Overwrote pending register: R27 in 'AssignReg'

              ;
              (table.insert)(R27_PC193, dynHero)
            end
          end
          if #validRoles == 0 then
            autoDeployListPool:PoolPut(validRoles)
          else
            local bestRole = nil
            if #validRoles > 1 then
              if dynGrid:GetAutoIsMax() then
                local bestValue = CommonUtil.Int64Min
                for _,dynHero in pairs(validRoles) do
                  -- DECOMPILER ERROR at PC288: Overwrote pending register: R27 in 'AssignReg'

                  R27_PC193 = R27_PC193(dynHero)
                  R27_PC193 = auto_career[R27_PC193]
                  if not R27_PC193 then
                    R27_PC193 = auto_career[0]
                    local careerKey = nil
                  end
                  if maxCareerKey <= careerKey then
                    local value = dynGrid:GetGridAttrFormulaValue(roleAttrDics[dynHero.dataId])
                    if bestValue < value then
                      bestValue = value
                      bestRole = dynHero
                    end
                  end
                end
              else
                do
                  local bestValue = CommonUtil.Int64Max
                  for _,dynHero in pairs(validRoles) do
                    if not auto_career[dynHero:GetCareer()] then
                      local careerKey = auto_career[0]
                    end
                    if maxCareerKey <= careerKey then
                      local value = dynGrid:GetGridAttrFormulaValue(roleAttrDics[dynHero.dataId])
                      if value < bestValue then
                        bestValue = value
                        bestRole = dynHero
                      end
                    end
                  end
                  do
                    bestRole = validRoles[1]
                    if bestRole == nil then
                      error("DeployTeamUtil.AutoBattleDeploy get bestRole is null!")
                      autoDeployListPool:PoolPut(validRoles)
                    else
                      for index,dynHero in pairs(roles) do
                        if dynHero == bestRole then
                          (table.remove)(roles, R28_PC353)
                          break
                        end
                      end
                      do
                        do
                          bestRole:SetCoord(dynGrid.coord, benchX)
                          succCoordDic[dynGrid.coord] = bestRole
                          autoDeployListPool:PoolPut(validRoles)
                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out DO_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out DO_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out DO_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_THEN_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_THEN_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_THEN_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                          -- DECOMPILER ERROR at PC367: LeaveBlock: unexpected jumping out IF_STMT

                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
  local conflictRoles = autoDeployListPool:PoolGet()
  for k,dynHero in pairs(benchRoles) do
    local curHero = succCoordDic[dynHero.coord]
    if curHero == nil then
      succCoordDic[dynHero.coord] = dynHero
    else
      if curHero ~= dynHero then
        (table.insert)(conflictRoles, dynHero)
      end
    end
  end
  local index = 1
  for k,role in pairs(conflictRoles) do
    local coord = nil
    repeat
      coord = (BattleUtil.XYCoord2Pos)(benchX, banchPosArray[index])
      index = index + 1
    until succCoordDic[coord] == nil
    role:SetCoord(coord, benchX)
  end
  autoDeployListPool:PoolPut(conflictRoles)
  if deployStage then
    local longRangeRoles = autoDeployListPool:PoolGet()
    local defendRoles = autoDeployListPool:PoolGet()
    for k,dynHero in pairs(stageRoles) do
      local curHero = succCoordDic[dynHero.coord]
      if curHero == nil then
        succCoordDic[dynHero.coord] = dynHero
      else
        if curHero ~= dynHero then
          if dynHero.attackRange <= 1 then
            (table.insert)(defendRoles, dynHero)
          else
            ;
            (table.insert)(longRangeRoles, dynHero)
          end
        end
      end
    end
    local mapDeployX = deploy_rows
    local mapSizeY = size_col
    if #defendRoles > 0 then
      for x = mapDeployX - 1, 0, -1 do
        for y = 0, mapSizeY - 1 do
          if #defendRoles ~= 0 then
            local coord = (BattleUtil.XYCoord2Pos)(x, y)
            do
              if succCoordDic[coord] == nil then
                local role = (table.remove)(defendRoles)
                succCoordDic[coord] = role
                role:SetCoordXY(x, y, benchX)
              end
              -- DECOMPILER ERROR at PC489: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC489: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
    do
      if #longRangeRoles > 0 then
        for x = 0, mapDeployX - 1 do
          for y = 0, mapSizeY - 1 do
            if #longRangeRoles ~= 0 then
              local coord = (BattleUtil.XYCoord2Pos)(x, y)
              do
                if succCoordDic[coord] == nil then
                  local role = (table.remove)(longRangeRoles)
                  succCoordDic[coord] = role
                  -- DECOMPILER ERROR at PC518: Overwrote pending register: R28 in 'AssignReg'

                  role:SetCoordXY(x, y, benchX)
                end
                -- DECOMPILER ERROR at PC523: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC523: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
      do
        do
          autoDeployListPool:PoolPut(longRangeRoles)
          autoDeployListPool:PoolPut(defendRoles)
          autoDeployListPool:PoolPut(benchRoles)
          autoDeployListPool:PoolPut(stageRoles)
        end
      end
    end
  end
end

local careerSortList = {1, 3, 4, 2, 5}
DeployTeamUtil.BattleSpecilDeploy = function(roomData, heroList, benchX)
  -- function num : 0_6 , upvalues : autoDeployListPool, _ENV, careerSortList, banchPosArray, DeployTeamUtil
  local deployGridWeightDic = {}
  local deployGridList = autoDeployListPool:PoolGet()
  for x,tab in pairs((roomData.roomSpecialDeployCfg).deployGridDic) do
    for y,_ in pairs(tab) do
      local coord = (BattleUtil.XYCoord2Pos)(x, y)
      deployGridWeightDic[coord] = 0
      ;
      (table.insert)(deployGridList, coord)
    end
  end
  for k,dynMonster in ipairs(roomData.monsterList) do
    if dynMonster.cat == (BattleUtil.battleRoleCat).monster and not dynMonster:IsStageMonster() then
      local coord = (BattleUtil.XYCoord2Pos)(dynMonster.targetDeployPosX, dynMonster.targetDeployPosY)
      if deployGridWeightDic[coord] == nil then
        error("monster\'s target delpoy pos is nil, monsterId:" .. tostring(dynMonster.dataId))
      else
        deployGridWeightDic[coord] = deployGridWeightDic[coord] + 1
      end
    end
  end
  ;
  (table.sort)(deployGridList, function(a, b)
    -- function num : 0_6_0 , upvalues : deployGridWeightDic
    if deployGridWeightDic[b] >= deployGridWeightDic[a] then
      do return deployGridWeightDic[a] == deployGridWeightDic[b] end
      do return a < b end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  local benchRoles = autoDeployListPool:PoolGet()
  local careerHeroDic = {}
  for k,dynHero in ipairs(heroList) do
    if dynHero.onBench then
      (table.insert)(benchRoles, dynHero)
    else
      local career = dynHero:GetCareer()
      if not careerHeroDic[career] then
        do
          careerHeroDic[career] = autoDeployListPool:PoolGet()
          ;
          (table.insert)(careerHeroDic[career], dynHero)
          -- DECOMPILER ERROR at PC99: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC99: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC99: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC99: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  for k,career in ipairs(careerSortList) do
    local heroList = careerHeroDic[career]
    if heroList ~= nil then
      for k2,dynHero in ipairs(heroList) do
        if #deployGridList == 0 then
          (table.insert)(benchRoles, dynHero)
        else
          local coord = (table.remove)(deployGridList, 1)
          local x, y = (BattleUtil.Pos2XYCoord)(coord)
          dynHero:SetCoordXY(x, y, benchX)
        end
      end
    end
  end
  if #banchPosArray < #benchRoles then
    error("bench hero num above bench num!!! pls check map config")
  end
  ;
  (DeployTeamUtil._DeloyBenchHero)(benchRoles, benchX)
  for k,list in pairs(careerHeroDic) do
    autoDeployListPool:PoolPut(list)
  end
  autoDeployListPool:PoolPut(deployGridList)
  autoDeployListPool:PoolPut(benchRoles)
end

return DeployTeamUtil

