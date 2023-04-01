-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN3DFormation = class("UIN3DFormation", UIBaseNode)
local base = UIBaseNode
local UINFmtPlatform = require("Game.Formation.UI.3DFormation.UINFmtPlatform")
local FmtEnum = require("Game.Formation.FmtEnum")
local UIN3DFormationWarningNode = require("Game.Formation.UI.3DFormation.UIN3DFormationWarningNode")
local FormationUtil = require("Game.Formation.FormationUtil")
UIN3DFormation.ctor = function(self, fmtCtrl, enterFmtData)
  -- function num : 0_0
  self.fmtCtrl = fmtCtrl
  self.enterFmtData = enterFmtData
end

UIN3DFormation.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UIN3DFormationWarningNode, FormationUtil, UINFmtPlatform
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.warningNode = (UIN3DFormationWarningNode.New)(self.fmtCtrl)
  ;
  (self.warningNode):Init((self.ui).periodicWarning)
  ;
  (self.warningNode):Hide()
  local enterFmtData = (self.fmtCtrl):GetCurEnterFmtData()
  self.platformDic = {}
  local fmtIndex = 0
  for idx,go in ipairs((self.ui).platform) do
    local isBan = false
    if not (self.enterFmtData):IsFormationIndexEnable(idx) then
      go:SetActive(false)
    else
      fmtIndex = fmtIndex + 1
      local isBench = enterFmtData:GetFormationMaxStageNum() < fmtIndex
      local unlock, lockStr = nil, nil
      if isBench then
        unlock = (FormationUtil.CheckFmtBenchUnlock)(fmtIndex, true)
      end
      if isBench and (self.enterFmtData):IsFmtInBattleDeploy() then
        isBan = true
      end
      if (self.enterFmtData):IsFmtCtrlFiexd() and not (self.enterFmtData):HasFmtFixedHeroIndex(fmtIndex) then
        isBan = true
      end
      if (self.enterFmtData):IsFmtPlatformBan(fmtIndex) then
        isBan = true
      end
      local plat = (UINFmtPlatform.New)(self.fmtCtrl, self.enterFmtData)
      plat:Init(go)
      plat:InitFmtPlatform(fmtIndex, isBench, lockStr, isBan)
      plat:SetItemParents((self.ui).parentList)
      -- DECOMPILER ERROR at PC100: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (self.platformDic)[fmtIndex] = plat
    end
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UIN3DFormation.GetPlotformItemDic = function(self)
  -- function num : 0_2
  return self.platformDic
end

UIN3DFormation.Init3DFormation = function(self)
  -- function num : 0_3
end

UIN3DFormation.Refresh3DFmt = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local totalFtPower, totalBenchPower = (self.fmtCtrl):CalculatePower(formationData)
  for index,platItem in pairs(self.platformDic) do
    local heroData = formationData:GetFormationHeroData(index)
    platItem:RefreshUIFmtPlatform(heroData)
  end
  self:ShowFmtHeroQuickLvUp()
end

UIN3DFormation.RefreshRefresh3DFmtFightPower = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local totalFtPower = 0
  local totalBenchPower = 0
  local heroPower = 0
  local heroTotalList = {}
  for index,platItem in pairs(self.platformDic) do
    heroPower = platItem:GetFmtPlatHeroFtPower()
    if heroPower ~= 0 then
      (table.insert)(heroTotalList, heroPower)
    end
    if platItem.isBench then
      totalBenchPower = heroPower + totalBenchPower
    else
      totalFtPower = heroPower + totalFtPower
    end
  end
  ;
  (table.sort)(heroTotalList, function(a, b)
    -- function num : 0_5_0
    do return b < a end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  local top5Total = 0
  for i = 1, #heroTotalList do
    if i <= 5 then
      do
        top5Total = top5Total + heroTotalList[i]
        -- DECOMPILER ERROR at PC40: LeaveBlock: unexpected jumping out IF_THEN_STMT

        -- DECOMPILER ERROR at PC40: LeaveBlock: unexpected jumping out IF_STMT

      end
    end
  end
  local dynPlayerFtPower = self:_GetCommanderPower(totalFtPower)
  totalFtPower = totalFtPower + dynPlayerFtPower
  top5Total = top5Total + dynPlayerFtPower
  local window = UIManager:GetWindow(UIWindowTypeID.Formation)
  if window ~= nil then
    window:RefreshUIAboutCurFmtDat(totalFtPower, totalBenchPower, nil, top5Total)
  end
end

UIN3DFormation._GetCommanderPower = function(self, heroPower)
  -- function num : 0_6 , upvalues : _ENV
  if self._commanderPowerTab == nil then
    self._commanderPowerTab = {}
  end
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._commanderPowerTab).power = heroPower
  local power = (ConfigData.GetFormulaValue)(eFormulaType.Commander, self._commanderPowerTab)
  power = (math.floor)(power)
  return power
end

UIN3DFormation.GetFmtPlatformUI = function(self, fmtIndex)
  -- function num : 0_7 , upvalues : _ENV
  local platform = (self.platformDic)[fmtIndex]
  if platform == nil then
    warn("Can\'t get FmtPlatformUI, fmtIndex = " .. tostring(fmtIndex))
  end
  return platform
end

UIN3DFormation.RefreshFmtPlatformUI = function(self, fmtIndex)
  -- function num : 0_8
  local platform = self:GetFmtPlatformUI(fmtIndex)
  if platform == nil then
    return 
  end
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local heroData = formationData:GetFormationHeroData(fmtIndex)
  platform:RefreshUIFmtPlatform(heroData)
  platform:RefreshFmtQuickLvUp(heroData, (self.ui).fXP_Btn_QuickLevelUp)
end

UIN3DFormation.ShowFmtHeroQuickLvUp = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  for index,platItem in pairs(self.platformDic) do
    local heroData = formationData:GetFormationHeroData(index)
    if heroData ~= nil then
      platItem:RefreshFmtQuickLvUp(heroData, (self.ui).fXP_Btn_QuickLevelUp)
    end
  end
end

UIN3DFormation.RefreshFmtHeroQuickLvUpByFmtIndex = function(self, fmtIndex)
  -- function num : 0_10
  local platform = self:GetFmtPlatformUI(fmtIndex)
  if platform == nil then
    return 
  end
  local formationData = (self.fmtCtrl):GetFmtCtrlFmtData()
  local heroData = formationData:GetFormationHeroData(fmtIndex)
  platform:RefreshFmtQuickLvUp(heroData, (self.ui).fXP_Btn_QuickLevelUp)
end

UIN3DFormation.SetWarningTipState = function(self, active)
  -- function num : 0_11
  if active then
    (self.warningNode):Show()
    ;
    (self.warningNode):OpenWarningTip4WcLevel()
  else
    ;
    (self.warningNode):Hide()
  end
end

UIN3DFormation.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  (base.OnDelete)(self)
end

return UIN3DFormation

