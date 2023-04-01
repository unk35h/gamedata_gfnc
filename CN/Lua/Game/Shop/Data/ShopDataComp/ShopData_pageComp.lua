-- params : ...
-- function num : 0 , upvalues : _ENV
local ShopData_pageComp = class("ShopData_pageComp")
ShopData_pageComp.ctor = function(self)
  -- function num : 0_0
end

ShopData_pageComp.UpdateShopDataComp = function(self, shopData, shopDataMsg)
  -- function num : 0_1
  self.shopData = shopData
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.shopData).shopPagesDic = {}
  self:__SplitShopGoods2Page(shopData)
end

ShopData_pageComp.GetShopPagesDic = function(self)
  -- function num : 0_2
  return (self.shopData).shopPagesDic
end

ShopData_pageComp.HasShopGoodsInPage = function(self, pageId)
  -- function num : 0_3 , upvalues : _ENV
  local pageData = ((self.shopData).shopPagesDic)[pageId]
  if pageData == nil or pageData.shelfIds == nil then
    return false
  end
  for _,shelfId in ipairs(pageData.shelfIds) do
    local goods = ((self.shopData).shopGoodsDic)[shelfId]
    if goods ~= nil then
      local hasTime, inTime = goods:GetStillTime()
      if not hasTime or inTime then
        return true
      end
    end
  end
  return false
end

ShopData_pageComp.__SplitShopGoods2Page = function(self, shopData)
  -- function num : 0_4 , upvalues : _ENV
  for shelfId,goodData in pairs(shopData.shopGoodsDic) do
    if goodData.pageId == nil then
      error("normal shop doog don\'t have page shelfId=" .. tostring(shelfId))
    else
      do
        do
          if ((self.shopData).shopPagesDic)[goodData.pageId] == nil then
            local name = nil
            if (ConfigData.shop_page)[goodData.pageId] == nil or ((ConfigData.shop_page)[goodData.pageId]).page == nil then
              name = ""
            else
              name = ((ConfigData.shop_page)[goodData.pageId]).page
            end
            -- DECOMPILER ERROR at PC46: Confused about usage of register: R8 in 'UnsetPending'

            ;
            ((self.shopData).shopPagesDic)[goodData.pageId] = {}
            -- DECOMPILER ERROR at PC51: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (((self.shopData).shopPagesDic)[goodData.pageId]).name = name
            -- DECOMPILER ERROR at PC57: Confused about usage of register: R8 in 'UnsetPending'

            ;
            (((self.shopData).shopPagesDic)[goodData.pageId]).shelfIds = {}
          end
          ;
          (table.insert)((((self.shopData).shopPagesDic)[goodData.pageId]).shelfIds, shelfId)
          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC67: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

return ShopData_pageComp

