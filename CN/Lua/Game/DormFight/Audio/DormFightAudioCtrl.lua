-- params : ...
-- function num : 0 , upvalues : _ENV
local DormFightCtrlBase = require("Game.Fight.Ctrl.DormFightCtrlBase")
local DormFightAudioCtrl = class("DormFightAudioCtrl", DormFightCtrlBase)
DormFightAudioCtrl.InitDormFightAudioCtrl = function(self, pvpFightController, dormFightAudioData)
  -- function num : 0_0
  self.fighterControllers = {}
end

DormFightAudioCtrl.OnCreateFighter = function(self, fighterController)
  -- function num : 0_1
  if (self.fighterControllers)[fighterController] ~= nil then
    self:RemoveFighterListener(fighterController)
  end
  self:AddFighterListener(fighterController)
end

DormFightAudioCtrl.AddFighterListener = function(self, fighterController)
  -- function num : 0_2
end

DormFightAudioCtrl.OnDestroyFighter = function(self, fighterController)
  -- function num : 0_3
  if (self.fighterControllers)[fighterController] ~= nil then
    self:RemoveFighterListener(fighterController)
  end
end

DormFightAudioCtrl.RemoveFighterListener = function(self, fighterController)
  -- function num : 0_4
end

DormFightAudioCtrl.RemoveAllListeners = function(self)
  -- function num : 0_5
end

return DormFightAudioCtrl

