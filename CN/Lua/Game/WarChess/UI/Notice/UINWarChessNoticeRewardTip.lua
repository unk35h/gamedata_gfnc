-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessNoticeRewardTip = class("UINWarChessNoticeRewardTip", base)
UINWarChessNoticeRewardTip.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessNoticeRewardTip.RefreshWCRewardNotice = function(self, itemId, curNum, addNum, isLimitFull)
  -- function num : 0_1 , upvalues : _ENV
  local itemCfg = (ConfigData.item)[itemId]
  if itemCfg == nil then
    error("can\'t get item with id:" .. tostring(itemId))
    return 
  end
  local resName = itemCfg.icon
  local itemName = (LanguageUtil.GetLocaleText)(itemCfg.name)
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(resName)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = itemName
  if curNum ~= nil then
    (((self.ui).tex_Current).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).tex_Current).text = tostring(curNum - addNum)
  else
    ;
    (((self.ui).tex_Current).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR at PC56: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Plus).text = "+" .. tostring(addNum)
  ;
  (((self.ui).tex_limit).gameObject):SetActive(isLimitFull)
end

return UINWarChessNoticeRewardTip

