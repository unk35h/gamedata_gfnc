-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWCSModeSelect = class("UIWCSModeSelect", UIBaseWindow)
local base = UIBaseWindow
local cs_MessageCommon = CS.MessageCommon
local UINWCSSaveNode = require("Game.WarChessSeason.UI.WCSSelect.UINWCSSaveNode")
local UINWCSSelectTower = require("Game.WarChessSeason.UI.WCSSelect.UINWCSSelectTower")
local UINWCSEnvNode = require("Game.WarChessSeason.UI.WCSSelect.UINWCSEnvNode")
local SubNodeType = {Archieve = 1, SelectEnv = 2, SelectDiff = 3}
UIWCSModeSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseChristmasSelect, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseModeSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickRollback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NewGame, self, self.__OnClickConfirm)
  self.__OnSelectArchiveCallback = BindCallback(self, self.__OnSelectArchive)
  self.__OnSelectEnvCallback = BindCallback(self, self.__OnSelectEnv)
  self.__seasonId = nil
  self.__loadSavingDataCallback = nil
  self.__startNewWCSCallback = nil
end

UIWCSModeSelect.InitWCSModeSelect = function(self, seasonId, loadSavingDataCallback, startNewWCSCallback, closeCallback)
  -- function num : 0_1
  self.__seasonId = seasonId
  self.__loadSavingDataCallback = loadSavingDataCallback
  self.__startNewWCSCallback = startNewWCSCallback
  self._closeCallback = closeCallback
  ;
  ((self.ui).obj_CostBg):SetActive(false)
  self:__OpenArchive()
end

UIWCSModeSelect.__OpenArchive = function(self)
  -- function num : 0_2 , upvalues : SubNodeType, UINWCSSaveNode
  self._subType = SubNodeType.Archieve
  if self._archiveNode == nil then
    ((self.ui).obj_checkPointNode):SetActive(true)
    self._archiveNode = (UINWCSSaveNode.New)()
    ;
    (self._archiveNode):Init((self.ui).obj_checkPointNode)
    ;
    (self._archiveNode):InitWCSSelectSaves(self.__seasonId, self.__OnSelectArchiveCallback)
    ;
    (self._archiveNode):SetFileNameByEnvName()
  else
    ;
    (self._archiveNode):Show()
  end
  if self._envNode ~= nil then
    (self._envNode):Hide()
  else
    ;
    ((self.ui).obj_envtSelectNode):SetActive(false)
  end
  if self._diffNode ~= nil then
    (self._diffNode):Hide()
  else
    ;
    ((self.ui).obj_modeSelectNode):SetActive(false)
  end
  ;
  (((self.ui).btn_Back).gameObject):SetActive(false)
  ;
  (((self.ui).btn_NewGame).gameObject):SetActive(false)
  ;
  ((self.ui).textEN):SetIndex(0)
  ;
  ((self.ui).textCN):SetIndex(0)
end

UIWCSModeSelect.__OpenEnv = function(self)
  -- function num : 0_3 , upvalues : SubNodeType, UINWCSEnvNode
  self._subType = SubNodeType.SelectEnv
  self._envId = nil
  if self._envNode == nil then
    ((self.ui).obj_envtSelectNode):SetActive(true)
    self._envNode = (UINWCSEnvNode.New)()
    ;
    (self._envNode):Init((self.ui).obj_envtSelectNode)
    ;
    (self._envNode):InitWCSEnvNode(self.__seasonId, self.__OnSelectEnvCallback, self.__OnOpenEnvTaskCallback)
  else
    ;
    (self._envNode):Show()
    ;
    (self._envNode):RefreshChristmas22EnvNode()
  end
  if self._archiveNode ~= nil then
    (self._archiveNode):Hide()
  else
    ;
    ((self.ui).obj_checkPointNode):SetActive(false)
  end
  if self._diffNode ~= nil then
    (self._diffNode):Hide()
  else
    ;
    ((self.ui).obj_modeSelectNode):SetActive(false)
  end
  ;
  (((self.ui).btn_Back).gameObject):SetActive(true)
  ;
  (((self.ui).btn_NewGame).gameObject):SetActive(false)
  ;
  ((self.ui).obj_selectedOne):SetActive(false)
  ;
  ((self.ui).tex_back_name):SetIndex(1)
  ;
  ((self.ui).textEN):SetIndex(1)
  ;
  ((self.ui).textCN):SetIndex(1)
end

UIWCSModeSelect.__OpenDiff = function(self)
  -- function num : 0_4 , upvalues : SubNodeType, UINWCSSelectTower, _ENV
  self._subType = SubNodeType.SelectDiff
  if self._diffNode == nil then
    ((self.ui).obj_modeSelectNode):SetActive(true)
    self._diffNode = (UINWCSSelectTower.New)()
    ;
    (self._diffNode):Init((self.ui).obj_modeSelectNode)
  else
    ;
    (self._diffNode):Show()
  end
  ;
  (self._diffNode):InitWCSSelectTower(self.__seasonId, self._envId)
  if self._archiveNode ~= nil then
    (self._archiveNode):Hide()
  else
    ;
    ((self.ui).obj_checkPointNode):SetActive(false)
  end
  if self._envNode ~= nil then
    (self._envNode):Hide()
  else
    ;
    ((self.ui).obj_envtSelectNode):SetActive(false)
  end
  ;
  (((self.ui).btn_Back).gameObject):SetActive(true)
  ;
  (((self.ui).btn_NewGame).gameObject):SetActive(true)
  ;
  ((self.ui).tex_back_name):SetIndex(0)
  ;
  ((self.ui).tex_StartPlayText):SetIndex(2)
  ;
  ((self.ui).textEN):SetIndex(2)
  ;
  ((self.ui).textCN):SetIndex(2)
  ;
  ((self.ui).obj_selectedOne):SetActive(true)
  -- DECOMPILER ERROR at PC95: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_SelectedEnvName).text = (LanguageUtil.GetLocaleText)((self._envCfg).general_env_name)
end

UIWCSModeSelect.__OnSelectArchive = function(self)
  -- function num : 0_5
  self:__OnClickConfirm()
end

UIWCSModeSelect.__OnSelectEnv = function(self, envId, envCfg)
  -- function num : 0_6
  self._envId = envId
  self._envCfg = envCfg
  self:__OpenDiff()
end

UIWCSModeSelect.OnClickRollback = function(self)
  -- function num : 0_7 , upvalues : SubNodeType
  if self._subType == SubNodeType.SelectDiff then
    self:__OpenEnv()
  else
    if self._subType == SubNodeType.SelectEnv then
      self:__OpenArchive()
    end
  end
end

UIWCSModeSelect.__OnClickConfirm = function(self)
  -- function num : 0_8 , upvalues : SubNodeType, cs_MessageCommon, _ENV
  if self._subType == SubNodeType.Archieve then
    local selectNewGame, selectArchive = (self._archiveNode):GetArchiveSelect()
    do
      if selectNewGame then
        self:__OpenEnv()
      else
        ;
        (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(8717), function()
    -- function num : 0_8_0 , upvalues : self, selectArchive
    if self.__loadSavingDataCallback ~= nil then
      (self.__loadSavingDataCallback)(selectArchive)
    end
  end
, nil)
      end
    end
  else
    do
      if self._subType == SubNodeType.SelectDiff then
        local stageInfoCfg = (self._diffNode):GetWCSSelectDiffInfoCfg()
        if self.__startNewWCSCallback ~= nil then
          (self.__startNewWCSCallback)(stageInfoCfg, self._envId)
        end
      end
    end
  end
end

UIWCSModeSelect.OnClickCloseModeSelect = function(self)
  -- function num : 0_9 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIWCSModeSelect.OnCloseChristmasSelect = function(self)
  -- function num : 0_10
  if self._closeCallback ~= nil then
    (self._closeCallback)()
  end
  self:Delete()
end

UIWCSModeSelect.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  if self._archiveNode ~= nil then
    (self._archiveNode):OnDelete()
  end
  if self._diffNode ~= nil then
    (self._diffNode):OnDelete()
  end
  if self._envNode ~= nil then
    (self._envNode):OnDelete()
  end
  ;
  (base.OnDelete)(self)
end

return UIWCSModeSelect

