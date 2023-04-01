-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpring23ModeSelectDiffItem = class("UINSpring23ModeSelectDiffItem", UIBaseNode)
local base = UIBaseNode
UINSpring23ModeSelectDiffItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_root, self, self.OnClickConfirm)
end

UINSpring23ModeSelectDiffItem.InitModelDiffItem = function(self, diffCfg, index, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._diffCfg = diffCfg
  self._index = index
  self._callback = callback
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ModeENName).text = diffCfg.difficulty_name_en
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_ModeCNName).text = (LanguageUtil.GetLocaleText)(diffCfg.difficulty_name)
  local totalDes = nil
  for index,catalog_id in ipairs(diffCfg.catalog) do
    local desCfg = (ConfigData.activity_spring_difficulty_catalog)[catalog_id]
    local des = (LanguageUtil.GetLocaleText)(desCfg.catalog_des)
    if (string.IsNullOrEmpty)(totalDes) then
      totalDes = des
    else
      totalDes = totalDes .. "\n" .. des
    end
  end
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_EPoints).text = totalDes
  self:SetModelColor(index)
end

UINSpring23ModeSelectDiffItem.SetModelDiffItemUnLocke = function(self, isUnlock, unlockDes)
  -- function num : 0_2 , upvalues : _ENV
  self.isUnlock = isUnlock
  if not IsNull((self.ui).obj_Locked) then
    ((self.ui).obj_Locked):SetActive(not isUnlock)
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    if not isUnlock then
      ((self.ui).tex_unlock).text = unlockDes
    end
  end
end

UINSpring23ModeSelectDiffItem.SetModelColor = function(self, index)
  -- function num : 0_3
  local color = ((self.ui).color_state)[index]
  if color == nil then
    color = ((self.ui).color_state)[#(self.ui).color_state]
  end
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_ModeBg).color = color
end

UINSpring23ModeSelectDiffItem.OnClickConfirm = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self)
  end
end

UINSpring23ModeSelectDiffItem.GetModeItemDiffInfoCfg = function(self)
  -- function num : 0_5
  return self._diffCfg, self._index
end

return UINSpring23ModeSelectDiffItem

