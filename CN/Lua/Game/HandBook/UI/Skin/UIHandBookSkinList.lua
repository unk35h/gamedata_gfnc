-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHandBookSkinList = class("UIHandBookSkinList", UIBaseWindow)
local base = UIBaseWindow
local UINHBHeroSkinTheme = require("Game.HandBook.UI.Skin.UINHBHeroSkinTheme")
local CS_Resloader = CS.ResLoader
local ShopEnum = require("Game.Shop.ShopEnum")
local UINSortButtonItem = require("Game.Hero.NewUI.SortList.UINSortButtonItem")
UIHandBookSkinList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_Resloader, UINHBHeroSkinTheme, UINSortButtonItem
  (UIUtil.SetTopStatus)(self, self.OnClickThemeClose)
  self._resloder = (CS_Resloader.Create)()
  self.__OpenThemeDetailCallback = BindCallback(self, self.__OpenThemeDetail)
  self._itemPool = (UIItemPool.New)(UINHBHeroSkinTheme, (self.ui).skinItem)
  ;
  ((self.ui).skinItem):SetActive(false)
  self._themeCfgList = {}
  self._sellThemeDic = {}
  self._actThemeDic = {}
  self._sortNode = (UINSortButtonItem.New)()
  ;
  (self._sortNode):Init((self.ui).SortBtnItem)
  ;
  (self._sortNode):InitSortButtonItem(0, false, function()
    -- function num : 0_0_0 , upvalues : self
    self:OnClickSortItem()
  end
)
  ;
  (self._sortNode):RefeshSortStateUI()
  self.__OnActivityShowChangeCallback = BindCallback(self, self.__OnActivityShowChange)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChangeCallback)
end

UIHandBookSkinList.InitHBHeroSkinTheme = function(self, sellSkinShopList, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._hbCtrl = ControllerManager:GetController(ControllerTypeId.HandBook)
  self._shopList = sellSkinShopList
  self._callback = callback
  for themeId,themeCfg in pairs(ConfigData.skinTheme) do
    local isAtLeastHaveOneUnlockedSkin = false
    for _,skinId in pairs(((ConfigData.skin).themeDic)[themeId]) do
      if (PlayerDataCenter.skinData):IsSkinUnlocked(skinId) then
        isAtLeastHaveOneUnlockedSkin = true
        break
      end
    end
    do
      do
        if not themeCfg.lock_theme and isAtLeastHaveOneUnlockedSkin then
          (table.insert)(self._themeCfgList, themeCfg)
        end
        -- DECOMPILER ERROR at PC42: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  local timeDic = {}
  for _,shop in ipairs(self._shopList) do
    for _,goods in pairs(shop.shopGoodsDic) do
      local flag, inTime, startTime, endTime = goods:GetStillTime()
      if flag then
        if PlayerDataCenter.timestamp < startTime then
          timeDic[startTime] = true
        end
        if PlayerDataCenter.timestamp < endTime then
          timeDic[endTime] = true
        end
      end
    end
  end
  self._conditionTimeList = {}
  for k,v in pairs(timeDic) do
    (table.insert)(self._conditionTimeList, k)
  end
  ;
  (table.sort)(self._conditionTimeList, function(a, b)
    -- function num : 0_1_0
    do return b < a end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self:__RecellThemes()
  if #self._conditionTimeList > 0 then
    if self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
    self._timerId = TimerManager:StartTimer(1, self.__CountDown, self)
  end
end

UIHandBookSkinList.__RecellThemes = function(self)
  -- function num : 0_2 , upvalues : _ENV
  (table.clearmap)(self._sellThemeDic)
  ;
  (table.clearmap)(self._actThemeDic)
  for _,shop in ipairs(self._shopList) do
    for _,goods in pairs(shop.shopGoodsDic) do
      local skinCfg = (ConfigData.skin)[goods.itemId]
      if skinCfg ~= nil then
        local flag, inTime, _, _ = goods:GetStillTime()
        -- DECOMPILER ERROR at PC30: Confused about usage of register: R16 in 'UnsetPending'

        if not flag or inTime then
          (self._sellThemeDic)[skinCfg.theme] = true
        end
      end
    end
  end
  local activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  for _,themeCfg in ipairs(self._themeCfgList) do
    local actFrameIdDic = ((ConfigData.skin).themeActivityDic)[themeCfg.id]
    if actFrameIdDic ~= nil then
      for actFrameId,_ in pairs(actFrameIdDic) do
        local activityData = activityCtrl:GetActivityFrameData(actFrameId)
        -- DECOMPILER ERROR at PC66: Confused about usage of register: R14 in 'UnsetPending'

        if activityData ~= nil and activityData:IsActivityOpen() then
          (self._actThemeDic)[themeCfg.id] = true
          break
        end
      end
    end
  end
  self:__SortItem()
end

UIHandBookSkinList.HBSkinUpdate = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for _,item in ipairs((self._itemPool).listItem) do
    local themeId = item:GetHBThemeId()
    local count = (self._hbCtrl):GetSkinThemeCollectNum(themeId)
    item:RefreshHBThemeCollect(count)
  end
  local singleThemeUI = UIManager:GetWindow(UIWindowTypeID.HandBookSkin)
  do
    if singleThemeUI ~= nil then
      local themeId = singleThemeUI:GetHBSkinThemeId()
      singleThemeUI:RefreshHBSkinCollect((self._sellThemeDic)[themeId] ~= nil)
      singleThemeUI:RefreshHBSkinItems()
    end
    -- DECOMPILER ERROR: 2 unprocessed JMP targets
  end
end

UIHandBookSkinList.__CountDown = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local needRefresh = self._needToRefreshTheme
  if not needRefresh then
    for i = #self._conditionTimeList, 1, -1 do
      if (self._conditionTimeList)[i] < PlayerDataCenter.timestamp then
        needRefresh = true
        ;
        (table.remove)(self._conditionTimeList, i)
      else
        break
      end
    end
  end
  do
    if not needRefresh then
      return 
    end
    self._needToRefreshTheme = false
    self:__RecellThemes()
    local singleThemeUI = UIManager:GetWindow(UIWindowTypeID.HandBookSkin)
    do
      if singleThemeUI ~= nil then
        local themeId = singleThemeUI:GetHBSkinThemeId()
        singleThemeUI:RefreshHBSkinCollect((self._sellThemeDic)[themeId] ~= nil)
      end
      if #self._conditionTimeList == 0 and self._timerId ~= nil then
        TimerManager:StopTimer(self._timerId)
        self._timerId = nil
      end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
end

UIHandBookSkinList.__OpenThemeDetail = function(self, themeItem)
  -- function num : 0_5 , upvalues : _ENV
  local themeId = themeItem:GetHBThemeId()
  local worldPos = (themeItem.transform).position
  UIManager:ShowWindowAsync(UIWindowTypeID.HandBookSkin, function(win)
    -- function num : 0_5_0 , upvalues : _ENV, self, themeId, worldPos
    if IsNull(win) then
      return 
    end
    self:Hide()
    win:InitHBSkinThemeSingle(themeId, (self._sellThemeDic)[themeId] ~= nil, function()
      -- function num : 0_5_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Show()
        ;
        (self._hbCtrl):SetHBViewSetLayer(1)
      end
    end
)
    win:PlayeHBSkinAni(worldPos)
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
end

UIHandBookSkinList.OnClickSortItem = function(self)
  -- function num : 0_6
  (self._sortNode):ReversalAscend()
  self:__SortItem()
end

UIHandBookSkinList.__OnActivityShowChange = function(self)
  -- function num : 0_7
  if self._timerId ~= nil then
    self._needToRefreshTheme = true
  else
    self:__RecellThemes()
  end
end

UIHandBookSkinList.__SortItem = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local isAscend = (self._sortNode).isAscend
  if isAscend then
    (table.sort)(self._themeCfgList, function(a, b)
    -- function num : 0_8_0 , upvalues : self
    if (self._sellThemeDic)[a.id] ~= (self._sellThemeDic)[b.id] then
      return (self._sellThemeDic)[a.id]
    end
    if not (self._sellThemeDic)[a.id] and (self._actThemeDic)[a.id] ~= (self._actThemeDic)[b.id] then
      return (self._actThemeDic)[a.id]
    end
    do return a.id < b.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  else
    ;
    (table.sort)(self._themeCfgList, function(a, b)
    -- function num : 0_8_1 , upvalues : self
    if (self._sellThemeDic)[a.id] ~= (self._sellThemeDic)[b.id] then
      return (self._sellThemeDic)[a.id]
    end
    if not (self._sellThemeDic)[a.id] and (self._actThemeDic)[a.id] ~= (self._actThemeDic)[b.id] then
      return (self._actThemeDic)[a.id]
    end
    do return b.id < a.id end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  end
  ;
  (self._itemPool):HideAll()
  for index,themeCfg in ipairs(self._themeCfgList) do
    local item = (self._itemPool):GetOne()
    local count = (self._hbCtrl):GetSkinThemeCollectNum(themeCfg.id)
    item:InitHBThemeItem(themeCfg, count, self._resloder, self.__OpenThemeDetailCallback)
    if (self._sellThemeDic)[themeCfg.id] ~= nil then
      item:SetHBHeroSkinThemeTag(1)
    end
    if (self._actThemeDic)[themeCfg.id] ~= nil then
      item:SetHBHeroSkinThemeTag(2)
    end
    item:PlayHBHeroSkinThemTween(index * 0.033)
  end
end

UIHandBookSkinList.OnClickThemeClose = function(self)
  -- function num : 0_9
  self:Delete()
  if self._callback ~= nil then
    (self._callback)()
  end
end

UIHandBookSkinList.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base, _ENV
  (self._itemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
  ;
  (self._resloder):Put2Pool()
  self._resloder = nil
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__OnActivityShowChangeCallback)
end

return UIHandBookSkinList

