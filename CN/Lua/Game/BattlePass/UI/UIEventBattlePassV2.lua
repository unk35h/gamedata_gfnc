-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventBattlePass = require("Game.BattlePass.UI.UIEventBattlePass")
local base = UIEventBattlePass
local UIEventBattlePassV2 = class("UIEventBattlePassV2", base)
UIEventBattlePassV2.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnInit)(self)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_SkinShop, self, self.OnBtnOpenSkinShop)
end

UIEventBattlePassV2.InitBattlePassUIV2 = function(self, activityId)
  -- function num : 0_1 , upvalues : _ENV
  local passInfo = ((PlayerDataCenter.battlepassData).passInfos)[activityId]
  self.passInfo = passInfo
  if self.passInfo == nil then
    return 
  end
  self:InitBattlePassStaticUI()
  self:UpdateBattlePassBase(passInfo)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.passTableNode).passTagValueOffset = -0.5
  ;
  (self.passTableNode):InitBattlePassTable(self.passInfo, true)
  ;
  (((self.ui).btn_SkinShop).gameObject):SetActive((self.passInfo):GetBPSkinShopId() > 0)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIEventBattlePassV2.OnBtnOpenSkinShop = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local ShopController = ControllerManager:GetController(ControllerTypeId.Shop, true)
  ShopController:GetShopData((self.passInfo):GetBPSkinShopId(), function(shopData)
    -- function num : 0_2_0 , upvalues : _ENV
    if shopData == nil then
      return 
    end
    local skinIds = {}
    for shelfId,goodData in pairs(shopData.shopGoodsDic) do
      (table.insert)(skinIds, goodData.itemId)
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.HeroSkin, function(win)
      -- function num : 0_2_0_0 , upvalues : skinIds
      if win == nil then
        return 
      end
      win:InitSkinBySkinList(nil, skinIds, nil, nil)
    end
)
  end
)
end

UIEventBattlePassV2.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UIEventBattlePassV2

