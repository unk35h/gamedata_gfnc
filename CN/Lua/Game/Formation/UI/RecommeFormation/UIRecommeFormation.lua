-- params : ...
-- function num : 0 , upvalues : _ENV
local UIRecommeFormation = class("UIRecommeFormation", UIBaseWindow)
local base = UIBaseWindow
local UINRecommeFormationItem = require("Game.Formation.UI.RecommeFormation.UINRecommeFormationItem")
local CS_ResLoader = CS.ResLoader
UIRecommeFormation.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINRecommeFormationItem, CS_ResLoader
  ((self.ui).recommeTeamItem):SetActive(false)
  self.itemPool = (UIItemPool.New)(UINRecommeFormationItem, (self.ui).recommeTeamItem)
  ;
  (UIUtil.SetTopStatus)(self, self.OnCloseUI)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).tog_Filter, self, self.OnToggleFiler)
  self.resloader = (CS_ResLoader.Create)()
end

UIRecommeFormation.InitRecommeFormation = function(self, isOpenCopy, recordInfo, recommeCtr)
  -- function num : 0_1 , upvalues : _ENV
  self.recommeCtr = recommeCtr
  self.recordInfo = recordInfo
  self.isOpenCopy = isOpenCopy
  local msg = nil
  if recordInfo.isDungeon then
    local dungeonStageCfg = (ConfigData.battle_dungeon)[(self.recordInfo).stageId]
    if dungeonStageCfg ~= nil then
      msg = (LanguageUtil.GetLocaleText)(dungeonStageCfg.name)
    end
  else
    do
      if (ConfigData.sector_stage)[(self.recordInfo).stageId] ~= nil then
        local difficultyId, sectorId, stageIndex = self:GetNormalStageData((self.recordInfo).stageId)
        msg = ConfigData:GetSectorInfoMsg(sectorId, stageIndex, difficultyId)
      else
        do
          if ConfigData.endless ~= nil and (ConfigData.endless).levelDic ~= nil and ((ConfigData.endless).levelDic)[(self.recordInfo).stageId] ~= nil then
            local stageCfg = ((ConfigData.endless).levelDic)[(self.recordInfo).stageId]
            local sectorId = stageCfg.sectorId
            local depth = stageCfg.index * 10
            local sectorCfg = (ConfigData.sector)[sectorId]
            if stageCfg ~= nil then
              msg = ConfigData:GetEndlessInfoMsg(sectorCfg, depth)
            end
          end
          do
            -- DECOMPILER ERROR at PC78: Confused about usage of register: R5 in 'UnsetPending'

            ;
            ((self.ui).tex_LevelInfo).text = msg
            if ((self.ui).tog_Filter).isOn == (self.recommeCtr).isRecommeSortForCount then
              self:OnToggleFiler((self.recommeCtr).isRecommeSortForCount)
            else
              -- DECOMPILER ERROR at PC95: Confused about usage of register: R5 in 'UnsetPending'

              ;
              ((self.ui).tog_Filter).isOn = (self.recommeCtr).isRecommeSortForCount
            end
          end
        end
      end
    end
  end
end

UIRecommeFormation.OnToggleFiler = function(self, isSelected)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self.recommeCtr).isRecommeSortForCount = isSelected
  if isSelected then
    (self.recordInfo):SortByHeroCount()
  else
    ;
    (self.recordInfo):SortByPower()
  end
  ;
  (self.itemPool):HideAll()
  self:__ShowList()
end

UIRecommeFormation.__ShowList = function(self)
  -- function num : 0_3
  for i = 1, #(self.recordInfo).list do
    local item = (self.itemPool):GetOne()
    item:InitRecommeItem(self.recommeCtr, ((self.recordInfo).list)[i], self.isOpenCopy, self.recordInfo, self.resloader)
  end
end

UIRecommeFormation.GetNormalStageData = function(self, stageId)
  -- function num : 0_4 , upvalues : _ENV
  local stageCfg = (ConfigData.sector_stage)[stageId]
  local sectorId = stageCfg.sector
  local difficultyId = stageCfg.difficulty
  local stageIndex = 0
  local difflist = (((ConfigData.sector_stage).sectorDiffDic)[sectorId])[difficultyId]
  for index,id in ipairs(difflist) do
    if id == stageId then
      stageIndex = index
    end
  end
  return difficultyId, sectorId, stageIndex
end

UIRecommeFormation.OnCloseUI = function(self)
  -- function num : 0_5
  self:Delete()
end

UIRecommeFormation.OnDelete = function(self)
  -- function num : 0_6 , upvalues : base
  (self.resloader):Put2Pool()
  self.resloader = nil
  ;
  (base.OnDelete)(self)
end

return UIRecommeFormation

