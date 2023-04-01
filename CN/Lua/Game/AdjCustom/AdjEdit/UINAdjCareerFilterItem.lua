-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjCareerFilterItem = class("UINAdjCareerFilterItem", UIBaseNode)
local base = UIBaseNode
local COLOR_UNSELECT = (Color.New)(0.10980392156863, 0.10980392156863, 0.10980392156863, 1)
UINAdjCareerFilterItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_kindItem, self, self.OnClickFilter)
end

UINAdjCareerFilterItem.InitAdjCareerFilterItem = function(self, career, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._callback = callback
  self._career = career
  self._isSelect = false
  local campCfg = (ConfigData.career)[self._career]
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_KindName).text = (LanguageUtil.GetLocaleText)(campCfg.name)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Career).sprite = CRH:GetSprite(campCfg.icon, CommonAtlasType.CareerCamp)
  self:__RefreshSelectState()
end

UINAdjCareerFilterItem.ResetAdjCareerFilterItem = function(self)
  -- function num : 0_2
  self._isSelect = false
  self:__RefreshSelectState()
end

UINAdjCareerFilterItem.OnClickFilter = function(self)
  -- function num : 0_3
  self._isSelect = not self._isSelect
  self:__RefreshSelectState()
  if self._callback ~= nil then
    (self._callback)(self._career, self._isSelect)
  end
end

UINAdjCareerFilterItem.__RefreshSelectState = function(self)
  -- function num : 0_4 , upvalues : COLOR_UNSELECT, _ENV
  ((self.ui).obj_OnSelect):SetActive(self._isSelect)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if self._isSelect then
    ((self.ui).img_Career).color = COLOR_UNSELECT
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_KindName).color = COLOR_UNSELECT
  else
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Career).color = Color.white
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_KindName).color = Color.white
  end
end

return UINAdjCareerFilterItem

