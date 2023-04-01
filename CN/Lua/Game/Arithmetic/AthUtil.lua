-- params : ...
-- function num : 0 , upvalues : _ENV
local AthUtil = {}
local ATHEnum = require("Game.Arithmetic.ArthmeticEnum")
AthUtil.AthGridSize = (Vector2.New)(4, 4)
AthUtil.AthUseGridList = {1, 2, 5, 6, 9, 10, 13, 14}
AthUtil.AthUseGridDic = {}
for k,v in ipairs(AthUtil.AthUseGridList) do
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R7 in 'UnsetPending'

  (AthUtil.AthUseGridDic)[v] = true
end
AthUtil.GetAthGridIdList = function(athData, pos)
  -- function num : 0_0 , upvalues : AthUtil
  local athSize = athData:GetAthSize()
  return (AthUtil.GetAthGridIdListBySize)(athSize, pos)
end

AthUtil.GetAthGridIdListBySize = function(athSize, pos)
  -- function num : 0_1 , upvalues : AthUtil, _ENV
  local sizeX = (AthUtil.AthGridSize).x
  local gridIdList = {pos}
  if athSize == 2 then
    local gridId = pos + sizeX
    ;
    (table.insert)(gridIdList, gridId)
  else
    do
      if athSize == 4 then
        for i = 0, 1 do
          local gridId = nil
          if i ~= 0 then
            gridId = pos + i
            ;
            (table.insert)(gridIdList, gridId)
          end
          gridId = pos + i + sizeX
          ;
          (table.insert)(gridIdList, gridId)
        end
      else
        do
          if athSize == 8 then
            for i = 0, 1 do
              for j = 0, 3 do
                if i ~= 0 or j ~= 0 then
                  local gridId = pos + i + sizeX * j
                  ;
                  (table.insert)(gridIdList, gridId)
                end
              end
            end
          end
          do
            return gridIdList
          end
        end
      end
    end
  end
end

local sortedSuitUidListDic = nil
AthUtil.OnekeyInstallAthArea = function(heroData, slotId, space, maxSpace, areaGridData)
  -- function num : 0_2 , upvalues : sortedSuitUidListDic, _ENV, AthUtil
  sortedSuitUidListDic = {}
  local freeSpace = (heroData:GetAthSlotList())[slotId]
  areaGridData:InitAthAreaGridData(heroData, space, maxSpace, true)
  local onekeyInstallDic = {}
  local onekeyInstallList = {}
  local slotUninstalledAthList = (PlayerDataCenter.allAthData):GetAllAthSlotList(slotId, nil, true, heroData.dataId)
  local slotUninstalledAthDic = {}
  local athDataList = {}
  local athDic = {}
  local existSuitDic = {}
  for k,athData in ipairs(slotUninstalledAthList) do
    slotUninstalledAthDic[athData.uid] = athData
    local suitId, suitCfltId = athData:GetAthSuit()
    if suitId ~= 0 then
      local existSuit = existSuitDic[suitId]
      if existSuit == nil then
        existSuit = {
suitDic = {}
, 
suitMaxQualityDic = {}
, num = 0}
        existSuitDic[suitId] = existSuit
      end
      local suitAthList = (existSuit.suitDic)[suitCfltId]
      if suitAthList == nil then
        suitAthList = {}
        existSuit.num = existSuit.num + 1
        -- DECOMPILER ERROR at PC56: Confused about usage of register: R22 in 'UnsetPending'

        ;
        (existSuit.suitDic)[suitCfltId] = suitAthList
      end
      ;
      (table.insert)(suitAthList, athData)
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R22 in 'UnsetPending'

      if athData:GetAthQuality() == eItemQualityType.Orange then
        (existSuit.suitMaxQualityDic)[suitCfltId] = true
      end
    end
  end
  local existSuit3DicNum = 0
  local existSuit2DicNum = 0
  local existSuit3Dic = {}
  local existSuit2Dic = {}
  for suitId,existSuit in pairs(existSuitDic) do
    if existSuit.num == 3 then
      existSuit3Dic[suitId] = existSuit
      existSuit3DicNum = existSuit3DicNum + 1
    else
      if existSuit.num == 2 then
        existSuit2Dic[suitId] = existSuit
        existSuit2DicNum = existSuit2DicNum + 1
      end
    end
  end
  local findSuitInstallFunc = function(propertyLv)
    -- function num : 0_2_0 , upvalues : freeSpace, existSuit3DicNum, AthUtil, existSuit3Dic, heroData, onekeyInstallList, onekeyInstallDic, slotUninstalledAthDic, existSuit2DicNum, _ENV, existSuit2Dic
    while 1 do
      if freeSpace >= 6 and existSuit3DicNum > 0 then
        local firstSuitId, firstExistSuit = nil, nil
        if propertyLv == 1 then
          firstSuitId = (AthUtil._FindFirstSuitId1)(existSuit3Dic, heroData)
        else
          -- DECOMPILER ERROR at PC20: Overwrote pending register: R2 in 'AssignReg'

          firstSuitId = (AthUtil._FindFirstSuitId2)(existSuit3Dic, heroData)
        end
        if firstSuitId ~= nil then
          do
            freeSpace = (AthUtil._InstallSuit)(firstExistSuit, heroData, onekeyInstallList, onekeyInstallDic, freeSpace, slotUninstalledAthDic, 3)
            existSuit3DicNum = existSuit3DicNum - 1
            existSuit3Dic[firstSuitId] = nil
            -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC38: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    while 1 do
      while 1 do
        if freeSpace >= 4 and (existSuit2DicNum > 0 or existSuit3DicNum > 0) then
          local firstSuitId = nil
          -- DECOMPILER ERROR at PC49: Overwrote pending register: R2 in 'AssignReg'

          local maxQualityNum = firstExistSuit
          local firstExistSuit = nil
          if existSuit3DicNum > 0 then
            if propertyLv == 1 then
              firstSuitId = (AthUtil._FindFirstSuitId1)(existSuit3Dic, heroData)
              -- DECOMPILER ERROR at PC68: Overwrote pending register: R2 in 'AssignReg'

            else
              -- DECOMPILER ERROR at PC74: Overwrote pending register: R3 in 'AssignReg'

              firstSuitId = (AthUtil._FindFirstSuitId2)(existSuit3Dic, heroData)
            end
          end
          -- DECOMPILER ERROR at PC88: Overwrote pending register: R3 in 'AssignReg'

          if existSuit2DicNum > 0 then
            if propertyLv == 1 then
              firstSuitId = (AthUtil._FindFirstSuitId1)(existSuit2Dic, heroData, firstSuitId, firstExistSuit, maxQualityNum)
            else
              -- DECOMPILER ERROR at PC97: Overwrote pending register: R3 in 'AssignReg'

              firstSuitId = (AthUtil._FindFirstSuitId2)(existSuit2Dic, heroData, firstSuitId, firstExistSuit)
            end
          end
          if existSuit3Dic[firstSuitId] == nil then
            local isSuit3 = firstSuitId == nil
            freeSpace = (AthUtil._InstallSuit)(firstExistSuit, heroData, onekeyInstallList, onekeyInstallDic, freeSpace, slotUninstalledAthDic, 2)
            if isSuit3 then
              existSuit3DicNum = existSuit3DicNum - 1
              existSuit3Dic[firstSuitId] = nil
              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC122: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
      existSuit2Dic[firstSuitId] = nil
      existSuit2DicNum = existSuit2DicNum - 1
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end

  findSuitInstallFunc(1)
  findSuitInstallFunc(2)
  local athInstallDic = (AthUtil._fillEmptySpace)(onekeyInstallList, freeSpace, areaGridData, slotId, slotUninstalledAthDic, heroData)
  if athInstallDic ~= nil then
    local _, oldAthDic = (PlayerDataCenter.allAthData):GetHeroAthList(heroData.dataId, slotId)
    if (table.count)(athInstallDic) == (table.count)(oldAthDic) then
      local allSame = true
      for uid,athData in pairs(oldAthDic) do
        if athInstallDic[uid] == nil then
          allSame = false
          break
        end
      end
      do
        do
          if allSame then
            return nil
          end
          return athInstallDic
        end
      end
    end
  end
end

AthUtil._FindFirstSuitId1 = function(existSuitDic, heroData, firstSuitId, firstExistSuit, maxQualityNum)
  -- function num : 0_3 , upvalues : _ENV, AthUtil
  if not maxQualityNum then
    maxQualityNum = 0
  end
  local heroCfg = heroData.heroCfg
  for suitId,existSuit in pairs(existSuitDic) do
    if (heroCfg.recommendSuitDic)[suitId] ~= nil then
      local curNum = (table.count)(existSuit.suitMaxQualityDic)
      if firstSuitId == nil then
        firstSuitId = suitId
        maxQualityNum = curNum
        firstExistSuit = existSuit
      else
        if maxQualityNum < curNum then
          firstSuitId = suitId
          maxQualityNum = curNum
          firstExistSuit = existSuit
        else
          if curNum == maxQualityNum then
            local wA, wB = AthUtil:_SuitWeightCompare(firstExistSuit.suitDic, existSuit.suitDic, heroData)
            -- DECOMPILER ERROR at PC40: Unhandled construct in 'MakeBoolean' P1

            if wA ~= wB and wA < wB then
              firstSuitId = suitId
              firstExistSuit = existSuit
            end
          end
        end
      end
    end
    local firstSuitPriority = (heroCfg.priority2_suit_dic)[firstSuitId]
    local curSuitPriority = (heroCfg.priority2_suit_dic)[suitId]
    if curSuitPriority < firstSuitPriority or firstSuitPriority == curSuitPriority and suitId < firstSuitId then
      firstSuitId = suitId
      firstExistSuit = existSuit
    end
  end
  return firstSuitId, firstExistSuit, maxQualityNum
end

AthUtil._FindFirstSuitId2 = function(existSuitDic, heroData, firstSuitId, firstExistSuit)
  -- function num : 0_4 , upvalues : _ENV, AthUtil
  local heroCfg = heroData.heroCfg
  for suitId,existSuit in pairs(existSuitDic) do
    if firstSuitId == nil then
      firstSuitId = suitId
      firstExistSuit = existSuit
    else
      local wA, wB = AthUtil:_SuitWeightCompare(firstExistSuit.suitDic, existSuit.suitDic, heroData)
      -- DECOMPILER ERROR at PC20: Unhandled construct in 'MakeBoolean' P1

      if wA ~= wB and wA < wB then
        firstSuitId = suitId
        firstExistSuit = existSuit
      end
    end
    if not (heroCfg.priority2_suit_dic)[firstSuitId] then
      local firstSuitPriority = math.maxinteger
    end
    if not (heroCfg.priority2_suit_dic)[suitId] then
      local curSuitPriority = math.maxinteger
    end
    if curSuitPriority < firstSuitPriority or firstSuitPriority == curSuitPriority and suitId < firstSuitId then
      firstSuitId = suitId
      firstExistSuit = existSuit
    end
  end
  return firstSuitId, firstExistSuit
end

AthUtil._SuitWeightCompare = function(self, suitDicA, suitDicB, heroData)
  -- function num : 0_5 , upvalues : ATHEnum, sortedSuitUidListDic, AthUtil
  local weightA, weightB = 0, 0
  for i = 1, ATHEnum.AthSuitConflictMax do
    local athListA = suitDicA[i]
    local athListB = suitDicB[i]
    if athListA ~= nil or athListB ~= nil then
      if athListA == nil and athListB ~= nil then
        weightB = weightB + 1
      else
        if athListA ~= nil and athListB == nil then
          weightA = weightA + 1
        else
          if sortedSuitUidListDic[athListA] == nil then
            (AthUtil._AthUidListSort)(athListA, heroData)
          end
          if sortedSuitUidListDic[athListB] == nil then
            (AthUtil._AthUidListSort)(athListB, heroData)
          end
          local firstAthA = athListA[1]
          local firstAthB = athListB[1]
          if (AthUtil._AthSortFunc)(firstAthA, firstAthB, heroData) then
            weightA = weightA + 1
          else
            weightB = weightB + 1
          end
        end
        do
          -- DECOMPILER ERROR at PC51: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC51: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC51: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC51: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  return weightA, weightB
end

AthUtil._InstallSuit = function(firstExistSuit, heroData, onekeyInstallList, onekeyInstallDic, freeSpace, slotUninstalledAthDic, installNum)
  -- function num : 0_6 , upvalues : _ENV, sortedSuitUidListDic, AthUtil
  local curNum = 0
  local athList = {}
  for suitCflsuittId,suitAthList in pairs(firstExistSuit.suitDic) do
    if sortedSuitUidListDic[suitAthList] == nil then
      (AthUtil._AthUidListSort)(suitAthList, heroData)
    end
    ;
    (table.insert)(athList, suitAthList[1])
  end
  ;
  (AthUtil._AthUidListSort)(athList, heroData)
  for k,athData in ipairs(athList) do
    freeSpace = AthUtil:_InstallAthData(athData, onekeyInstallList, onekeyInstallDic, freeSpace, slotUninstalledAthDic)
    curNum = curNum + 1
  end
  do
    if installNum > curNum then
      return freeSpace
    end
  end
end

AthUtil._InstallAthData = function(self, athData, onekeyInstallList, onekeyInstallDic, freeSpace, slotUninstalledAthDic)
  -- function num : 0_7 , upvalues : _ENV
  (table.insert)(onekeyInstallList, athData)
  onekeyInstallDic[athData.uid] = athData
  freeSpace = freeSpace - athData:GetAthSize()
  slotUninstalledAthDic[athData.uid] = nil
  return freeSpace
end

AthUtil._fillEmptySpace = function(tryInstallAthList, freeSpace, areaGridData, slotId, slotUninstalledAthDic, heroData)
  -- function num : 0_8 , upvalues : _ENV, AthUtil
  local slotUninstalledAthList = {}
  if freeSpace > 0 then
    for uid,athData in pairs(slotUninstalledAthDic) do
      (table.insert)(slotUninstalledAthList, athData)
    end
    ;
    (AthUtil._AthUidListSort)(slotUninstalledAthList, heroData)
  end
  local tryInstallIdDic = {}
  local tryInstallSuitDic = {}
  if tryInstallAthList == nil then
    tryInstallAthList = {}
  else
    for k,athData in ipairs(tryInstallAthList) do
      tryInstallIdDic[athData.id] = true
      local suitId, cfltId = athData:GetAthSuit()
      if suitId ~= 0 then
        if not tryInstallSuitDic[suitId] then
          do
            tryInstallSuitDic[suitId] = {}
            -- DECOMPILER ERROR at PC41: Confused about usage of register: R16 in 'UnsetPending'

            ;
            (tryInstallSuitDic[suitId])[cfltId] = true
            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  for k,athData in ipairs(slotUninstalledAthList) do
    if freeSpace > 0 then
      local athSize = athData:GetAthSize()
      local suitId, cfltId = athData:GetAthSuit()
      if athSize <= freeSpace and tryInstallIdDic[athData.id] == nil and (tryInstallSuitDic[suitId] == nil or (tryInstallSuitDic[suitId])[cfltId] == nil) then
        (table.insert)(tryInstallAthList, athData)
        tryInstallIdDic[athData.id] = true
        if suitId ~= 0 then
          if not tryInstallSuitDic[suitId] then
            do
              tryInstallSuitDic[suitId] = {}
              -- DECOMPILER ERROR at PC82: Confused about usage of register: R17 in 'UnsetPending'

              ;
              (tryInstallSuitDic[suitId])[cfltId] = true
              freeSpace = freeSpace - athSize
              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

              -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

            end
          end
        end
      end
    end
  end
  local athInstallDic, athInstalledDic = areaGridData:AutoSortAthTable(tryInstallAthList)
  if athInstallDic == nil then
    return 
  end
  local isEqual = true
  for k,v in pairs(athInstallDic) do
    if athInstalledDic[k] ~= v then
      isEqual = false
      break
    end
  end
  do
    if isEqual then
      return 
    end
    return athInstallDic
  end
end

AthUtil._AthUidListSort = function(athDataList, heroData)
  -- function num : 0_9 , upvalues : _ENV, AthUtil
  (table.sort)(athDataList, function(athDataA, athDataB)
    -- function num : 0_9_0 , upvalues : AthUtil, heroData
    return (AthUtil._AthSortFunc)(athDataA, athDataB, heroData)
  end
)
end

AthUtil._AthSortFunc = function(athDataA, athDataB, heroData)
  -- function num : 0_10 , upvalues : AthUtil
  local mainAttrPriorityA = (AthUtil.GetHeroAthMainAttrPriority)(heroData, athDataA)
  local mainAttrPriorityB = (AthUtil.GetHeroAthMainAttrPriority)(heroData, athDataB)
  local qulityA = athDataA:GetAthQuality()
  local qulityB = athDataB:GetAthQuality()
  local subAttrPriorityA, subAttrQualityA = (AthUtil.GetHeroAthSubAttrPriority)(heroData, athDataA)
  local subAttrPriorityB, subAttrQualityB = (AthUtil.GetHeroAthSubAttrPriority)(heroData, athDataB)
  if qulityB >= qulityA then
    do return qulityA == qulityB end
    if mainAttrPriorityA >= mainAttrPriorityB then
      do return mainAttrPriorityA == mainAttrPriorityB end
      if subAttrPriorityA >= subAttrPriorityB then
        do return subAttrPriorityA == subAttrPriorityB end
        if subAttrQualityB >= subAttrQualityA then
          do return subAttrQualityA == subAttrQualityB end
          do return athDataA.athTs < athDataB.athTs end
          -- DECOMPILER ERROR: 9 unprocessed JMP targets
        end
      end
    end
  end
end

AthUtil.GetHeroAthMainAttrPriority = function(heroData, athData)
  -- function num : 0_11
  local mainAttrId = ((athData.athMainAttrCfg).attrtibute_id)[1]
  local mainAttrPriority = ((heroData.heroCfg).priority_main_attribute_dic)[mainAttrId]
  if mainAttrPriority == nil then
    return 1000
  end
  return mainAttrPriority
end

local subAttrQulityWeightDic = {[eItemQualityType.White] = 1, [eItemQualityType.Blue] = 2, [eItemQualityType.Purple] = 4, [eItemQualityType.Orange] = 6}
AthUtil.GetHeroAthSubAttrPriority = function(heroData, athData)
  -- function num : 0_12 , upvalues : _ENV, subAttrQulityWeightDic
  local highestPriority = 1000
  local subQualityWeight = 0
  local areaId = athData:GetAthAreaType()
  local cfgName = "priority_sub_attribute" .. tostring(areaId) .. "_dic"
  for k,affixElem in ipairs(athData.affixList) do
    local curQuality = subAttrQulityWeightDic[affixElem.quality]
    if curQuality == nil then
      error("Unsurpported quality:" .. tostring(affixElem.quality))
      curQuality = 0
    end
    subQualityWeight = subQualityWeight + curQuality
    local cfg = (ConfigData.ath_affix_pool)[affixElem.id]
    if cfg == nil then
      error("Can\'t find ath_affix_pool, id = " .. tostring(affixElem.id))
    else
      local attrId = cfg.affix_para
      local subAttrPriority = ((heroData.heroCfg)[cfgName])[attrId]
      if subAttrPriority ~= nil and subAttrPriority < highestPriority then
        highestPriority = subAttrPriority
      end
    end
  end
  return highestPriority, subQualityWeight
end

AthUtil.ShowATHInfoFunc = function()
  -- function num : 0_13 , upvalues : _ENV
  local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
  ;
  (GuidePicture.OpenGuidePicture)(PicTipsConsts.ATH, nil)
end

AthUtil.ShowAthRefactorSuccess = function(athData, heroData, onShowFunc)
  -- function num : 0_14 , upvalues : _ENV
  if #(PlayerDataCenter.allAthData).athReconsitutionDataList <= 1 or not UIWindowTypeID.AthRefactorSuccessExtra then
    local winId = UIWindowTypeID.AthRefactorSuccess
  end
  UIManager:ShowWindowAsync(winId, function(window)
    -- function num : 0_14_0 , upvalues : athData, heroData, onShowFunc
    if window == nil then
      return 
    end
    window:InitAthRefactorSuccess(athData, heroData)
    if onShowFunc ~= nil then
      onShowFunc()
    end
  end
)
end

return AthUtil

