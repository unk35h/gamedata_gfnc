-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtTopNode = class("UINFmtTopNode", UIBaseNode)
local base = UIBaseNode
local FmtEnum = require("Game.Formation.FmtEnum")
local FormationUtil = require("Game.Formation.FormationUtil")
local UINTroopItem = require("Game.Formation.UI.2DFormation.UINTroopItem")
local CS_MessageCommon = CS.MessageCommon
local RenameHelper = require("Game.CommonUI.Rename.RenameHelper")
UINFmtTopNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_MessageCommon, UINTroopItem
  self.heroNetwork = NetworkManager:GetNetwork(NetworkTypeID.Hero)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SwitchTeam, self, self.__OnClickSwitchTeam)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_closeSwitchTeamList, self, self.__OnClickCloseSwitchTeam)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Recomme, self, self.OnClickRecomme)
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R1 in 'UnsetPending'

  if CloseCustomBename then
    ((self.ui).btn_ChangeTeamName).interactable = false
    ;
    (((CS.EventTriggerListener).Get)(((self.ui).btn_ChangeTeamName).gameObject)):onClick("+", function()
    -- function num : 0_0_0 , upvalues : CS_MessageCommon, _ENV
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(393))
  end
)
  else
    ;
    (((self.ui).btn_ChangeTeamName).onEndEdit):AddListener(BindCallback(self, self.EditFormationName))
  end
  self.troopPool = (UIItemPool.New)(UINTroopItem, (self.ui).switchTeamItem)
  ;
  ((self.ui).switchTeamItem):SetActive(false)
  self.__isInitedTroopPool = false
  self.characterLimit = ((self.ui).inputField).characterLimit
end

UINFmtTopNode.InitFmtTopNode = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_1 , upvalues : FormationUtil
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
  self.__offset = (FormationUtil.GetFmtIdOffsetByFmtFromModule)((self.enterFmtData):GetFmtCtrlFromModule(), (self.enterFmtData):GetFmtCtrlFmtIdStageId())
  self:RefreshChangeFmt()
  self:RefreshFixedTip()
  self:RefreshFmtRecommendBtn()
end

UINFmtTopNode.RefreshChangeFmt = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.enterFmtData):GetIsOpenChangeFmt() then
    local isFixed = (self.enterFmtData):IsFmtCtrlFiexd()
    ;
    (((self.ui).btn_ChangeTeamName).gameObject):SetActive(not isFixed)
    ;
    (((self.ui).btn_SwitchTeam).gameObject):SetActive(true)
    ;
    (self.fmtCtrl):SetCouldUseSwitchBtn(true)
    local fmtData = (self.fmtCtrl):GetFmtCtrlFmtData()
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

    if fmtData ~= nil and not (string.IsNullOrEmpty)(fmtData.name) then
      ((self.ui).btn_ChangeTeamName).text = fmtData.name
    else
      local showFmtId = (self.enterFmtData):GetFmtCtrlFmtId() - self.__offset
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).btn_ChangeTeamName).text = ((self.ui).tex_troopName):GetIndex(0, tostring(showFmtId))
    end
  else
    do
      ;
      (((self.ui).btn_ChangeTeamName).gameObject):SetActive(false)
      ;
      (((self.ui).btn_SwitchTeam).gameObject):SetActive(false)
      ;
      (self.fmtCtrl):SetCouldUseSwitchBtn(false)
    end
  end
end

UINFmtTopNode.RefreshFixedTip = function(self)
  -- function num : 0_3
  if (self.enterFmtData):IsFmtCtrlFiexd() then
    local isFixedCouldChangeTeam = (self.enterFmtData):IsFmtFixedCouldChangeTeam()
    ;
    (self.fmtCtrl):SetCouldUseSwitchBtn(isFixedCouldChangeTeam)
    ;
    ((self.ui).topNornal):SetActive(isFixedCouldChangeTeam)
    ;
    ((self.ui).obj_FixedTips):SetActive(not isFixedCouldChangeTeam)
    if not isFixedCouldChangeTeam then
      if (self.enterFmtData):HasFmtFixedExtra() then
        ((self.ui).tex_FixedTips):SetIndex(1)
      else
        ;
        ((self.ui).tex_FixedTips):SetIndex(0)
      end
    end
  end
end

UINFmtTopNode.RefreshCurrentFmtPow = function(self, totalFtPower, totalBenchPower)
  -- function num : 0_4 , upvalues : _ENV
  for _,item in pairs((self.troopPool).listItem) do
    local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
    if item.id == formationData.id then
      item:RefreshPower(totalFtPower, totalBenchPower)
    end
  end
end

UINFmtTopNode.RefreshFmtItemPow = function(self, formationData)
  -- function num : 0_5 , upvalues : _ENV
  for _,item in pairs((self.troopPool).listItem) do
    if item.id == formationData.id then
      local ftpower, benchPower = (self.fmtCtrl):CalculatePower(formationData)
      item:RefreshPower(ftpower, benchPower)
    end
  end
end

UINFmtTopNode.RefreshFmtRecommendBtn = function(self)
  -- function num : 0_6
  local bool = (self.enterFmtData):GetCouldShowFmtRecommendBtn()
  ;
  (((self.ui).btn_Recomme).gameObject):SetActive(bool)
end

UINFmtTopNode.__OnClickSwitchTeam = function(self)
  -- function num : 0_7 , upvalues : _ENV
  ((self.ui).switchTeamList):SetActive(true)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_SwitchTeamArrow).localScale = (Vector3.New)(1, 1, 1)
  ;
  (self.fmtCtrl):SetCouldUseSwitchBtn(false)
  self:__TryInitTroopItems()
  local curFmtData = (self.fmtCtrl):GetFmtCtrlFmtData()
  for _,item in pairs((self.troopPool).listItem) do
    if not item:IsCalcutedPower() then
      local formationData = nil
      if curFmtData.id == item.id then
        formationData = curFmtData
      else
        formationData = (PlayerDataCenter.formationDic)[item.id]
      end
      if formationData ~= nil then
        local ftpower, benchPower = (self.fmtCtrl):CalculatePower(formationData)
        item:RefreshPower(ftpower, benchPower)
      else
        do
          do
            item:RefreshPower(0, 0)
            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC58: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

UINFmtTopNode.OnClickRecomme = function(self)
  -- function num : 0_8 , upvalues : _ENV, FmtEnum
  local recommeCtr = ControllerManager:GetController(ControllerTypeId.RecommeFormation, true)
  local sectorStageId = (self.enterFmtData):GetFmtCtrlFmtIdStageId()
  if (self.enterFmtData):GetFmtCtrlGameType() == (FmtEnum.eFmtGamePlayType).Dungeon then
    recommeCtr:ReqDunRecommeFormation(sectorStageId, true)
  else
    recommeCtr:ReqRecommeFormationNew(sectorStageId, true)
  end
end

UINFmtTopNode.__OnClickCloseSwitchTeam = function(self)
  -- function num : 0_9 , upvalues : _ENV
  ((self.ui).switchTeamList):SetActive(false)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_SwitchTeamArrow).localScale = (Vector3.New)(1, -1, 1)
  ;
  (self.fmtCtrl):SetCouldUseSwitchBtn(true)
end

UINFmtTopNode.__TryInitTroopItems = function(self)
  -- function num : 0_10
  if self.__isInitedTroopPool then
    return 
  end
  self.__isInitedTroopPool = true
  ;
  (self.troopPool):HideAll()
  local __SelectFmt = function(id, index)
    -- function num : 0_10_0 , upvalues : self
    (self.fmtCtrl):FmtCtrlSwitchFmt(id, index)
  end

  if (self.enterFmtData):IsFmtFixedCouldChangeTeam() then
    local isFixedCouldChangeTeam = (self.enterFmtData):GetIsOpenChangeFmt()
  end
  for index = 1, (self.enterFmtData):GetFmtTeamSize() do
    local fmtId = nil
    if isFixedCouldChangeTeam then
      fmtId = (self.enterFmtData):GetFmtFixedChangeTeamFmtId(index)
    end
    if fmtId == nil then
      fmtId = index + self.__offset
    end
    local troopItem = (self.troopPool):GetOne()
    troopItem:InitTroopItem(fmtId, __SelectFmt, self.__offset, index)
  end
end

UINFmtTopNode.EditFormationName = function(self, fmtName)
  -- function num : 0_11 , upvalues : _ENV, RenameHelper
  if (string.IsNullOrEmpty)(fmtName) then
    self:OnEditFormationNameError()
    return 
  end
  local fmtData = (self.fmtCtrl):GetFmtCtrlFmtData()
  if fmtData ~= nil and fmtData.name == fmtName then
    return 
  end
  local inputLength = RenameHelper:GetNameLength(fmtName)
  if self.characterLimit < inputLength then
    fmtName = RenameHelper:ClampNameInLength(fmtName, self.characterLimit)
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).inputField).text = fmtName
  end
  if self.__OnEditFormationName == nil then
    self.__OnEditFormationName = BindCallback(self, self.__OnEditFormationNameComplete)
  end
  ;
  (self.heroNetwork):CS_HERO_FormationNameFresh((self.enterFmtData):GetFmtCtrlFmtId(), fmtName, self.__OnEditFormationName)
end

UINFmtTopNode.__OnEditFormationNameComplete = function(self)
  -- function num : 0_12
  local name = ((self.ui).btn_ChangeTeamName).text
  local troopItem = ((self.troopPool).listItem)[(self.enterFmtData):GetFmtCtrlFmtId() - self.__offset]
  if troopItem ~= nil then
    troopItem:RefreshTroopName(name)
  end
  ;
  (self.fmtCtrl):ModifyFormationName(name)
end

UINFmtTopNode.OnEditFormationNameError = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local fmtData = (self.fmtCtrl):GetFmtCtrlFmtData()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if fmtData ~= nil and not (string.IsNullOrEmpty)(fmtData.name) then
    ((self.ui).btn_ChangeTeamName).text = fmtData.name
  else
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).btn_ChangeTeamName).text = ((self.ui).tex_troopName):GetIndex(0, tostring((self.enterFmtData):GetFmtCtrlFmtId()))
  end
end

UINFmtTopNode.OnDelete = function(self)
  -- function num : 0_14
end

return UINFmtTopNode

