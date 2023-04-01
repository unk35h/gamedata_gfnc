-- params : ...
-- function num : 0 , upvalues : _ENV
local UISkinVoiceISelectItem = class("UISkinVoiceISelectItem", UIBaseNode)
local base = UIBaseNode
UISkinVoiceISelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickSeleteSkinVoice)
end

UISkinVoiceISelectItem.InitVoiceSelectItem = function(self, skinName, skinId, index, selectEvent)
  -- function num : 0_1
  self.skinId = skinId
  self.index = index
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).text).text = skinName
  self.selectEvent = selectEvent
end

UISkinVoiceISelectItem.OnClickSeleteSkinVoice = function(self)
  -- function num : 0_2
  if self.selectEvent ~= nil then
    (self.selectEvent)(self.skinId, self.index)
  end
end

return UISkinVoiceISelectItem

