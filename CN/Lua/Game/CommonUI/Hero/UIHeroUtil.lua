-- params : ...
-- function num : 0 , upvalues : _ENV
local UIHeroUtil = {}
UIHeroUtil.UpdHeroStar = function(img_Star, obj_StarHalf, rank)
  -- function num : 0_0
  local half = rank % 2
  local rankImgIndex = (rank - half) / 2 - 1
  if rankImgIndex >= 0 then
    (img_Star.gameObject):SetActive(true)
    img_Star:SetIndex(rankImgIndex)
    ;
    (img_Star.image):SetNativeSize()
  else
    ;
    (img_Star.gameObject):SetActive(false)
  end
  obj_StarHalf:SetActive(half == 1)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

local HeroLevel60Color = (Color.New)(1, 0.54509803921569, 0.12941176470588)
local HeroLevel60ColorHexPre = "<Color=#FF8B21>"
UIHeroUtil.GetHeroLevelColor = function(level)
  -- function num : 0_1 , upvalues : _ENV, HeroLevel60Color
  if (ConfigData.buildinConfig).HeroLongTailLevel > level or not HeroLevel60Color then
    return Color.white
  end
end

UIHeroUtil.GetHeroLevelColorHexStr = function(level)
  -- function num : 0_2 , upvalues : _ENV, HeroLevel60ColorHexPre
  if (ConfigData.buildinConfig).HeroLongTailLevel <= level then
    return HeroLevel60ColorHexPre .. tostring(level) .. "</Color>"
  end
  return tostring(level)
end

return UIHeroUtil

