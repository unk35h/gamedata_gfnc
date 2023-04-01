-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINShareCapture = class("UINShareCapture", base)
local UINUserHead = require("Game.CommonUI.Head.UINUserHead")
UINShareCapture.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINUserHead
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._head = (UINUserHead.New)()
  ;
  (self._head):Init((self.ui).UINUserHead)
end

UINShareCapture.InitShareCapture = function(self, resLoader)
  -- function num : 0_1 , upvalues : _ENV
  local userInfoData = PlayerDataCenter.inforData
  ;
  (self._head):SetLoadHeadSync()
  ;
  (self._head):InitUserHeadUI(userInfoData:GetAvatarId(), userInfoData:GetAvatarFrameId(), resLoader)
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).Tex_Lvl).text = tostring(userInfoData:GetUserLevel())
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).Tex_PlayerName).text = userInfoData:GetUserName()
  ;
  ((self.ui).Tex_PlayerID):SetIndex(0, tostring(userInfoData:GetUserUID()))
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).logo).texture = resLoader:LoadABAsset(PathConsts:GetResImagePath("NoAtlas/UI_ShareGameLogo.png"))
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).logo).enabled = not IsNull(((self.ui).logo).texture)
  local channelId = ((CS.MicaSDKManager).Instance).channelId
  local qrCodeCfg = (ConfigData.share_QRCode)[channelId]
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

  if qrCodeCfg ~= nil and not (string.IsNullOrEmpty)(qrCodeCfg.code_picture) then
    ((self.ui).QRCode).enabled = true
    local path = PathConsts.ImagePath .. "NoAtlas/" .. qrCodeCfg.code_picture .. ".png"
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).QRCode).texture = resLoader:LoadABAsset(path)
  else
    do
      -- DECOMPILER ERROR at PC85: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).QRCode).enabled = false
    end
  end
end

UINShareCapture.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (self._head):Delete()
  ;
  (base.OnDelete)(self)
end

return UINShareCapture

