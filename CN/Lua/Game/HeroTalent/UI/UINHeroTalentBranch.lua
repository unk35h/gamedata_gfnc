-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentBranch = class("UINHeroTalentBranch", UIBaseNode)
local base = UIBaseNode
UINHeroTalentBranch.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.__OnClickSelect)
  self.defalutUnActiveAlpha = ((self.ui).canvasGroup_root).alpha
  self.defalutUnActiveColor = ((self.ui).tex_Att).color
end

UINHeroTalentBranch.InitHeroTalentBranch = function(self, branchId, attridId, curVal, nextVal, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._branchId = branchId
  self._clickCallback = clickCallback
  if curVal == nil then
    curVal = 0
  end
  local name, curValStr, icon = ConfigData:GetAttribute(attridId, curVal)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).img_Icon).sprite = CRH:GetSprite(icon)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R9 in 'UnsetPending'

  ;
  ((self.ui).tex_Att).text = (LanguageUtil.GetLocaleText)(name)
  if nextVal ~= nil then
    local _, nextValStr, _ = ConfigData:GetAttribute(attridId, nextVal)
    ;
    ((self.ui).tex_Addition):SetIndex(0, curValStr, nextValStr)
  else
    do
      ;
      ((self.ui).tex_Addition):SetIndex(1, curValStr)
    end
  end
end

UINHeroTalentBranch.SetTalentBranckSelectState = function(self, selectBranchId)
  -- function num : 0_2
  ;
  ((self.ui).img_root):SetIndex(self._branchId == selectBranchId and 1 or 0)
end

UINHeroTalentBranch.SetTalentBranckActiveState = function(self, flag)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  if not flag or not 1 then
    ((self.ui).canvasGroup_root).alpha = self.defalutUnActiveAlpha
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

    if not flag or not (self.ui).activeColor then
      ((self.ui).tex_Att).color = self.defalutUnActiveColor
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

      if not flag or not (self.ui).activeColor then
        (((self.ui).tex_Addition).text).color = self.defalutUnActiveColor
        -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

        if not flag or not (self.ui).activeColor then
          ((self.ui).img_Icon).color = self.defalutUnActiveColor
        end
      end
    end
  end
end

UINHeroTalentBranch.__OnClickSelect = function(self)
  -- function num : 0_4
  if self._clickCallback ~= nil then
    (self._clickCallback)(self._branchId)
  end
end

return UINHeroTalentBranch

