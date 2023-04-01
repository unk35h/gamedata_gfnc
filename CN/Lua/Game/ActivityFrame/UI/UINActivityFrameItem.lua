-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActivityFrameItem = class("UINActivityFrameItem", UIBaseNode)
local base = UIBaseNode
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
UINActivityFrameItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_SwitchItem, self, self.OnSwitchValueChange)
end

UINActivityFrameItem.InitActivitySwitchItem = function(self, activityFrameData, changeValueFunc, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.activityFrameData = activityFrameData
  self.changeValueFunc = changeValueFunc
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.activityFrameData).name)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  if (self.activityFrameData).icon ~= nil then
    ((self.ui).img_Icon).enabled = false
    resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("UI_EventMain"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self.activityFrameData).icon)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).enabled = true
  end
)
  end
end

UINActivityFrameItem.SetActivitySwitchLineState = function(self, flag)
  -- function num : 0_2
  ((self.ui).obj_Line):SetActive(flag)
end

UINActivityFrameItem.InitActivitySwitchItemWithFakeData = function(self, fakeCfg, changeValueFunc)
  -- function num : 0_3 , upvalues : _ENV
  self.changeValueFunc = changeValueFunc
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(fakeCfg.name)
end

UINActivityFrameItem.SelectActivityTag = function(self)
  -- function num : 0_4
  if ((self.ui).tog_SwitchItem).isOn then
    self:OnSwitchValueChange(true)
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tog_SwitchItem).isOn = true
  end
end

UINActivityFrameItem.OnSwitchValueChange = function(self, flag)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  if flag then
    ((self.ui).tex_Name).color = (self.ui).color_selected
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_selected
  else
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).color = (self.ui).color_unselect
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).color = (self.ui).color_unselect
  end
  if self.changeValueFunc ~= nil then
    (self.changeValueFunc)(self, flag)
  end
end

UINActivityFrameItem.ActivityTagReddotShow = function(self, flag)
  -- function num : 0_6
  ((self.ui).redDot):SetActive(flag)
end

UINActivityFrameItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (base.OnDelete)(self)
end

return UINActivityFrameItem

