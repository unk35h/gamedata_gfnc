-- params : ...
-- function num : 0 , upvalues : _ENV
local UIN_HBHeroHeroListHeroItem = class("UIN_HBHeroHeroListHeroItem", UIBaseNode)
local base = UIBaseNode
local cs_DoTweenLoopType = ((CS.DG).Tweening).LoopType
UIN_HBHeroHeroListHeroItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_HeroItem, self, self.__OnClick)
end

UIN_HBHeroHeroListHeroItem.InitHBHeroHeadItem = function(self, onClickHeroItem)
  -- function num : 0_1
  self.onClickHeroItem = onClickHeroItem
end

UIN_HBHeroHeroListHeroItem.RefreshHBHeroHeadItem = function(self, heroId)
  -- function num : 0_2 , upvalues : _ENV
  self.heroId = heroId
  local heroData = nil
  if PlayerDataCenter:ContainsHeroData(heroId) then
    heroData = PlayerDataCenter:GetHeroData(heroId)
  end
  local model, name, campName = nil, nil, nil
  if heroData ~= nil then
    _ = heroData:GetHeroArchiveInfo()
    name = heroData:GetName()
    campName = (LanguageUtil.GetLocaleText)((heroData:GetCampCfg()).name)
  else
    -- DECOMPILER ERROR at PC37: Overwrote pending register: R3 in 'AssignReg'

    name = not (self.ui).str_lockedName and (self.ui).str_lockedModel or "NaN"
    campName = "???"
  end
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = name
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).text_HeroModel).text = model
  -- DECOMPILER ERROR at PC51: Overwrote pending register: R8 in 'AssignReg'

  self:SetHeroHeadIcon(R8_PC19, R9_PC18)
  return name, campName
end

UIN_HBHeroHeroListHeroItem.SetHeroHeadIcon = function(self, heroData, heroId)
  -- function num : 0_3 , upvalues : _ENV
  do
    if heroData ~= nil then
      local resName = heroData:GetHeroHeadResName()
      -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

      if (string.IsNullOrEmpty)(resName) ~= nil then
        ((self.ui).img_HeroPic).sprite = CRH:GetSprite(resName, CommonAtlasType.HeroHeadIcon)
        -- DECOMPILER ERROR at PC23: Confused about usage of register: R4 in 'UnsetPending'

        ;
        ((self.ui).img_HeroPic).color = Color.white
      end
      return 
    end
    local heroCfg = (ConfigData.hero_data)[heroId]
    if heroCfg ~= nil then
      local itemCfg = (ConfigData.item)[heroCfg.fragment]
      if itemCfg ~= nil then
        local resName = itemCfg.icon
        -- DECOMPILER ERROR at PC51: Confused about usage of register: R6 in 'UnsetPending'

        if (string.IsNullOrEmpty)(resName) ~= nil then
          ((self.ui).img_HeroPic).sprite = CRH:GetSprite(resName, CommonAtlasType.HeroHeadIcon)
          -- DECOMPILER ERROR at PC56: Confused about usage of register: R6 in 'UnsetPending'

          ;
          ((self.ui).img_HeroPic).color = Color.black
        end
      end
    end
  end
end

UIN_HBHeroHeroListHeroItem.__OnClick = function(self)
  -- function num : 0_4 , upvalues : _ENV
  AudioManager:PlayAudioById(1222)
  if self.onClickHeroItem ~= nil then
    (self.onClickHeroItem)(self.heroId)
  end
end

UIN_HBHeroHeroListHeroItem.HBHeroHeadPlayBlinkTween = function(self, order)
  -- function num : 0_5 , upvalues : cs_DoTweenLoopType
  self:ClearHBHeroItemTween()
  ;
  ((((self.ui).cg_HeroItem):DOFade(0, 0.1)):From()):SetDelay(order * 0.05)
  ;
  (((((self.ui).img_corver):DOFade(1, 0.05)):From()):SetDelay((order + 1) * 0.05)):SetLoops(3, cs_DoTweenLoopType.Yoyo)
end

UIN_HBHeroHeroListHeroItem.ClearHBHeroItemTween = function(self)
  -- function num : 0_6
  ((self.ui).cg_HeroItem):DOComplete()
  ;
  ((self.ui).img_corver):DOComplete()
end

UIN_HBHeroHeroListHeroItem.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  self:ClearHBHeroItemTween()
  ;
  (base.OnDelete)(self)
end

return UIN_HBHeroHeroListHeroItem

