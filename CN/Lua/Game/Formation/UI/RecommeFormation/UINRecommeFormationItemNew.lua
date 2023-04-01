-- params : ...
-- function num : 0 , upvalues : _ENV
local UINRecommeFormationItem = class("UINRecommeFormationItem", UIBaseNode)
local base = UIBaseNode
local UINHeroHeadWithStarItem = require("Game.CommonUI.Hero.UINHeroHeadWithStarItem")
local CS_MessageCommon = CS.MessageCommon
UINRecommeFormationItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadWithStarItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).obj_HeroHead):SetActive(false)
  ;
  ((self.ui).obj_EmptyHero):SetActive(false)
  self.heroHeadPool = (UIItemPool.New)(UINHeroHeadWithStarItem, (self.ui).obj_HeroHead)
  self.emptyIconList = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickRecommeItem)
end

UINRecommeFormationItem.InitRecommeItemNew = function(self, recommeCtr, data, recordInfo, resloader, callback)
  -- function num : 0_1 , upvalues : _ENV
  self.recommeCtr = recommeCtr
  self.data = data
  self.resloader = resloader
  self.itemClickCallback = callback
  self.index = data.rank
  local stageCount = recordInfo:GetRecommeMaxStageNum()
  ;
  (self.heroHeadPool):HideAll()
  for i = 1, #self.emptyIconList do
    ((self.emptyIconList)[i]):SetActive(false)
  end
  local emptyIndex = self:__RefreshHeroIcon(1, (self.ui).mainTeam, 1, stageCount)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Rank).text = (string.format)("%02d", data.rank)
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_winCount).text = tostring(data.winCount)
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_power).text = tostring(data.power)
end

UINRecommeFormationItem.__RefreshHeroIcon = function(self, emptyIndex, parentTr, startIndex, endIndex)
  -- function num : 0_2 , upvalues : _ENV
  for i = startIndex, endIndex do
    local recommanHeroInfo = ((self.data).recommanHeroList)[i]
    if recommanHeroInfo ~= nil then
      local item = (self.heroHeadPool):GetOne()
      local isHas = (PlayerDataCenter.heroDic)[recommanHeroInfo.basicId] ~= nil
      item:InitHeadByNotHaveData(recommanHeroInfo.basicId, isHas)
      ;
      ((item.gameObject).transform):SetParent(parentTr)
      ;
      ((item.gameObject).transform):SetAsLastSibling()
    else
      local emptyIcon = nil
      if emptyIndex <= #self.emptyIconList then
        emptyIcon = (self.emptyIconList)[emptyIndex]
      else
        emptyIcon = ((self.ui).obj_EmptyHero):Instantiate()
        ;
        (table.insert)(self.emptyIconList, emptyIcon)
      end
      emptyIndex = emptyIndex + 1
      emptyIcon:SetActive(true)
      ;
      (emptyIcon.transform):SetParent(parentTr)
      ;
      (emptyIcon.transform):SetAsLastSibling()
    end
  end
  do return emptyIndex end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINRecommeFormationItem.OnClickRecommeItem = function(self)
  -- function num : 0_3
  (self.itemClickCallback)(self.index)
end

return UINRecommeFormationItem

