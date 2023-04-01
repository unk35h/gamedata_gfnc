-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDungeonInfoHeroDetail = class("UINDungeonInfoHeroDetail", UIBaseNode)
local base = UIBaseNode
local UINDungeonInfoHeroDetailAttr = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoHeroDetailAttr")
local UINDungeonInfoHeroDetailSkill = require("Game.CommonUI.DungeonState.Info.UINDungeonInfoHeroDetailSkill")
local UINHeroCardItem = require("Game.Hero.NewUI.UINHeroCardItem")
local UINDungeonServerGridItem = require("Game.CommonUI.DungeonState.Info.UINDungeonServerGridItem")
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local UINBattleBuffStatusItem = require("Game.Battle.UI.UINBattleBuffStatusItem")
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
UINDungeonInfoHeroDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINHeroCardItem, UINDungeonInfoHeroDetailAttr, UINDungeonInfoHeroDetailSkill, UINBattleBuffStatusItem, UINDungeonServerGridItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.cardItem = (UINHeroCardItem.New)()
  ;
  (self.cardItem):Init((self.ui).obj_heroItem)
  self.attrPool = (UIItemPool.New)(UINDungeonInfoHeroDetailAttr, (self.ui).obj_attriItem)
  ;
  ((self.ui).obj_attriItem):SetActive(false)
  self.skillPool = (UIItemPool.New)(UINDungeonInfoHeroDetailSkill, (self.ui).obj_skillItem)
  ;
  ((self.ui).obj_skillItem):SetActive(false)
  self._buffStatusPool = (UIItemPool.New)(UINBattleBuffStatusItem, (self.ui).introItem)
  ;
  ((self.ui).introItem):SetActive(false)
  self.serverGridPool = (UIItemPool.New)(UINDungeonServerGridItem, (self.ui).gridBuffItem)
  ;
  ((self.ui).gridBuffItem):SetActive(false)
  self.__onShowSkillDetail = BindCallback(self, self.__ShowSkillDetail)
  self.__onHideRichInfoDetail = BindCallback(self, self.__HideRichInfoDetail)
  self.__onShowServerGridDetail = BindCallback(self, self.__ShowServerGridDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).attrTag, self, self.OnClickAttrDetail)
  ;
  (UIUtil.AddButtonListener)((self.ui).statusTag, self, self.OnClickStatusDetail)
end

UINDungeonInfoHeroDetail.InitHeroInfo = function(self, dynHeroData, resloader)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Power).text = tostring(dynHeroData:GetFightingPower())
  local hpPer = dynHeroData.hpPer / 10000
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_Hp).fillAmount = hpPer
  local maxHp = dynHeroData:GetRealAttr(eHeroAttr.maxHp)
  local realHp = maxHp * dynHeroData.hpPer / 10000
  if dynHeroData.hpPer / 10000 > 0 then
    realHp = (math.max)(1, realHp)
  end
  ;
  ((self.ui).tex_Hp):SetIndex(0, tostring((math.floor)(realHp)), tostring(maxHp))
  ;
  (self.attrPool):HideAll()
  for _,attrId in ipairs((ConfigData.game_config).dungeonHeroMainAttrIds) do
    local attrVal = dynHeroData:GetRealAttr(attrId)
    local attrOriginVal = dynHeroData:GetOriginAttr(attrId)
    local attrItem = (self.attrPool):GetOne(true)
    attrItem:InitAttr(attrId, attrVal, attrOriginVal)
  end
  self:__InitCommon(dynHeroData, resloader)
  ;
  (((self.ui).attrTag).gameObject):SetActive(false)
  ;
  (((self.ui).statusTag).gameObject):SetActive(false)
  self:OnClickAttrDetail()
end

UINDungeonInfoHeroDetail.InitHeroInfoInBattle = function(self, entity, resloader)
  -- function num : 0_2 , upvalues : _ENV
  local dynHeroData = entity.character
  local realAttrs = entity.realAttrList
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_Power).text = tostring(dynHeroData:GetFightingPower())
  local maxHp = entity.maxHp
  local hpPer = entity.hp / maxHp
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Hp).fillAmount = hpPer
  local realHp = maxHp * hpPer
  if hpPer > 0 then
    realHp = (math.max)(1, realHp)
  end
  ;
  ((self.ui).tex_Hp):SetIndex(0, tostring((math.floor)(realHp)), tostring(maxHp))
  ;
  (self.attrPool):HideAll()
  for _,attrId in ipairs((ConfigData.game_config).dungeonHeroMainAttrIds) do
    local attrVal = realAttrs[attrId] or 0
    local attrOriginVal = dynHeroData:GetOriginAttr(attrId)
    local attrItem = (self.attrPool):GetOne(true)
    attrItem:InitAttr(attrId, attrVal, attrOriginVal)
  end
  self:__InitCommon(dynHeroData, resloader)
  ;
  (((self.ui).attrTag).gameObject):SetActive(false)
  ;
  (((self.ui).statusTag).gameObject):SetActive(false)
  self:OnClickAttrDetail()
end

UINDungeonInfoHeroDetail.__InitCommon = function(self, dynHeroData, resloader)
  -- function num : 0_3 , upvalues : _ENV, ExplorationEnum
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).img_Quality).color = HeroRareColor[(dynHeroData.heroData).rare]
  local inTd = (BattleUtil.IsInTDBattle)()
  ;
  (self.cardItem):InitHeroCardItem(dynHeroData.heroData, resloader, nil)
  ;
  (self.cardItem):ShowTalentStage(dynHeroData:GetDynHeroTalentLevel())
  local gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).None
  local isTdSpecHero = not inTd or ((ConfigData.skill_adapter).td_adapter)[dynHeroData.dataId] ~= nil
  if isTdSpecHero then
    gameTypeAdapter = (ExplorationEnum.SpecGameTypeAdapter).TD
  end
  ;
  (self.cardItem):SetSpecialGameHeroActive(gameTypeAdapter)
  ;
  (self.skillPool):HideAll()
  for _,skillData in pairs(dynHeroData.showSkillDic) do
    if not skillData:IsCommonAttack() then
      local skillItem = (self.skillPool):GetOne(true)
      skillItem:InitDungeonSkillItem(skillData, resloader, self.__onShowSkillDetail, self.__onHideRichInfoDetail)
      if skillData:GetSkillAdapterType() > 0 and inTd then
        skillItem:ShowAsTdSkill()
      end
    end
  end
  for _,skillitem in ipairs((self.skillPool).listItem) do
    if (skillitem.skillData):IsPassiveSkill() then
      (skillitem.transform):SetSiblingIndex(0)
    elseif (skillitem.skillData):IsUniqueSkill() then
      (skillitem.transform):SetSiblingIndex(#(self.skillPool).listItem)
    end
  end
  if ExplorationManager.epCtrl ~= nil then
    (self.serverGridPool):HideAll()
    local dynPlayer = (ExplorationManager.epCtrl).dynPlayer
    local gridlist = (dynPlayer.allDynServerGrid):GetHeroServerGrid(dynHeroData.dataId)
    if gridlist ~= nil then
      for _,serverGrid in pairs(gridlist) do
        local gridItem = (self.serverGridPool):GetOne()
        gridItem:InitServerGridItem(serverGrid, self.__onShowServerGridDetail, self.__onHideRichInfoDetail)
      end
    end
  end
  -- DECOMPILER ERROR: 8 unprocessed JMP targets
end

UINDungeonInfoHeroDetail.__ShowSkillDetail = function(self, item, skillData)
  -- function num : 0_4 , upvalues : _ENV
  if skillData:GetIsUnlock() then
    self.__onRichIntroOpen = BindCallback(self, self.__RichIntroOpen, skillData)
    UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_4_0 , upvalues : self
    if win ~= nil then
      (self.__onRichIntroOpen)(win)
    end
  end
)
  end
end

UINDungeonInfoHeroDetail.__RichIntroOpen = function(self, skillData, win)
  -- function num : 0_5 , upvalues : _ENV, cs_Edge
  local modifier = nil
  local infowin = UIManager:GetWindow(UIWindowTypeID.DungeonInfoDetail)
  if infowin ~= nil then
    modifier = (infowin.ui).modifier
  end
  win:ShowIntroBySkillData((self.ui).introHolder, skillData, true, modifier)
  win:SetIntroListPosition(cs_Edge.Left)
end

UINDungeonInfoHeroDetail.__HideRichInfoDetail = function(self)
  -- function num : 0_6 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
end

UINDungeonInfoHeroDetail.__ShowServerGridDetail = function(self, serverGrid)
  -- function num : 0_7 , upvalues : _ENV, cs_Edge
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_7_0 , upvalues : _ENV, serverGrid, self, cs_Edge
    if win == nil then
      return 
    end
    local modifier = nil
    local infowin = UIManager:GetWindow(UIWindowTypeID.DungeonInfoDetail)
    if infowin ~= nil then
      modifier = (infowin.ui).modifier
    end
    local name, desc = serverGrid:GetGridNameAndDesc()
    win:ShowIntroCustom((self.ui).gridIntroHolder, name, desc, true, modifier)
    win:SetIntroListPosition(cs_Edge.Left, cs_Edge.Top)
  end
)
end

UINDungeonInfoHeroDetail.OnClickAttrDetail = function(self)
  -- function num : 0_8 , upvalues : _ENV
  ((self.ui).heroNode):SetActive(true)
  ;
  ((self.ui).stateNode):SetActive(false)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_attrTag).color = (self.ui).selectColor
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).attrTagText).color = Color.white
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_statusTag).color = (self.ui).normalColor
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).statusTagText).color = (self.ui).normalTextColor
end

UINDungeonInfoHeroDetail.OnClickStatusDetail = function(self)
  -- function num : 0_9 , upvalues : _ENV
  ((self.ui).heroNode):SetActive(false)
  ;
  ((self.ui).stateNode):SetActive(true)
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_statusTag).color = (self.ui).selectColor
  -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).statusTagText).color = Color.white
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).img_attrTag).color = (self.ui).normalColor
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).attrTagText).color = (self.ui).normalTextColor
end

UINDungeonInfoHeroDetail.OnDelete = function(self)
  -- function num : 0_10 , upvalues : base
  (base.OnDelete)(self)
end

return UINDungeonInfoHeroDetail

