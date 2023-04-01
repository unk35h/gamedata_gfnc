-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFormationRankPreview = class("UIFormationRankPreview", UIBaseWindow)
local base = UIBaseWindow
local UINFmtRankPreviewItem = require("Game.Formation.UI.Rank.UINFmtRankPreviewItem")
UIFormationRankPreview.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINFmtRankPreviewItem
  (UIUtil.SetTopStatus)(self, self.Delete, nil, nil, nil, true)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self._OnBtnClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Bg, self, self._OnBtnClose)
  self._rankItemPool = (UIItemPool.New)(UINFmtRankPreviewItem, (self.ui).rowItem, false)
end

UIFormationRankPreview.InitFmtRankPreview = function(self, heroPassStats)
  -- function num : 0_1 , upvalues : _ENV
  (self._rankItemPool):HideAll()
  for index,passStat in pairs(heroPassStats) do
    local rankItem = (self._rankItemPool):GetOne()
    rankItem:InitFmtRankPreviewItem(index, passStat)
  end
end

UIFormationRankPreview._OnBtnClose = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (UIUtil.OnClickBack)()
end

UIFormationRankPreview.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UIFormationRankPreview

