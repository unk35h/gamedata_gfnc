-- params : ...
-- function num : 0 , upvalues : _ENV
local UIRecommeFormationSeason = class("UIRecommeFormationSeason", UIBaseWindow)
local base = UIBaseWindow
local UINRecommeTeamItem = require("Game.CommonUI.Rank.UINRecommeTeamItem")
UIRecommeFormationSeason.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINRecommeTeamItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_close, self, self.OnClickClose)
  self.recommeTeamItemPool = (UIItemPool.New)(UINRecommeTeamItem, (self.ui).obj_recommeTeamItem)
  ;
  ((self.ui).obj_recommeTeamItem):SetActive(false)
end

UIRecommeFormationSeason.RefreshTeamItem = function(self, teamHeroList)
  -- function num : 0_1 , upvalues : _ENV
  (self.recommeTeamItemPool):HideAll()
  for k,v in pairs(teamHeroList) do
    local item = (self.recommeTeamItemPool):GetOne(true)
    item:RefreshRecommeTeamItem(v, k)
  end
  if #teamHeroList == 1 then
    local item = (self.recommeTeamItemPool):GetOne(true)
    item:RefreshRecommeTeamItem(nil, 2)
  end
end

UIRecommeFormationSeason.SetShowPosition = function(self, transform, downTransform)
  -- function num : 0_2 , upvalues : _ENV
  local positionX, positionY = UIManager:World2UIPositionOut(transform, ((self.ui).frame).parent, UIManager.UICamera, UIManager.UICamera)
  local downPositionX, downPositionY = UIManager:World2UIPositionOut(downTransform, ((self.ui).frame).parent, UIManager.UICamera, UIManager.UICamera)
  local downY = positionY - (((self.ui).frame).sizeDelta).y
  if downY < downPositionY then
    positionY = positionY - (downY - downPositionY)
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).frame).anchoredPosition = (Vector2.Temp)(positionX, positionY)
end

UIRecommeFormationSeason.OnClickClose = function(self)
  -- function num : 0_3
  (self.recommeTeamItemPool):DeleteAll()
  self:Delete()
end

return UIRecommeFormationSeason

