-- params : ...
-- function num : 0 , upvalues : _ENV
local UINWarehouseTab = class("UINWarehouseTab", UIBaseNode)
local base = UIBaseNode
local eWareHouseType = require("Game.Warehouse.eWareHouseType")
UINWarehouseTab.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Page, self, self.OnClickWarehouseTab)
end

UINWarehouseTab.InitWarehouseTab = function(self, warehouseTabCfg, clickAction, resloader)
  -- function num : 0_1 , upvalues : _ENV
  self.clickAction = clickAction
  self.warehouseTabCfg = warehouseTabCfg
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self.warehouseTabCfg).name)
  ;
  (((self.ui).img_Icon).gameObject):SetActive(false)
  resloader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("UI_Warehouse"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : self, _ENV
    if spriteAtlas == nil then
      return 
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = (AtlasUtil.GetResldSprite)(spriteAtlas, (self.warehouseTabCfg).icon)
    ;
    (((self.ui).img_Icon).gameObject):SetActive(true)
  end
)
  self:SetSelectState(false)
  self:RefreshRedDotState()
end

UINWarehouseTab.OnClickWarehouseTab = function(self)
  -- function num : 0_2
  if self.clickAction ~= nil then
    (self.clickAction)((self.warehouseTabCfg).id)
  end
end

UINWarehouseTab.SetSelectState = function(self, flag)
  -- function num : 0_3 , upvalues : eWareHouseType
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  if (self.warehouseTabCfg).id == (eWareHouseType.wharehouseType).LimitTimeItem then
    if not flag or not (self.ui).color_BtnSelected then
      ((self.ui).img_Buttom).color = (self.ui).color_SpecialBtnUnSelect
      -- DECOMPILER ERROR at PC27: Confused about usage of register: R2 in 'UnsetPending'

      if not flag or not (self.ui).color_TextSelected then
        ((self.ui).tex_Name).color = (self.ui).color_SpecialTexUnSelect
        -- DECOMPILER ERROR at PC38: Confused about usage of register: R2 in 'UnsetPending'

        if not flag or not (self.ui).color_ImgSelected then
          ((self.ui).img_Icon).color = (self.ui).color_SpecialImgUnSelect
          -- DECOMPILER ERROR at PC50: Confused about usage of register: R2 in 'UnsetPending'

          if not flag or not (self.ui).color_BtnSelected then
            ((self.ui).img_Buttom).color = (self.ui).color_BtnUnSelect
            -- DECOMPILER ERROR at PC61: Confused about usage of register: R2 in 'UnsetPending'

            if not flag or not (self.ui).color_TextSelected then
              ((self.ui).tex_Name).color = (self.ui).color_TextUnSelect
              -- DECOMPILER ERROR at PC72: Confused about usage of register: R2 in 'UnsetPending'

              if not flag or not (self.ui).color_ImgSelected then
                ((self.ui).img_Icon).color = (self.ui).color_ImgUnSelect
              end
            end
          end
        end
      end
    end
  end
end

UINWarehouseTab.RefreshRedDotState = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if (self.warehouseTabCfg).id == 1 then
    ((self.ui).blueDot):SetActive(false)
    return 
  end
  local ok, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Warehouse, (self.warehouseTabCfg).id)
  ;
  ((self.ui).blueDot):SetActive(not ok or node:GetRedDotCount() > 0)
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

return UINWarehouseTab

