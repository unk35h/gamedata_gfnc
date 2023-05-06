-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHalloween22ModeSelect = class("UIHalloween22ModeSelect", UIBaseWindow)
local base = UIBaseWindow
local UINHalloweenSelectMode = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectMode")
local UINHalloweenSelectArchive = require("Game.ActivityHallowmas.UI.Select.UINHalloweenSelectArchive")
UIHalloween22ModeSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.OnCloseSelect, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickBackSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NewGame, self, self.OnClickSelectComfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).token, self, self.OnClickToken)
  self.__RefreshPointCallback = BindCallback(self, self.__RefreshPoint)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmas, self.__RefreshPointCallback)
  self.__ArchiveSelectCallback = BindCallback(self, self.__ArchiveSelect)
  self.__RefreshSelectBtnStateCallback = BindCallback(self, self.__RefreshSelectBtnState)
  self.__ChangeUIStateCallback = BindCallback(self, self.__ChangeUIState)
end

UIHalloween22ModeSelect.InitModeSelect = function(self, hallowmasData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = hallowmasData
  self._callback = callback
  local iconId = (self._data):GetHallowmasScoreItemId()
  ;
  ((self.ui).tex_TokenName):SetIndex(0, ConfigData:GetItemName(iconId))
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenIcon).sprite = CRH:GetSpriteByItemId(iconId)
  self:__RefreshPoint()
  local saveData = WarChessSeasonManager:GetWCSSavingData()
  if saveData == nil or (table.count)(saveData) == 0 then
    self:__EnterModel()
  else
    self:__EnterArchive()
  end
end

UIHalloween22ModeSelect.__RefreshPoint = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local exp, expLimit = (self._data):GetHallowmasScoreDailyLimit()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TokenNum).text = tostring(exp) .. "/" .. tostring(expLimit)
end

UIHalloween22ModeSelect.__RefreshSelectBtnState = function(self)
  -- function num : 0_3
  if self._archiveNode ~= nil and (self._archiveNode).active then
    (((self.ui).btn_NewGame).gameObject):SetActive(false)
  else
    ;
    (((self.ui).btn_NewGame).gameObject):SetActive(true)
    ;
    ((self.ui).tex_Text):SetIndex(1)
  end
end

UIHalloween22ModeSelect.__ChangeUIState = function(self)
  -- function num : 0_4
  if self._archiveNode == nil or not (self._archiveNode).active then
    self:__EnterArchive()
  else
    self:__EnterModel()
  end
end

UIHalloween22ModeSelect.__EnterArchive = function(self)
  -- function num : 0_5 , upvalues : UINHalloweenSelectArchive
  ((self.ui).tex_title):SetIndex(0)
  if self._modeNode ~= nil then
    (self._modeNode):Hide()
  else
    ;
    ((self.ui).modeSelectNode):SetActive(false)
  end
  if self._archiveNode == nil then
    ((self.ui).checkPointNode):SetActive(true)
    self._archiveNode = (UINHalloweenSelectArchive.New)()
    ;
    (self._archiveNode):Init((self.ui).checkPointNode)
    ;
    (self._archiveNode):InitHalloweenSelectArchive(self._data, self.__ArchiveSelectCallback)
  else
    ;
    (self._archiveNode):Show()
  end
  self:__RefreshSelectBtnState()
end

UIHalloween22ModeSelect.__ArchiveSelect = function(self)
  -- function num : 0_6
  self:OnClickSelectComfirm()
end

UIHalloween22ModeSelect.__EnterModel = function(self)
  -- function num : 0_7 , upvalues : UINHalloweenSelectMode
  ((self.ui).tex_title):SetIndex(1)
  if self._archiveNode ~= nil then
    (self._archiveNode):Hide()
  else
    ;
    ((self.ui).checkPointNode):SetActive(false)
  end
  if self._modeNode == nil then
    ((self.ui).modeSelectNode):SetActive(true)
    self._modeNode = (UINHalloweenSelectMode.New)()
    ;
    (self._modeNode):Init((self.ui).modeSelectNode)
    ;
    (self._modeNode):InitHalloweenSelectMode(self._data, nil, self.__RefreshSelectBtnStateCallback, self.__ChangeUIStateCallback)
  else
    ;
    (self._modeNode):Show()
  end
  self:__RefreshSelectBtnState()
end

UIHalloween22ModeSelect.OnClickSelectComfirm = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self._archiveNode ~= nil and (self._archiveNode).active then
    local isSelectNew, archive = (self._archiveNode):GetArchiveSelect()
    if isSelectNew then
      self:__ChangeUIState()
    else
      if archive ~= nil then
        local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
        ctrl:ArchivehallowmasSeason(archive)
      end
    end
  else
    do
      if self._modeNode ~= nil then
        local selectDiffId = (self._modeNode):GetSelectHallowDiffId()
        if selectDiffId or 0 > 0 then
          local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
          ctrl:EnterhallowmasSeason((self._data):GetActId(), selectDiffId)
        end
      end
    end
  end
end

UIHalloween22ModeSelect.OnClickToken = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Carnival22InfoWindow, function(win)
    -- function num : 0_9_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitCarnivalInfoWindow(((self._data):GetHallowmasMainCfg()).score_limit_tip)
  end
)
end

UIHalloween22ModeSelect.OnClickBackSelect = function(self)
  -- function num : 0_10 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIHalloween22ModeSelect.OnCloseSelect = function(self)
  -- function num : 0_11
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIHalloween22ModeSelect.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmas, self.__RefreshPointCallback)
  ;
  (base.OnDelete)(self)
end

return UIHalloween22ModeSelect

