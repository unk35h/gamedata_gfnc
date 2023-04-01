-- params : ...
-- function num : 0 , upvalues : _ENV
local UINShopTogs = class("UINShopTogs", UIBaseNode)
local base = UIBaseNode
local ShopEnum = require("Game.Shop.ShopEnum")
local JumpManager = require("Game.Jump.JumpManager")
local UINShopShelfTog = require("Game.Shop.UINShopShelfTog")
UINShopTogs.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINShopShelfTog
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.shelfTypeTogPool = (UIItemPool.New)(UINShopShelfTog, (self.ui).obj_tog_ShelfType)
  ;
  ((self.ui).obj_tog_ShelfType):SetActive(false)
end

UINShopTogs.InitShopTogs = function(self, shopCtrl, resloader, onClickTogFunc)
  -- function num : 0_1
  self.shopCtrl = shopCtrl
  self.resloader = resloader
  self.onClickTogFunc = onClickTogFunc
end

UINShopTogs.RefreshShopTogs = function(self, shopId, shopData, autoSelectShelfId, autoSelectPageId)
  -- function num : 0_2 , upvalues : _ENV, ShopEnum
  local shopCfg = (ConfigData.shop)[shopId]
  local pageList = {}
  if shopCfg.shop_type == (ShopEnum.eShopType).Recommend then
    for _,pageId in ipairs(shopCfg.shop_para) do
      local pageCfg = (ConfigData.shop_page)[pageId]
      if pageCfg ~= nil and pageCfg.imgs ~= nil and self:_CheckRecommendValid(pageCfg) then
        (table.insert)(pageList, pageId)
      end
    end
  else
    do
      if shopCfg.shop_type == (ShopEnum.eShopType).PayGift then
        local payGiftCtrl = ControllerManager:GetController(ControllerTypeId.PayGift, true)
        local pageDic = {}
        for k,v in pairs(payGiftCtrl.dataDic) do
          if pageDic[(v.groupCfg).inPage] == nil and v:IsUnlock() and (v.needRefresh or not v:IsSoldOut()) and shopCfg.id == (v.groupCfg).inShop then
            pageDic[(v.groupCfg).inPage] = true
          end
        end
        for pageId,_ in pairs(pageDic) do
          if (ConfigData.shop_page)[pageId] ~= nil then
            (table.insert)(pageList, pageId)
          end
        end
        ;
        (table.sort)(pageList)
        for _,pageId in ipairs(shopCfg.shop_para) do
          (table.insert)(pageList, pageId)
        end
      else
        do
          if shopData:GetIsHavePages() then
            for pageId,_ in pairs(shopData:GetPageDic()) do
              if shopData:HasShopGoodsInPage(R14_PC119) then
                (table.insert)(pageList, R14_PC119)
              end
            end
          end
          do
            ;
            (table.sort)(pageList)
            if shopCfg.is_topbar ~= 0 then
              self:Show()
            else
              self:Hide()
            end
            ;
            (self.shelfTypeTogPool):HideAll()
            if pageList == nil or #pageList == 0 then
              do
                if shopCfg.is_topbar == -1 then
                  local item = (self.shelfTypeTogPool):GetOne()
                  item:InitOnlyTitleShelfTog(shopCfg.name)
                end
                ;
                (self.onClickTogFunc)(shopId, nil, autoSelectShelfId)
                do return  end
                local autoSelectIndex = 1
                if autoSelectPageId ~= nil then
                  for index,pageId in pairs(pageList) do
                    if autoSelectPageId == pageId then
                      autoSelectIndex = 
                      break
                    end
                  end
                end
                do
                  for index,pageId in ipairs(pageList) do
                    -- DECOMPILER ERROR at PC182: Overwrote pending register: R14 in 'AssignReg'

                    local item = (self.shelfTypeTogPool):GetOne()
                    -- DECOMPILER ERROR at PC184: Overwrote pending register: R14 in 'AssignReg'

                    R14_PC119(item, shopId, pageId, self.onClickTogFunc, #pageList)
                    -- DECOMPILER ERROR at PC190: Overwrote pending register: R14 in 'AssignReg'

                    R14_PC119(item, index == autoSelectIndex, autoSelectShelfId)
                  end
                  ;
                  (self.onClickTogFunc)(shopId, pageList[autoSelectIndex], autoSelectShelfId)
                  -- DECOMPILER ERROR: 2 unprocessed JMP targets
                end
              end
            end
          end
        end
      end
    end
  end
end

UINShopTogs._CheckRecommendValid = function(self, pageCfg)
  -- function num : 0_3 , upvalues : _ENV, JumpManager
  local isOpen = false
  for _,imgNum in ipairs(pageCfg.imgs) do
    local recommedCfg = (ConfigData.shop_recommend)[imgNum]
    if recommedCfg ~= nil then
      if recommedCfg.jump_target == (JumpManager.eJumpTarget).DynActivity then
        self.frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
        local frameData = (self.frameCtrl):GetActivityFrameData((recommedCfg.jump_arg)[1])
        if frameData ~= nil then
          isOpen = frameData:GetCouldShowActivity()
        else
          isOpen = false
        end
      else
        do
          do
            isOpen = true
            if isOpen then
              return true
            end
            -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC41: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
end

UINShopTogs.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (self.shelfTypeTogPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINShopTogs

