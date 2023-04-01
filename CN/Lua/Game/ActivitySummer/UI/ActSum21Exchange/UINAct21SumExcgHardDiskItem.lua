-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAct21SumExcgHardDiskItem = class("UINAct21SumExcgHardDiskItem", UIBaseNode)
local base = UIBaseNode
local cs_Material = (CS.UnityEngine).Material
UINAct21SumExcgHardDiskItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_Material
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.disNoiseMat = cs_Material((self.ui).mat_DisNoise)
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_HDItem).material = self.disNoiseMat
  self:SetHardDiskItemDissolve(0)
end

UINAct21SumExcgHardDiskItem.InitHardDiskItem = function(self, idx, poolId)
  -- function num : 0_1 , upvalues : _ENV
  self.idx = idx
  self.poolId = poolId
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.gameObject).name = tostring(poolId)
end

UINAct21SumExcgHardDiskItem.SetHardDiskItemDissolve = function(self, ratio)
  -- function num : 0_2
  local radio = ratio * 0.65
  ;
  (((self.ui).img_HDItem).material):SetFloat("_Dissolve", ratio)
end

UINAct21SumExcgHardDiskItem.PlayFxDOTween = function(self, curPickedNum, allRewardNum)
  -- function num : 0_3
  self:KillTween()
  if allRewardNum == 0 then
    return 
  end
  local radio = curPickedNum / allRewardNum * 0.65
  if radio == 0 then
    return 
  end
  self:SetHardDiskItemDissolve(0)
  ;
  (((self.ui).img_HDItem).material):DOFloat(radio, "_Dissolve", 1)
end

UINAct21SumExcgHardDiskItem.KillTween = function(self)
  -- function num : 0_4
  (((self.ui).img_HDItem).material):DOKill()
end

UINAct21SumExcgHardDiskItem.OnDelete = function(self)
  -- function num : 0_5 , upvalues : _ENV, base
  self:KillTween()
  DestroyUnityObject(self.disNoiseMat)
  ;
  (base.OnDelete)(self)
end

return UINAct21SumExcgHardDiskItem

