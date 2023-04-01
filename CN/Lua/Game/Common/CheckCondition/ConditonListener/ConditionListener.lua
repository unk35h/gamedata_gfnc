-- params : ...
-- function num : 0 , upvalues : _ENV
local ConditionListener = class("ConditionListener")
local CheckerTypeId, CheckerGlobalConfig = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local ConditionListenerDic = {[CheckerTypeId.PlayerLevel] = require("Game.Common.CheckCondition.ConditonListener.Listener.PlayerLevelListerner"), [CheckerTypeId.CompleteTask] = require("Game.Common.CheckCondition.ConditonListener.Listener.CompleteTaskListerner"), [CheckerTypeId.CompleteStage] = require("Game.Common.CheckCondition.ConditonListener.Listener.CompleteStageListerner"), [CheckerTypeId.CompleteAvg] = require("Game.Common.CheckCondition.ConditonListener.Listener.CompleteAvgListerner"), [CheckerTypeId.MinHeroStar] = require("Game.Common.CheckCondition.ConditonListener.Listener.HeroMinRankListener"), [CheckerTypeId.TimeRange] = require("Game.Common.CheckCondition.ConditonListener.Listener.TimeRangeListerner"), [CheckerTypeId.CharDungeonConsume] = require("Game.Common.CheckCondition.ConditonListener.Listener.CharDungeonConsumeListerner"), [CheckerTypeId.PlayerReturn] = require("Game.Common.CheckCondition.ConditonListener.Listener.PlayerReturnListerner"), [CheckerTypeId.ActivityOpen] = require("Game.Common.CheckCondition.ConditonListener.Listener.ActivityOpenListerner"), [CheckerTypeId.SectorStagePassTm] = require("Game.Common.CheckCondition.ConditonListener.Listener.SectorUnlockPassTimeListerner")}
ConditionListener.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__listeningConditonDic = {}
  self.__dataListDic = {}
  self.__runningFuncDic = {}
  self.__onConditonStateChange = BindCallback(self, self.OnConditonStateChange)
  self.__removeCCLSingleConditon = BindCallback(self, self.RemoveCCLSingleConditon)
end

ConditionListener.AddConditionChangeListener = function(self, listenerId, callback, ...)
  -- function num : 0_1 , upvalues : _ENV
  if (self.__listeningConditonDic)[listenerId] ~= nil then
    error("can\'t set same condition listernerId:" .. tonumber(listenerId))
    return 
  end
  local conditonTypeDic, curIsUnlock = self:__AddConditionInternal(listenerId, ...)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.__listeningConditonDic)[listenerId] = {callback = callback, conditonTypeDic = conditonTypeDic, curIsUnlock = curIsUnlock}
  self:__OnAddConditonOver(conditonTypeDic)
end

ConditionListener.RemoveConditionChangeListener = function(self, listenerId)
  -- function num : 0_2 , upvalues : _ENV
  local removeConditonData = (self.__listeningConditonDic)[listenerId]
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__listeningConditonDic)[listenerId] = nil
  if removeConditonData ~= nil then
    for conditonTypeId,_ in pairs(removeConditonData.conditonTypeDic) do
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R8 in 'UnsetPending'

      if (self.__dataListDic)[conditonTypeId] ~= nil then
        ((self.__dataListDic)[conditonTypeId])[listenerId] = nil
        -- DECOMPILER ERROR at PC25: Confused about usage of register: R8 in 'UnsetPending'

        if (table.count)((self.__dataListDic)[conditonTypeId]) < 1 then
          (self.__dataListDic)[conditonTypeId] = nil
          if (self.__runningFuncDic)[conditonTypeId] ~= nil then
            ((self.__runningFuncDic)[conditonTypeId]):Delete()
            -- DECOMPILER ERROR at PC35: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (self.__runningFuncDic)[conditonTypeId] = nil
          end
        end
      end
    end
    self:__OnAddConditonOver(removeConditonData.conditonTypeDic)
  end
end

ConditionListener.OnConditonStateChange = function(self, updateConditonTypeId)
  -- function num : 0_3 , upvalues : _ENV, CheckerGlobalConfig
  local conditionDataListDic = (self.__dataListDic)[updateConditonTypeId]
  if conditionDataListDic ~= nil then
    for listenerId,conditionDataList in pairs(conditionDataListDic) do
      local isUnlock = true
      for index,paramGoup in ipairs(conditionDataList) do
        local conditonTypeId = paramGoup[1]
        local checker = CheckerGlobalConfig[conditonTypeId]
        local isThisConditonUnlock = ((checker.Checker).ParamsCheck)(paramGoup)
        if isUnlock then
          isUnlock = isThisConditonUnlock
        end
      end
      local listenerData = (self.__listeningConditonDic)[listenerId]
      if listenerData.curIsUnlock ~= isUnlock then
        listenerData.curIsUnlock = isUnlock
        ;
        (listenerData.callback)(listenerId, isUnlock)
      end
    end
    local condition = (self.__runningFuncDic)[updateConditonTypeId]
    if condition ~= nil and condition.CheckOutTimeCondition ~= nil then
      condition:CheckOutTimeCondition(conditionDataListDic)
    end
  end
  do
    self:__OnAddConditonOver({[updateConditonTypeId] = true})
  end
end

ConditionListener.__AddConditionInternal = function(self, listenerId, ...)
  -- function num : 0_4 , upvalues : _ENV, CheckerGlobalConfig
  local paramNum = select("#", ...)
  if paramNum == 0 then
    print("[CheckCondition] not args")
    return 
  end
  local para1 = select(1, ...)
  local length = #para1
  for i = 2, paramNum do
    local para = select(i, ...)
    local len = #para
    if len > 0 and len ~= length then
      print("[CheckCondition] args length is different")
      return 
    end
  end
  local conditonTypeDic = {}
  local curIsUnlock = true
  for i = 1, length do
    local index = 1
    local paramGoup = {}
    for paraIndex = 1, paramNum do
      local para = select(paraIndex, ...)
      if #para > 0 then
        paramGoup[index] = para[i]
        index = index + 1
      end
    end
    local conditonTypeId = paramGoup[1]
    local checker = CheckerGlobalConfig[conditonTypeId]
    if checker == nil then
      error("Checker is nil  id:" .. tostring(conditonTypeId))
      return 
    end
    if not ((checker.Checker).LengthCheck)(paramGoup) then
      error("Checker LengthCheck error id:" .. tostring(conditonTypeId))
      return 
    end
    if curIsUnlock and curIsUnlock then
      curIsUnlock = ((checker.Checker).ParamsCheck)(paramGoup)
    end
    -- DECOMPILER ERROR at PC97: Confused about usage of register: R15 in 'UnsetPending'

    if (self.__dataListDic)[conditonTypeId] == nil then
      (self.__dataListDic)[conditonTypeId] = {}
    end
    -- DECOMPILER ERROR at PC106: Confused about usage of register: R15 in 'UnsetPending'

    if ((self.__dataListDic)[conditonTypeId])[listenerId] == nil then
      ((self.__dataListDic)[conditonTypeId])[listenerId] = {}
    end
    ;
    (table.insert)(((self.__dataListDic)[conditonTypeId])[listenerId], paramGoup)
    conditonTypeDic[conditonTypeId] = true
  end
  return conditonTypeDic, curIsUnlock
end

ConditionListener.__OnAddConditonOver = function(self, conditonTypeDic)
  -- function num : 0_5 , upvalues : _ENV, ConditionListenerDic
  for conditonTypeId,_ in pairs(conditonTypeDic) do
    do
      if (self.__runningFuncDic)[conditonTypeId] == nil then
        local listener = ConditionListenerDic[conditonTypeId]
        -- DECOMPILER ERROR at PC14: Confused about usage of register: R8 in 'UnsetPending'

        if listener ~= nil then
          (self.__runningFuncDic)[conditonTypeId] = (listener.New)()
          ;
          ((self.__runningFuncDic)[conditonTypeId]):InitListener(self.__onConditonStateChange, self.__removeCCLSingleConditon)
        else
          error((string.format)("not have conditonTypeId:%s\'s listener class", tostring(conditonTypeId)))
        end
      end
      local funcInstance = (self.__runningFuncDic)[conditonTypeId]
      do
        local conditonDataList = (self.__dataListDic)[conditonTypeId]
        if conditonDataList == nil then
          return 
        end
        funcInstance:AddNewCondition(conditonDataList)
        -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
end

ConditionListener.RemoveCCLSingleConditon = function(self, conditonTypeId, listenerId, index)
  -- function num : 0_6 , upvalues : _ENV
  local dataList = ((self.__dataListDic)[conditonTypeId])[listenerId]
  if dataList == nil then
    return 
  end
  ;
  (table.remove)(dataList, index)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R5 in 'UnsetPending'

  if #dataList < 1 then
    ((self.__dataListDic)[conditonTypeId])[listenerId] = nil
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R5 in 'UnsetPending'

    if (table.count)((self.__dataListDic)[conditonTypeId]) < 1 then
      (self.__dataListDic)[conditonTypeId] = nil
      if (self.__runningFuncDic)[conditonTypeId] ~= nil then
        ((self.__runningFuncDic)[conditonTypeId]):Delete()
        -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

        ;
        (self.__runningFuncDic)[conditonTypeId] = nil
      end
    end
  end
end

ConditionListener.IsDuplicationKey = function(self, listenerId)
  -- function num : 0_7
  do return (self.__listeningConditonDic)[listenerId] ~= nil end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

ConditionListener.Delete = function(self)
  -- function num : 0_8 , upvalues : _ENV
  for _,funcInstance in pairs(self.__runningFuncDic) do
    funcInstance:Delete()
  end
  self.__runningFuncDic = {}
  self.__listeningConditonDic = {}
  self.__dataListDic = {}
end

return ConditionListener

