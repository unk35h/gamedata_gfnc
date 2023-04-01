-- params : ...
-- function num : 0 , upvalues : _ENV
local UIRecommeFormation = class("UIRecommeFormation", UIBaseWindow)
local base = UIBaseWindow
local UINRecommeFormationItem = require("Game.Formation.UI.RecommeFormation.UINRecommeFormationItemNew")
local CS_ResLoader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
UIRecommeFormation.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINRecommeFormationItem, CS_ResLoader
  ((self.ui).recommeTeamItem):SetActive(false)
  self.itemPool = (UIItemPool.New)(UINRecommeFormationItem, (self.ui).recommeTeamItem)
  ;
  (UIUtil.SetTopStatus)(self, self.OnCloseUI)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_copy, self, self.OnClickCopyFormation)
  self._ClickRecommeFormationCallback = BindCallback(self, self.ClickRecommeFormationCallback)
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
            if isOpenCopy then
              ((self.ui).obj_canCopy):SetActive(true)
              ;
              ((self.ui).tip_textInfo):SetIndex(0)
              -- DECOMPILER ERROR at PC95: Confused about usage of register: R5 in 'UnsetPending'

              ;
              ((self.ui).img_tip).color = (self.ui).tipColor
            else
              ;
              ((self.ui).obj_canCopy):SetActive(false)
            end
            self:__ShowList()
          end
        end
      end
    end
  end
end

UIRecommeFormation.ClickRecommeFormationCallback = function(self, index)
  -- function num : 0_2 , upvalues : _ENV
  if not self.isOpenCopy or self.selectIndex == index then
    return 
  end
  ;
  ((self.ui).tip_textInfo):SetIndex(1)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_tip).color = (self.ui).clickColor
  ;
  ((self.ui).obj_Selected):SetActive(true)
  ;
  (((self.ui).obj_Selected).transform):SetParent((((self.itemPool).listItem)[index]).transform)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).obj_Selected).transform).anchoredPosition = Vector3.zero
  self.selectIndex = index
end

UIRecommeFormation.OnClickCopyFormation = function(self)
  -- function num : 0_3 , upvalues : _ENV, CS_MessageCommon
  if not self.selectIndex then
    return 
  end
  local data = ((self.recordInfo).list)[self.selectIndex]
  if data:IsAllowCopy() then
    local showingWindow = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
    showingWindow:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(TipContent.Recomme_Confirm), function()
    -- function num : 0_3_0 , upvalues : _ENV, self, data
    (UIUtil.OnClickBack)()
    ;
    (self.recommeCtr):ExitRecommeFormation(data)
  end
, nil)
  else
    do
      ;
      (CS_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Recomme_Fail))
    end
  end
end

UIRecommeFormation.__ShowList = function(self)
  -- function num : 0_4
  for i = 1, #(self.recordInfo).list do
    local item = (self.itemPool):GetOne()
    item:InitRecommeItemNew(self.recommeCtr, ((self.recordInfo).list)[i], self.recordInfo, self.resloader, self._ClickRecommeFormationCallback)
  end
end

UIRecommeFormation.GetNormalStageData = function(self, stageId)
  -- function num : 0_5 , upvalues : _ENV
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
  -- function num : 0_6
  self:Delete()
end

UIRecommeFormation.OnDelete = function(self)
  -- function num : 0_7 , upvalues : base
  (self.resloader):Put2Pool()
  self.resloader = nil
  ;
  (base.OnDelete)(self)
end

return UIRecommeFormation

