-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessResult = class("UIWarChessResult", base)
local cs_ResLoader = CS.ResLoader
local HeroData = require("Game.PlayerData.Hero.HeroData")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
local JumpManager = require("Game.Jump.JumpManager")
UIWarChessResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  self.resloader = ((CS.ResLoader).Create)()
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).rewardItem)
  ;
  (((self.ui).rewardItem).gameObject):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Return, self, self.OnReturnClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Detail, self, self.OnClickTeamChipDetail)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem1, self, self.OnClickJump2DefeatAdvise, 1)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_GotoItem2, self, self.OnClickJump2DefeatAdvise, 2)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GotoTechUp, self, self.OnClickJump2ActTech)
end

UIWarChessResult.InitWarChessResult = function(self, isWin)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).vectoryNode):SetActive(isWin)
  ;
  ((self.ui).failureNode):SetActive(not isWin)
  self._isWin = isWin
  local isWCS = WarChessSeasonManager:GetIsInWCSeason()
  if isWin then
    AudioManager:PlayAudioById(1003)
    ;
    ((self.ui).img_ResultState):SetIndex(0)
    ;
    ((self.ui).tex_ResultState):SetIndex(0)
    ;
    (((self.ui).img_ResultBG).material):SetFloat("_Decoloration", 0)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ResultBG).color = (self.ui).col_Success
    do
      if WarChessManager:IsWCCouldRestart() then
        local restartFunc, restartCostId, restartCostNum = WarChessManager:GetWCRestart()
        -- DECOMPILER ERROR at PC55: Confused about usage of register: R6 in 'UnsetPending'

        ;
        ((self.ui).tex_AgainPoint).text = tostring(againCostStamina)
        ;
        (((self.ui).btn_Again).gameObject):SetActive(true)
      end
      self:__ShowMVP()
      AudioManager:PlayAudioById(1004)
      ;
      ((self.ui).img_ResultState):SetIndex(1)
      if isWCS then
        ((self.ui).tex_ResultState):SetIndex(2)
      else
        ;
        ((self.ui).tex_ResultState):SetIndex(1)
      end
      ;
      (((self.ui).img_ResultBG).material):SetFloat("_Decoloration", 1)
      ;
      ((self.ui).suggestBtn):SetActive(true)
      ;
      ((self.ui).suggestTips):SetActive(false)
      do
        local battleFailJumpUnlock = FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_BattleFailJump)
        if not battleFailJumpUnlock then
          (((self.ui).failureNode).gameObject):SetActive(false)
        end
        self:__RefreshDefeatJump()
        self:__ShowChip()
        self:__ShowCoin()
        self:__ShowPowerIncrease()
        self:__RefreshTechBtn()
      end
    end
  end
end

UIWarChessResult.__RefreshTechBtn = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not WarChessSeasonManager:IsInWCS() then
    return 
  end
  local openFunc, reddotOPenFunc = WarChessSeasonManager:GetSeasonTechJumpFunc()
  if openFunc == nil then
    return 
  end
  self._openTechFunc = openFunc
  ;
  (((self.ui).btn_GotoTechUp).gameObject):SetActive(true)
  ;
  (((self.ui).btn_GotoItem1).gameObject):SetActive(false)
  ;
  ((self.ui).redDot_GotoTechUp):SetActive((reddotOPenFunc ~= nil and reddotOPenFunc()))
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIWarChessResult.RefreshWCResultReward = function(self, wcSettelRewardData)
  -- function num : 0_3 , upvalues : _ENV
  if not wcSettelRewardData.firstPassRewardDic then
    local firstPassRewardDic = table.emptytable
  end
  if not wcSettelRewardData.innerWCReardDic then
    local innerWCReardDic = table.emptytable
  end
  if not wcSettelRewardData.stmStorePickRewardDic then
    local stmStorePickRewardDic = table.emptytable
  end
  local isHaveFirstReward = (table.count)(firstPassRewardDic) > 0
  local isHaveInnerReward = (table.count)(innerWCReardDic) > 0
  local isHaveRewardBagReward = (table.count)(stmStorePickRewardDic) > 0
  local isHaveReward = isHaveFirstReward or isHaveInnerReward or isHaveRewardBagReward
  ;
  ((self.ui).rewardRect):SetActive(isHaveReward)
  ;
  ((self.ui).noReward):SetActive(not isHaveReward)
  ;
  ((self.ui).tex_noReward):SetIndex(0)
  ;
  ((self.ui).firstList):SetActive(isHaveFirstReward)
  ;
  ((self.ui).normalList):SetActive(isHaveInnerReward or isHaveRewardBagReward)
  ;
  (self.rewardItemPool):HideAll()
  if isHaveFirstReward then
    for itemId,itemNum in pairs(firstPassRewardDic) do
      local rewardItem = (self.rewardItemPool):GetOne()
      local itemCfg = (ConfigData.item)[itemId]
      rewardItem:InitItemWithCount(itemCfg, itemNum)
      ;
      (rewardItem.transform):SetParent(((self.ui).firstList).transform)
    end
  end
  local normalRewardDic = {}
  if isHaveInnerReward then
    for key,value in pairs(innerWCReardDic) do
      normalRewardDic[key] = (normalRewardDic[key] or 0) + value
    end
  end
  if isHaveRewardBagReward then
    for key,value in pairs(stmStorePickRewardDic) do
      normalRewardDic[key] = (normalRewardDic[key] or 0) + value
    end
  end
  for itemId,itemNum in pairs(normalRewardDic) do
    local rewardItem = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    rewardItem:InitItemWithCount(itemCfg, itemNum)
    ;
    (rewardItem.transform):SetParent(((self.ui).normalList).transform)
  end
  -- DECOMPILER ERROR: 14 unprocessed JMP targets
end

UIWarChessResult.RefreshWCLevelInfo = function(self, name, indexName)
  -- function num : 0_4
  (((self.ui).tex_LevelName).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelCount).text = indexName
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelName).text = name
end

UIWarChessResult.__ShowChip = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local teamDic = (wcCtrl.teamCtrl):GetWCTeams()
  local allChipLevel = 0
  for _,teamData in pairs(teamDic) do
    local dynPlayer = teamData:GetTeamDynPlayer()
    local chipList = dynPlayer:GetChipList()
    for _,chipData in pairs(chipList) do
      allChipLevel = allChipLevel + chipData:GetCount()
    end
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ChipCount).text = tostring(allChipLevel)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  if allChipLevel <= 0 then
    ((self.ui).btn_Detail).interactable = false
  else
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).btn_Detail).interactable = true
  end
end

UIWarChessResult.__ShowCoin = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local CCNum = (wcCtrl.backPackCtrl):GetWCCoinNum()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_MoneyCount).text = tostring(CCNum)
end

UIWarChessResult.__ShowPowerIncrease = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local teamDic = (wcCtrl.teamCtrl):GetWCTeams()
  local totalNewPower = 0
  local totalOldPower = 0
  for _,teamData in pairs(teamDic) do
    local dynPlayer = teamData:GetTeamDynPlayer()
    local newPower = dynPlayer:GetTotalFightingPower(true, false)
    local oldPower = dynPlayer:GetMirrorTeamFightPower(true, false) or 1
    totalNewPower = totalNewPower + newPower
    totalOldPower = totalOldPower + oldPower
  end
  local increase = ((totalNewPower) / (totalOldPower) - 1) * 100
  if increase <= 0 or not increase then
    increase = 0
  end
  ;
  ((self.ui).tex_BuffRate):SetIndex(0, GetPreciseDecimalStr(increase, 0))
end

UIWarChessResult.__ShowMVP = function(self)
  -- function num : 0_8 , upvalues : _ENV, HeroData
  local wcCtrl = WarChessManager:GetWarChessCtrl()
  local epMvpData = (wcCtrl.teamCtrl):GetWCMvpData()
  if epMvpData ~= nil then
    local heroId, MvpType, diggestRate = epMvpData:GetEpMvpData()
    local heroData = (wcCtrl.teamCtrl):GetHeroDynDataById(heroId)
    do
      if heroData == nil then
        local heroCfg = (ConfigData.hero_data)[heroId]
        heroData = (HeroData.New)({
basic = {id = heroId, level = 1, exp = 0, star = heroCfg.rank, potentialLvl = 0, ts = -1, career = heroCfg.career, company = heroCfg.camp, skinId = (PlayerDataCenter.skinData):DealNotSelfHaveHeroSkinOverraid(0, heroId)}
})
      end
      ExplorationManager:PlayMVPVoice(heroId)
      ;
      ((self.ui).tex_MvpType):SetIndex(MvpType)
      ;
      ((self.ui).tex_Rate):SetIndex(0, GetPreciseDecimalStr(diggestRate * 100, 0))
      self:_LoadMvpPic(heroData:GetResPicName())
    end
  end
end

UIWarChessResult._LoadMvpPic = function(self, resPicName)
  -- function num : 0_9 , upvalues : cs_ResLoader, _ENV
  if self.bigImgResloader ~= nil then
    (self.bigImgResloader):Put2Pool()
  end
  self.bigImgResloader = (cs_ResLoader.Create)()
  ;
  (self.bigImgResloader):LoadABAssetAsync(PathConsts:GetCharacterBigImgPrefabPath(resPicName), function(prefab)
    -- function num : 0_9_0 , upvalues : _ENV, self
    DestroyUnityObject(self.bigImgGameObject)
    self.bigImgGameObject = prefab:Instantiate((self.ui).heroBigImgNode)
    local commonPicCtrl = (self.bigImgGameObject):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroList")
  end
)
end

UIWarChessResult.OnClickTeamChipDetail = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WarChessViewChip, function(window)
    -- function num : 0_10_0
    if window ~= nil then
      window:InitAllTeamChips()
    end
  end
)
end

UIWarChessResult.OnReturnClicked = function(self)
  -- function num : 0_11 , upvalues : _ENV
  WarChessManager:ExitWarChess((Consts.SceneName).Sector, self._isWin, nil, function()
    -- function num : 0_11_0 , upvalues : _ENV
    local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
    if aftertTeatmentCtrl ~= nil then
      aftertTeatmentCtrl:TeatmentBengin()
    end
  end
)
end

UIWarChessResult.__RefreshDefeatJump = function(self)
  -- function num : 0_12 , upvalues : _ENV
  local cfg1 = (ConfigData.defeat_jump)[1]
  local cfg2 = (ConfigData.defeat_jump)[2]
  self.__defeatJumpCfgList = {cfg1, cfg2}
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_PicGotoItem2).enabled = false
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_PicGotoItem1).enabled = false
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetAtlasAssetPath("ExplorationResultFailures"), function(spriteAtlas)
    -- function num : 0_12_0 , upvalues : _ENV, self, cfg1, cfg2
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
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).text_GotoItem1).text = (LanguageUtil.GetLocaleText)(cfg1.des)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).text_GotoItem2).text = (LanguageUtil.GetLocaleText)(cfg2.des)
end

UIWarChessResult.OnClickJump2DefeatAdvise = function(self, typeIndex)
  -- function num : 0_13 , upvalues : _ENV, JumpManager
  WarChessManager:ExitWarChess((Consts.SceneName).Main, false, function()
    -- function num : 0_13_0 , upvalues : self, typeIndex, _ENV, JumpManager
    local defeatJumpCfg = (self.__defeatJumpCfgList)[typeIndex]
    if defeatJumpCfg == nil then
      error("defeatJumpCfg is nil with index " .. tostring(typeIndex))
      return 
    end
    local jumpId = defeatJumpCfg.jump_id
    local jumpArg = defeatJumpCfg.jump_arg
    JumpManager:Jump(jumpId, nil, function()
      -- function num : 0_13_0_0 , upvalues : _ENV
      local aftertTeatmentCtrl = ControllerManager:GetController(ControllerTypeId.BattleResultAftertTeatment)
      if aftertTeatmentCtrl ~= nil then
        aftertTeatmentCtrl:TeatmentBengin()
      end
    end
, jumpArg)
  end
)
end

UIWarChessResult.OnClickJump2ActTech = function(self)
  -- function num : 0_14 , upvalues : _ENV
  WarChessManager:ExitWarChess((Consts.SceneName).Main, false, function()
    -- function num : 0_14_0 , upvalues : self
    if self._openTechFunc ~= nil then
      (self._openTechFunc)()
    end
  end
)
end

UIWarChessResult.OnDelete = function(self)
  -- function num : 0_15
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
end

return UIWarChessResult

