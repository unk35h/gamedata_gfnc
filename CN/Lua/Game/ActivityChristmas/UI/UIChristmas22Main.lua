-- params : ...
-- function num : 0 , upvalues : _ENV
local UIChristmas22Main = class("UIChristmas22Main", UIBaseWindow)
local base = UIBaseWindow
local ActivityHallowmasEnum = require("Game.ActivityHallowmas.ActivityHallowmasEnum")
local UINChristmasBtn = require("Game.ActivityChristmas.UI.UINChristmasBtn")
local SectorStageDetailHelper = require("Game.Sector.SectorStageDetailHelper")
local ActivityFrameUtil = require("Game.ActivityFrame.ActivityFrameUtil")
local cs_MessageCommon = CS.MessageCommon
local cs_Material = (CS.UnityEngine).Material
local cs_UIParticle = ((CS.Coffee).UIExtensions).UIParticle
local cs_ParticleSystemRenderer = (CS.UnityEngine).ParticleSystemRenderer
local CS_LanguageGlobal = CS.LanguageGlobal
local BtnEnum = {StorySector = 1, Tech = 2, Bonus = 3, GuideSector = 4, Task = 5, Dungeon = 6}
local BtnFuncEnum = {[BtnEnum.StorySector] = "OnClickStorySector", [BtnEnum.Tech] = "OnClickTech", [BtnEnum.Bonus] = "OnClickBonus", [BtnEnum.GuideSector] = "OnClickGuideSector", [BtnEnum.Task] = "OnClickTask", [BtnEnum.Dungeon] = "OnClickDungeon"}
UIChristmas22Main.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, BtnEnum, UINChristmasBtn, BtnFuncEnum
  (UIUtil.SetTopStatus)(self, self.OnCloseChristmas)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_StartListen, self, self.OnClickSeason)
  self:_InitTitleTex()
  if (table.count)(BtnEnum) ~= #(self.ui).array_btnNode then
    if isGameDev then
      error(" btn count error")
    end
    return 
  end
  self._btnNodeDic = {}
  for _,index in pairs(BtnEnum) do
    local go = ((self.ui).array_btnNode)[index]
    local btnNode = (UINChristmasBtn.New)()
    btnNode:Init(go)
    local funcName = BtnFuncEnum[index]
    btnNode:InitChristmasBtn(BindCallback(self, self[funcName]))
    -- DECOMPILER ERROR at PC52: Confused about usage of register: R9 in 'UnsetPending'

    ;
    (self._btnNodeDic)[index] = btnNode
  end
  self.__RefreshCallback = BindCallback(self, self.__Refresh)
  MsgCenter:AddListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  MsgCenter:AddListener(eMsgEventId.WCS_ExitAndClear, self.__RefreshCallback)
end

UIChristmas22Main.InitChristmas22Main = function(self, hallowmasData, enterFunc, backCallback)
  -- function num : 0_1 , upvalues : _ENV
  AudioManager:PlayAudioById(3360)
  self._data = hallowmasData
  self._enterFunc = enterFunc
  self._backCallback = backCallback
  self._cfg = (self._data):GetHallowmasMainCfg()
  self:__Refresh()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._timerId = TimerManager:StartTimer(1, self.__OnTimeDown, self)
  self:__OnTimeDown()
  self._reddot = (self._data):GetActivityReddot()
  if self._reddot ~= nil then
    self._reddotFunc = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener((self._reddot).nodePath, self._reddotFunc)
    self:__RefreshReddot(self._reddot)
  end
  if (self._cfg).guide_id > 0 then
    (UIUtil.SetTopStateInfoFunc)(self, function()
    -- function num : 0_1_0 , upvalues : _ENV, self
    local GuidePicture = require("Game.Guide.GuidePicture.GuidePicture")
    ;
    (GuidePicture.OpenGuidePicture)((self._cfg).guide_id, nil)
  end
)
  end
  local avgid = (self._cfg).first_avg
  if avgid > 0 then
    local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
    local played = avgPlayCtrl:IsAvgPlayed(avgid)
    if not played and (self._data):IsActivityRunning() then
      self:Hide()
      ;
      (ControllerManager:GetController(ControllerTypeId.Avg, true)):StartAvg(nil, avgid, function()
    -- function num : 0_1_1 , upvalues : _ENV, self
    if IsNull(self.transform) then
      return 
    end
    self:Show()
  end
)
      return 
    end
  end
  do
    self:__TryOpenNewUnlock()
  end
end

UIChristmas22Main._InitTitleTex = function(self)
  -- function num : 0_2 , upvalues : CS_LanguageGlobal, _ENV, cs_ParticleSystemRenderer, cs_Material
  local languageInt = (CS_LanguageGlobal.GetLanguageInt)()
  local texture = ((self.ui).titleTexList)[languageInt + 1]
  if IsNull(texture) then
    error((string.format)("christmas22Main title texture %s is null", (CS_LanguageGlobal.GetLanguageStr)()))
    return 
  end
  if self.titleMats ~= nil then
    self:_DestroyMats()
  end
  self.titleMats = {}
  local particleSystemRenderers = (((self.ui).obj_titleFxp).transform):GetComponentsInChildren(typeof(cs_ParticleSystemRenderer))
  for i = 0, particleSystemRenderers.Length - 1 do
    local render = particleSystemRenderers[i]
    local mat = cs_Material(render.material)
    render.material = mat
    ;
    (table.insert)(self.titleMats, mat)
    mat:SetTexture("_MainTex", texture)
  end
end

UIChristmas22Main._DestroyMats = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.titleMats == nil then
    return 
  end
  for _,mat in ipairs(self.titleMats) do
    DestroyUnityObject(mat)
  end
  self.titleMats = nil
end

UIChristmas22Main.__TryOpenNewUnlock = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local actUnlockInfo = (self._data):GetActHallowmasUnlockInfo()
  if actUnlockInfo:IsExistActUnlockInfo() then
    UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Unlock, function(window)
    -- function num : 0_4_0 , upvalues : _ENV, self, actUnlockInfo
    if window == nil then
      return 
    end
    window:Christmas22UnlockBindFunc(BindCallback(self, self.OnClickStorySector), BindCallback(self, self.OnClickSeason), BindCallback(self, self.OnClickDungeon))
    window:InitChristmas22NewUnlock(actUnlockInfo, self._data)
  end
)
  end
end

UIChristmas22Main.EnterChristmas22Sector = function(self, selectSector)
  -- function num : 0_5
  if selectSector == (self._cfg).story_stage then
    self:OnClickStorySector()
  else
    if selectSector == (self._cfg).guide_stage then
      self:OnClickGuideSector()
    end
  end
end

UIChristmas22Main.__OnTimeDown = function(self)
  -- function num : 0_6 , upvalues : _ENV, ActivityFrameUtil
  do
    if self._expireTime == nil or PlayerDataCenter.timestamp < self._expireTime then
      local title, timeStr, expireTime = (ActivityFrameUtil.GetShowEndTimeStr)(self._data)
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).title).text = title
      -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self.ui).tex_Timer).text = timeStr
      self._expireTime = expireTime
    end
    local diffStr, diff = (ActivityFrameUtil.GetCountdownTimeStr)(self._expireTime)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Days).text = diffStr
    if diff <= 0 then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
  end
end

UIChristmas22Main.__Refresh = function(self)
  -- function num : 0_7 , upvalues : _ENV
  ((self.ui).tex_bound_Progress):SetIndex(0, tostring((self._data):GetHallowmasLv()), tostring((self._data):GetHallowmasCurExp()), tostring((self._data):GetHallowmasCurExpLimit()))
  local taskCount = (table.count)((self._data):GetHallowmasDailyTaskIdDic())
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_task_Progress).text = tostring(taskCount) .. "/" .. tostring((self._cfg).task_limit)
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  ;
  ((self.ui).img_ListeningBg):SetActive(isUnComplete)
end

UIChristmas22Main.__RefreshReddot = function(self, reddot)
  -- function num : 0_8 , upvalues : ActivityHallowmasEnum, BtnEnum
  local taskRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).DailyTask)
  local expRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Exp)
  local achievementRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Achievement)
  local sectorAvgRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).SectorAvg)
  local techRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).Tech)
  local techItemRed = reddot:GetChild((ActivityHallowmasEnum.reddotType).TechItemLimit)
  local taskRedCount = taskRed ~= nil and taskRed:GetRedDotCount() or 0
  local expRedCount = expRed ~= nil and expRed:GetRedDotCount() or 0
  local achievementRedCount = achievementRed ~= nil and achievementRed:GetRedDotCount() or 0
  local sectorAvgRedCount = sectorAvgRed ~= nil and sectorAvgRed:GetRedDotCount() or 0
  local techRedCount = techRed ~= nil and techRed:GetRedDotCount() or 0
  local techItemRedCount = techItemRed ~= nil and techItemRed:GetRedDotCount() or 0
  ;
  ((self._btnNodeDic)[BtnEnum.StorySector]):SetChristmasBtnRed(sectorAvgRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Tech]):SetChristmasBtnRed(techRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Tech]):SetChristmasBtnBlue(techRedCount == 0 and techItemRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Bonus]):SetChristmasBtnRed(expRedCount > 0)
  ;
  ((self._btnNodeDic)[BtnEnum.Task]):SetChristmasBtnRed(taskRedCount > 0 or achievementRedCount > 0)
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UIChristmas22Main.OnClickStorySector = function(self)
  -- function num : 0_9 , upvalues : SectorStageDetailHelper, _ENV
  if not (SectorStageDetailHelper.IsSectorNoCollide)((self._cfg).story_stage, true) then
    return 
  end
  if self._enterFunc == nil then
    return 
  end
  ;
  (self._enterFunc)((self._cfg).story_stage, 1, nil, function()
    -- function num : 0_9_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Show()
    end
  end
, function()
    -- function num : 0_9_1 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Hide()
    end
  end
)
end

UIChristmas22Main.OnClickTech = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22StrategyOverview, function(win)
    -- function num : 0_10_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    win:InitChristmas22StrategyOverview((self._data):GetHallowmasTechTree(), (self._cfg).tech_special_branch, function()
      -- function num : 0_10_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Hide()
        self:Show()
      end
    end
)
  end
)
end

UIChristmas22Main.OnClickBonus = function(self)
  -- function num : 0_11 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Bonus, function(win)
    -- function num : 0_11_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    self:Hide()
    win:InitHalloween22Bouns(self._data, function(tohome)
      -- function num : 0_11_0_0 , upvalues : _ENV, self
      if tohome then
        return 
      end
      if not IsNull(self.transform) then
        self:Show()
        self:__TryOpenNewUnlock()
      end
    end
)
  end
)
end

UIChristmas22Main.OnClickGuideSector = function(self)
  -- function num : 0_12 , upvalues : SectorStageDetailHelper, _ENV, cs_MessageCommon
  if not (SectorStageDetailHelper.IsSectorNoCollide)((self._cfg).guide_stage, true) then
    return 
  end
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local tips = ConfigData:GetTipContent((self._cfg).ban_guide_tip)
      ;
      (cs_MessageCommon.ShowMessageTips)(tips)
      return 
    end
    if self._enterFunc == nil then
      return 
    end
    ;
    (self._enterFunc)((self._cfg).guide_stage, 1, nil, function()
    -- function num : 0_12_0 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Show()
    end
  end
, function()
    -- function num : 0_12_1 , upvalues : _ENV, self
    if not IsNull(self.transform) then
      self:Hide()
    end
  end
)
  end
end

UIChristmas22Main.OnClickTask = function(self)
  -- function num : 0_13 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Task, function(win)
    -- function num : 0_13_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    self:Hide()
    win:InitChristmas22Task(self._data, function(tohome)
      -- function num : 0_13_0_0 , upvalues : _ENV, self
      if tohome then
        return 
      end
      if not IsNull(self.transform) then
        self:Show()
        self:__TryOpenNewUnlock()
      end
    end
)
  end
)
end

UIChristmas22Main.OnClickDungeon = function(self)
  -- function num : 0_14 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22Repeat, function(win)
    -- function num : 0_14_0 , upvalues : self, _ENV
    if win == nil then
      return 
    end
    if self.xMasDunCallback then
      (self.xMasDunCallback)()
      self.xMasDunCallback = nil
    end
    win:InitXMas22DunRepeat(self._data, function()
      -- function num : 0_14_0_0 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Show()
      end
    end
, function()
      -- function num : 0_14_0_1 , upvalues : _ENV, self
      if not IsNull(self.transform) then
        self:Hide()
      end
    end
)
  end
)
end

UIChristmas22Main.SetXMasDunSectorCallback = function(self, callback)
  -- function num : 0_15
  self.xMasDunCallback = callback
end

UIChristmas22Main.OnClickSeason = function(self)
  -- function num : 0_16 , upvalues : _ENV, SectorStageDetailHelper
  local isUnComplete = WarChessSeasonManager:GetUncompleteWCSData()
  do
    if isUnComplete then
      local ctrl = ControllerManager:GetController(ControllerTypeId.ActivityHallowmas)
      ctrl:ContinuehallowmasSeason()
      return 
    end
    if not (SectorStageDetailHelper.IsWarchessSeasonNoCollide)((self._cfg).warchess_season_id, true) then
      return 
    end
    UIManager:ShowWindowAsync(UIWindowTypeID.Christmas22ModeSelect, function(window)
    -- function num : 0_16_0 , upvalues : self
    if window == nil then
      return 
    end
    window:InitChristmas22ModeSelect(self._data)
  end
)
  end
end

UIChristmas22Main.OnCloseChristmas = function(self)
  -- function num : 0_17 , upvalues : _ENV
  local sectorCtrl = ControllerManager:GetController(ControllerTypeId.SectorController)
  if sectorCtrl ~= nil then
    sectorCtrl:PlaySectorBgm()
  end
  self:Delete()
  if self._backCallback then
    (self._backCallback)(false)
  end
end

UIChristmas22Main.OnDelete = function(self)
  -- function num : 0_18 , upvalues : _ENV, base
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._reddot ~= nil then
    RedDotController:RemoveListener((self._reddot).nodePath, self._reddotFunc)
    self._reddot = nil
  end
  self:_DestroyMats()
  MsgCenter:RemoveListener(eMsgEventId.ActivityHallowmas, self.__RefreshCallback)
  MsgCenter:RemoveListener(eMsgEventId.WCS_ExitAndClear, self.__RefreshCallback)
  ;
  (base.OnDelete)(self)
end

return UIChristmas22Main

