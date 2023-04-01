-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCustomHeroGiftNode = class("UINCustomHeroGiftNode", UIBaseNode)
local base = UIBaseNode
local eSelfSelectGift = require("Game.PayGift.eSelfSelectGift")
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINCustomHeroGiftNode.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SelectHero, self, self.OnClickCustomHeroGiftSelect)
  self._itemNode = (UINBaseItemWithCount.New)()
  ;
  (self._itemNode):Init((self.ui).uINBaseItemWithCount)
  ;
  (self._itemNode):Hide()
end

UINCustomHeroGiftNode.BindGiftHeroSelectCallback = function(self, callback)
  -- function num : 0_1
  self._callback = callback
end

UINCustomHeroGiftNode.RefreshCustomHeroGiftSelect = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  self._heroId = heroId
  ;
  (((self.ui).img_AddHero).gameObject):SetActive(self._heroId == nil)
  if self._heroId ~= nil then
    if PlayerDataCenter:ContainsHeroData(self._heroId) then
      (self._itemNode):Show()
      ;
      (((self.ui).img_ItemPic).gameObject):SetActive(false)
      local itemId = ((ConfigData.game_config).customHeroGiftConvert)[1]
      local count = ((ConfigData.game_config).customHeroGiftConvert)[2]
      ;
      (self._itemNode):InitItemWithCount((ConfigData.item)[itemId], count, self._callback)
    else
      (self._itemNode):Hide()
      ;
      (((self.ui).img_ItemPic).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC61: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).img_ItemPic).sprite = CRH:GetHeroSkinSprite(self._heroId)
    end
  end
  if self._heroId or 0 > 0 then
    local heroCfg = (ConfigData.hero_data)[self._heroId]
    local rankCfg = (ConfigData.hero_rank)[heroCfg.rank]
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Quality).color = HeroRareColor[rankCfg.rare]
    -- DECOMPILER ERROR at PC88: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).text).text = ConfigData:GetTipContent(413)
  else
    -- DECOMPILER ERROR at PC94: Confused about usage of register: R2 in 'UnsetPending'

    ((self.ui).img_Quality).color = Color.white
    -- DECOMPILER ERROR at PC101: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).text).text = ConfigData:GetTipContent(412)
    ;
    (self._itemNode):Hide()
    ;
    (((self.ui).img_ItemPic).gameObject):SetActive(false)
  end
  self:__RefreshSelectedState()
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINCustomHeroGiftNode.RefreshCustomChipGiftSelect = function(self, heroId, selfSelectCfg)
  -- function num : 0_3 , upvalues : _ENV, eSelfSelectGift
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).img_Quality).color = Color.white
  ;
  (((self.ui).img_ItemPic).gameObject):SetActive(false)
  self._heroId = heroId
  ;
  (((self.ui).img_AddHero).gameObject):SetActive(self._heroId == nil)
  if self._heroId or 0 == 0 then
    (self._itemNode):Hide()
    -- DECOMPILER ERROR at PC37: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).text).text = ConfigData:GetTipContent(416)
    self:__RefreshSelectedState()
    return 
  end
  if not selfSelectCfg then
    local localSelfSelectCfg = (ConfigData.customized_gift)[(eSelfSelectGift.type).heroFragWithOutLimit]
  end
  local heroCfg = (ConfigData.hero_data)[heroId]
  local itemId = heroCfg.fragment
  local count = (localSelfSelectCfg.param1)[1]
  ;
  (self._itemNode):Show()
  ;
  (self._itemNode):InitItemWithCount((ConfigData.item)[itemId], count, self._callback)
  -- DECOMPILER ERROR at PC71: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).text).text = ConfigData:GetTipContent(417)
  self:__RefreshSelectedState()
  -- DECOMPILER ERROR: 4 unprocessed JMP targets
end

UINCustomHeroGiftNode.__RefreshSelectedState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (self.ui).tweens == nil then
    return 
  end
  local isEmpty = self._heroId or 0 == 0
  ;
  ((((self.ui).tweens)[1]).gameObject):SetActive(isEmpty)
  for i,v in ipairs((self.ui).tweens) do
    if isEmpty then
      v:DORestart()
    else
      v:DORewind()
    end
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINCustomHeroGiftNode.OnClickCustomHeroGiftSelect = function(self)
  -- function num : 0_5
  if self._callback then
    (self._callback)()
  end
end

UINCustomHeroGiftNode.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  for i,v in ipairs((self.ui).tweens) do
    v:DOKill()
  end
  ;
  (base.OnDelete)(self)
end

return UINCustomHeroGiftNode

