-- params : ...
-- function num : 0 , upvalues : _ENV
local WCGuideUtil = {}
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local GuideActionType = {PlayGuide = 1, HideBattleRetreat = 2, AllowWcCamDrag = 3, SelectTeam = 4}
WCGuideUtil.GuideActionFunc = {[GuideActionType.PlayGuide] = function(guideAction)
  -- function num : 0_0 , upvalues : _ENV
  local guideCfg = (ConfigData.guide)[guideAction.action_args]
  if guideCfg.guide_type == 2 then
    GuideManager:StartNewTriggerGuide(guideAction.action_args)
  else
    GuideManager:StartNewGuide(guideAction.action_args)
  end
end
, [GuideActionType.HideBattleRetreat] = function(guideAction)
  -- function num : 0_1 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl == nil then
    return 
  end
  ;
  (wcCtrl.battleCtrl):SetWCAllowRetreatBattle(false)
end
, [GuideActionType.AllowWcCamDrag] = function(guideAction)
  -- function num : 0_2 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl == nil then
    return 
  end
  ;
  (wcCtrl.wcCamCtrl):AllowWcCamDrag(guideAction.action_args)
end
, [GuideActionType.SelectTeam] = function(guideAction)
  -- function num : 0_3 , upvalues : _ENV, eWarChessEnum
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  if wcCtrl == nil then
    return 
  end
  if wcCtrl.state ~= (eWarChessEnum.eWarChessState).play then
    return 
  end
  local teamIndex = (guideAction.action_args)[1]
  local curSelectedTeamData = (wcCtrl.curState):GetCurSelectedTeamData()
  if curSelectedTeamData == nil or curSelectedTeamData:GetWCTeamIndex() ~= teamIndex then
    local teamData = (wcCtrl.teamCtrl):GetTeamDataByTeamIndex(teamIndex)
    if teamData == nil then
      error("warchess can\'t select team by index:" .. tostring(teamIndex))
      return 
    end
    ;
    (wcCtrl.curState):WCPlayStateSelectTeam(teamData, true, true)
  end
end
}
WCGuideUtil.GetWCGuideActionsById = function(wcLevelId, moment, logicCoord, tipArg)
  -- function num : 0_4 , upvalues : _ENV, eWarChessEnum
  local wcGuideCfg = (ConfigData.warchess_guide)[wcLevelId]
  if wcGuideCfg == nil then
    return nil
  end
  local momentDicCfg = nil
  if (eWarChessEnum.wcGuideMomentGlobal)[moment] then
    momentDicCfg = wcGuideCfg.global
  else
    if logicCoord == nil then
      error("ExecuteWCGuideActions moment logic is null:" .. tostring(moment))
      return nil
    end
    momentDicCfg = wcGuideCfg[logicCoord]
  end
  if momentDicCfg == nil then
    return nil
  end
  local actionList = momentDicCfg[moment]
  if moment == (eWarChessEnum.wcGuideMomentType).WCTipPlayOver and actionList ~= nil then
    local actionList_temp = {}
    if tipArg ~= nil then
      for index,guide_config in ipairs(actionList) do
        local cat = (guide_config.action_moment_args)[1]
        local pm1 = (guide_config.action_moment_args)[2]
        if cat == nil or pm1 == nil then
          error("wc guide cfg error tip over guide arg is not enough wc_guideId:" .. tostring(guide_config.id))
        else
          local arg = cat << 32 | pm1
          if arg == tipArg then
            (table.insert)(actionList_temp, guide_config)
          end
        end
      end
    end
    do
      do
        actionList = actionList_temp
        return actionList
      end
    end
  end
end

WCGuideUtil.ExecuteWCGuideActions = function(actionList, battleCount)
  -- function num : 0_5 , upvalues : _ENV, WCGuideUtil
  if not battleCount then
    battleCount = 0
  end
  for _,guideAction in ipairs(actionList) do
    (WCGuideUtil.ExecuteWCGuideActionOne)(guideAction, battleCount)
  end
end

WCGuideUtil.ExecuteWCGuideActionOne = function(guideAction, battleCount)
  -- function num : 0_6 , upvalues : _ENV, WCGuideUtil
  if not battleCount then
    battleCount = 0
  end
  if guideAction.battle_count >= 0 and battleCount ~= guideAction.battle_count then
    return 
  end
  if guideAction.triggered_count > 0 then
    local globalData = WarChessManager:GetWCGlobalData()
    if globalData == nil then
      return 
    end
    local exeCount = globalData:GetWCGuideExeCount(guideAction.id)
    if guideAction.triggered_count <= exeCount then
      return 
    else
      globalData:SetWCGuideExeCount(guideAction.id, exeCount + 1)
    end
  end
  do
    local func = (WCGuideUtil.GuideActionFunc)[guideAction.action_type]
    if func == nil then
      error("no support wc guide action type:" .. tostring(guideAction.action_type))
    else
      func(guideAction)
    end
  end
end

return WCGuideUtil

