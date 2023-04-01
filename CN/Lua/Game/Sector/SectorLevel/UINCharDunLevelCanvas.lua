-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCharDunLevelCanvas = class("UINCharDunLevelCanvas", UIBaseNode)
local base = UIBaseNode
local UINLevelCharDunItem = require("Game.Sector.SectorLevel.UINLevelCharDunItem")
UINCharDunLevelCanvas.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINLevelCharDunItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_background, self, self.OnClickBackground)
  self.stagePool = (UIItemPool.New)(UINLevelCharDunItem, (self.ui).uINCharDunStory)
  ;
  ((self.ui).uINCharDunStory):SetActive(false)
  ;
  (((self.ui).switchTween).onComplete):AddListener(BindCallback(self, self.OnSwitchTweenComplete))
  ;
  (((self.ui).switchTween).onRewind):AddListener(BindCallback(self, self.OnSwitchTweenRewind))
  self.__OnClickLevelItemCallback = BindCallback(self, self.OnClickLevelItem)
  self.__OnLevelItemSelectStateCallback = BindCallback(self, self.OnLevelItemSelectState)
end

UINCharDunLevelCanvas.InitDiffLevelCanvas = function(self, sectorId, autoStateCfg, isUnCompleteEp, difficulty, levelItemClickEvent, levelAvgMainClickEvent, lAvgSubClickEvent, tweenCompleteEvent, resLoader, sectorLevelTipsGuides, clickBackFunc)
  -- function num : 0_1
  ((self.ui).obj_Select):SetActive(false)
  self._sectorId = sectorId
  self._difficulty = difficulty
  self._levelItemClickEvent = levelItemClickEvent
  self._tweenCompleteEvent = tweenCompleteEvent
  self._resLoader = resLoader
  self._clickBackFunc = clickBackFunc
  self:__UpdateSectorStageInfo()
  if isUnCompleteEp then
    self:RefreshUncompletedEp(autoStateCfg)
  end
  if autoStateCfg ~= nil then
    self:LocationSectorStageItem(autoStateCfg.id, false)
  end
end

UINCharDunLevelCanvas.SetDungeonListInSector = function(self, dungeonDataDic, clickDungeonItemEvent, blueReddotFunc)
  -- function num : 0_2
end

UINCharDunLevelCanvas.__UpdateSectorStageInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  (self.stagePool):HideAll()
  self.stageItemDic = {}
  local sectorStageCfg = (((ConfigData.sector_stage).sectorDiffDic)[self._sectorId])[self._difficulty]
  for i,stageCfgId in ipairs(sectorStageCfg) do
    local item = (self.stagePool):GetOne()
    if (PlayerDataCenter.sectorStage):IsStageUnlock(stageCfgId) then
      local showBlueDot = not (PlayerDataCenter.sectorStage):IsStageComplete(stageCfgId)
    end
    item:SetBluedot(showBlueDot)
    item:InitCharDunSectorStage(stageCfgId, self.__OnClickLevelItemCallback, self.__OnLevelItemSelectStateCallback, self._resLoader)
    -- DECOMPILER ERROR at PC42: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self.stageItemDic)[stageCfgId] = item
  end
end

UINCharDunLevelCanvas.OnClickBackground = function(self)
  -- function num : 0_4
  if self._clickBackFunc == nil then
    return 
  end
  ;
  ((self.ui).obj_Select):SetActive(false)
  ;
  (self._clickBackFunc)()
end

UINCharDunLevelCanvas.SetBackground = function(self, texture)
  -- function num : 0_5
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).background).texture = texture
end

UINCharDunLevelCanvas.OnSwitchTweenComplete = function(self)
  -- function num : 0_6
  if self.__isBackwardsTween then
    return 
  end
  self:OnSwitchTweenEndEvent()
end

UINCharDunLevelCanvas.OnSwitchTweenRewind = function(self)
  -- function num : 0_7
  if not self.__isBackwardsTween then
    return 
  end
  self.__isBackwardsTween = false
  self:OnSwitchTweenEndEvent()
end

UINCharDunLevelCanvas.OnSwitchTweenEndEvent = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:HideWindow(UIWindowTypeID.ClickContinue)
  ;
  ((self.ui).switchTween):DORewind()
  if self._tweenCompleteEvent ~= nil then
    (self._tweenCompleteEvent)()
  end
end

UINCharDunLevelCanvas.PlayDiffLevelCanvasSwitchTween = function(self, isUpTween)
  -- function num : 0_9 , upvalues : _ENV
  ((self.gameObject).transform):SetAsLastSibling()
  if isUpTween then
    ((self.ui).switchTween):DORestart()
  else
    self.__isBackwardsTween = true
    ;
    ((self.ui).switchTween):DOComplete()
    ;
    ((self.ui).switchTween):DOPlayBackwards()
  end
  local continueWindow = UIManager:ShowWindow(UIWindowTypeID.ClickContinue)
  continueWindow:InitContinue(nil, nil, nil, Color.clear, false)
end

UINCharDunLevelCanvas.SetSectorStageItemBlueDot = function(self, stageId, show)
  -- function num : 0_10
  local item = (self.stageItemDic)[stageId]
  if item ~= nil then
    item:SetBluedot(show)
  end
end

UINCharDunLevelCanvas.SetSectorLAvgMainItemBlueDot = function(self, avgId, show)
  -- function num : 0_11
end

UINCharDunLevelCanvas.PlayDiffLevelContentTween = function(self, duration)
  -- function num : 0_12
end

UINCharDunLevelCanvas.SetSpecialLevelList = function(self, specialLevelList)
  -- function num : 0_13
  self.specialLevelList = specialLevelList
end

UINCharDunLevelCanvas.GetSectorDungeonItem = function(self, dungeonId)
  -- function num : 0_14
  return nil
end

UINCharDunLevelCanvas.RefreshUncompletedEp = function(self, lastEpStateCfg)
  -- function num : 0_15
  if lastEpStateCfg == nil then
    return 
  end
  local item = (self.stageItemDic)[lastEpStateCfg]
  if item == nil then
    return 
  end
  item:RefreshUncompletedEp(true, false)
end

UINCharDunLevelCanvas.RefreshLevelState = function(self)
  -- function num : 0_16 , upvalues : _ENV
  for i,item in ipairs((self.stagePool).listItem) do
    item:RefreshStageUI()
  end
end

UINCharDunLevelCanvas.LocationSectorStageItem = function(self, id, isAvg)
  -- function num : 0_17
  local item = (self.stageItemDic)[id]
  if item == nil then
    return 
  end
  item:SeletedLevelItem(true, false)
  item:OnClickStage()
end

UINCharDunLevelCanvas.GetSectorStageItem = function(self, stageId)
  -- function num : 0_18
  return (self.stageItemDic)[stageId]
end

UINCharDunLevelCanvas.GetSectorLAvgMainItem = function(self, avgId)
  -- function num : 0_19
  return nil
end

UINCharDunLevelCanvas.OnClickLevelItem = function(self, item)
  -- function num : 0_20
  if self._levelItemClickEvent ~= nil then
    (self._levelItemClickEvent)(item)
  end
end

UINCharDunLevelCanvas.OnLevelItemSelectState = function(self, item, flag)
  -- function num : 0_21 , upvalues : _ENV
  if flag then
    ((self.ui).obj_Select):SetActive(true)
    ;
    (((self.ui).obj_Select).transform):SetParent(item.transform)
    -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).obj_Select).transform).localPosition = Vector3.zero
  else
    if (((self.ui).obj_Select).transform).parent == item.transform then
      ((self.ui).obj_Select):SetActive(false)
    end
  end
end

UINCharDunLevelCanvas.OnDelete = function(self)
  -- function num : 0_22 , upvalues : base
  (self.stagePool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINCharDunLevelCanvas

