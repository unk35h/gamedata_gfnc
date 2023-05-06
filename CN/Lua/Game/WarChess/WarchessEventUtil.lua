-- params : ...
-- function num : 0 , upvalues : _ENV
local WarchessEventUtil = {}
WarchessEventUtil.DealEventDataByMsg = function(self, eventSystemData)
  -- function num : 0_0 , upvalues : _ENV
  local eventCfg = (ConfigData.warchess_event)[eventSystemData.eventId]
  local choiceDatas = {}
  for index,choiceId in ipairs(eventSystemData.choices) do
    local choiceData = {index = index - 1, couldChoice = (eventSystemData.choiceApply)[index], choiceCfg = (ConfigData.warchess_event_choice)[choiceId]}
    if choiceData.choiceCfg == nil then
      error("choice cfg not exist choiceId:" .. tostring(choiceId))
      return 
    end
    ;
    (table.insert)(choiceDatas, choiceData)
  end
  return eventCfg, choiceDatas
end

WarchessEventUtil.ApplyWcEventInBattle = function(self, eventId, isBeforeBattle, selectFunc, exitFunc)
  -- function num : 0_1 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local teamData = (wcCtrl.battleCtrl):GetCurSelectedTeamData()
  local wid, tid = (wcCtrl.teamCtrl):GetWCTeamIdentify(teamData)
  local identify = {wid = wid, tid = tid}
  ;
  (wcCtrl.wcNetworkCtrl):CS_WarChess_EventInBattle(identify, eventId, isBeforeBattle, function(args)
    -- function num : 0_1_0 , upvalues : self, _ENV, wcCtrl, identify, selectFunc, exitFunc
    if args.Count <= 0 then
      return 
    end
    local eventSystemData = args[0]
    local eventCfg, choiceDatas = self:DealEventDataByMsg(eventSystemData)
    UIManager:ShowWindowAsync(UIWindowTypeID.WarChessEvent, function(win)
      -- function num : 0_1_0_0 , upvalues : eventCfg, choiceDatas, wcCtrl, identify, selectFunc, exitFunc
      if win == nil then
        return 
      end
      win:InitWCEventWithoutCtrl(eventCfg, choiceDatas, function(choiceData)
        -- function num : 0_1_0_0_0 , upvalues : wcCtrl, identify, win, selectFunc
        local index = choiceData.index
        ;
        (wcCtrl.wcNetworkCtrl):CS_WarChess_BattleSystem_ChoiceEvent(identify, index, function()
          -- function num : 0_1_0_0_0_0 , upvalues : win, selectFunc, index
          win:Delete()
          if selectFunc ~= nil then
            selectFunc(index)
          end
        end
)
      end
, function()
        -- function num : 0_1_0_0_1 , upvalues : win, exitFunc
        win:Delete()
        if exitFunc ~= nil then
          exitFunc()
        end
      end
)
    end
)
  end
)
end

return WarchessEventUtil

