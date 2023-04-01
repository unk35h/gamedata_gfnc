-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSwitchHouseBtn = class("UINSwitchHouseBtn", UIBaseNode)
local base = UIBaseNode
UINSwitchHouseBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_House, self, self._OnBtnHouseClick)
end

UINSwitchHouseBtn.InitSwitchHouse = function(self, houseId, name, iconIdx, clickAction)
  -- function num : 0_1 , upvalues : _ENV
  self._clickAction = clickAction
  self._houseId = houseId
  ;
  ((self.ui).img_House):SetIndex(iconIdx)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = tostring(name)
end

UINSwitchHouseBtn._OnBtnHouseClick = function(self)
  -- function num : 0_2
  if self._clickAction ~= nil then
    (self._clickAction)(self._houseId, true)
  end
end

UINSwitchHouseBtn.SetSwitchHouseBtnLock = function(self, isLock)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).obj_Lock):SetActive(isLock)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).img_House).image).enabled = not isLock
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  if not isLock or not (self.ui).color_lockName then
    ((self.ui).tex_Name).color = Color.white
  end
end

UINSwitchHouseBtn.SetSwitchHouseReddot = function(self, active)
  -- function num : 0_4
  ((self.ui).obj_redDot):SetActive(active)
end

UINSwitchHouseBtn.ShowSwitchHouseBlueDot = function(self, isShow)
  -- function num : 0_5
  ((self.ui).obj_blueDot):SetActive(isShow)
end

UINSwitchHouseBtn.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINSwitchHouseBtn

