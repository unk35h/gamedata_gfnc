-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtNotEditNode = class("UINFmtNotEditNode", UIBaseNode)
local base = UIBaseNode
local cs_tweening = (CS.DG).Tweening
local cs_MessageCommon = CS.MessageCommon
local UINFmtChallengeTask = require("Game.Formation.UI.ChallengeTask.UINFmtChallengeTask")
local UINBtnCommanderSkill = require("Game.Formation.UI.2DFormation.UINBtnCommanderSkill")
local UINFmtEvaluation = require("Game.Formation.UI.FormationEvaluation.UIFmtEvaluation")
local UINFmtDebuffNode = require("Game.Formation.UI.2DFormation.UINFmtDebuffNode")
UINFmtNotEditNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Editor, self, self.__OnClickEdit)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectChip, self, self.__OnClickChipList)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.__OnClickBattle)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Continue, self, self.__OnClickContinue)
  self.__isLowPower = nil
end

UINFmtNotEditNode.InitFmt2DUINode = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_1
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  self:RefreshBattleBtnState()
  self:RefreshBattlePow()
  self:RefreshChallengeNode()
  self:RefreshCSTNode()
  self:RefreshEvaluateNode()
  self:RefreshSelectDebuffNode()
  self:RefreshChipListBtn()
  self:RefreshFmtEditBtn()
  self:RefreshEnterBattleTip()
end

UINFmtNotEditNode.RefreshBattleBtnState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if not (self.enterFmtData):IsFmtInBattleDeploy() then
    local isShowContinue = (self.enterFmtData):IsFmtInWarChessDeploy()
  end
  ;
  (((self.ui).btn_Battle).gameObject):SetActive(not isShowContinue)
  ;
  (((self.ui).btn_Continue).gameObject):SetActive(isShowContinue)
  if isShowContinue then
    return 
  end
  if (self.enterFmtData):GetIsAutoBattleState() then
    ((self.ui).tex_Battle):SetIndex(1)
  else
    if (self.enterFmtData):IsFmtChallengeMode() then
      ((self.ui).tex_Battle):SetIndex(2)
    else
      ;
      ((self.ui).tex_Battle):SetIndex(0)
    end
  end
  local staminaCost = (self.enterFmtData):GetStaminaCost()
  local notStaminaTicketItemId = (self.enterFmtData):GetIsFmtTicketId()
  -- DECOMPILER ERROR at PC62: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).image_key).sprite = CRH:GetDefaultKeySprite(notStaminaTicketItemId)
  if staminaCost ~= nil then
    ((self.ui).tex_Point):SetIndex(0, tostring(staminaCost))
  end
end

UINFmtNotEditNode.RefreshBattlePow = function(self, totalFtPower, totalBenchPower, campCountDic, top5Total)
  -- function num : 0_3 , upvalues : _ENV
  local couldShowNormalNode = true
  if (self.enterFmtData):IsFmtHaveChallengeMode() then
    couldShowNormalNode = not ((self.enterFmtData):GetFmtChallengeModeData()):IsStageChallengeOpen()
  end
  ;
  ((self.ui).obj_normalNode):SetActive(couldShowNormalNode)
  if not couldShowNormalNode then
    return 
  end
  local isShowPower = (self.enterFmtData):GetIsShowTotalPow()
  ;
  ((self.ui).obj_totalPower):SetActive(isShowPower)
  ;
  ((self.ui).obj_recomendPower):SetActive(isShowPower)
  if not isShowPower then
    return 
  end
  do
    if totalFtPower == nil then
      local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
      totalFtPower = (self.fmtCtrl):CalculatePower(formationData)
    end
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_TotalPower).text = tostring(totalFtPower)
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_BenchTotalPower).text = tostring(totalBenchPower)
    local stageRecommendPower, benchRecommendPower = (self.enterFmtData):GetFmtCtrlRecommendPower()
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tex_RecomendPower).text = tostring((math.floor)(stageRecommendPower))
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R9 in 'UnsetPending'

    ;
    ((self.ui).tex_RecomendBenchPower).text = tostring((math.floor)(benchRecommendPower))
    local warnRate = ((ConfigData.game_config).formationPowWarn or 80) * 0.01
    local minPower = (math.floor)(stageRecommendPower * warnRate)
    self.__isLowPower = top5Total or 0 < minPower
    local isLow = totalFtPower < stageRecommendPower
    local isBenchLow = totalBenchPower < benchRecommendPower
    self:__SetBattlePowTween(isLow, isBenchLow)
    self._totalFtPowerWarn = isLow
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINFmtNotEditNode.__SetBattlePowTween = function(self, isLow, isBenchLow)
  -- function num : 0_4 , upvalues : cs_tweening
  ((self.ui).img_LowPower):DORewind()
  ;
  ((self.ui).img_LowPower):DOKill()
  if isLow then
    ((((self.ui).img_LowPower):DOFade(0, 1.5)):SetLoops(-1, (cs_tweening.LoopType).Yoyo)):SetLink(((self.ui).img_LowPower).gameObject)
  end
  ;
  ((self.ui).img_LowBeachPow):DORewind()
  ;
  ((self.ui).img_LowBeachPow):DOKill()
  if isBenchLow then
    ((((self.ui).img_LowBeachPow):DOFade(0, 1.5)):SetLoops(-1, (cs_tweening.LoopType).Yoyo)):SetLink(((self.ui).img_LowBeachPow).gameObject)
  end
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_LowPower).enabled = isLow
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_LowBeachPow).enabled = isBenchLow
end

UINFmtNotEditNode.RefreshChallengeNode = function(self)
  -- function num : 0_5 , upvalues : UINFmtChallengeTask
  if (self.enterFmtData):IsFmtHaveChallengeMode() then
    if self.fmtChallengeNode == nil then
      self.fmtChallengeNode = (UINFmtChallengeTask.New)()
      ;
      (self.fmtChallengeNode):Init((self.ui).obj_challengeNode)
    end
    ;
    (self.fmtChallengeNode):Show()
    ;
    (self.fmtChallengeNode):InitFmtChallengeTask(self.fmtCtrl, self.enterFmtData, self)
  else
    if self.fmtChallengeNode == nil then
      ((self.ui).obj_challengeNode):SetActive(false)
    else
      ;
      (self.fmtChallengeNode):Hide()
    end
  end
end

UINFmtNotEditNode.RefreshCSTNode = function(self)
  -- function num : 0_6 , upvalues : _ENV, UINBtnCommanderSkill
  local ctrlLock = (self.enterFmtData):GetIsCloseCommandSkill()
  local isCSUnlock = (ctrlLock or FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill)) and FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_commander_skill_Ui)
  if isCSUnlock then
    if self.btnCstItem == nil then
      self.btnCstItem = (UINBtnCommanderSkill.New)()
      ;
      (self.btnCstItem):Init((self.ui).obj_btn_CommanderSkill)
    end
    ;
    (self.btnCstItem):Show()
    ;
    (self.btnCstItem):InitBtnCommanderSkill4FmtCtrl(self.fmtCtrl, self.enterFmtData)
    local isFixed, skills = (self.enterFmtData):GetFixedCstSkills()
    if isFixed then
      (self.btnCstItem):RefreshCstByIdAndList(0, skills, isFixed)
      return 
    end
    local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
    local treeData = formationData:GetFmtCSTData()
    ;
    (self.btnCstItem):RefreshCstByTreeInfo(treeData)
  elseif self.btnCstItem == nil then
    ((self.ui).obj_btn_CommanderSkill):SetActive(false)
  else
    (self.btnCstItem):Hide()
  end
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UINFmtNotEditNode.RefreshEvaluateNode = function(self)
  -- function num : 0_7 , upvalues : UINFmtEvaluation
  local isOpenEvaluate = (self.enterFmtData):GetIsOpenFmtEvaluate()
  if isOpenEvaluate then
    if self.UIFmtEvaluation == nil then
      self.UIFmtEvaluation = (UINFmtEvaluation.New)()
      ;
      (self.UIFmtEvaluation):Init((self.ui).obj_formationEvaluation)
      local sectorStageId = (self.enterFmtData):GetFmtCtrlFmtIdStageId()
      local fromModule = (self.enterFmtData):GetFmtCtrlFromModule()
      ;
      (self.UIFmtEvaluation):InitializeAdvantageConfig(sectorStageId, fromModule)
    end
    do
      ;
      (self.UIFmtEvaluation):Show()
      do
        local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
        ;
        (self.UIFmtEvaluation):AnalysisFormation(formationData.data)
        if self.UIFmtEvaluation == nil then
          ((self.ui).obj_formationEvaluation):SetActive(false)
        else
          ;
          (self.UIFmtEvaluation):Hide()
        end
      end
    end
  end
end

UINFmtNotEditNode.RefreshSelectDebuffNode = function(self)
  -- function num : 0_8 , upvalues : UINFmtDebuffNode
  local isOpenBuffSelect = (self.enterFmtData):GetIsOpenSelectDebuff()
  if isOpenBuffSelect then
    if self.selectDebuffNode == nil then
      self.selectDebuffNode = (UINFmtDebuffNode.New)()
      ;
      (self.selectDebuffNode):Init((self.ui).obj_debuffSelect)
    end
    ;
    (self.selectDebuffNode):RefreshDebuffNode(self.fmtCtrl, self.enterFmtData)
    ;
    (self.selectDebuffNode):Show()
  else
    if self.selectDebuffNode == nil then
      ((self.ui).obj_debuffSelect):SetActive(false)
    else
      ;
      (self.selectDebuffNode):Hide()
    end
  end
end

UINFmtNotEditNode.RefreshChipListBtn = function(self)
  -- function num : 0_9
  local chipDataList = (self.enterFmtData):GetFmtChipDataList()
  ;
  (((self.ui).btn_SelectChip).gameObject):SetActive(chipDataList ~= nil and #chipDataList > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINFmtNotEditNode.RefreshFmtEditBtn = function(self)
  -- function num : 0_10
  if (self.enterFmtData):IsFmtCtrlFiexd() then
    if (self.enterFmtData):HasFmtFixedExtra() then
      (((self.ui).btn_Editor).gameObject):SetActive(true)
    else
      ;
      (((self.ui).btn_Editor).gameObject):SetActive(false)
    end
  end
end

UINFmtNotEditNode.RefreshEnterBattleTip = function(self)
  -- function num : 0_11
  local isChallengeMode = (self.enterFmtData):IsFmtChallengeMode()
  if isChallengeMode then
    ((self.ui).obj_WarnTips):SetActive(true)
    ;
    ((self.ui).tex_WarnTips):SetIndex(0)
  else
    if (self.enterFmtData):IsFmtCtrlFiexd() and not (self.enterFmtData):IsFmtFixedHeroFull((self.fmtCtrl):GetFmtCtrlFmtData()) then
      ((self.ui).obj_WarnTips):SetActive(true)
      ;
      ((self.ui).tex_WarnTips):SetIndex(1)
    else
      ;
      ((self.ui).obj_WarnTips):SetActive(false)
    end
  end
end

UINFmtNotEditNode.__OnClickEdit = function(self)
  -- function num : 0_12
  (self.fmtCtrl):FmtCtrlEnterEditSate()
end

UINFmtNotEditNode.__OnClickChipList = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local chipDataList = (self.enterFmtData):GetFmtChipDataList()
  if chipDataList ~= nil and #chipDataList > 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.CurrentChip, function(window)
    -- function num : 0_13_0 , upvalues : chipDataList
    window:InitCurrentChip(chipDataList)
  end
)
  end
end

UINFmtNotEditNode.__OnClickBattle = function(self)
  -- function num : 0_14 , upvalues : cs_MessageCommon
  if self.__isLowPower and not (self.enterFmtData):IsFmtChallengeMode() then
    local tip = (self.fmtCtrl):GetLowerEfficiencyTip((self.enterFmtData).stageId)
    ;
    (cs_MessageCommon.ShowMessageBox)(tip, function()
    -- function num : 0_14_0 , upvalues : self
    (self.fmtCtrl):FmtStartBattle()
  end
, nil)
  else
    do
      ;
      (self.fmtCtrl):FmtStartBattle()
    end
  end
end

UINFmtNotEditNode.__OnClickContinue = function(self)
  -- function num : 0_15 , upvalues : _ENV
  do
    if (self.enterFmtData):IsFmtInWarChessDeploy() then
      local callback = (self.enterFmtData):GetDeployOverCallback()
      if callback ~= nil then
        callback((self.fmtCtrl).__fmtData)
      end
    end
    ;
    (UIUtil.OnClickBackByWinId)(UIWindowTypeID.Formation)
  end
end

UINFmtNotEditNode.OnDelete = function(self)
  -- function num : 0_16
  if self.fmtChallengeNode ~= nil then
    (self.fmtChallengeNode):Delete()
  end
end

return UINFmtNotEditNode

