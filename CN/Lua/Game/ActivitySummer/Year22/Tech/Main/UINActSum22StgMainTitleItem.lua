-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActSum22StgMainTitleItem = class("UINActSum22StgMainTitleItem", base)
UINActSum22StgMainTitleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActSum22StgMainTitleItem.InitActSum22StgMainTitleItem = function(self, branchCfg)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_CNName).text = (LanguageUtil.GetLocaleText)(branchCfg.branch_name)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).text = (LanguageUtil.GetLocaleText)(branchCfg.branch_name_en)
end

UINActSum22StgMainTitleItem.SetActSum22StgMainTitleItemNum = function(self, curNum, maxNum)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).tex_Num):SetIndex(0, tostring(curNum), tostring(maxNum))
end

UINActSum22StgMainTitleItem.SetActSum22StgMainTitleItemWidth = function(self, width)
  -- function num : 0_3 , upvalues : _ENV
  if IsNull((self.ui).layoutElement) then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).layoutElement).minWidth = width
end

UINActSum22StgMainTitleItem.OnDelete = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnDelete)(self)
end

return UINActSum22StgMainTitleItem

