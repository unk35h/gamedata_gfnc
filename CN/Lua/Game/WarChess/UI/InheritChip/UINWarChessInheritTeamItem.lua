-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessInheritTeamItem = class("UINWarChessInheritTeamItem", UIBaseNode)
local UINWarChessMain_DNTeamItemHeroItem = require("Game.WarChess.UI.Main.UINWarChessMain_DNTeamItemHeroItem")
UINWarChessInheritTeamItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessMain_DNTeamItemHeroItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.heroHeadPool = (UIItemPool.New)(UINWarChessMain_DNTeamItemHeroItem, (self.ui).heroHeadItem)
  ;
  ((self.ui).heroHeadItem):SetActive(false)
end

UINWarChessInheritTeamItem.InitWCDeployTeamItem = function(self, dTeamData, resloader)
  -- function num : 0_1
  self.dTeamData = dTeamData
  self.resloader = resloader
  self:RefreshTeamItem()
end

UINWarChessInheritTeamItem.RefreshTeamItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local firstHeroData, teamPower, heroDataList, isDeployed, teamName = nil, nil, nil, nil, nil
  firstHeroData = (self.dTeamData):GetFirstHeroData()
  teamPower = (self.dTeamData):GetDTeamTeamPower()
  heroDataList = (self.dTeamData):GetTeamMemberHeroDataList()
  isDeployed = (self.dTeamData):GetIsDeploied()
  teamName = (self.dTeamData):GetDTeamName()
  self.__couldDeploy = true
  self.__isHaveHero = firstHeroData ~= nil
  ;
  ((self.ui).realTeam):SetActive(self.__isHaveHero)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

  if self.__isHaveHero then
    ((self.ui).img_HeroPic).texture = (self.resloader):LoadABAsset(PathConsts:GetCharacterPicPath(firstHeroData:GetResPicName()))
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_TeamPow).text = tostring(teamPower)
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_TeamName).text = teamName
    ;
    (self.heroHeadPool):HideAll()
    for index,heroData in ipairs(heroDataList) do
      local heroHeadItem = (self.heroHeadPool):GetOne()
      heroHeadItem:InitWCHeroHeadItem(R14_PC71, index == 1)
    end
  end
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

return UINWarChessInheritTeamItem

