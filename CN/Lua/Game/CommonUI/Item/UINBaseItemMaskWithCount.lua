-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBaseItemMaskWithCount = class("UINBaseItemWithCount", UIBaseNode)
local base = UIBaseNode
UINBaseItemMaskWithCount.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBaseItemMaskWithCount.InitItemMaskWithCount = function(self, nowNum, totalNum)
  -- function num : 0_1
  self:SetFntMask(nowNum, totalNum)
end

UINBaseItemMaskWithCount.SetFntMask = function(self, nowNum, totalNum)
  -- function num : 0_2 , upvalues : _ENV
  if nowNum == 0 then
    ((self.ui).obj_mask):SetActive(false)
    ;
    ((self.ui).obj_had):SetActive(false)
  else
    if nowNum < totalNum then
      ((self.ui).obj_mask):SetActive(false)
      ;
      ((self.ui).obj_had):SetActive(true)
      ;
      ((self.ui).tex_Had):SetIndex(1, "\n", tostring(nowNum), tostring(totalNum))
    else
      ;
      ((self.ui).obj_mask):SetActive(true)
      ;
      ((self.ui).obj_had):SetActive(true)
      ;
      ((self.ui).tex_Had):SetIndex(0)
    end
  end
end

UINBaseItemMaskWithCount.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINBaseItemMaskWithCount

