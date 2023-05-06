-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChristmas22ModeSelect = class("UIChristmas22ModeSelect", UIBaseWindow)
local base = UIBaseWindow
local UINHalloweenSelectArchive = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectArchive")
local UINHalloweenSelectMode = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectMode")
local UINChristmas22EnvNode = require("Game.ActivityChristmas.UI.ModeSelect.UINChristmas22EnvNode")
local cs_MessageCommon = CS.MessageCommon
local SubNodeType = {Archieve = 1, SelectEnv = 2, SelectDiff = 3}
UIChristmas22ModeSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseChristmasSelect, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseModeSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickRollback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NewGame, self, self.OnClickConfirm)
  self.__OnSelectArchiveCallback = BindCallback(self, self.__OnSelectArchive)
  self.__OnSelectEnvCallback = BindCallback(self, self.__OnSelectEnv)
  self.__OnOpenEnvTaskCallback = BindCallback(self, self.__OnOpenEnvTask)
end

UIChristmas22ModeSelect.InitChristmas22ModeSelect = function(self, hallowmasData)
  -- function num : 0_1 , upvalues : _ENV
  self._data = hallowmasData
  self._envId = nil
  self._callback = callback
  local saveData = WarChessSeasonManager:GetWCSSavingData()
  if saveData == nil or (table.count)(saveData) == 0 then
    self:__OpenEnv()
  else
    self:__OpenArchive()
  end
end

UIChristmas22ModeSelect.__OpenArchive = function(self)
  -- function num : 0_2 , upvalues : SubNodeType, UINHalloweenSelectArchive
  self._subType = SubNodeType.Archieve
  if self._archiveNode == nil then
    ((self.ui).checkPointNode):SetActive(true)
    self._archiveNode = (UINHalloweenSelectArchive.New)()
    ;
    (self._archiveNode):Init((self.ui).checkPointNode)
    ;
    (self._archiveNode):InitHalloweenSelectArchive(self._data, self.__OnSelectArchiveCallback)
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
    ((self.ui).environmentSelectNode):SetActive(false)
  end
  if self._diffNode ~= nil then
    (self._diffNode):Hide()
  else
    ;
    ((self.ui).modeSelectNode):SetActive(false)
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

UIChristmas22ModeSelect.__OpenEnv = function(self)
  -- function num : 0_3 , upvalues : SubNodeType, UINChristmas22EnvNode, _ENV
  self._subType = SubNodeType.SelectEnv
  self._envId = nil
  if self._envNode == nil then
    ((self.ui).environmentSelectNode):SetActive(true)
    self._envNode = (UINChristmas22EnvNode.New)()
    ;
    (self._envNode):Init((self.ui).environmentSelectNode)
    ;
    (self._envNode):InitChristmas22EnvNode(self._data, self.__OnSelectEnvCallback, self.__OnOpenEnvTaskCallback)
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
    ((self.ui).checkPointNode):SetActive(false)
  end
  if self._diffNode ~= nil then
    (self._diffNode):Hide()
  else
    ;
    ((self.ui).modeSelectNode):SetActive(false)
  end
  local saveData = WarChessSeasonManager:GetWCSSavingData()
  ;
  (((self.ui).btn_Back).gameObject):SetActive(saveData ~= nil and (table.count)(saveData) > 0)
  ;
  (((self.ui).btn_NewGame).gameObject):SetActive(false)
  ;
  ((self.ui).textEN):SetIndex(1)
  ;
  ((self.ui).textCN):SetIndex(1)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIChristmas22ModeSelect.__OpenDiff = function(self)
  -- function num : 0_4 , upvalues : SubNodeType, UINHalloweenSelectMode
  self._subType = SubNodeType.SelectDiff
  if self._diffNode == nil then
    ((self.ui).modeSelectNode):SetActive(true)
    self._diffNode = (UINHalloweenSelectMode.New)()
    ;
    (self._diffNode):Init((self.ui).modeSelectNode)
  else
    ;
    (self._diffNode):Show()
  end
  ;
  (self._diffNode):InitHalloweenSelectMode(self._data, self._envId)
  if self._archiveNode ~= nil then
    (self._archiveNode):Hide()
  else
    ;
    ((self.ui).checkPointNode):SetActive(false)
  end
  if self._envNode ~= nil then
    (self._envNode):Hide()
  else
    ;
    ((self.ui).environmentSelectNode):SetActive(false)
  end
  ;
  (((self.ui).btn_Back).gameObject):SetActive(true)
  ;
  (((self.ui).btn_NewGame).gameObject):SetActive(true)
  ;
  ((self.ui).tex_Text):SetIndex(2)
  ;
  ((self.ui).textEN):SetIndex(2)
  ;
  ((self.ui).textCN):SetIndex(2)
end

UIChristmas22ModeSelect.__OnSelectArchive = function(self)
  -- function num : 0_5
  self:OnClickConfirm()
end

UIChristmas22ModeSelect.__OnSelectEnv = function(self, envId)
  -- function num : 0_6
  self._envId = envId
  self:__OpenDiff()
end

UIChristmas22ModeSelect.__OnOpenEnvTask = function(self, envCfg)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.ChristmasEnvTask, function(window)
    -- function num : 0_7_0 , upvalues : envCfg, _ENV, self
    if window == nil then
      return 
    end
    window:InitChristmasEnvTask(envCfg.env_task, BindCallback(self._data, (self._data).ReqHallowmasCommitEnvTaskList), BindCallback(self._data, (self._data).ReqHallowmasCommitTask))
    local nameCfg = ConfigData.activity_hallowmas_name
    window:SetChristmasEnvTaskTitle((LanguageUtil.GetLocaleText)((nameCfg[5]).name))
  end
)
end

UIChristmas22ModeSelect.OnClickRollback = function(self)
  -- function num : 0_8 , upvalues : SubNodeType
  if self._subType == SubNodeType.SelectDiff then
    self:__OpenEnv()
  else
    if self._subType == SubNodeType.SelectEnv then
      self:__OpenArchive()
    end
  end
end

UIChristmas22ModeSelect.OnClickConfirm = function(self)
  -- function num : 0_9 , upvalues : SubNodeType, cs_MessageCommon, _ENV
  if self._subType == SubNodeType.Archieve then
    local selectNewGame, selectArchive = (self._archiveNode):GetArchiveSelect()
    do
      if selectNewGame then
        self:__OpenEnv()
      else
        ;
        (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(8717), function()
    -- function num : 0_9_0 , upvalues : _ENV, selectArchive
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
    ctrl:ArchivehallowmasSeason(selectArchive)
  end
, nil)
      end
    end
  else
    do
      if self._subType == SubNodeType.SelectDiff then
        local diffId = (self._diffNode):GetSelectHallowDiffId()
        local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
        ctrl:EnterhallowmasSeason((self._data):GetActId(), diffId, self._envId)
      end
    end
  end
end

UIChristmas22ModeSelect.OnClickCloseModeSelect = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIChristmas22ModeSelect.OnCloseChristmasSelect = function(self)
  -- function num : 0_11
  self:Delete()
end

UIChristmas22ModeSelect.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
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

return UIChristmas22ModeSelect

