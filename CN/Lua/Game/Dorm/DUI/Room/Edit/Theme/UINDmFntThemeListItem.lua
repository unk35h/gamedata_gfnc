-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINDmFntThemeListItem = class("UINDmFntThemeListItem", base)
UINDmFntThemeListItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINDmFntThemeListItem.InitDmFntThemeListItem = function(self, themeData, editRoomData, resLoader, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  local fntThemeCfg = themeData.dmFntThemeCfg
  self._fntThemeCfg = fntThemeCfg
  self._clickFunc = clickFunc
  local iconPath = PathConsts:GetDormFntThemeIconPath(fntThemeCfg.theme_pic)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).enabled = false
  resLoader:LoadABAssetAsync(iconPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(texture) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).texture = texture
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).enabled = true
  end
)
  local comform = themeData:GetDmFntThemeComformt()
  local ownNum = themeData:GetDmFntThemeUseableNum()
  local totalNum = themeData:GetDmFntThemeTotalNum()
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Comfort).text = tostring(comform)
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(fntThemeCfg.theme_name)
  ;
  ((self.ui).tex_Num):SetIndex(0, tostring(ownNum), tostring(totalNum))
  ;
  ((self.ui).obj_img_OnlyBig):SetActive(fntThemeCfg.only_big)
  if themeData:IsDmFntThemeInSell() then
    (((self.ui).img_Tag).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R10 in 'UnsetPending'

    ;
    ((self.ui).img_Tag).color = ((self.ui).tagColorList)[1]
    ;
    ((self.ui).tex_Tag):SetIndex(0)
  else
    if fntThemeCfg.is_activity then
      (((self.ui).img_Tag).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC85: Confused about usage of register: R10 in 'UnsetPending'

      ;
      ((self.ui).img_Tag).color = ((self.ui).tagColorList)[2]
      ;
      ((self.ui).tex_Tag):SetIndex(1)
    else
      ;
      (((self.ui).img_Tag).gameObject):SetActive(false)
    end
  end
end

UINDmFntThemeListItem._OnClickRoot = function(self)
  -- function num : 0_2
  if self._clickFunc ~= nil then
    (self._clickFunc)(self._fntThemeCfg)
  end
end

UINDmFntThemeListItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmFntThemeListItem

