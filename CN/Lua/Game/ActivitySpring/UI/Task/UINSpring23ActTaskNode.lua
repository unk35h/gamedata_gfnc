-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Task.UINChristmas22ActTaskNode")
local UINSpring23ActTaskNode = class("UINSpring23ActTaskNode", base)
local UINSpring23ActTaskItem = require("Game.ActivitySpring.UI.Task.UINSpring23ActTaskItem")
local JumpManager = require("Game.Jump.JumpManager")
UINSpring23ActTaskNode.InitChristmas22ActTaskNode = function(self, springData)
  -- function num : 0_0 , upvalues : _ENV
  self._springData = springData
  self._taskitemDic = {}
  self._taskIdDic = {}
  local onceTaskIds = (self._springData):GetSpringOnceTskIds()
  for _,taskId in pairs(onceTaskIds) do
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R8 in 'UnsetPending'

    (self._taskIdDic)[taskId] = true
  end
end

UINSpring23ActTaskNode.__OnInstantiateItem = function(self, go)
  -- function num : 0_1 , upvalues : UINSpring23ActTaskItem
  local item = (UINSpring23ActTaskItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._goItem)[go] = item
end

UINSpring23ActTaskNode.__RefreshGetAllBtn = function(self, getAllActive)
  -- function num : 0_2 , upvalues : _ENV
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  if not getAllActive or not (self.ui).color_btnActive then
    ((self.ui).img_GetAll).color = (self.ui).color_btnDisActive
    -- DECOMPILER ERROR at PC21: Confused about usage of register: R2 in 'UnsetPending'

    if not getAllActive or not Color.white then
      ((self.ui).tex_GetAll).color = (self.ui).color_texDisActive
      -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).btn_GetAll).interactable = getAllActive
    end
  end
end

UINSpring23ActTaskNode.OnClickGetAll = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self._springData):ReqSpringAllOnceTask(function()
    -- function num : 0_3_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
  end
)
end

UINSpring23ActTaskNode.__TaskClick = function(self, taskData)
  -- function num : 0_4 , upvalues : JumpManager, _ENV
  do
    if not taskData:CheckComplete() then
      local flag, jumpId, jumpArgs = taskData:GetTaskJumpArg()
      if flag then
        JumpManager:Jump(jumpId, nil, nil, jumpArgs)
      end
      return 
    end
    ;
    (self._springData):ReqSpringOnceTask(taskData.id, function()
    -- function num : 0_4_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:RefillChristmas22ActTaskNode()
    end
  end
)
  end
end

return UINSpring23ActTaskNode

