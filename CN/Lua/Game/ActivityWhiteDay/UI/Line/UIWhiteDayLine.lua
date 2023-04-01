-- params : ...
-- function num : 0 , upvalues : _ENV
local UIWhiteDayLine = class("UIWhiteDayLine", UIBaseWindow)
local base = UIBaseWindow
local cs_ResLoader = CS.ResLoader
local cs_MessageCommon = CS.MessageCommon
local UINWhiteDayOrderItem = require("Game.ActivityWhiteDay.UI.Line.UINWhiteDayOrderItem")
local ActivityWhiteDayUtil = require("Game.ActivityWhiteDay.ActivityWhiteDayUtil")
UIWhiteDayLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWhiteDayOrderItem
  self.orderItemPool = (UIItemPool.New)(UINWhiteDayOrderItem, (self.ui).obj_productItem)
  ;
  ((self.ui).obj_productItem):SetActive(false)
  self.__onClickkStartProduce = BindCallback(self, self.__OnClickkStartProduce)
  self.__refreshWDAssistHero = BindCallback(self, self.RefreshWDAssistHero)
  self.__onConfirmSelectHero = BindCallback(self, self.__OnConfirmSelectHero)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickClose)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_AddHero, self, self.__OnClickSelectHeto)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Switch, self, self.__OnClickSelectHeto)
end

UIWhiteDayLine.InitWDLine = function(self, AWDCtrl, AWDLineData)
  -- function num : 0_1
  self.AWDCtrl = AWDCtrl
  self.AWDLineData = AWDLineData
  self:RefreshFactoryLineIntro()
  self:RefreshWDOrderList()
  self:RefreshWDAssistHero()
end

UIWhiteDayLine.RefreshWDOrderList = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (self.orderItemPool):HideAll()
  local orderDataList = (self.AWDLineData):GetWDLineOrderDataList()
  for index,orderData in ipairs(orderDataList) do
    if orderData:GetWDLineOrderCouldShow() then
      local orderItem = (self.orderItemPool):GetOne()
      orderItem:InitWDOrderItem(orderData, self.__onClickkStartProduce)
    end
  end
end

UIWhiteDayLine.RefreshFactoryLineIntro = function(self)
  -- function num : 0_3 , upvalues : _ENV, cs_ResLoader
  local lineCfg = (self.AWDLineData):GetWDLineCfg()
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(lineCfg.line_name)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Describe).text = (LanguageUtil.GetLocaleText)(lineCfg.line_des)
  local linePicRes = lineCfg.line_res
  if not (string.IsNullOrEmpty)(linePicRes) then
    if self.bigResLoader ~= nil then
      (self.bigResLoader):Put2Pool()
      self.bigResLoader = nil
    end
    self.bigResLoader = (cs_ResLoader.Create)()
    local path = PathConsts:GetWhiteDayLinePath(linePicRes)
    ;
    (UIUtil.LoadABAssetAsyncAndSetTexture)(self.bigResLoader, path, (self.ui).img_ProductionLine)
  end
end

UIWhiteDayLine.RefreshWDAssistHero = function(self)
  -- function num : 0_4 , upvalues : _ENV, cs_ResLoader, ActivityWhiteDayUtil
  local AWDData = (self.AWDLineData):GetAWDData()
  local assistHeroId = (self.AWDLineData):GetWDLDAssistHeroID()
  local isHaveHero = assistHeroId ~= nil
  ;
  ((self.ui).obj_hero):SetActive(isHaveHero)
  ;
  ((self.ui).obj_empty):SetActive(not isHaveHero)
  if not isHaveHero then
    return 
  end
  local heroCfg = (ConfigData.hero_data)[assistHeroId]
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  local heroData = (PlayerDataCenter.heroDic)[assistHeroId]
  if self.heroResLoader ~= nil then
    (self.heroResLoader):Put2Pool()
    self.heroResLoader = nil
  end
  self.heroResLoader = (cs_ResLoader.Create)()
  ;
  (self.heroResLoader):LoadABAssetAsync(PathConsts:GetCharacterPicPath(heroData:GetResPicName()), function(texture)
    -- function num : 0_4_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_HeroPic).texture = texture
  end
)
  local assistTypeId, assistCfg = (ActivityWhiteDayUtil.GetAssistHeroTypeByHeroId)(AWDData, heroData.heroCfg)
  ;
  ((self.ui).img_RewardIcon):SetIndex(assistTypeId - 1)
  -- DECOMPILER ERROR at PC70: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_RewardInfo).text = (LanguageUtil.GetLocaleText)(assistCfg.effect_text)
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIWhiteDayLine.__OnClickkStartProduce = function(self, orderData)
  -- function num : 0_5 , upvalues : _ENV
  local AWDData = (self.AWDLineData):GetAWDData()
  local actFrameId = AWDData:GetActFrameId()
  local orderId = orderData:GetWDLineOrderId()
  local assistHeroId = (self.AWDLineData):GetWDLDAssistHeroID()
  local lineId = (self.AWDLineData):GetWDLDLineID()
  if assistHeroId == nil then
    self:__OnClickSelectHeto(function()
    -- function num : 0_5_0 , upvalues : self, actFrameId, orderId, lineId, _ENV
    local assistHeroId = (self.AWDLineData):GetWDLDAssistHeroID()
    if assistHeroId ~= nil then
      (self.AWDCtrl):WDStartLineOrder(actFrameId, orderId, assistHeroId, lineId)
      AudioManager:PlayAudioById(1202)
      self:OnClickClose()
    end
  end
)
    AudioManager:PlayAudioById(1200)
    return 
  end
  ;
  (self.AWDCtrl):WDStartLineOrder(actFrameId, orderId, assistHeroId, lineId)
  AudioManager:PlayAudioById(1202)
  self:OnClickClose()
end

UIWhiteDayLine.__OnClickSelectHeto = function(self, afterSelectCallback)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayHeroList, function(window)
    -- function num : 0_6_0 , upvalues : self, afterSelectCallback
    if window == nil then
      return 
    end
    local AWDData = (self.AWDLineData):GetAWDData()
    window:InitWDHeroList(self.AWDCtrl, AWDData, self.AWDLineData, false, self.__onConfirmSelectHero, function()
      -- function num : 0_6_0_0 , upvalues : self, afterSelectCallback
      (self.__refreshWDAssistHero)()
      if afterSelectCallback ~= nil then
        afterSelectCallback()
      end
    end
)
  end
)
end

UIWhiteDayLine.__OnConfirmSelectHero = function(self, selectedHeroId)
  -- function num : 0_7
  (self.AWDLineData):SetWDLDAssistHeroID(selectedHeroId)
end

UIWhiteDayLine.OnClickClose = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if not (self.AWDLineData):GetIsInProduction() then
    (self.AWDLineData):SetWDLDAssistHeroID(nil)
  end
  ;
  (UIUtil.ReShowTopStatus)()
  self:Hide()
end

UIWhiteDayLine.OnShow = function(self)
  -- function num : 0_9 , upvalues : base, _ENV
  (base.OnShow)(self)
  ;
  (UIUtil.HideTopStatus)()
end

UIWhiteDayLine.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  if self.bigResLoader ~= nil then
    (self.bigResLoader):Put2Pool()
    self.bigResLoader = nil
  end
  if self.heroResLoader ~= nil then
    (self.heroResLoader):Put2Pool()
    self.heroResLoader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWhiteDayLine

