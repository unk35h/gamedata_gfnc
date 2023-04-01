-- params : ...
-- function num : 0 , upvalues : _ENV
local LbIntrctActionData = class("LbIntrctActionData")
LbIntrctActionData.InitLbIntrctAction = function(self, actionCfg, entity, intrctFunc, eActIntrct)
  -- function num : 0_0
  self._actionCfg = actionCfg
  self._intrctEntity = entity
  self._intrctFunc = intrctFunc
  self._eActIntrct = eActIntrct
  self._intrctData = entity:GetLbIntrctEntData()
end

LbIntrctActionData.GetLbIntrctActionName = function(self)
  -- function num : 0_1 , upvalues : _ENV
  return (LanguageUtil.GetLocaleText)((self._actionCfg).obj_func_name)
end

LbIntrctActionData.GetLbIntrctActionIconName = function(self)
  -- function num : 0_2
  return (self._actionCfg).func_icon
end

LbIntrctActionData.GetLbIntrctActionSubName = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local func = ((self._eActIntrct).eSubNameFuncs)[(self._actionCfg).obj_func_id]
  if func then
    return func(self._intrctEntity, self._actionCfg)
  end
  return (LanguageUtil.GetLocaleText)((self._actionCfg).obj_func_subname)
end

LbIntrctActionData.GetLbIntrctActionId = function(self)
  -- function num : 0_4
  return (self._actionCfg).obj_func_id
end

LbIntrctActionData.IsShowLbIntrctActionBluedot = function(self)
  -- function num : 0_5
  local func = ((self._eActIntrct).eActIntrctActionShowBlueDotFunc)[(self._actionCfg).obj_func_id]
  if func then
    return func(self._intrctEntity, self._actionCfg)
  end
  return false
end

LbIntrctActionData.GetLbIntrctActionLockStateDes = function(self)
  -- function num : 0_6
  local func = ((self._eActIntrct).eActIntrctActionLockStateDesFunc)[(self._actionCfg).obj_func_id]
  if func then
    return func(self._intrctEntity, self._actionCfg)
  end
  return 0
end

LbIntrctActionData.IsLbIntrctEntiUnlock = function(self)
  -- function num : 0_7
  return (self._intrctData):IsLbIntrctUnlock()
end

LbIntrctActionData.InvokeLbIntrctActionUIInit = function(self, uiItem)
  -- function num : 0_8
  local func = ((self._eActIntrct).eActIntrctActionUIInitFunc)[(self._actionCfg).obj_func_id]
  if func == nil then
    return 
  end
  func(uiItem, self._intrctEntity, self._actionCfg)
end

LbIntrctActionData.InvokeLbIntrctAction = function(self)
  -- function num : 0_9
  if not self:IsLbIntrctEntiUnlock() then
    return 
  end
  if self._intrctFunc ~= nil then
    (self._intrctFunc)(self._intrctEntity)
  end
end

LbIntrctActionData.GetLbIntrctActionParams = function(self)
  -- function num : 0_10
  return (self._actionCfg).func_params
end

return LbIntrctActionData

