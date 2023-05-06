-- params : ...
-- function num : 0 , upvalues : _ENV
local UINATHDungeonInfo = class("UINATHDungeonInfo", UIBaseNode)
local base = UIBaseNode
UINATHDungeonInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickCloseBtnInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_yes, self, self.__OnClickCloseBtnInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.__OnClickCloseBtnInfo)
end

UINATHDungeonInfo.InitDungeonInfo = function(self, infoText, infoTitleIndex)
  -- function num : 0_1 , upvalues : _ENV
  (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_DropInfo).text = infoText
  ;
  ((self.ui).tex_InfoTitle):SetIndex(infoTitleIndex)
end

UINATHDungeonInfo.BackAction = function(self)
  -- function num : 0_2
  self:Hide()
end

UINATHDungeonInfo.__OnClickCloseBtnInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

return UINATHDungeonInfo

