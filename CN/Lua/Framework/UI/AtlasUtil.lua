-- params : ...
-- function num : 0 , upvalues : _ENV
local cs_ResLoader = CS.ResLoader
AtlasUtil = {}
-- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

AtlasUtil.GetSpriteFromAtlas = function(atlasName, sName, resloader)
  -- function num : 0_0 , upvalues : _ENV
  local atlas = resloader:LoadABAsset(PathConsts:GetAtlasAssetPath(atlasName))
  if IsNull(atlas) then
    return nil
  end
  local sprite = (AtlasUtil.GetResldSprite)(atlas, sName)
  if IsNull(sprite) then
    return nil
  end
  return sprite
end

-- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

AtlasUtil.GetSpirteAtlas = function(atlasName, resloader)
  -- function num : 0_1 , upvalues : _ENV
  local atlas = resloader:LoadABAsset(PathConsts:GetAtlasAssetPath(atlasName))
  return atlas
end

-- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

AtlasUtil.GetResldSprite = function(atlas, spriteName)
  -- function num : 0_2 , upvalues : cs_ResLoader
  return (cs_ResLoader.GetAtlasSprite)(atlas, spriteName)
end


