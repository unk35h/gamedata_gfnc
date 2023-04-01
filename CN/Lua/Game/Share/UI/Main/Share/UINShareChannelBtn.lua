-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINShareChannelBtn = class("UINShareChannelBtn", base)
UINShareChannelBtn.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINShareChannelBtn.InitShareChannelBtn = function(self, shareChannelId, clickFunc)
  -- function num : 0_1
  self._shareChannelId = shareChannelId
  self._clickFunc = clickFunc
  ;
  ((self.ui).img_Icon):SetIndex(shareChannelId)
end

UINShareChannelBtn._OnClickRoot = function(self)
  -- function num : 0_2
  if self._clickFunc ~= nil then
    (self._clickFunc)(self._shareChannelId)
  end
end

UINShareChannelBtn.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINShareChannelBtn

