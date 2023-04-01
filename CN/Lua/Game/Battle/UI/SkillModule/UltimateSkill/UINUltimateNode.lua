-- params : ...
-- function num : 0 , upvalues : _ENV
local UINUltimateNode = class("UINUltimateNode", UIBaseNode)
local base = UIBaseNode
local UINUltSkillHeroItem = require("Game.Battle.UI.SkillModule.UltimateSkill.UINUltSkillHeroItem")
local UINUltSkillMpParticleItem = require("Game.Battle.UI.SkillModule.UltimateSkill.UINUltSkillMpParticleItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HeroData = require("Game.PlayerData.Hero.HeroData")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local CS_DOTween = ((CS.DG).Tweening).DOTween
local ProgressAnimSpeed = 1.5
local MaskRadiusMax = 1
local MaskRadius = 0.3
;
(xlua.private_accessible)(CS.BattlePlayerController)
UINUltimateNode.ctor = function(self, resloader)
  -- function num : 0_0
  self.resloader = resloader
end

UINUltimateNode.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINUltSkillHeroItem, UINUltSkillMpParticleItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ultSkip, self, self.OnUltSkip)
  ;
  (((self.ui).btn_ShowUltDes).onPress):AddListener(BindCallback(self, self.__OnLongPressShowUltDes))
  ;
  (((self.ui).btn_ShowUltDes).onPressUp):AddListener(BindCallback(self, self.__OnPressUpShowUltDes))
  self.__OnHeroItemClicked = BindCallback(self, self.OnHeroItemClicked)
  self.__ShowSkillInfo = BindCallback(self, self.ShowSkillInfo)
  self.__HideSkillInfo = BindCallback(self, self.HideSkillInfo)
  self.__OnRecycleMpParticle = BindCallback(self, self.__RecycleMpParticle)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
  self.heroItemPool = (UIItemPool.New)(UINUltSkillHeroItem, (self.ui).heroHeadItem)
  ;
  ((self.ui).mpParticleItem):SetActive(false)
  self.mpParticleItem = (UIItemPool.New)(UINUltSkillMpParticleItem, (self.ui).mpParticleItem)
  -- DECOMPILER ERROR at PC76: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).focusMask).enabled = false
  self.maskMaterial = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_maskFoucus)
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).focusMask).material = self.maskMaterial
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).videoRenderer).enabled = false
  -- DECOMPILER ERROR at PC94: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).btn_ultSkipRender).raycastTarget = false
  self.__skillFillAmount = 0
  self.__skillEfficent = (ConfigData.game_config).ultMpEfficent / (ConfigData.game_config).ultMpMaxEfficent
  self._img_Value_Height = ((((self.ui).img_Value).transform).rect).height
end

UINUltimateNode.InitBattlePlayerUltSkill = function(self, battleSkillList, useSkillFunc, ultEffectSkipFunc)
  -- function num : 0_2
  self.useSkillFunc = useSkillFunc
  self.ultEffectSkipFunc = ultEffectSkipFunc
  self:CreateUltSkillHero(battleSkillList)
end

UINUltimateNode.CreateUltSkillHero = function(self, battleSkillList)
  -- function num : 0_3 , upvalues : _ENV
  self.hasUltSkill = false
  self.heroItemDic = {}
  self.heroUltItemCount = 0
  self.notSkillHeroItemDic = {}
  ;
  (self.heroItemPool):HideAll()
  local battleOriginRoleList = ((((CS.BattleManager).Instance).CurBattleController).PlayerTeamController).battleOriginRoleList
  local hasSkillHeroIdDic = {}
  local index = 0
  for i = 0, battleSkillList.Count - 1 do
    local battleSkill = battleSkillList[i]
    if battleSkill ~= nil then
      index = index + 1
      if not self.hasUltSkill then
        self.hasUltSkill = true
      end
      local id = (battleSkill.maker).roleDataId
      local heroData = self:_GetHeroData(id)
      hasSkillHeroIdDic[id] = true
      self:AddHeroUltSkill(battleSkill, index, heroData)
    end
  end
  for i = 0, battleOriginRoleList.Count - 1 do
    local roleEntity = battleOriginRoleList[i]
    local heroId = roleEntity.roleDataId
    if roleEntity.x ~= (ConfigData.buildinConfig).BenchX and not hasSkillHeroIdDic[heroId] then
      local heroData = self:_GetHeroData(heroId)
      self:AddHeroItem(heroId, heroData)
    end
  end
end

UINUltimateNode._GetHeroData = function(self, heroId)
  -- function num : 0_4 , upvalues : _ENV, HeroData
  local heroData = nil
  local dynPlayer = (BattleUtil.GetCurDynPlayer)()
  do
    if dynPlayer ~= nil then
      local dynHero = (dynPlayer.heroDic)[heroId]
      if dynHero ~= nil then
        return dynHero.heroData
      end
    end
    heroData = (PlayerDataCenter.heroDic)[heroId]
    do
      if heroData == nil then
        local heroCfg = (ConfigData.hero_data)[heroId]
        heroData = (HeroData.New)({
basic = {id = heroId, level = 1, exp = 0, star = heroCfg.rank, potentialLvl = 0, ts = -1, career = heroCfg.career, company = heroCfg.camp}
})
      end
      return heroData
    end
  end
end

UINUltimateNode.AddUltSkillItemInBattle = function(self, roleDataId, battleSkill)
  -- function num : 0_5
  if (self.heroItemDic)[roleDataId] ~= nil then
    return 
  end
  local index = self.heroUltItemCount + 1
  local heroData = self:_GetHeroData(roleDataId)
  if heroData == nil then
    return 
  end
  self:AddHeroUltSkill(battleSkill, index, heroData)
  self.heroUltItemCount = index
  self.hasUltSkill = true
end

UINUltimateNode.RemoveUltSkillItemInBattle = function(self, roleDataId, battleSkill)
  -- function num : 0_6
  local heroItem = (self.heroItemDic)[roleDataId]
  if heroItem == nil then
    return 
  end
  ;
  (self.heroItemPool):HideOne(heroItem)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.heroItemDic)[roleDataId] = nil
  self.heroUltItemCount = self.heroUltItemCount - 1
end

UINUltimateNode.OnHeroItemClicked = function(self, battleSkill)
  -- function num : 0_7 , upvalues : _ENV
  if self.useSkillFunc == nil then
    return 
  end
  local skillModuleWin = UIManager:GetWindow(UIWindowTypeID.BattleSkillModule)
  if skillModuleWin ~= nil then
    skillModuleWin:SetSelectSkillType(true)
  end
  ;
  (self.useSkillFunc)(battleSkill, false)
  MsgCenter:Broadcast(eMsgEventId.OnUltSkillClick, battleSkill)
end

UINUltimateNode.OnUltSkip = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if ExplorationManager:IsInExploration() and ExplorationManager:IsSectorNewbee() then
    return 
  end
  local win = UIManager:GetWindow(UIWindowTypeID.UltimateSkillShow)
  if win ~= nil then
    win:Delete()
  end
  if self.ultEffectSkipFunc ~= nil then
    (self.ultEffectSkipFunc)()
  end
end

UINUltimateNode.ShowSkillInfo = function(self, item, battleSkill, heroData)
  -- function num : 0_9 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  local isShowDetail = ((CommonUtil.GetDetailDescribeSetting)(eGameSetDescType.skill))
  local name, describe = nil, nil
  if battleSkill == nil then
    for k,skillData in ipairs(heroData.skillList) do
      if skillData:IsUniqueSkill() then
        name = skillData:GetName()
        describe = skillData:GetLevelDescribe(1, nil, isShowDetail)
        break
      end
    end
  else
    do
      name = battleSkill.name
      describe = (battleSkill.skillCfg):GetLevelDescribe(battleSkill.level, false, isShowDetail)
      win:SetTitleAndContext(name, describe)
      win:FloatTo(item.transform, HAType.right, VAType.up)
    end
  end
end

UINUltimateNode.HideSkillInfo = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.FloatingFrame)
end

UINUltimateNode.AddHeroUltSkill = function(self, battleSkill, index, heroData)
  -- function num : 0_11 , upvalues : _ENV
  local heroId = (battleSkill.maker).roleDataId
  if (self.heroItemDic)[heroId] ~= nil then
    warning((string.format)("为英雄%d配置了多个必杀技，请检查配置表。", heroId))
    return 
  end
  local heroItem = (self.heroItemPool):GetOne()
  heroItem:InitUltSkillHeroItem(battleSkill, self.resloader, self.__OnHeroItemClicked, index, (self.ui).efx_offsetZ, heroData, (self.ui).fxpCanvas, (self.ui).hpCanvas)
  heroItem:SetShowUltSkillInfoFunc(self.__ShowSkillInfo, self.__HideSkillInfo)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self.heroItemDic)[heroId] = heroItem
  self.heroUltItemCount = self.heroUltItemCount + 1
  if self.__highlightIntensity ~= nil then
    heroItem:UltSkillUsable(self.__useEnable, self.__highlightIntensity)
  end
end

UINUltimateNode.AddHeroItem = function(self, heroId, heroData)
  -- function num : 0_12
  if (self.notSkillHeroItemDic)[heroId] ~= nil then
    return 
  end
  local heroItem = (self.heroItemPool):GetOne()
  heroItem:InitHeroUltHeadItem(heroData, self.resloader, self)
  heroItem:SetShowUltSkillInfoFunc(self.__ShowSkillInfo, self.__HideSkillInfo)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (self.notSkillHeroItemDic)[heroId] = heroItem
end

UINUltimateNode.RemoveHeroItem = function(self, heorId)
  -- function num : 0_13
  local item = (self.notSkillHeroItemDic)[heorId]
  if item == nil then
    return 
  end
  ;
  (self.heroItemPool):HideOne(item)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.notSkillHeroItemDic)[heorId] = nil
end

UINUltimateNode.OnUpdateLogic_UltimateNode = function(self)
  -- function num : 0_14 , upvalues : _ENV
  for k,skillItem in ipairs((self.heroItemPool).listItem) do
    skillItem:OnUpdateLogic_UltSkillItem(self.__highlightIntensity)
    skillItem:OnUpdateLogic_ReturnCD()
  end
end

UINUltimateNode.OnUpdateRender_UltimateNode = function(self, deltaTime, interpolation)
  -- function num : 0_15 , upvalues : _ENV
  for k,skillItem in ipairs((self.heroItemPool).listItem) do
    skillItem:OnUpdateRender_UltSkillItem(deltaTime, interpolation)
    skillItem:OnUpdateRender_ReturnCD()
  end
end

UINUltimateNode.ShowSideHeadHpBar = function(self, heroHpRateDic)
  -- function num : 0_16 , upvalues : _ENV
  for _,skillItem in pairs((self.heroItemPool).listItem) do
    local rate = heroHpRateDic[skillItem.heroId]
    if rate ~= nil then
      skillItem:SetSideHpBarActive(true, rate)
    else
      skillItem:SetSideHpBarActive(false)
    end
  end
end

UINUltimateNode.ShowHeroReturnCD = function(self, heroId, retrunCD)
  -- function num : 0_17 , upvalues : _ENV
  if self.heroItemPool == nil then
    return 
  end
  for _,skillItem in pairs((self.heroItemPool).listItem) do
    if skillItem.heroId == heroId then
      skillItem:ShowHeroReturnCD(retrunCD)
      break
    end
  end
end

UINUltimateNode.DisableHeroUltSkill = function(self, heroId, disable)
  -- function num : 0_18 , upvalues : _ENV
  if self.heroItemDic == nil then
    return 
  end
  self.__useEnable = not disable
  local heroItem = (self.heroItemDic)[heroId]
  local battleCtrl, playerCtrl = nil, nil
  if (BattleUtil.IsInTDBattle)() then
    battleCtrl = ((CS.BattleManager).Instance).CurBattleController
    if battleCtrl ~= nil then
      playerCtrl = battleCtrl.PlayerController
    end
  end
  if heroItem ~= nil then
    local maker = nil
    if heroItem.battleSkill ~= nil then
      maker = (heroItem.battleSkill).maker
    end
    local isRoleDie = maker ~= nil and maker.hp <= 0
    if not disable and isRoleDie then
      return 
    end
    if playerCtrl ~= nil and isRoleDie then
      playerCtrl:RemoveHeroUltSkill(heroItem.battleSkill)
      self:RemoveUltSkillItemInBattle(heroId, heroItem.battleSkill)
    else
      heroItem:DisableUltSkillHeroItem(disable)
    end
  end
  local isAllDisable = self:CheckAllHeroItemDisable()
  if isAllDisable and self.__tweenLeft then
    ((self.ui).tweenLeft):DOPlayBackwards()
    self.__tweenLeft = false
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINUltimateNode.CheckAllHeroItemDisable = function(self)
  -- function num : 0_19 , upvalues : _ENV
  local isAllDisable = true
  for k,v in pairs(self.heroItemDic) do
    if v ~= nil and not v:IsHeroItemDisabled() then
      isAllDisable = false
      break
    end
  end
  do
    return isAllDisable
  end
end

UINUltimateNode.UpdateUltSkill = function(self, useEnable, curRatio, nextRatio, factor, interpolation)
  -- function num : 0_20 , upvalues : _ENV, ProgressAnimSpeed
  local fillAount = (Mathf.Lerp)(self.__skillFillAmount, nextRatio, interpolation * ProgressAnimSpeed)
  self:RefreshUltMpFillAmount(fillAount)
  self:RefreshUltSkillHero(useEnable, ((self.ui).img_AdvValue).fillAmount)
  self:RefreshUltMpSpeed(factor, true)
end

UINUltimateNode.UpdateUltSkillForce = function(self, useEnable, curRatio, factor)
  -- function num : 0_21
  self:RefreshUltMpFillAmount(curRatio)
  self:RefreshUltSkillHero(useEnable, ((self.ui).img_AdvValue).fillAmount)
  self:RefreshUltMpSpeed(factor, false)
end

UINUltimateNode.RefreshUltSkillHero = function(self, useEnable, fillAount)
  -- function num : 0_22 , upvalues : _ENV
  local allHeroItemDisable = self:CheckAllHeroItemDisable()
  if useEnable then
    self.__useEnable = not allHeroItemDisable
    if self.__useEnable and self.hasUltSkill then
      local efcMentioned = false
      if not self.__tweenLeft then
        ((self.ui).tweenLeft):DOPlayForward()
        self.__tweenLeft = true
        efcMentioned = true
      end
      local intensity = (fillAount - 0.1) / 0.9
      if self.__highlightIntensity ~= intensity or efcMentioned or self.__highlightIntensity >= 1 then
        self.__highlightIntensity = intensity
        for k,heroItem in pairs(self.heroItemDic) do
          heroItem:UltSkillUsable(true, intensity)
          if efcMentioned and not heroItem:IsHeroItemDisabled() then
            heroItem:ShowEfcMetioned()
          end
        end
      end
    else
      do
        if self.__tweenLeft then
          ((self.ui).tweenLeft):DOPlayBackwards()
          self.__tweenLeft = false
        end
        for k,heroItem in pairs(self.heroItemDic) do
          heroItem:UltSkillUsable(false)
        end
        do
          for k,heroItem in pairs(self.notSkillHeroItemDic) do
            heroItem:UltSkillUsable(false)
          end
        end
      end
    end
  end
end

UINUltimateNode.RefreshUltMpFillAmount = function(self, fillAount)
  -- function num : 0_23 , upvalues : _ENV
  self.__skillFillAmount = fillAount
  local efficent = self.__skillEfficent
  local invalidFillAmount = (math.min)(fillAount / efficent, 1)
  local validFillAmount = (math.min)((math.max)(fillAount - efficent, 0) / (1 - efficent), 1)
  if ((self.ui).img_Value).fillAmount < 1 and invalidFillAmount == 1 then
    AudioManager:PlayAudioById(1005)
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Value).fillAmount = invalidFillAmount
  if ((self.ui).img_AdvValue).fillAmount < 1 and validFillAmount == 1 then
    AudioManager:PlayAudioById(1006)
  end
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_AdvValue).fillAmount = validFillAmount
  local posY = 0
  if invalidFillAmount >= 1 then
    posY = self._img_Value_Height * (validFillAmount - 0.5)
  else
    posY = self._img_Value_Height * (invalidFillAmount - 0.5)
  end
  ;
  ((self.ui).progressPoint):SetAnchoredPosition(0, posY)
end

UINUltimateNode.IsUltSkillSlotFull = function(self)
  -- function num : 0_24
  do return ((self.ui).img_Value).fillAmount >= 1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINUltimateNode.RefreshUltMpSpeed = function(self, speed, withTween)
  -- function num : 0_25 , upvalues : _ENV
  local newSpeed = self:GetSpeedInDeployState()
  -- DECOMPILER ERROR at PC7: Unhandled construct in 'MakeBoolean' P1

  if newSpeed or self.__ultMpSpeed == speed then
    return 
  end
  self.__ultMpSpeed = speed
  local speedStr = nil
  if speed >= 10 then
    speedStr = tostring((math.floor)(speed))
  else
    speedStr = (string.format)("%.1f", speed)
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Speed).text = speedStr
  local clampSpeed = (math.min)(speed, 10)
  local posY = ((((self.ui).speedItem).parent).sizeDelta).y * (clampSpeed - 1) / 9
  ;
  ((self.ui).speedItem):SetAnchoredPosition(0, posY)
  if withTween then
    local value = clampSpeed / 10
    local endValue = (Vector3.New)(value, value, value)
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tweenSpeed).endValueV3 = endValue
    ;
    ((self.ui).tweenSpeed):DORestart()
  end
end

UINUltimateNode.GetSpeedInDeployState = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local battleManager = (CS.BattleManager).Instance
  local battleCtrl = battleManager.CurBattleController
  if not battleManager.IsBattleRunning then
    local playerTeam = battleCtrl.PlayerTeamController
    local aliveRoleCount = 0
    aliveRoleCount = aliveRoleCount + self:CheckAndCollectAliveCount(playerTeam.battleOriginRoleList)
    aliveRoleCount = aliveRoleCount + self:CheckAndCollectAliveCount(playerTeam.dungeonRoleList)
    local ultSkillModel = ((battleCtrl.PlayerController).UltSkillHandle).ultSkillModel
    ultSkillModel:InitUltMpFactor(aliveRoleCount, ultSkillModel.dynPlayer)
    return ultSkillModel.UltMpIncreaseFactorOnPercent
  end
  do
    return nil
  end
end

UINUltimateNode.CheckAndCollectAliveCount = function(self, csRoleList)
  -- function num : 0_27
  if csRoleList == nil or csRoleList.Count <= 0 then
    return 0
  end
  local aliveCount = 0
  for i = 0, csRoleList.Count - 1 do
    local role = csRoleList[i]
    if not role.roleOnBench and not role.isDead then
      aliveCount = aliveCount + 1
    end
  end
  return aliveCount
end

UINUltimateNode.CreateMpParticle = function(self, startPos, ratio)
  -- function num : 0_28 , upvalues : _ENV
  if ratio == 0 then
    return 
  end
  local mpPartItem = (self.mpParticleItem):GetOne()
  local posX, posY = UIManager:World2UIPositionOut((self.ui).progressPoint, nil, nil, UIManager.UICamera)
  mpPartItem:InitUltSkillMpParticle(startPos, posX, posY, ratio, self.__OnRecycleMpParticle)
end

UINUltimateNode.__RecycleMpParticle = function(self, mpPartItem)
  -- function num : 0_29
  (self.mpParticleItem):HideOne(mpPartItem)
end

UINUltimateNode.ShowUltSkillFocusMask = function(self, show)
  -- function num : 0_30 , upvalues : MaskRadiusMax, CS_DOTween, _ENV, MaskRadius
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  if show then
    ((self.ui).focusMask).enabled = true
    ;
    (self.maskMaterial):SetFloat("_Radius", MaskRadiusMax)
    local startRadius = (self.maskMaterial):GetFloat("_Radius")
    do
      ((CS_DOTween.To)(function()
    -- function num : 0_30_0 , upvalues : startRadius
    return startRadius
  end
, function(x)
    -- function num : 0_30_1 , upvalues : _ENV, self
    if not IsNull(self.maskMaterial) then
      (self.maskMaterial):SetFloat("_Radius", x)
    end
  end
, MaskRadius, 0.7)):SetLink(self.gameObject)
    end
  else
    do
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).focusMask).enabled = false
    end
  end
end

UINUltimateNode.UpdateUltSkillFocusMask = function(self, screenPos)
  -- function num : 0_31 , upvalues : _ENV
  (self.maskMaterial):SetVector("_Item", (Vector4.New)(screenPos.x, screenPos.y, 0, 0))
end

UINUltimateNode.GetUltSkillMovieRenderer = function(self)
  -- function num : 0_32
  return (self.ui).videoRenderer
end

UINUltimateNode.GetUltSkipBtnRenderer = function(self)
  -- function num : 0_33
  return (self.ui).btn_ultSkipRender
end

UINUltimateNode.ChangeUltSkillUIOrder = function(self, change)
  -- function num : 0_34
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  if change then
    ((self.ui).canvas_heroList).overrideSorting = true
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).canvas_progress).overrideSorting = true
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).raycast_heroList).enabled = false
    ;
    ((self.ui).tween_progress):DORestart()
  else
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).canvas_heroList).overrideSorting = false
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).canvas_progress).overrideSorting = false
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).raycast_heroList).enabled = true
    ;
    ((self.ui).tween_progress):DORewind()
  end
end

UINUltimateNode.IsHaveUltHead = function(self, heroId)
  -- function num : 0_35
  if (self.heroItemDic)[heroId] ~= nil then
    return true, true
  end
  if (self.notSkillHeroItemDic)[heroId] ~= nil then
    return true, false
  end
  return false, false
end

UINUltimateNode.__OnLongPressShowUltDes = function(self)
  -- function num : 0_36 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  local title = ConfigData:GetTipContent(1019)
  local describe = ConfigData:GetTipContent(1018)
  win:SetTitleAndContext(title, describe)
  win:FloatTo(nil, HAType.autoCenter, VAType.up, -20, 20)
end

UINUltimateNode.__OnPressUpShowUltDes = function(self)
  -- function num : 0_37 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.FloatingFrame)
end

UINUltimateNode.OnDelete = function(self)
  -- function num : 0_38 , upvalues : _ENV, base
  self.heroItemCount = 0
  if self.maskMaterial ~= nil then
    DestroyUnityObject(self.maskMaterial)
    self.maskMaterial = nil
  end
  self.useSkillFunc = nil
  self.ultEffectSkipFunc = nil
  ;
  (self.heroItemPool):DeleteAll()
  self.heroItemPool = nil
  ;
  (self.mpParticleItem):DeleteAll()
  self.mpParticleItem = nil
  self:ShowUltSkillFocusMask(false)
  ;
  (base.OnDelete)(self)
end

return UINUltimateNode

