-- params : ...
-- function num : 0 , upvalues : _ENV
local UINChangePro = class("UINChangePro", UIBaseNode)
local base = UIBaseNode
local LotteryRtUtil = require("Game.Lottery.UI.LotteryRtUtil")
local cs_RenderTextureFormat = (CS.UnityEngine).RenderTextureFormat
local cs_Shader = (CS.UnityEngine).Shader
local cs_Vector4 = (CS.UnityEngine).Vector4
UINChangePro.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Male, self, self.OnClickBoySex)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Female, self, self.OnClickGrilSex)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancle, self, self.Close)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.Confirm)
  self.isGril = (PlayerDataCenter.inforData):GetSex()
  self:initModel()
end

UINChangePro.initModel = function(self)
  -- function num : 0_1 , upvalues : LotteryRtUtil, cs_RenderTextureFormat, _ENV
  local isSupARGBHalf = (LotteryRtUtil.SupportsRenderTextures)(cs_RenderTextureFormat.ARGBHalf)
  for index,go in ipairs((self.ui).modelViews) do
    go:SetActive(isSupARGBHalf)
  end
  for index,go in ipairs((self.ui).picViews) do
    go:SetActive(not isSupARGBHalf)
  end
  if not isSupARGBHalf then
    return 
  end
  self.male_texture = (LotteryRtUtil.GetARGBHalfRtTemporary)(345, 420, 24)
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).male_ImgCamera).texture = self.male_texture
  ;
  (((self.ui).male_ImgCamera).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).male_Camera).targetTexture = self.male_texture
  self.female_texture = (LotteryRtUtil.GetARGBHalfRtTemporary)(345, 420, 24)
  -- DECOMPILER ERROR at PC55: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).female_ImgCamera).texture = self.female_texture
  ;
  (((self.ui).female_ImgCamera).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC65: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).female_Camera).targetTexture = self.female_texture
end

UINChangePro.OnClickBoySex = function(self)
  -- function num : 0_2
  self.isGril = false
  self:RefreshPannel()
end

UINChangePro.OnClickGrilSex = function(self)
  -- function num : 0_3
  self.isGril = true
  self:RefreshPannel()
end

UINChangePro._ShowUI = function(self)
  -- function num : 0_4
  self:Show()
  self:RefreshPannel()
  self:__SetCharacterLight()
end

UINChangePro.RefreshPannel = function(self)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  if self.isGril then
    ((self.ui).img_Male).color = (self.ui).color_unselect
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Female).color = (self.ui).color_select
    ;
    ((self.ui).male_Ring):SetActive(not self.isGril)
    ;
    ((self.ui).female_Ring):SetActive(self.isGril)
    ;
    (((self.ui).boy_unSelect).gameObject):SetActive(true)
    ;
    (((self.ui).boy_Select).gameObject):SetActive(false)
    ;
    (((self.ui).gril_unSelect).gameObject):SetActive(false)
    ;
    (((self.ui).gril_Select).gameObject):SetActive(true)
  else
    -- DECOMPILER ERROR at PC53: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Male).color = (self.ui).color_select
    -- DECOMPILER ERROR at PC58: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Female).color = (self.ui).color_unselect
    ;
    ((self.ui).male_Ring):SetActive(not self.isGril)
    ;
    ((self.ui).female_Ring):SetActive(self.isGril)
    ;
    (((self.ui).boy_unSelect).gameObject):SetActive(false)
    ;
    (((self.ui).boy_Select).gameObject):SetActive(true)
    ;
    (((self.ui).gril_unSelect).gameObject):SetActive(true)
    ;
    (((self.ui).gril_Select).gameObject):SetActive(false)
  end
end

UINChangePro.__SetCharacterLight = function(self)
  -- function num : 0_6 , upvalues : cs_Shader, cs_Vector4, _ENV
  (cs_Shader.SetGlobalVector)((cs_Shader.PropertyToID)("_CustomLightDir"), cs_Vector4(0, 0.5, -0.8, 1))
  ;
  (cs_Shader.SetGlobalColor)((cs_Shader.PropertyToID)("_GlobalCharColor"), Color.white)
end

UINChangePro.BindCloseFun = function(self, CloseFun)
  -- function num : 0_7
  self.closeFun = CloseFun
end

UINChangePro.Close = function(self)
  -- function num : 0_8
  if self.closeFun ~= nil then
    (self.closeFun)()
  end
end

UINChangePro.Confirm = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.isGril ~= (PlayerDataCenter.inforData):GetSex() then
    (NetworkManager:GetNetwork(NetworkTypeID.Object)):CS_User_SexMod(self.isGril)
  end
  self:Close()
end

UINChangePro.OnDelete = function(self)
  -- function num : 0_10 , upvalues : LotteryRtUtil, base
  if self.modelResloader ~= nil then
    (self.modelResloader):Put2Pool()
    self.modelResloader = nil
  end
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

  if self.male_texture ~= nil then
    ((self.ui).male_Camera).targetTexture = nil
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).male_ImgCamera).texture = nil
    ;
    (LotteryRtUtil.ReleaseTemporaryAndDestory)(self.male_texture)
    self.male_texture = nil
  end
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  if self.female_texture ~= nil then
    ((self.ui).female_Camera).targetTexture = nil
    -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).female_ImgCamera).texture = nil
    ;
    (LotteryRtUtil.ReleaseTemporaryAndDestory)(self.female_texture)
    self.female_texture = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINChangePro

