-- params : ...
-- function num : 0 , upvalues : _ENV
local UINQuickPrchaseKayItemNodeItem = class("UINQuickPrchaseKayItemNodeItem", UIBaseNode)
local base = UIBaseNode
UINQuickPrchaseKayItemNodeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.selectNum = 0
  self.warehousNum = 0
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_itemNode, self, self.AddOne)
  ;
  (((self.ui).btn_itemNode).onPress):AddListener(BindCallback(self, self.AddOne))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_UnSelect, self, self.MineOne)
  ;
  (((self.ui).btn_UnSelect).onPress):AddListener(BindCallback(self, self.MineOne))
  self:SetLimtTimeDetailActive(false)
end

UINQuickPrchaseKayItemNodeItem.InitQPKItem = function(self, packageItemId, onChangeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.selectNum = 0
  self.packageItemId = packageItemId
  self.onChangeCallback = onChangeCallback
  self.itemCfg = (ConfigData.item)[packageItemId]
  self.isOutTime = false
  self.outTime = -1
  if self.itemCfg == nil then
    error("can\'t read itemCfg with id:" .. tostring(packageItemId))
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_ItemIcon).sprite = CRH:GetSprite((self.itemCfg).icon)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)((self.itemCfg).name)
  local itemNum = PlayerDataCenter:GetItemCount(self.packageItemId)
  self:RefreshWharehouseNume(itemNum)
  self:RefreshNum(true)
  self:SetLimtTimeDetailActive(false)
end

UINQuickPrchaseKayItemNodeItem.InitQPKLimiTimeItem = function(self, packageItemId, outTime, count, onChangeCallback)
  -- function num : 0_2 , upvalues : _ENV
  self.selectNum = 0
  self.packageItemId = packageItemId
  self.onChangeCallback = onChangeCallback
  self.itemCfg = (ConfigData.item)[packageItemId]
  self.outTime = outTime
  self.isOutTime = false
  if self.itemCfg == nil then
    error("can\'t read itemCfg with id:" .. tostring(packageItemId))
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_ItemIcon).sprite = CRH:GetSprite((self.itemCfg).icon)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_ItemName).text = (LanguageUtil.GetLocaleText)((self.itemCfg).name)
  self:RefreshWharehouseNume(count)
  self:RefreshNum(true)
end

UINQuickPrchaseKayItemNodeItem.AddOne = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.warehousNum <= self.selectNum then
    return 
  end
  if self.isOutTime == true then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6041))
    return 
  end
  self.selectNum = self.selectNum + 1
  self:RefreshNum()
end

UINQuickPrchaseKayItemNodeItem.AddAll = function(self)
  -- function num : 0_4
  if self.warehousNum <= self.selectNum then
    return 
  end
  if self.isOutTime == true then
    return 
  end
  self.selectNum = self.warehousNum
  self:RefreshNum()
end

UINQuickPrchaseKayItemNodeItem.AddNum = function(self, num, isInit)
  -- function num : 0_5 , upvalues : _ENV
  if self.warehousNum <= self.selectNum then
    return 
  end
  if self.isOutTime == true then
    ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(6041))
    return 
  end
  self.selectNum = self.selectNum + num
  self:RefreshNum(isInit)
end

UINQuickPrchaseKayItemNodeItem.MineOne = function(self)
  -- function num : 0_6
  if self.selectNum <= 0 then
    return 
  end
  self.selectNum = self.selectNum - 1
  self:RefreshNum()
end

UINQuickPrchaseKayItemNodeItem.MineNum = function(self, num, isInit)
  -- function num : 0_7
  if self.selectNum <= 0 then
    return 
  end
  self.selectNum = self.selectNum - num
  self:RefreshNum(isInit)
end

UINQuickPrchaseKayItemNodeItem.CleanAll = function(self)
  -- function num : 0_8
  self.selectNum = 0
  self:RefreshNum()
end

UINQuickPrchaseKayItemNodeItem.RefreshNum = function(self, isInit)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).tex_ItemSelectNum).text = tostring(self.selectNum)
  ;
  (((self.ui).btn_UnSelect).gameObject):SetActive(self.selectNum > 0)
  ;
  ((self.ui).go_imgNumber):SetActive(self.selectNum > 0)
  if not isInit and self.onChangeCallback ~= nil then
    (self.onChangeCallback)(self, self.selectNum)
  end
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINQuickPrchaseKayItemNodeItem.RefreshWharehouseNume = function(self, itemNum)
  -- function num : 0_10 , upvalues : _ENV
  self.warehousNum = itemNum
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Number).text = tostring(self.warehousNum)
end

UINQuickPrchaseKayItemNodeItem.GetKeyNum = function(self)
  -- function num : 0_11 , upvalues : _ENV
  return ((self.itemCfg).giftOptainDic)[ConstGlobalItem.SKey]
end

UINQuickPrchaseKayItemNodeItem.SetLimtTimeDetailActive = function(self, bValue)
  -- function num : 0_12
  if ((self.ui).obj_Time).activeSelf ~= bValue then
    ((self.ui).obj_Time):SetActive(bValue)
  end
end

UINQuickPrchaseKayItemNodeItem.UpdateLimitTimeDetail = function(self)
  -- function num : 0_13 , upvalues : _ENV
  self.isOutTime = false
  self:SetLimtTimeDetailActive(true)
  local diffTime = self.outTime - PlayerDataCenter.timestamp
  if diffTime > 0 then
    local d, h, m, s = TimeUtil:TimestampToTimeInter(diffTime, false, true)
    if d > 0 then
      ((self.ui).text_Time):SetIndex(0, tostring(d), tostring(h))
    else
      if h > 0 then
        ((self.ui).text_Time):SetIndex(1, tostring(h), tostring(m))
      else
        if m > 0 then
          ((self.ui).text_Time):SetIndex(2, tostring(m))
        else
          ;
          ((self.ui).text_Time):SetIndex(2, tostring(1))
        end
      end
    end
  else
    do
      self.isOutTime = true
      ;
      ((self.ui).text_Time):SetIndex(3)
    end
  end
end

UINQuickPrchaseKayItemNodeItem.GetIsOutTime = function(self)
  -- function num : 0_14
  return self.isOutTime
end

UINQuickPrchaseKayItemNodeItem.GetOutTime = function(self)
  -- function num : 0_15
  return self.outTime
end

UINQuickPrchaseKayItemNodeItem.GetLastNum = function(self)
  -- function num : 0_16
  return self.warehousNum - self.selectNum
end

UINQuickPrchaseKayItemNodeItem.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base
  (base.OnDelete)(self)
end

return UINQuickPrchaseKayItemNodeItem

