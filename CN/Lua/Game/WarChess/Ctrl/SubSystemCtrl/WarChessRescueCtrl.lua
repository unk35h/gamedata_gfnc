-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.Ctrl.SubSystemCtrl.Base.WarChessSubSystemCtrlBase")
local WarChessRescueCtrl = class("WarChessRescueCtrl", base)
local cs_MessageCommon = CS.MessageCommon
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
local WarChessHelper = require("Game.Warchess.WarChessHelper")
WarChessRescueCtrl.ctor = function(self, wcCtrl)
  -- function num : 0_0
  self.__rescueSystemData = nil
  self.__identify = nil
  self.__curTeamData = nil
  self.__couldReplaceHeroIdList = nil
  self.__couldReplaceHeroDataDic = nil
end

WarChessRescueCtrl.__GetWCSubSystemCat = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
  return (eWarChessEnum.eSystemCat).rescue
end

WarChessRescueCtrl.OpenWCSubSystem = function(self, systemState, identify)
  -- function num : 0_2 , upvalues : _ENV
  if systemState == nil or systemState.rescueSystemData == nil then
    error("not have data")
    return 
  end
  self.__rescueSystemData = systemState.rescueSystemData
  self.__identify = identify
  self.__curTeamData = ((self.wcCtrl).teamCtrl):GetTeamDataByTeamUid(identify.tid)
  local careerDic = {[(self.__rescueSystemData).career] = true}
  self:__GenCouldReplaceHeroIdList(careerDic)
  UIManager:ShowWindowAsync(UIWindowTypeID.EpSupportRoom, function(win)
    -- function num : 0_2_0 , upvalues : self
    if win == nil then
      return 
    end
    local dynPlayer = (self.__curTeamData):GetTeamDynPlayer()
    local supportHeroMixedList = self:GetWCCouldReplaceHeroDataDic()
    local cancleFunc = function()
      -- function num : 0_2_0_0 , upvalues : self
      self:CancelReplaceWCTeamHero()
    end

    local confirmFunc = function(enterIdList, quitHeroIdList)
      -- function num : 0_2_0_1 , upvalues : self
      self:ConfirmReplaceWCTeamHero(enterIdList, quitHeroIdList)
    end

    win:InitEpSurpportRoomForWC(dynPlayer, supportHeroMixedList, cancleFunc, confirmFunc)
  end
)
end

WarChessRescueCtrl.GetWCCouldReplaceHeroDataDic = function(self)
  -- function num : 0_3
  return self.__couldReplaceHeroDataDic
end

WarChessRescueCtrl.__GenCouldReplaceHeroIdList = function(self, careerDic)
  -- function num : 0_4 , upvalues : _ENV
  if not careerDic then
    careerDic = {}
  end
  local couldRescueHeroIdList = {}
  local couldRescueHeroDataDic = {}
  local curInUseHeroDic = {}
  for teamIndex,teamData in pairs(((self.wcCtrl).teamCtrl):GetWCTeams()) do
    local wcDynPlayer = teamData:GetTeamDynPlayer()
    for heroId,dynHeroData in pairs(wcDynPlayer.heroDic) do
      curInUseHeroDic[heroId] = true
    end
  end
  for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
    local career = heroData.career
    if careerDic[career] ~= nil then
      local usedDynHeroData = ((self.wcCtrl).teamCtrl):GetHeroDynDataById(heroId)
    end
    if usedDynHeroData ~= nil then
      if curInUseHeroDic[heroId] == nil or usedDynHeroData.hpPer <= 0 then
        do
          (table.insert)(couldRescueHeroIdList, heroId)
          couldRescueHeroDataDic[heroId] = usedDynHeroData
          usedDynHeroData.onBench = false
          ;
          (table.insert)(couldRescueHeroIdList, heroId)
          couldRescueHeroDataDic[heroId] = heroData
          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC63: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self.__couldReplaceHeroIdList = couldRescueHeroIdList
  self.__couldReplaceHeroDataDic = couldRescueHeroDataDic
end

WarChessRescueCtrl.ConfirmReplaceWCTeamHero = function(self, enterIdList, quitHeroIdList)
  -- function num : 0_5 , upvalues : _ENV, cs_MessageCommon
  local newHeroDic = {}
  local heroDic = (self.__curTeamData):GetWCTeamOrderDic()
  local removeDic = {}
  for _,heroId in pairs(quitHeroIdList) do
    removeDic[heroId] = true
  end
  local normalNum = ((ConfigData.formation_rule)[0]).stage_num
  local benchNum = ((ConfigData.formation_rule)[0]).bench_num
  local enterIndex = 1
  for heroIndex = 1, normalNum + benchNum do
    local curHeroId = heroDic[heroIndex]
    if curHeroId == nil then
      newHeroDic[heroIndex] = enterIdList[enterIndex]
      enterIndex = enterIndex + 1
    else
      if removeDic[curHeroId] then
        newHeroDic[heroIndex] = enterIdList[enterIndex]
        enterIndex = enterIndex + 1
      else
        newHeroDic[heroIndex] = curHeroId
      end
    end
  end
  for heroIndex,heroId in pairs(newHeroDic) do
    local usedDynHeroData = ((self.wcCtrl).teamCtrl):GetHeroDynDataById(heroId)
    if usedDynHeroData ~= nil and usedDynHeroData.hpPer <= 0 then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(8721))
      return 
    end
  end
  local identify = self.__identify
  local heroes = newHeroDic
  local fromFormationIdx = (self.__curTeamData):GetWCTeamIndex()
  local powerNum = 0
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Event_FreshFormation(identify, heroes, fromFormationIdx, powerNum, false, function()
    -- function num : 0_5_0 , upvalues : _ENV
    if isGameDev then
      print("换人结束")
    end
  end
)
end

WarChessRescueCtrl.CancelReplaceWCTeamHero = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local identify = self.__identify
  ;
  ((self.wcCtrl).wcNetworkCtrl):CS_WarChess_Event_FreshFormation(identify, table.emptytable, 0, 0, true, function()
    -- function num : 0_6_0 , upvalues : _ENV
    if isGameDev then
      print("换人结束")
    end
  end
)
end

WarChessRescueCtrl.CloseWCSubSystem = function(self, isSwitchClose)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.CloseWCSubSystem)()
  UIManager:DeleteWindow(UIWindowTypeID.EpSupportRoom)
  self:Exit()
end

WarChessRescueCtrl.Exit = function(self)
  -- function num : 0_8
  self.__rescueSystemData = nil
  self.__identify = nil
  self.__couldReplaceHeroIdList = nil
  self.__couldReplaceHeroDataDic = nil
end

WarChessRescueCtrl.Delete = function(self)
  -- function num : 0_9
end

return WarChessRescueCtrl

