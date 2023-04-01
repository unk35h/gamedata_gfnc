-- params : ...
-- function num : 0 , upvalues : _ENV
local LbInteractData = class("LbInteractData")
local LbIntrctActionData = require("Game.ActivityLobby.Data.LbIntrctActionData")
LbInteractData.ctor = function(self, interactObjCfg, eActIntrct)
  -- function num : 0_0
  self._interactObjCfg = interactObjCfg
  self._eActIntrct = eActIntrct
end

LbInteractData.GetLbIntrctObjType = function(self)
  -- function num : 0_1
  return (self._interactObjCfg).obj_type
end

LbInteractData.GetLbIntrctObjPath = function(self)
  -- function num : 0_2
  return (self._interactObjCfg).obj_path
end

LbInteractData.GetLbIntrctObjFxPath = function(self)
  -- function num : 0_3
  return (self._interactObjCfg).obj_fx_path
end

LbInteractData.GetLbIntrctObjActionIdList = function(self)
  -- function num : 0_4
  return (self._interactObjCfg).obj_func
end

LbInteractData.SetLbIntrctObjActions = function(self, actionList)
  -- function num : 0_5
  self._actionList = actionList
end

LbInteractData.GetLbIntrctObjActions = function(self)
  -- function num : 0_6
  return self._actionList
end

LbInteractData.GetLbIntrctObjActionFirst = function(self)
  -- function num : 0_7
  return (self._actionList)[1]
end

LbInteractData.GetLbIntrctObjHeroId = function(self)
  -- function num : 0_8
  return (self._interactObjCfg).hero_id
end

LbInteractData.IsLbIntrctObjShowQuickEntrance = function(self)
  -- function num : 0_9
  return (self._interactObjCfg).is_quick
end

LbInteractData.GetLbIntrctObjId = function(self)
  -- function num : 0_10
  return (self._interactObjCfg).obj_id
end

LbInteractData.IsLbIntrctUnlock = function(self)
  -- function num : 0_11
  local checkUnlockFunc = ((self._eActIntrct).eUnlockIntrctFunc)[(self._interactObjCfg).obj_id]
  if checkUnlockFunc == nil then
    return true
  end
  return checkUnlockFunc(self)
end

LbInteractData.IsLbActIntrctObjHideHeadUI = function(self)
  -- function num : 0_12
  return (self._interactObjCfg).hide_head_ui
end

return LbInteractData

