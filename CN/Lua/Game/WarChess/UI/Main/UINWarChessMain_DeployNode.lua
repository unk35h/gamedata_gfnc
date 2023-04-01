-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_DeployNode = class("UINWarChessMain_DeployNode", base)
local FmtEnum = require("Game.Formation.FmtEnum")
local UINWarChessMain_DNTeamItem = require("Game.WarChess.UI.Main.UINWarChessMain_DNTeamItem")
UINWarChessMain_DeployNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessMain_DNTeamItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BattleStart, self, self.__OnClickBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ApplyDynDeploy, self, self.__OnClickApplyDynDeploy)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ExitDynDeploy, self, self.__OnClickExitDynDeploy)
  self.teamItemPool = (UIItemPool.New)(UINWarChessMain_DNTeamItem, (self.ui).teamItem)
  ;
  ((self.ui).teamItem):SetActive(false)
  self.__index2TeamItemDic = {}
  self.__onClickCurTeam = BindCallback(self, self.__OnClickCurTeam)
  self.__onEnterFmt = BindCallback(self, self.__OnEnterFmt)
  self.__onExitFmt = BindCallback(self, self.__OnExitFmt)
  self.__onDeployOver = BindCallback(self, self.__OnDeployOver)
  self.__onChangeDrag2Scroll = BindCallback(self, self.__OnChangeDrag2Scroll)
  self.__onDeployTeamChange = BindCallback(self, self.OnDeployTeamChange)
  MsgCenter:AddListener(eMsgEventId.WC_DeployTeamChange, self.__onDeployTeamChange)
  self.__onWCIsDeployingHeroChange = BindCallback(self, self.OnWCIsDeployingHeroChange)
  MsgCenter:AddListener(eMsgEventId.WC_DeployingTeam, self.__onWCIsDeployingHeroChange)
end

UINWarChessMain_DeployNode.InitWarChessDeployNode = function(self, deployState, resloader)
  -- function num : 0_1
  self.deployState = deployState
  self.wcCtrl = (self.deployState).wcCtrl
  self.resloader = resloader
  local isDynDeploy = deployState:GetIsDynDeploy()
  ;
  ((self.ui).obj_deploy):SetActive(not isDynDeploy)
  ;
  ((self.ui).obj_dynDeploy):SetActive(isDynDeploy)
  if not isDynDeploy then
    self:RefreshLevelInfo()
  end
  self:RefreshTeamItems()
  self:OnDeployTeamChange()
end

UINWarChessMain_DeployNode.RefreshLevelInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local recommendPower = WarChessManager:GetWCRecommenPower()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_RecommendPower).text = tostring(recommendPower)
end

UINWarChessMain_DeployNode.RefreshTeamItems = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local maxShowFmtNum = ((self.wcCtrl).teamCtrl):GetWCFmtShowNum()
  local dTeamDic = (self.deployState):GetDTeamDataDic()
  local dTeamList = {}
  for index,dTeamData in pairs(dTeamDic) do
    (table.insert)(dTeamList, dTeamData)
  end
  ;
  (table.sort)(dTeamList, function(a, b)
    -- function num : 0_3_0 , upvalues : self
    local index_a = a:GetDTeamIndex()
    local index_b = b:GetDTeamIndex()
    local teamData_a = (self.deployState):GetTeamDataByIndex(index_a)
    local teamData_b = (self.deployState):GetTeamDataByIndex(index_b)
    local isDeploied_a = teamData_a ~= nil
    local isDeploied_b = teamData_b ~= nil
    local isHaveHero_a = a:GetFirstHeroData() ~= nil
    local isHaveHero_b = b:GetFirstHeroData() ~= nil
    local isFixed_a = a:GetDTeamIsFixedTeam()
    local isFixed_b = b:GetDTeamIsFixedTeam()
    if isDeploied_a ~= isDeploied_b then
      return isDeploied_a
    end
    if isFixed_a ~= isFixed_b then
      return isFixed_a
    end
    if isHaveHero_a ~= isHaveHero_b then
      return isHaveHero_a
    end
    do return index_a < index_b end
    -- DECOMPILER ERROR: 8 unprocessed JMP targets
  end
)
  self.__index2TeamItemDic = {}
  ;
  (self.teamItemPool):HideAll()
  for _,dTeamData in ipairs(dTeamList) do
    local teamItem = (self.teamItemPool):GetOne()
    local index = dTeamData:GetDTeamIndex()
    teamItem:InitWCDeployTeamItem(self.deployState, index, self.__onClickCurTeam, self.resloader)
    teamItem:SetWCDeployTeamDragChange(true, self.__onChangeDrag2Scroll)
    -- DECOMPILER ERROR at PC49: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.__index2TeamItemDic)[index] = teamItem
  end
end

UINWarChessMain_DeployNode.GetWCDeployTeamItem = function(self, index)
  -- function num : 0_4
  return (self.__index2TeamItemDic)[index]
end

UINWarChessMain_DeployNode.OnDeployTeamChange = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local deployLimit = ((self.wcCtrl).teamCtrl):GetWCFmtNum()
  local dpTeamCount = 0
  local isDynDeploy = (self.deployState):GetIsDynDeploy()
  if isDynDeploy then
    self:RefreshTeamItems()
    dpTeamCount = ((self.wcCtrl).teamCtrl):GetWCFmtCurNum()
    local dTeamDic = (self.deployState):GetDTeamDataDic()
    for index,dTeamData in pairs(dTeamDic) do
      if dTeamData:GetIsDeploied() then
        dpTeamCount = dpTeamCount + 1
      end
    end
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_DynTeamCount).text = tostring(dpTeamCount) .. "/" .. tostring(deployLimit)
    return 
  end
  do
    local totalPower = 0
    local dTeamDic = (self.deployState):GetDTeamDataDic()
    for index,dTeamData in pairs(dTeamDic) do
      local isDeploied = false
      if dTeamData:GetIsDeploied() then
        isDeploied = true
        dpTeamCount = dpTeamCount + 1
        totalPower = totalPower + dTeamData:GetDTeamTeamPower()
      end
      local teamItem = (self.__index2TeamItemDic)[index]
      teamItem:RefreshTeamIsDeployed(isDeploied)
    end
    -- DECOMPILER ERROR at PC78: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_TeamCount).text = tostring(dpTeamCount) .. "/" .. tostring(deployLimit)
    -- DECOMPILER ERROR at PC84: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_CurTotalPower).text = tostring(totalPower)
  end
end

UINWarChessMain_DeployNode.OnWCIsDeployingHeroChange = function(self, bool, inStage)
  -- function num : 0_6
  if bool and not inStage then
    return 
  end
  if bool then
    (((self.ui).obj_normalMode).transform):DOLocalMoveY(-300, 0.1)
  else
    ;
    (((self.ui).obj_normalMode).transform):DOLocalMoveY(165, 0.1)
  end
  ;
  ((self.ui).obj_quitMode):SetActive(bool)
end

UINWarChessMain_DeployNode.__OnClickBattle = function(self)
  -- function num : 0_7
  (self.deployState):WCStartPlay()
end

UINWarChessMain_DeployNode.__OnClickApplyDynDeploy = function(self)
  -- function num : 0_8
  (self.deployState):ApplyDynDeploy()
end

UINWarChessMain_DeployNode.__OnClickExitDynDeploy = function(self)
  -- function num : 0_9
  (self.deployState):ExitDynDeploy()
end

UINWarChessMain_DeployNode.__OnClickCurTeam = function(self, teamItem)
  -- function num : 0_10 , upvalues : _ENV
  if WarChessSeasonManager:GetIsInWCSeasonNotFirstLevel() then
    return 
  end
  self:__OpenFormation(teamItem)
end

UINWarChessMain_DeployNode.__OpenFormation = function(self, teamItem)
  -- function num : 0_11 , upvalues : _ENV, FmtEnum
  local index = teamItem.index
  local fmtId = nil
  local teamData = (self.deployState):GetTeamDataByIndex(index)
  if teamData ~= nil and teamData:GetWCTeamIsDead() then
    (self.deployState):CleanTeamDataByIndex(index)
  end
  local dTeamData = (self.deployState):GetDTeamDataByIndex(index)
  if dTeamData ~= nil then
    fmtId = dTeamData:GetFmtId()
  end
  local dTeamDataDic = (self.deployState):GetDTeamDataDic()
  local fmtCtrl = ControllerManager:GetController(ControllerTypeId.Formation, true)
  local wcLevelId = WarChessManager:GetWCLevelId()
  local wcLevelCfg = WarChessManager:GetWCLevelCfg()
  local wcsCtrl = (WarChessSeasonManager:GetWCSCtrl())
  local officialCfgId, floorCfg = nil, nil
  if wcsCtrl ~= nil then
    officialCfgId = wcsCtrl:GetWCSOfficialSupportCfgId()
    local towerId = wcsCtrl:GetWCSTowerId()
    floorCfg = ((ConfigData.warchess_season_floor)[towerId])[(WarChessSeasonManager:GetWCSCtrl()):WCSGetFloor()]
  else
    do
      officialCfgId = WarChessManager:GetWCOfficialSupportCfgId()
      fmtCtrl:ResetFmtCtrlState()
      ;
      ((((((fmtCtrl:GetNewEnterFmtData()):SetFmtIsWarChessDeploy(true, self.__onDeployOver, wcLevelCfg, index)):SetFmtWarChessDTeamDataDic(dTeamDataDic)):SetFmtCtrlBaseInfo((FmtEnum.eFmtFromModule).WarChess, wcLevelId, fmtId)):SetFmtCtrlCallback(self.__onEnterFmt, self.__onExitFmt, nil)):SetIsOpenChangeFmt(not (self.deployState):GetIsDynDeploy())):SetOfficialSupportCfgId(officialCfgId)
      if floorCfg ~= nil then
        (fmtCtrl:GetCurEnterFmtData()):SetFmtWarChessSeasonRecommendCfg(floorCfg.recommend_hero, floorCfg.recommend_team, floorCfg.recommend_skill)
      end
      fmtCtrl:EnterFormation()
    end
  end
end

UINWarChessMain_DeployNode.__OnEnterFmt = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.WarChessMain)
  UIManager:HideWindow(UIWindowTypeID.WarChessInfo)
  ;
  ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(false)
end

UINWarChessMain_DeployNode.__OnExitFmt = function(self)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowOnly(UIWindowTypeID.WarChessMain)
  UIManager:ShowWindowOnly(UIWindowTypeID.WarChessInfo)
  ;
  ((self.wcCtrl).wcCamCtrl):SetIsCouldNormalMoveCamera(true)
  self:__RefreshAllTeamData()
  local dTeamDic = (self.deployState):GetDTeamDataDic()
  for index,dTeamData in pairs(dTeamDic) do
    if dTeamData:GetIsDeploied() then
      local firstHeroData = dTeamData:GetFirstHeroData()
      ;
      ((self.wcCtrl).teamCtrl):RefreshDeployHeroEntity(firstHeroData, index)
    end
  end
end

UINWarChessMain_DeployNode.__OnDeployOver = function(self, fmtData, callbcak)
  -- function num : 0_14
  self:__RefreshAllTeamData()
  if callbcak ~= nil then
    callbcak()
  end
end

UINWarChessMain_DeployNode.__RefreshAllTeamData = function(self)
  -- function num : 0_15 , upvalues : _ENV
  (self.deployState):RefreshAllDTeamData()
  for _,teamItem in pairs((self.teamItemPool).listItem) do
    teamItem:RefreshTeamItem()
  end
end

UINWarChessMain_DeployNode.__OnChangeDrag2Scroll = function(self, eventData)
  -- function num : 0_16
  eventData.pointerDrag = ((self.ui).scroll_mask).gameObject
  ;
  ((self.ui).scroll_mask):OnBeginDrag(eventData)
end

UINWarChessMain_DeployNode.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_DeployTeamChange, self.__onDeployTeamChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_DeployingTeam, self.__onWCIsDeployingHeroChange)
  ;
  (self.teamItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINWarChessMain_DeployNode

