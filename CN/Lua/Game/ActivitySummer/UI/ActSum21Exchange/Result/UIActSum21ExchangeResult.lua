-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActSum21ExchangeResult = class("UIActSum21ExchangeResult", UIBaseWindow)
local base = UIBaseWindow
local UINActSum21ExcgResultItem = require("Game.ActivitySummer.UI.ActSum21Exchange.Result.UINActSum21ExcgResultItem")
UIActSum21ExchangeResult.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self._OnClickClose)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onInstantiateItem = BindCallback(self, self.__OnNewItem)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).scrollRect).onChangeItem = BindCallback(self, self.__OnChangeItem)
  self._ItemDic = {}
end

UIActSum21ExchangeResult.InitActSum21ExchangeResult = function(self, rewardDataList, closeFunc)
  -- function num : 0_1
  self.rewardDataList = rewardDataList
  self.closeFunc = closeFunc
  self:_RefillScrollRect()
end

UIActSum21ExchangeResult._RefillScrollRect = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).scrollRect).totalCount = #self.rewardDataList
  ;
  ((self.ui).scrollRect):RefillCells()
end

UIActSum21ExchangeResult.__OnNewItem = function(self, go)
  -- function num : 0_3 , upvalues : UINActSum21ExcgResultItem
  local item = (UINActSum21ExcgResultItem.New)()
  item:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._ItemDic)[go] = item
end

UIActSum21ExchangeResult.__OnChangeItem = function(self, go, index)
  -- function num : 0_4 , upvalues : _ENV
  local item = (self._ItemDic)[go]
  if item == nil then
    error("Can\'t find item by gameObject")
    return 
  end
  local rewardData = (self.rewardDataList)[index + 1]
  if rewardData == nil then
    error("Can\'t find rewardData by index, index = " .. tonumber(index))
  end
  item:InitActSum21ExcgResultItem(rewardData.itemId, rewardData.itemNum, rewardData.groupNum)
end

UIActSum21ExchangeResult._OnClickClose = function(self)
  -- function num : 0_5
  self:Delete()
  if self.closeFunc ~= nil then
    (self.closeFunc)()
  end
end

UIActSum21ExchangeResult.OnDelete = function(self)
  -- function num : 0_6 , upvalues : _ENV, base
  for k,v in pairs(self._ItemDic) do
    v:Delete()
  end
  DestroyUnityObject((self.ui).scrollRect)
  ;
  (base.OnDelete)(self)
end

return UIActSum21ExchangeResult

