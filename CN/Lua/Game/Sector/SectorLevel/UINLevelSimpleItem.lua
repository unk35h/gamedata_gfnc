-- params : ...
-- function num : 0 , upvalues : _ENV
local UINLevelSimpleItem = class("UINLevelSimpleItem", UIBaseNode)
local base = UIBaseNode
local SectorEnum = require("Game.Sector.SectorEnum")
local verticalAnchor = (Vector2.New)(0.5, 1)
local horizontalAnchor = (Vector2.New)(0, 0.5)
UINLevelSimpleItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).rootBtn, self, self.OnClickLevelItem)
  self._challengeUISizeDefault = (((self.ui).challengeBg).sizeDelta).x
end

UINLevelSimpleItem.InitSectorLevelItem = function(self, stageCfg, arrangeCfg, clickEvent, resLoader)
  -- function num : 0_1 , upvalues : _ENV, SectorEnum, verticalAnchor, horizontalAnchor
  self.clickEvent = clickEvent
  self.stageCfg = stageCfg
  local stageId = ConfigData:GetSectorIdShow(stageCfg.sector)
  if ((ConfigData.sector).onlyShowStageIdSectorDic)[stageCfg.sector] then
    local descStr = (SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).OnlyNumber]
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R7 in 'UnsetPending'

    ;
    ((self.ui).tex_SubTile).text = (string.format)(descStr, stageCfg.num)
  else
    do
      local descStr = nil
      if stageCfg.special_arrange > 0 then
        local descType = ((ConfigData.level_arrange).pos_tag_dic)[stageCfg.special_arrange]
        descStr = (SectorEnum.SectorLevelItemDesc)[descType]
      else
        do
          do
            descStr = (SectorEnum.SectorLevelItemDesc)[(SectorEnum.eSectorLevelItemType).Normal]
            -- DECOMPILER ERROR at PC50: Confused about usage of register: R7 in 'UnsetPending'

            ;
            ((self.ui).tex_SubTile).text = (string.format)(descStr, stageId, stageCfg.num)
            -- DECOMPILER ERROR at PC57: Confused about usage of register: R6 in 'UnsetPending'

            ;
            ((self.ui).tex_Tile).text = (LanguageUtil.GetLocaleText)(stageCfg.name)
            if stageCfg.icon ~= nil and not (string.IsNullOrEmpty)(stageCfg.icon) then
              resLoader:LoadABAssetAsync(PathConsts:GetAtlasAssetPath("SectorLevelIcon"), function(spriteAtlas)
    -- function num : 0_1_0 , upvalues : _ENV, self, stageCfg
    if spriteAtlas == nil or IsNull(self.transform) then
      return 
    end
    local stageIcon = (AtlasUtil.GetResldSprite)(spriteAtlas, stageCfg.icon)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).img_Pic).sprite = stageIcon
  end
)
            end
            self:RefreshLevelState()
            self:LevelItemShowContinue(false)
            -- DECOMPILER ERROR at PC84: Confused about usage of register: R6 in 'UnsetPending'

            if arrangeCfg.vertical then
              (self.transform).anchorMin = verticalAnchor
              -- DECOMPILER ERROR at PC87: Confused about usage of register: R6 in 'UnsetPending'

              ;
              (self.transform).anchorMax = verticalAnchor
            else
              -- DECOMPILER ERROR at PC91: Confused about usage of register: R6 in 'UnsetPending'

              ;
              (self.transform).anchorMin = horizontalAnchor
              -- DECOMPILER ERROR at PC94: Confused about usage of register: R6 in 'UnsetPending'

              ;
              (self.transform).anchorMax = horizontalAnchor
            end
            -- DECOMPILER ERROR at PC103: Confused about usage of register: R6 in 'UnsetPending'

            ;
            (self.transform).anchoredPosition = (Vector2.New)((arrangeCfg.pos)[1], (arrangeCfg.pos)[2])
            self:SeletedLevelItem(false, false)
            self:UpdLvItemChallengeTask()
          end
        end
      end
    end
  end
end

UINLevelSimpleItem.UpdLvItemChallengeTask = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (PlayerDataCenter.sectorAchievementDatas):HasStageChallengeTask((self.stageCfg).id) then
    ((self.ui).challenge):SetActive(true)
    local size = ((self.ui).challengeBg).sizeDelta
    size.x = self._challengeUISizeDefault * #(self.stageCfg).hard_task
    -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).challengeBg).sizeDelta = size
    local curNum = (PlayerDataCenter.sectorAchievementDatas):GetStageChallengeTaskCompleteNum((self.stageCfg).id)
    size = ((self.ui).img_ChallengeCur).sizeDelta
    size.x = self._challengeUISizeDefault * curNum
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_ChallengeCur).sizeDelta = size
  else
    do
      ;
      (((self.ui).challenge).gameObject):SetActive(false)
    end
  end
end

UINLevelSimpleItem.OnClickLevelItem = function(self)
  -- function num : 0_3
  if self.clickEvent ~= nil then
    (self.clickEvent)(self)
  end
end

UINLevelSimpleItem.DisableSelectLevelItem = function(self, disable)
  -- function num : 0_4
  if not self.isUnlock then
    return 
  end
  self.isDisable = disable
  self:RefreshNoEntry()
end

UINLevelSimpleItem.RefreshNoEntry = function(self)
  -- function num : 0_5
  if not self.isUnlock or self.isDisable then
    ((self.ui).clearLevelIcon):SetActive(false)
    ;
    ((self.ui).noEntry):SetActive(true)
    if self.isDisable then
      ((self.ui).img_NoEntry):SetIndex(0)
    else
      ;
      ((self.ui).img_NoEntry):SetIndex(1)
    end
  else
    ;
    ((self.ui).noEntry):SetActive(false)
    ;
    ((self.ui).clearLevelIcon):SetActive(self.isClear)
  end
end

UINLevelSimpleItem.LevelItemShowContinue = function(self, show)
  -- function num : 0_6
  ((self.ui)["continue"]):SetActive(show)
  if self.isClear then
    ((self.ui).clearLevel):SetActive(not show)
  end
end

UINLevelSimpleItem.SeletedLevelItem = function(self, select, withTween)
  -- function num : 0_7
  ((self.ui).obj_Select):SetActive(select)
end

UINLevelSimpleItem.ShowBlueDotLevelItem = function(self, show)
  -- function num : 0_8
  ((self.ui).blueDot):SetActive(show)
end

UINLevelSimpleItem.RefreshLevelState = function(self)
  -- function num : 0_9 , upvalues : _ENV
  self.isClear = (PlayerDataCenter.sectorStage):IsStageComplete((self.stageCfg).id)
  ;
  ((self.ui).clearLevel):SetActive(self.isClear)
  self.isUnlock = (PlayerDataCenter.sectorStage):IsStageUnlock((self.stageCfg).id)
  self:RefreshNoEntry()
  local showUnlockView = false
  do
    if not self.isClear then
      local systeId = ((ConfigData.system_open).mainLevelUnlock)[(self.stageCfg).id]
      if systeId ~= nil and systeId > 0 then
        showUnlockView = true
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R3 in 'UnsetPending'

        ;
        ((self.ui).tex_UnlockView).text = (LanguageUtil.GetLocaleText)(((ConfigData.system_open)[systeId]).name)
      end
    end
    ;
    ((self.ui).go_unlockView):SetActive(showUnlockView)
  end
end

UINLevelSimpleItem.IsLevelUnlock = function(self)
  -- function num : 0_10
  return self.isUnlock
end

UINLevelSimpleItem.GetLevelStageData = function(self)
  -- function num : 0_11
  return self.stageCfg
end

return UINLevelSimpleItem

