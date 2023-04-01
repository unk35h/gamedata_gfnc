-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTaskUnlockItem = class("UINTaskUnlockItem", UIBaseNode)
local base = UIBaseNode
local cs_MessageCommon = CS.MessageCommon
UINTaskUnlockItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).taskUnlockItem, self, self.OnClickItem)
end

UINTaskUnlockItem.InitTaskUnlockItem = function(self, type, clickDes)
  -- function num : 0_1 , upvalues : _ENV
  self._clickDes = clickDes
  local cfg = (ConfigData.task_unlock_type)[type]
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).text).text = (LanguageUtil.GetLocaleText)(cfg.type)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).image).sprite = CRH:GetSprite(cfg.icon)
end

UINTaskUnlockItem.SetIsTaskUnlockPicked = function(self, isPicked)
  -- function num : 0_2
  ((self.ui).obj_isPicked):SetActive(isPicked)
end

UINTaskUnlockItem.OnClickItem = function(self)
  -- function num : 0_3 , upvalues : cs_MessageCommon, _ENV
  (cs_MessageCommon.ShowMessageTips)((LanguageUtil.GetLocaleText)(self._clickDes))
end

return UINTaskUnlockItem

