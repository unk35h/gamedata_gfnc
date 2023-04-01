-- params : ...
-- function num : 0 , upvalues : _ENV
local AllAdjCustomData = class("AllAdjCustomData")
local AdjCustomPresetData = require("Game.AdjCustom.AdjCustomPresetData")
AllAdjCustomData.ctor = function(self)
  -- function num : 0_0
  self._dataDic = nil
  self._selectId = nil
end

AllAdjCustomData.InitAdjCustonData = function(self, msg)
  -- function num : 0_1 , upvalues : _ENV
  self._dataDic = {}
  self._selectId = msg.curPresetId
  for _,singleMsg in ipairs(msg.mainPresets) do
    self:SetAdjPresetData(singleMsg)
  end
end

AllAdjCustomData.GetUsingAdjCustomPresetId = function(self)
  -- function num : 0_2
  return self._selectId
end

AllAdjCustomData.GetUsingCustomPreset = function(self)
  -- function num : 0_3
  return (self._dataDic)[self._selectId]
end

AllAdjCustomData.SetUsingAdjCustomPresetId = function(self, id)
  -- function num : 0_4
  self._selectId = id
end

AllAdjCustomData.GetAdjCustomPresetData = function(self, id)
  -- function num : 0_5
  return (self._dataDic)[id]
end

AllAdjCustomData.SetAdjPresetData = function(self, data)
  -- function num : 0_6 , upvalues : _ENV, AdjCustomPresetData
  local id = data.id
  if (ConfigData.game_config).adjCustomTeamMax < id then
    return 
  end
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R3 in 'UnsetPending'

  if (self._dataDic)[id] == nil then
    (self._dataDic)[id] = (AdjCustomPresetData.New)()
    ;
    ((self._dataDic)[id]):InitPresetData(id)
  end
  ;
  ((self._dataDic)[id]):UpdatePresetMsg(data)
end

AllAdjCustomData.SetAdjPresetName = function(self, id, name)
  -- function num : 0_7
  if (self._dataDic)[id] == nil then
    return 
  end
  ;
  ((self._dataDic)[id]):SetAdjPresetName(name)
end

AllAdjCustomData.DelAdjPreset = function(self, id)
  -- function num : 0_8
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._dataDic)[id] = nil
end

AllAdjCustomData.IsAdjPresetUnlock = function(self, id)
  -- function num : 0_9 , upvalues : _ENV
  if (ConfigData.game_config).adjCustomTeamMax < id then
    return false
  end
  local cfg = (ConfigData.main_interface)[id]
  if cfg == nil then
    return false
  end
  return (CheckCondition.CheckLua)(cfg.pre_condition, cfg.pre_para1, cfg.pre_para2)
end

AllAdjCustomData.HasAdjPresetCount = function(self)
  -- function num : 0_10 , upvalues : _ENV
  return (table.count)(self._dataDic)
end

return AllAdjCustomData

