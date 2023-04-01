-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechSpeicalSide")
local UINSpring23TechSpeicalSide = class("UINSpring23TechSpeicalSide", base)
UINSpring23TechSpeicalSide.RefreshTechSpeicalSideInfoNode = function(self)
  -- function num : 0_0 , upvalues : base
  (base.RefreshTechSpeicalSideInfoNode)(self)
  if self._curTechData == nil then
    return 
  end
  local isUnlockAndLvUp = (self._curTechData):GetCurLevel() > 0
  ;
  ((self.ui).tex_lvup):SetIndex(isUnlockAndLvUp and 1 or 0)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

return UINSpring23TechSpeicalSide

