-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenAchievementItem = class("UINHalloweenAchievementItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINHalloweenAchievementItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).obj_Get, self, self.OnClickComplete)
  self._starList = {(self.ui).starItem}
  self._itemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItemWithReceived)
  ;
  ((self.ui).uINBaseItemWithReceived):SetActive(false)
end

UINHalloweenAchievementItem.InitAchieventItem = function(self, taskData, star, callback)
  -- function num : 0_1
  self._task = taskData
  self._callback = callback
  self:__RefreshFixed(star)
  self:RefreshTaskUI()
end

UINHalloweenAchievementItem.__RefreshFixed = function(self, star)
  -- function num : 0_2 , upvalues : _ENV
  local count = #self._starList
  for i = 1, count do
    local starItem = (self._starList)[i]
    starItem:SetActive(i <= star)
  end
  for i = count + 1, star do
    local starItem = ((self.ui).starItem):Instantiate()
    ;
    (table.insert)(self._starList, starItem)
    starItem:SetActive(true)
  end
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleName).text = (self._task):GetTaskName()
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (self._task):GetTaskFirstStepIntro()
  ;
  (self._itemPool):HideAll()
  local ids, nums = (self._task):GetTaskCfgRewards()
  for i,id in ipairs(ids) do
    local num = nums[i]
    local itemCfg = (ConfigData.item)[id]
    local item = (self._itemPool):GetOne()
    item:InitItemWithCount(itemCfg, num, nil, (self._task).isPicked)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINHalloweenAchievementItem.RefreshTaskUI = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if (self._task).isPicked then
    ((self.ui).obj_Progress):SetActive(false)
    ;
    (((self.ui).obj_Get).gameObject):SetActive(false)
    ;
    ((self.ui).obj_Completed):SetActive(true)
  else
    if (self._task):CheckComplete() then
      ((self.ui).obj_Progress):SetActive(false)
      ;
      ((self.ui).obj_Completed):SetActive(false)
      ;
      (((self.ui).obj_Get).gameObject):SetActive(true)
    else
      ;
      ((self.ui).obj_Completed):SetActive(false)
      ;
      (((self.ui).obj_Get).gameObject):SetActive(false)
      ;
      ((self.ui).obj_Progress):SetActive(true)
      local aim, schedule = (self._task):GetTaskProcess()
      ;
      ((self.ui).tex_Progress):SetIndex(0, tostring(aim), tostring(schedule))
      -- DECOMPILER ERROR at PC76: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).slider).value = aim / schedule
    end
  end
end

UINHalloweenAchievementItem.GetHallowAchieveTask = function(self)
  -- function num : 0_4
  return self._task
end

UINHalloweenAchievementItem.OnClickComplete = function(self)
  -- function num : 0_5
  if self._callback ~= nil then
    (self._callback)(self._task)
  end
end

return UINHalloweenAchievementItem

