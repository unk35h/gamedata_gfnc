-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEpSptRoomHeroItem = class("UINEpSptRoomHeroItem", UIBaseNode)
local base = UIBaseNode
local UINHeroHeadItem = require("Game.CommonUI.Hero.UINHeroHeadItem")
UINEpSptRoomHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroHeadItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.headItem = (UINHeroHeadItem.New)()
  ;
  (self.headItem):Init((self.ui).obj_heroHeadItem)
  self._clickFunc = BindCallback(self, self._OnClickRoot)
end

UINEpSptRoomHeroItem._InitBasse = function(self, heroData, resloader, clickEvent)
  -- function num : 0_1
  self.clickEvent = clickEvent
  ;
  (self.headItem):InitHeroHeadItem(heroData, resloader, self._clickFunc)
  local half = heroData.rank % 2
  local rankImgIndex = (heroData.rank - half) / 2 - 1
  if rankImgIndex >= 0 then
    (((self.ui).img_Star).gameObject):SetActive(true)
    ;
    ((self.ui).img_Star):SetIndex(rankImgIndex)
    local vec = ((((self.ui).img_Star).image).rectTransform).sizeDelta
    vec.x = (((((self.ui).img_Star).image).sprite).rect).width
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((((self.ui).img_Star).image).rectTransform).sizeDelta = vec
  else
    do
      ;
      (((self.ui).img_Star).gameObject):SetActive(false)
      ;
      (((self.ui).img_Half).gameObject):SetActive(half == 1)
      -- DECOMPILER ERROR: 1 unprocessed JMP targets
    end
  end
end

UINEpSptRoomHeroItem.InitEpSptRoomHeroExItem = function(self, heroData, resloader, clickEvent)
  -- function num : 0_2 , upvalues : _ENV
  self:_InitBasse(heroData, resloader, clickEvent)
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_hP).fillAmount = 1
  ;
  ((self.ui).isBench):SetActive(false)
  self.fightingPower = heroData:GetFightingPower()
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(self.fightingPower)
  self._isHeroData = true
  self.heroData = heroData
  self._id = heroData.dataId
end

UINEpSptRoomHeroItem.InitEpSptRoomHeroItem = function(self, dynHeroData, resloader, clickEvent)
  -- function num : 0_3 , upvalues : _ENV
  self.dynHeroData = dynHeroData
  local heroData = dynHeroData.heroData
  self:_InitBasse(heroData, resloader, clickEvent)
  local hpPer = dynHeroData.hpPer / 10000
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).img_hP).fillAmount = hpPer
  ;
  ((self.ui).isBench):SetActive(dynHeroData:IsBench())
  self.fightingPower = dynHeroData:GetFightingPower()
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(self.fightingPower)
  self._isHeroData = false
  self._id = dynHeroData.uid
end

UINEpSptRoomHeroItem.SetEpSptRoomHeroItemSelect = function(self, select)
  -- function num : 0_4
  ((self.ui).onSelect):SetActive(select)
end

UINEpSptRoomHeroItem.SetEpSptRoomHeroItemHas = function(self, has)
  -- function num : 0_5
  ((self.ui).has):SetActive(has)
  self.has = has
end

UINEpSptRoomHeroItem.GetSupHeroItemPowerAndId = function(self)
  -- function num : 0_6
  return self.fightingPower, self._id
end

UINEpSptRoomHeroItem.ClickSupHeroItem = function(self)
  -- function num : 0_7
  return self:_OnClickRoot()
end

UINEpSptRoomHeroItem._OnClickRoot = function(self)
  -- function num : 0_8
  if self.has then
    return 
  end
  if self.clickEvent ~= nil then
    if not self._isHeroData or not self.heroData then
      local heroData = self.dynHeroData
    end
    ;
    (self.clickEvent)(self, heroData, self.fightingPower, self._isHeroData)
  end
end

UINEpSptRoomHeroItem.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (base.OnDelete)(self)
end

return UINEpSptRoomHeroItem

