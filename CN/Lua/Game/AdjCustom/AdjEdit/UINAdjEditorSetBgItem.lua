-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAdjEditorSetBgItem = class("UINAdjEditorSetBgItem", UIBaseNode)
local base = UINAdjEditorSetBgItem
UINAdjEditorSetBgItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).bgItem, self, self.OnClickItem)
end

UINAdjEditorSetBgItem.InitAdjBgItem = function(self, bgCfg, resloader, clickEvent)
  -- function num : 0_1 , upvalues : _ENV
  self._bgId = bgCfg.id
  self._bgCfg = bgCfg
  self._clickEvent = clickEvent
  self._isUnlock = nil
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((self._bgCfg).name)
  self:__SetLockedDes()
  local bgPath = PathConsts:GetMainBgThumbnail(tostring(self._bgId))
  resloader:LoadABAssetAsync(bgPath, function(texture)
    -- function num : 0_1_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

    if not IsNull(self.transform) then
      ((self.ui).img_Bg).texture = texture
    end
  end
)
  self:RefreshAdjBgLockState()
end

UINAdjEditorSetBgItem.RefreshAdjBgLockState = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self._isUnlock then
    return 
  end
  self._isUnlock = PlayerDataCenter:GetItemCount(self._bgId) > 0
  ;
  ((self.ui).lock):SetActive(not self._isUnlock)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINAdjEditorSetBgItem.__SetLockedDes = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if (self._bgCfg).condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Store then
    local shopId = ((self._bgCfg).condition_para)[1]
    local shopCfg = (ConfigData.shop)[shopId]
    if shopCfg ~= nil then
      ((self.ui).tex_Condition):SetIndex(0, (LanguageUtil.GetLocaleText)(shopCfg.name))
    else
      ;
      ((self.ui).tex_Condition):SetIndex(3)
    end
  else
    do
      if (self._bgCfg).condition == proto_csmsg_SystemFunctionID.SystemFunctionID_Operate_Active then
        local actFrameId = ((self._bgCfg).condition_para)[1]
        local actFrameData = (ControllerManager:GetController(ControllerTypeId.ActivityFrame)):GetActivityFrameData(actFrameId)
        if actFrameData ~= nil then
          ((self.ui).tex_Condition):SetIndex(1, (LanguageUtil.GetLocaleText)(actFrameData.name))
        else
          ;
          ((self.ui).tex_Condition):SetIndex(4)
        end
      else
        do
          if (table.count)((self._bgCfg).pre_condition) > 0 then
            ((self.ui).tex_Condition):SetIndex(2, (CheckCondition.GetUnlockInfoLua)((self._bgCfg).pre_condition, (self._bgCfg).pre_para1, (self._bgCfg).pre_para2))
          else
            ;
            ((self.ui).tex_Condition):SetIndex(3)
          end
        end
      end
    end
  end
end

UINAdjEditorSetBgItem.SetAdjBgSelectState = function(self, flag)
  -- function num : 0_4
  ((self.ui).img_Sel):SetActive(flag)
end

UINAdjEditorSetBgItem.GetAdjBgItemId = function(self)
  -- function num : 0_5
  return self._bgId
end

UINAdjEditorSetBgItem.IsAdkBgUnlock = function(self)
  -- function num : 0_6
  return self._isUnlock
end

UINAdjEditorSetBgItem.OnClickItem = function(self)
  -- function num : 0_7
  if self._clickEvent ~= nil then
    (self._clickEvent)(self._bgId)
  end
end

return UINAdjEditorSetBgItem

