-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCustomHeroSelectItem = class("UINCustomHeroSelectItem", UIBaseNode)
local base = UIBaseNode
UINCustomHeroSelectItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroInfo, self, self.OnClickPreview)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroItem, self, self.OnClickHeroSelect)
  self._starList = {}
  ;
  (table.insert)(self._starList, (self.ui).img_star)
end

UINCustomHeroSelectItem.InitCustomHeroItem = function(self, heroCfg, callback, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self._heroId = heroCfg.id
  self._callback = callback
  self._resloader = resloader
  ;
  (((self.ui).btn_HeroInfo).gameObject):SetActive(false)
  local rankCfg = (ConfigData.hero_rank)[heroCfg.rank]
  local campCfg = (ConfigData.camp)[heroCfg.camp]
  local careerCfg = (ConfigData.career)[heroCfg.career]
  local modelCfg = (ConfigData.resource_model)[heroCfg.src_id]
  ;
  ((self.ui).tex_HeroID):SetIndex(0, tostring(heroCfg.id))
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Quality).color = HeroRareColor[rankCfg.rare]
  -- DECOMPILER ERROR at PC52: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_QualityLight).color = HeroRareColor[rankCfg.rare]
  ;
  (((self.ui).img_Camp).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetCampPicPath(campCfg.icon), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_Camp).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Camp).texture = texture
  end
)
  ;
  (((self.ui).img_Hero).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(modelCfg.res_Name), function(texture)
    -- function num : 0_1_1 , upvalues : _ENV, self
    if IsNull(self.transform) or IsNull(texture) then
      return 
    end
    ;
    (((self.ui).img_Hero).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Hero).texture = texture
  end
)
  -- DECOMPILER ERROR at PC89: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_Career).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
  ;
  ((self.ui).img_IsHave):SetActive(PlayerDataCenter:ContainsHeroData(self._heroId))
  local num = heroCfg.rank
  local count = (math.ceil)(num / 2)
  local isHalf = num % 2 == 1
  for _,starGameObject in ipairs(self._starList) do
    (starGameObject.gameObject):SetActive(false)
  end
  for i = 1, count do
    if (self._starList)[i] ~= nil then
      (((self._starList)[i]).gameObject):SetActive(true)
      ;
      ((self._starList)[i]):SetIndex(0)
    else
      local imgItemInfo = ((((self.ui).img_star).gameObject):Instantiate()):GetComponent(typeof(CS.UiImageItemInfo))
      ;
      (table.insert)(self._starList, imgItemInfo)
      ;
      (imgItemInfo.gameObject):SetActive(true)
    end
  end
  if isHalf then
    ((self._starList)[count]):SetIndex(1)
  end
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINCustomHeroSelectItem.RefreshCustomHeroState = function(self, heroId)
  -- function num : 0_2
  (((self.ui).img_OnSelect).gameObject):SetActive(heroId == self._heroId)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINCustomHeroSelectItem.OnClickHeroSelect = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._heroId)
  end
end

UINCustomHeroSelectItem.OnClickPreview = function(self)
  -- function num : 0_4
end

return UINCustomHeroSelectItem

