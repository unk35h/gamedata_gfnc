-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActWinter23LvSwitchList = class("UINActWinter23LvSwitchList", UIBaseNode)
local base = UIBaseNode
local cs_DoTween = ((CS.DG).Tweening).DOTween
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
UINActWinter23LvSwitchList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActWinter23LvSwitchList.InitUINActWinter23ChapterListItem = function(self, index)
  -- function num : 0_1 , upvalues : _ENV
  self.index = index
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = (string.format)("%02d", index)
end

UINActWinter23LvSwitchList.SetMainChapter = function(self)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  (((self.ui).layout).padding).left = (self.ui).padding
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).layout).padding).right = (self.ui).padding
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).color = (self.ui).big_fontColor
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).fontSize = (self.ui).big_fontSize
end

UINActWinter23LvSwitchList.SetSideChapter = function(self)
  -- function num : 0_3
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R1 in 'UnsetPending'

  (((self.ui).layout).padding).left = 0
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (((self.ui).layout).padding).right = 0
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).color = (self.ui).small_fontColor
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).fontSize = (self.ui).small_fontSize
end

UINActWinter23LvSwitchList.SetChapterListItemRedDotOpen = function(self, bool)
  -- function num : 0_4
  ((self.ui).obj_redDot):SetActive(bool)
end

UINActWinter23LvSwitchList.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnDelete)(self)
end

return UINActWinter23LvSwitchList

