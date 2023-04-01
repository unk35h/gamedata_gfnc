-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINShare = class("UINShare", base)
local UINShareChannelBtn = require("Game.Share.UI.Main.Share.UINShareChannelBtn")
local eShare = require("Game.Share.eShare")
UINShare.ctor = function(self, shareRoot)
  -- function num : 0_0
  self._shareRoot = shareRoot
end

UINShare.OnInit = function(self)
  -- function num : 0_1 , upvalues : _ENV, UINShareChannelBtn
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._OnClickShareChannelFunc = BindCallback(self, self._OnClickShareChannel)
  self._shareBtnPool = (UIItemPool.New)(UINShareChannelBtn, (self.ui).Btn_Share, false)
end

UINShare.InitShareNode = function(self, shareTexture)
  -- function num : 0_2
  self:_InitShareBtn()
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).ScreenShot).texture = shareTexture
  local size = (((self.ui).ScreenShot).transform).sizeDelta
  size.x = ((((self.ui).ScreenShot).transform).rect).height * shareTexture.width / shareTexture.height
  -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).ScreenShot).transform).sizeDelta = size
end

UINShare._InitShareBtn = function(self)
  -- function num : 0_3 , upvalues : _ENV, eShare
  (self._shareBtnPool):HideAll()
  local shareChannelList = nil
  if ((Consts.GameChannelType).IsInland)() then
    shareChannelList = eShare.InlandChannelList
  else
    error("Unsurported share channel:" .. tostring(((CS.MicaSDKManager).Instance).channelId))
    return 
  end
  for k,channel in ipairs(shareChannelList) do
    local btn = (self._shareBtnPool):GetOne()
    btn:InitShareChannelBtn(channel, self._OnClickShareChannelFunc)
  end
end

UINShare._OnClickShareChannel = function(self, shareChannelId)
  -- function num : 0_4
  (self._shareRoot):ShareImgChannel(shareChannelId)
end

UINShare.OnDelete = function(self)
  -- function num : 0_5 , upvalues : base
  (self._shareBtnPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINShare

