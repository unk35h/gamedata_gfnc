-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UINChristmas22LimitTaskItem")
local UINSpring23LimitTaskItem = class("UINSpring23LimitTaskItem", base)
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINSpring23LimitTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Refresh, self, self.ClickRefresh)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ItemClick, self, self.ClickConfirm)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINSpring23LimitTaskItem.RefreshChristmas22LimitTaskItem = function(self)
  -- function num : 0_1 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fill).value = schedule / aim
  local isComplete = (self._taskData):CheckComplete()
  if isComplete then
    ((self.ui).tex_Progress):SetIndex(1)
    ;
    ((self.ui).state):SetIndex(0)
    ;
    ((self.ui).tex_State):SetIndex(0)
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).btn_ReceiveItem).color = (self.ui).color_canReceive
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = Color.white
    return 
  end
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
  local haveJump = (self._taskData):GetTaskJumpArg()
  if haveJump then
    ((self.ui).state):SetIndex(1)
    ;
    ((self.ui).tex_State):SetIndex(1)
    -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).btn_ReceiveItem).color = (self.ui).color_goto
    -- DECOMPILER ERROR at PC75: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = Color.white
  else
    ;
    ((self.ui).state):SetIndex(2)
    ;
    ((self.ui).tex_State):SetIndex(2)
    -- DECOMPILER ERROR at PC91: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).btn_ReceiveItem).color = (self.ui).color_uncomplete
    -- DECOMPILER ERROR at PC97: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = (self.ui).color_uncompleteText
  end
end

return UINSpring23LimitTaskItem

