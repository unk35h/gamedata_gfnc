-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySpring.UI.StoryReview.UINSpring23StoryBaseItem")
local UINSpring23StoryCharItem = class("UINSpring23StoryCharItem", base)
UINSpring23StoryCharItem.__InitUI = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.__InitUI)(self)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Stage).text = (LanguageUtil.GetLocaleText)((self._interactInfoCfg).index)
end

return UINSpring23StoryCharItem

