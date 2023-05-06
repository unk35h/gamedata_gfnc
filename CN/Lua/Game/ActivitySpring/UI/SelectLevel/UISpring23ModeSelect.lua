-- params : ...
-- function num : 0 , upvalues : _ENV
local UISpring23ModeSelect = class("UISpring23ModeSelect", UIBaseWindow)
local base = UIBaseWindow
local UINSpring23ModeSelectDiffNode = require("Game.ActivitySpring.UI.SelectLevel.UINSpring23ModeSelectDiffNode")
local UIMSpring23ModeSelectEnvNode = require("Game.ActivitySpring.UI.SelectLevel.UINSpring23ModeSelectEnvNode")
local SubNodeType = {SelectEnv = 1, SelectDiff = 2}
UISpring23ModeSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, nil)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickCloseModeSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Back, self, self.OnClickRollback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_NewGame, self, self.OnClickConfirm)
  self.__OnSelectEnvCallback = BindCallback(self, self.__OnSelectEnv)
  self.__OnSelectDiffCallback = BindCallback(self, self.__OnSelectDiff)
end

UISpring23ModeSelect.InitSpring23ModeSelect = function(self, actSpringData, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = actSpringData
  self.closeCallback = closeCallback
  self:__OpenEnv()
  local tickId = actSpringData:GetSpringTicketID()
  ;
  (UIUtil.RefreshTopResId)({tickId})
end

UISpring23ModeSelect.__OpenEnv = function(self)
  -- function num : 0_2 , upvalues : SubNodeType, UIMSpring23ModeSelectEnvNode
  self._subType = SubNodeType.SelectEnv
  self._envId = nil
  if self._envNode == nil then
    self._envNode = (UIMSpring23ModeSelectEnvNode.New)()
    ;
    (self._envNode):Init((self.ui).obj_envtSelectNode)
    ;
    (self._envNode):InitSpring23EnvNode(self._data, self.__OnSelectEnvCallback)
  end
  ;
  (self._envNode):RefreshSpring23EnvNode()
  ;
  (self._envNode):Show()
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

UISpring23ModeSelect.__OpenDiff = function(self)
  -- function num : 0_3 , upvalues : SubNodeType, UINSpring23ModeSelectDiffNode, _ENV
  self._subType = SubNodeType.SelectDiff
  if self._diffNode == nil then
    self._diffNode = (UINSpring23ModeSelectDiffNode.New)()
    ;
    (self._diffNode):Init((self.ui).obj_modeSelectNode)
  end
  ;
  (self._diffNode):InitSpring23SelectMode(self._data, self._envId, self.__OnSelectDiffCallback)
  ;
  (self._diffNode):Show()
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
  ((self.ui).textEN):SetIndex(1)
  ;
  ((self.ui).textCN):SetIndex(1)
  ;
  ((self.ui).tex_NewGameText):SetIndex(1)
  local envCfg = (ConfigData.activity_spring_advanced_env)[self._envId]
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_SelectedEnvName).text = (LanguageUtil.GetLocaleText)(envCfg.env_name)
end

UISpring23ModeSelect.__OnSelectEnv = function(self, envId)
  -- function num : 0_4
  self._envId = envId
  self:__OpenDiff()
end

UISpring23ModeSelect.__OnSelectDiff = function(self, diff, index)
  -- function num : 0_5 , upvalues : _ENV
  self._diffId = diff
  self._index = index
  local envCfg = (ConfigData.activity_spring_advanced_env)[self._envId]
  local stageId = (envCfg.stage_id)[self._index]
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local costStamina = stageCfg.cost_strength_num
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Cost).text = "-" .. tostring(costStamina)
end

UISpring23ModeSelect.OnClickConfirm = function(self)
  -- function num : 0_6 , upvalues : SubNodeType, _ENV
  if self._subType == SubNodeType.SelectDiff then
    local EnterFormation = function()
    -- function num : 0_6_0 , upvalues : _ENV, self
    local ctrl = ControllerManager:GetController(ControllerTypeId.ActivitySpring)
    ctrl:EnterSpringEp(self._data, self._envId, self._diffId, self._index)
  end

    do
      local curStamina = (PlayerDataCenter.stamina):GetCurrentStamina()
      if curStamina < (ConfigData.game_config).staminaWarnNum then
        local staminaCeiling = (PlayerDataCenter.stamina):GetStaminaCeiling()
        local msg = (string.format)(ConfigData:GetTipContent(751), curStamina, staminaCeiling)
        local msgWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
        msgWindow:ShowTextBoxWithYesAndNo(msg, function()
    -- function num : 0_6_1 , upvalues : EnterFormation
    EnterFormation()
  end
, function()
    -- function num : 0_6_2
    return 
  end
)
      else
        do
          EnterFormation()
        end
      end
    end
  end
end

UISpring23ModeSelect.OnClickRollback = function(self)
  -- function num : 0_7 , upvalues : SubNodeType
  if self._subType == SubNodeType.SelectDiff then
    self:__OpenEnv()
  end
end

UISpring23ModeSelect.OnClickCloseModeSelect = function(self)
  -- function num : 0_8 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UISpring23ModeSelect.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  if self.closeCallback ~= nil then
    (self.closeCallback)()
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

return UISpring23ModeSelect

