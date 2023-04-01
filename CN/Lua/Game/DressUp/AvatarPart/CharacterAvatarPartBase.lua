-- params : ...
-- function num : 0 , upvalues : _ENV
local CharacterAvatarPartBase = class("CharacterAvatarPartBase")
local bodyPartTypeNameTable = {[1] = "_head", [2] = "_hair", [3] = "_body", [4] = "_leg", [5] = "", [6] = ""}
CharacterAvatarPartBase.Init = function(self)
  -- function num : 0_0
  self.dressId = 0
  self.dressData = nil
  self.prefabPath = nil
  self.obj = nil
  self.dressUpCtrl = nil
end

CharacterAvatarPartBase.InitCharacterAvatarPart = function(self, avatarPartConfig, DressUpCtrl)
  -- function num : 0_1
  self.dressData = avatarPartConfig
  if self.dressData == nil then
    return 
  end
  self.dressId = avatarPartConfig.id
  self.dressUpCtrl = DressUpCtrl
end

CharacterAvatarPartBase.InstantiatePartObj = function(self, resLoader, callback)
  -- function num : 0_2 , upvalues : _ENV
  if resLoader == nil then
    return 
  end
  local prefabPath = self:GetAvatarPartPath()
  resLoader:LoadABAssetAsync(prefabPath, function(prefab)
    -- function num : 0_2_0 , upvalues : _ENV, self, callback
    if IsNull(prefab) then
      return 
    end
    self.obj = prefab:Instantiate()
    if callback ~= nil then
      callback(self)
    end
  end
)
end

CharacterAvatarPartBase.AttachAvatarParts = function(self)
  -- function num : 0_3
end

CharacterAvatarPartBase.RemoveAvatarParts = function(self)
  -- function num : 0_4
end

CharacterAvatarPartBase.GetAvatarPartPath = function(self)
  -- function num : 0_5 , upvalues : _ENV, bodyPartTypeNameTable
  if self.dressData == nil then
    return 
  end
  local avatarName = (self.dressData).avatar_name
  local bodyPartType = (self.dressData).body_part_type
  local prefabPath = PathConsts:GetCharacterAvatarPartPrefabPath(avatarName, avatarName .. bodyPartTypeNameTable[bodyPartType])
  return prefabPath
end

return CharacterAvatarPartBase

