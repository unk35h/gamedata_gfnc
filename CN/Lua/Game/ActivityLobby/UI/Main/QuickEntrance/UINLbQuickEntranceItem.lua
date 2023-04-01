-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINLbQuickEntranceItem = class("UINLbQuickEntranceItem", base)
UINLbQuickEntranceItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Jump, self, self._OnClickJump)
end

UINLbQuickEntranceItem.InitLbQuickEntranceItem = function(self, actionData)
  -- function num : 0_1
  self._actionData = actionData
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_TitlleName).text = actionData:GetLbIntrctActionName()
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = actionData:GetLbIntrctActionSubName()
  self:UpdLbQuickEntranceItemLock()
  self:UpdLbQuickEntranceItemBlueDot()
end

UINLbQuickEntranceItem.UpdLbQuickEntranceItemLock = function(self)
  -- function num : 0_2
  local isUnlock = (self._actionData):IsLbIntrctEntiUnlock()
  ;
  ((self.ui).obj_Lock):SetActive(not isUnlock)
  if not isUnlock then
    ((self.ui).tex_Lock):SetIndex((self._actionData):GetLbIntrctActionLockStateDes())
  end
end

UINLbQuickEntranceItem.UpdLbQuickEntranceItemBlueDot = function(self)
  -- function num : 0_3
  ((self.ui).blueDot):SetActive((self._actionData):IsShowLbIntrctActionBluedot())
end

UINLbQuickEntranceItem._OnClickJump = function(self)
  -- function num : 0_4
  if self._actionData ~= nil then
    (self._actionData):InvokeLbIntrctAction()
  end
end

UINLbQuickEntranceItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINLbQuickEntranceItem

