-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.Task.UINSpring23ActTaskNode")
local UINWinter23TermTask = class("UINWinter23TermTask", base)
local JumpManager = require("Game.Jump.JumpManager")
UINWinter23TermTask.BindWinter23TermTaskOperFunc = function(self, func)
  -- function num : 0_0
  self._operFunc = func
end

UINWinter23TermTask.InitChristmas22ActTaskNode = function(self, actTermTaskData, term)
  -- function num : 0_1 , upvalues : _ENV
  self._actTermTaskData = actTermTaskData
  self._term = term
  self._taskitemDic = {}
  self._taskIdDic = {}
  local onceTaskIds = (self._actTermTaskData):GetTermTaskIds(self._term)
  for _,taskId in pairs(onceTaskIds) do
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R9 in 'UnsetPending'

    (self._taskIdDic)[taskId] = true
  end
end

UINWinter23TermTask.OnClickGetAll = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self._actTermTaskData):ReqCommitTermAllTask(self._term, function()
    -- function num : 0_2_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
    if self._operFunc ~= nil then
      (self._operFunc)()
    end
  end
)
end

UINWinter23TermTask.__TaskClick = function(self, taskData)
  -- function num : 0_3 , upvalues : JumpManager, _ENV
  do
    if not taskData:CheckComplete() then
      local flag, jumpId, jumpArgs = taskData:GetTaskJumpArg()
      if flag then
        JumpManager:Jump(jumpId, nil, nil, jumpArgs)
      end
      return 
    end
    ;
    (self._actTermTaskData):ReqCommitTermOnceTask(taskData.id, function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
    if self._operFunc ~= nil then
      (self._operFunc)()
    end
  end
)
  end
end

return UINWinter23TermTask

