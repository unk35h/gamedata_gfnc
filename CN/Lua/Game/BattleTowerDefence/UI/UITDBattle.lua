-- params : ...
-- function num : 0 , upvalues : _ENV
local UITDBattle = class("TDBattle", UIBaseWindow)
local base = UIBaseWindow
local CS_BattleManager = (CS.BattleManager).Instance
local UINTDBattleHeroHeadItem = require("Game.BattleTowerDefence.UI.UINTDBattleHeroHeadItem")
local UINTDBattleNextBtn = require("Game.BattleTowerDefence.UI.UINTDBattleNextBtn")
local UINMonsterLevel = require("Game.Exploration.UI.MonsterLevel.UINMonsterLevel")
local UINTDBtParticle = require("Game.BattleTowerDefence.UI.Battle.UINTDBtParticle")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local cs_scrambleMode = ((CS.DG).Tweening).ScrambleMode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local cs_LeanTouch = ((CS.Lean).Touch).LeanTouch
UITDBattle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINTDBtParticle, cs_LeanTouch, UINTDBattleHeroHeadItem, UINTDBattleNextBtn, UINMonsterLevel
  (UIUtil.AddButtonListener)((self.ui).btn_EpStore, self, self.__OnClickResidentStore)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_cancle, self, self.EndDragMode)
  self.tdBtParticleNode = (UINTDBtParticle.New)()
  ;
  (self.tdBtParticleNode):Init((self.ui).particalNode)
  self.__onDragUpdate = BindCallback(self, self.__OnDragUpdate)
  ;
  (cs_LeanTouch.OnFingerSet)("+", self.__onDragUpdate)
  self.__onFingerDown = BindCallback(self, self.__OnFingerDown)
  ;
  (cs_LeanTouch.OnFingerDown)("+", self.__onFingerDown)
  self.__onFingerUp = BindCallback(self, self.__OnFingerUp)
  ;
  (cs_LeanTouch.OnFingerUp)("+", self.__onFingerUp)
  ;
  (((self.ui).img_cancle).gameObject):SetActive(false)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
  self.headPool = (UIItemPool.New)(UINTDBattleHeroHeadItem, (self.ui).heroHeadItem)
  self.__OnDragHeroTower = BindCallback(self, self.OnDragHeroTower)
  self.__OnClickHeroHead = BindCallback(self, self.OnClickHeroHead)
  self.__onChangePointDrag = BindCallback(self, self.ChangePointDrag)
  self.__setCurrentSelectRole = BindCallback(self, self.__SetCurrentSelectRole)
  self.__CountDown = BindCallback(self, self.CountDown)
  self.__ShowCD = BindCallback(self, self.ShowCD)
  MsgCenter:AddListener(eMsgEventId.TDNextCountDown, self.__ShowCD)
  self.__ShowNextClick = BindCallback(self, self.ShowNextClick)
  MsgCenter:AddListener(eMsgEventId.TDNextClickActive, self.__ShowNextClick)
  self.__updateMoney = BindCallback(self, self.__UpdateExpMoney)
  MsgCenter:AddListener(eMsgEventId.EpMoneyChange, self.__updateMoney)
  self.__openBulletTime = BindCallback(self, self.__OpenBulletTime)
  MsgCenter:AddListener(eMsgEventId.TDOpenBulletTime, self.__openBulletTime)
  self.__onTapSetTDRole = BindCallback(self, self.__OnTapSetTDRole)
  MsgCenter:AddListener(eMsgEventId.OnTapSetTDRole, self.__onTapSetTDRole)
  self.__closeBulletTime = BindCallback(self, self.__CloseBulletTime)
  MsgCenter:AddListener(eMsgEventId.TDCloseBulletTime, self.__closeBulletTime)
  self.__displayOtherUI = BindCallback(self, self.__DisplayOtherUI)
  MsgCenter:AddListener(eMsgEventId.TDDisplayOtherUI, self.__displayOtherUI)
  self.__updateTowerList = BindCallback(self, self.OnTowerPlacement)
  MsgCenter:AddListener(eMsgEventId.TDUpdateTowerList, self.__updateTowerList)
  self.showNextWave = false
  self.headers = {}
  self.__OnNextWave = BindCallback(self, self.OnNextWave)
  MsgCenter:AddListener(eMsgEventId.TDNextWava, self.__OnNextWave)
  self.__OnMonsterBorn = BindCallback(self, self.OnMonsterBorn)
  MsgCenter:AddListener(eMsgEventId.TDMonsterBorn, self.__OnMonsterBorn)
  self.__OnReceiveMpSpeed = BindCallback(self, self.OnReceiveMpSpeed)
  MsgCenter:AddListener(eMsgEventId.TDMPAddSpeed, self.__OnReceiveMpSpeed)
  self.__onEnemyIsDead = BindCallback(self, self.__OnEnemyIsDead)
  MsgCenter:AddListener(eMsgEventId.EnemyIsDead, self.__onEnemyIsDead)
  self.tdNextWaveBtn = (UINTDBattleNextBtn.New)()
  ;
  (self.tdNextWaveBtn):Init((self.ui).btn_BattleNext)
  ;
  (self.tdNextWaveBtn):SetNextWaveCallback(BindCallback(self, self.__OnClickNextWave))
  self.monsterLevelView = (UINMonsterLevel.New)()
  ;
  (self.monsterLevelView):Init((self.ui).monsterLevel)
  ;
  (self.monsterLevelView):InitMonsterLevelUI((BattleUtil.GetCurDynPlayer)(), true)
  ;
  (self.monsterLevelView):Hide()
  self._positionTokenInfo = (((self.ui).tokenInfo).transform).localPosition
  self._positionWaitHero = (((self.ui).waitHeroList).transform).localPosition
  self._positionEpStore = (((self.ui).btn_EpStore).transform).localPosition
  ;
  ((self.ui).obj_TokenFx):SetActive(false)
  ;
  (((self.ui).btn_token).onPress):AddListener(BindCallback(self, self.__OnTokenLongPress))
  ;
  (((self.ui).btn_token).onPressUp):AddListener(BindCallback(self, self.__OnTokenPressUp))
  self:ShowDeployTowerTips(false)
end

UITDBattle.InitTDBattle = function(self, waitToCasteTowerEntities, theBattleTowerCount, csCallNextWave, csGetTowerMp, csDragWaitTower, csRetreatTower)
  -- function num : 0_1 , upvalues : _ENV
  if waitToCasteTowerEntities == nil then
    return 
  end
  ;
  (self.headPool):HideAll()
  for k,v in pairs(waitToCasteTowerEntities) do
    if v ~= nil then
      local item = (self.headPool):GetOne()
      item:OnInitHeroItem(v, v:GetTDRoleCastCost(), self.__OnDragHeroTower, self.__OnClickHeroHead, self.__onChangePointDrag, self.__setCurrentSelectRole)
      -- DECOMPILER ERROR at PC25: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (self.headers)[v] = item
    end
  end
  self.__callNextWaveAction = csCallNextWave
  self.__getTowerMpFunction = csGetTowerMp
  self.__dragWaitTower = csDragWaitTower
  self.__retreatTower = csRetreatTower
  ;
  (self.tdNextWaveBtn):Hide()
  ;
  (((self.ui).cDText).gameObject):SetActive(false)
  self:PlayCountDownWarringTween(-1)
  ;
  (((self.ui).btn_EpStore).gameObject):SetActive(true)
  self:__UpdateExpMoney()
  local maxCount = 0
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer ~= nil then
    maxCount = dynPlayer:GetEnterFiledNum()
  end
  self:_RefreshDeployUI(theBattleTowerCount, maxCount)
  ;
  ((self.ui).tDInfo):SetActive(false)
  self:TryShowMonsterLevel(true)
  -- DECOMPILER ERROR at PC75: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).img_TokenBar).fillAmount = 0
  self._mpReplySpeed = 0
  self:LeftPositionSet(false)
  self._isSpecialTDMode = (BattleUtil.IsSpecialTDMode)()
  if self._isSpecialTDMode then
    (((self.ui).waitHeroList).gameObject):SetActive(false)
    ;
    (((self.ui).btn_EpStore).gameObject):SetActive(false)
    ;
    ((self.ui).tokenInfo):SetActive(false)
    ;
    ((self.ui).monsterLevel):SetActive(false)
    ;
    ((self.ui).tDInfo):SetActive(false)
  end
end

UITDBattle.GetBtnCancleUI = function(self)
  -- function num : 0_2
  return (self.ui).img_cancle
end

UITDBattle.InjectTimeScaleAction = function(self, changeTimeScale, getLastTimeScale)
  -- function num : 0_3
  self.__changeTimeScale = changeTimeScale
  self.__getLastTimeScale = getLastTimeScale
end

UITDBattle.__UpdateExpMoney = function(self, money)
  -- function num : 0_4
  if money == nil then
    money = self:__GetCurCoin()
  end
  self:UpdateTowerMp(money)
end

UITDBattle.__SetCurrentSelectRole = function(self, item)
  -- function num : 0_5
  self.curSelectRoleItem = item
  self.onTapSelectRole = true
end

UITDBattle.__OnFingerDown = function(self, leanFinger)
  -- function num : 0_6
  self.__fingerId = leanFinger.Index
end

UITDBattle.__OnFingerUp = function(self, leanFinger)
  -- function num : 0_7
  self.__fingerId = nil
  if self.curSelectRoleItem ~= nil and not self.onTapSelectRole then
    self:EndDragMode()
  end
end

UITDBattle.__OnDragUpdate = function(self, leanFinger)
  -- function num : 0_8
  if not self.onTapSelectRole or self.curSelectRoleItem == nil then
    return 
  end
  if leanFinger.IsOverGui then
    return 
  end
  self:OnDragHeroTower(self.curSelectRoleItem)
end

UITDBattle.OnDragHeroTower = function(self, battleHeroHead, eventData)
  -- function num : 0_9 , upvalues : _ENV
  do
    if not (ConfigData.buildinConfig).TowerOptionInDeploy then
      local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
      if battleCtrl ~= nil and not battleCtrl:BattleIsRunning() then
        return 
      end
    end
    local characterWindow = UIManager:GetWindow(UIWindowTypeID.TDCharactorInfo)
    if characterWindow ~= nil and characterWindow.active then
      characterWindow:Hide()
    end
    local roleEntity = battleHeroHead.roleEntity
    if roleEntity ~= nil then
      (((self.ui).img_cancle).gameObject):SetActive(true)
      self:__DisplayOtherUI(false)
      self:ShowDeployTowerTips(true)
      self:__OpenBulletTime()
      if self.__dragWaitTower ~= nil then
        (self.__dragWaitTower)(roleEntity)
      end
    end
  end
end

UITDBattle.__OnTapSetTDRole = function(self)
  -- function num : 0_10
  (((self.ui).img_cancle).gameObject):SetActive(true)
  self:__DisplayOtherUI(false)
  self:__OpenBulletTime()
  self:ShowDeployTowerTips(true)
end

UITDBattle.OnTowerPlacement = function(self, role, isOn, towerCasteCost, theBattleTowerCount)
  -- function num : 0_11 , upvalues : _ENV
  if not towerCasteCost then
    towerCasteCost = 0
  end
  if not theBattleTowerCount then
    theBattleTowerCount = 0
  end
  if role == nil then
    return 
  end
  local maxCount = 0
  local dynHero = nil
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer ~= nil then
    maxCount = dynPlayer:GetEnterFiledNum()
    dynHero = dynPlayer:GetDynHeroByDataId(role.roleDataId)
  end
  local skillMoudleUI = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
  if isOn then
    local headItem = (self.headers)[role]
    if headItem ~= nil then
      (self.headPool):HideOne(headItem)
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R10 in 'UnsetPending'

      ;
      (self.headers)[role] = nil
    end
    if skillMoudleUI ~= nil and not skillMoudleUI:IsHaveHeroHeadInUlt(role.roleDataId) and dynHero ~= nil then
      skillMoudleUI:AddHeroItemWithoutUltSkill(role.roleDataId, dynHero.heroData)
    end
  else
    do
      theBattleTowerCount = self:GetAliveTowerCount()
      self:ClearCurInputTile(role)
      local item = (self.headPool):GetOne()
      item:OnInitHeroItem(role, towerCasteCost, self.__OnDragHeroTower, self.__OnClickHeroHead, self.__onChangePointDrag, self.__setCurrentSelectRole)
      -- DECOMPILER ERROR at PC76: Confused about usage of register: R10 in 'UnsetPending'

      if (self.headers)[role] == nil then
        (self.headers)[role] = item
      end
      do
        local flag, isUlt = skillMoudleUI:IsHaveHeroHeadInUlt(role.roleDataId)
        if skillMoudleUI ~= nil and flag and not isUlt then
          skillMoudleUI:RemoveHeroItemWithoutUltSkill(role.roleDataId)
        end
        self:_RefreshDeployUI(theBattleTowerCount, maxCount)
        self:RefreshTDHeadState()
        local epWindow = UIManager:ShowWindow(UIWindowTypeID.DungeonStateInfo)
        if epWindow ~= nil then
          epWindow:TowerPlacementChange(role.roleDataId, isOn)
        end
      end
    end
  end
end

UITDBattle._RefreshDeployUI = function(self, theBattleTowerCount, maxCount)
  -- function num : 0_12 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Deploy).text = (string.format)("%d/%d", theBattleTowerCount, maxCount)
  local idx = maxCount <= theBattleTowerCount and 1 or 0
  local texCol = ((self.ui).deployTexCols)[idx + 1]
  local bgCol = ((self.ui).deployBgCols)[idx + 1]
  ;
  ((self.ui).tex_DeployState):SetIndex(idx)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (((self.ui).tex_DeployState).text).color = texCol
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Deploy).color = texCol
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_deployBg).color = bgCol
  self._isFullHero = maxCount <= theBattleTowerCount
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UITDBattle.GetAliveTowerCount = function(self)
  -- function num : 0_13 , upvalues : CS_BattleManager, _ENV
  local theBattleTowerCount = 0
  local battleCtrl = CS_BattleManager.CurBattleController
  if battleCtrl == nil then
    return 0
  end
  local playerTeamCtrl = battleCtrl.PlayerTeamController
  if playerTeamCtrl == nil then
    return 0
  end
  local battleRoleList = playerTeamCtrl.battleRoleList
  if battleRoleList == nil or battleRoleList.Count <= 0 then
    return 0
  end
  for i = 0, battleRoleList.Count - 1 do
    local role = battleRoleList[i]
    if role.roleType == eBattleRoleType.character and role.hp > 0 then
      theBattleTowerCount = theBattleTowerCount + 1
    end
  end
  return theBattleTowerCount
end

UITDBattle.ClearCurInputTile = function(self, role)
  -- function num : 0_14 , upvalues : _ENV
  if role.hp > 0 then
    return 
  end
  local csBattleCtrl = ((CS.BattleManager).Instance).CurBattleController
  if csBattleCtrl == nil then
    return 
  end
  local battleSkillInputCtrl = (csBattleCtrl.PlayerController).battleSkillInputController
  if battleSkillInputCtrl == nil or not battleSkillInputCtrl:IsActive() or battleSkillInputCtrl.inputRole == nil or battleSkillInputCtrl.inputRole ~= role then
    return 
  end
  if battleSkillInputCtrl.cancleSelect ~= nil then
    (battleSkillInputCtrl.cancleSelect)()
  end
  ;
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(705))
end

UITDBattle.EndDragMode = function(self)
  -- function num : 0_15
  (((self.ui).img_cancle).gameObject):SetActive(false)
  self:__DisplayOtherUI(true)
  self:ShowDeployTowerTips(false)
  self:OnTowerInfoHide()
  self:__CloseBulletTime()
  self.curSelectRoleItem = nil
  self.onTapSelectRole = false
end

UITDBattle.ShowDeployTowerTips = function(self, enable)
  -- function num : 0_16
  ((self.ui).messageTips):SetActive(enable)
end

UITDBattle.OnActiveCancleBtn = function(self)
  -- function num : 0_17
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_cancle).color = (self.ui).highlightColor
end

UITDBattle.OnDisActiveCancleBtn = function(self)
  -- function num : 0_18
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).img_cancle).color = (self.ui).normalColor
end

UITDBattle.ShowCD = function(self, frameCount)
  -- function num : 0_19 , upvalues : _ENV
  if frameCount <= 0 then
    self._secCount = 0
    ;
    (((self.ui).cDText).gameObject):SetActive(false)
    self:PlayCountDownWarringTween(-1)
    return 
  end
  self._secCount = (BattleUtil.FrameToTime)(frameCount)
  if self.timer == nil then
    self.timer = TimerManager:StartTimer(1, self.__CountDown, nil, false, false, false)
  end
  ;
  (((self.ui).cDText).gameObject):SetActive(true)
  local floorSec = (math.floor)(self._secCount)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).cDText).text = tostring(floorSec)
  self:PlayCountDownWarringTween(floorSec)
end

UITDBattle.OnUpdateHeroCd = function(self)
  -- function num : 0_20 , upvalues : _ENV
  for i,headItem in ipairs((self.headPool).listItem) do
    headItem:UpdateCd()
  end
end

UITDBattle.CountDown = function(self)
  -- function num : 0_21 , upvalues : _ENV
  self._secCount = self._secCount - 1
  if self._secCount < 0 then
    (((self.ui).cDText).gameObject):SetActive(false)
    self:PlayCountDownWarringTween(-1)
    return 
  end
  local floorSec = (math.floor)(self._secCount)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).cDText).text = tostring(floorSec)
  self:PlayCountDownWarringTween(floorSec)
end

UITDBattle.PlayCountDownWarringTween = function(self, floorSec)
  -- function num : 0_22
  if (((self.ui).Ani_CD).gameObject).activeSelf then
    (((self.ui).Ani_CD).gameObject):SetActive(false)
  end
  if floorSec < 0 then
    return 
  end
  local startSec = (self.ui).flo_CDStarTime or 5
  if startSec < floorSec then
    return 
  end
  if not (((self.ui).Ani_CD).gameObject).activeSelf then
    (((self.ui).Ani_CD).gameObject):SetActive(true)
  end
end

UITDBattle.UpdateTowerMp = function(self, mp)
  -- function num : 0_23 , upvalues : _ENV, CS_BattleManager
  if self._lastMp == mp then
    return 
  end
  self._lastMp = mp
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Token).text = tostring(mp)
  self:RefreshTDHeadState()
  local playerCtrl = CS_BattleManager:GetBattlePlayerController()
  if self._mpReplySpeed or playerCtrl == nil or 0 > 0 then
    self._mpReplyOriTime = Time.time
    if self.mpAddTimerId == nil then
      self.mpAddTimerId = TimerManager:StartTimer(1, self.OnTimerMpForecastProcess, self, false, true, false)
    end
    self:OnTimerMpForecastProcess()
  end
end

UITDBattle.OnReceiveMpSpeed = function(self, mpSpeed)
  -- function num : 0_24 , upvalues : _ENV
  self._mpReplySpeed = mpSpeed / 1000 / (ConfigData.game_config).mpGrowInterval * BattleUtil.LogicFrameCount
end

UITDBattle.__GetCurCoin = function(self)
  -- function num : 0_25 , upvalues : _ENV
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil then
    return 0
  end
  return dynPlayer:GetMoneyCount()
end

UITDBattle.RefreshTDHeadState = function(self)
  -- function num : 0_26 , upvalues : _ENV
  for _,headItem in ipairs((self.headPool).listItem) do
    headItem:UpdateEnoughState(self._lastMp, self._isFullHero)
  end
end

UITDBattle.ShowNextClick = function(self, flag, displayCost, calcMoneyAction)
  -- function num : 0_27 , upvalues : _ENV
  if self.updateNextWaveCostTimerId ~= nil and self.updateNextWaveCostTimerId > 0 then
    TimerManager:StopTimer(self.updateNextWaveCostTimerId)
    self.updateNextWaveCostTimerId = 0
  end
  ;
  (((self.ui).btn_BattleNext).gameObject):SetActive(flag)
  self.showNextWave = flag
  if flag then
    (self.tdNextWaveBtn):Show()
    self.curNextWaveDisplayCost = displayCost
    ;
    (self.tdNextWaveBtn):RefreshNextBtnState(self._curWave, self._totalWave, displayCost)
    self.updateNextWaveCostTimerId = TimerManager:StartTimer(1, (BindCallback(self, self.UpdateNextWaveCostText, calcMoneyAction)), nil, false, false, false)
  else
    ;
    (self.tdNextWaveBtn):Hide()
  end
end

UITDBattle.UpdateNextWaveCostText = function(self, calcMoneyAction)
  -- function num : 0_28
  if calcMoneyAction == nil then
    return 
  end
  self.curNextWaveDisplayCost = calcMoneyAction()
  ;
  (self.tdNextWaveBtn):RefreshRewardCount(self.curNextWaveDisplayCost)
end

UITDBattle.__OnClickNextWave = function(self)
  -- function num : 0_29
  (((self.ui).cDText).gameObject):SetActive(false)
  self.onClickNextWaveClick = true
  self:PlayCountDownWarringTween(-1)
  if self.__callNextWaveAction ~= nil then
    (self.__callNextWaveAction)()
  end
end

UITDBattle.__PlayOnClickNextFx = function(self)
  -- function num : 0_30 , upvalues : _ENV
  local count = 10
  local destPos = (((self.ui).img_TokenIconAni).transform).position
  local originPos = (self.transform):InverseTransformPoint((((self.ui).cDText).transform).position)
  local win = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if win ~= nil then
    win:StartResFxFlyAni(1, originPos, destPos, count)
  end
  self:__PlayTokenIconTween()
end

UITDBattle.__OnClickResidentStore = function(self)
  -- function num : 0_31 , upvalues : _ENV
  if not ExplorationManager:IsInExploration() then
    return 
  end
  local dungeonInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonInfoWin ~= nil then
    dungeonInfoWin:SetMoneyActive(true)
  end
  ;
  (ExplorationManager.epCtrl):OpenResidentStore(function()
    -- function num : 0_31_0 , upvalues : dungeonInfoWin
    dungeonInfoWin:SetMoneyActive(false)
  end
)
end

UITDBattle.GetTowerMp = function(self)
  -- function num : 0_32
  local mp = 0
  if self.__getTowerMpFunction ~= nil then
    mp = (self.__getTowerMpFunction)()
  end
  return mp
end

UITDBattle.OnTdBattleStart = function(self)
  -- function num : 0_33 , upvalues : _ENV
  (((self.ui).btn_EpStore).gameObject):SetActive(false)
  if not (BattleUtil.IsSpecialTDMode)() then
    ((self.ui).tDInfo):SetActive(true)
  end
  self:TryShowMonsterLevel(false)
  local dungeonInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonInfoWin ~= nil then
    dungeonInfoWin:ShowTopInfo(false)
  end
  self:LeftPositionSet(true)
end

UITDBattle.LeftPositionSet = function(self, isInBattle)
  -- function num : 0_34
  (((self.ui).tokenInfo).transform):DOKill(true)
  ;
  (((self.ui).waitHeroList).transform):DOKill(true)
  ;
  (((self.ui).btn_EpStore).transform):DOKill(true)
  if isInBattle then
    ((((self.ui).tokenInfo).transform):DOLocalMove(self._positionTokenInfo, 0.5)):SetLink(((self.ui).tokenInfo).gameObject)
    ;
    ((((self.ui).waitHeroList).transform):DOLocalMove(self._positionWaitHero, 0.5)):SetLink(((self.ui).waitHeroList).gameObject)
    ;
    ((((self.ui).btn_EpStore).transform):DOLocalMove(self._positionEpStore, 0.5)):SetLink(((self.ui).btn_EpStore).gameObject)
  else
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tokenInfo).transform).localPosition = self._positionTokenInfo + (self.ui).pos_waitLeftOffset
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).waitHeroList).transform).localPosition = self._positionWaitHero + (self.ui).pos_waitLeftOffset
    -- DECOMPILER ERROR at PC80: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).btn_EpStore).transform).localPosition = self._positionEpStore + (self.ui).pos_waitLeftOffset
  end
end

UITDBattle.OnBattleEnd = function(self)
  -- function num : 0_35 , upvalues : _ENV
  self:OnTowerInfoHide()
  if self.mpAddTimerId ~= nil then
    TimerManager:StopTimer(self.mpAddTimerId)
    self.mpAddTimerId = nil
  end
  local dungeonInfoWin = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonInfoWin ~= nil then
    dungeonInfoWin:ShowTopInfo(true)
    dungeonInfoWin:ChipListWeakenTween(false)
  end
end

UITDBattle.OnTowerInfoHide = function(self)
  -- function num : 0_36 , upvalues : _ENV
  local tdTowerInfo = UIManager:GetWindow(UIWindowTypeID.TDCharactorInfo)
  if tdTowerInfo ~= nil then
    tdTowerInfo:Hide()
  end
end

UITDBattle.OnTowerInfoShow = function(self, hero, worldPos)
  -- function num : 0_37 , upvalues : _ENV
  local tdInfoUI = UIManager:GetWindow(UIWindowTypeID.TDCharactorInfo)
  if tdInfoUI == nil then
    tdInfoUI = UIManager:ShowWindow(UIWindowTypeID.TDCharactorInfo)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (tdInfoUI.transform).sizeDelta = (Vector2.New)(100, 100)
  else
    tdInfoUI:Show()
  end
  tdInfoUI:InitCharactor(hero, BindCallback(self, self.OnRoleRetreat))
  local uiCamera = UIManager.UICamera
  local mainCamera = UIManager:GetMainCamera()
  local pos = UIManager:World2UIPosition(worldPos, (tdInfoUI.transform).parent, uiCamera, mainCamera)
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((tdInfoUI.gameObject).transform).localPosition = (Vector3.New)(pos.x, pos.y, 0)
end

UITDBattle.OnRoleRetreat = function(self, characterEntity)
  -- function num : 0_38
  if self.__retreatTower ~= nil then
    (self.__retreatTower)(characterEntity)
  end
end

UITDBattle.__DisplayOtherUI = function(self, active)
  -- function num : 0_39
  if active then
    self:__ShowOtherUI()
  else
    self:__HideOtherUI()
  end
end

UITDBattle.__HideOtherUI = function(self)
  -- function num : 0_40 , upvalues : _ENV
  if self.showNextWave then
    (self.tdNextWaveBtn):Hide()
  end
  ;
  ((self.ui).waitHeroList):SetActive(false)
  ;
  ((self.ui).tokenInfo):SetActive(false)
  local battleSkillModule = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
  if battleSkillModule ~= nil and battleSkillModule.active then
    battleSkillModule:Hide(true)
  end
  local UIBattleWin = UIManager:GetWindow(UIWindowTypeID.Battle)
  if UIBattleWin ~= nil and UIBattleWin.active then
    UIBattleWin:Hide()
  end
end

UITDBattle.__ShowOtherUI = function(self)
  -- function num : 0_41 , upvalues : _ENV
  if self.showNextWave then
    (self.tdNextWaveBtn):Show()
  end
  if not self._isSpecialTDMode then
    ((self.ui).waitHeroList):SetActive(true)
    ;
    ((self.ui).tokenInfo):SetActive(true)
  end
  local battleSkillModule = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
  if battleSkillModule ~= nil and not battleSkillModule.active then
    battleSkillModule:Show(true)
  end
  local UIBattleWin = UIManager:GetWindow(UIWindowTypeID.Battle)
  if UIBattleWin ~= nil and not UIBattleWin.active then
    UIBattleWin:Show()
  end
end

UITDBattle.OnClickHeroHead = function(self, roleEntity)
  -- function num : 0_42 , upvalues : _ENV
  local dungeonStateWindow = UIManager:GetWindow(UIWindowTypeID.DungeonStateInfo)
  if dungeonStateWindow ~= nil then
    self:__OpenBulletTime(true)
    dungeonStateWindow:RegisterHeroListCloseCallBack(function()
    -- function num : 0_42_0 , upvalues : dungeonStateWindow, self
    dungeonStateWindow:CancleHeroListCloseCallBack()
    self:__CloseBulletTime()
  end
)
    dungeonStateWindow:OnHeroCoordChanged()
    dungeonStateWindow:ShowHero(roleEntity.character)
  end
end

UITDBattle.OnNextWave = function(self, curWave, totalWave, remainEmptyCount)
  -- function num : 0_43 , upvalues : _ENV
  ((self.ui).tex_Enemy):SetIndex(0, "0", tostring(remainEmptyCount))
  self:CurrentWaveProcess(curWave, totalWave)
  if self.onClickNextWaveClick then
    self.onClickNextWaveClick = false
    self:__PlayOnClickNextFx()
  end
  self._waveEmptyCount = remainEmptyCount
  self._curWave = curWave
  self._totalWave = totalWave
end

UITDBattle.OnMonsterBorn = function(self, remainEmptyCount)
  -- function num : 0_44 , upvalues : _ENV
  ((self.ui).tex_Enemy):SetIndex(0, tostring(self._waveEmptyCount - remainEmptyCount), self._waveEmptyCount)
end

UITDBattle.OnTimerMpForecastProcess = function(self)
  -- function num : 0_45 , upvalues : _ENV
  local diff = Time.time - self._mpReplyOriTime
  local process = (math.clamp)(diff * self._mpReplySpeed, 0, 1)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_TokenBar).fillAmount = process
end

UITDBattle.CurrentWaveProcess = function(self, curWave, totalWave)
  -- function num : 0_46 , upvalues : _ENV
  local cur = tostring(curWave)
  local total = tostring(totalWave)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Process).text = cur .. "/" .. total
end

UITDBattle.__OpenBulletTime = function(self, isPause)
  -- function num : 0_47
  if self.__isOpenBulletTime then
    return 
  end
  self.__isOpenBulletTime = true
  self:__RecordTimeScale()
  self:__SetTimeScaleTemply(isPause)
end

UITDBattle.__CloseBulletTime = function(self)
  -- function num : 0_48 , upvalues : _ENV
  if not self.__isOpenBulletTime then
    return 
  end
  self.__isOpenBulletTime = false
  if self.curTimeScale ~= (Time.unity_time).timeScale then
    return 
  end
  self:__RecoverTimeScale()
end

UITDBattle.__RecordTimeScale = function(self)
  -- function num : 0_49 , upvalues : _ENV
  self.lastRecordTimeScale = (Time.unity_time).timeScale
end

UITDBattle.__SetTimeScaleTemply = function(self, isPause)
  -- function num : 0_50 , upvalues : _ENV
  if not isPause or not 0 then
    local targetScale = (ConfigData.game_config).bulletTime
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (Time.unity_time).timeScale = targetScale
  self.curTimeScale = (Time.unity_time).timeScale
end

UITDBattle.__RecoverTimeScale = function(self)
  -- function num : 0_51 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (Time.unity_time).timeScale = self.lastRecordTimeScale
end

UITDBattle.__GetTopViewTimeLine = function(self)
  -- function num : 0_52 , upvalues : _ENV
  return ((CS.CameraController).Instance).SwitchToTopViewTimeLine
end

UITDBattle.__SwitchToTopView = function(self)
  -- function num : 0_53 , upvalues : _ENV
  if self.ToTopViewing then
    return 
  end
  self:__SetSwitchTimelineEnable(true)
  if self.timeLinePlayCoroutine ~= nil then
    (TimelineUtil.StopTlCo)(self.timeLinePlayCoroutine)
    self.timeLinePlayCoroutine = nil
  end
  if not self.switchToTopViewTimeLine then
    self.switchToTopViewTimeLine = self:__GetTopViewTimeLine()
    if self.switchToTopViewTimeLine ~= nil then
      self.timeLinePlayCoroutine = (TimelineUtil.Play)(self.switchToTopViewTimeLine, nil, false, true, true)
    end
    self.ToTopViewing = true
  end
end

UITDBattle.__SwitchToNormalView = function(self, withoutAnim)
  -- function num : 0_54 , upvalues : _ENV
  if not self.ToTopViewing then
    return 
  end
  if self.timeLinePlayCoroutine ~= nil then
    (TimelineUtil.StopTlCo)(self.timeLinePlayCoroutine)
    self.timeLinePlayCoroutine = nil
  end
  if not self.switchToTopViewTimeLine then
    self.switchToTopViewTimeLine = self:__GetTopViewTimeLine()
    if self.switchToTopViewTimeLine ~= nil then
      if not withoutAnim then
        self.timeLinePlayCoroutine = (TimelineUtil.Rewind)(self.switchToTopViewTimeLine, nil, nil, true, true)
      else
        -- DECOMPILER ERROR at PC33: Confused about usage of register: R2 in 'UnsetPending'

        ;
        (self.switchToTopViewTimeLine).time = 0
        ;
        (self.switchToTopViewTimeLine):Evaluate()
        self:__SetSwitchTimelineEnable(false)
      end
    end
    self.ToTopViewing = false
  end
end

UITDBattle.__SetSwitchTimelineEnable = function(self, enable)
  -- function num : 0_55
  if not self.switchToTopViewTimeLine then
    self.switchToTopViewTimeLine = self:__GetTopViewTimeLine()
    ;
    ((self.switchToTopViewTimeLine).gameObject):SetActive(enable)
  end
end

UITDBattle.ChangePointDrag = function(self, eventData)
  -- function num : 0_56
  eventData.pointerDrag = ((self.ui).heroScrollRect).gameObject
  ;
  ((self.ui).heroScrollRect):OnBeginDrag(eventData)
end

UITDBattle.TryShowMonsterLevel = function(self, enable)
  -- function num : 0_57 , upvalues : _ENV
  if self.monsterLevelView == nil then
    return 
  end
  if not enable then
    (self.monsterLevelView):Hide()
    return 
  end
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  if dynPlayer == nil or dynPlayer.epCommonData == nil or (dynPlayer.epCommonData).monster == nil then
    (self.monsterLevelView):Hide()
    return 
  end
  ;
  (self.monsterLevelView):Show()
  ;
  (self.monsterLevelView):UpdateMonsterLevelByData((dynPlayer.epCommonData).monster)
end

UITDBattle.__OnEnemyIsDead = function(self, rewardCount, worldPos)
  -- function num : 0_58
  if worldPos ~= nil then
    (self.tdBtParticleNode):TDBtPlayCoinAddFx(rewardCount, worldPos)
  end
  self:__PlayTokenIconTween()
end

UITDBattle.__PlayTokenIconTween = function(self)
  -- function num : 0_59 , upvalues : _ENV, cs_DoTween
  ((self.ui).obj_TokenFx):SetActive(true)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  if self.tokenSeq ~= nil then
    (((self.ui).img_TokenIconAni).transform).localScale = Vector3.one
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_TokenIconAni).color = Color.white
    ;
    (self.tokenSeq):Restart()
    return 
  end
  local seq = (cs_DoTween.Sequence)()
  seq:SetAutoKill(false)
  seq:Append((((self.ui).img_TokenIconAni).transform):DOScale((Vector3.New)(3, 3, 1), 0.6))
  seq:Join(((self.ui).img_TokenIconAni):DOFade(0, 0.6))
  seq:OnComplete(function()
    -- function num : 0_59_0 , upvalues : self
    ((self.ui).obj_TokenFx):SetActive(false)
  end
)
  self.tokenSeq = seq
end

UITDBattle.__OnTokenLongPress = function(self)
  -- function num : 0_60 , upvalues : _ENV, HAType, VAType
  if ExplorationManager == nil then
    return 
  end
  local dynplayer = ExplorationManager:GetDynPlayer()
  if dynplayer == nil then
    return 
  end
  local epTypeCfg = ExplorationManager:GetEpTypeCfg()
  if epTypeCfg == nil then
    return 
  end
  local hideInterest = false
  local theMoney = dynplayer:GetMoneyCount()
  if (ConfigData.game_config).towerMoneyMax <= theMoney then
    hideInterest = true
  end
  if epTypeCfg.interest_open then
    local isInterestOpen = not hideInterest
  end
  if not isInterestOpen then
    return 
  end
  local str = ConfigData:GetTipContent(763)
  local n = tostring((epTypeCfg.interest)[1] // 10) .. "%"
  local msg = (string.format)(str, n, (epTypeCfg.interest)[2])
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  win:SetTitleAndContext(nil, msg)
  win:FloatTo(((self.ui).btn_token).transform, HAType.autoCenter, VAType.up)
  win:Copy3DModifier((self.ui).comp_3dModifier)
end

UITDBattle.__OnTokenPressUp = function(self)
  -- function num : 0_61 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UITDBattle.OnDelete = function(self)
  -- function num : 0_62 , upvalues : cs_LeanTouch, _ENV, base
  self.onTapSelectRole = false
  if self.__isOpenBulletTime then
    self:__CloseBulletTime()
  end
  ;
  (self.tdBtParticleNode):Delete()
  ;
  (cs_LeanTouch.OnFingerSet)("-", self.__onDragUpdate)
  ;
  (cs_LeanTouch.OnFingerDown)("-", self.__onFingerDown)
  ;
  (cs_LeanTouch.OnFingerUp)("-", self.__onFingerUp)
  self:__SwitchToNormalView(true)
  if self.timeLinePlayCoroutine ~= nil then
    (TimelineUtil.StopTlCo)(self.timeLinePlayCoroutine)
    self.timeLinePlayCoroutine = nil
  end
  self.switchToTopViewTimeLine = nil
  if self.updateNextWaveCostTimerId ~= nil and self.updateNextWaveCostTimerId > 0 then
    TimerManager:StopTimer(self.updateNextWaveCostTimerId)
  end
  self.__callNextWaveAction = nil
  self.__getTowerMpFunction = nil
  self.__retreatTower = nil
  self.__dragWaitTower = nil
  if self.timer ~= nil and self.timer > 0 then
    TimerManager:StopTimer(self.timer)
    self.timer = nil
  end
  if self.mpAddTimerId ~= nil then
    TimerManager:StopTimer(self.mpAddTimerId)
    self.mpAddTimerId = nil
  end
  self.headers = nil
  for _,headItem in ipairs((self.headPool).listItem) do
    headItem:OnDelete()
  end
  MsgCenter:RemoveListener(eMsgEventId.OnTapSetTDRole, self.__onTapSetTDRole)
  MsgCenter:RemoveListener(eMsgEventId.TDUpdateTowerList, self.__updateTowerList)
  MsgCenter:RemoveListener(eMsgEventId.TDNextCountDown, self.__ShowCD)
  MsgCenter:RemoveListener(eMsgEventId.TDNextClickActive, self.__ShowNextClick)
  MsgCenter:RemoveListener(eMsgEventId.EpMoneyChange, self.__updateMoney)
  MsgCenter:RemoveListener(eMsgEventId.TDOpenBulletTime, self.__openBulletTime)
  MsgCenter:RemoveListener(eMsgEventId.TDCloseBulletTime, self.__closeBulletTime)
  MsgCenter:RemoveListener(eMsgEventId.TDDisplayOtherUI, self.__displayOtherUI)
  MsgCenter:RemoveListener(eMsgEventId.TDNextWava, self.__OnNextWave)
  MsgCenter:RemoveListener(eMsgEventId.TDMonsterBorn, self.__OnMonsterBorn)
  MsgCenter:RemoveListener(eMsgEventId.TDMPAddSpeed, self.__OnReceiveMpSpeed)
  MsgCenter:RemoveListener(eMsgEventId.EnemyIsDead, self.__onEnemyIsDead)
  if self.tokenSeq ~= nil then
    (self.tokenSeq):Kill()
    self.tokenSeq = nil
  end
  if self.monsterLevelView ~= nil then
    (self.monsterLevelView):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UITDBattle

