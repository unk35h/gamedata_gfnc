-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMain_DNTeamItem = class("UINWarChessMain_DNTeamItem", UIBaseNode)
local UINWarChessMain_DNTeamItemHeroItem = require("Game.WarChess.UI.Main.UINWarChessMain_DNTeamItemHeroItem")
UINWarChessMain_DNTeamItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessMain_DNTeamItemHeroItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_teamItem, self, self.OnClickTeam)
  self.heroHeadPool = (UIItemPool.New)(UINWarChessMain_DNTeamItemHeroItem, (self.ui).heroHeadItem)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
  self.__isHaveHero = false
  self.__couldDeploy = true
  local eventTrigger = ((CS.EventTriggerListener).Get)(self.gameObject)
  eventTrigger:onBeginDrag("+", BindCallback(self, self.__OnBeginDrag))
  eventTrigger:onDrag("+", BindCallback(self, self.__OnDrag))
  eventTrigger:onEndDrag("+", BindCallback(self, self.__OnEndDrag))
end

UINWarChessMain_DNTeamItem.InitWCDeployTeamItem = function(self, deployState, index, onClickCurTeam, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.deployState = deployState
  self.index = index
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.gameObject).name = tostring(index)
  self.onClickCurTeam = onClickCurTeam
  self.resloader = resloader
  self:RefreshTeamItem()
end

UINWarChessMain_DNTeamItem.SetWCDeployTeamDragChange = function(self, isOpen, onDragChangeFunc)
  -- function num : 0_2
  self._isOpenDragChange = isOpen
  self._onDragChangeFunc = onDragChangeFunc
end

UINWarChessMain_DNTeamItem.RefreshTeamItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local firstHeroData, teamPower, heroDataList, isDeployed, teamName = nil, nil, nil, nil, nil
  local teamData = (self.deployState):GetTeamDataByIndex(self.index)
  if teamData ~= nil then
    local isDead = teamData:GetWCTeamIsDead()
    local firstHeroId = teamData:GetFirstHeroId()
    firstHeroData = (((self.deployState).wcCtrl).teamCtrl):GetHeroDynDataById(firstHeroId)
    teamPower = teamData:GetWCTeamPower()
    heroDataList = {}
    for index,dynHeroData in ipairs(teamData:GetWCTeamHeroList()) do
      if not dynHeroData:IsBench() then
        (table.insert)(heroDataList, dynHeroData.heroData)
      end
    end
    isDeployed = not isDead
    teamName = teamData:GetWCTeamName()
    ;
    ((self.ui).obj_img_Death):SetActive(isDead)
    ;
    ((self.ui).obj_notDeploy):SetActive(isDeployed)
    self.__couldDeploy = isDead
  else
    do
      do
        local dTeamData = (self.deployState):GetDTeamDataByIndex(self.index)
        firstHeroData = dTeamData:GetFirstHeroData()
        teamPower = dTeamData:GetDTeamTeamPower()
        heroDataList = dTeamData:GetTeamMemberHeroDataList()
        isDeployed = dTeamData:GetIsDeploied()
        teamName = dTeamData:GetDTeamName()
        ;
        ((self.ui).obj_img_Death):SetActive(false)
        ;
        ((self.ui).obj_notDeploy):SetActive(false)
        self.__couldDeploy = true
        self.__isHaveHero = firstHeroData ~= nil
        ;
        ((self.ui).realTeam):SetActive(self.__isHaveHero)
        ;
        ((self.ui).emptyTeam):SetActive(not self.__isHaveHero)
        -- DECOMPILER ERROR at PC114: Confused about usage of register: R7 in 'UnsetPending'

        if self.__isHaveHero then
          ((self.ui).img_HeroPic).texture = (self.resloader):LoadABAsset(PathConsts:GetCharacterPicPath(firstHeroData:GetResPicName()))
          -- DECOMPILER ERROR at PC120: Confused about usage of register: R7 in 'UnsetPending'

          ;
          ((self.ui).tex_TeamPow).text = tostring(teamPower)
          -- DECOMPILER ERROR at PC123: Confused about usage of register: R7 in 'UnsetPending'

          ;
          ((self.ui).tex_TeamName).text = teamName
          ;
          (self.heroHeadPool):HideAll()
          for index,heroData in ipairs(heroDataList) do
            local heroHeadItem = (self.heroHeadPool):GetOne()
            heroHeadItem:InitWCHeroHeadItem(R15_PC140, index == 1)
          end
          self:RefreshTeamIsDeployed(isDeployed)
        end
        -- DECOMPILER ERROR: 4 unprocessed JMP targets
      end
    end
  end
end

UINWarChessMain_DNTeamItem.RefreshTeamIsDeployed = function(self, isDeployed)
  -- function num : 0_4
  ((self.ui).obj_IsOnGroudTag):SetActive(isDeployed)
end

UINWarChessMain_DNTeamItem.OnClickTeam = function(self)
  -- function num : 0_5
  if self._isDragCheckFinish then
    return 
  end
  if not self.__couldDeploy then
    return 
  end
  if not (self.deployState):IsWCDeployGuideComplete() then
    return 
  end
  if self.onClickCurTeam ~= nil then
    (self.onClickCurTeam)(self)
  end
end

UINWarChessMain_DNTeamItem.__OnBeginDrag = function(self, go, eventData)
  -- function num : 0_6
  if not self.__isHaveHero then
    return 
  end
  if not self.__couldDeploy then
    return 
  end
  self._startDragPos = eventData.position
  self._checkDragCount = 3
  self._isDragCheckFinish = false
end

UINWarChessMain_DNTeamItem.__OnDrag = function(self, go, eventData)
  -- function num : 0_7 , upvalues : _ENV
  if not self.__isHaveHero then
    self:__ChangeDrag(eventData)
    return 
  end
  if not self.__couldDeploy then
    self:__ChangeDrag(eventData)
    return 
  end
  if not self._isDragCheckFinish then
    self._checkDragCount = self._checkDragCount - 1
    if self._checkDragCount > 0 then
      return 
    end
    if self._isOpenDragChange then
      local xDiff = (math.abs)((eventData.position).x - (self._startDragPos).x)
      local yDiff = (math.abs)((eventData.position).y - (self._startDragPos).y)
      if yDiff * 3 < xDiff then
        self:__ChangeDrag(eventData)
        return 
      end
    end
    do
      ;
      (self.deployState):BeginDrag2Deploy(self.index)
      self._isDragCheckFinish = true
      ;
      (self.deployState):OnDrag2Deploy(self.index)
    end
  end
end

UINWarChessMain_DNTeamItem.__OnEndDrag = function(self, go, eventData)
  -- function num : 0_8
  if not self.__isHaveHero then
    return 
  end
  if not self.__couldDeploy then
    return 
  end
  ;
  (self.deployState):FinishDrag2Deploy(self.index)
  self._startDragPos = nil
  self._checkDragCount = nil
  self._isDragCheckFinish = nil
end

UINWarChessMain_DNTeamItem.__ChangeDrag = function(self, eventData)
  -- function num : 0_9
  if self._onDragChangeFunc ~= nil then
    (self._onDragChangeFunc)(eventData)
  end
  self._startDragPos = nil
  self._checkDragCount = nil
  self._isDragCheckFinish = nil
end

UINWarChessMain_DNTeamItem.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINWarChessMain_DNTeamItem

