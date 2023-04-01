-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UICarnivalInfoWindow = class("UICarnivalInfoWindow", base)
UICarnivalInfoWindow.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_BG, self, self._OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self._OnClickClose)
end

UICarnivalInfoWindow.InitCarnivalTaskIntroRule = function(self, ruleId)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  local ruleCfg = (ConfigData.system_rule)[ruleId]
  if ruleCfg == nil then
    error("rule is NIL " .. tostring(ruleId))
    return 
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Rule).text = (LanguageUtil.GetLocaleText)(ruleCfg.rule_text)
end

UICarnivalInfoWindow.InitCarnivalInfoWindow = function(self, ruleId)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  local ruleCfg = (ConfigData.system_rule)[ruleId]
  if ruleCfg == nil then
    error("rule is NIL " .. tostring(ruleId))
    return 
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des1Rule).text = (LanguageUtil.GetLocaleText)(ruleCfg.rule_text)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(ruleCfg.maintitle)
end

UICarnivalInfoWindow._OnClickClose = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UICarnivalInfoWindow.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UICarnivalInfoWindow

