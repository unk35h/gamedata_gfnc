-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEpSptRoomHeroDetail = class("UINEpSptRoomHeroDetail", UIBaseNode)
local base = UIBaseNode
local UINDungeonInfoHeroDetailAttr = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoHeroDetailAttr")
local UINDungeonInfoHeroDetailSkill = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoHeroDetailSkill")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
UINEpSptRoomHeroDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINDungeonInfoHeroDetailAttr, UINDungeonInfoHeroDetailSkill
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.potentialImgWidth = ((((self.ui).img_Breakthrough).sprite).textureRect).width
  ;
  ((self.ui).attriItem):SetActive(false)
  self.attrItemPool = (UIItemPool.New)(UINDungeonInfoHeroDetailAttr, (self.ui).attriItem)
  ;
  ((self.ui).skillItem):SetActive(false)
  self.skillItemPool = (UIItemPool.New)(UINDungeonInfoHeroDetailSkill, (self.ui).skillItem)
  self.__onShowSkillDetail = BindCallback(self, self.__ShowSkillDetail)
  self.__onHideRichInfoDetail = BindCallback(self, self.__HideRichInfoDetail)
end

UINEpSptRoomHeroDetail._InitBase = function(self, heroData)
  -- function num : 0_1
  self:_RefreshPotential(heroData.potential)
  self:_RefreshLevel(heroData.level)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_HeroName).text = heroData:GetName()
end

UINEpSptRoomHeroDetail.InitEpSptExRoomHeroDetail = function(self, heroData, resloader, fightPower)
  -- function num : 0_2 , upvalues : _ENV, DynBattleSkill
  self:_InitBase(heroData)
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(fightPower)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_HP).fillAmount = 1
  local maxHp = heroData:GetAttr(eHeroAttr.maxHp)
  ;
  ((self.ui).tex_HP):SetIndex(0, tostring((math.floor)(maxHp)), tostring(maxHp))
  ;
  (self.attrItemPool):HideAll()
  for _,attrId in ipairs((ConfigData.game_config).dungeonHeroMainAttrIds) do
    local attrVal = heroData:GetAttr(attrId)
    local attrItem = (self.attrItemPool):GetOne()
    attrItem:InitAttr(attrId, attrVal, attrVal)
  end
  ;
  (self.skillItemPool):HideAll()
  for k,skillData in ipairs(heroData.skillList) do
    if skillData.type ~= eHeroSkillType.LifeSkill and not skillData:IsCommonAttack() then
      local skillItem = (self.skillItemPool):GetOne()
      local battleSkill = (DynBattleSkill.New)(skillData.dataId, skillData.level, eBattleSkillLogicType.Original, skillData:IsSkillUnlockAdvance())
      battleSkill:SetIsFullLevel(skillData:IsFullLevel())
      skillItem:InitDungeonSkillItem(battleSkill, resloader, self.__onShowSkillDetail, self.__onHideRichInfoDetail)
    end
  end
end

UINEpSptRoomHeroDetail.InitEpSptRoomHeroDetail = function(self, dynHeroData, resloader, fightPower)
  -- function num : 0_3 , upvalues : _ENV
  local heroData = dynHeroData.heroData
  self:_InitBase(heroData)
  local power = fightPower
  if power == nil then
    power = dynHeroData:GetFightingPower()
  end
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(power)
  local hpPer = dynHeroData.hpPer / 10000
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_HP).fillAmount = hpPer
  local maxHp = dynHeroData:GetRealAttr(eHeroAttr.maxHp)
  local realHp = maxHp * dynHeroData.hpPer / 10000
  if dynHeroData.hpPer / 10000 > 0 then
    realHp = (math.max)(1, realHp)
  end
  ;
  ((self.ui).tex_HP):SetIndex(0, tostring((math.floor)(realHp)), tostring(maxHp))
  ;
  (self.attrItemPool):HideAll()
  for _,attrId in ipairs((ConfigData.game_config).dungeonHeroMainAttrIds) do
    local attrVal = dynHeroData:GetRealAttr(attrId)
    local attrOriginVal = dynHeroData:GetOriginAttr(attrId)
    local attrItem = (self.attrItemPool):GetOne()
    attrItem:InitAttr(attrId, attrVal, attrOriginVal)
  end
  ;
  (self.skillItemPool):HideAll()
  for index,skillData in pairs(dynHeroData.showSkillDic) do
    if not skillData:IsCommonAttack() then
      local skillItem = (self.skillItemPool):GetOne()
      skillItem:InitDungeonSkillItem(skillData, resloader, self.__onShowSkillDetail, self.__onHideRichInfoDetail)
    end
  end
  for _,skillitem in ipairs((self.skillItemPool).listItem) do
    if (skillitem.skillData):IsPassiveSkill() then
      (skillitem.transform):SetSiblingIndex(0)
    else
      if (skillitem.skillData):IsUniqueSkill() then
        (skillitem.transform):SetSiblingIndex(#(self.skillItemPool).listItem)
      end
    end
  end
end

UINEpSptRoomHeroDetail._RefreshLevel = function(self, level)
  -- function num : 0_4 , upvalues : _ENV
  if level > 999 then
    warn("level Num is out off MaxSize 999")
  end
  local empty = ""
  if level <= 9 then
    empty = "00"
  else
    if level <= 99 then
      empty = "0"
    end
  end
  ;
  ((self.ui).tex_Level):SetIndex(0, empty, level)
end

UINEpSptRoomHeroDetail._RefreshPotential = function(self, potential)
  -- function num : 0_5
  local vec = (((self.ui).img_Breakthrough).rectTransform).sizeDelta
  vec.x = self.potentialImgWidth * potential
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (((self.ui).img_Breakthrough).rectTransform).sizeDelta = vec
end

UINEpSptRoomHeroDetail.__ShowSkillDetail = function(self, item, skillData)
  -- function num : 0_6 , upvalues : _ENV
  if skillData:GetIsUnlock() then
    UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_6_0 , upvalues : self, skillData
    if win ~= nil then
      self:__RichIntroOpen(skillData, win)
    end
  end
)
  end
end

UINEpSptRoomHeroDetail.__RichIntroOpen = function(self, skillData, win)
  -- function num : 0_7 , upvalues : _ENV, cs_Edge
  local modifier = nil
  local infowin = UIManager:GetWindow(UIWindowTypeID.DungeonInfoDetail)
  if infowin ~= nil then
    modifier = (infowin.ui).modifier
  end
  win:ShowIntroBySkillData((self.ui).introHolder, skillData, true, modifier, nil, nil, 1)
  win:SetIntroListPosition(cs_Edge.Left)
end

UINEpSptRoomHeroDetail.__HideRichInfoDetail = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
end

UINEpSptRoomHeroDetail.OnDelete = function(self)
  -- function num : 0_9 , upvalues : base
  (self.attrItemPool):DeleteAll()
  ;
  (self.skillItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINEpSptRoomHeroDetail

