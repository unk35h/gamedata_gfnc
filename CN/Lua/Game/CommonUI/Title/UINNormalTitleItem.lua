-- params : ...
-- function num : 0 , upvalues : _ENV
local UINNormalTitleItem = class("UINStageRewardPreItem", UIBaseNode)
local base = UIBaseNode
local CS_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local CS_ColorUtility = (CS.UnityEngine).ColorUtility
local util = require("XLua.Common.xlua_util")
local titleEnum = require("Game.CommonUI.Title.TitleEnum")
local CS_Material = (CS.UnityEngine).Material
UINNormalTitleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, CS_Material
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.bgImgMat = CS_Material(((self.ui).img_bg).material)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_bg).material = self.bgImgMat
end

UINNormalTitleItem.InitNormalTitleItem = function(self, titlePrefix, titlePostfix, titleBG, resloader, bgAtlas)
  -- function num : 0_1
  self.titleResloader = resloader
  self.bgAtlas = bgAtlas
  self.titlePrefix = titlePrefix
  self.titlePostfix = titlePostfix
  self.titleBg = titleBG
  self:RefreshTitle(titlePrefix, titlePostfix, titleBG)
end

UINNormalTitleItem.RefreshTitle = function(self, titlePrefix, titlePostfix, titleBG)
  -- function num : 0_2 , upvalues : _ENV, titleEnum, CS_ColorUtility, CS_LayoutRebuilder
  if titlePostfix == nil or titlePostfix == 0 then
    self.postConfig = {name = ""}
  else
    self.postConfig = (ConfigData.title)[titlePostfix]
  end
  if titlePrefix == nil or titlePrefix == 0 then
    self.preConfig = {name = ""}
  else
    self.preConfig = (ConfigData.title)[titlePrefix]
  end
  local bgId = titleBG
  if titleBG == nil or titleBG == 0 then
    bgId = titleEnum.NormalBGItemId
  end
  self.bgConfig = (ConfigData.title_background)[bgId]
  local realTitle = nil
  local atlasSprite = (AtlasUtil.GetResldSprite)(self.bgAtlas, (self.bgConfig).icon)
  local atlasTex = atlasSprite.texture
  if self.bgTex ~= atlasTex then
    (self.bgImgMat):SetTexture("_MainTex", atlasTex)
    self.bgTex = atlasTex
  end
  if (string.IsNullOrEmpty)((LanguageUtil.GetLocaleText)((self.preConfig).name)) and (string.IsNullOrEmpty)((LanguageUtil.GetLocaleText)((self.postConfig).name)) then
    realTitle = (LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(6050))
  else
    realTitle = (string.format)((LanguageUtil.GetLocaleText)(ConfigData:GetTipContent(6047)), (LanguageUtil.GetLocaleText)((self.preConfig).name), (LanguageUtil.GetLocaleText)((self.postConfig).name))
  end
  self.realTitle = realTitle
  local success, color = (CS_ColorUtility.TryParseHtmlString)((self.bgConfig).font_colour)
  -- DECOMPILER ERROR at PC110: Confused about usage of register: R10 in 'UnsetPending'

  if success then
    ((self.ui).tex_ApDes).color = color
  end
  -- DECOMPILER ERROR at PC113: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_ApDes).text = realTitle
  ;
  (CS_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).tran_tex)
  local realWidth = (math.clamp)(0, (((self.ui).tran_tex).sizeDelta).x + 60, ((((self.ui).img_bg).transform).sizeDelta).x)
  -- DECOMPILER ERROR at PC142: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).tran_view).sizeDelta = (Vector2.Temp)(realWidth, (((self.ui).tran_tex).sizeDelta).y)
  local xTiling = realWidth / ((((self.ui).img_bg).rectTransform).rect).width
  ;
  (self.bgImgMat):SetFloat("_XTiling", xTiling)
  local textureRect = atlasSprite.textureRect
  local mainTiling = Vector2.zero
  local mainOffset = Vector2.zero
  mainTiling.x = textureRect.width / atlasTex.width
  mainTiling.y = textureRect.height / atlasTex.height
  mainOffset.x = textureRect.x / atlasTex.width
  mainOffset.y = textureRect.y / atlasTex.height
  ;
  (self.bgImgMat):SetTextureScale("_MainTex", mainTiling)
  ;
  (self.bgImgMat):SetTextureOffset("_MainTex", mainOffset)
end

UINNormalTitleItem.SetPreTitle = function(self, preTitleCfg)
  -- function num : 0_3
  self.titlePrefix = preTitleCfg.id
  self:RefreshTitle(self.titlePrefix, self.titlePostfix, self.titleBg)
end

UINNormalTitleItem.SetPostTitle = function(self, postTitleCfg)
  -- function num : 0_4
  self.titlePostfix = postTitleCfg.id
  self:RefreshTitle(self.titlePrefix, self.titlePostfix, self.titleBg)
end

UINNormalTitleItem.SetTitleBg = function(self, titleBgCfg)
  -- function num : 0_5
  self.titleBg = titleBgCfg.id
  self:RefreshTitle(self.titlePrefix, self.titlePostfix, self.titleBg)
end

UINNormalTitleItem.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnDelete)(self)
end

return UINNormalTitleItem

