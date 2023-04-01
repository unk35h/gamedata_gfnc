-- params : ...
-- function num : 0 , upvalues : _ENV
local ExplorationSceneCtrl = require("Game.Exploration.Ctrl.ExplorationSceneCtrl")
local ExplorationTDSceneCtrl = class("ExplorationTDSceneCtrl", ExplorationSceneCtrl)
local CS_RenderMgr = (CS.RenderManager).Instance
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
ExplorationTDSceneCtrl.ctor = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.__onStartTimelineCompleteGeneral = BindCallback(self, self.OnStartTimelineCompleteGeneral, true)
end

ExplorationTDSceneCtrl.__PlaySceneStartTimeline = function(self)
  -- function num : 0_1 , upvalues : ExplorationEnum, _ENV
  self.loadRoleComplete = true
  self.showEpUIComplete = true
  ;
  (self.epSceneEntity):OnSceneLoadedPlay(self.__onStartTimelineCompleteGeneral)
  self:ChangeEpSceneState((ExplorationEnum.eEpSceneState).InTimeline)
  self:ShowSkipWindow(false)
  self:SetEpMapCameraCullMask(LayerMask.UI3D)
end

ExplorationTDSceneCtrl.OnPlayerMoveComplete = function(self, roomData)
  -- function num : 0_2
end

ExplorationTDSceneCtrl.SetTDInBattleScene = function(self, flag)
  -- function num : 0_3
  self.inBattleScene = flag
end

ExplorationTDSceneCtrl.InBattleScene = function(self)
  -- function num : 0_4
  return self.inBattleScene
end

return ExplorationTDSceneCtrl

