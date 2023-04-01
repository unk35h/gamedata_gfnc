-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessEventCtrl = class("WarChessEventCtrl", base)
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.Warchess.WarChessHelper")
local cs_MessageCommon = CS.MessageCommon
WarChessEventCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__eventSystemData = nil
  self.__identify = nil
  self.__eventCfg = nil
  self.__choiceDatas = nil
end

WarChessEventCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).event
end

WarChessEventCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV, eWarChessEnum
  if systemState == nil or systemState.eventSystemData == nil then
    error("not have data")
    return 
  end
  self.__eventSystemData = systemState.eventSystemData
  self.__identify = identify
  self.__systemPos = systemState.pos
  self:__DealEventData()
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessEvent, function(win)
    -- function num : 0_2_0 , upvalues : self, _ENV, eWarChessEnum
    if win == nil then
      return 
    end
    win:InitWCEvent(self)
    WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCEventEnter, self.__systemPos)
  end
)
end

WarChessEventCtrl.EnterNextWCEvent = function(self, eventSystemData)
  -- function num : 0_3 , upvalues : _ENV
  self.__eventSystemData = eventSystemData
  self:__DealEventData()
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessEvent, function(win)
    -- function num : 0_3_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitWCEvent(self)
  end
)
end

WarChessEventCtrl.__DealEventData = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local eventId = (self.__eventSystemData).eventId
  self.__eventCfg = (ConfigData.warchess_event)[eventId]
  self.__choiceDatas = {}
  for index,choiceId in ipairs((self.__eventSystemData).choices) do
    local choiceData = {index = index - 1, couldChoice = ((self.__eventSystemData).choiceApply)[index], choiceCfg = (ConfigData.warchess_event_choice)[choiceId]}
    if choiceData.choiceCfg == nil then
      error("choice cfg not exist choiceId:" .. tostring(choiceId))
      return 
    end
    ;
    (table.insert)(self.__choiceDatas, choiceData)
  end
end

WarChessEventCtrl.GetWCEventConfig = function(self)
  -- function num : 0_5
  return self.__eventCfg
end

WarChessEventCtrl.GetWCEventChoices = function(self)
  -- function num : 0_6
  return self.__choiceDatas
end

WarChessEventCtrl.WCEventSelect = function(self, choiceData)
  -- function num : 0_7 , upvalues : WarChessHelper
  local index = choiceData.index
  self._lastEventCfg = self.__eventCfg
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_EventSystem_Select(self.__identify, index, function()
    -- function num : 0_7_0 , upvalues : WarChessHelper, choiceData, self
    (WarChessHelper.AcquireOutSideBoxReward)((choiceData.choiceCfg).triggerActions, (self.wcCtrl).wcGlobalData)
    self:_OnEventSelectEnd(choiceData)
  end
)
end

local eventEndFuncDic = {[(eWarChessEnum.eWcEventId).EatPumpkin] = function(choiceData)
  -- function num : 0_8 , upvalues : _ENV, eWarChessEnum, cs_MessageCommon
  local costItemNum = nil
  for i,trigger in ipairs((choiceData.choiceCfg).triggerActions) do
    if (trigger.pms)[1] ~= 1 then
      local isReduce = trigger.cat ~= (eWarChessEnum.eTriggerType).ItemChange
      do
        if isReduce then
          local itemId = (trigger.pms)[2]
          if itemId == (eWarChessEnum.eItemId).Pumpkin then
            costItemNum = (trigger.pms)[3]
          end
        end
        -- DECOMPILER ERROR at PC27: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC27: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  if costItemNum == nil then
    return 
  end
  ;
  (cs_MessageCommon.ShowMessageTips)((string.format)(ConfigData:GetTipContent(8530), costItemNum))
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end
}
WarChessEventCtrl._OnEventSelectEnd = function(self, choiceData)
  -- function num : 0_9 , upvalues : eventEndFuncDic
  if self.__eventCfg and eventEndFuncDic[(self.__eventCfg).id] then
    (eventEndFuncDic[(self.__eventCfg).id])(choiceData)
  end
end

WarChessEventCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_10 , upvalues : base, _ENV, eWarChessEnum
  (base.CloseWCSubSystem)()
  local logicPos = self.__systemPos
  self:Exit()
  WarChessManager:QuickExeWCGuideActions((eWarChessEnum.wcGuideMomentType).WCEventExit, logicPos)
end

WarChessEventCtrl.Exit = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.WarChessEvent)
  self.__eventSystemData = nil
  self.__identify = nil
  self.__eventCfg = nil
  self.__choiceDatas = nil
  self.__systemPos = nil
end

WarChessEventCtrl.Delete = function(self)
  -- function num : 0_12
end

return WarChessEventCtrl

