-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFormation = class("UIFormation", UIBaseWindow)
local base = UIBaseWindow
local cs_tweening = (CS.DG).Tweening
local FormationUtil = require("Game.Formation.FormationUtil")
local JumpManager = require("Game.Jump.JumpManager")
local UINFmtHeroInfoItem = require("Game.Formation.UI.2DFormation.UINFmtHeroInfoItem")
local UINFmtNotEditNode = require("Game.Formation.UI.2DFormation.SubNodes.UINFmtNotEditNode")
local UINFmtEditNode = require("Game.Formation.UI.2DFormation.SubNodes.UINFmtEditNode")
local UINFmtTopNode = require("Game.Formation.UI.2DFormation.SubNodes.UINFmtTopNode")
UIFormation.OnShow = function(self)
  -- function num : 0_0
end

UIFormation.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINFmtHeroInfoItem, UINFmtNotEditNode, UINFmtTopNode, cs_tweening
  self.heroNetwork = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_LastTeam, self, self.__ChangeFormationTeam, -1)
  ;
  (UIUtil.AddButtonListenerWithArg)((self.ui).btn_NextTeam, self, self.__ChangeFormationTeam, 1)
  ;
  ((self.ui).obj_fHeroInfoItem):SetActive(false)
  self.heroInfoPool = (UIItemPool.New)(UINFmtHeroInfoItem, (self.ui).obj_fHeroInfoItem)
  self.heroInfoDic = {}
  self.notEditNode = (UINFmtNotEditNode.New)()
  ;
  (self.notEditNode):Init((self.ui).obj_notEditorNode)
  self.topNode = (UINFmtTopNode.New)()
  ;
  (self.topNode):Init((self.ui).obj_topNode)
  self.editNode = nil
  self.maskMaterial = nil
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_focusMask).enabled = false
  local editorModelSeq = ((cs_tweening.DOTween).Sequence)()
  editorModelSeq:Append(((self.ui).tran_FHeroInfo):DOAnchorPosY((((self.ui).tran_FHeroInfo).anchoredPosition).y + 20, 0.5))
  editorModelSeq:Join(((self.ui).tran_SwitchBtn):DOAnchorPosY((((self.ui).tran_SwitchBtn).anchoredPosition).y + 100, 0.5))
  editorModelSeq:Pause()
  editorModelSeq:SetAutoKill(false)
  self.editorModelSeq = editorModelSeq
  self.notEditorSeq = self:__InitPageSeq((self.ui).can_notEditorNode, function()
    -- function num : 0_1_0 , upvalues : self
    (self.notEditNode):Hide()
  end
)
  self.editorSeq = self:__InitPageSeq((self.ui).can_editorNode, function()
    -- function num : 0_1_1 , upvalues : self
    if self.editNode == nil then
      ((self.ui).obj_editorNode):SetActive(false)
    else
      ;
      (self.editNode):Hide()
    end
  end
)
  self.curPageSeq = self.notEditorSeq
  ;
  (self.curPageSeq):Restart()
end

UIFormation.InitUIFormation = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_2 , upvalues : JumpManager, _ENV
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  JumpManager.couldUseItemJump = true
  ;
  (self.notEditNode):InitFmt2DUINode(fmtCtrl, enterFmtData)
  ;
  (self.topNode):InitFmtTopNode(fmtCtrl, enterFmtData)
  if self.editNode == nil then
    ((self.ui).obj_editorNode):SetActive(false)
  else
    ;
    (self.editNode):Hide()
  end
  local resTab = self:RefreshFmtUIResShow()
  ;
  (UIUtil.SetTopStatus)(self, self.OnClickBack, resTab, nil, nil, nil, function()
    -- function num : 0_2_0 , upvalues : self, _ENV
    if (self.enterFmtData):IsFmtInBattleDeploy(true) or (self.enterFmtData):IsFmtInWarChessDeploy() then
      (UIUtil.SetTopStatusBtnShow)(false, false)
    end
    local win = UIManager:GetWindow(UIWindowTypeID.TopStatus)
    if win ~= nil then
      local resItem = win:GetTopStatusResItem(ConstGlobalItem.HeroExp)
      if resItem ~= nil then
        resItem:SetPlayNumberTweenActive(true)
      end
    end
  end
)
  GuideManager:TryTriggerGuide(eGuideCondition.InFormation)
  if (self.enterFmtData):GetIsOpenSelectDebuff() and (self.enterFmtData):GetIsOpenBuffWhenEnter() then
    ((self.notEditNode).selectDebuffNode):OnClickBuffSelect()
  end
end

UIFormation.RefreshAllUIAboutFmtData = function(self)
  -- function num : 0_3
  (self.notEditNode):InitFmt2DUINode(self.fmtCtrl, self.enterFmtData)
  ;
  (self.topNode):InitFmtTopNode(self.fmtCtrl, self.enterFmtData)
  if self.editNode ~= nil then
    (self.editNode):RefreshEditNode()
  end
end

UIFormation.RefreshUIAboutCurFmtDat = function(self, totalFtPower, totalBenchPower, campCountDic, top5Total)
  -- function num : 0_4
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if totalFtPower == nil then
    totalFtPower = (self.fmtCtrl):CalculatePower(formationData)
  end
  ;
  (self.notEditNode):RefreshBattlePow(totalFtPower, totalBenchPower, campCountDic, top5Total)
  ;
  (self.notEditNode):RefreshEvaluateNode()
  ;
  (self.notEditNode):RefreshEnterBattleTip()
  ;
  (self.topNode):RefreshCurrentFmtPow(totalFtPower, totalBenchPower)
  if self.editNode ~= nil then
    (self.editNode):RefreshPowAndEvaluate(totalFtPower, totalBenchPower)
  end
end

UIFormation.RefreshFmtItemPow = function(self, fmtData)
  -- function num : 0_5
  (self.topNode):RefreshFmtItemPow(fmtData)
end

UIFormation.RefreshFmtUIResShow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local showExp = (self.enterFmtData):GetIsFmtExpShow()
  local showStamina = (self.enterFmtData):GetIsFmtStaminaShow()
  local notStaminaTicketItemId = (self.enterFmtData):GetIsFmtTicketId()
  local resTab = {}
  if showExp then
    (table.insert)(resTab, ConstGlobalItem.HeroExp)
  end
  if showStamina then
    (table.insert)(resTab, notStaminaTicketItemId)
  end
  return resTab
end

UIFormation.EnterEditorMode = function(self)
  -- function num : 0_7 , upvalues : UINFmtEditNode
  if self.editNode == nil then
    self.editNode = (UINFmtEditNode.New)()
    ;
    (self.editNode):Init((self.ui).obj_editorNode)
    ;
    (self.editNode):InitFmtEditNode(self.fmtCtrl, self.enterFmtData)
  end
  ;
  (self.editNode):Show()
  ;
  (self.editNode):OpenEmtEditNode()
  ;
  (self.editorModelSeq):Restart()
  self:__SwitchPageTween(self.editorSeq)
end

UIFormation.ExitEditorMode = function(self)
  -- function num : 0_8
  (self.notEditNode):Show()
  ;
  (self.editorModelSeq):PlayBackwards()
  self:__SwitchPageTween(self.notEditorSeq)
end

UIFormation.__ChangeFormationTeam = function(self, num)
  -- function num : 0_9 , upvalues : FormationUtil
  local idOffset = (FormationUtil.GetFmtIdOffsetByFmtFromModule)((self.enterFmtData):GetFmtCtrlFromModule(), (self.enterFmtData):GetFmtCtrlFmtIdStageId())
  local id = (self.enterFmtData):GetFmtCtrlFmtId() + num - idOffset
  local max = (self.enterFmtData):GetFmtTeamSize()
  if max < id then
    id = 1
  else
    if id < 1 then
      id = max
    end
  end
  local index = id
  id = id + idOffset
  ;
  (self.fmtCtrl):FmtCtrlSwitchFmt(id, index)
end

UIFormation.SetSwitchButtonActive = function(self, active)
  -- function num : 0_10
  (((self.ui).btn_LastTeam).gameObject):SetActive(active)
  ;
  (((self.ui).btn_NextTeam).gameObject):SetActive(active)
end

UIFormation.SetFormationFocus = function(self, isOpen, heroPos)
  -- function num : 0_11 , upvalues : _ENV
  if isOpen then
    if self.maskMaterial == nil then
      self.maskMaterial = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_maskFoucus)
    end
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_focusMask).material = self.maskMaterial
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_focusMask).enabled = true
    local screenPos = (UIManager:GetMainCamera()):WorldToScreenPoint(heroPos)
    ;
    (self.maskMaterial):SetVector("_Item", (Vector4.New)(screenPos.x, screenPos.y, 0, 0))
    ;
    (self.maskMaterial):SetFloat("_Radius", 0.01)
  else
    do
      -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).img_focusMask).enabled = false
    end
  end
end

UIFormation.RefreshFmtCST = function(self)
  -- function num : 0_12
  (self.notEditNode):RefreshCSTNode()
end

UIFormation.RefreshFmtPower = function(self)
  -- function num : 0_13
  (self.notEditNode):RefreshBattlePow()
end

UIFormation.TryRefreshHeroCards = function(self, heroIdDic, isSkin)
  -- function num : 0_14
  if self.editNode ~= nil then
    (self.editNode):TryRefreshHeroCard(heroIdDic, isSkin)
  end
end

UIFormation.CreatFmtHeroInfo = function(self, heroData, position)
  -- function num : 0_15
  do
    if (self.heroInfoDic)[heroData.dataId] ~= nil then
      local infoItem = (self.heroInfoDic)[heroData.dataId]
      self:UpdateFmtHeroInfo(heroData, position)
      return infoItem
    end
    local infoItem = (self.heroInfoPool):GetOne()
    infoItem:InitFmtHeroInfo(self.fmtCtrl, self.enterFmtData)
    infoItem:RefreshFmtheroInfo(heroData, position)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self.heroInfoDic)[heroData.dataId] = infoItem
    return infoItem
  end
end

UIFormation.UpdateFmtHeroInfo = function(self, heroData, position, onlyPos)
  -- function num : 0_16
  local infoItem = (self.heroInfoDic)[heroData.dataId]
  if infoItem == nil then
    return 
  end
  infoItem:RefreshFmtheroInfo(heroData, position, onlyPos)
end

UIFormation.ShowFmtHeroInfo = function(self, heroId, show)
  -- function num : 0_17
  local infoItem = (self.heroInfoDic)[heroId]
  if infoItem == nil then
    return 
  end
  if show then
    infoItem:Show()
  else
    infoItem:Hide()
  end
end

UIFormation.ReturnFmtHeroInfo = function(self, heroId)
  -- function num : 0_18
  local infoItem = (self.heroInfoDic)[heroId]
  if infoItem == nil then
    return 
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.heroInfoDic)[heroId] = nil
  ;
  (self.heroInfoPool):HideOne(infoItem)
end

UIFormation.ShowChangeMark = function(self, flag)
  -- function num : 0_19 , upvalues : _ENV
  for k,heroInfoItem in pairs(self.heroInfoDic) do
    heroInfoItem:SetChangeMarkState(flag)
  end
end

UIFormation.SetUIFmtHeroInfoItemLv = function(self, heroId, level)
  -- function num : 0_20
  local heroItem = (self.heroInfoDic)[heroId]
  if heroItem ~= nil then
    heroItem:SetFmtHeroInfoItemLv(level)
  end
end

UIFormation.__SwitchPageTween = function(self, curPageSeq)
  -- function num : 0_21
  if self.curPageSeq == curPageSeq then
    return 
  end
  ;
  (self.curPageSeq):PlayBackwards()
  curPageSeq:Restart()
  self.curPageSeq = curPageSeq
end

UIFormation.__InitPageSeq = function(self, pageFade, rewindAct)
  -- function num : 0_22 , upvalues : cs_tweening
  local pageSeq = ((cs_tweening.DOTween).Sequence)()
  pageSeq:Append((pageFade:DOFade(0, 0.5)):From())
  pageSeq:Join(((pageFade.transform):DOAnchorPosY(((pageFade.transform).anchoredPosition).y - 200, 0.5)):From())
  pageSeq:OnRewind(rewindAct)
  pageSeq:Pause()
  pageSeq:SetAutoKill(false)
  return pageSeq
end

UIFormation.IsFmtToltalPowerWarn = function(self)
  -- function num : 0_23
  return (self.notEditNode)._totalFtPowerWarn
end

UIFormation.OnClickBack = function(self)
  -- function num : 0_24
  (self.fmtCtrl):ExitFormation()
  self:Delete()
end

UIFormation.OnDelete = function(self)
  -- function num : 0_25 , upvalues : JumpManager, _ENV, base
  JumpManager.couldUseItemJump = false
  if self.editorModelSeq ~= nil then
    (self.editorModelSeq):Kill()
    self.editorModelSeq = nil
  end
  if self.notEditorSeq ~= nil then
    (self.notEditorSeq):Kill()
    self.notEditorSeq = nil
  end
  if self.editorSeq ~= nil then
    (self.editorSeq):Kill()
    self.editorSeq = nil
  end
  ;
  (self.heroInfoPool):DeleteAll()
  ;
  (self.notEditNode):Delete()
  ;
  (self.topNode):Delete()
  if self.editNode ~= nil then
    (self.editNode):Delete()
  end
  if self.maskMaterial ~= nil then
    DestroyUnityObject(self.maskMaterial)
    self.maskMaterial = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIFormation

