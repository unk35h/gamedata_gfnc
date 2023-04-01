-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local ActivityFramePreviewFunc = {[(ActivityFrameEnum.eActivityType).HeroGrow] = function(activityFrameData)
  -- function num : 0_0 , upvalues : _ENV
  local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
  heroGrowCtrl:InitHeroGrowByAct(activityFrameData)
end
}
return ActivityFramePreviewFunc

