-- params : ...
-- function num : 0 , upvalues : _ENV
local base = ExplorationCtrlBase
local ExplorationSupportCtrl = class("ExplorationSupportCtrl", base)
local DynHero = require("Game.Exploration.Data.DynHero")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
ExplorationSupportCtrl.ctor = function(self, epCtrl)
  -- function num : 0_0 , upvalues : _ENV
  self.eventNetWork = NetworkManager:GetNetwork(NetworkTypeID.EventRoom)
end

ExplorationSupportCtrl.EnterSupportRoomEx = function(self, careerList)
  -- function num : 0_1 , upvalues : _ENV
  local dynPlayer = (self.epCtrl).dynPlayer
  local careerDic = {}
  for k,careerId in ipairs(careerList) do
    careerDic[careerId] = true
  end
  local supportHeroList = {}
  local fightPwerDic = {}
  for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
    if careerDic[heroData.career] and not dynPlayer:ExistDynHeroByDataId(heroId) then
      fightPwerDic[heroData] = heroData:GetFightingPower()
      ;
      (table.insert)(supportHeroList, heroData)
    end
  end
  ;
  (table.sort)(supportHeroList, function(a, b)
    -- function num : 0_1_0 , upvalues : fightPwerDic
    if fightPwerDic[b] >= fightPwerDic[a] then
      do return fightPwerDic[a] == fightPwerDic[b] end
      do return a.dataId < b.dataId end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  UIManager:ShowWindowAsync(UIWindowTypeID.EpSupportRoom, function(window)
    -- function num : 0_1_1 , upvalues : dynPlayer, supportHeroList, self
    if window == nil then
      return 
    end
    window:InitEpSurpportRoomEx(dynPlayer, supportHeroList, self)
    ;
    ((self.epCtrl).autoCtrl):OnEnterEpEventSupportEx(true)
  end
)
end

ExplorationSupportCtrl.EnterSupportRoom = function(self, heroStcList)
  -- function num : 0_2 , upvalues : _ENV
  local supportHeroList = {}
  local dynPlayer = (self.epCtrl).dynPlayer
  for k,stc in ipairs(heroStcList) do
    local dynHeroData = dynPlayer:CreateSupportDynHero(stc)
    if dynHeroData ~= nil then
      (table.insert)(supportHeroList, dynHeroData)
    end
  end
  dynPlayer:ExecuteAllChip2NewHeroList(supportHeroList)
  UIManager:ShowWindowAsync(UIWindowTypeID.EpSupportRoom, function(window)
    -- function num : 0_2_0 , upvalues : dynPlayer, supportHeroList, self
    if window == nil then
      return 
    end
    window:InitEpSurpportRoom(dynPlayer, supportHeroList, self)
    ;
    ((self.epCtrl).autoCtrl):OnEnterEpEventSupportEx(true)
  end
)
end

ExplorationSupportCtrl.ReqChangeSupportHero = function(self, quitHeroUidList, enterIdList)
  -- function num : 0_3 , upvalues : _ENV
  local roomData = (self.epCtrl):GetCurrentRoomData()
  if not self._OnReqChangeHeroFunc then
    self._OnReqChangeHeroFunc = BindCallback(self, self._OnReqChangeSupportHero)
    ;
    (self.eventNetWork):CS_EXPLORATION_EVENT_Assist(roomData.position, quitHeroUidList, enterIdList, self._OnReqChangeHeroFunc)
  end
end

ExplorationSupportCtrl.ReqChangeSupportExHero = function(self, quitHeroUidDic, enterIdDic)
  -- function num : 0_4 , upvalues : _ENV
  local roomData = (self.epCtrl):GetCurrentRoomData()
  if not self._OnReqChangeHeroFunc then
    self._OnReqChangeHeroFunc = BindCallback(self, self._OnReqChangeSupportHero)
    ;
    (self.eventNetWork):CS_EXPLORATION_EVENT_AssistEX(roomData.position, quitHeroUidDic, enterIdDic, self._OnReqChangeHeroFunc)
  end
end

ExplorationSupportCtrl._OnReqChangeSupportHero = function(self, objList)
  -- function num : 0_5 , upvalues : _ENV, ExplorationEnum
  if objList.Count == 0 then
    error("objList.Count == 0")
    return 
  end
  UIManager:DeleteWindow(UIWindowTypeID.EpSupportRoom)
  local msg = objList[0]
  if msg.roleSync == nil then
    return 
  end
  self:ChangeEpHero(msg.roleSync)
  MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).SupportRoom)
end

ChangeDynPlayerHero = function(dynPlayer, enter, quit, battlRoleType)
  -- function num : 0_6 , upvalues : _ENV, DynHero
  local newHeroList = {}
  local heroUidDic = {}
  local mirrorHeroDic = {}
  local addHeroList = {}
  local removeHeroList = {}
  local heroNum = 0
  for k,dynHero in ipairs(dynPlayer.heroList) do
    local mirrorHero = (dynPlayer.mirrorHeroList)[k]
    if quit[dynHero.uid] ~= nil then
      (table.insert)(removeHeroList, dynHero)
    else
      ;
      (table.insert)(newHeroList, dynHero)
      mirrorHeroDic[mirrorHero.uid] = mirrorHero
      if not dynHero:IsBench() then
        heroNum = heroNum + 1
      end
    end
  end
  local maxStateNum = dynPlayer:GetEnterFiledNum()
  for k,role in pairs(enter) do
    local dynHero = dynPlayer:CreateDynHero((role.data).stc, (role.data).dyc, role.roleType)
    dynHero:SetDynHeroFmtIdx(((role.data).dyc).formationIdx)
    dynHero.onBench = maxStateNum <= heroNum
    if not dynHero:IsBench() then
      heroNum = heroNum + 1
    end
    ;
    (table.insert)(newHeroList, dynHero)
    ;
    (table.insert)(addHeroList, dynHero)
    local stc = (role.data).stc
    local mirrorHero = (DynHero.New)(dynHero.heroData, dynHero.uid, battlRoleType)
    mirrorHero:UpdateBaseHeroData(stc.attr, stc.skillGroup, stc.athSkillGroup, stc.additionSkillGroup, stc.rawAttr)
    mirrorHero:SetDynHeroTalentLevel(stc.talent)
    mirrorHero:SetExtraFixedPower(stc.talentEfficiency)
    mirrorHeroDic[mirrorHero.uid] = mirrorHero
  end
  ;
  (table.sort)(newHeroList, function(a, b)
    -- function num : 0_6_0
    do return a:GetDynHeroFmtIdx() < b:GetDynHeroFmtIdx() end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local newMirrorHeroList = {}
  for k,dynHero in ipairs(newHeroList) do
    newMirrorHeroList[k] = mirrorHeroDic[dynHero.uid]
    heroUidDic[dynHero.uid] = dynHero
  end
  dynPlayer:SetPlayerNewHeroList(newHeroList, newMirrorHeroList, heroUidDic, mirrorHeroDic, enter)
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

ExplorationSupportCtrl.ChangeEpHero = function(self, roleSync)
  -- function num : 0_7 , upvalues : _ENV
  local dynPlayer = (self.epCtrl).dynPlayer
  local addHeroList, newHeroList, removeHeroList = dynPlayer:ChangeDynPlayerHeroList(roleSync.enter, roleSync.quit, roleSync.change)
  ExplorationManager:TryUpdataEpMvpHeros(newHeroList, removeHeroList)
  local epWindow = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if epWindow ~= nil then
    epWindow:ReInitDungeonHeroList(dynPlayer)
  end
  ;
  (UIManager:ShowWindow(UIWindowTypeID.ClickContinue)):InitContinue(nil, nil, nil, Color.clear, false)
  ;
  ((self.epCtrl).sceneCtrl):RefreshEpSceneHeroPos(newHeroList)
  ;
  ((self.epCtrl).sceneCtrl):ChangeEpHeroModel(removeHeroList, addHeroList, function()
    -- function num : 0_7_0 , upvalues : _ENV
    UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  end
, true)
end

ExplorationSupportCtrl.OnDelete = function(self)
  -- function num : 0_8
end

return ExplorationSupportCtrl

