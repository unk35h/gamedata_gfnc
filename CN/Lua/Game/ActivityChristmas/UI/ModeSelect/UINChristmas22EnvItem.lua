-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22EnvItem = class("UINChristmas22EnvItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINChristmas22EnvItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Reward, self, self.OnClickScoreTask)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Rank, self, self.OnClickRank)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self.OnClickSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).obj_Locked, self, self.OnClickLocked)
end

UINChristmas22EnvItem.InitChristmas22EnvItem = function(self, hallowmasData, envCfg, selectCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = hallowmasData
  self._envCfg = envCfg
  self._selectCallback = selectCallback
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnvironmentName).text = (LanguageUtil.GetLocaleText)((self._envCfg).general_env_name)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)((self._envCfg).general_env_des)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)((self._envCfg).general_env_des2)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_BuffIcon).sprite = CRH:GetSprite((self._envCfg).general_env_icon, CommonAtlasType.ExplorationIcon)
  self:RefreshChristmas22EnvItem()
end

UINChristmas22EnvItem.BindChristmas22EnvCallback = function(self, secotorTaskCallback, rankCallback)
  -- function num : 0_2
  self._secotorTaskCallback = secotorTaskCallback
  self._rankCallback = rankCallback
end

UINChristmas22EnvItem.RefreshChristmas22EnvItem = function(self)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tex_score):SetIndex(0, tostring((self._data):GetHallowmasEnvScore((self._envCfg).general_env_id)))
  local isUnlock = (self._data):IsHallowmasEnvUnlock((self._envCfg).general_env_id)
  ;
  (((self.ui).btn_Reward).gameObject):SetActive(not isUnlock or #(self._envCfg).env_task > 0)
  ;
  (((self.ui).btn_Rank).gameObject):SetActive(not isUnlock or (self._envCfg).rank_id > 0)
  ;
  (((self.ui).btn_Select).gameObject):SetActive(isUnlock)
  ;
  ((self.ui).score):SetActive(isUnlock)
  ;
  (((self.ui).obj_Locked).gameObject):SetActive(not isUnlock)
  do
    if not isUnlock then
      local conditionList = (self._envCfg).preConditions
      if (self._envCfg).preConditionsNum > 1 then
        local unlockInfo = (LanguageUtil.GetLocaleText)((self._envCfg).pre_desc)
        if not (string.IsNullOrEmpty)(unlockInfo) then
          self._unlockStr = unlockInfo
        else
          self._unlockStr = (CheckCondition.GetUnlockInfoLuaByManyList)(conditionList)
          self._unlockStr = ConfigData:GetTipContent(8708, self._unlockStr)
        end
      elseif (self._envCfg).preConditionsNum == 1 then
        local firstCond = conditionList[1]
        self._unlockStr = (CheckCondition.GetUnlockInfoLua)(firstCond[1], firstCond[2], firstCond[3])
        self._unlockStr = ConfigData:GetTipContent(8708, self._unlockStr)
      else
        self._unlockStr = ""
      end
      -- DECOMPILER ERROR at PC117: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_unlock).text = self._unlockStr
    end
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    self._isLookedTask = userDataCache:GetHallowmasEnvTaskLooked((self._data):GetActId(), (self._envCfg).general_env_id)
    ;
    ((self.ui).task_blueDot):SetActive(not self._isLookedTask)
    -- DECOMPILER ERROR: 9 unprocessed JMP targets
  end
end

UINChristmas22EnvItem.OnClickRank = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (self._envCfg).rank_id <= 0 then
    return 
  end
  if self._rankCallback ~= nil then
    (self._rankCallback)((self._envCfg).rank_id)
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonRank, function(rankWindow)
    -- function num : 0_4_0 , upvalues : self
    if rankWindow == nil then
      return 
    end
    rankWindow:InitCommonRank((self._envCfg).rank_id)
  end
)
end

UINChristmas22EnvItem.OnClickScoreTask = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._secotorTaskCallback ~= nil then
    (self._secotorTaskCallback)(self._envCfg)
  end
  if not self._isLookedTask then
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    userDataCache:SetHallowmasEnvTaskLooked((self._data):GetActId(), (self._envCfg).general_env_id)
    ;
    ((self.ui).task_blueDot):SetActive(false)
    self._isLookedTask = true
  end
end

UINChristmas22EnvItem.OnClickSelect = function(self)
  -- function num : 0_6
  if self._selectCallback ~= nil then
    (self._selectCallback)((self._envCfg).general_env_id)
  end
end

UINChristmas22EnvItem.OnClickLocked = function(self)
  -- function num : 0_7 , upvalues : cs_MessageCommon
  (cs_MessageCommon.ShowMessageTips)(self._unlockStr)
end

UINChristmas22EnvItem.GetChristmasEnvCfg = function(self)
  -- function num : 0_8
  return self._envCfg
end

UINChristmas22EnvItem.SetChristmasEnvTaskRed = function(self, active)
  -- function num : 0_9
  ((self.ui).task_redDot):SetActive(active)
  if not self._isLookedTask then
    ((self.ui).task_blueDot):SetActive(not active)
  end
end

return UINChristmas22EnvItem

