-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentLine = class("UINHeroTalentLine", UIBaseNode)
local base = UIBaseNode
local unValidAlpha = 0.1
local dottedLineAlpha = 0.5
UINHeroTalentLine.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINHeroTalentLine.SetHeroTalentLine = function(self, startPos, endPos)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R3 in 'UnsetPending'

  (self.transform).localPosition = startPos
  local offsetVec = endPos - startPos
  local z = (Vector2.Angle)(Vector2.right, offsetVec)
  if offsetVec.y <= 0 or not z then
    z = -z
  end
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).localEulerAngles = (Vector3.New)(0, 0, z)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).pivot = (Vector2.New)(0, 0.5)
  -- DECOMPILER ERROR at PC40: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).sizeDelta = (Vector2.New)((Vector3.Distance)(startPos, endPos), 4)
end

UINHeroTalentLine.RefreshHeroTalentLine = function(self, valid, isDottedLine)
  -- function num : 0_2 , upvalues : unValidAlpha, dottedLineAlpha
  ;
  ((self.ui).img_Line):SetIndex(isDottedLine and 1 or 0)
  local color = ((self.ui).img).color
  if not valid then
    color.a = unValidAlpha
  else
    if isDottedLine then
      color.a = dottedLineAlpha
    else
      color.a = 1
    end
  end
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img).color = color
end

return UINHeroTalentLine

