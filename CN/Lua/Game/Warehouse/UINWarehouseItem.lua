-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarehouseItem = class("UINWarehouseItem", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINWarehouseItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.item = (UINBaseItemWithCount.New)()
  ;
  (self.item):Init((self.ui).uINBaseItemWithCount)
end

UINWarehouseItem.InitWarehouseItem = function(self, itemCfg, count, clickEvent, wareHouseNum)
  -- function num : 0_1 , upvalues : _ENV
  self.itemCfg = itemCfg
  self.outTime = nil
  ;
  (self.item):InitItemWithCount(itemCfg, count, clickEvent, wareHouseNum, BindCallback(self, self.OnClickExtra))
  self:RefreshRedDotState()
end

UINWarehouseItem.InitWarehouseDynLimitTimeItem = function(self, itemCfg, stackInfo, clickEvent, wareHouseNum)
  -- function num : 0_2 , upvalues : _ENV
  self.itemCfg = itemCfg
  self.outTime = stackInfo.time
  ;
  (self.item):InitItemWithCount(itemCfg, stackInfo.num, clickEvent, wareHouseNum, BindCallback(self, self.OnClickExtra))
  ;
  (self.item):BindClickCustomArg(stackInfo)
  self:RefreshRedDotState()
  self:UpdateLimitTimeDetail()
end

UINWarehouseItem.InitWarehouseLimitTimeItem = function(self, itemCfg, count, outTime, clickEvent, wareHouseNum)
  -- function num : 0_3 , upvalues : _ENV
  self.itemCfg = itemCfg
  self.outTime = outTime
  ;
  (self.item):InitItemWithCount(itemCfg, count, clickEvent, wareHouseNum, BindCallback(self, self.OnClickExtra))
  self:RefreshRedDotState()
  self:UpdateLimitTimeDetail()
end

UINWarehouseItem.UpdateLimitTimeDetail = function(self)
  -- function num : 0_4
  if self.outTime ~= nil then
    (self.item):ShowLimtTimeDetail(self.outTime)
  end
end

UINWarehouseItem.RefreshRedDotState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local ok, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Warehouse, (self.itemCfg).warehouse_page, (self.itemCfg).id)
  if node:GetRedDotCount() <= 0 then
    ((self.ui).blueDot):SetActive(not ok)
    ;
    ((self.ui).blueDot):SetActive(false)
    -- DECOMPILER ERROR: 3 unprocessed JMP targets
  end
end

UINWarehouseItem.OnClickExtra = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local ok, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Warehouse, (self.itemCfg).warehouse_page, (self.itemCfg).id)
  if ok and node:GetRedDotCount() > 0 then
    node:SetRedDotCount(0)
    local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
    saveUserData:SetNewGiftItemReddot((self.itemCfg).id, nil)
  end
end

UINWarehouseItem.SetNum = function(self, num)
  -- function num : 0_7
  (self.item):SetNum(num)
end

return UINWarehouseItem

