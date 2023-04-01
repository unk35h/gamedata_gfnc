-- params : ...
-- function num : 0 , upvalues : _ENV
local HandBookController = class("HandBookController", ControllerBase)
local base = ControllerBase
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local HandBookEnum = require("Game.HandBook.HandBookEnum")
local ShopUtil = require("Game.Shop.ShopUtil")
local __isSendingSingle = false
local __singleQueue = {}
local SendSingle = function(callback)
  -- function num : 0_0 , upvalues : __isSendingSingle, _ENV, __singleQueue
  if __isSendingSingle then
    (table.insert)(__singleQueue, callback)
    return 
  else
    __isSendingSingle = true
    if callback ~= nil then
      callback()
    end
  end
end

local SendSingleOver = function()
  -- function num : 0_1 , upvalues : __isSendingSingle, __singleQueue, _ENV
  __isSendingSingle = false
  if #__singleQueue > 0 then
    local callback = __singleQueue[1]
    ;
    (table.remove)(__singleQueue, 1)
    callback()
  end
end

HandBookController.OnInit = function(self)
  -- function num : 0_2 , upvalues : _ENV, eDynConfigData
  ConfigData:LoadDynCfg(eDynConfigData.hero_relationship)
  self.__collectNumDic = {}
  self.__viewLayerList = {}
  self._skinThemeNumDic = {}
  self.__PreconditionCallback = BindCallback(self, self.__Precondition)
  MsgCenter:AddListener(eMsgEventId.PreCondition, self.__PreconditionCallback)
  self.__onHeroSkinChange = BindCallback(self, self.__OnHeroSkinChange)
  MsgCenter:AddListener(eMsgEventId.OnHeroSkinChange, self.__onHeroSkinChange)
  self.__onHeroUpdate = BindCallback(self, self.__OnHeroUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateHero, self.__onHeroUpdate)
  self.__SkinUpdateCallback = BindCallback(self, self.__SkinUpdate)
  MsgCenter:AddListener(eMsgEventId.UpdateHeroSkin, self.__SkinUpdateCallback)
  self._whiteHistoryMsgDic = {}
end

HandBookController.CalCampHeroCollectNum = function(self, forceRecal)
  -- function num : 0_3 , upvalues : _ENV
  if not forceRecal and not (table.IsEmptyTable)(self.__collectNumDic) then
    return 
  end
  for campId,_ in pairs(ConfigData.camp) do
    local num = 0
    for _,heroId in pairs(((ConfigData.camp).camp2HeroListDic)[campId]) do
      if (PlayerDataCenter.heroDic)[heroId] ~= nil then
        num = num + 1
      end
    end
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__collectNumDic)[campId] = num
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R8 in 'UnsetPending'

    ;
    (self.__collectNumDic)[0] = ((self.__collectNumDic)[0] or 0) + (num)
  end
end

HandBookController.CalSkinThemeCollectNum = function(self, forceRecal)
  -- function num : 0_4 , upvalues : _ENV
  if not forceRecal and not (table.IsEmptyTable)(self._skinThemeNumDic) then
    return 
  end
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._skinThemeNumDic)[0] = 0
  for themeId,skinList in pairs((ConfigData.skin).themeDic) do
    local themeCfg = (ConfigData.skinTheme)[themeId]
    if not themeCfg.lock_theme then
      local num = 0
      for _,skinId in ipairs(skinList) do
        if (PlayerDataCenter.skinData):IsHaveSkin(skinId) then
          num = num + 1
        end
      end
      -- DECOMPILER ERROR at PC39: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._skinThemeNumDic)[themeId] = num
      -- DECOMPILER ERROR at PC44: Confused about usage of register: R9 in 'UnsetPending'

      ;
      (self._skinThemeNumDic)[0] = (self._skinThemeNumDic)[0] + (num)
    end
  end
end

HandBookController.__SkinUpdate = function(self)
  -- function num : 0_5 , upvalues : _ENV, HandBookEnum
  self:CalSkinThemeCollectNum(true)
  local hbSkinListWin = UIManager:GetWindow(UIWindowTypeID.HandBookSkinList)
  if hbSkinListWin ~= nil then
    hbSkinListWin:HBSkinUpdate()
  end
  local mianUI = UIManager:GetWindow(UIWindowTypeID.HandBookMain)
  if mianUI ~= nil then
    mianUI:RefreshHBCollectByType((HandBookEnum.eEnterType).Skin)
  end
end

HandBookController.OpenHandBookMain = function(self, where)
  -- function num : 0_6 , upvalues : _ENV
  self:CalCampHeroCollectNum()
  self:CalSkinThemeCollectNum()
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookBackground, function(bg_win)
    -- function num : 0_6_0 , upvalues : self, _ENV, where
    self:SetHBViewSetLayer(0)
    UIManager:ShowWindowAsync(UIWindowTypeID.HandBookMain, function(win)
      -- function num : 0_6_0_0 , upvalues : where, bg_win
      win:InitHandBookMain()
      win:SetFromWhichUI(where)
      bg_win:HBBGPalyerEnterTween()
    end
)
  end
)
end

HandBookController.OpenHandBookHeroIndex = function(self)
  -- function num : 0_7 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookHeroCampIndex, function(win)
    -- function num : 0_7_0 , upvalues : _ENV, self
    if win == nil then
      return 
    end
    UIManager:HideWindow(UIWindowTypeID.HandBookMain)
    win:InitHBHeroCampIndex(function()
      -- function num : 0_7_0_0 , upvalues : _ENV, self
      UIManager:ShowWindowOnly(UIWindowTypeID.HandBookMain)
      self:SetHBViewSetLayer(0)
    end
)
    self:SetHBViewSetLayer(1, ConfigData:GetTipContent(8302))
  end
)
end

HandBookController.OpenHandBookHeroSkinTheme = function(self)
  -- function num : 0_8 , upvalues : _ENV, HandBookEnum
  self:__GetShopInfo(function(sellSkinShopList)
    -- function num : 0_8_0 , upvalues : _ENV, self, HandBookEnum
    UIManager:ShowWindowAsync(UIWindowTypeID.HandBookSkinList, function(win)
      -- function num : 0_8_0_0 , upvalues : _ENV, sellSkinShopList, self, HandBookEnum
      if IsNull(win) then
        return 
      end
      UIManager:HideWindow(UIWindowTypeID.HandBookMain)
      win:InitHBHeroSkinTheme(sellSkinShopList, function()
        -- function num : 0_8_0_0_0 , upvalues : _ENV, self
        UIManager:ShowWindowOnly(UIWindowTypeID.HandBookMain)
        self:SetHBViewSetLayer(0)
      end
)
      self:SetHBViewSetLayer(1, (LanguageUtil.GetLocaleText)(((ConfigData.handbook)[(HandBookEnum.eEnterType).Skin]).title))
    end
)
  end
)
end

HandBookController.OpenHandBookActivity = function(self, worldPos)
  -- function num : 0_9 , upvalues : _ENV, HandBookEnum
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookActBook, function(win)
    -- function num : 0_9_0 , upvalues : _ENV, worldPos, self, HandBookEnum
    if IsNull(win) then
      return 
    end
    UIManager:HideWindow(UIWindowTypeID.HandBookMain)
    win:InitHandBookActBook(worldPos, function()
      -- function num : 0_9_0_0 , upvalues : _ENV, self
      UIManager:ShowWindowOnly(UIWindowTypeID.HandBookMain)
      self:SetHBViewSetLayer(0)
    end
)
    self:SetHBViewSetLayer(1, (LanguageUtil.GetLocaleText)(((ConfigData.handbook)[(HandBookEnum.eEnterType).Activity]).title))
  end
)
end

HandBookController.__GetShopInfo = function(self, callback)
  -- function num : 0_10 , upvalues : ShopUtil
  if callback == nil then
    return 
  end
  local needReqShopIds = (ShopUtil.GetSkinShopIdList)()
  local sellSkinShopList = {}
  if #needReqShopIds > 0 then
    self:__ReqShop(1, needReqShopIds, sellSkinShopList, callback)
  else
    callback(sellSkinShopList)
  end
end

HandBookController.__ReqShop = function(self, index, needReqShopIds, sellSkinShopList, callback)
  -- function num : 0_11 , upvalues : _ENV
  local shopCtr = ControllerManager:GetController(ControllerTypeId.Shop)
  local shopId = needReqShopIds[index]
  shopCtr:GetShopData(shopId, function(shopData)
    -- function num : 0_11_0 , upvalues : _ENV, sellSkinShopList, index, needReqShopIds, callback, self
    (table.insert)(sellSkinShopList, shopData)
    if #needReqShopIds <= index then
      callback(sellSkinShopList)
    else
      self:__ReqShop(index + 1, needReqShopIds, sellSkinShopList, callback)
    end
  end
)
end

HandBookController.GetHBHeroAllCollect = function(self)
  -- function num : 0_12 , upvalues : _ENV
  return (self.__collectNumDic)[0], (ConfigData.hero_data).totalHeroCount
end

HandBookController.GetHBSkinAllCollect = function(self)
  -- function num : 0_13 , upvalues : _ENV
  return (self._skinThemeNumDic)[0], (ConfigData.skin).hbSkinCount
end

HandBookController.GetCampHeroCollectRate = function(self, campId)
  -- function num : 0_14 , upvalues : _ENV
  return ((self.__collectNumDic)[campId] or 0) / (((ConfigData.camp).camp2HeroNumDic)[campId] or 1)
end

HandBookController.GetCampHeroCollectNum = function(self, campId)
  -- function num : 0_15 , upvalues : _ENV
  return (self.__collectNumDic)[campId] or 0, ((ConfigData.camp).camp2HeroNumDic)[campId] or 0
end

HandBookController.GetSkinThemeCollectNum = function(self, themeId)
  -- function num : 0_16
  return (self._skinThemeNumDic)[themeId] or 0
end

HandBookController.SetHBViewSetLayer = function(self, layer, name)
  -- function num : 0_17 , upvalues : _ENV
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  if name ~= nil then
    (self.__viewLayerList)[layer] = name
  end
  local bgWin = UIManager:GetWindow(UIWindowTypeID.HandBookBackground)
  if bgWin ~= nil then
    if layer <= 0 then
      bgWin:ShowHBBGSetTop(false)
      bgWin:ShowHBBGTime(true)
      return 
    end
    bgWin:ShowHBBGSetTop(true)
    bgWin:ShowHBBGTime(false)
    local index = layer - 1
    bgWin:HBBGSetTop(index, self.__viewLayerList)
  end
end

HandBookController.__OnHeroSkinChange = function(self, heroId, skinId)
  -- function num : 0_18 , upvalues : _ENV
  local listWin = UIManager:GetWindow(UIWindowTypeID.HandBookHeroCampHeroList)
  local relationWin = UIManager:GetWindow(UIWindowTypeID.HandbookHeroRelation)
  if listWin ~= nil then
    listWin:HBHLOnHeroSkinChange(heroId)
  end
  if relationWin ~= nil then
    relationWin:HBHROnHeroSkinChange(heroId)
  end
end

HandBookController.__OnHeroUpdate = function(self, heroUpdateDic, hasNew)
  -- function num : 0_19 , upvalues : _ENV, HandBookEnum
  if not hasNew then
    return 
  end
  self:CalCampHeroCollectNum(true)
  local indexWin = UIManager:GetWindow(UIWindowTypeID.HandBookHeroCampIndex)
  local listWin = UIManager:GetWindow(UIWindowTypeID.HandBookHeroCampHeroList)
  if indexWin ~= nil then
    indexWin:HBCIRefreshCollectRate()
  end
  if listWin ~= nil then
    listWin:RefreshHeroCollect()
  end
  local mianUI = UIManager:GetWindow(UIWindowTypeID.HandBookMain)
  if mianUI ~= nil then
    mianUI:RefreshHBCollectByType((HandBookEnum.eEnterType).Hero)
  end
end

HandBookController.__Precondition = function(self)
  -- function num : 0_20 , upvalues : _ENV
  local mianUI = UIManager:GetWindow(UIWindowTypeID.HandBookMain)
  if mianUI ~= nil then
    mianUI:CheckAndRefreshCollect()
  end
end

HandBookController.ReqWhiteHistoryData = function(self, actId, callback)
  -- function num : 0_21 , upvalues : SendSingle, _ENV, SendSingleOver
  if (self._whiteHistoryMsgDic)[actId] ~= nil then
    if callback ~= nil then
      callback((self._whiteHistoryMsgDic)[actId])
    end
    return 
  end
  SendSingle(function()
    -- function num : 0_21_0 , upvalues : _ENV, actId, self, callback, SendSingleOver
    local whiteDayNetWork = NetworkManager:GetNetwork(NetworkTypeID.WhiteDay)
    whiteDayNetWork:CS_Activity_Polariod_History(actId, function(args)
      -- function num : 0_21_0_0 , upvalues : _ENV, self, actId, callback, SendSingleOver
      if args.Count == 0 then
        error("args.Count == 0")
        return 
      end
      local activityPolariodData = args[0]
      -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

      ;
      (self._whiteHistoryMsgDic)[actId] = activityPolariodData
      if callback ~= nil then
        callback(activityPolariodData)
      end
      SendSingleOver()
    end
)
  end
)
end

HandBookController.OnDelete = function(self)
  -- function num : 0_22 , upvalues : _ENV, eDynConfigData
  ConfigData:ReleaseDynCfg(eDynConfigData.hero_relationship)
  MsgCenter:RemoveListener(eMsgEventId.PreCondition, self.__PreconditionCallback)
  MsgCenter:RemoveListener(eMsgEventId.OnHeroSkinChange, self.__onHeroSkinChange)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHero, self.__onHeroUpdate)
  MsgCenter:RemoveListener(eMsgEventId.UpdateHeroSkin, self.__SkinUpdateCallback)
end

return HandBookController

