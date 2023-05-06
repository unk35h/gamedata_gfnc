-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessInfo = class("UIWarChessInfo", base)
local cs_ResLoader = CS.ResLoader
local eWCInteractType = require("Game.WarChess.Interact.Base.eWCInteractType")
local UINWarChessInfoOpNode = require("Game.WarChess.UI.Info.UINWarChessInfoOpNode")
local WarChessConditionCheck = require("Game.WarChess.ConditionCheck.WarChessConditionCheck")
local UINWarChessInfoInfoRoot = require("Game.WarChess.UI.Info.root.UINWarChessInfoInfoRoot")
local UINWarChessInfoInfoOpIcon = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoOpIcon")
local UINWarChessInfoInfoHPBar = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoHPBar")
local UINWarChessInfoInfoTeamInfo = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoTeamInfo")
local UINWarChessInfoInfoDeployMark = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoDeployMark")
local UINWarChessInfoMonsterGroupTagList = require("Game.WarChess.UI.Info.UINWarChessInfoTagListNode")
local UINWarChessInfoInfoEnemyMove = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoEnemyMove")
local UINWarChessInfoMoney = require("Game.WarChess.UI.Info.Info.UINWarChessInfoMoney")
local UINWarChessInfoInfoLonpressCircle = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoLonpressCircle")
local UINWarChessInfoMonsterDrop = require("Game.WarChess.UI.Info.Info.UINWarChessInfoMonsterDrop")
local UINWarChessInfoInfoEntityHeadIcon = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoEntityHeadIcon")
local WarChessHelper = require("Game.WarChess.WarChessHelper")
local eWarChessEnum = require("Game.WarChess.eWarChessEnum")
UIWarChessInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, UINWarChessInfoOpNode, UINWarChessInfoMonsterGroupTagList, UINWarChessInfoMoney, UINWarChessInfoMonsterDrop, UINWarChessInfoInfoLonpressCircle, _ENV, UINWarChessInfoInfoRoot, UINWarChessInfoInfoHPBar, UINWarChessInfoInfoOpIcon, UINWarChessInfoInfoTeamInfo, UINWarChessInfoInfoDeployMark, UINWarChessInfoInfoEnemyMove, UINWarChessInfoInfoEntityHeadIcon
  self.resloader = (cs_ResLoader.Create)()
  self.__lastCamView = nil
  self.__data2InfoRootDic = {}
  self.selectedTeamData = nil
  self.curInterActData = nil
  self.OPNode = (UINWarChessInfoOpNode.New)()
  ;
  (self.OPNode):Init((self.ui).opBtnGroup)
  ;
  (self.OPNode):Hide()
  self.MonsterTagNode = (UINWarChessInfoMonsterGroupTagList.New)()
  ;
  (self.MonsterTagNode):Init((self.ui).tagList)
  ;
  (self.MonsterTagNode):Hide()
  self.getMoneyNode = (UINWarChessInfoMoney.New)()
  ;
  (self.getMoneyNode):Init((self.ui).Money)
  ;
  (self.getMoneyNode):Hide()
  self.enemyDropNode = (UINWarChessInfoMonsterDrop.New)()
  ;
  (self.enemyDropNode):Init((self.ui).monsterDropIcon)
  ;
  (self.enemyDropNode):Hide()
  self.longPressNode = (UINWarChessInfoInfoLonpressCircle.New)()
  ;
  (self.longPressNode):Init((self.ui).longPressCircle)
  ;
  (self.longPressNode):Hide()
  self.infoRootPool = (UIItemPool.New)(UINWarChessInfoInfoRoot, (self.ui).infoRoot)
  ;
  ((self.ui).infoRoot):SetActive(false)
  self.hpBarPool = (UIItemPool.New)(UINWarChessInfoInfoHPBar, (self.ui).hPBar)
  ;
  ((self.ui).hPBar):SetActive(false)
  self.opIconPool = (UIItemPool.New)(UINWarChessInfoInfoOpIcon, (self.ui).opIcon)
  ;
  ((self.ui).opIcon):SetActive(false)
  self.teamInfoPool = (UIItemPool.New)(UINWarChessInfoInfoTeamInfo, (self.ui).teamInfo)
  ;
  ((self.ui).teamInfo):SetActive(false)
  self.deployPool = (UIItemPool.New)(UINWarChessInfoInfoDeployMark, (self.ui).deployMark)
  ;
  ((self.ui).deployMark):SetActive(false)
  self.enemyMovePool = (UIItemPool.New)(UINWarChessInfoInfoEnemyMove, (self.ui).enemyMove)
  ;
  ((self.ui).enemyMove):SetActive(false)
  self.entityHeadIconPool = (UIItemPool.New)(UINWarChessInfoInfoEntityHeadIcon, (self.ui).entityHeadIcon)
  ;
  ((self.ui).entityHeadIcon):SetActive(false)
  self.__onCameraMove = BindCallback(self, self.__OnCameraMove)
  MsgCenter:AddListener(eMsgEventId.WC_CameraMove, self.__onCameraMove)
  self.__onEntityInfoUpdate = BindCallback(self, self.__OnEntityInfoUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_EntityInfoUpdate, self.__onEntityInfoUpdate)
  self.__onTeamInfoUpdate = BindCallback(self, self.__OnTeamInfoUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_TeamInfoUpdate, self.__onTeamInfoUpdate)
  self.__onTeamHeroUpdate = BindCallback(self, self._OnTeamHeroInfoUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_HeroDynUpdate, self.__onTeamHeroUpdate)
  self.__onGridInfoUpdate = BindCallback(self, self.__OnGridInfoUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_GridInfoUpdate, self.__onGridInfoUpdate)
  MsgCenter:AddListener(eMsgEventId.WC_DeployTeamChange, self.__onGridInfoUpdate)
  self.__onSelectTeam = BindCallback(self, self.__OnSelectTeam)
  MsgCenter:AddListener(eMsgEventId.WC_SelectTeam, self.__onSelectTeam)
  self.__onWCAPNumChange = BindCallback(self, self.__OnWCAPNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_TeamAPChange, self.__onWCAPNumChange)
  MsgCenter:AddListener(eMsgEventId.WC_APLimitChange, self.__onWCAPNumChange)
  self.__onWCPressChange = BindCallback(self, self.OnWCPressChange)
  MsgCenter:AddListener(eMsgEventId.WC_StressPointChange, self.__onWCPressChange)
  self.__onWCItemChange = BindCallback(self, self.__OnWCItemChange)
  MsgCenter:AddListener(eMsgEventId.WC_CoinNumChange, self.__onWCItemChange)
  self.__onWCLongPressTeam = BindCallback(self, self.__OnWCLongPressTeam)
  MsgCenter:AddListener(eMsgEventId.WC_LongPressRateChange, self.__onWCLongPressTeam)
  self.__onTeamCouldMoveGridChange = BindCallback(self, self.__OnTeamCouldMoveGridChange)
  MsgCenter:AddListener(eMsgEventId.WC_TeamCouldMoveGridChange, self.__onTeamCouldMoveGridChange)
  self.__onTeamNumericChange = BindCallback(self, self.__OnTeamNumericChange)
  MsgCenter:AddListener(eMsgEventId.WC_TeamNumericChange, self.__onTeamNumericChange)
  self.resloader = ((CS.ResLoader).Create)()
end

UIWarChessInfo.InitWCInfo = function(self, wcCtrl)
  -- function num : 0_1
  self.wcCtrl = wcCtrl
  self.__lastCamView = nil
  local ok, camView = ((self.wcCtrl).wcCamCtrl):GetCameraViewOnPlaneRect()
  if ok then
    local curView = {xMin = camView[0], yMin = camView[1], xMax = camView[2], yMax = camView[3]}
    self:__OnCameraMove(true, curView)
  end
end

UIWarChessInfo.__OnCameraMove = function(self, ok, curView, lastView)
  -- function num : 0_2 , upvalues : _ENV
  if not ok then
    return 
  end
  local xMin = curView.xMin
  local yMin = curView.yMin
  local xMax = curView.xMax
  local yMax = curView.yMax
  if self.__lastCamView == nil then
    (self.infoRootPool):HideAll()
    self.__data2InfoRootDic = {}
    for x = xMin, xMax do
      for y = yMin, yMax do
        self:__TryShowInfoByPosXY(x, y)
      end
    end
  else
    do
      for _,infoRoot in pairs((self.infoRootPool).listItem) do
        self:__UpdateInfoRoot(infoRoot, xMin, yMin, xMax, yMax)
      end
      do
        local isOverLap = xMax >= (self.__lastCamView).xMin and (self.__lastCamView).yMax >= yMin and (self.__lastCamView).xMax >= xMin and yMax >= (self.__lastCamView).yMin
        for x = xMin, xMax do
          for y = yMin, yMax do
            -- DECOMPILER ERROR at PC91: Unhandled construct in 'MakeBoolean' P1

            if isOverLap and (x < (self.__lastCamView).xMin or (self.__lastCamView).xMax < x or y < (self.__lastCamView).yMin or (self.__lastCamView).yMax < y) then
              self:__TryShowInfoByPosXY(x, y)
            end
            self:__TryShowInfoByPosXY(x, y)
          end
        end
        self.__lastCamView = lastView
        -- DECOMPILER ERROR: 5 unprocessed JMP targets
      end
    end
  end
end

UIWarChessInfo.OnWCPressChange = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.infoRootPool ~= nil then
    for _,v in pairs((self.infoRootPool).listItem) do
      if v ~= nil then
        v:CheckEntityCanMove()
      end
    end
  end
end

UIWarChessInfo._CreateWCInfoRootItem = function(self, logicPos)
  -- function num : 0_4 , upvalues : _ENV
  local infoRoot = (self.infoRootPool):GetOne()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (infoRoot.gameObject).name = (string.format)("%d_%d", logicPos.x, logicPos.y)
  return infoRoot
end

UIWarChessInfo._CreateWCInfoTeamRoot = function(self, index)
  -- function num : 0_5 , upvalues : _ENV
  local infoRoot = (self.infoRootPool):GetOne()
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (infoRoot.gameObject).name = tostring(index)
  return infoRoot
end

UIWarChessInfo.__TryShowInfoByPosXY = function(self, x, y)
  -- function num : 0_6 , upvalues : _ENV
  local logicPos = (Vector2.New)(x, y)
  local teamData = ((self.wcCtrl).teamCtrl):GetTeamDataByLogicPos(logicPos)
  do
    if teamData ~= nil and (self.__data2InfoRootDic)[teamData] == nil then
      local infoRoot = self:_CreateWCInfoTeamRoot(teamData:GetWCTeamIndex())
      infoRoot:SetResloader(self.resloader)
      infoRoot:PopInfoRoot4Team(teamData, self)
      -- DECOMPILER ERROR at PC28: Confused about usage of register: R6 in 'UnsetPending'

      ;
      (self.__data2InfoRootDic)[teamData] = infoRoot
      return 
    end
    local gridData = ((self.wcCtrl).mapCtrl):GetGridDataByLogicXY(nil, x, y)
    local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPosXY(nil, x, y)
    if entityData ~= nil and (self.__data2InfoRootDic)[entityData] == nil and (entityData:GetEntityIsMonster() or entityData:GetEntityCouldInteract()) then
      local infoRoot = self:_CreateWCInfoRootItem(logicPos)
      infoRoot:SetResloader(self.resloader)
      infoRoot:PopInfoRoot4Entity(entityData, self)
      -- DECOMPILER ERROR at PC69: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.__data2InfoRootDic)[entityData] = infoRoot
    else
      do
        if gridData ~= nil and (self.__data2InfoRootDic)[gridData] == nil and gridData:GetGridCouldInteract() then
          local infoRoot = self:_CreateWCInfoRootItem(logicPos)
          infoRoot:SetResloader(self.resloader)
          infoRoot:PopInfoRoot4Grid(gridData, self)
          -- DECOMPILER ERROR at PC92: Confused about usage of register: R8 in 'UnsetPending'

          ;
          (self.__data2InfoRootDic)[gridData] = infoRoot
        end
      end
    end
  end
end

UIWarChessInfo.__UpdateInfoRoot = function(self, infoRoot, xMin, yMin, xMax, yMax)
  -- function num : 0_7
  if infoRoot:WCIRIsInView(xMin, yMin, xMax, yMax) or infoRoot.haveOpNode then
    infoRoot:WCIRUpdatPos()
  else
    local data = infoRoot:WCInfoGetData()
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R7 in 'UnsetPending'

    if data ~= nil then
      (self.__data2InfoRootDic)[data] = nil
    end
    ;
    (self.infoRootPool):HideOne(infoRoot)
  end
end

UIWarChessInfo.__OnEntityInfoUpdate = function(self, entityData, isDelete)
  -- function num : 0_8
  if entityData == nil then
    return 
  end
  do
    if not entityData:GetEntityIsMonster() and not entityData:GetEntityCouldInteract() then
      local infoRoot = (self.__data2InfoRootDic)[entityData]
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      if infoRoot ~= nil then
        (self.__data2InfoRootDic)[entityData] = nil
        ;
        (self.infoRootPool):HideOne(infoRoot)
      end
      return 
    end
    local xMin, yMin, xMax, yMax = self:__GetLastViewRect()
    local infoRoot = (self.__data2InfoRootDic)[entityData]
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    if infoRoot ~= nil then
      if isDelete then
        (self.__data2InfoRootDic)[entityData] = nil
        ;
        (self.infoRootPool):HideOne(infoRoot)
        return 
      end
      local showPos = entityData:GetEntityShowPos()
      infoRoot:WCIRSetShowPos(showPos)
      infoRoot:RefreshWCMonsterHpBar()
      self:__UpdateInfoRoot(infoRoot, xMin, yMin, xMax, yMax)
      return 
    end
    do
      local showPos = entityData:GetEntityShowPos()
      local logicPos = entityData:GetEntityLogicPos()
      if showPos == nil then
        return 
      end
      if self:__isInView(showPos.x, showPos.z, xMin, yMin, xMax, yMax) then
        local infoRoot = self:_CreateWCInfoRootItem(logicPos)
        infoRoot:SetResloader(self.resloader)
        infoRoot:PopInfoRoot4Entity(entityData, self)
        -- DECOMPILER ERROR at PC80: Confused about usage of register: R11 in 'UnsetPending'

        ;
        (self.__data2InfoRootDic)[entityData] = infoRoot
      end
    end
  end
end

UIWarChessInfo.__OnSelectTeam = function(self, teamData)
  -- function num : 0_9 , upvalues : _ENV
  local isCurSelected = teamData ~= nil
  self.selectedTeamData = teamData
  for data,infoRoot in pairs(self.__data2InfoRootDic) do
    infoRoot:WCIRSetInteractInfoActive(isCurSelected, teamData)
  end
  do
    if teamData ~= nil then
      local infoRoot = (self.__data2InfoRootDic)[teamData]
      if infoRoot ~= nil then
        infoRoot:UpdateAllInfo()
      end
    end
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UIWarChessInfo.__OnTeamCouldMoveGridChange = function(self, teamData)
  -- function num : 0_10 , upvalues : _ENV
  if self.selectedTeamData ~= nil and self.selectedTeamData == teamData then
    for data,infoRoot in pairs(self.__data2InfoRootDic) do
      infoRoot:WCIRSetInteractInfoActive(true, teamData)
    end
  end
end

UIWarChessInfo.__OnTeamNumericChange = function(self, teamData, numericUpdate)
  -- function num : 0_11
  if teamData == nil then
    return 
  end
  local infoRoot = (self.__data2InfoRootDic)[teamData]
  if infoRoot ~= nil then
    infoRoot:UpdateAllInfo()
  end
end

UIWarChessInfo.__OnTeamInfoUpdate = function(self, teamData)
  -- function num : 0_12
  local xMin, yMin, xMax, yMax = self:__GetLastViewRect()
  local infoRoot = (self.__data2InfoRootDic)[teamData]
  local index = teamData:GetWCTeamIndex()
  local heroEntity = ((self.wcCtrl).teamCtrl):GetWCHeroEntity(index, nil, nil)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R9 in 'UnsetPending'

  if heroEntity == nil then
    (self.__data2InfoRootDic)[teamData] = nil
    if infoRoot ~= nil then
      (self.infoRootPool):HideOne(infoRoot)
    end
    return 
  end
  local showPos = heroEntity:WCHeroEntityGetShowPos()
  if infoRoot ~= nil then
    infoRoot:WCIRSetShowPos(showPos)
    self:__UpdateInfoRoot(infoRoot, xMin, yMin, xMax, yMax)
    return 
  end
  if self:__isInView(showPos.x, showPos.z, xMin, yMin, xMax, yMax) then
    local infoRoot = self:_CreateWCInfoTeamRoot(teamData:GetWCTeamIndex())
    infoRoot:SetResloader(self.resloader)
    infoRoot:PopInfoRoot4Team(teamData, self)
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R11 in 'UnsetPending'

    ;
    (self.__data2InfoRootDic)[teamData] = infoRoot
  end
end

UIWarChessInfo._OnTeamHeroInfoUpdate = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local teamDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  for k,teamData in pairs(teamDic) do
    local infoRoot = (self.__data2InfoRootDic)[teamData]
    if infoRoot ~= nil then
      infoRoot:RefreshWCTeamHpBar()
    end
  end
end

UIWarChessInfo.__OnGridInfoUpdate = function(self, gridData)
  -- function num : 0_14
  if gridData == nil then
    return 
  end
  local showPos = gridData:GetGridShowPos()
  local logicPos = gridData:GetGridLogicPos()
  local entityData = ((self.wcCtrl).mapCtrl):GetEntityDataByLogicPos(nil, logicPos)
  do
    if entityData ~= nil or not gridData:GetGridCouldInteract() then
      local infoRoot = (self.__data2InfoRootDic)[gridData]
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R6 in 'UnsetPending'

      if infoRoot ~= nil then
        (self.__data2InfoRootDic)[gridData] = nil
        ;
        (self.infoRootPool):HideOne(infoRoot)
      end
      return 
    end
    local xMin, yMin, xMax, yMax = self:__GetLastViewRect()
    local infoRoot = (self.__data2InfoRootDic)[gridData]
    if infoRoot ~= nil then
      infoRoot:WCIRSetShowPos(showPos)
      infoRoot:UpdateAllInfo()
      self:__UpdateInfoRoot(infoRoot, xMin, yMin, xMax, yMax)
      return 
    end
    if self:__isInView(showPos.x, showPos.z, xMin, yMin, xMax, yMax) then
      local infoRoot = self:_CreateWCInfoRootItem(logicPos)
      infoRoot:SetResloader(self.resloader)
      infoRoot:PopInfoRoot4Grid(gridData, self)
      -- DECOMPILER ERROR at PC70: Confused about usage of register: R11 in 'UnsetPending'

      ;
      (self.__data2InfoRootDic)[gridData] = infoRoot
    end
  end
end

UIWarChessInfo.__GetLastViewRect = function(self)
  -- function num : 0_15
  if self.__lastCamView == nil then
    return nil
  end
  local xMin = (self.__lastCamView).xMin
  local yMin = (self.__lastCamView).yMin
  local xMax = (self.__lastCamView).xMax
  local yMax = (self.__lastCamView).yMax
  return xMin, yMin, xMax, yMax
end

UIWarChessInfo.__OnWCAPNumChange = function(self, changeTeam)
  -- function num : 0_16 , upvalues : _ENV
  local allTeamDic = ((self.wcCtrl).teamCtrl):GetWCTeams()
  for _,teamData in pairs(allTeamDic) do
    local infoRoot = (self.__data2InfoRootDic)[teamData]
    if infoRoot ~= nil then
      infoRoot:UpdateAllInfo()
    end
  end
  if changeTeam ~= nil then
    local infoRoot = (self.__data2InfoRootDic)[changeTeam]
    if infoRoot ~= nil then
      local diffAp = changeTeam:GetWCTeamDiffAP()
      if diffAp < 0 then
        infoRoot:ShowTeamApReduceTip(changeTeam, diffAp)
      end
    end
  end
end

UIWarChessInfo.__isInView = function(self, x, y, xMin, yMin, xMax, yMax)
  -- function num : 0_17
  if xMin == nil or yMin == nil or xMax == nil or yMax == nil then
    return true
  end
  do return xMin <= x and x <= xMax and yMin <= y and y <= yMax end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIWarChessInfo.PopInteractUI = function(self, interacts, data, unit, teamData, actCallback)
  -- function num : 0_18 , upvalues : WarChessHelper, _ENV, WarChessConditionCheck, eWarChessEnum, eWCInteractType
  local notSeletedTeam = teamData == nil
  if #interacts <= 0 then
    return false
  end
  ;
  (self.OPNode):CleanWCOPRoot()
  local isMonster = data:IsWCUnitMonster()
  local infoRoot = (self.__data2InfoRootDic)[data]
  do
    if infoRoot == nil then
      local x, y = (WarChessHelper.Coordination2Pos)(unit.pos)
      do
        self:__TryShowInfoByPosXY(x, y)
        infoRoot = (self.__data2InfoRootDic)[data]
      end
    end
    if infoRoot ~= nil then
      local needToHideObjs = {}
      infoRoot.haveOpNode = true
      infoRoot:SetIsShowselfOpIconItem(false)
      if (self.OPNode).active then
        (self.OPNode):Hide()
      end
      ;
      ((self.OPNode).transform):SetParent(((infoRoot.ui).opHolder).transform)
      -- DECOMPILER ERROR at PC52: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.OPNode).transform).localPosition = Vector3.one
      ;
      (self.OPNode):SetWCUseCallback(function()
    -- function num : 0_18_0 , upvalues : infoRoot, self, _ENV, needToHideObjs
    infoRoot.haveOpNode = false
    infoRoot:WCIRSetInteractInfoActive(true, self.selectedTeamData)
    for _,subNode in pairs(needToHideObjs) do
      if subNode ~= nil then
        subNode:Hide()
      end
    end
    infoRoot:SetIsShowHeadIcon(true)
    self:HideShowInfo()
  end
)
      ;
      (self.OPNode):Show()
      if isMonster then
        (self.MonsterTagNode):Show()
        ;
        (self.MonsterTagNode):SetWCIIMonsterTag(data, isMonster)
        ;
        ((self.MonsterTagNode).transform):SetParent(((infoRoot.ui).tagHolder).transform)
        -- DECOMPILER ERROR at PC81: Confused about usage of register: R10 in 'UnsetPending'

        ;
        ((self.MonsterTagNode).transform).localPosition = Vector3.zero
        needToHideObjs.MonsterTagNode = self.MonsterTagNode
        local dropIcons = data:GetDropIcons()
        if dropIcons ~= nil and #dropIcons > 0 then
          (self.enemyDropNode):Show()
          ;
          (self.enemyDropNode):RefreshWCMonsterDropIcons(dropIcons)
          ;
          ((self.enemyDropNode).transform):SetParent((infoRoot.ui).monsterDropHolder)
          -- DECOMPILER ERROR at PC108: Confused about usage of register: R11 in 'UnsetPending'

          ;
          ((self.enemyDropNode).transform).localPosition = Vector3.zero
          needToHideObjs.enemyDropNode = self.enemyDropNode
          infoRoot:SetIsShowHeadIcon(false)
        end
      end
    else
      self.curInterActData = data
    end
    local couldUseNum = 0
    for _,interactCfg in pairs(interacts) do
      -- DECOMPILER ERROR at PC157: Unhandled construct in 'MakeBoolean' P1

      if (WarChessConditionCheck.CheckGridConditionTree)(unit, interactCfg) and (eWarChessEnum.IntroInterActType)[interactCfg.cat] and (interactCfg.cat ~= eWCInteractType.infoWithoutTeam or teamData == nil) and (interactCfg.cat ~= eWCInteractType.gridIntr or teamData == nil or not (CommonUtil.GetIsWarChessQuickInteract)() or GuideManager.inGuide) then
        if actCallback ~= nil then
          self:HideShowInfo()
          actCallback(interactCfg, true)
          self.__showingIntro = true
        end
        couldUseNum = couldUseNum + 1
      end
      if interactCfg.cat == eWCInteractType.born then
        if notSeletedTeam and data:GetIsBornPoint() then
          (self.OPNode):SetWCShowDynDeployTeam()
        end
        return false
      elseif not notSeletedTeam and (interactCfg.cat ~= eWCInteractType.battle or not teamData:GetWCTeamIsGhost()) then
        local costAP = ((self.wcCtrl).interactCtrl):GetWCIneractionAPCost(interactCfg)
        ;
        (self.OPNode):SetWCAct(actCallback, interactCfg, costAP, isMonster, function(callback)
    -- function num : 0_18_1 , upvalues : isMonster, notSeletedTeam, self, data, teamData
    if isMonster and not notSeletedTeam then
      ((self.wcCtrl).mapCtrl):GetMonsterCouldSecKill(data, teamData, callback)
    else
      if callback ~= nil then
        callback(false)
      end
    end
  end
)
        couldUseNum = couldUseNum + 1
      end
    end
    if couldUseNum <= 0 then
      return false
    end
    AudioManager:PlayAudioById(1233)
    do return true end
    -- DECOMPILER ERROR: 15 unprocessed JMP targets
  end
end

UIWarChessInfo.HideShowInfo = function(self)
  -- function num : 0_19 , upvalues : _ENV
  if self.__showingIntro then
    UIManager:HideWindow(UIWindowTypeID.WarChessObjDetail)
    UIManager:HideWindow(UIWindowTypeID.WarChessMonsterDetail)
    self.__showingIntro = false
  end
end

UIWarChessInfo.PopCustomInteractUI = function(self, data, actCallback, costAP, typeIndex, notClean)
  -- function num : 0_20 , upvalues : _ENV
  if not notClean then
    (self.OPNode):CleanWCOPRoot()
  end
  local infoRoot = (self.__data2InfoRootDic)[data]
  if infoRoot ~= nil then
    infoRoot.haveOpNode = true
    infoRoot:SetIsShowselfOpIconItem(false)
    ;
    ((self.OPNode).transform):SetParent(((infoRoot.ui).opHolder).transform)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.OPNode).transform).localPosition = Vector3.one
    ;
    (self.OPNode):SetWCUseCallback(function()
    -- function num : 0_20_0 , upvalues : infoRoot, self
    infoRoot.haveOpNode = false
    infoRoot:WCIRSetInteractInfoActive(true, self.selectedTeamData)
    self:HideShowInfo()
  end
)
    ;
    (self.OPNode):Show()
  else
    self.curInterActData = data
  end
  ;
  (self.OPNode):SetWCCustomInteract(actCallback, costAP, typeIndex)
end

UIWarChessInfo.__OnWCItemChange = function(self, itemId, curNum, addNum)
  -- function num : 0_21 , upvalues : _ENV
  if itemId == ConstGlobalItem.WCMoney and addNum > 0 then
    if self.selectedTeamData == nil then
      return 
    end
    local teamInfoRoot = (self.__data2InfoRootDic)[self.selectedTeamData]
    if teamInfoRoot == nil then
      return 
    end
    ;
    ((self.getMoneyNode).transform):SetParent(((teamInfoRoot.ui).moneyHolder).transform)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.getMoneyNode).transform).localPosition = Vector3.one
    ;
    (self.getMoneyNode):InitWCGetMoneyItem(itemId, addNum)
    ;
    (self.getMoneyNode):Show()
    ;
    (self.getMoneyNode):WCGetMoneyPlayTween()
  end
end

UIWarChessInfo.__OnWCLongPressTeam = function(self, rate, pos)
  -- function num : 0_22 , upvalues : _ENV
  if rate == nil then
    (self.longPressNode):Hide()
  else
    ;
    (self.longPressNode):Show()
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.longPressNode).transform).localPosition = TransitionScreenPoint(UIManager:GetUICamera(), (((self.ui).infoItems).transform).gameObject, pos)
    ;
    (self.longPressNode):WCInfoLongPressCircleSetRate(rate)
  end
end

UIWarChessInfo.OnDelete = function(self)
  -- function num : 0_23 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.WC_CameraMove, self.__onCameraMove)
  MsgCenter:RemoveListener(eMsgEventId.WC_EntityInfoUpdate, self.__onEntityInfoUpdate)
  MsgCenter:RemoveListener(eMsgEventId.WC_TeamInfoUpdate, self.__onTeamInfoUpdate)
  MsgCenter:RemoveListener(eMsgEventId.WC_HeroDynUpdate, self.__onTeamHeroUpdate)
  MsgCenter:RemoveListener(eMsgEventId.WC_GridInfoUpdate, self.__onGridInfoUpdate)
  MsgCenter:RemoveListener(eMsgEventId.WC_DeployTeamChange, self.__onGridInfoUpdate)
  MsgCenter:RemoveListener(eMsgEventId.WC_SelectTeam, self.__onSelectTeam)
  MsgCenter:RemoveListener(eMsgEventId.WC_TeamAPChange, self.__onWCAPNumChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_APLimitChange, self.__onWCAPNumChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_StressPointChange, self.__onWCPressChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_CoinNumChange, self.__onWCItemChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_LongPressRateChange, self.__onWCLongPressTeam)
  MsgCenter:RemoveListener(eMsgEventId.WC_TeamCouldMoveGridChange, self.__onTeamCouldMoveGridChange)
  MsgCenter:RemoveListener(eMsgEventId.WC_TeamNumericChange, self.__onTeamNumericChange)
  ;
  (self.enemyDropNode):Delete()
  ;
  (self.infoRootPool):DeleteAll()
  ;
  (self.hpBarPool):DeleteAll()
  ;
  (self.deployPool):DeleteAll()
  ;
  (self.opIconPool):DeleteAll()
  ;
  (self.getMoneyNode):Delete()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self._timer ~= nil then
    TimerManager:StopTimer(self._timer)
    self._timer = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWarChessInfo

