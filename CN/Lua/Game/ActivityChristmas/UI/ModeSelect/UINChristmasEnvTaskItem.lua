-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmasEnvTaskItem = class("UINChristmasEnvTaskItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINChristmasEnvTaskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self.OnClickReceive)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Goto, self, self.OnClickJump)
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
end

UINChristmasEnvTaskItem.InitChristmasEnvTaskItem = function(self, taskData, getCallback, gotoCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._getCallback = getCallback
  self._gotoCallback = gotoCallback
  self._taskData = taskData
  ;
  (self._itemPool):HideAll()
  local itemIds, itemNums = (self._taskData):GetTaskCfgRewards()
  for i,itemId in ipairs(itemIds) do
    local item = (self._itemPool):GetOne()
    local num = itemNums[i]
    local itemCfg = (ConfigData.item)[itemId]
    item:InitItemWithCount(itemCfg, num)
  end
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskIntro).text = (self._taskData):GetTaskFirstStepIntro()
  self:RefreshChristmasEnvTaskItem()
end

UINChristmasEnvTaskItem.RefreshChristmasEnvTaskItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local schedule, aim = (self._taskData):GetTaskProcess()
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).text = tostring(schedule) .. "/" .. tostring(aim)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Fill).fillAmount = schedule / aim
  if (self._taskData).isPicked then
    for i,v in ipairs((self._itemPool).listItem) do
      v:SetPickedUIActive(true)
    end
    ;
    ((self.ui).img_Buttom):SetIndex(2)
    ;
    ((self.ui).obj_Completed):SetActive(true)
    ;
    ((self.ui).obj_Unfinish):SetActive(false)
    ;
    (((self.ui).btn_Get).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Goto).gameObject):SetActive(false)
    -- DECOMPILER ERROR at PC63: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_TaskIntro).color = (self.ui).col_isFinish
    -- DECOMPILER ERROR at PC68: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Progress).color = (self.ui).col_isFinish
    return 
  end
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TaskIntro).color = Color.black
  -- DECOMPILER ERROR at PC79: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Progress).color = Color.black
  ;
  ((self.ui).obj_Completed):SetActive(false)
  if (self._taskData):CheckComplete() then
    ((self.ui).img_Buttom):SetIndex(1)
    ;
    (((self.ui).btn_Get).gameObject):SetActive(true)
    ;
    ((self.ui).obj_Unfinish):SetActive(false)
    ;
    (((self.ui).btn_Goto).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).btn_Get).gameObject):SetActive(false)
  ;
  ((self.ui).img_Buttom):SetIndex(0)
  local canJump = ((self._taskData).stcData).jump_id or 0 > 0
  ;
  ((self.ui).obj_Unfinish):SetActive(not canJump)
  ;
  (((self.ui).btn_Goto).gameObject):SetActive(canJump)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINChristmasEnvTaskItem.GetEnvTaskId = function(self)
  -- function num : 0_3
  return (self._taskData).id
end

UINChristmasEnvTaskItem.OnClickReceive = function(self)
  -- function num : 0_4
  if self._getCallback ~= nil then
    (self._getCallback)(self._taskData)
  end
end

UINChristmasEnvTaskItem.OnClickJump = function(self)
  -- function num : 0_5
  if self._gotoCallback ~= nil then
    (self._gotoCallback)(self._taskData)
  end
end

return UINChristmasEnvTaskItem

