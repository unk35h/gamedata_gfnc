-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseWindow
local UIWarChessMonsterDetail = class("UIWarChessMonsterDetail", base)
local UIWCEnemySkillItem = require("Game.WarChess.UI.Detail.UIWCEnemySkillItem")
local UINEnemyTagItem = require("Game.Battle.UI.UINEnemyTagItem")
local UINMonsterPicItem = require("Game.WarChess.UI.Detail.UINWarChessMonsterPicItem")
local DynBattleSkill = require("Game.Exploration.Data.DynBattleSkill")
local cs_Edge = ((CS.UnityEngine).RectTransform).Edge
local UIWCMapPointItem = require("Game.WarChess.UI.Detail.UIWCMapPointItem")
UIWarChessMonsterDetail.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINMonsterPicItem, UIWCEnemySkillItem, UINEnemyTagItem, UIWCMapPointItem
  (((self.ui).btn_bg).gameObject):SetActive(false)
  ;
  ((self.ui).monsterPicItem):SetActive(false)
  self.monsterPicItemPool = (UIItemPool.New)(UINMonsterPicItem, (self.ui).monsterPicItem)
  ;
  ((self.ui).skillIntroItem):SetActive(false)
  self.skillItemPool = (UIItemPool.New)(UIWCEnemySkillItem, (self.ui).skillIntroItem)
  ;
  ((self.ui).obj_tag):SetActive(false)
  self.tagItemPool = (UIItemPool.New)(UINEnemyTagItem, (self.ui).obj_tag)
  self._OnClickPicItemFunc = BindCallback(self, self.OnClickPicItem)
  self.__onShowSkillDetail = BindCallback(self, self.OnShowSkillDetail)
  self.resloader = ((CS.ResLoader).Create)()
  ;
  ((self.ui).obj_mapPoint):SetActive(false)
  self.__mapPointSize = (((self.ui).obj_mapPoint).transform).sizeDelta
  self.mapPointsPool = (UIItemPool.New)(UIWCMapPointItem, (self.ui).obj_mapPoint)
  for _,obj_layout in pairs((self.ui).arr_layouts) do
    obj_layout:SetActive(false)
  end
end

UIWarChessMonsterDetail.InitWCIntro = function(self, battleRoomId, worldPos, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.__closeCallback = closeCallback
  if battleRoomId ~= nil then
    local monsterGroupCfg = (ConfigData.warchess_room_monster)[battleRoomId]
    if monsterGroupCfg == nil then
      error("表怪物组不存在 battleRoomId:" .. tostring(battleRoomId))
      return 
    end
    local monsterGroupId = monsterGroupCfg.team_id
    if self.__cacheMonsterGroupId ~= monsterGroupId then
      local battleGroupTeamCfg = (ConfigData.warchess_monster_team_data)[monsterGroupId]
      if battleGroupTeamCfg == nil then
        error("warchess_room_monster表怪物组ID不满足条件 >3000000 and <4000000")
        self:OnClickBG()
        return 
      end
      local IsObstacle = function(monster_id)
    -- function num : 0_1_0
    do return monster_id == 1000 or monster_id == 1001 end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end

      local posTeamDic = {}
      self.monsterTeamDic = {}
      for _,monsterCfg in pairs(battleGroupTeamCfg) do
        if not IsObstacle(monsterCfg.monster_id) then
          (table.insert)(self.monsterTeamDic, monsterCfg)
        end
        local posArr = monsterCfg.enemy_pos
        posTeamDic[self:_HashPosToValue(posArr[1], posArr[2])] = monsterCfg.monster_id
      end
      self.batlleSceneId = (WarChessManager.wcLevelCfg).prefeb_id
      if not self.batlleSceneId then
        error("表中场景id(prefeb_id)不存在 levelId:" .. tostring((WarChessManager.wcLevelCfg).id))
        return 
      end
      local batlleSceneData = (ConfigData.scene)[self.batlleSceneId]
      local mapRow = batlleSceneData.size_row
      local mapCol = batlleSceneData.size_col
      local isMapBuilt = mapRow == self.__mapRow and mapCol == self.__mapCol
      if not isMapBuilt then
        self.__mapRow = mapRow
        self.__mapCol = mapCol
        local mapHalfRow = mapRow >> 1
        local mapHalfCol = mapCol >> 1
        local iconWidth = (self.__mapPointSize).x
        local iconHight = (self.__mapPointSize).y - 15
        self.__mapPointDic = {}
        ;
        (self.mapPointsPool):HideAll()
        for col = 1, mapCol do
          local realRow = mapRow
          if col & 1 == 0 then
            realRow = mapRow - 1
          end
          for rol = 1, realRow do
            local rowOffset = 0
            if realRow & 1 == 0 then
              rowOffset = iconWidth / 2
            end
            local colOffset = 0
            if mapCol & 1 == 0 then
              colOffset = iconHight / 2
            end
            local mapPoint = (self.mapPointsPool):GetOne()
            mapPoint:HideCareerIcon()
            local x = iconWidth * (rol - 1 - mapHalfRow) + rowOffset
            local y = iconHight * -(col - 1 - mapHalfCol) + colOffset
            mapPoint:SetLocalPos(x, y)
            mapPoint:SetImgItemInfo(2)
            -- DECOMPILER ERROR at PC154: Confused about usage of register: R31 in 'UnsetPending'

            ;
            (self.__mapPointDic)[self:_HashPosToValue(rol - 1, col - 1)] = mapPoint
          end
        end
        isMapBuilt = true
      else
        for hashPosVal,_ in pairs(self.__cachePosTeam) do
          local mapPoint = (self.__mapPointDic)[hashPosVal]
          mapPoint:SetImgItemInfo(2)
          mapPoint:HideCareerIcon()
        end
      end
      for hashPosVal,monsterId in pairs(posTeamDic) do
        local mapPoint = (self.__mapPointDic)[hashPosVal]
        if IsObstacle(monsterId) then
          mapPoint:SetImgItemInfo(1)
        else
          mapPoint:SetImgItemInfo(0)
          if monsterId then
            local monsterCfg = (ConfigData.monster)[monsterId]
            mapPoint:SetImgCareer(monsterCfg)
          end
        end
      end
      self.__cachePosTeam = posTeamDic
      self.__cacheMonsterGroupId = monsterGroupId
    end
    -- DECOMPILER ERROR at PC208: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Team).text = (LanguageUtil.GetLocaleText)(monsterGroupCfg.mon_name)
    -- DECOMPILER ERROR at PC215: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Difficulty).text = (LanguageUtil.GetLocaleText)(1)
    self:InitMonsterPicItemList()
  end
  self:UpdDetailPanelPos(worldPos)
  -- DECOMPILER ERROR: 11 unprocessed JMP targets
end

UIWarChessMonsterDetail._HashPosToValue = function(self, row, col)
  -- function num : 0_2
  return row * 1000 + col
end

UIWarChessMonsterDetail._HashValueToPos = function(self, hashVal)
  -- function num : 0_3
  local col = hashVal % 1000
  local row = hashVal // 1000
  return row, col
end

UIWarChessMonsterDetail.InitMonsterPicItemList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.monsterTeamDic == nil then
    return 
  end
  ;
  (self.monsterPicItemPool):HideAll()
  self.curPicItem = nil
  local mapItem = (self.monsterPicItemPool):GetOne()
  if self.curPicItem == nil then
    self.curPicItem = mapItem
    ;
    (mapItem.transform):SetParent(((self.ui).group_PicItem).transform)
    ;
    (mapItem.transform):SetAsLastSibling()
    mapItem:InitMapItem(self._OnClickPicItemFunc)
  end
  for k,v in pairs(self.monsterTeamDic) do
    local monsterId = v.monster_id
    local monsterCfg = (ConfigData.monster)[monsterId]
    if monsterCfg ~= nil then
      local picItem = (self.monsterPicItemPool):GetOne()
      ;
      (picItem.transform):SetParent(((self.ui).group_PicItem).transform)
      ;
      (picItem.transform):SetAsLastSibling()
      picItem:InitItem(monsterCfg, self.resloader, self._OnClickPicItemFunc)
    end
  end
  self:OnClickPicItem(self.curPicItem)
end

UIWarChessMonsterDetail.OnShowSkillDetail = function(self, skillData)
  -- function num : 0_5 , upvalues : _ENV
  if self.selSkillData == skillData then
    ((self.ui).togGroup):SetAllTogglesOff()
    UIManager:HideWindow(UIWindowTypeID.RichIntro)
    self.selSkillData = nil
    return 
  end
  self.selSkillData = skillData
  self.__onSkillIntroWindowOpen = BindCallback(self, self.SkillIntroWindowOpen, skillData)
  UIManager:ShowWindowAsync(UIWindowTypeID.RichIntro, function(win)
    -- function num : 0_5_0 , upvalues : self
    if win ~= nil then
      (self.__onSkillIntroWindowOpen)(win)
    end
  end
)
end

UIWarChessMonsterDetail.SkillIntroWindowOpen = function(self, skillData, win)
  -- function num : 0_6 , upvalues : cs_Edge
  win:ShowIntroBySkillData((self.ui).introHolder, skillData, true, (self.ui).modifier, false, true, 2)
  win:SetIntroListPosition(cs_Edge.Left, cs_Edge.Top)
end

UIWarChessMonsterDetail.UpdDetailPanelPos = function(self, worldPos)
  -- function num : 0_7 , upvalues : _ENV
  local rolePosX = (UIManager:World2UIPosition(worldPos, self.transform)).x
  local targetPosX = rolePosX - (((self.ui).uINWCEnemyDetail).sizeDelta).x / 2 - 150
  if targetPosX <= (self.ui).panelPosRangeX - ((self.transform).rect).width / 2 then
    targetPosX = rolePosX + (((self.ui).uINWCEnemyDetail).sizeDelta).x / 2 + 150
  end
  local anchoredPos = ((self.ui).uINWCEnemyDetail).anchoredPosition
  anchoredPos.x = targetPosX
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).uINWCEnemyDetail).anchoredPosition = anchoredPos
end

UIWarChessMonsterDetail.OnClickPicItem = function(self, picItem)
  -- function num : 0_8 , upvalues : _ENV, DynBattleSkill
  picItem:SetItemSelect(true)
  local monsterCfg = picItem.monsterCfg
  if self.selSkillData then
    ((self.ui).togGroup):SetAllTogglesOff()
    UIManager:HideWindow(UIWindowTypeID.RichIntro)
    self.selSkillData = nil
  end
  if monsterCfg then
    ((self.ui).tagList):SetActive(true)
    ;
    (((self.ui).tex_Des).gameObject):SetActive(false)
    self:_SetShowLayoutType(1)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Name).text = (LanguageUtil.GetLocaleText)(monsterCfg.name)
    local careerId = monsterCfg.career
    local careerCfg = (ConfigData.career)[careerId]
    if careerCfg == nil then
      error("Can\'t find careerCfg, campId = " .. tostring(careerId))
    else
      -- DECOMPILER ERROR at PC62: Confused about usage of register: R5 in 'UnsetPending'

      ;
      ((self.ui).img_Career).sprite = CRH:GetSprite(careerCfg.icon, CommonAtlasType.CareerCamp)
    end
    ;
    (self.skillItemPool):HideAll()
    local skillIds = monsterCfg.enemy_skill
    for k,skillId in pairs(skillIds) do
      local skillData = (DynBattleSkill.New)(skillId, 1, eBattleSkillLogicType.Original)
      if not skillData:IsCommonAttack() then
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
    ;
    (self.tagItemPool):HideAll()
    local monsterTag = monsterCfg.monster_tag
    local tagEnd = #monsterTag
    local tagStart = 1
    for i = tagStart, tagEnd do
      local tagId = monsterTag[i]
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
  else
    do
      ;
      ((self.ui).tagList):SetActive(false)
      ;
      (((self.ui).tex_Des).gameObject):SetActive(true)
      -- DECOMPILER ERROR at PC158: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).tex_Des).text = ConfigData:GetTipContent(8711)
      self:_SetShowLayoutType(2)
    end
  end
end

UIWarChessMonsterDetail.OnHide = function(self)
  -- function num : 0_9 , upvalues : base
  if self.__closeCallback ~= nil then
    (self.__closeCallback)()
  end
  ;
  (base.OnHide)(self)
end

UIWarChessMonsterDetail._SetShowLayoutType = function(self, index)
  -- function num : 0_10
  if index ~= self.__layoutType then
    if self.__layoutType then
      (((self.ui).arr_layouts)[self.__layoutType]):SetActive(false)
    end
    ;
    (((self.ui).arr_layouts)[index]):SetActive(true)
    self.__layoutType = index
  end
end

UIWarChessMonsterDetail.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (self.monsterPicItemPool):DeleteAll()
  ;
  (self.skillItemPool):DeleteAll()
  ;
  (self.tagItemPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.mapPointsPool):DeleteAll()
  self.__mapPointSize = nil
  self.__cachePosTeam = nil
  self.monsterTeamDic = nil
  self.__mapPointDic = nil
  ;
  (base.OnDelete)(self)
end

return UIWarChessMonsterDetail

