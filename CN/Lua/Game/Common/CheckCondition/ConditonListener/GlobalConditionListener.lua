-- params : ...
-- function num : 0 , upvalues : _ENV
local GlobalConditionListener = class("GlobalConditionListener")
local ConditionListener = require("Game.Common.CheckCondition.ConditonListener.ConditionListener")
GlobalConditionListener.ctor = function(self)
  -- function num : 0_0 , upvalues : ConditionListener
  self.__ConditionListener = (ConditionListener.New)()
end

GlobalConditionListener.GetConditionListener = function(self)
  -- function num : 0_1
  return self.__ConditionListener
end

GlobalConditionListener.AddConditionChangeListener = function(self, listenerId, callback, ...)
  -- function num : 0_2
  (self.__ConditionListener):AddConditionChangeListener(listenerId, callback, ...)
end

GlobalConditionListener.RemoveConditionChangeListener = function(self, listenerId)
  -- function num : 0_3
  (self.__ConditionListener):RemoveConditionChangeListener(listenerId)
end

GlobalConditionListener.Delete = function(self)
  -- function num : 0_4
  (self.__ConditionListener):Delete()
end

return GlobalConditionListener

