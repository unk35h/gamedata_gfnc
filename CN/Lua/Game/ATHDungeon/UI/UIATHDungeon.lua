-- params : ...
-- function num : 0 , upvalues : _ENV
local UIDungeonBase = require("Game.CommonUI.DungeonPanelWidgets.UIDungeonBase")
local UIATHDungeon = class("UIATHDungeon", UIDungeonBase)
local base = UIDungeonBase
local UIATHDungeonItem = require("Game.ATHDungeon.UI.UIATHDungeonItem")
local UIATHChapterItem = require("Game.ATHDungeon.UI.UIATHChapterItem")
local UIATHSuitDetailNode = require("Game.ATHDungeon.UI.UIATHSuitDetailNode")
local UIATHSuitItem = require("Game.ATHDungeon.UI.UIATHSuitItem")
local UINMatDungeonSubTitle = require("Game.MaterialDungeon.UI.UINMatDungeonSubTitle")
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
local UINATHDungeonInfo = require("Game.ATHDungeon.UI.UINATHDungeonInfo")
local cs_MessageCommon = CS.MessageCommon
local CS_LayoutRebuilder = ((CS.UnityEngine).UI).LayoutRebuilder
local eAthExtraType = {ExtraArea = 1, ExtraSuit = 2, ExtraSuit2 = 3}
local eAthAreaType = {AreaA = 1, AreaB = 2, AreaC = 3, AreaAll = 4}
UIATHDungeon.OnInit = function(self)
  -- function num : 0_0 , upvalues : base, _ENV, UIATHSuitItem, UIATHSuitDetailNode, UINATHDungeonInfo, UINMatDungeonSubTitle, UINCommonSwitchToggle
  (base.OnInit)(self)
  self.onChapterItemClick = BindCallback(self, self.__loadExtraShowUI)
  self.onSuitItemClick = BindCallback(self, self._onSuitItemClick)
  self.SuitItemPool = (UIItemPool.New)(UIATHSuitItem, (self.ui).obj_SuitNode)
  ;
  ((self.ui).obj_SuitNode):SetActive(false)
  self.suitEffectNode = (UIATHSuitDetailNode.New)()
  ;
  (self.suitEffectNode):Init((self.ui).obj_SuitEffect)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.__OnClickBtnInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_dropAllSuit, self, self._OnClickDropAll)
  self._dungeonInfo = (UINATHDungeonInfo.New)()
  ;
  (self._dungeonInfo):Init((self.ui).obj_DropInfo)
  self.subTitleDic = {}
  self.subTitlePool = (UIItemPool.New)(UINMatDungeonSubTitle, (self.ui).obj_SubTile)
  ;
  ((self.ui).obj_SubTile):SetActive(false)
  self.__SubListShowState = BindCallback(self, self.SubListShowState)
  self._dropSwitchTog = (UINCommonSwitchToggle.New)()
  ;
  (self._dropSwitchTog):Init((self.ui).tog_SwitchBuffTimes)
  ;
  (self._dropSwitchTog):CommonSwitchTogAutoSetValue(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_BuffInfo, self, self.ShowDropInfo)
  self._OnSwitchDropBuffFunc = BindCallback(self, self._OnClickSwitchDropBuff)
  self._decomposeTog = (UINCommonSwitchToggle.New)()
  ;
  (self._decomposeTog):Init((self.ui).tog_IsATHDecompose)
  ;
  (self._decomposeTog):CommonSwitchTogAutoSetValue(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_IsATHDecompose, self, self.ShowAutoDecomposeInfo)
  self._OnSwitchDecomposeFunc = BindCallback(self, self._OnClickSwitchDecompose)
end

UIATHDungeon.InitDungeonType = function(self, dungeonTypeData, selectItemId, onBackCallback)
  -- function num : 0_1 , upvalues : _ENV, base
  self.dungeonTypeUIEnum = UIWindowTypeID.ATHDungeon
  self._selectItemId = selectItemId
  ;
  (base.InitDungeonType)(self, dungeonTypeData, selectItemId, onBackCallback)
  ;
  (self._decomposeTog):InitCommonSwitchToggle(self:GetDecomposeActive(), self._OnSwitchDecomposeFunc)
  local subTtielId = (self.selectDungeonData):GetSubTitleId()
  if subTtielId ~= nil then
    self:SubListShowState(subTtielId, true, true)
    local subItem = (self.subTitleDic)[subTtielId]
    if subItem ~= nil then
      subItem:SetDungeonSubTitleState(true)
    end
  end
end

UIATHDungeon.InitDungeonList = function(self)
  -- function num : 0_2 , upvalues : _ENV, UIATHDungeonItem
  if self.dungeonItemPool == nil then
    self.dungeonItemPool = (UIItemPool.New)(UIATHDungeonItem, (self.ui).tog_DungeonItem)
    ;
    ((self.ui).tog_DungeonItem):SetActive(false)
  else
    ;
    (self.dungeonItemPool):HideAll()
  end
  if self.smallDungeonItemPool == nil then
    self.smallDungeonItemPool = (UIItemPool.New)(UIATHDungeonItem, (self.ui).tog_SmallDungeonItem)
    ;
    ((self.ui).tog_SmallDungeonItem):SetActive(false)
  else
    ;
    (self.smallDungeonItemPool):HideAll()
  end
  local subDungeonDataDic = {}
  local toggleDataList = {}
  for _,dungeonData in ipairs(self.dungeonDataList) do
    if not dungeonData:IsHideDg() then
      local subTtielId = dungeonData:GetSubTitleId()
      if subTtielId ~= nil then
        local list = subDungeonDataDic[subTtielId]
        if list == nil then
          list = {}
          subDungeonDataDic[subTtielId] = list
          ;
          (table.insert)(toggleDataList, {hasSubset = true, dungeonDataList = list, subTtielId = subTtielId})
        end
        ;
        (table.insert)(list, dungeonData)
      else
        do
          do
            ;
            (table.insert)(toggleDataList, {hasSubset = false, dungeonData = dungeonData})
            -- DECOMPILER ERROR at PC79: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC79: LeaveBlock: unexpected jumping out IF_ELSE_STMT

            -- DECOMPILER ERROR at PC79: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC79: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC79: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
  end
  ;
  (self.subTitlePool):HideAll()
  self.subTitleDic = {}
  local subTitleIdList = (ConfigData.material_dungeon).subTitleIdList
  for k,v in ipairs(toggleDataList) do
    do
      -- DECOMPILER ERROR at PC103: Unhandled construct in 'MakeBoolean' P1

      if v.hasSubset and subDungeonDataDic[v.subTtielId] ~= nil then
        local subTitleItem = (self.subTitlePool):GetOne()
        subTitleItem:SetSubTitleInfo((ConfigData.dungeonSubInfo)[v.subTtielId], self.resLoader, false, self.__SubListShowState)
        subTitleItem:SetMatDgSubTitleLock((v.dungeonDataList)[1])
        -- DECOMPILER ERROR at PC118: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.subTitleDic)[v.subTtielId] = subTitleItem
      end
      do
        local item = (self.dungeonItemPool):GetOne()
        item:InitDungeonItem(v.dungeonData, self.resLoader, self.__onItemClick)
        -- DECOMPILER ERROR at PC130: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self.dungeonItemDic)[v.dungeonData] = item
        -- DECOMPILER ERROR at PC131: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  for key,value in pairs(subDungeonDataDic) do
    local subTitleItem = (self.subTitleDic)[key]
    for _,dungeonData in ipairs(value) do
      local item = (self.smallDungeonItemPool):GetOne()
      item:InitDungeonItem(dungeonData, self.resLoader, self.__onItemClick)
      -- DECOMPILER ERROR at PC152: Confused about usage of register: R16 in 'UnsetPending'

      ;
      (self.dungeonItemDic)[dungeonData] = item
      ;
      (item.transform):SetParent(subTitleItem.transform, false)
      ;
      ((item.transform).gameObject):SetActive(false)
    end
  end
  for subTitleId,subTitleItem in pairs(self.subTitleDic) do
    subTitleItem:RefreshIsMultReward(self.dungeonItemDic)
  end
end

UIATHDungeon.OnSelectItemEvent = function(self, item)
  -- function num : 0_3 , upvalues : _ENV, base
  local saveUserData = PersistentManager:GetDataModel((PersistentConfig.ePackage).UserData)
  saveUserData:SetLastAthDungeonId((item.dungeonData).dungeonId)
  ;
  (base.OnSelectItemEvent)(self, item)
end

UIATHDungeon.InitDungeonStages = function(self, dungeonData)
  -- function num : 0_4 , upvalues : base, UIATHChapterItem, _ENV
  (base.InitDungeonStages)(self, dungeonData, UIATHChapterItem)
  for _,item in ipairs((self.dungeonStageItemPool).listItem) do
    item:SetAthStageClickEvent(self.onChapterItemClick)
    if item == (self.chaptersUI).selectChapterItem then
      (self.onChapterItemClick)(item)
    end
  end
end

UIATHDungeon.ShowDungeonDetail = function(self, item)
  -- function num : 0_5 , upvalues : _ENV, base
  local dungeonCfg = (item.dungeonData):GetDungeonCfg()
  local panelName = (LanguageUtil.GetLocaleText)(dungeonCfg.name_panel)
  if (string.IsNullOrEmpty)(panelName) then
    panelName = (LanguageUtil.GetLocaleText)(dungeonCfg.name)
  end
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_StoryName).text = panelName
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = (LanguageUtil.GetLocaleText)(dungeonCfg.des_info)
  self.double = (item.dungeonData):GetDungeonDoubleWithLimit()
  -- DECOMPILER ERROR at PC35: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).img_StoryBg).texture = item.bannerTexture
  ;
  (base.ShowDungeonDetail)(self, item)
end

UIATHDungeon.EnterFormation = function(self, ...)
  -- function num : 0_6 , upvalues : _ENV, base, cs_MessageCommon
  local EnterFunc = BindCallback(self, base.EnterFormation, ...)
  if (ConfigData.game_config).athMaxNum - (ConfigData.game_config).athSpaceNotEnoughNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
    (cs_MessageCommon.ShowMessageBox)(ConfigData:GetTipContent(145), EnterFunc, nil)
  else
    EnterFunc()
  end
end

UIATHDungeon.__loadExtraShowUI = function(self, stageItem)
  -- function num : 0_7 , upvalues : UIATHDungeon
  self:UpdATHDgFBuffTimes((stageItem.dungeonStageData).dungeonData)
  local dungeonStageCfg = (stageItem.dungeonStageData):GetDungeonStageCfg()
  local extraType = dungeonStageCfg.day_extra_type
  local texIdx = dungeonStageCfg.tex_index
  local extraShow, isEveryDay = UIATHDungeon:GetATHExtraCfgData(dungeonStageCfg.day_extra_show)
  ;
  (self.SuitItemPool):HideAll()
  ;
  (((self.ui).btn_dropAllSuit).gameObject):SetActive(false)
  ;
  (((self.ui).btn_Info).gameObject):SetActive(false)
  if isEveryDay then
    ((self.ui).tex_DropTips):SetIndex(1)
  else
    ;
    ((self.ui).tex_DropTips):SetIndex(0)
  end
  if extraType then
    (((self.ui).btn_Info).gameObject):SetActive(true)
    if #extraShow < 10 then
      for index = 1, #extraShow do
        local item = (self.SuitItemPool):GetOne()
        item:InitATHSuitItem(extraShow[index], self.resLoader)
        item.clickEvent = self.onSuitItemClick
      end
      ;
      (self.suitEffectNode):SetCoulClickThroughGos((self.SuitItemPool).listItem)
      return 
    end
  end
  ;
  (((self.ui).btn_dropAllSuit).gameObject):SetActive(true)
  ;
  ((self.ui).tex_DropAllSuit):SetIndex(texIdx)
end

UIATHDungeon.GetATHExtraCfgData = function(self, cfgShow)
  -- function num : 0_8 , upvalues : _ENV
  local timePassCtrl = ControllerManager:GetController(ControllerTypeId.TimePass, true)
  local weekNum = timePassCtrl:GetLogicWeekNum()
  local list = (string.split)(cfgShow, "|")
  local dataList = {}
  for k,v in ipairs(list) do
    local tmpList = (string.split)(v, "=")
    local wekNum = tonumber(tmpList[1])
    if #tmpList >= 2 and (wekNum == weekNum or wekNum == 0) then
      dataList = (CommonUtil.SplitStrToNumber)(tmpList[2], "_")
      return dataList, wekNum == 0
    end
  end
  error("day_extra_show err this day:" .. weekNum)
  do return dataList, false end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIATHDungeon._onSuitItemClick = function(self, suitItem)
  -- function num : 0_9
  (self.suitEffectNode):InitSuitDetailNode(suitItem.athSuitId, self.resLoader)
  ;
  (self.suitEffectNode):Show()
end

UIATHDungeon._OnClickDropAll = function(self)
  -- function num : 0_10 , upvalues : _ENV
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.ATH_Dungeon_All_Area_Extra_Msg))
end

UIATHDungeon.__OnClickBtnInfo = function(self)
  -- function num : 0_11
  local info = (self.selectDungeonData):GetDungeonDropInfo()
  self:ShowDungeonInfoNode(info, 0)
end

UIATHDungeon.ShowDungeonInfoNode = function(self, infoText, infoTitleIndex)
  -- function num : 0_12
  (self._dungeonInfo):Show()
  ;
  (self._dungeonInfo):InitDungeonInfo(infoText, infoTitleIndex)
end

UIATHDungeon.SubListShowState = function(self, subId, isShowList, isInit)
  -- function num : 0_13 , upvalues : _ENV, CS_LayoutRebuilder
  for key,value in pairs(self.subTitleDic) do
    if key ~= subId then
      value.isShowOpen = false
      value:RefreshState()
    end
  end
  for dungeonData,item in pairs(self.dungeonItemDic) do
    if dungeonData:GetSubTitleId() == subId then
      (item.gameObject):SetActive(isShowList)
    else
      if dungeonData:GetSubTitleId() ~= nil then
        (item.gameObject):SetActive(false)
      end
    end
  end
  if isShowList and not isInit then
    AudioManager:PlayAudioById(1069)
  end
  ;
  (CS_LayoutRebuilder.ForceRebuildLayoutImmediate)(((self.ui).scrollRoll).transform)
end

UIATHDungeon.UpdATHDgFBuffTimes = function(self, dungeonData)
  -- function num : 0_14 , upvalues : _ENV
  local dungeonCfg = dungeonData:GetDungeonCfg()
  local dropId = ((ConfigData.battle_dungeon_period_drop).dgTypeDic)[dungeonCfg.dungeon_type]
  if dropId == nil then
    ((self.ui).obj_btn_BuffTimes):SetActive(false)
    return 
  end
  local dropCfg = (ConfigData.battle_dungeon_period_drop)[dropId]
  ;
  ((self.ui).obj_btn_BuffTimes):SetActive(true)
  local useNum = (ControllerManager:GetController(ControllerTypeId.TimePass)):GetDungeonPeriodDropTimes(dropCfg.save_id)
  local remainNum = dropCfg.drop_times - useNum
  self._dropBuffRemainNum = remainNum
  ;
  ((self.ui).tex_BuffTime):SetIndex(dropCfg.reset_times_point, tostring(remainNum))
  local dropBuffActive = self:GetDgDropBuffActive()
  ;
  (self._dropSwitchTog):InitCommonSwitchToggle(dropBuffActive, self._OnSwitchDropBuffFunc)
end

UIATHDungeon.ShowDropInfo = function(self)
  -- function num : 0_15 , upvalues : _ENV
  local dungeonCfg = (self.selectDungeonData):GetDungeonCfg()
  self:ShowDungeonInfoNode(ConfigData:GetTipContent(dungeonCfg.extra_drop_info), 1)
end

UIATHDungeon._OnClickSwitchDropBuff = function(self, isOn)
  -- function num : 0_16
  if self._dropBuffRemainNum <= 0 then
    return 
  end
  local currentIsOn = self:GetDgDropBuffActive()
  if not currentIsOn then
    self:ShowDropInfo()
  end
  local dungeonCfg = (self.selectDungeonData):GetDungeonCfg()
  self:SetDgDropBuffActive(dungeonCfg.dungeon_type, not currentIsOn)
  ;
  (self._dropSwitchTog):SetCommonSwitchToggleValue(not currentIsOn)
end

UIATHDungeon.ShowAutoDecomposeInfo = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local info = ConfigData:GetTipContent(TipContent.AutoDecompose)
  self:ShowDungeonInfoNode(info, 2)
end

UIATHDungeon._OnClickSwitchDecompose = function(self, isOn)
  -- function num : 0_18
  local currentIsOn = self:GetDecomposeActive()
  if not currentIsOn then
    self:ShowAutoDecomposeInfo()
  end
  self:SetDecomposeActive(not currentIsOn)
  ;
  (self._decomposeTog):SetCommonSwitchToggleValue(not currentIsOn)
end

UIATHDungeon.OnDelete = function(self)
  -- function num : 0_19 , upvalues : base
  (self._dropSwitchTog):Delete()
  ;
  (self._decomposeTog):Delete()
  ;
  (base.OnDelete)(self)
end

return UIATHDungeon

