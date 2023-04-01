-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActWinter23ChapterButtonGroup = class("UINActWinter23ChapterButtonGroup", UIBaseNode)
local base = UIBaseNode
local UINActWinter23ChapterBtn = require("Game.ActivityWinter23.UI.Sector.UINActWinter23ChapterBtn")
local UINActWinter23ChapterButtonList = require("Game.ActivityWinter23.UI.Sector.UINActWinter23ChapterList")
local ActivityWinter23Enum = require("Game.ActivityWinter23.Data.ActivityWinter23Enum")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
UINActWinter23ChapterButtonGroup.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActWinter23ChapterBtn
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_ChapterList, self, self.OnClickOpenFullSelectChapter)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_selectLeft, self, self.OnClickSelectChapterLeft)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_selectRight, self, self.OnClickSelectChapterRight)
  self._switchCallback = BindCallback(self, self.OnClickSwitchBtn)
  self._switchChapterCallback = BindCallback(self, self.SwitchSelectChapter)
  self._switchLevelCallback = BindCallback(self, self.SwitchLevelCallback)
  self.chapterBtnPool = (UIItemPool.New)(UINActWinter23ChapterBtn, (self.ui).btn_chapter)
  ;
  ((self.ui).btn_chapter):SetActive(false)
  self.__RefreshButtonGroupRedDot = BindCallback(self, self.RefreshWin23ChapterButtonGroupUIRedDot)
  MsgCenter:AddListener(eMsgEventId.OnMainLevelStateChange, self.__RefreshButtonGroupRedDot)
end

UINActWinter23ChapterButtonGroup.InitWinter23ChapterButtonGroup = function(self, winter23Data, curSectorId, curChapterId, isRepeat, selectFunc, outDataFunc, resloader)
  -- function num : 0_1 , upvalues : _ENV, UINActWinter23ChapterButtonList, ActivityWinter23Enum
  self.winter23Data = winter23Data
  self.winter23Cfg = winter23Data:GetWinter23Cfg()
  self.selectFunc = selectFunc
  self.outDataFunc = outDataFunc
  self.curSectorId = curSectorId
  self.curChapterId = curChapterId or 1
  self.sectorChapterCfg = (ConfigData.activity_winter23_chapters)[curSectorId]
  self.resloader = resloader
  self.sectorList = {(self.winter23Cfg).normal_sector, (self.winter23Cfg).hard_stage}
  self.chapterList = (UINActWinter23ChapterButtonList.New)()
  ;
  (self.chapterList):Init((self.ui).obj_chapterList)
  self.isRepeat = isRepeat
  self.stageBtn = (self.chapterBtnPool):GetOne()
  if not self.isRepeat or not (ActivityWinter23Enum.levelSelectButtonType).mainButton then
    self:RefreshButtonShow(true, (ActivityWinter23Enum.levelSelectButtonType).repeatButton)
    self.modeBtn = (self.chapterBtnPool):GetOne()
    if self.curSectorId ~= (self.winter23Cfg).normal_sector or not (ActivityWinter23Enum.levelSelectButtonType).normalDiffButton then
      local modeId = (ActivityWinter23Enum.levelSelectButtonType).hardDiffButton
    end
    self:RefreshButtonShow(false, modeId)
    self:RefreshChapterShow()
    if (ControllerManager:GetController(ControllerTypeId.ActivityWinter23)):GetIsFirstEnterMainEp() then
      self:_OpenWinter23LvSwitch()
    end
    self:RefreshChapterObjActive()
  end
end

UINActWinter23ChapterButtonGroup.RefreshChapterObjActive = function(self)
  -- function num : 0_2
  ((self.ui).obj_chapter):SetActive(not self.isRepeat)
end

UINActWinter23ChapterButtonGroup.RefreshButtonShow = function(self, isStage, modeId)
  -- function num : 0_3
  if isStage then
    (self.stageBtn):InitWinter23LvBtn(modeId, self._switchCallback)
  else
    ;
    (self.modeBtn):InitWinter23LvBtn(modeId, self._switchCallback)
  end
end

UINActWinter23ChapterButtonGroup.RefreshChapterShow = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_midNum).text = (string.format)("%02d", self.curChapterId)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_leftNum).text = (string.format)("%02d", self.curChapterId - 1)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_rightNum).text = (string.format)("%02d", self.curChapterId + 1)
  ;
  (((self.ui).btn_selectLeft).gameObject):SetActive(true)
  ;
  (((self.ui).btn_selectRight).gameObject):SetActive(true)
  self:RefreshWin23ChapterButtonGroupUIRedDot()
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R1 in 'UnsetPending'

  if self.curChapterId == 1 then
    ((self.ui).tex_leftNum).text = ""
    ;
    (((self.ui).btn_selectLeft).gameObject):SetActive(false)
  end
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R1 in 'UnsetPending'

  if self.curChapterId == #self.sectorChapterCfg then
    ((self.ui).tex_rightNum).text = ""
    ;
    (((self.ui).btn_selectRight).gameObject):SetActive(false)
  end
end

UINActWinter23ChapterButtonGroup.RefreshWin23ChapterButtonGroupUIRedDot = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self:SetWin23ChapterButtonGroupUIRedDot(false)
  local win23Ctrl = ControllerManager:GetController(ControllerTypeId.ActivityWinter23)
  if win23Ctrl then
    local win23Data = win23Ctrl:GetWinter23Data()
    local chaptersCfg = win23Data:GetChaptersCfg()
    local oldChapterStageIds = ((chaptersCfg[self.curSectorId])[self.curChapterId]).stage_id
    if #oldChapterStageIds > 0 and (PlayerDataCenter.sectorStage):IsStageUnlock(oldChapterStageIds[1]) then
      win23Data:SetWinter23ChapterLooked(self.curChapterId)
    end
    for i,cfg in pairs(chaptersCfg[self.curSectorId]) do
      local isLooked = win23Data:IsWinter23ChapterLooked(cfg.chapter_id)
      local lastChapterCfg = (chaptersCfg[self.curSectorId])[cfg.chapter_id]
      if lastChapterCfg then
        local stageIds = ((chaptersCfg[self.curSectorId])[cfg.chapter_id]).stage_id
        if not isLooked and #stageIds > 0 and (PlayerDataCenter.sectorStage):IsStageUnlock(stageIds[1]) and not (PlayerDataCenter.sectorStage):IsStageComplete(stageIds[1]) then
          self:SetWin23ChapterButtonGroupUIRedDot(true, cfg.chapter_id)
          break
        end
      end
    end
  end
end

UINActWinter23ChapterButtonGroup.SetWin23ChapterButtonGroupUIRedDot = function(self, bool, redIndex)
  -- function num : 0_6
  self.isRedDotOpen = bool
  self.redIndex = redIndex or 0
  ;
  ((self.ui).obj_RightRedDot):SetActive(false)
  ;
  ((self.ui).obj_LeftRedDot):SetActive(false)
  if self.redIndex - self.curChapterId == -1 then
    ((self.ui).obj_LeftRedDot):SetActive(self.isRedDotOpen)
  else
    if self.redIndex - self.curChapterId == 1 then
      ((self.ui).obj_RightRedDot):SetActive(self.isRedDotOpen)
    end
  end
end

UINActWinter23ChapterButtonGroup.RefreshSectorId = function(self, sectorId)
  -- function num : 0_7
  self.curSectorId = sectorId
  self:RefreshSelectBtnState()
end

UINActWinter23ChapterButtonGroup._OpenWinter23LvSwitch = function(self)
  -- function num : 0_8 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Winter23LvSwitch, function(win)
    -- function num : 0_8_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitIActWinter23LvSwitch(self.sectorList, self.curSectorId == (self.sectorList)[1] and 1 or 2, self.resloader, self._switchLevelCallback)
  end
)
end

UINActWinter23ChapterButtonGroup.OnClickSwitchBtn = function(self, modeId)
  -- function num : 0_9 , upvalues : ActivityWinter23Enum
  if modeId == (ActivityWinter23Enum.levelSelectButtonType).repeatButton or modeId == (ActivityWinter23Enum.levelSelectButtonType).mainButton then
    self:_SwitchRepeatMode()
  else
    if modeId == (ActivityWinter23Enum.levelSelectButtonType).normalDiffButton or modeId == (ActivityWinter23Enum.levelSelectButtonType).hardDiffButton then
      self:_OpenWinter23LvSwitch()
    end
  end
end

UINActWinter23ChapterButtonGroup.SwitchLevelCallback = function(self, levelIndex)
  -- function num : 0_10 , upvalues : SectorStageDetailHelper, _ENV, ActivityWinter23Enum
  if not (SectorStageDetailHelper.IsSectorNoCollide)(levelIndex, true) then
    return 
  end
  self.curSectorId = levelIndex
  ;
  (ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)):ChangeWinter23MainEpSector(levelIndex, self.curChapterId)
  local modeId = nil
  if levelIndex == (self.winter23Cfg).normal_sector then
    modeId = (ActivityWinter23Enum.levelSelectButtonType).normalDiffButton
  else
    modeId = (ActivityWinter23Enum.levelSelectButtonType).hardDiffButton
  end
  self:RefreshButtonShow(false, modeId)
end

UINActWinter23ChapterButtonGroup._SwitchRepeatMode = function(self)
  -- function num : 0_11 , upvalues : _ENV, ActivityWinter23Enum
  self.isRepeat = (ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)):ChangeWinter23MainEpRepeat(self.curChapterId)
  local modeId = nil
  if self.isRepeat then
    modeId = (ActivityWinter23Enum.levelSelectButtonType).mainButton
    ;
    ((self.ui).ani_chapter):Play("UI_Winter23ChapterButtonGroupChapterOut")
    local aniClip = ((self.ui).ani_chapter):GetClip("UI_Winter23ChapterButtonGroupChapterOut")
    local aniTime = 0
    if aniClip then
      aniTime = aniClip.length
    end
    if self.outChapterTimer then
      TimerManager:StopTimer(self.outChapterTimer)
      self.outChapterTimer = nil
    end
    self.outChapterTimer = TimerManager:StartTimer(aniTime, function()
    -- function num : 0_11_0 , upvalues : self
    self:RefreshChapterObjActive()
  end
, nil, true)
  else
    do
      modeId = (ActivityWinter23Enum.levelSelectButtonType).repeatButton
      self:RefreshChapterObjActive()
      self:RefreshButtonShow(true, modeId)
    end
  end
end

UINActWinter23ChapterButtonGroup.OnClickOpenFullSelectChapter = function(self)
  -- function num : 0_12
  (self.chapterList):Show()
  ;
  (self.chapterList):InitWinter23ChapterList(self.sectorChapterCfg, self.curChapterId, self._switchChapterCallback)
  ;
  (self.chapterList):SetRedDotStart(self.isRedDotOpen, self.redIndex)
end

UINActWinter23ChapterButtonGroup.OnClickSelectChapterLeft = function(self)
  -- function num : 0_13 , upvalues : _ENV
  if self.curChapterId == 1 then
    return 
  end
  self.curChapterId = self.curChapterId - 1
  self:RefreshChapterShow()
  ;
  (ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)):ChangeWinter23MainEpChapter(self.curChapterId)
end

UINActWinter23ChapterButtonGroup.RefreshSelectChapter = function(self, selectId)
  -- function num : 0_14
end

UINActWinter23ChapterButtonGroup.OnClickSelectChapterRight = function(self)
  -- function num : 0_15 , upvalues : _ENV
  if self.curChapterId == #self.sectorChapterCfg then
    return 
  end
  self.curChapterId = self.curChapterId + 1
  self:RefreshChapterShow()
  ;
  (ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)):ChangeWinter23MainEpChapter(self.curChapterId)
end

UINActWinter23ChapterButtonGroup.SwitchSelectChapter = function(self, index)
  -- function num : 0_16 , upvalues : _ENV
  (self.chapterList):Hide()
  if self.curChapterId == index then
    return 
  end
  self.curChapterId = index
  self:RefreshChapterShow()
  ;
  (ControllerManager:GetController(ControllerTypeId.ActivityWinter23, true)):ChangeWinter23MainEpChapter(self.curChapterId)
end

UINActWinter23ChapterButtonGroup.OnDelete = function(self)
  -- function num : 0_17 , upvalues : base, _ENV
  (base.OnDelete)(self)
  MsgCenter:RemoveListener(eMsgEventId.OnMainLevelStateChange, self.__RefreshButtonGroupRedDot)
  if self.outChapterTimer then
    TimerManager:StopTimer(self.outChapterTimer)
    self.outChapterTimer = nil
  end
end

return UINActWinter23ChapterButtonGroup

