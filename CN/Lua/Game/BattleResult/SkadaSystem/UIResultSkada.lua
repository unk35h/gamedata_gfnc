-- params : ...
-- function num : 0 , upvalues : _ENV
local UIResultSkada = class("UIResultSkada", UIBaseWindow)
local base = UIBaseWindow
local SkadaEnum = require("Game.BattleResult.SkadaSystem.SkadaEnum")
local UINSkadaType = require("Game.BattleResult.SkadaSystem.UINSkadaType")
local UISkadaTeamPage = require("Game.BattleResult.SkadaSystem.UISkadaTeamPage")
local UISkadaInfoPage = require("Game.BattleResult.SkadaSystem.UISkadaInfoPage")
UIResultSkada.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UISkadaTeamPage, UISkadaInfoPage
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnBtnCloseClicked)
  ;
  ((self.ui).tog_DataType):SetActive(false)
  self.resloader = ((CS.ResLoader).Create)()
  self.panelSkadaTeamPage = (UISkadaTeamPage.New)()
  ;
  (self.panelSkadaTeamPage):Init((self.ui).skadaTeamPage)
  self.panelSkadaInfoPage = (UISkadaInfoPage.New)()
  ;
  (self.panelSkadaInfoPage):Init((self.ui).skadaInfoPage)
  self:InitSkadaTypeGroup()
end

UIResultSkada.InitSkadaTypeGroup = function(self)
  -- function num : 0_1 , upvalues : _ENV, SkadaEnum, UINSkadaType
  self.__skadaTypeGroup = {}
  self.__OnSkadaTypeChanged = BindCallback(self, self.OnSkadaTypeChanged)
  for id = 1, SkadaEnum.MaxSkadaTypeNum do
    local go = ((self.ui).tog_DataType):Instantiate()
    go:SetActive(true)
    local skadaTypeItem = (UINSkadaType.New)()
    skadaTypeItem:Init(go)
    skadaTypeItem:InitSkadaType(id, self.__OnSkadaTypeChanged)
    ;
    (table.insert)(self.__skadaTypeGroup, skadaTypeItem)
  end
end

UIResultSkada.OnSkadaTypeChanged = function(self, value, item)
  -- function num : 0_2
  if value then
    self.skadaType = item.typeId
    if self.panelSkadaTeamPage ~= nil then
      (self.panelSkadaTeamPage):OnSkadaTypeChanged(self.skadaType)
    end
    if self.panelSkadaInfoPage ~= nil then
      (self.panelSkadaInfoPage):OnSkadaTypeChanged(self.skadaType)
    end
  end
end

UIResultSkada.GetSkadaType = function(self)
  -- function num : 0_3
  return self.skadaType
end

UIResultSkada.InitBattleSkada = function(self, battleStatistics, playerRoleList, enemyRoleList)
  -- function num : 0_4 , upvalues : _ENV
  (self.panelSkadaTeamPage):InitSkadaTeamPage(battleStatistics, playerRoleList, enemyRoleList, self.resloader, self.panelSkadaInfoPage)
  ;
  (self.panelSkadaInfoPage):FirstInitSkadaInfoPage(self.resloader, battleStatistics)
  ;
  ((self.__skadaTypeGroup)[1]):SetSkadaTypeOpen(true)
  ;
  (((self.ui).tex_stageText).gameObject):SetActive(false)
  if ExplorationManager:IsInExploration() then
    local msg = nil
    local infoData = ExplorationManager:TryToGetCurrentLevelInfo()
    if infoData.moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Exploration then
      (((self.ui).tex_stageText).gameObject):SetActive(true)
      msg = ConfigData:GetSectorInfoMsg(infoData.sector, infoData.num, infoData.difficulty)
    else
      if infoData.moduleId == proto_csmsg_SystemFunctionID.SystemFunctionID_Endless then
        (((self.ui).tex_stageText).gameObject):SetActive(true)
        msg = ConfigData:GetEndlessInfoMsg(infoData.cfg, infoData.index)
      end
    end
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_stageText).text = msg
  end
end

UIResultSkada.SetSkadaCloseCallback = function(self, closeCallback)
  -- function num : 0_5
  self.closeCallback = closeCallback
end

UIResultSkada.BackAction = function(self)
  -- function num : 0_6
  if self.closeCallback ~= nil then
    (self.closeCallback)()
  end
  self:Delete()
end

UIResultSkada.OnBtnCloseClicked = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIResultSkada.OnDelete = function(self)
  -- function num : 0_8 , upvalues : base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIResultSkada

