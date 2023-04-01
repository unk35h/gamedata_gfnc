-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.DressUp.AvatarPart.CharacterAvatarPartBase")
local BodyAvatarPart = class("BodyAvatarPart", base)
BodyAvatarPart.Init = function(self)
  -- function num : 0_0 , upvalues : base
  (base.Init)(self)
  self.avatarType = 0
  self.cs_avatarPart = nil
end

BodyAvatarPart.InstantiatePartObj = function(self, resLoader)
  -- function num : 0_1 , upvalues : _ENV, base
  if IsNull(resLoader) then
    return 
  end
  ;
  (base.InstantiatePartObj)(self, resLoader)
  if IsNull(self.obj) then
    return 
  end
  self.cs_avatarPart = (self.obj):GetComponent(typeof((CS.MagicaCloth).MagicaAvatarParts))
  return self.obj
end

BodyAvatarPart.AttachAvatarParts = function(self, parent)
  -- function num : 0_2 , upvalues : _ENV
  if self.dressUpCtrl == nil then
    return 
  end
  if IsNull(self.cs_avatarPart) then
    return 
  end
  if IsNull((self.dressUpCtrl).dressUpController) then
    return 
  end
  self:RemoveAvatarParts()
  self.partsId = ((self.dressUpCtrl).dressUpController):AttachAvatarParts(self.cs_avatarPart)
  if not IsNull(parent) then
    ((self.obj).transform):SetParent(parent)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.obj).transform).position = Vector3.zero
    -- DECOMPILER ERROR at PC44: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.obj).transform).localEulerAngles = Vector3.zero
  end
end

BodyAvatarPart.RemoveAvatarParts = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.dressUpCtrl == nil then
    return 
  end
  if IsNull(self.cs_avatarPart) then
    return 
  end
  if IsNull((self.dressUpCtrl).dressUpController) then
    return 
  end
  ;
  ((self.dressUpCtrl).dressUpController):RemoveAvatarParts(self.cs_avatarPart)
  self.partsId = 0
end

return BodyAvatarPart

