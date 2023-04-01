-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFlappyGiftItem = class("UINFlappyGiftItem", UIBaseNode)
local base = UIBaseNode
local AwardPanelTitleTextIndex = 1
UINFlappyGiftItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Item, self, self.__OnClick)
end

UINFlappyGiftItem.InjectAwardData = function(self, fbConfig, showAwardDataFunc, awardIndex)
  -- function num : 0_1
  self.awardData = (fbConfig.progress_award_data)[awardIndex]
  self.__showAwardDataFunc = showAwardDataFunc
  self.fbConfig = fbConfig
end

UINFlappyGiftItem.__OnClick = function(self)
  -- function num : 0_2 , upvalues : AwardPanelTitleTextIndex
  if self.__showAwardDataFunc ~= nil then
    (self.__showAwardDataFunc)(self.awardData, self.fbConfig, AwardPanelTitleTextIndex, (self.ui).awardPanelRoot)
  end
end

UINFlappyGiftItem.UpdatePosAndTips = function(self, progress, percent, totalWidth)
  -- function num : 0_3 , upvalues : _ENV
  local pos = ((self.ui).rectTrans).anchoredPosition
  pos.x = totalWidth * percent / 100
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).rectTrans).anchoredPosition = pos
  ;
  ((self.ui).tex_Rate):SetIndex(0, tostring(percent))
  if percent <= progress // 100 then
    ((self.ui).obj_isPicked):SetActive(true)
  end
end

UINFlappyGiftItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINFlappyGiftItem

