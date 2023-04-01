-- params : ...
-- function num : 0 , upvalues : _ENV
local UIFactoryQuickProduce = class("UIFactoryQuickProduce", UIBaseWindow)
local base = UIBaseWindow
local UINFactoryOrderNode = require("Game.Factory.UI.UINFactoryOrderNode")
UIFactoryQuickProduce.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINFactoryOrderNode
  self.factoryController = ControllerManager:GetController(ControllerTypeId.Factory, false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnclickClose)
  ;
  (((self.ui).tween_factoryOrderNode).onRewind):AddListener(BindCallback(self, self.Delete))
  ;
  (((self.ui).tween_factoryOrderNode).onComplete):AddListener(BindCallback(self, self.OnTweenComplete))
  self.factoryOrderNode = (UINFactoryOrderNode.New)(true)
  ;
  (self.factoryOrderNode):Init((self.ui).factoryOrderNode)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.factoryOrderNode).ui).quickPurchaseRoot = (self.ui).quickPurchaseRoot
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self.factoryOrderNode).closeQuickProduceNode = BindCallback(self, self.OnclickClose)
end

UIFactoryQuickProduce.OpenQuickProduce = function(self, targetOrderData, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tween_factoryOrderNode):DOPlayForward()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).fade).blocksRaycasts = false
  AudioManager:PlayAudioById(1070)
  ;
  (self.factoryOrderNode):InitOrderNode(targetOrderData:GetOrderRoomIndex())
  ;
  (self.factoryOrderNode):ShowOrder(targetOrderData)
  ;
  (self.factoryOrderNode):SetCloseCommonRewardCallback(function()
    -- function num : 0_1_0 , upvalues : self, closeCallback
    self:OnclickClose()
    if closeCallback ~= nil then
      closeCallback()
    end
  end
)
end

UIFactoryQuickProduce.OnclickClose = function(self)
  -- function num : 0_2
  self:OrderNodesPlayOver()
end

UIFactoryQuickProduce.OrderNodesPlayOver = function(self)
  -- function num : 0_3 , upvalues : _ENV
  ((self.ui).tween_factoryOrderNode):DOPlayBackwards()
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fade).blocksRaycasts = false
  AudioManager:PlayAudioById(1071)
end

UIFactoryQuickProduce.OnTweenComplete = function(self)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).fade).blocksRaycasts = true
end

UIFactoryQuickProduce.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self.factoryOrderNode):Delete()
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).fade).blocksRaycasts = true
  ;
  (base.OnDelete)(self)
end

return UIFactoryQuickProduce

