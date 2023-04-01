-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.ActivityChristmas.UI.Tech.UINChristmas22TechLv")
local UINSpring23TechLv = class("UINSpring23TechLv", base)
UINSpring23TechLv.OnInit = function(self)
  -- function num : 0_0 , upvalues : base
  (base.OnInit)(self)
  self._canLvBtnColor = ((self.ui).img_Clear).color
  self._canLvTexColor = (((self.ui).tex_level).text).color
end

UINSpring23TechLv.RefreshChristmas22TechLv = function(self)
  -- function num : 0_1 , upvalues : base
  ((self.ui).ani_techInfoNode):Stop()
  ;
  ((self.ui).ani_techInfoNode):Play()
  ;
  (base.RefreshChristmas22TechLv)(self)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  if (self._techData):IsLeveUpResEnough() then
    ((self.ui).img_Clear).color = self._canLvBtnColor
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.ui).tex_level).text).color = self._canLvTexColor
    ;
    ((self.ui).obj_image):SetActive(true)
  else
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Clear).color = (self.ui).color_cannotLvBtn
    -- DECOMPILER ERROR at PC41: Confused about usage of register: R1 in 'UnsetPending'

    ;
    (((self.ui).tex_level).text).color = (self.ui).color_cannotLvText
    ;
    ((self.ui).obj_image):SetActive(false)
  end
end

UINSpring23TechLv.__RefreshDes = function(self)
  -- function num : 0_2 , upvalues : base, _ENV
  if (self._techData):IsMaxLvel() or (self._techData):GetCurLevel() == 0 then
    (base.__RefreshDes)(self)
    return 
  end
  local level = (self._techData):GetCurLevel()
  local desCur = (self._techData):GetTechDescription(level, self._desType)
  local desNext = (self._techData):GetTechDescription(level + 1, self._desType)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(9108, desCur, desNext)
end

return UINSpring23TechLv

