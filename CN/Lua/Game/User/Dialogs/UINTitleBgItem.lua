-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTitleBgItem = class("UINTitleBgItem", UIBaseNode)
local base = UIBaseNode
local CS_ColorUtility = (CS.UnityEngine).ColorUtility
UINTitleBgItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_bgItem, self, self.OnClickTitleBg)
end

UINTitleBgItem.InitTitleBgItem = function(self, cfg, resloader, bgAtlas, clickFunc)
  -- function num : 0_1 , upvalues : _ENV, CS_ColorUtility
  self.cfg = cfg
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(cfg.name)
  local newTitleItemDic = (PlayerDataCenter.gameSettingData):GetNewTitleItemDic()
  if newTitleItemDic[cfg.id] then
    ((self.ui).img_New):SetActive(true)
  else
    ;
    ((self.ui).img_New):SetActive(false)
  end
  local success, color = (CS_ColorUtility.TryParseHtmlString)(cfg.font_colour)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

  if success then
    ((self.ui).tex_ApDes).color = color
  end
  self.bgAtlas = bgAtlas
  self.resloader = resloader
  -- DECOMPILER ERROR at PC44: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Bg).sprite = (AtlasUtil.GetResldSprite)(self.bgAtlas, cfg.icon)
  self.clickFunc = clickFunc
end

UINTitleBgItem.SetTitleBgSelect = function(self, flag)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).outline).color = (self.ui).selectColor
  else
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).outline).color = (self.ui).normalColor
  end
end

UINTitleBgItem.OnClickTitleBg = function(self)
  -- function num : 0_3
  if self.clickFunc then
    (self.clickFunc)(self.cfg)
  end
end

UINTitleBgItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINTitleBgItem

