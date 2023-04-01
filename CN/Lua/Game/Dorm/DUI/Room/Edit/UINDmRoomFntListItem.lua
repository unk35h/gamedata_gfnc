-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDmRoomFntListItem = class("UINDmRoomFntListItem", UIBaseNode)
local base = UIBaseNode
UINDmRoomFntListItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
end

UINDmRoomFntListItem.InitDmRoomFntListItem = function(self, fntWarehouseData, clickFunc, inBigRoom)
  -- function num : 0_1 , upvalues : _ENV
  self.fntWarehouseData = fntWarehouseData
  self.clickFunc = clickFunc
  self._inBigRoom = inBigRoom
  ;
  ((self.ui).comfortLv):SetActive(not fntWarehouseData.isDefaultDmFnt)
  ;
  ((self.ui).num):SetActive(not fntWarehouseData.isDefaultDmFnt)
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R4 in 'UnsetPending'

  if fntWarehouseData.isDefaultDmFnt then
    ((self.ui).tex_Name).text = fntWarehouseData.name
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite(fntWarehouseData.icon)
  else
    -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Comfort).text = tostring((fntWarehouseData.fntCfg).comfort)
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)((fntWarehouseData.itemCfg).name)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).img_Icon).sprite = CRH:GetSprite((fntWarehouseData.itemCfg).icon)
  end
  ;
  ((self.ui).obj_img_OnlyBig):SetActive((fntWarehouseData.fntCfg).only_big)
  self:UpdDmRoomFntListItem()
end

UINDmRoomFntListItem.UpdDmRoomFntListItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local fntNum = self:_GetFntNum()
  local isSet = self._maxNum ~= nil and fntNum == 0 and (PlayerDataCenter.itemDic)[(self.fntWarehouseData).id] ~= nil
  ;
  ((self.ui).isSet):SetActive(isSet)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  if (self.fntWarehouseData).isDefaultDmFnt then
    ((self.ui).buttom).color = Color.white
    return 
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(fntNum)
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R3 in 'UnsetPending'

  if fntNum <= 0 or not Color.white then
    ((self.ui).buttom).color = Color.gray
    -- DECOMPILER ERROR at PC60: Confused about usage of register: R3 in 'UnsetPending'

    if not self._inBigRoom and ((self.fntWarehouseData).fntCfg).only_big then
      ((self.ui).buttom).color = Color.gray
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

UINDmRoomFntListItem.SetDmRoomFntListItemMaxNum = function(self, maxNum)
  -- function num : 0_3
  self._maxNum = maxNum
end

UINDmRoomFntListItem._GetFntNum = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local num = (self.fntWarehouseData).count
  if self._maxNum ~= nil then
    num = (math.min)(num, self._maxNum)
  end
  return num
end

UINDmRoomFntListItem._OnClickRoot = function(self)
  -- function num : 0_5
  if self.clickFunc ~= nil then
    (self.clickFunc)(self.fntWarehouseData, self)
  end
end

UINDmRoomFntListItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINDmRoomFntListItem

