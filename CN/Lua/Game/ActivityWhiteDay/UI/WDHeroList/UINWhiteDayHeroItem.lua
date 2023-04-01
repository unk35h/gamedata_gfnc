-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWhiteDayHeroItem = class("UINWhiteDayHeroItem", UIBaseNode)
local base = UIBaseNode
UINWhiteDayHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_heroItem, self, self.__OnClick)
end

UINWhiteDayHeroItem.InitWDHeroItem = function(self, heroCfg, isPickPhoto, heroAssistType, clickEvent, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.heroCfg = heroCfg
  self.clickEvent = clickEvent
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  local heroData = (PlayerDataCenter.heroDic)[heroCfg.id]
  local picPath = nil
  if heroData ~= nil then
    picPath = PathConsts:GetCharacterPicPath(heroData:GetResPicName())
  else
    local defaultSkin = heroCfg.default_skin
    local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
    local resCfg = skinCtr:GetResModel(heroCfg.id, defaultSkin)
    picPath = PathConsts:GetCharacterPicPath(resCfg.res_Name)
  end
  do
    resloader:LoadABAssetAsync(picPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self, heroCfg
    if IsNull(self.transform) then
      return 
    end
    if self.heroCfg ~= heroCfg then
      return 
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPic).texture = texture
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPic).enabled = true
  end
)
    if isPickPhoto then
      ((self.ui).obj_icon):SetActive(false)
    else
      ;
      ((self.ui).obj_icon):SetActive(true)
      ;
      ((self.ui).img_Icon):SetIndex(heroAssistType - 1)
    end
  end
end

UINWhiteDayHeroItem.__OnClick = function(self)
  -- function num : 0_2
  if self.clickEvent ~= nil then
    (self.clickEvent)(self)
  end
end

UINWhiteDayHeroItem.SetWDHeroItemSelected = function(self, bool)
  -- function num : 0_3
  if bool then
    ((self.ui).img_bottom):SetIndex(1)
  else
    ;
    ((self.ui).img_bottom):SetIndex(0)
  end
end

UINWhiteDayHeroItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINWhiteDayHeroItem

