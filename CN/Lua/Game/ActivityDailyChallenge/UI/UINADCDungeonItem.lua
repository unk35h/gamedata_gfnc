-- params : ...
-- function num : 0 , upvalues : _ENV
local UINADCDungeonItem = class("UINADCDungeonItem", UIBaseNode)
local base = UIBaseNode
UINADCDungeonItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).shadow, self, self.OnClickItem)
end

UINADCDungeonItem.InitADCDungeonItem = function(self, adcData, dungeonCfg, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._adcData = adcData
  self._dungeonCfg = (ConfigData.battle_dungeon)[dungeonCfg.dungeon_id]
  self._callback = callback
  self._superDungeon = dungeonCfg.unlock_item > 1
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_LevelName).text = (LanguageUtil.GetLocaleText)((self._dungeonCfg).name)
  local index = self._superDungeon and 1 or 0
  ;
  ((self.ui).img_MiddenBg):SetIndex(index)
  ;
  ((self.ui).img_BottonRighticon):SetIndex(index)
  ;
  ((self.ui).img_LeftLine):SetIndex(index)
  self:RefreshADCDungeonItem()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UINADCDungeonItem.RefreshADCDungeonItem = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isUnlock = (self._adcData):IsADCDungeonUnlock((self._dungeonCfg).id)
  if not isUnlock then
    ((self.ui).img_Lockmask):SetActive(true)
    ;
    (((self.ui).tex_CurrentDes).gameObject):SetActive(false)
    ;
    (((self.ui).tex_CurrentScore).gameObject):SetActive(false)
    ;
    (((self.ui).texbg).gameObject):SetActive(false)
    return 
  end
  ;
  (((self.ui).texbg).gameObject):SetActive(true)
  ;
  ((self.ui).img_Lockmask):SetActive(false)
  ;
  (((self.ui).tex_CurrentDes).gameObject):SetActive(true)
  local score = (self._adcData):GetADCDungeonPoint((self._dungeonCfg).id)
  local flag = score > 0
  ;
  (((self.ui).tex_CurrentScore).gameObject):SetActive(flag)
  ;
  ((self.ui).tex_CurrentDes):SetIndex(flag and 0 or 1)
  -- DECOMPILER ERROR at PC78: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_CurrentScore).text = tostring(score)
  local index = 2
  index = not flag or (self._superDungeon and 3) or 1
  -- DECOMPILER ERROR at PC94: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).texbg).color = ((self.ui).color_texbg)[index]
  -- DECOMPILER ERROR: 5 unprocessed JMP targets
end

UINADCDungeonItem.RefreshADCSelectState = function(self, dungeonId)
  -- function num : 0_3
  ((self.ui).img_Selected):SetActive(dungeonId == (self._dungeonCfg).id)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINADCDungeonItem.OnClickItem = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)((self._dungeonCfg).id, self)
  end
end

return UINADCDungeonItem

