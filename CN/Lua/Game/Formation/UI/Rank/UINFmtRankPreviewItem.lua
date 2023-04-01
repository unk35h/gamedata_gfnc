-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtRankPreviewItem = class("UINFmtRankPreviewItem", UIBaseNode)
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINFmtRankPreviewItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.heroItem = UINHeroHeadItem:New()
  ;
  (self.heroItem):Init((self.ui).heroHeadItem)
end

UINFmtRankPreviewItem.InitFmtRankPreviewItem = function(self, index, passStat)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Rank).text = tostring(index)
  ;
  ((self.ui).tex_UseTimes):SetIndex(0, tostring(passStat.cnt))
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  if passStat.rate == 0 then
    ((self.ui).tex_Rate).text = "0%"
  else
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Rate).text = (string.format)("%.1f%%", (math.max)(passStat.rate / 100, 0.1))
  end
  local heroId = passStat.heroId
  local heroCfg = (ConfigData.hero_data)[heroId]
  if heroCfg == nil then
    error("hero cfg is null,id:" .. tostring(heroId))
    return 
  end
  -- DECOMPILER ERROR at PC54: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  ;
  (self.heroItem):InitHeroHeadItemWithId(heroId, nil)
end

return UINFmtRankPreviewItem

