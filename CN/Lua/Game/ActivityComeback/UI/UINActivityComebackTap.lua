-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivityCombackTap = class("UINActivityCombackTap", UIBaseNode)
local base = UIBaseNode
UINActivityCombackTap.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_pageItem, self, self.__OnClickItem)
  self._defaultColorText = ((self.ui).tex_PageName).color
  self._defaultColorImg = ((self.ui).img_PageIcon).color
end

UINActivityCombackTap.InitActivityCombackTap = function(self, activityFaramData, clickFunc, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self._activityFaramData = activityFaramData
  self._clickFunc = clickFunc
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_PageName).text = (self._activityFaramData).name
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  if (self._activityFaramData).icon ~= nil then
    ((self.ui).img_PageIcon).enabled = false
    resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("UI_EventMain"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PageIcon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self._activityFaramData).icon)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_PageIcon).enabled = true
  end
)
  end
end

UINActivityCombackTap.RefreshCombackTapSelect = function(self, flag)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).obj_Select):SetActive(flag)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).tex_PageName).color = Color.white
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_PageIcon).color = Color.white
  else
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_PageName).color = self._defaultColorText
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_PageIcon).color = self._defaultColorImg
  end
end

UINActivityCombackTap.__OnClickItem = function(self)
  -- function num : 0_3
  if self._clickFunc ~= nil then
    (self._clickFunc)(self._activityFaramData)
  end
end

UINActivityCombackTap.GetActivityCombackData = function(self)
  -- function num : 0_4
  return self._activityFaramData
end

UINActivityCombackTap.SetComebackTabReddot = function(self, flag)
  -- function num : 0_5
  ((self.ui).redDot):SetActive(flag)
end

return UINActivityCombackTap

