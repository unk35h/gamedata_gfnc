-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAutoModuleSwitch = class("UINAutoModuleSwitch", UIBaseNode)
local base = UIBaseNode
UINAutoModuleSwitch.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AutoModule, self, self.OnTogAutoModuleChanged)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_StartAuto, self, self.OnBtnStartAutoClicked)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.ui).color_DefaultAuto = ((self.ui).img_StartAuto).color
  self.__onRefreshAutoModeState = BindCallback(self, self.RefreshAutoModeState)
  MsgCenter:AddListener(eMsgEventId.OnRefreshAutoModeState, self.__onRefreshAutoModeState)
end

UINAutoModuleSwitch.OnTogAutoModuleChanged = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local enable = ((ExplorationManager.epCtrl).autoCtrl):IsEnableAutoMode()
  local value = not enable
  if enable then
    ((ExplorationManager.epCtrl).autoCtrl):DisableEpAutoMode()
  else
    ;
    ((ExplorationManager.epCtrl).autoCtrl):EnableEpAutoMode()
  end
end

UINAutoModuleSwitch.RefreshAutoModeState = function(self, value, isRunning)
  -- function num : 0_2
  ((self.ui).tex_AutoON):SetActive(value)
  ;
  ((self.ui).tex_AutoOFF):SetActive(not value)
  ;
  ((self.ui).img_AudoSelect):SetIndex(value and 1 or 0)
  ;
  (((self.ui).btn_StartAuto).gameObject):SetActive(value)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

  if isRunning then
    ((self.ui).img_StartAuto).color = (self.ui).color_CloseAuto
    ;
    ((self.ui).tex_StartAuto):SetIndex(1)
  else
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_StartAuto).color = (self.ui).color_DefaultAuto
    ;
    ((self.ui).tex_StartAuto):SetIndex(0)
  end
end

UINAutoModuleSwitch.OnBtnStartAutoClicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local modelOpen, isRunning = ((ExplorationManager.epCtrl).autoCtrl):StartOrStopEpAutoMode()
  self:RefreshAutoModeState(modelOpen, isRunning)
end

UINAutoModuleSwitch.OnDelete = function(self)
  -- function num : 0_4 , upvalues : _ENV
  MsgCenter:RemoveListener(eMsgEventId.OnRefreshAutoModeState, self.__onRefreshAutoModeState)
end

return UINAutoModuleSwitch

