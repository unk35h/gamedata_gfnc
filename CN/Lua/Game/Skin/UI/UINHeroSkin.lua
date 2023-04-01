-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroSkin = class("UINHeroSkin", UIBaseNode)
local base = UIBaseNode
local UINHeroSkinTag = require("Game.Skin.UI.UINHeroSkinTag")
local UINHeroSkinSpTag = require("Game.Skin.UI.UINHeroSkinSpTag")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
UINHeroSkin.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroSkinTag, UINHeroSkinSpTag
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  ((self.ui).tagItem):SetActive(false)
  self.tagPool = (UIItemPool.New)(UINHeroSkinTag, (self.ui).tagItem)
  ;
  ((self.ui).tagItem):SetActive(false)
  self._tagSpPool = (UIItemPool.New)(UINHeroSkinSpTag, (self.ui).img_SpTag)
  ;
  ((self.ui).img_SpTag):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_skinPreviewItem, self, self.OnClickSkinItem)
end

UINHeroSkin.InitSkinItem = function(self, heroId, skinCfg, resLoader, clickFunc, outDataFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.heroCfg = (ConfigData.hero_data)[heroId]
  self.skinCfg = skinCfg
  self.shopGoodsData = nil
  self.clickFunc = clickFunc
  self.outDataFunc = outDataFunc
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  self.resModelCfg = skinCtr:GetResModel(heroId, skinCfg ~= nil and skinCfg.id or nil)
  self.isL2DRectify = (PlayerDataCenter.skinData):IsL2dRectify(skinCfg.id)
  ;
  (self.tagPool):HideAll()
  local live2dLevel, haveModel = (CommonUIUtil.CreateHeroSkinTags)(self.skinCfg, self.tagPool)
  self.live2dLevel = live2dLevel
  self.haveModel = haveModel
  ;
  (((self.ui).img_Skin).gameObject):SetActive(false)
  local picResPath = PathConsts:GetCharacterPicPath((self.resModelCfg).src_id_pic)
  resLoader:LoadABAssetAsync(picResPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if not IsNull((self.ui).img_Skin) then
      (((self.ui).img_Skin).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_Skin).texture = texture
    end
  end
)
  -- DECOMPILER ERROR at PC68: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = self.skinCfg ~= nil and (LanguageUtil.GetLocaleText)((self.skinCfg).name) or ""
  if self.skinCfg == nil or not (self.skinCfg).theme then
    local skinTheme = (ConfigData.skinTheme)[(ConfigData.game_config).defaultSkinThemId]
    -- DECOMPILER ERROR at PC93: Confused about usage of register: R11 in 'UnsetPending'

    ;
    ((self.ui).tex_SkinName).text = skinTheme ~= nil and (LanguageUtil.GetLocaleText)(skinTheme.name) or ""
    ;
    (self._tagSpPool):HideAll()
    for _,tagId in ipairs((self.skinCfg).showlabel) do
      local item = (self._tagSpPool):GetOne()
      item:InitSkinSpTag(tagId)
    end
    local isShowL2DComingSoon = (self.skinCfg).temp_label
    ;
    ((self.ui).obj_L2DComingSoon):SetActive(isShowL2DComingSoon)
    ;
    (((self.ui).obj_L2DComingSoon).transform):SetAsLastSibling()
    self:Refresh()
  end
end

UINHeroSkin.Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self:__TryUpdateShopData()
  if self.skinCfg ~= nil and not (PlayerDataCenter.skinData):IsHaveSkin((self.skinCfg).id) and self.shopGoodsData ~= nil then
    ((self.ui).obj_Price):SetActive(true)
    local priceItem = (ConfigData.item)[(self.shopGoodsData).currencyId]
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Price).sprite = CRH:GetSprite(priceItem.small_icon)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Price).text = tostring((self.shopGoodsData).newCurrencyNum)
  else
    do
      ;
      ((self.ui).obj_Price):SetActive(false)
      self:OnTimerCutDownStart()
    end
  end
end

UINHeroSkin.__TryUpdateShopData = function(self)
  -- function num : 0_3 , upvalues : _ENV, ActivityFrameEnum
  self.shopGoodsData = nil
  self._bpGiftId = 0
  local skinCtr = ControllerManager:GetController(ControllerTypeId.Skin, true)
  if self.skinCfg == nil then
    return 
  end
  self.shopGoodsData = skinCtr:GetGoodsBySkinCfg(self.skinCfg)
  local actData = skinCtr:GetActFrameDataBySkinCfg(self.skinCfg)
  if actData ~= nil and actData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).BattlePass then
    if self.shopGoodsData == nil then
      return 
    end
    local actId = actData:GetActId()
    local passInfo = ((PlayerDataCenter.battlepassData).passInfos)[actId]
    if passInfo == nil or passInfo:GetBpBannerSkinId() == (self.skinCfg).id or passInfo:GetBPSkinShopId() == 0 then
      return 
    end
    self._bpGiftId = passInfo:GetBpSkinCoinGift()
  end
end

UINHeroSkin.GetItemLive2dLevel = function(self)
  -- function num : 0_4
  return self.live2dLevel
end

UINHeroSkin.GetSkinBpGiftId = function(self)
  -- function num : 0_5
  return self._bpGiftId
end

UINHeroSkin.OnTimerCutDownStart = function(self)
  -- function num : 0_6 , upvalues : _ENV
  ((self.ui).time):SetActive(false)
  if self.cutDownTimer ~= nil then
    TimerManager:StopTimer(self.cutDownTimer)
    self.cutDownTimer = nil
  end
  if self.shopGoodsData == nil then
    return 
  end
  if (self.shopGoodsData).isSoldOut then
    return 
  end
  local hasTime = (self.shopGoodsData):GetStillTime()
  if not hasTime then
    return 
  end
  ;
  ((self.ui).time):SetActive(true)
  self.cutDownTimer = TimerManager:StartTimer(1, self.OnTimerCutDown, self)
  self:OnTimerCutDown()
end

UINHeroSkin.OnTimerCutDown = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.shopGoodsData == nil then
    self:OnTimerCutDownFinish()
    return 
  end
  local hasTime, inTime, startTime, endTime = (self.shopGoodsData):GetStillTime()
  if not hasTime or not inTime then
    self:OnTimerCutDownFinish()
    return 
  end
  local remaindTime = endTime - PlayerDataCenter.timestamp
  local d, h, m, s = TimeUtil:TimestampToTimeInter(remaindTime, false, true)
  if d > 0 then
    ((self.ui).text_time):SetIndex(0, tostring(d), tostring(h))
    return 
  end
  if h > 0 then
    ((self.ui).text_time):SetIndex(1, tostring(h), tostring(m))
    return 
  end
  if s > 0 then
    m = m + 1
  end
  ;
  ((self.ui).text_time):SetIndex(2, tostring(m))
end

UINHeroSkin.OnTimerCutDownFinish = function(self)
  -- function num : 0_8 , upvalues : _ENV
  ((self.ui).time):SetActive(false)
  if self.cutDownTimer ~= nil then
    TimerManager:StopTimer(self.cutDownTimer)
    self.cutDownTimer = nil
  end
  self.shopGoodsData = nil
  if self.outDataFunc ~= nil then
    (self.outDataFunc)()
  end
end

UINHeroSkin.SetSelectState = function(self, flag)
  -- function num : 0_9 , upvalues : _ENV
  (((self.ui).img_Quailty).gameObject):SetActive(flag)
  ;
  ((self.ui).maskBlack):SetActive(not flag)
  for i,v in ipairs((self.tagPool).listItem) do
    v:SetSelectState(flag)
  end
end

UINHeroSkin.OnClickSkinItem = function(self)
  -- function num : 0_10
  if self.clickFunc ~= nil then
    (self.clickFunc)(self)
  end
end

UINHeroSkin.OnDelete = function(self)
  -- function num : 0_11 , upvalues : _ENV, base
  if self.cutDownTimer ~= nil then
    TimerManager:StopTimer(self.cutDownTimer)
    self.cutDownTimer = nil
  end
  ;
  (base.OnDelete)(self)
end

UINHeroSkin.TryGetShopGoodsId = function(self)
  -- function num : 0_12
  if self.shopGoodsData == nil then
    return nil, nil
  end
  return (self.shopGoodsData).shopId, (self.shopGoodsData).shelfId
end

return UINHeroSkin

