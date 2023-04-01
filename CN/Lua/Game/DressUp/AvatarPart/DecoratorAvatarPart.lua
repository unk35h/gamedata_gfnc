-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.DressUp.AvatarPart.CharacterAvatarPartBase")
local DecoratorAvatarPart = class("DecoratorAvatarPart", base)
local attachNodePathTable = {right_hand = "root/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Neck/Bip001 R Clavicle/Bip001 R UpperArm/Bip001 R Forearm/Bip001 R Hand", left_hand = "root/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Neck/Bip001 L Clavicle/Bip001 L UpperArm/Bip001 L Forearm/Bip001 L Hand", head = "root/Bip001/Bip001 Pelvis/Bip001 Spine/Bip001 Spine1/Bip001 Neck/Bip001 Head"}
DecoratorAvatarPart.Init = function(self)
  -- function num : 0_0 , upvalues : base
  (base.Init)(self)
  self.avatarType = 0
  self.cs_avatarPart = nil
end

DecoratorAvatarPart.AttachAvatarParts = function(self)
  -- function num : 0_1 , upvalues : _ENV, attachNodePathTable
  if self.dressUpCtrl == nil then
    return 
  end
  if IsNull((self.dressUpCtrl).obj) then
    return 
  end
  if IsNull(self.obj) then
    return 
  end
  local attachNodePath = attachNodePathTable[(self.dressData).attach_pos]
  local parent = (((self.dressUpCtrl).obj).transform):Find(attachNodePath)
  if not IsNull(parent) then
    ((self.obj).transform):SetParent(parent)
    -- DECOMPILER ERROR at PC40: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.obj).transform).localPosition = Vector3.zero
    -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.obj).transform).localEulerAngles = Vector3.zero
    -- DECOMPILER ERROR at PC50: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.obj).transform).localScale = Vector3.one
  end
end

DecoratorAvatarPart.RemoveAvatarParts = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if IsNull(self.obj) then
    return 
  end
  ;
  (((CS.UnityEngine).GameObject).Destroy)(self.obj)
end

return DecoratorAvatarPart

