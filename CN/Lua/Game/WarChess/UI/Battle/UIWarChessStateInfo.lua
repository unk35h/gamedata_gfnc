-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWarChessStateInfo = class("UIWarChessStateInfo", UIBaseWindow)
local base = UIBaseWindow
local CS_ResLoader = CS.ResLoader
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local UINDungeonChipList = require("Game.CommonUI.DungeonState.UINDungeonChipList")
local UINDungeonBuffList = require("Game.CommonUI.DungeonState.UINDungeonBuffList")
local UINEpCampFetter = require("Game.Exploration.UI.CampFetter.UINEpCampFetter")
local UINEpResFlyAniPanel = require("Game.CommonUI.DungeonState.ResFly.UINEpResFlyAniPanel")
local UINChipItem = require("Game.CommonUI.Item.UINChipItem")
local CS_DOTween = ((CS.DG).Tweening).DOTween
local cs_Material = (CS.UnityEngine).Material
local ScrambleMode = ((CS.DG).Tweening).ScrambleMode
UIWarChessStateInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : CS_ResLoader, UINDungeonChipList, UINDungeonBuffList, _ENV, UINChipItem, UINEpCampFetter, UINEpResFlyAniPanel
  self.resloader = (CS_ResLoader.Create)()
  self.chipList = (UINDungeonChipList.New)()
  ;
  (self.chipList):Init((self.ui).obj_ChipList)
  self.buffList = (UINDungeonBuffList.New)()
  ;
  (self.buffList):Init((self.ui).obj_BuffList)
  self.getChipOriginScale = (((self.ui).getChipItem).transform).localScale
  ;
  ((self.ui).getChipItem):SetActive(false)
  self.getChipPool = (UIItemPool.New)(UINChipItem, (self.ui).getChipItem)
  self.getChipAniCache = {}
  self.__onMoneyChange = BindCallback(self, self.RefreshMoney)
  self.__onSaveMoneyChange = BindCallback(self, self.RefreshSaveMoney)
  MsgCenter:AddListener(eMsgEventId.EpMoneyChange, self.__onMoneyChange)
  MsgCenter:AddListener(eMsgEventId.EpSaveMoneyChange, self.__onSaveMoneyChange)
  self.__DungeonHeroListActiveSet = BindCallback(self, self.DungeonHeroListActiveSet)
  MsgCenter:AddListener(eMsgEventId.DungeonHeroListActiveSet, self.__DungeonHeroListActiveSet)
  self.isCampFetterUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_CampConnection)
  self.epCampFetterNode = (UINEpCampFetter.New)()
  ;
  (self.epCampFetterNode):Init((self.ui).obj_campBond)
  ;
  (self.epCampFetterNode):Hide()
  ;
  (self.epCampFetterNode):InitEpCampFetter(self.resloader)
  self.resFlyAniNode = (UINEpResFlyAniPanel.New)(self)
  ;
  (self.resFlyAniNode):Init((self.ui).resFlyAnimation)
end

-- DECOMPILER ERROR at PC40: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.InitHeroAndChip = function(self, dynPlayer)
  -- function num : 0_1
  (self.heroList):InitHeroList(dynPlayer.heroList, self.resloader, (self.chipList).selectHeroCallback, dynPlayer:GetEpBuffList())
  ;
  (self.chipList):InitChipList(dynPlayer:GetChipList(), (self.heroList).selectWithChipIdCallback, dynPlayer:GetChipLimitInfo())
  ;
  (self.buffList):InitBuffList(dynPlayer:GetEpBuffList())
  self:UpdateAllCampFetter()
  self:RefreshMoney(true)
end

-- DECOMPILER ERROR at PC43: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.ReInitDungeonHeroList = function(self, dynPlayer)
  -- function num : 0_2
  (self.heroList):InitHeroList(dynPlayer.heroList, self.resloader, (self.chipList).selectHeroCallback, dynPlayer:GetEpBuffList())
end

-- DECOMPILER ERROR at PC46: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.DungeonHeroListActiveSet = function(self, active)
  -- function num : 0_3 , upvalues : _ENV
  do
    if active then
      local win = UIManager:GetWindow(UIWindowTypeID.EpChipDiscard)
      if win ~= nil and win.active then
        self:SetHeroListActive(false)
        return 
      end
    end
    self:SetHeroListActive(active)
    ;
    ((self.ui).obj_campBond):SetActive(not self.isCampFetterUnlock or active)
  end
end

-- DECOMPILER ERROR at PC49: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetHeroListActive = function(self, isActive)
  -- function num : 0_4
  if isActive then
    (self.heroList):SetHpBarActive(true)
  end
  ;
  (self.heroList):SetIsHideHeroList(not isActive)
end

-- DECOMPILER ERROR at PC52: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetHeroListHpBar = function(self, isActive)
  -- function num : 0_5
  (self.heroList):SetHpBarActive(isActive)
end

-- DECOMPILER ERROR at PC55: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.RefreshHeroListHp = function(self, isActive)
  -- function num : 0_6
  (self.heroList):RefreshHeroHp()
end

-- DECOMPILER ERROR at PC58: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.ShowHero = function(self, hero)
  -- function num : 0_7 , upvalues : _ENV
  if hero == nil then
    (self.heroList):Hide()
    return 
  end
  ;
  (self.heroList):Show()
  for index,value in ipairs(((self.heroList).itemPool).listItem) do
    if (value.dynHeroData).dataId == hero.dataId then
      (self.heroList):OnHeroClick((((self.heroList).itemPool).listItem)[index])
      break
    end
  end
end

-- DECOMPILER ERROR at PC61: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.RegisterHeroListCloseCallBack = function(self, callback)
  -- function num : 0_8
  (self.heroList):RegisterExrCloseCallBack(callback)
end

-- DECOMPILER ERROR at PC64: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.CancleHeroListCloseCallBack = function(self)
  -- function num : 0_9
  (self.heroList):CancleExrCloseCallBack()
end

-- DECOMPILER ERROR at PC67: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.OnHeroCoordChanged = function(self)
  -- function num : 0_10
  (self.heroList):OnHeroCoordChanged()
end

-- DECOMPILER ERROR at PC70: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.TowerPlacementChange = function(self, dataId, isOn)
  -- function num : 0_11
  (self.heroList):TowerPlacementChange(dataId, isOn)
end

-- DECOMPILER ERROR at PC73: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetMoneyActive = function(self, active)
  -- function num : 0_12
  ((self.ui).obj_money):SetActive(active)
end

-- DECOMPILER ERROR at PC76: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.RefreshMoney = function(self, isInit)
  -- function num : 0_13 , upvalues : _ENV, ScrambleMode
  local money = 0
  local dynplayer = nil
  if ExplorationManager ~= nil then
    dynplayer = ExplorationManager:GetDynPlayer()
    if dynplayer ~= nil then
      local theMoney = dynplayer:GetMoneyCount()
      if theMoney ~= nil then
        money = theMoney
      end
    end
  end
  do
    ;
    ((self.ui).tex_Money):DOKill(true)
    ;
    (((self.ui).tex_Money):DOText(tostring(money), 1, true, ScrambleMode.Numerals)):SetLink(((self.ui).tex_Money).gameObject)
    if isInit ~= true and self.active then
      AudioManager:PlayAudioById(1007)
    end
    if self.LoadMoneyIcon == nil and dynplayer ~= nil then
      local icon = dynplayer:GetMoneyIconId()
      -- DECOMPILER ERROR at PC58: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).img_Money).sprite = CRH:GetSprite(icon)
      self.LoadMoneyIcon = true
    end
  end
end

-- DECOMPILER ERROR at PC79: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetSaveMoneyActive = function(self, active)
  -- function num : 0_14
  ((self.ui).obj_saveMoney):SetActive(active)
  if active then
    self:RefreshSaveMoney()
  end
end

-- DECOMPILER ERROR at PC82: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.RefreshSaveMoney = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local money = 0
  do
    if self.dynplayer ~= nil then
      local theMoney = (self.dynplayer):GetEpSaveMoney()
      if theMoney ~= nil then
        money = theMoney
      end
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_SaveMoney).text = (math.floor)(money)
    ;
    ((self.ui).obj_saveMoney):SetActive((money ~= 0 and ((self.ui).obj_money).activeSelf))
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

-- DECOMPILER ERROR at PC85: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.Show = function(self)
  -- function num : 0_16 , upvalues : base, _ENV
  if self.active then
    return 
  end
  ;
  (base.Show)(self)
  ;
  (self.chipList):ReFillList()
  self:__ClearFadeTween()
  self.__fadeTween = UIManager:PlayDoFade((self.ui).canvasGroup, 0, 1, 0.5)
  self:SetLoanMoneyActive(false)
end

-- DECOMPILER ERROR at PC88: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.Hide = function(self, withTween)
  -- function num : 0_17 , upvalues : base, _ENV
  if not self.active then
    return 
  end
  ;
  (base.Hide)(self)
  local win = UIManager:GetWindow(UIWindowTypeID.DungeonInfoDetail)
  if win ~= nil then
    win:OnClickRetreat()
  end
  if withTween then
    self:__ClearFadeTween()
    self.__fadeTween = UIManager:PlayDoFade((self.ui).canvasGroup, 1, 0, 0.5)
  end
end

-- DECOMPILER ERROR at PC91: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.__ClearFadeTween = function(self)
  -- function num : 0_18
  if self.__fadeTween ~= nil then
    (self.__fadeTween):Kill()
    self.__fadeTween = nil
  end
end

-- DECOMPILER ERROR at PC94: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.OnHide = function(self)
  -- function num : 0_19
  self.__startGetChipAni = false
  if self.getChipTween ~= nil then
    (self.getChipTween):Kill()
    self.getChipTween = nil
  end
  self.getChipAniCache = {}
  ;
  (((self.ui).eff_GetItem).gameObject):SetActive(false)
  ;
  (self.getChipPool):HideAll()
  ;
  (self.chipList):SetListBlocksRaycasts(true)
  ;
  (self.chipList):SetChipGetEffectEnable(false)
end

-- DECOMPILER ERROR at PC97: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.ShowGetChipAni = function(self, chipData, position, scale, chipReturnMoney)
  -- function num : 0_20 , upvalues : _ENV
  if not ((self.chipList).gameObject).activeInHierarchy then
    return 
  end
  ;
  (table.insert)(self.getChipAniCache, {chipData = chipData, position = position, scale = scale, chipReturnMoney = chipReturnMoney or 0})
  if not self.__startGetChipAni then
    self:__StartShowGetChipAni()
  end
end

-- DECOMPILER ERROR at PC100: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.__StartShowGetChipAni = function(self)
  -- function num : 0_21 , upvalues : _ENV, CS_DOTween
  if #self.getChipAniCache == 0 then
    self.__startGetChipAni = false
    ;
    (self.chipList):SetListBlocksRaycasts(true)
    return 
  end
  ;
  (self.chipList):SetListBlocksRaycasts(false)
  self.__startGetChipAni = true
  local getChipData = (table.remove)(self.getChipAniCache, 1)
  local chipData, position, scale, chipReturnMoney = getChipData.chipData, getChipData.position, getChipData.scale, getChipData.chipReturnMoney
  if not (self.chipList):ListContainChip(chipData.dataId) then
    self:__StartShowGetChipAni()
  end
  ;
  (self.chipList):ScrollChipItemInScreen(chipData, function(targetChipItem)
    -- function num : 0_21_0 , upvalues : self, chipData, position, scale, CS_DOTween, _ENV, chipReturnMoney
    if targetChipItem ~= nil then
      (self.chipList):SetChipGetEffectEnable(true)
      local destPosition = (self.transform):InverseTransformPoint(targetChipItem:GetChipItemWorldPos())
      do
        local chipItem = (self.getChipPool):GetOne()
        chipItem:InitChipItem(chipData)
        chipItem:Show()
        -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

        ;
        (chipItem.transform).localPosition = position
        local curScale = scale or self.getChipOriginScale
        -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (chipItem.transform).localScale = curScale
        ;
        (((self.ui).eff_GetItem).gameObject):SetActive(true)
        -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (((self.ui).eff_GetItem).transform).localPosition = destPosition
        ;
        (((self.ui).eff_GetItem).material):SetFloat("_UI_Player", 0)
        local sequence = (CS_DOTween.Sequence)()
        sequence:Append((chipItem.transform):DOLocalMove(destPosition, (ConfigData.game_config).getChipMoveTime))
        sequence:Join((chipItem.transform):DOScale(self.getChipOriginScale, (ConfigData.game_config).getChipMoveTime))
        sequence:AppendCallback(function()
      -- function num : 0_21_0_0 , upvalues : self, chipItem
      (self.getChipPool):HideOne(chipItem)
    end
)
        sequence:Append((((self.ui).eff_GetItem).material):DOFloat(1, "_UI_Player", (ConfigData.game_config).getChipEffectTime))
        sequence:AppendCallback(function()
      -- function num : 0_21_0_1 , upvalues : self, chipReturnMoney, destPosition
      (self.chipList):SetChipGetEffectEnable(false)
      self.getChipTween = nil
      ;
      (((self.ui).eff_GetItem).gameObject):SetActive(false)
      if chipReturnMoney > 0 then
        self:StartResFxFlyAni(1, destPosition, (((self.ui).img_Money).transform).position, 15)
      end
      self:__StartShowGetChipAni()
    end
)
        self.getChipTween = sequence
        AudioManager:PlayAudioById(1009)
      end
    else
      do
        self:__StartShowGetChipAni()
      end
    end
  end
)
end

-- DECOMPILER ERROR at PC103: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.StartResFxFlyAni = function(self, resId, origin, dest, count)
  -- function num : 0_22
  (self.resFlyAniNode):StartNewResFlyAni(resId, origin, dest, count)
end

-- DECOMPILER ERROR at PC106: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.ChipListWeakenTween = function(self, weaken)
  -- function num : 0_23
  if weaken then
    ((self.ui).topWeakenTween):DORestart()
  else
    ;
    ((self.ui).topWeakenTween):DOPlayBackwards()
  end
end

-- DECOMPILER ERROR at PC109: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.OnlyShowChipList = function(self, oblyShow, showHeroListAndHpBar)
  -- function num : 0_24
  if showHeroListAndHpBar == nil then
    showHeroListAndHpBar = not oblyShow
  end
  if oblyShow then
    self:Show()
    self:DungeonHeroListActiveSet(showHeroListAndHpBar)
    self:SetHeroListHpBar(showHeroListAndHpBar)
    self:SetMoneyActive(false)
    self:SetSaveMoneyActive(false)
    self:SetLoanMoneyActive(false)
  else
    self:DungeonHeroListActiveSet(showHeroListAndHpBar)
    self:SetHeroListHpBar(showHeroListAndHpBar)
    self:SetMoneyActive(true)
    self:SetSaveMoneyActive(true)
  end
end

-- DECOMPILER ERROR at PC112: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.ShowTopInfo = function(self, enable)
  -- function num : 0_25
  if (self.ui).top_info == nil then
    return 
  end
  if enable and not ((self.ui).top_info).activeInHierarchy then
    ((self.ui).top_info):SetActive(true)
    return 
  end
  if not enable and ((self.ui).top_info).activeInHierarchy then
    ((self.ui).top_info):SetActive(false)
  end
end

-- DECOMPILER ERROR at PC115: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.CheckChipListBgShow = function(self, check)
  -- function num : 0_26
  (self.chipList):CheckChipListContainerShow(check)
end

-- DECOMPILER ERROR at PC118: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetLoanMoneyActive = function(self, active, couldLoanNum)
  -- function num : 0_27 , upvalues : _ENV
  ((self.ui).obj_loansMoney):SetActive(active)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  if couldLoanNum ~= nil then
    ((self.ui).tex_LoanMoney).text = tostring(couldLoanNum)
  end
end

-- DECOMPILER ERROR at PC121: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.StopUseChipEffect = function(self)
  -- function num : 0_28
  if self.chipList ~= nil then
    (self.chipList):StopAllUseChipEffect()
  end
end

-- DECOMPILER ERROR at PC124: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.UpdateAllCampFetter = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if not self.isCampFetterUnlock then
    (self.epCampFetterNode):Hide()
    return 
  else
    ;
    (self.epCampFetterNode):Show()
  end
  if ExplorationManager.epCtrl == nil then
    return 
  end
  local usingCampFetterList, totalUsingNum = ((ExplorationManager.epCtrl).campFetterCtrl):GetUsingCampFetterList()
  ;
  (self.epCampFetterNode):RefreshAllCampFetter(usingCampFetterList, totalUsingNum, self.resloader)
end

-- DECOMPILER ERROR at PC127: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.GetEpCampFetterNode = function(self)
  -- function num : 0_30
  return self.epCampFetterNode
end

-- DECOMPILER ERROR at PC130: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.SetBuffListActive = function(self, active)
  -- function num : 0_31
  if active then
    (self.buffList):Show()
  else
    ;
    (self.buffList):Hide()
  end
end

-- DECOMPILER ERROR at PC133: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.TrySetLimitSellBtnActive = function(self, active)
  -- function num : 0_32
  (self.chipList):SetLimitSellBtnActive(active)
end

-- DECOMPILER ERROR at PC136: Confused about usage of register: R12 in 'UnsetPending'

UIDungeonStateInfo.OnDelete = function(self)
  -- function num : 0_33 , upvalues : _ENV, base
  self:__ClearFadeTween()
  if self.getChipTween ~= nil then
    (self.getChipTween):Kill()
    self.getChipTween = nil
  end
  ;
  (self.resloader):Put2Pool()
  self.resloader = nil
  ;
  (self.chipList):Delete()
  ;
  (self.heroList):Delete()
  ;
  (self.buffList):Delete()
  if (self.ui).eff_GetItem ~= nil then
    DestroyUnityObject(((self.ui).eff_GetItem).material)
  end
  MsgCenter:RemoveListener(eMsgEventId.EpMoneyChange, self.__onMoneyChange)
  MsgCenter:RemoveListener(eMsgEventId.EpSaveMoneyChange, self.__onSaveMoneyChange)
  MsgCenter:RemoveListener(eMsgEventId.DungeonHeroListActiveSet, self.__DungeonHeroListActiveSet)
  ;
  (base.OnDelete)(self)
end

return UIDungeonStateInfo

