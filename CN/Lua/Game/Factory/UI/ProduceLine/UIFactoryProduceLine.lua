-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFactoryProduceLine = class("UIFactoryProduceLine", UIBaseWindow)
local base = UIBaseWindow
local UINFactoryProduceLineItem = require("Game.Factory.UI.ProduceLine.UINFactoryProduceLineItem")
UIFactoryProduceLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINFactoryProduceLineItem
  self.factoryController = ControllerManager:GetController(ControllerTypeId.Factory, false)
  ;
  ((((UIUtil.CreateNewTopStatusData)(self)):SetTopStatusBackAction(self.BackAction)):SetTopStatusVisible(true)):PushTopStatusDataToBackStack()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickReturn)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.OnClickReturn)
  self.lineItemPool = (UIItemPool.New)(UINFactoryProduceLineItem, (self.ui).obj_productItem)
  ;
  (((self.ui).obj_productItem).gameObject):SetActive(false)
end

UIFactoryProduceLine.InitAllLines = function(self)
  -- function num : 0_1 , upvalues : _ENV
  (self.lineItemPool):HideAll()
  for index,processingDatas in pairs((self.factoryController).ProcessingOrders) do
    for uid,processingData in pairs(processingDatas) do
      local item = (self.lineItemPool):GetOne()
      item:InitProduceLineItem(processingData)
    end
  end
  ;
  ((self.ui).obj_emptyState):SetActive(#(self.lineItemPool).listItem <= 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIFactoryProduceLine.RefreshEnergey = function(self)
  -- function num : 0_2 , upvalues : _ENV
  for _,lineItem in ipairs((self.lineItemPool).listItem) do
    lineItem:RefreshEnergey()
  end
end

UIFactoryProduceLine.OnTimeRefresh = function(self)
  -- function num : 0_3 , upvalues : _ENV
  for _,lineItem in ipairs((self.lineItemPool).listItem) do
    lineItem:OnTimeUpdate()
  end
end

UIFactoryProduceLine.BackAction = function(self)
  -- function num : 0_4
  self:Delete()
end

UIFactoryProduceLine.OnClickReturn = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (UIUtil.OnClickBackByUiTab)(self)
end

UIFactoryProduceLine.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  if self.lineItemPool ~= nil then
    (self.lineItemPool):DeleteAll()
    self.lineItemPool = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIFactoryProduceLine

