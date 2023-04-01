-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23ModeSelectEnvItem = class("UINSpring23ModeSelectEnvItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINSpring23ModeSelectEnvItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Select, self, self.OnClickSelect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Locked, self, self.OnClickLocked)
end

UINSpring23ModeSelectEnvItem.InitSpring23EnvItem = function(self, actSpringData, envCfg, selectCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._data = actSpringData
  self._envCfg = envCfg
  self._selectCallback = selectCallback
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnvironmentName).text = (LanguageUtil.GetLocaleText)((self._envCfg).env_name)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)((self._envCfg).env_des)
  self:RefreshChristmas22EnvItem()
end

UINSpring23ModeSelectEnvItem.RefreshChristmas22EnvItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).tex_Additon):SetIndex(0, (self._envCfg).env_des_extra)
  local isUnlock = (self._data):IsSpring23EnvUnlock((self._envCfg).env_id)
  ;
  (((self.ui).btn_Select).gameObject):SetActive(isUnlock)
  ;
  (((self.ui).btn_Locked).gameObject):SetActive(not isUnlock)
  if not isUnlock then
    local lockDes = (CheckCondition.GetUnlockInfoLua)((self._envCfg).pre_condition, (self._envCfg).pre_para1, (self._envCfg).pre_para2)
    do
      do
        if (self._envCfg).need_interact > 0 then
          local lockDes2 = (string.format)(ConfigData:GetTipContent(9105), tostring((self._envCfg).need_interact))
          lockDes = lockDes .. "\n" .. lockDes2
        end
        self._unlockStr = lockDes
        -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

        ;
        ((self.ui).tex_unlock).text = self._unlockStr
        if isUnlock then
          local isHaveExtrAdd = not (string.IsNullOrEmpty)((self._envCfg).env_des_extra)
        end
        ;
        ((self.ui).obj_Buff):SetActive(isHaveExtrAdd)
        if isHaveExtrAdd then
          ((self.ui).tex_Additon):SetIndex(0, (self._envCfg).env_des_extra)
        end
      end
    end
  end
end

UINSpring23ModeSelectEnvItem.OnClickSelect = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.__isShowingBlueDot then
    local userDataCache = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    local actId = (self._data):GetActId()
    local envId = (self._envCfg).env_id
    userDataCache:SetSpring23IsNotEnteredNewEnv(actId, envId, false)
    ;
    (self._data):RefreshSpring23LevelUnlockBuleDot()
  end
  do
    if self._selectCallback ~= nil then
      (self._selectCallback)((self._envCfg).env_id)
    end
  end
end

UINSpring23ModeSelectEnvItem.OnClickLocked = function(self)
  -- function num : 0_4 , upvalues : cs_MessageCommon
  (cs_MessageCommon.ShowMessageTips)(self._unlockStr)
end

UINSpring23ModeSelectEnvItem.GetSpring23EnvId = function(self)
  -- function num : 0_5
  return (self._envCfg).env_id
end

UINSpring23ModeSelectEnvItem.SetSpring23EnvBlueDot = function(self, active)
  -- function num : 0_6
  self.__isShowingBlueDot = active
  ;
  ((self.ui).obj_blueDot):SetActive(active)
end

return UINSpring23ModeSelectEnvItem

