-- params : ...
-- function num : 0 , upvalues : _ENV
local ChipEnum = require("Game.PlayerData.Item.ChipEnum")
local DynSpecEffectMgr = class("DynSpecEffectMgr")
local GetChipCounterTab = function()
  -- function num : 0_0 , upvalues : _ENV
  local map = {count = 0}
  local c = (ConfigData.game_config).heroMaxCareer
  for i = 1, c do
    map[i] = 0
  end
  return map
end

local LogicAddFunc = {[proto_object_EffectType.EffectType_CareerChange] = function(self, effect)
  -- function num : 0_1 , upvalues : GetChipCounterTab
  local dic = (self._chipActiveCareer)[effect.value2]
  if dic == nil then
    dic = GetChipCounterTab()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._chipActiveCareer)[effect.value2] = dic
  end
  dic[effect.value1] = dic[effect.value1] + 1
  dic.count = dic.count + 1
end
, [proto_object_EffectType.EffectType_OnlyCareerChange] = function(self, effect)
  -- function num : 0_2 , upvalues : GetChipCounterTab, _ENV
  local dic = (self._chipActiveCareer)[effect.value2]
  if dic == nil then
    dic = GetChipCounterTab()
    -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._chipActiveCareer)[effect.value2] = dic
  end
  dic[effect.value1] = dic[effect.value1] + 1
  dic.count = dic.count + 1
  local list = (self._chipOnlyCareer)[effect.value1]
  if list == nil then
    list = {}
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._chipOnlyCareer)[effect.value1] = list
  end
  ;
  (table.insert)(list, 1, effect.value2)
  if #list > 1 then
    error("add effect OnlyCareerChang exceed 1,new effect Id:" .. tostring(effect.effectId))
    ;
    (table.sort)(list)
  end
end
}
local LogicRemoveFunc = {[proto_object_EffectType.EffectType_CareerChange] = function(self, effect)
  -- function num : 0_3
  local dic = (self._chipActiveCareer)[effect.value2]
  if dic == nil then
    return 
  end
  dic[effect.value1] = dic[effect.value1] - 1
  dic.count = dic.count - 1
end
, [proto_object_EffectType.EffectType_OnlyCareerChange] = function(self, effect)
  -- function num : 0_4 , upvalues : _ENV
  local dic = (self._chipActiveCareer)[effect.value2]
  if dic == nil then
    return 
  end
  dic[effect.value1] = dic[effect.value1] - 1
  dic.count = dic.count - 1
  local list = (self._chipOnlyCareer)[effect.value1]
  if list ~= nil then
    (table.removebyvalue)(list, effect.value2, false)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

    if #list <= 0 then
      (self._chipOnlyCareer)[effect.value1] = nil
    end
  end
end
}
local chipInfluenceFunc = {}
DynSpecEffectMgr.ctor = function(self)
  -- function num : 0_5
  self._effets = {}
  self._count = 0
  self._chipActiveCareer = {}
  self._chipOnlyCareer = {}
end

DynSpecEffectMgr.InitSpecEffect = function(self, effect)
  -- function num : 0_6 , upvalues : _ENV, LogicAddFunc
  if effect == nil then
    return 
  end
  for id,effect in pairs(effect.effects) do
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R7 in 'UnsetPending'

    (self._effets)[id] = effect
    self._count = self._count + 1
    ;
    (LogicAddFunc[effect.effectType])(self, effect)
  end
end

DynSpecEffectMgr.UpdateSpecEffectDiff = function(self, diff)
  -- function num : 0_7 , upvalues : _ENV, LogicRemoveFunc, LogicAddFunc
  if diff == nil then
    return 
  end
  for _,id in pairs(diff.removed) do
    local effect = (self._effets)[id]
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R8 in 'UnsetPending'

    if effect ~= nil then
      (self._effets)[id] = nil
      self._count = self._count - 1
      ;
      (LogicRemoveFunc[effect.effectType])(self, effect)
    end
  end
  for id,effect in pairs(diff.added) do
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R7 in 'UnsetPending'

    if (self._effets)[id] == nil then
      (self._effets)[id] = effect
      self._count = self._count + 1
      ;
      (LogicAddFunc[effect.effectType])(self, effect)
    end
  end
end

DynSpecEffectMgr.HasSpecEffectCount = function(self)
  -- function num : 0_8
  do return self._count > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

DynSpecEffectMgr.ModifyChipValidRole = function(self, roleList, validRoleDic, influenceType, influenceArg)
  -- function num : 0_9 , upvalues : chipInfluenceFunc
  local func = chipInfluenceFunc[influenceType]
  if func ~= nil then
    func(self, roleList, validRoleDic, influenceArg)
    return true
  end
  return false
end

DynSpecEffectMgr._ChipCareerInfluence = function(self, roleList, validRoleDic, influenceArg)
  -- function num : 0_10 , upvalues : _ENV
  local activeDic = (self._chipActiveCareer)[influenceArg]
  for k,role in ipairs(roleList) do
    local career = role:GetCareer()
    local careerTrans = (self._chipOnlyCareer)[career]
    -- DECOMPILER ERROR at PC15: Unhandled construct in 'MakeBoolean' P1

    if careerTrans ~= nil and careerTrans[1] == influenceArg then
      validRoleDic[role] = true
    end
    if career == influenceArg or activeDic ~= nil and activeDic[career] > 0 then
      validRoleDic[role] = true
    end
  end
end

chipInfluenceFunc[(ChipEnum.eChipInfluenceType).Career] = DynSpecEffectMgr._ChipCareerInfluence
return DynSpecEffectMgr

