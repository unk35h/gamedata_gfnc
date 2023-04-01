-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCommonActivityBG = class("UINCommonActivityBG", UIBaseNode)
local base = UIBaseNode
UINCommonActivityBG.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINCommonActivityBG.InitActivityBG = function(self, frameId, resloader)
  -- function num : 0_1 , upvalues : _ENV
  local cfg = (ConfigData.activity_head)[frameId]
  if cfg == nil then
    return 
  end
  local color = (Color.New)((cfg.head_bar_color)[1] / 255, (cfg.head_bar_color)[2] / 255, (cfg.head_bar_color)[3] / 255)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).Line_below).color = color
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).Line_top1).color = color
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).Line_top2).color = color
  resloader:LoadABAssetAsync(PathConsts:GetActivityPath(cfg.head_pic_path), function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    if texture == nil then
      return 
    end
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).titleIMG).texture = texture
  end
)
end

return UINCommonActivityBG

