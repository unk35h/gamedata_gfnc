-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWCSRecommeFormationWindow = class("UIWCSRecommeFormationWindow", UIBaseWindow)
local base = UIBaseWindow
local UINWCSRecommeFormationItem = require("Game.WarChessSeason.UI.WCSRecommend.UINWCSRecommeFormationItem")
local UINHeroHeadWithStarItem = require("Game.CommonUI.Hero.UINHeroHeadWithStarItem")
local UINCommanderSkill = require("Game.Formation.UI.2DFormation.UINCommanderSkill")
local HeroData = require("Game.PlayerData.Hero.HeroData")
UIWCSRecommeFormationWindow.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWCSRecommeFormationItem, UINHeroHeadWithStarItem, UINCommanderSkill
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  self.resloader = ((CS.ResLoader).Create)()
  self.__GetHeroHeadCallback = BindCallback(self, self.GetHeroHead)
  self.__GetCommanderSkillCallback = BindCallback(self, self.GetCommanderSkill)
  self.formationItemPool = (UIItemPool.New)(UINWCSRecommeFormationItem, (self.ui).recommeTeamItem)
  ;
  (((self.ui).recommeTeamItem).gameObject):SetActive(false)
  self.heroHeadItemPool = (UIItemPool.New)(UINHeroHeadWithStarItem, (self.ui).obj_HeroHead)
  ;
  (((self.ui).obj_HeroHead).gameObject):SetActive(false)
  self.skillItemPool = (UIItemPool.New)(UINCommanderSkill, (self.ui).obj_SkillItem)
  ;
  (((self.ui).obj_SkillItem).gameObject):SetActive(false)
  ;
  ((self.ui).obj_EmptyHero):SetActive(false)
  self.emptyHeroHeadItemList = {}
  self.emptyHeroHeadItemListIndex = 1
end

UIWCSRecommeFormationWindow.InitWCSRecommendTeamAndSkill = function(self, recommendTeamList, recommendSkillDataList)
  -- function num : 0_1 , upvalues : _ENV
  if not self.settedTopStatus then
    (UIUtil.SetTopStatus)(self, self.BackAction, nil, nil, nil, true)
    self.settedTopStatus = true
  end
  self._recommendTeamList = recommendTeamList
  self._recommendSkillDataList = recommendSkillDataList
  ;
  (self.formationItemPool):HideAll()
  ;
  (self.heroHeadItemPool):HideAll()
  ;
  (self.skillItemPool):HideAll()
  for i = 1, #self.emptyHeroHeadItemList do
    ((self.emptyHeroHeadItemList)[i]):SetActive(false)
  end
  self.emptyHeroHeadItemListIndex = 1
  self:InitRecommendTeamShow()
end

UIWCSRecommeFormationWindow.GetHeroHead = function(self, heroId, parentTr)
  -- function num : 0_2
  if heroId ~= nil then
    self:_GetOneHeroHead(heroId, parentTr)
  else
    self:_GetOneEmptyHeroHead(parentTr)
  end
end

UIWCSRecommeFormationWindow._GetOneHeroHead = function(self, heroId, parentTr)
  -- function num : 0_3 , upvalues : _ENV, HeroData
  local headItem = (self.heroHeadItemPool):GetOne()
  local heroInfo = (PlayerDataCenter.heroDic)[heroId]
  local isHas = heroInfo ~= nil
  do
    if not isHas then
      local heroCfg = (ConfigData.hero_data)[heroId]
      heroInfo = (HeroData.New)({
basic = {id = heroCfg.id, level = 1, exp = 0, star = heroCfg.rank, potentialLvl = 0, ts = -1, career = heroCfg.career, company = heroCfg.camp}
})
      heroInfo.heroCfg = heroCfg
    end
    headItem:InitHead(heroInfo, isHas)
    ;
    ((headItem.gameObject).transform):SetParent(parentTr)
    ;
    ((headItem.gameObject).transform):SetAsLastSibling()
    do return headItem end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIWCSRecommeFormationWindow._GetOneEmptyHeroHead = function(self, parentTr)
  -- function num : 0_4 , upvalues : _ENV
  local emptyIndex = self.emptyHeroHeadItemListIndex
  local emptyIcon = nil
  if emptyIndex <= #self.emptyHeroHeadItemList then
    emptyIcon = (self.emptyHeroHeadItemList)[emptyIndex]
  else
    emptyIcon = ((self.ui).obj_EmptyHero):Instantiate()
    ;
    (table.insert)(self.emptyHeroHeadItemList, emptyIcon)
  end
  emptyIndex = emptyIndex + 1
  emptyIcon:SetActive(true)
  ;
  (emptyIcon.transform):SetParent(parentTr)
  ;
  (emptyIcon.transform):SetAsLastSibling()
  self.emptyHeroHeadItemListIndex = emptyIndex
  return emptyIcon
end

UIWCSRecommeFormationWindow.GetCommanderSkill = function(self, skillId, parentTr)
  -- function num : 0_5 , upvalues : _ENV
  local skillItem = (self.skillItemPool):GetOne()
  if skillId == nil then
    error("nil commander id！")
    return 
  end
  skillItem:InitCommanderSkill(skillId, self.resloader)
  ;
  (skillItem.transform):SetParent(parentTr)
  ;
  (skillItem.transform):SetAsLastSibling()
end

UIWCSRecommeFormationWindow.InitRecommendTeamShow = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for recommendId,recommendTeam in pairs(self._recommendTeamList) do
    local recommendSkillData = (self._recommendSkillDataList)[recommendId]
    local formationItem = (self.formationItemPool):GetOne()
    formationItem:InitWCSRecommeFormationItem(recommendTeam, recommendSkillData, self.__GetHeroHeadCallback, self.__GetCommanderSkillCallback, self.resloader)
  end
end

UIWCSRecommeFormationWindow.BackAction = function(self)
  -- function num : 0_7
  self.settedTopStatus = false
  self:Hide()
end

UIWCSRecommeFormationWindow.OnClickClose = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.settedTopStatus then
    (UIUtil.OnClickBack)()
  end
end

UIWCSRecommeFormationWindow.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWCSRecommeFormationWindow

