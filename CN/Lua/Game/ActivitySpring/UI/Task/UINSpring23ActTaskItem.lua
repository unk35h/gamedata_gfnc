-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UINChristmas22ActTaskItem")
local UINSpring23ActTaskItem = class("UINSpring23ActTaskItem", base)
UINSpring23ActTaskItem.__RefreshFill = function(self)
  -- function num : 0_0 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).bar).value = schedule / aim
  ;
  ((self.ui).tex_Progress):SetIndex(0, tostring(schedule), tostring(aim))
end

UINSpring23ActTaskItem.__RefreshPickConfirmBtn = function(self)
  -- function num : 0_1
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).btn_Receive).color = (self.ui).color_uncomplete
  ;
  (((self.ui).img_state).gameObject):SetActive(false)
  ;
  ((self.ui).tex_State):SetIndex(3)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).tex_State).text).color = (self.ui).color_uncompleteText
  ;
  ((self.ui).state):SetActive(false)
end

UINSpring23ActTaskItem.__RefreshConfirmBtn = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).state):SetActive(true)
  local isComplete = (self._taskData):CheckComplete()
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R2 in 'UnsetPending'

  if isComplete then
    ((self.ui).btn_Receive).color = (self.ui).color_canReceive
    ;
    ((self.ui).img_state):SetIndex(0)
    ;
    ((self.ui).tex_State):SetIndex(0)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = Color.white
    return 
  end
  local isGoto = (self._taskData):GetTaskJumpArg()
  -- DECOMPILER ERROR at PC41: Confused about usage of register: R3 in 'UnsetPending'

  if isGoto then
    ((self.ui).btn_Receive).color = (self.ui).color_goto
    ;
    ((self.ui).img_state):SetIndex(1)
    ;
    ((self.ui).tex_State):SetIndex(1)
    -- DECOMPILER ERROR at PC57: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = Color.white
  else
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).btn_Receive).color = (self.ui).color_uncomplete
    ;
    ((self.ui).img_state):SetIndex(2)
    ;
    ((self.ui).tex_State):SetIndex(2)
    -- DECOMPILER ERROR at PC79: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_State).text).color = (self.ui).color_uncompleteText
  end
end

return UINSpring23ActTaskItem

