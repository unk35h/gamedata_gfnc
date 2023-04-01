-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivitySummer.Year22.Shop.UIActSum22Shop")
local UIWinter23Shop = class("UIWinter23Shop", base)
local UINCommonActivityBG = require("Game.ActivityFrame.UI.UINCommonActivityBG")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local cs_ResLoader = CS.ResLoader
UIWinter23Shop.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, UINCommonActivityBG, cs_ResLoader
  (base.OnInit)(self)
  self._actBgNode = (UINCommonActivityBG.New)()
  ;
  (self._actBgNode):Init((self.ui).uI_CommonActivityBG)
  self._resloader = (cs_ResLoader.Create)()
end

UIWinter23Shop.__SetNewClassNode = function(self)
  -- function num : 0_1 , upvalues : _ENV
  self.class_ShopGoodsItem = require("Game.ActivityWinter23.UI.Shop.UINWinter23ShopGoodsItem")
  self.class_ShopPage = require("Game.ActivityWinter23.UI.Shop.UINWinter23ShopPage")
  self.isTimeShotTitle = true
end

UIWinter23Shop.__SetCoin = function(self)
  -- function num : 0_2
end

UIWinter23Shop.__CancleCoin = function(self)
  -- function num : 0_3
end

UIWinter23Shop.__CoinRefresh = function(self)
  -- function num : 0_4
end

UIWinter23Shop.BindRedShopFunc = function(self, func)
  -- function num : 0_5
  self._redFunc = func
end

UIWinter23Shop.BindSelectShopFunc = function(self, func)
  -- function num : 0_6
  self._selectFunc = func
end

UIWinter23Shop.InitSum22ShopByShopList = function(self, activityBase, shopList, showToken, callback)
  -- function num : 0_7 , upvalues : base, _ENV
  (base.InitSum22ShopByShopList)(self, activityBase, shopList, showToken, callback)
  ;
  (UIUtil.RefreshTopResId)({self._showToken})
  if self._redFunc ~= nil then
    local count = #(self._shopSelectItemPool).listItem
    for i,v in ipairs((self._shopSelectItemPool).listItem) do
      v:SetWinter23ShopRed((self._redFunc)(shopList[i]))
      if i == count then
        v:HideWinter23ShopLine()
      end
    end
  end
  do
    ;
    (self._actBgNode):InitActivityBG(activityBase:GetActFrameId(), self._resloader)
  end
end

UIWinter23Shop.__OnSelectShop = function(self, shopId, item)
  -- function num : 0_8 , upvalues : base
  if self._isReqing then
    return 
  end
  ;
  (base.__OnSelectShop)(self, shopId, item)
  local pos = (((self.ui).obj_Selected).transform).anchoredPosition
  pos.y = ((item.transform).anchoredPosition).y
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  (((self.ui).obj_Selected).transform).anchoredPosition = pos
  if self._selectFunc ~= nil then
    (self._selectFunc)(shopId)
  end
  if self._redFunc ~= nil then
    item:SetWinter23ShopRed(false)
  end
end

UIWinter23Shop.__RefreShopTitle = function(self)
  -- function num : 0_9
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  if ((self._shopData).shopCfg).is_recommended then
    ((self.ui).img_top).color = (self.ui).color_recommend
  else
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_top).color = (self.ui).color_normal
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_TitleName).text = (self._shopData).shopName
end

UIWinter23Shop.__RefreshTime = function(self)
  -- function num : 0_10 , upvalues : _ENV, ActivityFrameUtil
  if self._expireTime or 0 == 0 then
    self._expireTime = (self._activityBase):GetActivityDestroyTime()
    local date = TimeUtil:TimestampToDate(self._expireTime, false, true)
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Time).text = (string.format)("%02d/%02d %02d:%02d", date.month, date.day, date.hour, date.min)
  end
  do
    local timeStr, time = (ActivityFrameUtil.GetCountdownTimeStr)(self._expireTime, self.isTimeShotTitle)
    if time <= 0 and self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_countdown).text = timeStr
  end
end

UIWinter23Shop.__RefreShopTitle = function(self)
  -- function num : 0_11
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  if ((self._shopData).shopCfg).is_recommended then
    ((self.ui).img_top).color = (self.ui).color_recommend
    ;
    ((self.ui).tex_TitleName):SetIndex(0)
  else
    -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_top).color = (self.ui).color_normal
    ;
    ((self.ui).tex_TitleName):SetIndex(1, (self._shopData).shopName)
  end
end

UIWinter23Shop.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIWinter23Shop

