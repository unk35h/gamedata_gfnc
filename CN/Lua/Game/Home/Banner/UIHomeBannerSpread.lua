-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHomeBannerSpread = class("UIHomeBannerSpread", UIBaseWindow)
local base = UIBaseWindow
local UINHomeBannerPicItem = require("Game.Home.Banner.UINHomeBannerPicItem")
local HomeBannerManager = require("Game.Home.Banner.HomeBannerManager")
UIHomeBannerSpread.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.advItemDic = {}
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.__OnClickBackground)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll_advList).onInstantiateItem = BindCallback(self, self.__OnInstantiateAdvItem)
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scroll_advList).onChangeItem = BindCallback(self, self.__OnChangeAdvItem)
end

UIHomeBannerSpread.SetSpreadBannerProperty = function(self, bannerLoopList, bannerDataList)
  -- function num : 0_1
  self.bannerLoopList = bannerLoopList
  self.bannerDataList = bannerDataList
  self:UpdateAdvItemShow()
end

UIHomeBannerSpread.UpdateAdvItemShow = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).scroll_advList).totalCount = #self.bannerDataList
  ;
  ((self.ui).scroll_advList):RefillCells()
end

UIHomeBannerSpread.__OnClickBackground = function(self)
  -- function num : 0_3
  self:Delete()
end

UIHomeBannerSpread.__OnChangeAdvItem = function(self, go, index)
  -- function num : 0_4 , upvalues : _ENV
  local advItem = (self.advItemDic)[go]
  advItem:InitHomeBannerPicItem((self.bannerDataList)[index + 1])
  ;
  (UIUtil.AddButtonListener)((advItem.ui).button, self, self.__OnClickBackground)
end

UIHomeBannerSpread.__OnInstantiateAdvItem = function(self, go)
  -- function num : 0_5 , upvalues : UINHomeBannerPicItem
  local advItem = (UINHomeBannerPicItem.New)()
  advItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.advItemDic)[go] = advItem
end

UIHomeBannerSpread.OnHide = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local homeWin = UIManager:GetWindow(UIWindowTypeID.Home)
  if homeWin ~= nil and (homeWin.homeLeftNode).bannerUI ~= nil then
    ((homeWin.homeLeftNode).bannerUI):Show()
  else
    if homeWin ~= nil then
      (homeWin.homeLeftNode):RefreshBannerWidget()
    end
  end
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R2 in 'UnsetPending'

  if self.bannerLoopList ~= nil then
    (self.bannerLoopList).__isAutoPlay = true
  end
end

UIHomeBannerSpread.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  if self.advItemDic ~= nil then
    for i,v in pairs(self.advItemDic) do
      v:Delete()
    end
    self.advItemDic = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIHomeBannerSpread

