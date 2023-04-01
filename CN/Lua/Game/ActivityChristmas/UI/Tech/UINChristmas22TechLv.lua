-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChristmas22TechLv = class("UINChristmas22TechLv", UIBaseNode)
local base = UIBaseNode
UINChristmas22TechLv.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_icon, self, self.OnClickItemIntro)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Clear, self, self.OnClickLv)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_lock, self, self.OnClickLv)
end

UINChristmas22TechLv.SetChristmas22LogicDesType = function(self, desType)
  -- function num : 0_1
  self._desType = desType
end

UINChristmas22TechLv.InitChristmas22TechLv = function(self, techData, callback)
  -- function num : 0_2
  self._techData = techData
  self._callback = callback
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_BuffName).text = (self._techData):GetAWTechName()
  self:RefreshChristmas22TechLv()
end

UINChristmas22TechLv.RefreshChristmas22TechLv = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self._costId = nil
  self._costNum = nil
  self:__RefreshDes()
  ;
  ((self.ui).tex_lv):SetIndex(0, tostring((self._techData):GetCurLevel()), tostring((self._techData):GetMaxLevel()))
  if (self._techData):IsMaxLvel() then
    ((self.ui).cost):SetActive(false)
    ;
    (((self.ui).btn_Clear).gameObject):SetActive(false)
    ;
    ((self.ui).lock):SetActive(false)
    return 
  end
  if not (self._techData):GetIsUnlock() then
    ((self.ui).cost):SetActive(false)
    ;
    (((self.ui).btn_Clear).gameObject):SetActive(false)
    ;
    ((self.ui).lock):SetActive(true)
    local condition, para1, para2 = (self._techData):GetAWTechUnlockParam(1)
    -- DECOMPILER ERROR at PC74: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Lock).text = (CheckCondition.GetUnlockInfoLua)(condition, para1, para2)
    return 
  end
  do
    local condition, para1, para2 = (self._techData):GetAWTechUnlockParam((self._techData):GetCurLevel() + 1)
    local isUnlock = (CheckCondition.CheckLua)(condition, para1, para2)
    if not isUnlock then
      ((self.ui).cost):SetActive(false)
      ;
      (((self.ui).btn_Clear).gameObject):SetActive(false)
      ;
      ((self.ui).lock):SetActive(true)
      -- DECOMPILER ERROR at PC115: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).tex_Lock).text = (CheckCondition.GetUnlockInfoLua)(condition, para1, para2)
      return 
    end
    ;
    ((self.ui).lock):SetActive(false)
    ;
    ((self.ui).cost):SetActive(true)
    ;
    (((self.ui).btn_Clear).gameObject):SetActive(not (self._techData):IsMaxLvel())
    ;
    ((self.ui).tex_level):SetIndex((self._techData):GetCurLevel() > 0 and 1 or 0)
    local costDic = (self._techData):GetLevelCost((self._techData):GetCurLevel() + 1)
    for k,v in pairs(costDic) do
      self._costId = k
      self._costNum = v
      do break end
    end
    do
      if self._costId ~= nil then
        local hasCount = PlayerDataCenter:GetItemCount(self._costId)
        -- DECOMPILER ERROR at PC179: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self.ui).icon).sprite = CRH:GetSpriteByItemId(self._costId, true)
        -- DECOMPILER ERROR at PC185: Confused about usage of register: R7 in 'UnsetPending'

        ;
        ((self.ui).tex_Cost).text = tostring(self._costNum)
        -- DECOMPILER ERROR at PC197: Confused about usage of register: R7 in 'UnsetPending'

        if self._costNum > hasCount or not Color.white then
          ((self.ui).tex_Cost).color = Color.red
        end
      end
    end
  end
end

UINChristmas22TechLv.HideChristmas22TechBtnState = function(self)
  -- function num : 0_4
  ((self.ui).lock):SetActive(false)
  ;
  ((self.ui).cost):SetActive(false)
  ;
  (((self.ui).btn_Clear).gameObject):SetActive(false)
end

UINChristmas22TechLv.__RefreshDes = function(self)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Des).text = (self._techData):GetTechDescription(nil, self._desType)
end

UINChristmas22TechLv.OnClickLv = function(self)
  -- function num : 0_6
  if self._callback ~= nil then
    (self._callback)(self._techData)
  end
end

UINChristmas22TechLv.OnClickItemIntro = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self._costId == nil then
    return 
  end
  local itemCfg = (ConfigData.item)[self._costId]
  if itemCfg == nil then
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.GlobalItemDetail, function(win)
    -- function num : 0_7_0 , upvalues : itemCfg
    if win ~= nil then
      win:InitCommonItemDetail(itemCfg)
    end
  end
)
end

return UINChristmas22TechLv

