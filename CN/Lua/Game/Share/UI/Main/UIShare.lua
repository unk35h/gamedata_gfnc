-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIShare = class("UIShare", base)
local UINShareCapture = require("Game.Share.UI.Main.Capture.UINShareCapture")
local UINShare = require("Game.Share.UI.Main.Share.UINShare")
local util = require("XLua.Common.xlua_util")
local eShare = require("Game.Share.eShare")
local cs_ResLoader = CS.ResLoader
local cs_WaitForEndOfFrame = (CS.UnityEngine).WaitForEndOfFrame
local cs_MessageCommon = CS.MessageCommon
local cs_FilePathHelper = (CS.FilePathHelper).Instance
local cs_ImageConversion = (CS.UnityEngine).ImageConversion
UIShare.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINShare, UINShareCapture
  (UIUtil.AddButtonListener)((self.ui).btn_Close, self, self.CloseShareWin)
  self._resLoader = (cs_ResLoader.Create)()
  self.shareNode = (UINShare.New)(self)
  ;
  (self.shareNode):Init((self.ui).shareNode)
  self.srCaptureNode = (UINShareCapture.New)()
  ;
  (self.srCaptureNode):Init((self.ui).captureNode)
end

UIShare.SetShareBeforeCaptureFunc = function(self, beforeCaptureFunc)
  -- function num : 0_1
  self._beforeCaptureFunc = beforeCaptureFunc
  return self
end

UIShare.SetShareAfterCaptureFunc = function(self, afterCaptureFunc)
  -- function num : 0_2
  self._afterCaptureFunc = afterCaptureFunc
  return self
end

UIShare.SetShareCloseFunc = function(self, closeFunc)
  -- function num : 0_3
  self._closeFunc = closeFunc
  return self
end

UIShare.InitShare = function(self, shareId)
  -- function num : 0_4 , upvalues : _ENV, util
  self._shareId = shareId
  ;
  (self.srCaptureNode):InitShareCapture(self._resLoader)
  self.__shareCoroutine = (GR.StartCoroutine)((util.cs_generator)(BindCallback(self, self._CaptureImgCo)))
end

UIShare._ClearTextureTemp = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self._textureTemp ~= nil then
    DestroyUnityObject(self._textureTemp)
    self._textureTemp = nil
  end
end

UIShare._CaptureImgCo = function(self)
  -- function num : 0_6 , upvalues : _ENV, cs_WaitForEndOfFrame
  if self._beforeCaptureFunc ~= nil then
    (self._beforeCaptureFunc)()
  end
  UIManager:HideClickEffect(true)
  NoticeManager:PuaseShowNotice("UIShare")
  ;
  (self.shareNode):Hide()
  ;
  (self.srCaptureNode):Show()
  local ingameDebugConsoleGo = nil
  if isGameDev then
    ingameDebugConsoleGo = (((CS.UnityEngine).GameObject).Find)("IngameDebugConsole")
    if not IsNull(ingameDebugConsoleGo) then
      ingameDebugConsoleGo:SetActive(false)
    end
  end
  local waitForEndOfFrame = cs_WaitForEndOfFrame()
  ;
  (coroutine.yield)(waitForEndOfFrame)
  self:_ClearTextureTemp()
  self._textureTemp = (GR.CaptureScreenshotAsTexture)()
  UIManager:HideClickEffect(false)
  NoticeManager:ContinueShowNotice("UIShare")
  if not IsNull(ingameDebugConsoleGo) then
    ingameDebugConsoleGo:SetActive(true)
  end
  if self._afterCaptureFunc ~= nil then
    (self._afterCaptureFunc)()
  end
  ;
  (self.srCaptureNode):Hide()
  ;
  (self.shareNode):Show()
  ;
  (self.shareNode):InitShareNode(self._textureTemp)
end

UIShare.ShareImgChannel = function(self, shareChannelId)
  -- function num : 0_7 , upvalues : cs_ImageConversion, cs_FilePathHelper, _ENV, cs_MessageCommon
  local bytes = (cs_ImageConversion.EncodeToPNG)(self._textureTemp)
  local ok = cs_FilePathHelper:WriteBytesToFile(PathConsts.PersistentShareImgPath, bytes)
  if not ok then
    error("Save share image falied")
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(14028))
    return 
  end
  local shareCtrl = ControllerManager:GetController(ControllerTypeId.Share, true)
  shareCtrl:ShareImg(self._shareId, shareChannelId)
  self:CloseShareWin()
end

UIShare.CloseShareWin = function(self)
  -- function num : 0_8
  if self._closeFunc ~= nil then
    (self._closeFunc)()
  end
  self:Delete()
end

UIShare.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, base
  (self.srCaptureNode):Delete()
  ;
  (self.shareNode):Delete()
  ;
  (self._resLoader):Put2Pool()
  self._resLoader = nil
  if self.__shareCoroutine ~= nil then
    (GR.StopCoroutine)(self.__shareCoroutine)
    self.__shareCoroutine = nil
  end
  self:_ClearTextureTemp()
  ;
  (base.OnDelete)(self)
end

return UIShare

