-- params : ...
-- function num : 0 , upvalues : _ENV
local UIBattleEnemyDetail = class("UIBattleEnemyDetail", UIBaseWindow)
local base = UIBaseWindow
local UIAttrUtil = require("Game.CommonUI.Hero.Attr.UIAttrUtil")
local UINEnemyBreakDes = require("Game.Battle.UI.UINEnemyBreakDes")
local UINEnemySkillItem = require("Game.Battle.UI.UINEnemySkillItem")
local UINEnemyTagItem = require("Game.Battle.UI.UINEnemyTagItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local UINBattleGirdInfoNode = require("Game.Battle.UI.Grid.UINBattleGirdInfoNode")
local UINBattleMetalGear = require("Game.Battle.UI.UINBattleMetalGear")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local UINBattleBuffStatusItem = require("Game.Battle.UI.UINBattleBuffStatusItem")
local CS_ResLoader = CS.ResLoader
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
local cs_BattleManager = CS.BattleManager
local TagState = {Attr = 1, Skill = 2, Status = 3}
UIBattleEnemyDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : UINBattleGirdInfoNode, UINEnemyBreakDes, _ENV, UINEnemySkillItem, UINEnemyTagItem, UINBattleBuffStatusItem
  self.battleGirdInfoNode = (UINBattleGirdInfoNode.New)()
  ;
  (self.battleGirdInfoNode):Init((self.ui).battleGirdInfoNode)
  self.breakNode = (UINEnemyBreakDes.New)()
  ;
  (self.breakNode):Init((self.ui).breakNode)
  ;
  ((self.ui).skillIntroItem):SetActive(false)
  self.skillItemPool = (UIItemPool.New)(UINEnemySkillItem, (self.ui).skillIntroItem)
  ;
  ((self.ui).obj_tag):SetActive(false)
  self.tagItemPool = (UIItemPool.New)(UINEnemyTagItem, (self.ui).obj_tag)
  self._buffStatusPool = (UIItemPool.New)(UINBattleBuffStatusItem, (self.ui).IntroItem)
  ;
  ((self.ui).IntroItem):SetActive(false)
  self._showBreakDetailFunc = BindCallback(self, self._ShowBreakDetail)
  self.__onShowSkillDetail = BindCallback(self, self.__ShowSkillDetail)
  self.__OnChipDetailActiveChange = BindCallback(self, self.OnChipDetailActiveChange)
  MsgCenter:AddListener(eMsgEventId.OnDungeonDetailWinChange, self.__OnChipDetailActiveChange)
  self.resloader = ((CS.ResLoader).Create)()
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_attrTag, self, self.__Switch2AttrWidget)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_skillTag, self, self.__Switch2SkillWidget)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_statusTag, self, self.OnClickBuffDetail)
end

UIBattleEnemyDetail.InitBattleEnemyDetail = function(self, dynRole, isNew, characterEntity)
  -- function num : 0_1 , upvalues : _ENV, TagState
  self:_UpdDetailPanelPos(characterEntity)
  if isNew then
    ((self.ui).obj_isNew):SetActive(true)
  else
    ;
    ((self.ui).obj_isNew):SetActive(false)
  end
  AudioManager:PlayAudioById(1079)
  if self.dynRole ~= dynRole then
    self.tagState = nil
    self.dynRole = dynRole
  end
  self.isSummoner = false
  ;
  ((self.ui).detailTag):SetActive(true)
  self.characterEntity = characterEntity
  if not dynRole.isShowInfoBar then
    ((self.ui).obj_power):SetActive(false)
  else
    ;
    ((self.ui).obj_power):SetActive(true)
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R4 in 'UnsetPending'

    ;
    ((self.ui).tex_Power).text = tostring(dynRole:GetFightingPower())
  end
  -- DECOMPILER ERROR at PC57: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = dynRole:GetMonsterInfo()
  ;
  (self.skillItemPool):HideAll()
  local monsterLableSkiilList = dynRole:GetItemSkillListByType(eBattleSkillLogicType.Lable)
  if #monsterLableSkiilList > 0 then
    for k,skillData in pairs(monsterLableSkiilList) do
      local skillItem = (self.skillItemPool):GetOne()
      skillItem:InitEnemySkillIntroItem(skillData, self.__onShowSkillDetail)
    end
  end
  do
    local originSkiilList = dynRole:GetOriginSkillList()
    for k,skillData in pairs(originSkiilList) do
      if not skillData:IsCommonAttack() and not skillData:IsHideViewSkill() then
        local skillItem = (self.skillItemPool):GetOne()
        skillItem:InitEnemySkillIntroItem(skillData, self.__onShowSkillDetail)
      end
    end
    if #(self.skillItemPool).listItem > 0 then
      ((self.ui).obj_skills):SetActive(true)
    else
      ;
      ((self.ui).obj_skills):SetActive(false)
    end
    local monsterTag, isCS = (self.dynRole):GetRoleTag()
    self:_SetBaseProperty(dynRole:GetName(), dynRole:GetCareer(), dynRole:GetResPicName(), monsterTag, isCS)
    self:__ShowEnemyEffctGrid(dynRole.x, dynRole.y)
    UIManager:HideWindow(UIWindowTypeID.RichIntro)
    self.selSkillData = nil
    self._selBreakCompnt = nil
    self.tagState = self.tagState or TagState.Skill
    if self.tagState == TagState.Skill then
      self:__Switch2SkillWidget()
    else
      if self.tagState == TagState.Attr then
        self:__Switch2AttrWidget()
      end
    end
    self:_UpdBreakDes(characterEntity:GetBreakComponent())
    ;
    (((self.ui).btn_statusTag).gameObject):SetActive(false)
  end
end

UIBattleEnemyDetail.InitBattleSummonerDetail = function(self, dynSummoner, summonerEntity)
  -- function num : 0_2 , upvalues : _ENV, DynBattleSkill, TagState
  self:_UpdDetailPanelPos(summonerEntity)
  ;
  (((self.ui).btn_statusTag).gameObject):SetActive(false)
  ;
  ((self.ui).obj_isNew):SetActive(false)
  AudioManager:PlayAudioById(1079)
  if self.dynRole ~= dynSummoner then
    self.tagState = nil
    self.dynRole = dynSummoner
  end
  self.isSummoner = true
  ;
  ((self.ui).obj_power):SetActive(false)
  local monsterTag, isCS = (dynSummoner.summonerCfg).MonsterTag, true
  self.summonerEntity = summonerEntity
  local resCfg = (ConfigData.resource_model)[dynSummoner.srcId]
  self:_SetBaseProperty(dynSummoner.name, dynSummoner.career, resCfg.res_Name, monsterTag, isCS)
  self:__ShowEnemyEffctGrid(dynSummoner.x, dynSummoner.y)
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
  self.selSkillData = nil
  self._selBreakCompnt = nil
  ;
  (self.skillItemPool):HideAll()
  local originSkiilList = dynSummoner.originSkillList
  local luaOriginSkillList = {}
  for _,skillData in pairs(originSkiilList) do
    local battleSkill = (DynBattleSkill.New)(skillData.dataId, skillData.level, eBattleSkillLogicType.Original)
    ;
    (table.insert)(luaOriginSkillList, battleSkill)
  end
  for k,skillData in pairs(luaOriginSkillList) do
    if not skillData:IsCommonAttack() and not skillData:IsHideViewSkill() then
      local skillItem = (self.skillItemPool):GetOne()
      skillItem:InitEnemySkillIntroItem(skillData, self.__onShowSkillDetail)
    end
  end
  do
    self.tagState = self.tagState or TagState.Skill
    if #(self.skillItemPool).listItem > 0 then
      ((self.ui).obj_skills):SetActive(true)
      ;
      ((self.ui).detailTag):SetActive(true)
    else
      ;
      ((self.ui).obj_skills):SetActive(false)
      self.tagState = TagState.Attr
      ;
      ((self.ui).detailTag):SetActive(false)
    end
    if self.tagState == TagState.Skill then
      self:__Switch2SkillWidget()
    else
      if self.tagState == TagState.Attr then
        self:__Switch2AttrWidget()
      end
    end
    self:_UpdBreakDes(summonerEntity:GetBreakComponent())
  end
end

UIBattleEnemyDetail._SetBaseProperty = function(self, roleName, careerId, picPath, tagList, isCS)
  -- function num : 0_3 , upvalues : _ENV
  self.roleName = roleName
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = self.roleName
  local careerCfg = (ConfigData.career)[careerId]
  if careerCfg == nil then
    error("Can\'t find careerCfg, campId = " .. tostring(careerId))
  else
    -- DECOMPILER ERROR at PC26: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).img_Career).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
  end
  local path = PathConsts:GetCharacterSmallPicPath(picPath)
  -- DECOMPILER ERROR at PC33: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).img_EnemyPic).enabled = false
  ;
  (self.resloader):LoadABAssetAsync(path, function(texture)
    -- function num : 0_3_0 , upvalues : _ENV, self
    -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

    if texture ~= nil and not IsNull(self.gameObject) then
      ((self.ui).img_EnemyPic).enabled = true
      -- DECOMPILER ERROR at PC12: Confused about usage of register: R1 in 'UnsetPending'

      ;
      ((self.ui).img_EnemyPic).texture = texture
    end
  end
)
  local tagEnd = nil
  local tagStart = 1
  if isCS then
    tagStart = 0
    tagEnd = tagList.Count - 1
  else
    tagEnd = #tagList
  end
  ;
  (self.tagItemPool):HideAll()
  for i = tagStart, tagEnd do
    local tagId = tagList[i]
    if tagId ~= nil then
      local tagCfg = (ConfigData.monster_tag)[tagId]
      if tagCfg == nil then
        error("Can\'t find tagCfg id=" .. tagId)
      else
        local item = (self.tagItemPool):GetOne()
        item:InitEnemyTagItem((LanguageUtil.GetLocaleText)(tagCfg.tag))
      end
    end
  end
  self:UpdateEnemyAttriWidget()
end

UIBattleEnemyDetail._UpdBreakDes = function(self, breakCompnt)
  -- function num : 0_4
  if breakCompnt == nil then
    (self.breakNode):Hide()
  else
    ;
    (self.breakNode):Show()
    ;
    (self.breakNode):InitEnemyBreakDes(breakCompnt, self._showBreakDetailFunc)
  end
end

UIBattleEnemyDetail._UpdDetailPanelPos = function(self, roleEntity)
  -- function num : 0_5 , upvalues : _ENV
  local roleTran = (roleEntity.lsObject).transform
  if IsNull(roleTran) then
    return 
  end
  local rolePosX = UIManager:World2UIPositionOut(roleTran, self.transform)
  local targetPosX = rolePosX - (((self.ui).uINEnemyDetail).sizeDelta).x / 2 - 150
  if targetPosX <= (self.ui).panelPosRangeX - ((self.transform).rect).width / 2 then
    targetPosX = rolePosX + (((self.ui).uINEnemyDetail).sizeDelta).x / 2 + 150
  end
  local anchoredPos = ((self.ui).uINEnemyDetail).anchoredPosition
  anchoredPos.x = targetPosX
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).uINEnemyDetail).anchoredPosition = anchoredPos
end

UIBattleEnemyDetail.UpdateEnemyAttriWidget = function(self)
  -- function num : 0_6 , upvalues : UIAttrUtil
  local attrDataList = nil
  local attrOutLineWindow = self.ui_attrMiniWidget
  if attrOutLineWindow == nil then
    if self.isSummoner then
      attrOutLineWindow = (UIAttrUtil.ShowSummonerAttrMiniWidget)(self.summonerEntity, (self.ui).attributeMiniWidget)
    else
      -- DECOMPILER ERROR at PC20: Overwrote pending register: R1 in 'AssignReg'

      attrOutLineWindow = (UIAttrUtil.ShowEntityAttrMiniWidget)(self.characterEntity, (self.ui).attributeMiniWidget)
    end
    attrOutLineWindow:Hide()
    self.ui_attrMiniWidget = attrOutLineWindow
  else
    -- DECOMPILER ERROR at PC39: Overwrote pending register: R1 in 'AssignReg'

  end
  if not self.isSummoner or not (UIAttrUtil.GetDynBattleRoleAttrDataListForShow)(self.summonerEntity, function(summonerEntity, attrId)
    -- function num : 0_6_0
    return summonerEntity:GetRealProperty(attrId)
  end
) then
    (UIAttrUtil.UpdateAttrData)(self.roleName, attrDataList, attrOutLineWindow)
  end
end

UIBattleEnemyDetail.__Switch2AttrWidget = function(self)
  -- function num : 0_7 , upvalues : _ENV, TagState
  if ((self.ui).obj_skills).activeSelf then
    ((self.ui).obj_skills):SetActive(false)
  end
  if self.ui_attrMiniWidget == nil or (self.ui_attrMiniWidget).active then
    return 
  end
  ;
  ((self.ui).skillNode):SetActive(false)
  ;
  ((self.ui).Status):SetActive(false)
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
  self:__SetAllSkillItemSelectOff()
  ;
  (self.ui_attrMiniWidget):Show()
  self.tagState = TagState.Attr
  self:__SwitchTagText()
end

UIBattleEnemyDetail.__Switch2SkillWidget = function(self)
  -- function num : 0_8 , upvalues : TagState
  if self.ui_attrMiniWidget ~= nil and (self.ui_attrMiniWidget).active then
    (self.ui_attrMiniWidget):Hide()
  end
  ;
  ((self.ui).Status):SetActive(false)
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).skill_scroll).verticalNormalizedPosition = 1
  if not ((self.ui).obj_skills).activeSelf then
    ((self.ui).obj_skills):SetActive(true)
  end
  ;
  ((self.ui).skillNode):SetActive(true)
  self.tagState = TagState.Skill
  self:__SwitchTagText()
end

UIBattleEnemyDetail.__SwitchTagText = function(self)
  -- function num : 0_9 , upvalues : TagState, _ENV
  local isSkill = self.tagState == TagState.Skill
  local isAttr = self.tagState == TagState.Attr
  local isStatus = self.tagState == TagState.Status
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R4 in 'UnsetPending'

  if not isSkill or not (self.ui).selectColor then
    ((self.ui).img_skillTag).color = (self.ui).normalColor
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R4 in 'UnsetPending'

    if not isAttr or not (self.ui).selectColor then
      ((self.ui).img_attrTag).color = (self.ui).normalColor
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R4 in 'UnsetPending'

      if not isStatus or not (self.ui).selectColor then
        ((self.ui).img_statusTag).color = (self.ui).normalColor
        -- DECOMPILER ERROR at PC61: Confused about usage of register: R4 in 'UnsetPending'

        if not isSkill or not Color.white then
          ((self.ui).text_skillTag).color = (self.ui).normalTextColor
          -- DECOMPILER ERROR at PC72: Confused about usage of register: R4 in 'UnsetPending'

          if not isAttr or not Color.white then
            ((self.ui).text_attrTag).color = (self.ui).normalTextColor
            -- DECOMPILER ERROR at PC83: Confused about usage of register: R4 in 'UnsetPending'

            if not isStatus or not Color.white then
              ((self.ui).text_statusTag).color = (self.ui).normalTextColor
              -- DECOMPILER ERROR: 15 unprocessed JMP targets
            end
          end
        end
      end
    end
  end
end

UIBattleEnemyDetail.__SetAllSkillItemSelectOff = function(self)
  -- function num : 0_10 , upvalues : _ENV
  if self.skillItemPool == nil or (self.skillItemPool).listItem == nil then
    return 
  end
  if #(self.skillItemPool).listItem <= 0 then
    return 
  end
  self.selSkillData = nil
  self._selBreakCompnt = nil
  for _,v in pairs((self.skillItemPool).listItem) do
    v:SetRefreshSelectUI(false)
  end
  ;
  (self.breakNode):UpdEnemyBreakDesSelectUI(false)
end

UIBattleEnemyDetail._ShowBreakDetail = function(self, breakCompnt)
  -- function num : 0_11 , upvalues : _ENV, cs_Edge
  self.selSkillData = nil
  if self._selBreakCompnt == breakCompnt then
    ((self.ui).togGroup):SetAllTogglesOff()
    UIManager:HideWindow(UIWindowTypeID.RichIntro)
    self._selBreakCompnt = nil
    return 
  end
  self._selBreakCompnt = breakCompnt
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_11_0 , upvalues : breakCompnt, self, cs_Edge
    if win == nil then
      return 
    end
    local bkCfg = breakCompnt.breakConfig
    win:ShowIntroCustom((self.ui).introHolder, bkCfg.DesName, bkCfg.DescriptionLv, true, (self.ui).modifier)
    win:SetIntroListPosition(cs_Edge.Left, cs_Edge.Top)
  end
)
end

UIBattleEnemyDetail.__ShowSkillDetail = function(self, skillData)
  -- function num : 0_12 , upvalues : _ENV
  self._selBreakCompnt = nil
  if self.selSkillData == skillData then
    ((self.ui).togGroup):SetAllTogglesOff()
    UIManager:HideWindow(UIWindowTypeID.RichIntro)
    self.selSkillData = nil
    return 
  end
  self.selSkillData = skillData
  self.__onSkillIntroWindowOpen = BindCallback(self, self.SkillIntroWindowOpen, skillData)
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_12_0 , upvalues : self
    if win ~= nil then
      (self.__onSkillIntroWindowOpen)(win)
    end
  end
)
end

UIBattleEnemyDetail.SkillIntroWindowOpen = function(self, skillData, win)
  -- function num : 0_13 , upvalues : cs_Edge
  win:ShowIntroBySkillData((self.ui).introHolder, skillData, true, (self.ui).modifier, false, true, 2)
  win:SetIntroListPosition(cs_Edge.Left, cs_Edge.Top)
end

UIBattleEnemyDetail.__ShowEnemyEffctGrid = function(self, x, y)
  -- function num : 0_14 , upvalues : _ENV, UINBattleMetalGear
  local needShowGridInfo = false
  local dynEffectGrid = nil
  if ((CS.BattleManager).Instance).IsInBattle then
    local battleCtrl = ((CS.BattleManager).Instance).CurBattleController
    local effectGrid = (battleCtrl.EfcGridController):GetEffectGrid(x, y)
    if effectGrid ~= nil then
      needShowGridInfo = true
      dynEffectGrid = effectGrid.gridData
    end
  end
  do
    ;
    (self.battleGirdInfoNode):Hide()
    if self.__battleMetaGearInfo ~= nil then
      (self.__battleMetaGearInfo):Hide()
    end
    if not needShowGridInfo then
      return 
    end
    if dynEffectGrid:IsMetalGearGrid() then
      if self.__battleMetaGearInfo == nil then
        self.__battleMetaGearInfo = (UINBattleMetalGear.New)()
        ;
        (self.__battleMetaGearInfo):Init((self.ui).obj_mGNode)
      end
      ;
      (self.__battleMetaGearInfo):Show()
      ;
      (self.__battleMetaGearInfo):InitBattleGridMetalGear(dynEffectGrid)
    else
      ;
      (self.battleGirdInfoNode):Show()
      ;
      (self.battleGirdInfoNode):InitBattleGridInfo(dynEffectGrid)
    end
  end
end

UIBattleEnemyDetail.OnChipDetailActiveChange = function(self, active)
  -- function num : 0_15
  if active and self.active then
    self:Hide()
    self._changeHide = true
    return 
  end
  if self._changeHide then
    self:Show()
    self._changeHide = false
  end
end

UIBattleEnemyDetail.OnClickBuffDetail = function(self)
  -- function num : 0_16 , upvalues : TagState
  if self.ui_attrMiniWidget ~= nil and (self.ui_attrMiniWidget).active then
    (self.ui_attrMiniWidget):Hide()
  end
  ;
  ((self.ui).skillNode):SetActive(false)
  ;
  ((self.ui).Status):SetActive(true)
  self.tagState = TagState.Status
  self:__SwitchTagText()
end

UIBattleEnemyDetail.OnDelete = function(self)
  -- function num : 0_17 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnDungeonDetailWinChange, self.__OnChipDetailActiveChange)
  UIManager:HideWindow(UIWindowTypeID.RichIntro)
  self.tagState = nil
  self.selSkillData = nil
  self.characterEntity = nil
  self.summonerEntity = nil
  if self.ui_attrMiniWidget ~= nil then
    (self.ui_attrMiniWidget):OnDelete()
    self.ui_attrMiniWidget = nil
  end
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.breakNode):Delete()
  ;
  (self.skillItemPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

UIBattleEnemyDetail.OnHide = function(self)
  -- function num : 0_18 , upvalues : base
  if self.ui_attrMiniWidget ~= nil and (self.ui_attrMiniWidget).active then
    (self.ui_attrMiniWidget):Hide()
  end
  ;
  (base.OnHide)(self)
end

return UIBattleEnemyDetail

