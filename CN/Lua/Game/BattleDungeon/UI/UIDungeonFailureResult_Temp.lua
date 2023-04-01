-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonFailureResult_Temp = class("UIExplorationResult", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local JumpManager = require("Game.Jump.JumpManager")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local cs_MessageCommon = CS.MessageCommon
local CCId = 1
UIDungeonFailureResult_Temp.OnInit = function(self)
  -- function num : 0_0 , upvalues : cs_ResLoader, _ENV, UINBaseItemWithCount
  self.isWin = false
  self.rewardsRecord = {}
  self.rewardList = {}
  self.CCNum = nil
  self.resloader = (cs_ResLoader.Create)()
  ;
  (((self.ui).btn_Skada).gameObject):SetActive(true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.OnReturnClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Again, self, self.OnRestartClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Detail, self, self.ShowAllChips)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ViewAllReward, self, self.ShowAllItems)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Skada, self, self.__ShowBattleStatistic)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem1, self, self.OnClickJump2DefeatAdvise, 1)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem2, self, self.OnClickJump2DefeatAdvise, 2)
  ;
  (((self.ui).btn_Again).gameObject):SetActive(false)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem)
  ;
  (((self.ui).rewardItem).gameObject):SetActive(false)
end

UIDungeonFailureResult_Temp.FailDungeon = function(self, clearAction, closeAction, statisticFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.statisticFunc = statisticFunc
  self._auBack = AudioManager:PlayAudioById(3010, function()
    -- function num : 0_1_0 , upvalues : self
    self._auBack = nil
  end
)
  self.rewardsRecord = rewardsRecord
  self.isWin = false
  self._battleEndClear = clearAction
  self.closeAction = closeAction
  local resultBG_Material = ((self.ui).img_ResultBG).material
  if self.isWin then
    ((self.ui).img_ResultState):SetIndex(0)
    ;
    ((self.ui).tex_ResultState):SetIndex(0)
    ;
    ((self.ui).vectoryNode):SetActive(true)
    ;
    ((self.ui).failureNode):SetActive(false)
    resultBG_Material:SetFloat("_Decoloration", 0)
  else
    ;
    ((self.ui).img_ResultState):SetIndex(1)
    ;
    ((self.ui).tex_ResultState):SetIndex(1)
    ;
    ((self.ui).vectoryNode):SetActive(false)
    ;
    ((self.ui).failureNode):SetActive(true)
    resultBG_Material:SetFloat("_Decoloration", 1)
  end
  self:__RefreshDefeatJump()
end

UIDungeonFailureResult_Temp.DungeonFaileSetPlayeAgain = function(self, playerAgainCallback, dInterfaceData)
  -- function num : 0_2 , upvalues : _ENV
  self.playerAgainCallback = playerAgainCallback
  self.__dInterfaceData = dInterfaceData
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_AgainPoint).text = tostring(dInterfaceData:GetReplayStaminaCost())
  ;
  (((self.ui).btn_Again).gameObject):SetActive(true)
end

UIDungeonFailureResult_Temp.OnReturnClicked = function(self)
  -- function num : 0_3
  if self._battleEndClear ~= nil then
    (self._battleEndClear)()
  end
  if self.closeAction ~= nil then
    (self.closeAction)()
  end
end

UIDungeonFailureResult_Temp.OnRestartClicked = function(self)
  -- function num : 0_4
  if self.playerAgainCallback ~= nil then
    (self.playerAgainCallback)(self.__dInterfaceData)
  end
end

UIDungeonFailureResult_Temp.UpdataResultsUI = function(self, isWin)
  -- function num : 0_5
  self:ShowReward()
  self:ShowChip()
  self:ShowCoin()
  self:ShowPowerIncrease()
  self:ShowMVP()
end

UIDungeonFailureResult_Temp.ShowReward = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_MessageCommon
  local hasAth = false
  self.rewardList = {}
  for itemId,num in pairs(self.rewardsRecord) do
    do
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        error("can\'t read itemCfg with id=" .. itemId)
      else
        hasAth = ConfigData:IsRewardNotShowATH(itemCfg)
        if not hasAth and itemCfg.explorationHold then
          do
            (table.insert)(self.rewardList, {itemCfg = itemCfg, num = num})
            -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC35: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  if hasAth then
    if PlayerDataCenter.lastAthDiff ~= nil then
      for _,athData in ipairs(PlayerDataCenter.lastAthDiff) do
        (table.insert)(self.rewardList, {num = 1, itemCfg = athData.itemCfg, isAth = true, athData = athData})
      end
    end
    do
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R2 in 'UnsetPending'

      PlayerDataCenter.lastAthDiff = nil
      local containAth = false
      ;
      (self.rewardItemPool):HideAll()
      ;
      (((self.ui).btn_ViewAllReward).gameObject):SetActive(false)
      for index,v in ipairs(self.rewardList) do
        if index <= 4 then
          do
            local item = (self.rewardItemPool):GetOne()
            if v.isAth then
              item:InitItemWithCount(v.itemCfg, v.num, function()
    -- function num : 0_6_0 , upvalues : _ENV, v
    UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
      -- function num : 0_6_0_0 , upvalues : v
      if win ~= nil then
        win:InitAthDetail(v.itemCfg, v.athData)
      end
    end
)
  end
)
            else
              item:InitItemWithCount(v.itemCfg, v.num)
            end
            if (v.itemCfg).type == eItemType.Arithmetic then
              containAth = true
            end
            -- DECOMPILER ERROR at PC102: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC102: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
      if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
        (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
      end
    end
  end
end

UIDungeonFailureResult_Temp.ShowChip = function(self)
  -- function num : 0_7 , upvalues : _ENV
  self.chipList = ((ExplorationManager.epCtrl).dynPlayer):GetChipList()
  local chipNum = 0
  for _,chipData in ipairs(self.chipList) do
    chipNum = chipNum + chipData:GetCount()
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ChipCount).text = tostring(chipNum)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  if chipNum <= 0 then
    ((self.ui).btn_Detail).interactable = false
  else
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_Detail).interactable = true
  end
end

UIDungeonFailureResult_Temp.ShowCoin = function(self)
  -- function num : 0_8 , upvalues : CCId, _ENV
  self.CCNum = 0
  if (self.rewardsRecord)[CCId] ~= nil then
    self.CCNum = (self.rewardsRecord)[CCId]
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_MoneyCount).text = tostring(self.CCNum)
end

UIDungeonFailureResult_Temp.ShowPowerIncrease = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local power = ((ExplorationManager.epCtrl).dynPlayer):GetTotalFightingPower(true, false)
  local oldPower = ((ExplorationManager.epCtrl).dynPlayer):GetMirrorTeamFightPower(true, false)
  local increase = GetPreciseDecimalStr(power / oldPower * 100, 0)
  ;
  ((self.ui).tex_BuffRate):SetIndex(0, tostring(increase))
end

UIDungeonFailureResult_Temp.ShowMVP = function(self)
  -- function num : 0_10 , upvalues : _ENV, cs_ResLoader
  if ExplorationManager.tempMVP ~= nil then
    local mvpGrade = ExplorationManager.tempMVP
    local heroData = ((mvpGrade.role).character).heroData
    ;
    ((self.ui).tex_MvpType):SetIndex(mvpGrade.gradeType)
    local value = mvpGrade.value
    local totalValue = mvpGrade.totalValue
    ;
    ((self.ui).tex_Rate):SetIndex(0, GetPreciseDecimalStr(value / totalValue * 100, 0))
    if self.bigImgResloader ~= nil then
      (self.bigImgResloader):Put2Pool()
    end
    self.bigImgResloader = (cs_ResLoader.Create)()
    ;
    (self.bigImgResloader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(heroData:GetResPicName()), function(prefab)
    -- function num : 0_10_0 , upvalues : _ENV, self
    DestroyUnityObject(self.bigImgGameObject)
    self.bigImgGameObject = prefab:Instantiate((self.ui).heroBigImgNode)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroList")
  end
)
  end
end

UIDungeonFailureResult_Temp.ShowAllChips = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ViewChips, function(windows)
    -- function num : 0_11_0 , upvalues : self
    if windows ~= nil then
      self.viewAllChipWin = windows
      if self.chipList ~= nil then
        windows:InitChips(self.chipList, self.resloader)
      end
    end
  end
)
end

UIDungeonFailureResult_Temp.ShowAllItems = function(self)
  -- function num : 0_12 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ViewItems, function(windows)
    -- function num : 0_12_0 , upvalues : self
    if windows ~= nil then
      self.viewAllItemWin = windows
      windows:InitItems(self.rewardList, self.resloader)
    end
  end
)
end

UIDungeonFailureResult_Temp.__ShowBattleStatistic = function(self)
  -- function num : 0_13
  if self.statisticFunc ~= nil then
    (self.statisticFunc)()
  end
end

UIDungeonFailureResult_Temp.__RefreshDefeatJump = function(self)
  -- function num : 0_14 , upvalues : _ENV
  local list = (BattleDungeonManager.dunInterfaceData):GetDefeatJumpList()
  local cfg1 = (ConfigData.defeat_jump)[list[1] or 1]
  local cfg2 = (ConfigData.defeat_jump)[list[2] or 2]
  self.__defeatJumpCfgList = {cfg1, cfg2}
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_PicGotoItem2).enabled = false
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_PicGotoItem1).enabled = false
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("ExplorationResultFailures"), function(spriteAtlas)
    -- function num : 0_14_0 , upvalues : _ENV, self, cfg1, cfg2
    if spriteAtlas == nil then
      return 
    end
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem1).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, cfg1.pic_path)
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem2).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, cfg2.pic_path)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem2).enabled = true
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PicGotoItem1).enabled = true
  end
)
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text_GotoItem1).text = (LanguageUtil.GetLocaleText)(cfg1.des)
  -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text_GotoItem2).text = (LanguageUtil.GetLocaleText)(cfg2.des)
end

UIDungeonFailureResult_Temp.OnClickJump2DefeatAdvise = function(self, typeIndex)
  -- function num : 0_15 , upvalues : _ENV, JumpManager
  if self._battleEndClear ~= nil then
    (self._battleEndClear)()
  end
  BattleDungeonManager:InjectBattleExitEvent(function()
    -- function num : 0_15_0 , upvalues : _ENV, self, typeIndex, JumpManager
    (UIManager:GetWindow(UIWindowTypeID.Loading)):SetLoadingTipsSystemId(2)
    ;
    ((CS.GSceneManager).Instance):LoadSceneAsyncByAB((Consts.SceneName).Main, function(ok)
      -- function num : 0_15_0_0 , upvalues : _ENV, self, typeIndex, JumpManager
      (ControllerManager:GetController(ControllerTypeId.HomeController, true)):OnEnterHome()
      UIManager:ShowWindowAsync(UIWindowTypeID.Home, function(window)
        -- function num : 0_15_0_0_0 , upvalues : _ENV, self, typeIndex, JumpManager
        if window == nil then
          return 
        end
        window:SetFrom2Home(AreaConst.Home)
        local defeatJumpCfg = (self.__defeatJumpCfgList)[typeIndex]
        if defeatJumpCfg == nil then
          error("defeatJumpCfg is nil with index " .. tostring(typeIndex))
          return 
        end
        local jumpId = defeatJumpCfg.jump_id
        local jumpArg = defeatJumpCfg.jump_arg
        JumpManager:Jump(jumpId, nil, function()
          -- function num : 0_15_0_0_0_0 , upvalues : _ENV
          local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
          if aftertTeatmentCtrl ~= nil then
            aftertTeatmentCtrl:TeatmentBengin()
          end
        end
, jumpArg)
      end
)
    end
)
  end
)
  if self.closeAction ~= nil then
    (self.closeAction)()
  end
end

UIDungeonFailureResult_Temp.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  if self._auBack ~= nil then
    AudioManager:StopAudioByBack(self._auBack)
    self._auBack = nil
  end
  if self.resLoader ~= nil then
    (self.resLoader):Put2Pool()
    self.resLoader = nil
  end
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
    self.bigImgResloader = nil
  end
  if self.viewAllChipWin ~= nil then
    (self.viewAllChipWin):Delete()
  end
  if self.viewAllItemWin ~= nil then
    (self.viewAllItemWin):Delete()
  end
  ;
  (base.OnDelete)(self)
end

return UIDungeonFailureResult_Temp

