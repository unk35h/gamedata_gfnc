-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarChessMainTop_PressPanelItem = {}
local base = UIBaseNode
local UINWarChessMainTop_PressPanelItem = class("UINWarChessMainTop_PressPanelItem", UIBaseNode)
UINWarChessMainTop_PressPanelItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessMainTop_PressPanelItem.RefreshWCPressItem = function(self, stressPoint, stressCfg, sprite)
  -- function num : 0_1 , upvalues : _ENV
  local isReached = stressCfg.stresspoint <= stressPoint
  if isReached then
    ((self.ui).img_pressureItem):SetIndex(0)
    ;
    ((self.ui).tween_icon):DOPlay()
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_isActive).color = (self.ui).color_ActiveImg
  else
    ((self.ui).img_pressureItem):SetIndex(1)
    ;
    ((self.ui).tween_icon):DOPause()
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_isActive).color = (self.ui).color_notActiveImg
  end
  ;
  ((self.ui).obj_isActive):SetActive(isReached)
  ;
  ((self.ui).obj_inactive):SetActive(not isReached)
  -- DECOMPILER ERROR at PC53: Confused about usage of register: R5 in 'UnsetPending'

  if isReached then
    ((self.ui).slider_inactive).value = stressPoint / stressCfg.stresspoint
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_Inactive).text = tostring(stressPoint) .. "/" .. tostring(stressCfg.stresspoint)
    if stressCfg.level < 10 then
      ((self.ui).tex_Lv):SetIndex(0, tostring(stressCfg.level))
    else
      ((self.ui).tex_Lv):SetIndex(1, tostring(stressCfg.level))
    end
    local index = 0
    ;
    (((self.ui).img_Icon).gameObject):SetActive(sprite ~= nil)
    -- DECOMPILER ERROR at PC99: Confused about usage of register: R6 in 'UnsetPending'

    if sprite ~= nil then
      ((self.ui).img_Icon).sprite = sprite
      index = 2
    end
    if isReached then
      index = index + 1
    end
    ;
    ((self.ui).img_Type):SetIndex(index)
    -- DECOMPILER ERROR at PC115: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(stressCfg.describe)
    -- DECOMPILER ERROR: 10 unprocessed JMP targets
  end
end

UINWarChessMainTop_PressPanelItem.PlayPressureItemTween = function(self, time)
  -- function num : 0_2
  ((self.ui).canvas_PressureItem):DOComplete()
  ;
  ((((self.ui).canvas_PressureItem):DOFade(0, 0.3)):From()):SetDelay(time * 0.03)
end

UINWarChessMainTop_PressPanelItem.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  ((self.ui).canvas_PressureItem):DOKill()
  ;
  (base.OnDelete)(self)
end

return UINWarChessMainTop_PressPanelItem

