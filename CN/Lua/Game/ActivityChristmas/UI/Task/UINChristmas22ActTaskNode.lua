-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22ActTaskNode = class("UINChristmas22ActTaskNode", UIBaseNode)
local base = UIBaseNode
local UINChristmas22ActTaskItem = require("Game.ActivityChristmas.UI.Task.UINChristmas22ActTaskItem")
UINChristmas22ActTaskNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetAll, self, self.OnClickGetAll)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).taskList).onInstantiateItem = BindCallback(self, self.__OnInstantiateItem)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).taskList).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self.__TaskClickCallback = BindCallback(self, self.__TaskClick)
  self._goItem = {}
end

UINChristmas22ActTaskNode.InitChristmas22ActTaskNode = function(self, hallowmasData)
  -- function num : 0_1 , upvalues : _ENV
  self._hallowmasData = hallowmasData
  self._taskitemDic = {}
  self._taskIdDic = {}
  local achieveCfg = (self._hallowmasData):GetHallowmasAchievementCfg()
  for taskId,_ in pairs(achieveCfg) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R8 in 'UnsetPending'

    (self._taskIdDic)[taskId] = true
  end
end

UINChristmas22ActTaskNode.RefillChristmas22ActTaskNode = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local taskDataList = {}
  local getAllActive = false
  for taskId,_ in pairs(self._taskIdDic) do
    local taskData = (PlayerDataCenter.allTaskData):GetTaskDataById(taskId, true)
    ;
    (table.insert)(taskDataList, taskData)
    if not getAllActive and taskData:CheckComplete() then
      getAllActive = true
    end
  end
  ;
  (table.sort)(taskDataList, function(a, b)
    -- function num : 0_2_0
    if a.isPicked ~= b.isPicked then
      return not a.isPicked
    end
    local aComplete = a:CheckComplete()
    if aComplete ~= b:CheckComplete() then
      return aComplete
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self._taskDataList = taskDataList
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).taskList).totalCount = #self._taskDataList
  ;
  ((self.ui).taskList):RefillCells()
  self:__RefreshGetAllBtn(getAllActive)
end

UINChristmas22ActTaskNode.__RefreshGetAllBtn = function(self, getAllActive)
  -- function num : 0_3
  (((self.ui).btn_GetAll).gameObject):SetActive(getAllActive)
end

UINChristmas22ActTaskNode.__OnInstantiateItem = function(self, go)
  -- function num : 0_4 , upvalues : UINChristmas22ActTaskItem
  local item = (UINChristmas22ActTaskItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._goItem)[go] = item
end

UINChristmas22ActTaskNode.__OnChangeItem = function(self, go, index)
  -- function num : 0_5
  local item = (self._goItem)[go]
  local taskData = (self._taskDataList)[index + 1]
  item:InitChristmas22ActTaskItem(taskData, self.__TaskClickCallback)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._taskitemDic)[taskData.id] = item
end

UINChristmas22ActTaskNode.RefreshChristmas22ActTaskChange = function(self, taskData)
  -- function num : 0_6
  local item = (self._taskitemDic)[taskData.id]
  if item ~= nil and item:GetChristmasActTaskId() == taskData.id then
    if taskData:CheckComplete() then
      self:RefillChristmas22ActTaskNode()
    else
      item:RefreshChristmas22ActTaskItem()
    end
    if taskData:CheckComplete() then
      (((self.ui).btn_GetAll).gameObject):SetActive(true)
    end
  end
end

UINChristmas22ActTaskNode.OnClickGetAll = function(self)
  -- function num : 0_7 , upvalues : _ENV
  (self._hallowmasData):ReqHallowmasAllChievement(function()
    -- function num : 0_7_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
  end
)
end

UINChristmas22ActTaskNode.__TaskClick = function(self, taskData)
  -- function num : 0_8 , upvalues : _ENV
  (self._hallowmasData):ReqHallowmasCommitTask(taskData.id, function()
    -- function num : 0_8_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
  end
)
end

return UINChristmas22ActTaskNode

