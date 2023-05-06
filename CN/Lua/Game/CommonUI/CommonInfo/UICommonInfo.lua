-- params : ...
-- function num : 0 , upvalues : _ENV
local UICommonInfo = class("UICommonInfo", UIBaseWindow)
local base = UIBaseWindow
UICommonInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.__onBackClick, nil, nil, nil, nil, function()
    -- function num : 0_0_0 , upvalues : _ENV
    if ExplorationManager:IsInExploration() then
      (UIUtil.SetTopStatusBtnShow)(false, false)
    end
  end
)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self.__OnClickRootBack)
  self.defaultSize = ((self.ui).tex_Rules).fontSize
end

UICommonInfo.InitCommonInfo = function(self, infoStr, titleStr, backFunc, isNotNeedTop)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R5 in 'UnsetPending'

  ((self.ui).tex_Rules).text = infoStr
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).text_Tile).text = titleStr
  self.onBackCallback = backFunc
  self.isNotNeedTop = isNotNeedTop
  if self.isNotNeedTop then
    (UIUtil.HideTopStatus)()
  end
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Rules).fontSize = self.defaultSize
end

UICommonInfo.SetCommonInfoFontSize = function(self, size)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_Rules).fontSize = size
end

UICommonInfo.InitCommonInfoByRule = function(self, ruleId, showTop)
  -- function num : 0_3 , upvalues : _ENV
  local ruleCfg = (ConfigData.system_rule)[ruleId]
  if ruleCfg == nil then
    error("rule cfg is nil " .. tostring(ruleId))
    return 
  end
  self:InitCommonInfo((LanguageUtil.GetLocaleText)(ruleCfg.rule_text), ((LanguageUtil.GetLocaleText)(ruleCfg.maintitle)), nil, not showTop)
end

UICommonInfo.InitDungeonDropInfo = function(self, dungeonTypeID, backFunc)
  -- function num : 0_4 , upvalues : _ENV
  self.onBackCallback = backFunc
  local cfg = (ConfigData.dungeon_info)[dungeonTypeID]
  if cfg == nil then
    error("dungeon_info cfg is Not Find id:" .. tostring(dungeonTypeID))
  end
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Rules).text = (LanguageUtil.GetLocaleText)(cfg.info_text)
end

UICommonInfo.__OnClickRootBack = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.isNotNeedTop then
    (UIUtil.PopFromBackStackByUiTab)(self)
    ;
    (UIUtil.HideTopStatus)()
    self:__onBackClick()
  else
    ;
    (UIUtil.OnClickBackByUiTab)(self)
  end
end

UICommonInfo.__onBackClick = function(self)
  -- function num : 0_6 , upvalues : base
  if self.onBackCallback ~= nil then
    (self.onBackCallback)()
  end
  ;
  (base.Delete)(self)
end

UICommonInfo.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UICommonInfo

