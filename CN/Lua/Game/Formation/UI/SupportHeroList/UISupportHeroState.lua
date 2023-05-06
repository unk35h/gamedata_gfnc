-- params : ...
-- function num : 0 , upvalues : _ENV
local UISupportHeroState = class("UISupportHeroState", UIBaseWindow)
local base = UIBaseWindow
local UINSupportHeroSkill = require("Game.Formation.UI.SupportHeroList.UINSupportHeroSkill")
local UINSupportHeroAth = require("Game.Formation.UI.SupportHeroList.UINSupportHeroAth")
local UINHeroTag = require("Game.Hero.NewUI.State.UINHeroTag")
local UINHeroAttrItem = require("Game.Formation.UI.Common.UINHeroAttrItem")
local UINAthSuitMainItem = require("Game.Arithmetic.AthMain.UINAthSuitMainItem")
local UIHeroUtil = require("Game.CommonUI.Hero.UIHeroUtil")
local FixedFmtHeroData = require("Game.PlayerData.Hero.FixedFmtHeroData")
local cs_ResLoader = CS.ResLoader
UISupportHeroState.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, cs_ResLoader, UINHeroTag, UINHeroAttrItem, UINSupportHeroAth, UINAthSuitMainItem, UINSupportHeroSkill
  (UIUtil.SetTopStatus)(self, self._OnClickReturn)
  self.resloader = (cs_ResLoader.Create)()
  self.startList = {}
  ;
  (table.insert)(self.startList, (self.ui).img_star)
  ;
  (((self.ui).img_star).gameObject):SetActive(false)
  self.tagPool = (UIItemPool.New)(UINHeroTag, (self.ui).tagItem)
  ;
  ((self.ui).tagItem):SetActive(false)
  self.attrPool = (UIItemPool.New)(UINHeroAttrItem, (self.ui).attriItem)
  ;
  ((self.ui).attriItem):SetActive(false)
  self.athPool = (UIItemPool.New)(UINSupportHeroAth, (self.ui).athItem)
  ;
  ((self.ui).athItem):SetActive(false)
  self.athSuitPool = (UIItemPool.New)(UINAthSuitMainItem, (self.ui).suitItem)
  ;
  ((self.ui).suitItem):SetActive(false)
  self.skillItemList = {}
  for i,skillItemObj in ipairs((self.ui).skillItemArr) do
    local item = (UINSupportHeroSkill.New)()
    item:Init(skillItemObj)
    ;
    (table.insert)(self.skillItemList, item)
  end
  for _,tween in ipairs((self.ui).tweens) do
    tween:DOPlay()
  end
  self._onDescribeChange = BindCallback(self, self._OnSupportHeroDescribeChange)
  MsgCenter:AddListener(eMsgEventId.DescribeSettingChange, self._onDescribeChange)
end

UISupportHeroState.InitSupportHeroState = function(self, supportHeroData)
  -- function num : 0_1
  self.supportHeroData = supportHeroData
  self:RefreshHeroBase()
  self:RefreshHeroDetail()
  self:RefreshHeroSkill()
  self:RefreshTalentState()
end

UISupportHeroState.RefreshHeroBase = function(self)
  -- function num : 0_2 , upvalues : _ENV, FixedFmtHeroData, UIHeroUtil, cs_ResLoader
  local heroCfg = (self.supportHeroData).heroCfg
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(heroCfg.name)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_ENName).text = heroCfg.name_en
  -- DECOMPILER ERROR at PC26: Confused about usage of register: R2 in 'UnsetPending'

  if IsInstanceOfClass(self.supportHeroData, FixedFmtHeroData) then
    ((self.ui).tex_Efficiency).text = tostring((self.supportHeroData):GetFightingPower())
  else
    -- DECOMPILER ERROR at PC35: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_Efficiency).text = tostring((self.supportHeroData):GetSupporterPow())
  end
  ;
  ((self.ui).img_Carrer):SetIndex(heroCfg.career - 1)
  ;
  ((self.ui).tex_Level):SetIndex(0, (UIHeroUtil.GetHeroLevelColorHexStr)((self.supportHeroData).level))
  local rare = ((self.supportHeroData).rankCfg).rare
  -- DECOMPILER ERROR at PC58: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).img_Quality).color = HeroRareColor[rare]
  local campCfg = (ConfigData.camp)[(self.supportHeroData).camp]
  ;
  (((self.ui).img_Camp).gameObject):SetActive(false)
  ;
  (self.resloader):LoadABAssetAsync(PathConsts:GetCampPicPath(campCfg.icon), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    ;
    (((self.ui).img_Camp).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Camp).texture = texture
  end
)
  if self.heroModel ~= nil then
    DestroyUnityObject(self.heroModel)
    self.heroModel = nil
  end
  if self.heroLoader ~= nil then
    (self.heroLoader):Put2Pool()
    self.heroLoader = nil
  end
  self.heroLoader = (cs_ResLoader.Create)()
  local resName = (self.supportHeroData):GetResPicName()
  resName = PathConsts:GetCharacterBigImgPrefabPath(resName)
  ;
  (self.heroLoader):LoadABAssetAsync(resName, function(prefab)
    -- function num : 0_2_1 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self.heroModel = prefab:Instantiate(((self.ui).heroHolder).transform)
    local commonPicCtrl = (self.heroModel):FindComponent(eUnityComponentID.CommonPicController)
    commonPicCtrl:SetPosType("HeroSkin")
    if (self.supportHeroData):GetHeroIsNotHaveLegalSkin() then
      local rawImage = (self.heroModel):FindComponent(eUnityComponentID.RawImage)
      rawImage.material = (((CS.UnityEngine).Object).Instantiate)((self.ui).mat_heroPicPaperCut)
    end
  end
)
  local tags = (self.supportHeroData):GetHeroTag()
  ;
  (self.tagPool):HideAll()
  for _,tagId in ipairs(tags) do
    local item = (self.tagPool):GetOne()
    item:InitTag(tagId)
  end
end

UISupportHeroState.RefreshHeroDetail = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local starCount = (math.ceil)((self.supportHeroData).star / 2)
  local isHalfStar = (self.supportHeroData):IsHalfStar()
  for i = 1, starCount do
    local starItem = (self.startList)[i]
    if starItem == nil then
      starItem = ((((self.ui).img_star).gameObject):Instantiate()):GetComponent(typeof(CS.UiImageItemInfo))
      ;
      (table.insert)(self.startList, starItem)
    end
    ;
    (starItem.gameObject):SetActive(true)
    if i < starCount then
      starItem:SetIndex(0)
    else
      starItem:SetIndex(isHalfStar and 1 or 0)
    end
  end
  local potentialImgWidth = ((((self.ui).img_Breakthrough).sprite).textureRect).width
  local vec = (((self.ui).img_Breakthrough).rectTransform).sizeDelta
  vec.x = potentialImgWidth * (self.supportHeroData).potential
  -- DECOMPILER ERROR at PC69: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (((self.ui).img_Breakthrough).rectTransform).sizeDelta = vec
  ;
  (self.attrPool):HideAll()
  for k,attrId in ipairs((ConfigData.game_config).supportDetailAttr) do
    local attrValue = (self.supportHeroData):GetAttr(attrId, true)
    local item = (self.attrPool):GetOne()
    item:InitHeroAttrItem(attrId, attrValue, nil)
  end
  ;
  (self.athPool):HideAll()
  local athSlotList = (self.supportHeroData):GetAthSlotList()
  for index,space in ipairs(athSlotList) do
    local slotDic = (self.supportHeroData):GetAthSlotInfo(index)
    local item = (self.athPool):GetOne()
    item:InitAth(index, space, slotDic)
  end
  local athSuitDic = (self.supportHeroData):GetAthSuit()
  ;
  (self.athSuitPool):HideAll()
  if (table.count)(athSuitDic) == 0 then
    ((self.ui).obj_NoSuit):SetActive(true)
  else
    ;
    ((self.ui).obj_NoSuit):SetActive(false)
    local athSuitList = {}
    local showMax = 2
    local theSuitCountMinData = nil
    for athSuitId,count in pairs(athSuitDic) do
      if #athSuitList < showMax then
        local suitData = {id = athSuitId, curCount = count}
        ;
        (table.insert)(athSuitList, suitData)
        if theSuitCountMinData == nil or count < theSuitCountMinData.curCount then
          theSuitCountMinData = suitData
        end
      else
        do
          if theSuitCountMinData.curCount < count then
            theSuitCountMinData.id = athSuitId
            theSuitCountMinData.curCount = count
            for _,temp in ipairs(athSuitList) do
              if temp.curCount < theSuitCountMinData.curCount then
                theSuitCountMinData = temp
              end
            end
          end
          do
            -- DECOMPILER ERROR at PC182: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC182: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC182: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    ;
    (table.sort)(athSuitList, function(a, b)
    -- function num : 0_3_0
    if b.curCount >= a.curCount then
      do return a.curCount == b.curCount end
      do return a.id < b.id end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
    for _,data in ipairs(athSuitList) do
      data.cfg = ((ConfigData.ath_suit)[data.id])[1]
      local item = (self.athSuitPool):GetOne()
      item:InitAthSuitMainItem(data, self.resloader)
    end
  end
  do
    local weaponId, weaponData = (self.supportHeroData):GetSpecWeaponData()
    if weaponId then
      ((self.ui).obj_SpecWeapon):SetActive(true)
      local heroId = (self.supportHeroData).dataId
      ;
      (self.resloader):LoadABAssetAsync(PathConsts:GetSpecWeaponPicPath(heroId), function(texture)
    -- function num : 0_3_1 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    if not texture then
      error("specWeapon icon texture not exit")
      return 
    end
    -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_SpecWeapon).texture = texture
  end
)
      ;
      ((self.ui).obj_WeaponUnlock):SetActive(false)
      if weaponData then
        ((self.ui).img_ArmaLvbg):SetActive(true)
        local step = weaponData:GetSpecWeaponCurStep()
        -- DECOMPILER ERROR at PC248: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((self.ui).tex_SpecWeaponState).text = (LanguageUtil.GetRomanNumber)(step)
        -- DECOMPILER ERROR at PC257: Confused about usage of register: R11 in 'UnsetPending'

        ;
        ((self.ui).tex_SpecWeaponLv).text = "LV." .. tostring(weaponData:GetSpecWeaponCurLevel())
      else
        do
          do
            ;
            ((self.ui).img_ArmaLvbg):SetActive(false)
            ;
            ((self.ui).obj_WeaponUnlock):SetActive(true)
            ;
            ((self.ui).obj_SpecWeapon):SetActive(false)
          end
        end
      end
    end
  end
end

UISupportHeroState.RefreshHeroSkill = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local skillDataList = {}
  for i,skillData in ipairs((self.supportHeroData).skillList) do
    if not skillData:IsCommonAttack() then
      (table.insert)(skillDataList, skillData)
    end
  end
  for i = 1, #self.skillItemList do
    local item = (self.skillItemList)[i]
    if #skillDataList < i then
      item:Hide()
    else
      item:Show()
      item:InitSupportHeroSkill(skillDataList[i], self.resloader)
    end
  end
end

UISupportHeroState.RefreshTalentState = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if (ConfigData.buildinConfig).HeroTalentForbid then
    ((self.ui).talentHolder):SetActive(false)
    return 
  end
  ;
  ((self.ui).talentHolder):SetActive(true)
  ;
  (((self.ui).btn_ShowIntro).gameObject):SetActive(false)
  local level = (self.supportHeroData):GetSupportHerotalentLevel()
  local stage, stageDes = ConfigData:GetTalentStage(level)
  ;
  ((self.ui).img_Talent):SetIndex(stage - 1)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_TalentStage).text = stageDes
end

UISupportHeroState._OnClickReturn = function(self)
  -- function num : 0_6 , upvalues : _ENV
  for _,tween in ipairs((self.ui).tweens) do
    tween:DOKill()
  end
  self:Delete()
end

UISupportHeroState._OnSupportHeroDescribeChange = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.skillItemList == nil then
    return 
  end
  for _,item in ipairs(self.skillItemList) do
    item:UpdateLevelDescribe()
  end
end

UISupportHeroState.OnDeleteEntity = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnDeleteEntity)(self)
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  if self.heroLoader ~= nil then
    (self.heroLoader):Put2Pool()
    self.heroLoader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.DescribeSettingChange, self._onDescribeChange)
end

return UISupportHeroState

