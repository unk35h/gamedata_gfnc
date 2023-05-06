-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonRuleInfo = class("UICommonRuleInfo", UIBaseWindow)
local base = UIBaseWindow
UICommonRuleInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__CloseUI)
  ;
  (UIUtil.AddButtonListener)((self.ui).background, self, self.__OnClickBackgroup)
end

UICommonRuleInfo.InitCommonRule = function(self, ruleId)
  -- function num : 0_1 , upvalues : _ENV
  local ruleCfg = (ConfigData.system_rule)[ruleId]
  if ruleCfg == nil then
    error("system_rule MISS ruleId is " .. tostring(ruleId))
    return 
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_MainTile).text = (LanguageUtil.GetLocaleText)(ruleCfg.maintitle)
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_SubTile).text = (LanguageUtil.GetLocaleText)(ruleCfg.subtitle)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_En).text = (LanguageUtil.GetLocaleText)(ruleCfg.text_en)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Title).text = (LanguageUtil.GetLocaleText)(ruleCfg.title)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Rule).text = (LanguageUtil.GetLocaleText)(ruleCfg.rule_text)
end

UICommonRuleInfo.__OnClickBackgroup = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UICommonRuleInfo.__CloseUI = function(self)
  -- function num : 0_3
  self:Delete()
end

return UICommonRuleInfo

