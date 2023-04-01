-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmCheckInDetailSlot = class("UINDmCheckInDetailSlot", UIBaseNode)
local base = UIBaseNode
UINDmCheckInDetailSlot.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_IconBtn, self, self._OnClickRoot)
end

UINDmCheckInDetailSlot.InitDmCheckInDetailSlot = function(self, index, heroId, clickFunc)
  -- function num : 0_1
  self.index = index
  self.clickFunc = clickFunc
  self:UpdDmCheckInDetailSlot(heroId)
end

UINDmCheckInDetailSlot.UpdDmCheckInDetailSlot = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  self.heroId = heroId
  if heroId == nil then
    (((self.ui).HeroAvator).gameObject):SetActive(false)
    ;
    (((self.ui).addOrEmpty).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_tir).enabled = false
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_can).enabled = false
    ;
    ((self.ui).addOrEmpty):SetIndex(1)
    return 
  end
  if heroId == 0 then
    (((self.ui).HeroAvator).gameObject):SetActive(false)
    ;
    (((self.ui).addOrEmpty).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_tir).enabled = true
    -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_can).enabled = true
    ;
    ((self.ui).addOrEmpty):SetIndex(0)
    return 
  end
  ;
  (((self.ui).HeroAvator).gameObject):SetActive(true)
  ;
  (((self.ui).addOrEmpty).gameObject):SetActive(false)
  local heroData = PlayerDataCenter:GetHeroData(heroId)
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R3 in 'UnsetPending'

  if heroData ~= nil then
    ((self.ui).img_HeroIcon).sprite = CRH:GetHeroSkinSprite(heroData.dataId, heroData.skinId)
  end
end

UINDmCheckInDetailSlot._OnClickRoot = function(self)
  -- function num : 0_3
  if self.heroId == nil or self.heroId == 0 then
    return 
  end
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.index)
  end
end

UINDmCheckInDetailSlot.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmCheckInDetailSlot

