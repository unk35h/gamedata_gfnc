-- params : ...
-- function num : 0 , upvalues : _ENV
local PersistentDataBase = class("PersistenDataBase")
PersistentDataBase.InitBySaveData = function(self, data)
  -- function num : 0_0
end

PersistentDataBase.InitByDefaultData = function(self)
  -- function num : 0_1
end

PersistentDataBase.GetSaveEncodeTable = function(self)
  -- function num : 0_2
  return self
end

PersistentDataBase.GetSaveDataFilePath = function(self)
  -- function num : 0_3
  return ""
end

PersistentDataBase.SetPstDataDirty = function(self)
  -- function num : 0_4
  self.isDirty = true
end

PersistentDataBase.IsPstDataDirty = function(self)
  -- function num : 0_5
  return self.isDirty
end

PersistentDataBase.ResetPstDataDirty = function(self)
  -- function num : 0_6
  self.isDirty = false
end

PersistentDataBase.AutoSaveSingletonPst = function(self)
  -- function num : 0_7 , upvalues : _ENV
  PersistentManager:SaveModelData(self.__packageId)
  self.__delayTimerId = nil
end

PersistentDataBase.DelaySavePstData = function(self, delay)
  -- function num : 0_8 , upvalues : _ENV
  if self.__delayTimerId ~= nil then
    return 
  end
  self.__delayTimerId = TimerManager:StartTimer(delay, self.AutoSaveSingletonPst, self, true, false, true)
end

PersistentDataBase.OnLogoutDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV
  TimerManager:StopTimer(self.__delayTimerId)
end

return PersistentDataBase

