-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22EnvDetailItem = class("UINCarnival22EnvDetailItem", UIBaseNode)
local base = UIBaseNode
local ActivityCarnivalEnum = require("Game.ActivityCarnival.ActivityCarnivalEnum")
UINCarnival22EnvDetailItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).selectedBg, self, self.OnClickItem)
  self._defaultOutputColor = ((self.ui).img_outputBg).color
end

UINCarnival22EnvDetailItem.InitEnvDetailItem = function(self, carnival, envCfg, hideline, clickFunc)
  -- function num : 0_1 , upvalues : _ENV, ActivityCarnivalEnum
  self._carnival = carnival
  self._envCfg = envCfg
  self._clickFunc = clickFunc
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_EnviroNO).text = (LanguageUtil.GetLocaleText)((self._envCfg).env_name)
  ;
  ((self.ui).tex_ENEnviroNO):SetIndex(0, tostring((self._envCfg).id))
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Details).text = (LanguageUtil.GetLocaleText)((self._envCfg).env_des)
  local extraContent = (LanguageUtil.GetLocaleText)((self._envCfg).env_des_extra)
  ;
  ((self.ui).obj_outputBg):SetActive(not (string.IsNullOrEmpty)(extraContent))
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Output).text = extraContent
  ;
  ((self.ui).line):SetActive(not hideline)
  local unlock = (self._carnival):IsCarnivalUnlockEnv((self._envCfg).id)
  ;
  ((self.ui).obj_Locked):SetActive(not unlock)
  ;
  (((self.ui).selectedBg).gameObject):SetActive(unlock)
  if not unlock then
    local unlockLevel = (self._envCfg).exp_level
    local lockStr = (string.format)(ConfigData:GetTipContent(7122), tostring(unlockLevel))
    local lockDeslist = (CheckCondition.GetUnlockAndInfoList)((self._envCfg).pre_condition, (self._envCfg).pre_para1, (self._envCfg).pre_para2)
    for i = 1, #lockDeslist do
      lockStr = lockStr .. "\n" .. (lockDeslist[i]).lockReason
    end
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_Locked).text = lockStr
    -- DECOMPILER ERROR at PC106: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).enviroBg).color = (self.ui).color_locked_img
    -- DECOMPILER ERROR at PC111: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_output_title).color = (self.ui).color_locked_text
    -- DECOMPILER ERROR at PC117: Confused about usage of register: R10 in 'UnsetPending'

    ;
    (((self.ui).tex_ENEnviroNO).text).color = (self.ui).color_locked_text
    -- DECOMPILER ERROR at PC122: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).tex_Details).color = (self.ui).color_locked_text
    -- DECOMPILER ERROR at PC127: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).img_outputBg).color = (self.ui).color_locked_img
  else
    do
      -- DECOMPILER ERROR at PC133: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).enviroBg).color = Color.white
      -- DECOMPILER ERROR at PC138: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).tex_output_title).color = Color.white
      -- DECOMPILER ERROR at PC144: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (((self.ui).tex_ENEnviroNO).text).color = Color.white
      -- DECOMPILER ERROR at PC149: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).tex_Details).color = Color.white
      -- DECOMPILER ERROR at PC153: Confused about usage of register: R7 in 'UnsetPending'

      ;
      ((self.ui).img_outputBg).color = self._defaultOutputColor
      local reddot = (self._carnival):GetActivityReddot()
      if reddot == nil then
        return 
      end
      reddot = reddot:GetChild((ActivityCarnivalEnum.eActivityCarnivalReddot).UnlockEnv)
      if reddot == nil then
        return 
      end
      reddot = reddot:GetChild(tostring((self._envCfg).id))
      ;
      ((self.ui).redDot):SetActive(reddot ~= nil and reddot:GetRedDotCount() > 0)
      -- DECOMPILER ERROR: 1 unprocessed JMP targets
    end
  end
end

UINCarnival22EnvDetailItem.GetEnvDetailItemCfg = function(self)
  -- function num : 0_2
  return self._envCfg
end

UINCarnival22EnvDetailItem.SetEvnDetailItemCurrent = function(self, flag)
  -- function num : 0_3
  ((self.ui).now):SetActive(flag)
  if flag then
    (((self.ui).selectedBg).gameObject):SetActive(false)
  end
end

UINCarnival22EnvDetailItem.OnClickItem = function(self)
  -- function num : 0_4
  if self._clickFunc ~= nil then
    (self._clickFunc)((self._envCfg).id)
  end
end

return UINCarnival22EnvDetailItem

