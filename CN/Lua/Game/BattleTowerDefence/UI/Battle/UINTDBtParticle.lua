-- params : ...
-- function num : 0 , upvalues : _ENV
local UINTDBtParticle = class("UINTDBtParticle", UIBaseNode)
local base = UIBaseNode
local UINTDBtCoinAddItem = require("Game.BattleTowerDefence.UI.Battle.UINTDBtCoinAddItem")
UINTDBtParticle.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINTDBtCoinAddItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._returnCoinAddFxFunc = BindCallback(self, self._ReturnCoinAddFx)
  ;
  ((self.ui).fX_CoinAdd):SetActive(false)
  self.coinAddItemPool = (UIItemPool.New)(UINTDBtCoinAddItem, (self.ui).fX_CoinAdd)
end

UINTDBtParticle.InitTDBtParticle = function(self)
  -- function num : 0_1
end

UINTDBtParticle.TDBtPlayCoinAddFx = function(self, coinNum, position)
  -- function num : 0_2
  local coinAddItem = (self.coinAddItemPool):GetOne()
  coinAddItem:InitTDBtCoinAddItem(coinNum, position, self._returnCoinAddFxFunc)
end

UINTDBtParticle._ReturnCoinAddFx = function(self, coinAddItem)
  -- function num : 0_3
  (self.coinAddItemPool):HideOne(coinAddItem)
end

UINTDBtParticle.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.coinAddItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINTDBtParticle

