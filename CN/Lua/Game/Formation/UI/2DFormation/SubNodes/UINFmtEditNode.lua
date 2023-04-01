-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtEditNode = class("UINFmtEditNode", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
local cs_tweening = (CS.DG).Tweening
local cs_DOTween = ((CS.DG).Tweening).DOTween
local HeroFilterEnum = require("Game.Hero.NewUI.HeroFilterEnum")
local UINFormationChoiceItem = require("Game.Formation.UI.2DFormation.UINFormationChoiceItem")
local UINFormationChoiceSupportItem = require("Game.Formation.UI.2DFormation.UINFormationChoiceSupportItem")
local UINFormationChioceCareerTog = require("Game.Formation.UI.2DFormation.UINFormationChioceCareerTog")
local UINFmtEvaluation = require("Game.Formation.UI.FormationEvaluation.UIFmtEvaluation")
local FriendSupportHeroData = require("Game.Formation.Data.FriendSupportHeroData")
local FormationUtil = require("Game.Formation.FormationUtil")
local UINFmtHeroFilterTypeToggle = require("Game.Formation.UI.2DFormation.UINFmtHeroFilterTypeToggle")
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local FmtEnum = require("Game.Formation.FmtEnum")
UINFmtEditNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINFormationChoiceSupportItem, UINFormationChioceCareerTog, UINFmtHeroFilterTypeToggle
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ReSet, self, self.OnClickResetFomration)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sort, self, self.OnClickPowerSort)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickChioceClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CompleteRank, self, self.OnFmtCompleteRankClick)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_OfficialSupport, self, self.__OnClickOfficialSuport)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recommend, self, self.__OnClickRecommendFormation)
  self.__OnBeginDragHero = BindCallback(self, self.OnBeginDragHero)
  self.__OnDragHero = BindCallback(self, self.OnDragHero)
  self.__OnEndDragHero = BindCallback(self, self.OnEndDragHero)
  self.__OnClickHero = BindCallback(self, self.OnClickHero)
  self.__OnCheckModelDrag = BindCallback(self, self.OnCheckModelDrag)
  self.__OnPullFormationDeal = BindCallback(self, self.OnPullFormationDeal)
  self.__OnClickSelectSupportHero = BindCallback(self, self.OnClickSelectSupportHero)
  self.__OnClickSupportUnavailable = BindCallback(self, self.OnClickSupportUnavailable)
  -- DECOMPILER ERROR at PC93: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).cardList).onInstantiateItem = BindCallback(self, self.OnInstantiateItem)
  -- DECOMPILER ERROR at PC100: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).cardList).onChangeItem = BindCallback(self, self.OnHeroChangeItem)
  self.heroItemDic = {}
  self.showHeroList = nil
  self.__isInOfficialSupport = false
  self.selectCareer = 0
  self.selectCamp = 0
  self.isDesOrder = true
  self.supportHero = (UINFormationChoiceSupportItem.New)()
  ;
  (self.supportHero):Init((self.ui).obj_SupportHolder)
  self.careerPool = (UIItemPool.New)(UINFormationChioceCareerTog, (self.ui).tog_Filtrate)
  ;
  (((self.ui).tog_Filtrate).gameObject):SetActive(false)
  self._typeTogglePool = (UIItemPool.New)(UINFmtHeroFilterTypeToggle, (self.ui).toggle)
  ;
  ((self.ui).toggle):SetActive(false)
  self._switchOfficialSupportTog = nil
end

UINFmtEditNode.InitFmtEditNode = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_1 , upvalues : _ENV
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  self.resloader = (self.fmtCtrl):GetFmtCtrlResloader()
  ;
  (self._typeTogglePool):HideAll()
  for i = 0, 1 do
    local item = (self._typeTogglePool):GetOne()
    if i == 0 then
      item:InitFilterTypeToggle(i, BindCallback(self, self.RefreshCareerTogs))
    else
      if i == 1 then
        item:InitFilterTypeToggle(i, BindCallback(self, self.RefreshCampTogs))
      end
    end
  end
end

UINFmtEditNode.OpenEmtEditNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnClickQuick)
  AudioManager:PlayAudioById(1077)
  self.heroDataDic = self:__GetCouldChoiceHeroDic()
  self:RefreshPowerSortBtn()
  self:__RefreshIsShowSwitchOfficialSupport()
  self:__RefreshIsShowRecommendFormation()
  local selectTypeIndex = self.selectCamp > 0 and 2 or 1
  for i,typeToggle in ipairs((self._typeTogglePool).listItem) do
    typeToggle:OnToggleHeroFilterType(i == selectTypeIndex)
  end
  self:RefreshPowAndEvaluate()
  self:InitFormationSupportHero()
  ;
  ((self.fmtCtrl).fmtSceneCtrl):RegisterPullFormationDragAct(self.__OnCheckModelDrag, self.__OnPullFormationDeal)
  local heroPassStats = (self.enterFmtData):GetFmtHeroPassInfo()
  ;
  (((self.ui).btn_CompleteRank).gameObject):SetActive(heroPassStats ~= nil)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINFmtEditNode.OnClickQuick = function(self, tohome)
  -- function num : 0_3 , upvalues : _ENV
  if self.fmtCtrl ~= nil then
    (self.fmtCtrl):FmtCtrlQuitEditSate()
  end
  if not tohome then
    GuideManager:TryTriggerGuide(eGuideCondition.InFormation)
    GuideManager:TryTriggerGuide(eGuideCondition.InFormationSpecial)
  end
  ;
  ((self.fmtCtrl).fmtSceneCtrl):RemovePullFormationDragAct()
end

UINFmtEditNode.RefreshEditNode = function(self)
  -- function num : 0_4
  if not self.active then
    return 
  end
  self.heroDataDic = self:__GetCouldChoiceHeroDic()
  self:RefreshHeroList()
  self:RefreshPowAndEvaluate()
  local fomationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if (self.supportHero).heroData ~= fomationData:GetRealSupportHeroData() then
    self:InitFormationSupportHero()
  else
    ;
    (self.supportHero):SetFmtChoiceSupportItemInFmt(fomationData:GetRealSupportHeroData() ~= nil)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINFmtEditNode.__GetCouldChoiceHeroDic = function(self)
  -- function num : 0_5 , upvalues : _ENV, FormationUtil
  local fomationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local formationHeroDic = fomationData:GetFormationHeroDic(true)
  local usedHeroDic = {}
  for formatindex,heroId in pairs(formationHeroDic) do
    usedHeroDic[heroId] = true
  end
  if (self.enterFmtData):IsFmtInWarChessDeploy() then
    local AllFmtIdDic = {}
    local idOffset = (FormationUtil.GetFmtIdOffsetByFmtFromModule)((self.enterFmtData):GetFmtCtrlFromModule())
    local curFmtId = (self.enterFmtData):GetFmtCtrlFmtId()
    local max = (self.enterFmtData):GetFmtTeamSize()
    for i = 1, max do
      local fmtId = nil
      if (self.enterFmtData):IsFmtFixedCouldChangeTeam() then
        fmtId = (self.enterFmtData):GetFmtFixedChangeTeamFmtId(i)
      end
      if fmtId == nil then
        fmtId = idOffset + i
      end
      if fmtId ~= curFmtId then
        AllFmtIdDic[i] = fmtId
      end
    end
    self.otherFmtHeroDic = {}
    self.otherFmtHeroFmtDic = {}
    for index,fmtId in pairs(AllFmtIdDic) do
      local fmtData = (self.fmtCtrl):GetOtherFormationData(fmtId)
      if fmtData ~= nil then
        local fmtHeroDic = fmtData:GetFormationHeroDic(false)
        for fmtIndex,heroId in pairs(fmtHeroDic) do
          -- DECOMPILER ERROR at PC75: Confused about usage of register: R20 in 'UnsetPending'

          (self.otherFmtHeroDic)[heroId] = true
          -- DECOMPILER ERROR at PC80: Confused about usage of register: R20 in 'UnsetPending'

          ;
          (self.otherFmtHeroFmtDic)[heroId] = {fmtData = fmtData, index = index}
        end
      end
    end
  end
  do
    local heroDataDic = {}
    if self.__isInOfficialSupport then
      local usedOfficalSupportDic = {}
      local curOfficialSupportDic = fomationData:GetIsHaveOfficialSupportDic()
      if curOfficialSupportDic ~= nil then
        for fmtIdx,officialSuppotData in pairs(curOfficialSupportDic) do
          usedOfficalSupportDic[officialSuppotData.heroId] = true
        end
      end
      do
        do
          for heroId,heroData in pairs(self.__allOfficialSupportHeroDataDic) do
            if usedOfficalSupportDic[heroId] == nil then
              heroDataDic[heroId] = heroData
            end
          end
          do return heroDataDic end
          for heroId,heroData in pairs(PlayerDataCenter.heroDic) do
            if usedHeroDic[heroId] == nil then
              heroDataDic[heroId] = heroData
            end
          end
          return heroDataDic
        end
      end
    end
  end
end

UINFmtEditNode.RefreshHeroList = function(self, isRefresh)
  -- function num : 0_6 , upvalues : _ENV
  self.showHeroList = {}
  for heroId,heroData in pairs(self.heroDataDic) do
    if (self.selectCareer == 0 or heroData.career == self.selectCareer) and (self.selectCamp == 0 or heroData.camp == self.selectCamp) then
      (table.insert)(self.showHeroList, heroData)
    end
  end
  local powerDic = {}
  for _,heroData in pairs(self.showHeroList) do
    powerDic[heroData.dataId] = heroData:GetFightingPower()
  end
  local isInBattleDeploy = (self.enterFmtData):IsFmtInBattleDeploy()
  ;
  (table.sort)(self.showHeroList, function(heroDataA, heroDataB)
    -- function num : 0_6_0 , upvalues : isInBattleDeploy, self, _ENV, powerDic
    local heroDataIdA = heroDataA.dataId
    local heroDataIdB = heroDataB.dataId
    if isInBattleDeploy then
      local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
      local hpPerA = fmtDungeonDyncData:GetDungeonDyncHeroHpPer(heroDataA)
      local hpPerB = fmtDungeonDyncData:GetDungeonDyncHeroHpPer(heroDataB)
      local deadA = hpPerA == 0
      local deadB = hpPerB == 0
      if deadA ~= deadB then
        return deadB
      end
    end
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    -- DECOMPILER ERROR at PC42: Unhandled construct in 'MakeBoolean' P1

    if not (self.otherFmtHeroDic)[heroDataIdA] and (wcCtrl.teamCtrl):GetHeroDynDataById(heroDataA.dataId) == nil then
      local isDeployedA = wcCtrl == nil
      local isDeployedB = (self.otherFmtHeroDic)[heroDataIdB] or (wcCtrl.teamCtrl):GetHeroDynDataById(heroDataB.dataId) ~= nil
      if isDeployedA ~= isDeployedB then
        return isDeployedB
      end
      local hpPerA = (wcCtrl.teamCtrl):GetWcTeamHeroHpPer(heroDataA.dataId)
      local hpPerB = (wcCtrl.teamCtrl):GetWcTeamHeroHpPer(heroDataB.dataId)
      local deadA = hpPerA == 0
      do
        local deadB = hpPerB == 0
        if deadA ~= deadB then
          return deadB
        end
        if heroDataA.dataId >= heroDataB.dataId then
          do return powerDic[heroDataA.dataId] ~= powerDic[heroDataB.dataId] end
          if powerDic[heroDataB.dataId] >= powerDic[heroDataA.dataId] then
            do return not self.isDesOrder end
            do return powerDic[heroDataA.dataId] < powerDic[heroDataB.dataId] end
            -- DECOMPILER ERROR: 17 unprocessed JMP targets
          end
        end
      end
    end
  end
)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).cardList).totalCount = #self.showHeroList
  if isRefresh then
    ((self.ui).cardList):RefreshCells()
  else
    ;
    ((self.ui).cardList):RefillCells()
  end
  ;
  ((self.ui).obj_noCard):SetActive(((self.ui).cardList).totalCount == 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINFmtEditNode.OnInstantiateItem = function(self, go)
  -- function num : 0_7 , upvalues : UINFormationChoiceItem
  local item = (UINFormationChoiceItem.New)(self.fmtCtrl, self.enterFmtData)
  item:Init(go)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.heroItemDic)[go] = item
end

UINFmtEditNode.OnHeroChangeItem = function(self, go, index)
  -- function num : 0_8 , upvalues : _ENV
  local heroData = (self.showHeroList)[index + 1]
  local item = (self.heroItemDic)[go]
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((item.ui).cg_heroCardHolder).alpha = 1
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((item.ui).tweenHolder).localPosition = Vector2.zero
  item:InitChoiceItem(heroData, self.resloader, self.__OnBeginDragHero, self.__OnDragHero, self.__OnEndDragHero, self.__OnClickHero)
  if (self.enterFmtData):IsFmtInWarChessDeploy() then
    local isShowOtherFmtHero = (self.otherFmtHeroDic)[heroData.dataId]
    item:SetShowInOtherFmt(isShowOtherFmtHero)
    local wcCtrl = WarChessManager:GetWarChessCtrl()
    if wcCtrl then
      local hpPer = (wcCtrl.teamCtrl):GetWcTeamHeroHpPer(heroData.dataId)
      item:UpdFmtHeroChoiceItemHp(hpPer)
    end
  end
  do
    if (self.enterFmtData):IsFmtInBattleDeploy() then
      local hpPer = ((self.enterFmtData):GetFmtDungeonDyncData()):GetDungeonDyncHeroHpPer(heroData)
      item:UpdFmtHeroChoiceItemHp(hpPer)
    end
  end
end

UINFmtEditNode.__GetFmtHeroItemByIndex = function(self, index)
  -- function num : 0_9 , upvalues : _ENV
  local go = ((self.ui).cardList):GetCellByIndex(index)
  if not IsNull(go) then
    return (self.heroItemDic)[go]
  end
  return nil
end

UINFmtEditNode.__CalculateUIPosAndCanSeekPlatform = function(self, touchPos)
  -- function num : 0_10 , upvalues : _ENV
  local uiPos = UIManager:Screen2UIPosition(touchPos, ((self.transform).gameObject):GetComponent(typeof((CS.UnityEngine).RectTransform)), UIManager.UICamera)
  if self._autoPutPosY == nil then
    local rectTrWordPos = (((self.ui).rectTr_Touch2Recycle).transform):TransformPoint(Vector3.zero)
    local rectTrlocalPos = (self.transform):InverseTransformPoint(rectTrWordPos)
    self._autoPutPosY = rectTrlocalPos.y + (((self.ui).rectTr_Touch2Recycle).rect).height / 2
  end
  do
    local isCanSeek = self._autoPutPosY < uiPos.y
    do return uiPos, isCanSeek end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

UINFmtEditNode.OnBeginDragHero = function(self, eventData, item)
  -- function num : 0_11
  self.startDragPos = eventData.position
  self.checkDragCount = 3
  self.__dragingHero = false
end

UINFmtEditNode.OnDragHero = function(self, eventData, item)
  -- function num : 0_12 , upvalues : _ENV, cs_MessageCommon, UINFormationChoiceItem
  if self.checkDragCount >= 0 then
    self.checkDragCount = self.checkDragCount - 1
    if self.checkDragCount == 0 then
      local xDiff = (math.abs)((eventData.position).x - (self.startDragPos).x)
      local yDiff = (math.abs)((eventData.position).y - (self.startDragPos).y)
      if yDiff * 3 < xDiff then
        if self.__guideData ~= nil then
          return 
        end
        ;
        ((self.ui).cardList):ChangePointDrag(eventData)
      else
        ;
        ((self.ui).cardList):StopMovement()
        if self.__guideData ~= nil and (item.heroData).dataId ~= (self.__guideData).heroId then
          return 
        end
        if (self.enterFmtData):IsFmtInWarChessDeploy() then
          local heroId = (item.heroData).dataId
          local isShowOtherFmtHero = (self.otherFmtHeroDic)[heroId]
          local otherFmtData = (self.otherFmtHeroFmtDic)[heroId]
          if isShowOtherFmtHero then
            local teamName = (otherFmtData.fmtData).name
            if (string.IsNullOrEmpty)(teamName) then
              teamName = (string.format)(ConfigData:GetTipContent(TipContent.WarChess_TeamDefaultName), tostring(otherFmtData.index))
            end
            local msg = (string.format)(ConfigData:GetTipContent(8712), teamName)
            ;
            (cs_MessageCommon.ShowMessageTipsWithErrorSound)(msg)
            return 
          end
          do
            do
              local wcCtrl = WarChessManager:GetWarChessCtrl()
              if wcCtrl ~= nil and (wcCtrl.teamCtrl):GetWcTeamHeroHpPer((item.heroData).dataId) <= 0 then
                return 
              end
              local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
              if fmtDungeonDyncData ~= nil and fmtDungeonDyncData:GetDungeonDyncHeroHpPer(item.heroData) <= 0 then
                (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2903))
                item:SetSelectedState(true)
                return 
              end
              if (self.enterFmtData):IsFmtFixedHeroId((item.heroData).dataId) then
                (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(1002))
                item:SetSelectedState(true)
                return 
              end
              item:SetSelectedState(true)
              self.__dragingHero = true
              ;
              (self.fmtCtrl):FmtCtrlOnStartDraggingCard(item.heroData)
              if self.copyCard == nil then
                self.copyCard = (UINFormationChoiceItem.New)(self.fmtCtrl, self.enterFmtData)
                local go = ((self.ui).heroCardHolder):Instantiate(self.transform)
                ;
                (self.copyCard):Init(go)
                -- DECOMPILER ERROR at PC180: Confused about usage of register: R7 in 'UnsetPending'

                ;
                ((self.copyCard).transform).localScale = (Vector3.New)(0.8, 0.8, 0.8)
              end
              do
                ;
                (self.copyCard):Show()
                ;
                (self.copyCard):InitChoiceItem(item.heroData, self.resloader)
                AudioManager:PlayAudioById(1059)
                if (self.enterFmtData):IsFmtInBattleDeploy() then
                  local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
                  local hpPer = fmtDungeonDyncData:GetDungeonDyncHeroHpPer(item.heroData)
                  ;
                  (self.copyCard):UpdFmtHeroChoiceItemHp(hpPer)
                end
                do
                  if not self.__dragingHero then
                    return 
                  end
                  local uiPos, isCanSeek = self:__CalculateUIPosAndCanSeekPlatform(eventData.position)
                  -- DECOMPILER ERROR at PC223: Confused about usage of register: R5 in 'UnsetPending'

                  ;
                  ((self.copyCard).transform).localPosition = (Vector3.New)(uiPos.x, uiPos.y, 0)
                  if isCanSeek then
                    ((self.fmtCtrl).fmtSceneCtrl):SeekHeroPutPlatform()
                  else
                    ;
                    ((self.fmtCtrl).fmtSceneCtrl):RecoverHeroPutPlatform()
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end

UINFmtEditNode.OnEndDragHero = function(self, eventData, item)
  -- function num : 0_13 , upvalues : _ENV
  item:SetSelectedState(false)
  if not self.__dragingHero then
    return 
  end
  self.__dragingHero = false
  ;
  (self.copyCard):Hide()
  ;
  (self.fmtCtrl):FmtCtrlOnEndDraggingCard()
  local uiPos, isCanSeek = self:__CalculateUIPosAndCanSeekPlatform(eventData.position)
  if not isCanSeek then
    return 
  end
  do
    if self.__guideData ~= nil then
      local lastHeroPlat = ((self.fmtCtrl).fmtSceneCtrl):GetFmtLastSeekHeroPlat()
      -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

      if lastHeroPlat ~= nil and lastHeroPlat.fmtIndex == (self.__guideData).posId then
        (self.__guideData).compelete = true
      else
        ;
        ((self.fmtCtrl).fmtSceneCtrl):RecoverHeroPutPlatform()
      end
    end
    local flag, beReplaceHeroData = ((self.fmtCtrl).fmtSceneCtrl):ConfirmHeroPutPlatform((self.copyCard).heroData)
    if flag then
      if (item.heroData).isFriendSupport then
        item:SetFmtChoiceSupportItemInFmt(true)
      else
        -- DECOMPILER ERROR at PC61: Confused about usage of register: R7 in 'UnsetPending'

        ;
        (self.heroDataDic)[((self.copyCard).heroData).dataId] = nil
      end
      if beReplaceHeroData ~= nil then
        if beReplaceHeroData.isFriendSupport then
          (self.supportHero):SetFmtChoiceSupportItemInFmt(false)
        else
          -- DECOMPILER ERROR at PC86: Confused about usage of register: R7 in 'UnsetPending'

          if (beReplaceHeroData.isOfficialSupport or self.__isInOfficialSupport) and beReplaceHeroData.isOfficialSupport and self.__isInOfficialSupport then
            (self.heroDataDic)[beReplaceHeroData.dataId] = beReplaceHeroData
          end
        end
      end
      -- DECOMPILER ERROR at PC90: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.heroDataDic)[beReplaceHeroData.dataId] = beReplaceHeroData
      self:RefreshHeroList(true)
      ;
      (self.fmtCtrl):OnCurrentFmtChanged()
      local voiceId = ConfigData:GetVoicePointRandom(eVoicePointType.EnterTeam, nil, ((self.copyCard).heroData).dataId)
      local cvCtr = ControllerManager:GetController(ControllerTypeId.Cv, true)
      cvCtr:PlayCv(((self.copyCard).heroData).dataId, voiceId)
    end
  end
end

UINFmtEditNode.OnClickHero = function(self, heroData)
  -- function num : 0_14 , upvalues : _ENV
  if self.__guideData ~= nil then
    return 
  end
  if self.copyCard ~= nil and (self.copyCard).active then
    return 
  end
  if heroData.isFriendSupport then
    return 
  end
  if heroData.isOfficialSupport then
    UIManager:ShowWindowAsync(UIWindowTypeID.SupportHeroState, function(win)
    -- function num : 0_14_0 , upvalues : heroData
    if win == nil then
      return 
    end
    win:InitSupportHeroState(heroData)
  end
)
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroState, function(win)
    -- function num : 0_14_1 , upvalues : heroData, self
    if win ~= nil then
      win:InitHeroState(heroData, self.showHeroList)
    end
  end
)
end

UINFmtEditNode.OnCheckModelDrag = function(self, touchPos)
  -- function num : 0_15
  local uiPos, isCanSeek = self:__CalculateUIPosAndCanSeekPlatform(touchPos)
  ;
  (((self.ui).rectTr_Touch2Recycle).gameObject):SetActive(true)
  ;
  ((self.ui).obj_noCard):SetActive(false)
  if isCanSeek and (((self.ui).doTween_RecycleImage).tween):IsPlaying() then
    ((self.ui).doTween_RecycleImage):DOPause()
    -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).canvasGroup_RecycleImage).alpha = 1
  end
  if not (((self.ui).doTween_RecycleImage).tween):IsPlaying() then
    ((self.ui).doTween_RecycleImage):DORestart()
  end
  return not isCanSeek
end

UINFmtEditNode.OnPullFormationDeal = function(self, heroData)
  -- function num : 0_16
  ((self.ui).doTween_RecycleImage):DOPause()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).canvasGroup_RecycleImage).alpha = 1
  ;
  (((self.ui).rectTr_Touch2Recycle).gameObject):SetActive(false)
  if ((self.ui).cardList).totalCount ~= 0 then
    ((self.ui).obj_noCard):SetActive(heroData ~= nil)
    do return  end
    if heroData.isFriendSupport then
      (self.supportHero):SetFmtChoiceSupportItemInFmt(false)
    else
      -- DECOMPILER ERROR at PC49: Confused about usage of register: R2 in 'UnsetPending'

      if (heroData.isOfficialSupport or self.__isInOfficialSupport) and heroData.isOfficialSupport and self.__isInOfficialSupport then
        (self.heroDataDic)[heroData.dataId] = heroData
      end
    end
    -- DECOMPILER ERROR at PC53: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.heroDataDic)[heroData.dataId] = heroData
    self:RefreshHeroList(true)
    ;
    (self.fmtCtrl):OnCurrentFmtChanged()
    -- DECOMPILER ERROR: 6 unprocessed JMP targets
  end
end

UINFmtEditNode.InitFormationSupportHero = function(self)
  -- function num : 0_17 , upvalues : _ENV, FriendSupportHeroData
  local fomationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if not (self.enterFmtData):GetFmtIsFriendSupport() then
    if (self.enterFmtData):GetFmtForceShowSupportNotAvaliable() then
      (self.supportHero):Show()
      ;
      (self.supportHero):InitAsUnavailable(self.__OnClickSupportUnavailable)
      return 
    end
    ;
    (self.supportHero):Hide()
    return 
  end
  ;
  (self.supportHero):Show()
  if (self.enterFmtData):GetFmtIsFriendSupportTimeLimitted() then
    (self.supportHero):InitAsExhaustCard()
    return 
  end
  local supportHeroData = fomationData:GetRealSupportHeroData()
  local inFmt = supportHeroData ~= nil
  if supportHeroData == nil then
    supportHeroData = (self.fmtCtrl):GetCacheSelectedSupportHero()
  end
  local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
  if fmtDungeonDyncData ~= nil and fmtDungeonDyncData:HasDgDyncLastAstHero() then
    local brief, random = fmtDungeonDyncData:GetDgDyncAscHeroData()
    local fixCfg = (PlayerDataCenter.supportHeroData):GetCurFormationLevelEffectByAllHero(PlayerDataCenter.heroDic)
    supportHeroData = (FriendSupportHeroData.CreatSupportHeroDataBase)(brief, random, fixCfg)
  end
  if supportHeroData ~= nil then
    (self.supportHero):InitChoiceItem(supportHeroData, (self.fmtCtrl).resloader, self.__OnBeginDragHero, self.__OnDragHero, self.__OnEndDragHero, self.__OnClickSelectSupportHero)
    ;
    (self.supportHero):SetFmtChoiceSupportItemInFmt(inFmt)
    if fmtDungeonDyncData ~= nil then
      local hpPer = fmtDungeonDyncData:GetDungeonDyncHeroHpPer(supportHeroData)
      ;
      (self.supportHero):UpdFmtHeroChoiceItemHp(hpPer)
    end
  else
    (self.supportHero):InitAsEmpuyCard(self.__OnClickSelectSupportHero)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINFmtEditNode.OnClickSelectSupportHero = function(self)
  -- function num : 0_18 , upvalues : cs_MessageCommon, _ENV, FmtEnum
  if self.__guideData ~= nil then
    return 
  end
  local fmtDungeonDyncData = (self.enterFmtData):GetFmtDungeonDyncData()
  if fmtDungeonDyncData ~= nil and fmtDungeonDyncData:HasDgDyncLastAstHero() then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(2904))
    return 
  end
  if (self.enterFmtData):GetFmtCtrlFromModule() == (FmtEnum.eFmtFromModule).DailyDungeon and FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_DailyDungeonQuick) and not PlayerDataCenter:IsDungeonModuleOpenQuick(fmtDungeonDyncData.moduleId) then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(9307), function()
    -- function num : 0_18_0 , upvalues : self
    self:__EnterSupprtSelect()
  end
, nil)
    return 
  end
  self:__EnterSupprtSelect()
end

UINFmtEditNode.__EnterSupprtSelect = function(self)
  -- function num : 0_19 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.SelectSupportList, function(win)
    -- function num : 0_19_0 , upvalues : self, _ENV
    if win ~= nil then
      local fomationData = (self.fmtCtrl):GetFmtCtrlFmtData()
      do
        win:InitSelectSupportHeroList(function(friednSupportHeroData)
      -- function num : 0_19_0_0 , upvalues : fomationData, self, _ENV
      local supportHeroData = fomationData:GetRealSupportHeroData()
      if supportHeroData ~= nil and friednSupportHeroData ~= supportHeroData then
        fomationData:CleanSupportData()
        ;
        ((self.fmtCtrl).fmtSceneCtrl):RefreshFmtScene()
      end
      if friednSupportHeroData ~= nil then
        (self.supportHero):InitChoiceItem(friednSupportHeroData, (self.fmtCtrl).resloader, self.__OnBeginDragHero, self.__OnDragHero, self.__OnEndDragHero, self.__OnClickSelectSupportHero)
        do
          if fmtDungeonDyncData ~= nil then
            local hpPer = 10000
            ;
            (self.supportHero):UpdFmtHeroChoiceItemHp(hpPer)
          end
          ;
          (self.fmtCtrl):CacheSelectedSupportHero(friednSupportHeroData)
        end
      end
    end
, self.selectCareer, fomationData)
      end
    end
  end
)
end

UINFmtEditNode.ClearSupportCard = function(self)
  -- function num : 0_20
  (self.supportHero):InitAsEmpuyCard(self.__OnClickSelectSupportHero)
end

UINFmtEditNode.OnClickSupportUnavailable = function(self)
  -- function num : 0_21 , upvalues : cs_MessageCommon, _ENV
  if (self.enterFmtData):IsFmtChallengeMode() then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(960))
    return 
  end
  ;
  (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7004))
end

UINFmtEditNode.RefreshPowerSortBtn = function(self)
  -- function num : 0_22
  local color = ((self.ui).img_ArrowUp).color
  color.a = self.isDesOrder and 0.5 or 1
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_ArrowUp).color = color
  color = ((self.ui).img_ArrowDown).color
  color.a = self.isDesOrder and 1 or 0.5
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_ArrowDown).color = color
end

UINFmtEditNode.RefreshCareerTogs = function(self)
  -- function num : 0_23 , upvalues : _ENV, HeroFilterEnum
  if self.__OnClickCareerFiltrate == nil then
    self.__OnClickCareerFiltrate = BindCallback(self, self.OnClickCareerFiltrate)
  end
  self.selectCamp = 0
  ;
  (self.careerPool):HideAll()
  local careerMax = (HeroFilterEnum.eKindMaxCount)[(HeroFilterEnum.eKindType).Career]
  for i = 0, careerMax do
    local careerTog = (self.careerPool):GetOne()
    careerTog:InitCareerTog(i, self.__OnClickCareerFiltrate)
    if self.selectCareer == i then
      careerTog:SetTogState(true)
    end
  end
end

UINFmtEditNode.RefreshCampTogs = function(self)
  -- function num : 0_24 , upvalues : _ENV, HeroFilterEnum
  if self.__OnClickCampFlitrate == nil then
    self.__OnClickCampFlitrate = BindCallback(self, self.OnClickCampFlitrate)
  end
  self.selectCareer = 0
  ;
  (self.careerPool):HideAll()
  local careerMax = (HeroFilterEnum.eKindMaxCount)[(HeroFilterEnum.eKindType).Camp]
  for i = 0, careerMax do
    local careerTog = (self.careerPool):GetOne()
    careerTog:InitCompany(i, self.__OnClickCampFlitrate)
    if self.selectCamp == i then
      careerTog:SetTogState(true)
    end
  end
end

UINFmtEditNode.RefreshPowAndEvaluate = function(self, totalFtPower, totalBenchPower)
  -- function num : 0_25 , upvalues : UINFmtEvaluation, _ENV
  local isEditShowPow = (self.enterFmtData):GetFmtEditIsShowPow()
  local isEditShowEvaluate = (self.enterFmtData):GetFmtEditIsShowEvaluate()
  ;
  ((self.ui).curPower):SetActive(isEditShowPow)
  ;
  ((self.ui).evaluation):SetActive(isEditShowEvaluate)
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if isEditShowEvaluate then
    if self.fmtEvaluation == nil then
      self.fmtEvaluation = (UINFmtEvaluation.New)()
      ;
      (self.fmtEvaluation):Init((self.ui).evaluation)
      local sectorStageId = (self.enterFmtData):GetFmtCtrlFmtIdStageId()
      local fromModule = (self.enterFmtData):GetFmtCtrlFromModule()
      ;
      (self.fmtEvaluation):InitializeAdvantageConfig(sectorStageId, fromModule)
      for _,careerItem in ipairs((self.careerPool).listItem) do
        careerItem:SetEvaluation(((self.fmtEvaluation).advTypeDic)[careerItem.advTypeId] == true)
      end
    end
    if formationData ~= nil then
      (self.fmtEvaluation):AnalysisFormation(formationData:GetFormationHeroDic())
    end
  end
  if isEditShowPow and formationData ~= nil then
    if totalFtPower == nil then
      totalFtPower = (self.fmtCtrl):CalculatePower(formationData)
    end
    local power = totalFtPower + totalBenchPower
    -- DECOMPILER ERROR at PC85: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_CurPower).text = tostring(power)
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINFmtEditNode.OnClickResetFomration = function(self)
  -- function num : 0_26 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.MessageCommon, function(win)
    -- function num : 0_26_0 , upvalues : _ENV, self
    if win ~= nil then
      win:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(389), function()
      -- function num : 0_26_0_0 , upvalues : self, _ENV
      local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
      if self.__isInOfficialSupport then
        local officialSptDic = formationData:GetIsHaveOfficialSupportDic()
        if officialSptDic ~= nil then
          for _,officialSuppotData in pairs(officialSptDic) do
            -- DECOMPILER ERROR at PC17: Confused about usage of register: R7 in 'UnsetPending'

            (self.heroDataDic)[officialSuppotData.heroId] = officialSuppotData.o_heroData
          end
        end
      else
        do
          for _,heroId in pairs(formationData:GetFormationHeroDic(true)) do
            -- DECOMPILER ERROR at PC34: Confused about usage of register: R6 in 'UnsetPending'

            (self.heroDataDic)[heroId] = ((((self.fmtCtrl).fmtSceneCtrl).heroEntityIdDic)[heroId]):GetFmtHeroEntityData()
          end
          do
            formationData.data = {}
            formationData:CleanSupportData()
            self:RefreshHeroList()
            ;
            ((self.fmtCtrl).fmtSceneCtrl):ClearFmtInEditorModel()
            ;
            ((self.fmtCtrl).fmtSceneCtrl):RefreshFmtScene(true)
            ;
            (self.fmtCtrl):OnCurrentFmtChanged()
            ;
            (self.supportHero):SetFmtChoiceSupportItemInFmt(false)
          end
        end
      end
    end
, nil)
    end
  end
)
end

UINFmtEditNode.OnClickPowerSort = function(self)
  -- function num : 0_27 , upvalues : _ENV
  self.isDesOrder = not self.isDesOrder
  self:RefreshHeroList()
  self:RefreshPowerSortBtn()
  AudioManager:PlayAudioById(4100)
end

UINFmtEditNode.OnClickCareerFiltrate = function(self, careerId, item)
  -- function num : 0_28 , upvalues : _ENV
  self.selectCareer = careerId
  self:RefreshHeroList()
  ;
  ((self.ui).tr_CurSel):SetParent(item.transform)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tr_CurSel).localPosition = Vector3.zero
end

UINFmtEditNode.OnClickCampFlitrate = function(self, campId, item)
  -- function num : 0_29 , upvalues : _ENV
  self.selectCamp = campId
  self:RefreshHeroList()
  ;
  ((self.ui).tr_CurSel):SetParent(item.transform)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tr_CurSel).localPosition = Vector3.zero
end

UINFmtEditNode.TryRefreshHeroCard = function(self, heroIdDic, isSkin)
  -- function num : 0_30 , upvalues : _ENV
  for index,heroData in pairs(self.showHeroList) do
    local heroId = heroData.dataId
    if heroIdDic[heroId] ~= nil then
      local cardItem = self:__GetFmtHeroItemByIndex(index - 1)
      if cardItem ~= nil then
        if isSkin then
          (cardItem.heroCardItem):UpdateSkin()
        else
          ;
          (cardItem.heroCardItem):RefreshHeroCardItem()
          cardItem:OnShowChoiceRedTip()
          cardItem:OnShowChoiceNorTip()
        end
      end
    end
  end
end

UINFmtEditNode.SetFmtEditorGuideData = function(self, heroId, posId)
  -- function num : 0_31
  self.__guideData = {heroId = heroId, posId = posId, compelete = false}
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_cardList).raycastTarget = false
  ;
  ((self.ui).cardList):StopMovement()
  ;
  ((self.fmtCtrl).fmtSceneCtrl):GuideDisableClickPlat(true)
end

UINFmtEditNode.IsFmtEditorGuideComplete = function(self)
  -- function num : 0_32
  if self.__guideData == nil then
    return true
  end
  return (self.__guideData).compelete
end

UINFmtEditNode.ClearFmtEditorGuideData = function(self)
  -- function num : 0_33
  self.__guideData = nil
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).rect_cardList).raycastTarget = true
  ;
  ((self.fmtCtrl).fmtSceneCtrl):GuideDisableClickPlat(false)
end

UINFmtEditNode.OnFmtCompleteRankClick = function(self)
  -- function num : 0_34 , upvalues : _ENV
  local heroPassStats = (self.enterFmtData):GetFmtHeroPassInfo()
  if heroPassStats == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.FormationRankPreview, function(window)
    -- function num : 0_34_0 , upvalues : heroPassStats
    if window == nil then
      return 
    end
    window:InitFmtRankPreview(heroPassStats)
  end
)
end

UINFmtEditNode.__RefreshIsShowSwitchOfficialSupport = function(self)
  -- function num : 0_35 , upvalues : UINCommonSwitchToggle
  local isHave = (self.enterFmtData):GetIsHaveOfficialSupport()
  ;
  (((self.ui).btn_OfficialSupport).gameObject):SetActive(isHave)
  if isHave and self._switchOfficialSupportTog == nil then
    self._switchOfficialSupportTog = (UINCommonSwitchToggle.New)()
    ;
    (self._switchOfficialSupportTog):Init((self.ui).tog_OfficialSupport)
    ;
    (self._switchOfficialSupportTog):InitCommonSwitchToggle(self.__isInOfficialSupport, nil)
  end
end

UINFmtEditNode.__OnClickOfficialSuport = function(self)
  -- function num : 0_36 , upvalues : cs_DOTween, _ENV
  if self.__isInOfficialSupport then
    self.__allOfficialSupportHeroDataDic = nil
  else
    local allOfficialSupportHeroDataDic = (self.enterFmtData):GetIsHaveOfficialSupportHeroDic()
    self.__allOfficialSupportHeroDataDic = allOfficialSupportHeroDataDic
  end
  do
    self.__isInOfficialSupport = not self.__isInOfficialSupport
    ;
    (self._switchOfficialSupportTog):SetCommonSwitchToggleValue(self.__isInOfficialSupport)
    if self.__officialUpportsSquence ~= nil then
      (self.__officialUpportsSquence):Kill()
      self.__officialUpportsSquence = nil
    end
    local sequence = (cs_DOTween.Sequence)()
    sequence:AppendInterval(0.01)
    for go,cardItem in pairs(self.heroItemDic) do
      sequence:Join(((cardItem.ui).tweenHolder):DOLocalMoveY(-200, 0.2))
      sequence:Join(((cardItem.ui).cg_heroCardHolder):DOFade(0, 0.2))
    end
    sequence:AppendInterval(0.2)
    sequence:AppendCallback(function()
    -- function num : 0_36_0 , upvalues : self
    self:RefreshEditNode()
  end
)
    sequence:AppendCallback(function()
    -- function num : 0_36_1 , upvalues : _ENV, self, sequence
    for index,heroData in ipairs(self.showHeroList) do
      index = index - 1
      local cardItem = self:__GetFmtHeroItemByIndex(index)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R6 in 'UnsetPending'

      if cardItem ~= nil then
        do
          ((cardItem.ui).cg_heroCardHolder).alpha = 0
          -- DECOMPILER ERROR at PC18: Confused about usage of register: R6 in 'UnsetPending'

          ;
          ((cardItem.ui).tweenHolder).localPosition = Vector2.zero
          sequence:Join(((((cardItem.ui).tweenHolder):DOLocalMoveY(-200, 0.2)):From()):SetDelay(0.015 * (index)))
          sequence:Join((((cardItem.ui).cg_heroCardHolder):DOFade(1, 0.2)):SetDelay(0.015 * (index)))
          -- DECOMPILER ERROR at PC45: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC45: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
)
    self.__officialUpportsSquence = sequence
  end
end

UINFmtEditNode.__RefreshIsShowRecommendFormation = function(self)
  -- function num : 0_37
  local isHave = (self.enterFmtData):GetCouldShowWarChessRecommendBtn()
  ;
  (((self.ui).btn_Recommend).gameObject):SetActive(isHave)
end

UINFmtEditNode.__OnClickRecommendFormation = function(self)
  -- function num : 0_38 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessRecommeFormationWindow, function(window)
    -- function num : 0_38_0 , upvalues : self
    if window == nil then
      return 
    end
    local recommendTeamList = (self.enterFmtData):GetWarChessRecommendTeam()
    local recommendSkillDataList = (self.enterFmtData):GetWarChessRecommendSkillData()
    window:InitWCSRecommendTeamAndSkill(recommendTeamList, recommendSkillDataList)
    ;
    ((window.gameObject).transform):SetAsLastSibling()
  end
)
end

UINFmtEditNode.OnClickChioceClose = function(self)
  -- function num : 0_39 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UINFmtEditNode.OnDelete = function(self)
  -- function num : 0_40 , upvalues : _ENV
  UIManager:DeleteWindow(UIWindowTypeID.WarChessRecommeFormationWindow)
  if self.__officialUpportsSquence ~= nil then
    (self.__officialUpportsSquence):Kill()
    self.__officialUpportsSquence = nil
  end
end

return UINFmtEditNode

