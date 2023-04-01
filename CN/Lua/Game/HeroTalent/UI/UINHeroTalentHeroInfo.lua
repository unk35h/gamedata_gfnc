-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHeroTalentHeroInfo = class("UINHeroTalentHeroInfo", UIBaseNode)
local base = UIBaseNode
local CS_UnityEngine_GameObject = (CS.UnityEngine).GameObject
local CS_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local UINStarUpAttrItem = require("Game.Hero.NewUI.UpgradeStar.UINStarUpAttrItem")
local UINHeroTalentNodeDetailEffect = require("Game.HeroTalent.UI.UINHeroTalentNodeDetailEffect")
UINHeroTalentHeroInfo.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroTalentNodeDetailEffect
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._starList = {}
  ;
  (table.insert)(self._starList, (self.ui).img_Star)
  ;
  (((self.ui).img_Star).gameObject):SetActive(false)
  self._effectPool = (UIItemPool.New)(UINHeroTalentNodeDetailEffect, (self.ui).attItem)
  ;
  ((self.ui).attItem):SetActive(false)
  ;
  ((self.ui).total):SetActive(false)
  self.defalutAttriNodeHeight = ((self.ui).attriNode).minHeight
  self.defaultAddtionHeight = (((self.ui).attrititleRect).rect).height
end

UINHeroTalentHeroInfo.UpdateHeroTalentHeroInfo = function(self, heroData)
  -- function num : 0_1 , upvalues : _ENV
  self._heroData = heroData
  self._talentNode = nil
  self._talent = nil
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Career).sprite = CRH:GetSprite((heroData:GetCareerCfg()).icon, CommonAtlasType.CareerCamp)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_HeroPic).sprite = CRH:GetHeroSkinSprite((self._heroData).dataId, (self._heroData).skinId)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (self._heroData):GetName()
  self:RefreshHeroTalentHeroInfoUI()
end

UINHeroTalentHeroInfo.SetHeroTalentNode = function(self, talentNode)
  -- function num : 0_2
  self._talentNode = talentNode
  self._talent = nil
  self:__RefreshHeroTalentProcess()
  self:__RefreshTalentAddAttribute()
end

UINHeroTalentHeroInfo.ShowHeroTalentAllAddtion = function(self, talentData)
  -- function num : 0_3
  self._talent = talentData
  self._talentNode = nil
  self:__RefreshHeroTalentProcess()
  self:__RefreshTalentAddAttribute()
end

UINHeroTalentHeroInfo.CancleHeroTalentShow = function(self)
  -- function num : 0_4
  self._talentNode = nil
  self._talent = nil
  self:__RefreshHeroTalentProcess()
  self:__RefreshTalentAddAttribute()
end

UINHeroTalentHeroInfo.RefreshHeroTalentHeroInfoUI = function(self)
  -- function num : 0_5 , upvalues : _ENV, CS_UnityEngine_GameObject
  local starNum = (self._heroData).rank // 2
  local half = (self._heroData).rank % 2 == 1
  if not half or not starNum + 1 then
    for index,imgStar in ipairs(self._starList) do
      (imgStar.gameObject):SetActive(starNum > 0)
      if not half or starNum ~= 1 or not 1 then
        do
          imgStar:SetIndex(starNum <= 0 or 0)
          starNum = starNum - 1
          -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_THEN_STMT

          -- DECOMPILER ERROR at PC39: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
    for i = starNum, 1, -1 do
      local go = (CS_UnityEngine_GameObject.Instantiate)(((self.ui).img_Star).gameObject, (((self.ui).img_Star).transform).parent)
      local img = go:GetComponent(typeof(CS.UiImageItemInfo))
      ;
      (table.insert)(self._starList, img)
      img:SetIndex(half and starNum == 1 and 1 or 0)
    end
    ;
    ((self.ui).tex_lv):SetIndex(0, tostring((self._heroData).level))
    self:__RefreshHeroTalentProcess()
    self:__RefreshTalentAddAttribute()
    -- DECOMPILER ERROR: 8 unprocessed JMP targets
  end
end

UINHeroTalentHeroInfo.__RefreshHeroTalentProcess = function(self)
  -- function num : 0_6 , upvalues : _ENV
  ((self.ui).total):SetActive(self._talent ~= nil)
  if self._talent == nil then
    return 
  end
  local curLv, totalLv = (self._talent):GetHeroTalentTotalLevel()
  local stage, stageTex = ConfigData:GetTalentStage(curLv)
  local process = curLv / totalLv
  ;
  ((self.ui).total_Icon):SetIndex(stage - 1)
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).total_tex_curState).text = stageTex
  ;
  ((self.ui).total_tex_process):SetIndex(0, tostring((math.floor)(process * 100)))
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).total_slider).value = process
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINHeroTalentHeroInfo.__RefreshTalentAddAttribute = function(self)
  -- function num : 0_7 , upvalues : CS_LayoutRebuilder, _ENV
  ((self.ui).attNode):SetActive(false)
  if self._talentNode ~= nil then
    self:__RefreshTalentNodeAttr()
  else
    if self._talent ~= nil then
      self:__RefreshTalentAllAttr()
    end
  end
  ;
  (CS_LayoutRebuilder.ForceRebuildLayoutImmediate)((self.ui).attriRect)
  local targetHeight = self.defaultAddtionHeight + (((self.ui).attriRect).rect).height
  targetHeight = (math.min)(targetHeight, self.defalutAttriNodeHeight)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).attriNode).minHeight = targetHeight
end

UINHeroTalentHeroInfo.__RefreshTalentNodeAttr = function(self)
  -- function num : 0_8 , upvalues : _ENV
  local attributeUpDic = nil
  local flag, selctId = (self._talentNode):GetHeroTalentNodeBranchId()
  if flag then
    attributeUpDic = (self._talentNode):GetTalentNextLvBranchAttriDescrib()
    if attributeUpDic ~= nil then
      attributeUpDic = attributeUpDic[selctId]
    end
  else
    attributeUpDic = (self._talentNode):GetTalentNextLvAttriDescrib()
  end
  if attributeUpDic == nil or (table.count)(attributeUpDic) == 0 then
    return 
  end
  ;
  ((self.ui).tex_Tile):SetIndex(0)
  ;
  ((self.ui).attNode):SetActive(true)
  ;
  (self._effectPool):HideAll()
  local talent = (self._heroData):GetHeroDataTalent()
  if talent == nil then
    error("talent is nil")
    return 
  end
  for attriId,info in pairs(attributeUpDic) do
    local attriCfg = (ConfigData.attribute)[attriId]
    local shoeAttriId = attriCfg.merge_attribute > 0 and attriCfg.merge_attribute or attriId
    local item = (self._effectPool):GetOne()
    talent:SetSingleAttrBouns(attriId, -info.cur)
    local oriAttr = (self._heroData):GetAttr(shoeAttriId, false, true)
    talent:SetSingleAttrBouns(attriId, info.cur)
    local nextAttr = nil
    if info.next ~= nil then
      local diffVal = info.next - info.cur
      talent:SetSingleAttrBouns(attriId, diffVal)
      nextAttr = (self._heroData):GetAttr(shoeAttriId, false, true)
      talent:SetSingleAttrBouns(attriId, -diffVal)
    else
      do
        do
          nextAttr = (self._heroData):GetAttr(shoeAttriId, false, true)
          item:RefreshDetailEffectByAttriId(shoeAttriId, oriAttr, nextAttr, false)
          -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC117: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
end

UINHeroTalentHeroInfo.__RefreshTalentAllAttr = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local attributeUpDic = (self._talent):GetAttributeAddtionAll()
  if attributeUpDic == nil or (table.count)(attributeUpDic) == 0 then
    return 
  end
  ;
  ((self.ui).tex_Tile):SetIndex(1)
  ;
  ((self.ui).attNode):SetActive(true)
  ;
  (self._effectPool):HideAll()
  local heroTalent = (self._heroData):GetHeroDataTalent()
  ;
  (self._heroData):BindHeroDataTalent(nil)
  local attriShowDic = {}
  for attriId,attriVal in pairs(attributeUpDic) do
    local attriCfg = (ConfigData.attribute)[attriId]
    local shoeAttriId = attriCfg.merge_attribute > 0 and attriCfg.merge_attribute or attriId
    if attriShowDic[shoeAttriId] == nil then
      attriShowDic[shoeAttriId] = (self._heroData):GetAttr(attriId, false, true)
    end
  end
  ;
  (self._heroData):BindHeroDataTalent(heroTalent)
  for attriId,attriVal in pairs(attriShowDic) do
    local item = (self._effectPool):GetOne()
    local curAttr = (self._heroData):GetAttr(attriId, false, true)
    local diffAttr = curAttr - attriVal
    item:RefreshDetailEffectByAttriId(attriId, diffAttr, nil, false)
  end
end

UINHeroTalentHeroInfo.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINHeroTalentHeroInfo

